{esp/cep/escep050.i}

PROCEDURE pi-carrega-dados:
    def  input param pi-cod-estabel  as char no-undo.
    DEF  INPUT PARAM p-it-codigo     LIKE ITEM.it-codigo.
    DEF  INPUT PARAM p-cod-depos-ini LIKE deposito.cod-depos.
    DEF  INPUT PARAM p-cod-depos-fim LIKE deposito.cod-depos.
    DEF  INPUT PARAM p-tipo          AS INT.
    DEF OUTPUT PARAM c-descricao    AS CHARACTER FORMAT "x(40)".
    DEF OUTPUT PARAM c-cod-localiz  AS CHARACTER FORMAT "x(30)".
    DEF OUTPUT PARAM de-quantidade  AS DECIMAL FORMAT "->>,>>>,>>9.99".
    DEF OUTPUT PARAM de-saldo       AS DECIMAL FORMAT "->>,>>>,>>9.99".
    DEF OUTPUT PARAM de-saldo-rec   AS DECIMAL FORMAT "->>,>>>,>>9.99".
    DEF OUTPUT PARAM i-saldo-alm    AS DECIMAL FORMAT "->>,>>>,>>9.99".
    DEF OUTPUT PARAM TABLE FOR tt-aes.
    DEF OUTPUT PARAM TABLE FOR tt-saldo.

    EMPTY TEMP-TABLE tt-aes.
    EMPTY TEMP-TABLE tt-saldo.

    ASSIGN de-quantidade = 0
           i-saldo-alm   = 0.    


    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.
    IF NOT AVAIL ITEM THEN
        RETURN "Item nÆo cadastrado. Favor informar um item v lido.".

    ASSIGN c-descricao   = ITEM.desc-item
           c-cod-localiz = ITEM.cod-localiz.

    IF p-tipo = 1 then do:
         for each ae-item no-lock
            where ae-item.cod-estabel = pi-cod-estabel
            and   ae-item.it-codigo  = p-it-codigo     
            and   ae-item.situacao   = NO 
            and   ae-item.cod-depos >= p-cod-depos-ini
            and   ae-item.cod-depos <= p-cod-depos-fim
          break by ae-item.data
                by ae-item.localizacao:

               create tt-aes.
               assign tt-aes.nr-ae       = ae-item.nr-ae
                      tt-aes.sequencia   = ae-item.sequencia
                      tt-aes.quantidade  = ae-item.quantidade
                      tt-aes.data        = ae-item.data
                      tt-aes.localizacao = ae-item.localizacao
                      tt-aes.cod-depos   = ae-item.cod-depos
                      tt-aes.roteiro     = ae-item.roteiro
                      tt-aes.it-codigo   = ae-item.it-codigo.
               assign de-quantidade = de-quantidade + ae-item.quantidade.
         end.
    end.
    else do:
         for each ae-item no-lock
            where ae-item.cod-estabel = pi-cod-estabel
            and   ae-item.it-codigo  = p-it-codigo     
            and   ae-item.situacao   = NO 
            and   ae-item.cod-depos >= p-cod-depos-ini
            and   ae-item.cod-depos <= p-cod-depos-fim
            break by ae-item.nr-ae
                    by ae-item.localizacao:

               if first-of(ae-item.localizacao) then do:
                    create tt-aes.
                    assign tt-aes.nr-ae         = ae-item.nr-ae
                           tt-aes.data          = ae-item.data
                           tt-aes.localizacao   = ae-item.localizacao
                           tt-aes.cod-depos     = ae-item.cod-depos
                           tt-aes.roteiro       = ae-item.roteiro.
               end.

               assign tt-aes.quantidade = tt-aes.quantidade + 1
                      de-quantidade     = de-quantidade     + 1.
         end.
    end.

    ASSIGN de-saldo = 0
           de-saldo-rec = 0.

    FOR EACH saldo-estoq NO-LOCK
       WHERE saldo-estoq.it-codigo    = p-it-codigo
         and saldo-estoq.cod-estabel  = pi-cod-estabel
         AND saldo-estoq.qtidade-atu <> 0:

        CREATE tt-saldo.
        ASSIGN tt-saldo.cod-depos     = saldo-estoq.cod-depos   
               tt-saldo.cod-localiz   = saldo-estoq.cod-localiz 
               tt-saldo.quantidade    = (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada).

        CASE saldo-estoq.cod-depos:
            WHEN "alm" THEN ASSIGN de-saldo     = de-saldo     + saldo-estoq.qtidade-atu. 
            WHEN "rec" THEN ASSIGN de-saldo-rec = de-saldo-rec + saldo-estoq.qtidade-atu.
        END CASE.

        IF  saldo-estoq.cod-depos >= p-cod-depos-ini
        AND saldo-estoq.cod-depos <= p-cod-depos-fim THEN
            ASSIGN i-saldo-alm = i-saldo-alm + (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada).    
    END.
