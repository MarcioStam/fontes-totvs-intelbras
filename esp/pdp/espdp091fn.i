FUNCTION fnEstoque RETURNS DECIMAL
  ( INPUT p-cod-estabel   AS CHAR,
    INPUT p-it-codigo     AS CHAR,
    INPUT p-cod-depos     AS CHAR,
    INPUT p-cod-localiz   AS CHAR,
    INPUT p-saldo-central AS LOG ) :

    
    
/*------------------------------------------------------------------------------
  Purpose:  Retornar o saldo dispo°vel para alocaá∆o do item 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE qtd             AS DECIMAL    NO-UNDO INIT 0.
    DEFINE VARIABLE qtd-alocada    AS DECIMAL    NO-UNDO INIT 0.
    DEFINE VARIABLE c-localizacao  AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE p-qtd-total    LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE p-qtd-disp     LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE p-qtd-bloq     LIKE wm-saldo-estoque.qtd-atual            NO-UNDO.
    DEFINE VARIABLE qtd-atualizada LIKE int-wms-nf-atualiz.qt-baixada NO-UNDO.

    DEFINE BUFFER bf-saldo-estoq-fnEstoque FOR saldo-estoq.
    
    ASSIGN c-localizacao = "".
    
    /*Localizaá‰es que devem ser desconsideradas*/
    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "espdp091":U
          AND ponto-programa.ponto         = 2,
        EACH  conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
          AND ENTRY(1,conteudo-programa.conteudo) = p-cod-depos:
        IF  c-localizacao = "" THEN
            ASSIGN c-localizacao = ENTRY(2,conteudo-programa.conteudo).
        ELSE
            ASSIGN c-localizacao = c-localizacao + "," + ENTRY(2,conteudo-programa.conteudo).
    END.
    
    FIND FIRST item-uni-estab USE-INDEX codigo NO-LOCK 
         WHERE item-uni-estab.it-codigo   = p-it-codigo
           AND item-uni-estab.cod-estabel = p-cod-estabel
           AND item-uni-estab.nr-linha    = 20 NO-ERROR.
    
    IF  AVAIL item-uni-estab
    AND NOT p-saldo-central THEN DO:
        RUN esapi/esapi011.p (INPUT  p-cod-estabel,
                              INPUT  p-it-codigo,
                              INPUT  p-cod-depos,
                              INPUT  p-cod-localiz,
                              OUTPUT qtd).
    END.
    ELSE DO:
        
        FOR EACH bf-saldo-estoq-fnEstoque NO-LOCK
            WHERE bf-saldo-estoq-fnEstoque.cod-estabel = p-cod-estabel
              AND bf-saldo-estoq-fnEstoque.cod-depos   = p-cod-depos
              AND bf-saldo-estoq-fnEstoque.it-codigo   = p-it-codigo:

            /* Desconsidera as localizaá‰es cadastradas no ES0018 */
            IF  (bf-saldo-estoq-fnEstoque.cod-localiz <> "" OR c-localizacao <> "") 
            AND (LOOKUP(bf-saldo-estoq-fnEstoque.cod-localiz, c-localizacao) > 0) THEN
                NEXT.

            IF  p-cod-localiz <> "*"
            AND bf-saldo-estoq-fnEstoque.cod-localiz <> p-cod-localiz THEN
                NEXT.
            
            FIND FIRST int-saldo-estoq NO-LOCK
                {dbini\es322.i1 int-saldo-estoq bf-saldo-estoq-fnEstoque} NO-ERROR.

            IF  AVAIL int-saldo-estoq 
            AND int-saldo-estoq.log-bloqueado THEN NEXT.

            ASSIGN qtd         = qtd + bf-saldo-estoq-fnEstoque.qtidade-atu - bf-saldo-estoq-fnEstoque.qt-alocada - bf-saldo-estoq-fnEstoque.qt-aloc-prod - bf-saldo-estoq-fnEstoque.qt-aloc-ped
                   qtd-alocada = qtd-alocada + bf-saldo-estoq-fnEstoque.qt-alocada + bf-saldo-estoq-fnEstoque.qt-aloc-ped.
        END.

        /* Validacao MFT x WMS  */
        FIND FIRST deposito 
             WHERE deposito.cod-depos    = p-cod-depos
               AND deposito.log-gera-wms = YES NO-LOCK NO-ERROR.


        IF  AVAIL deposito
        AND NOT AVAIL item-uni-estab THEN DO: /*Central configurada nunca tem saldo no wms, ent∆o considera sempre o saldo cont†bil*/
            EMPTY TEMP-TABLE tt-erro.

            RUN esp/wmp/eswmpapi003.p (INPUT  p-cod-estabel,
                                       INPUT  p-cod-depos,
                                       INPUT  p-it-codigo,
                                       INPUT  "",
                                       OUTPUT p-qtd-total,
                                       OUTPUT p-qtd-disp,
                                       OUTPUT p-qtd-bloq,
                                       OUTPUT TABLE tt-erro).

            FOR EACH tt-erro WHERE tt-erro.cd-erro = 56:
                DELETE tt-erro.
            END. /* FOR EACH tt-erro */

            /* Verifica quantidade atualizada no estoque e que ainda estah pendente de integracao com o WMS */
            ASSIGN qtd-atualizada = 0.
            FOR EACH int-wms-nf-atualiz NO-LOCK
               WHERE int-wms-nf-atualiz.cod-depos   = p-cod-depos
                 AND int-wms-nf-atualiz.it-codigo   = p-it-codigo
                 AND int-wms-nf-atualiz.cod-estabel = p-cod-estabel:

                ASSIGN qtd-atualizada = qtd-atualizada + int-wms-nf-atualiz.qt-baixada.
            END.

            /*Considera o menor entre dispon°vel estoque ou dispon°vel WMS*/
            ASSIGN qtd = IF p-qtd-disp - qtd-alocada - qtd-atualizada < qtd THEN p-qtd-disp - qtd-alocada - qtd-atualizada ELSE qtd.
        END. /* IF AVAIL deposito THEN DO: */
    END.

    IF qtd < 0 THEN
        ASSIGN qtd = 0.

    RETURN qtd.
END.