END.

PROCEDURE pi-carrega-ficha:
    DEF  INPUT PARAM p-nr-ficha       LIKE ficha-cq.nr-ficha NO-UNDO.
    DEF OUTPUT PARAM p-cod-emitente   LIKE ficha-cq.cod-emitente NO-UNDO.
    DEF OUTPUT PARAM p-nome-emit      LIKE emitente.nome-emit NO-UNDO.
    DEF OUTPUT PARAM p-nro-docto      LIKE ficha-cq.nro-docto NO-UNDO.
    DEF OUTPUT PARAM p-serie-docto    LIKE ficha-cq.serie NO-UNDO.
    DEF OUTPUT PARAM p-nat-operacao   LIKE ficha-cq.nat-operacao NO-UNDO.
    DEF OUTPUT PARAM p-dt-emissao     LIKE ficha-cq.dt-ficha NO-UNDO.
    DEF OUTPUT PARAM p-it-codigo      LIKE ficha-cq.it-codigo NO-UNDO.
    DEF OUTPUT PARAM p-desc-item      LIKE item.desc-item NO-UNDO.
    DEF OUTPUT PARAM p-narrativa      AS CHARACTER NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-ficha-cq.

    DEFINE VARIABLE i-total AS INTEGER     NO-UNDO.

    find ficha-cq no-lock 
         where ficha-cq.nr-ficha = p-nr-ficha no-error.
    IF NOT AVAIL ficha-cq THEN
        RETURN "Erro na ficha da AE. Verifique com Almoxarifado".

    find emitente no-lock 
         where emitente.cod-emitente = ficha-cq.cod-emitente no-error.

    find item no-lock 
         where item.it-codigo = ficha-cq.it-codigo no-error.

    find docum-est no-lock 
         where docum-est.cod-emitente = ficha-cq.cod-emitente  
         AND   docum-est.serie-docto  = ficha-cq.serie   
         AND   docum-est.nro-docto    = ficha-cq.nro-docto     
         AND   docum-est.nat-operacao = ficha-cq.nat-operacao no-error.

    assign i-total = 0
           p-cod-emitente   = ficha-cq.cod-emitente
           p-nome-emit      = emitente.nome-emit
           p-nro-docto      = ficha-cq.nro-docto
           p-serie-docto    = ficha-cq.serie
           p-nat-operacao   = ficha-cq.nat-operacao
           p-dt-emissao     = ficha-cq.dt-ficha
           p-it-codigo      = ficha-cq.it-codigo 
           p-desc-item      = item.desc-item.

    for each ficha-cq no-lock
       where ficha-cq.serie-docto  = p-serie-docto
       and   ficha-cq.nro-docto    = p-nro-docto
       and   ficha-cq.cod-emitente = p-cod-emitente
       and   ficha-cq.nat-operacao = p-nat-operacao
       and   ficha-cq.it-codigo    = p-it-codigo
       by    ficha-cq.nr-ficha:

        ASSIGN i-total = i-total + ficha-cq.qt-original.

        CREATE tt-ficha-cq.
        ASSIGN tt-ficha-cq.nr-ficha     = ficha-cq.nr-ficha
               tt-ficha-cq.qt-original  = ficha-cq.qt-original
               tt-ficha-cq.qt-aprovada  = ficha-cq.qt-aprovada
               tt-ficha-cq.qt-rejeitada = ficha-cq.qt-rejeitada
               tt-ficha-cq.qt-apr-cond  = ficha-cq.qt-apr-cond
               tt-ficha-cq.dt-inspecao  = ficha-cq.dt-inspecao
               tt-ficha-cq.narrativa    = ficha-cq.narrativa.
    end.

    FIND FIRST tt-ficha-cq NO-ERROR.
    ASSIGN p-narrativa = IF AVAIL tt-ficha-cq THEN tt-ficha-cq.narrativa ELSE "".

END PROCEDURE.

PROCEDURE pi-retorna-estab-usuario:
    DEFINE  INPUT PARAMETER p-cod-usuario AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-estab   AS CHARACTER NO-UNDO.

    FIND FIRST usuar_univ NO-LOCK
         WHERE usuar_univ.cod_usuario = p-cod-usuario NO-ERROR.
    IF AVAIL usuar_univ THEN
        ASSIGN p-cod-estab = usuar_univ.cod_estab.
    ELSE
        ASSIGN p-cod-estab = "101".
END PROCEDURE.
