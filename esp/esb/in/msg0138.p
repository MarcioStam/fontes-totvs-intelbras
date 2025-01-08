CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

DEFINE VARIABLE h-msg138a              AS HANDLE      NO-UNDO.
DEFINE VARIABLE p-indice-financiamento AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-icms           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-desc-icms      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-valor-item          AS DECIMAL     NO-UNDO.

{esp/esb/in/msg0138.i}

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEF TEMP-TABLE tt-erro-aux LIKE tt-erro.

DEFINE DATASET mensagem FOR cabecalho, conteudo, msg0138, ProdutosItens, ProdutoItem
   DATA-RELATION FOR conteudo, msg0138          RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0138, ProdutosItens     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ProdutosItens, ProdutoItem RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('longchar', iXML, 'empty', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0138r, ProdutosItensR, ProdutoItemR, resultado
   DATA-RELATION FOR conteudor, msg0138r          RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0138r, ProdutosItensR     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR ProdutosItensR, ProdutoItemR RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0138r, resultado          RELATION-FIELDS (idm, idm) NESTED.

FIND msg0138.

CREATE cabecalhor.
FIND cabecalho.
BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor .
ASSIGN cabecalhor.CodigoMensagem = 'MSG0138R1'.

CREATE conteudor.
CREATE resultado.
CREATE msg0138r.
CREATE ProdutosItensR.

blk_principal:
DO TRANSACTION
ON ERROR UNDO blk_principal,LEAVE blk_principal
ON STOP  UNDO blk_principal,LEAVE blk_principal:

    IF NOT VALID-HANDLE (h-msg138a) THEN
        RUN esp/esb/in/msg0138a.p PERSISTENT SET h-msg138a.

    RUN pi-calc-juros IN h-msg138a (INPUT  msg0138.CondicaoPagamento,
                                    OUTPUT p-indice-financiamento,
                                    OUTPUT TABLE tt-erro).

    IF RETURN-VALUE = "NOK":U THEN
        UNDO blk_principal, LEAVE blk_principal.
    
    FOR EACH ProdutoItem
        BREAK BY ProdutoItem.CodigoProduto:

        FOR EACH tt-erro-aux: DELETE tt-erro-aux. END.

        RUN pi-calcula-icms IN h-msg138a (INPUT  msg0138.Conta,
                                          INPUT  ProdutoItem.Estabelecimento,
                                          INPUT  ProdutoItem.CodigoProduto,
                                          OUTPUT de-perc-icms,
                                          OUTPUT de-perc-desc-icms,
                                          OUTPUT TABLE tt-erro-aux).

        FOR EACH tt-erro-aux:
            IF tt-erro-aux.mensagem = 'Erro Item' THEN DO:
               FIND FIRST tt-erro WHERE SUBSTRING(tt-erro.mensagem,1,9) = 'Erro Item' NO-ERROR.

               IF NOT AVAIL tt-erro THEN DO:
                  CREATE tt-erro.
                  ASSIGN tt-erro.mensagem = 'Erro Item: '.
               END.                      

               IF INDEX(tt-erro.mensagem,ProdutoItem.CodigoProduto) = 0 THEN
                  ASSIGN tt-erro.mensagem = tt-erro.mensagem + ProdutoItem.CodigoProduto + ';'.
            END.
        END.    

        IF LAST(ProdutoItem.CodigoProduto) THEN DO:

           FIND FIRST tt-erro WHERE SUBSTRING(tt-erro.mensagem,1,9) = 'Erro Item' NO-ERROR.

           IF AVAIL tt-erro THEN DO:
              ASSIGN tt-erro.mensagem = tt-erro.mensagem + "  Natureza de opera‡Æo nÆo encontrada para este Estabelecimento x Cliente x Comercio/Industria, Verifique com GRUPO.TRIBUTARIO - escdp015".
           END.                                                                                                                                                                                         
        END.


        IF OPSYS = "UNIX" THEN log-manager:write-message("Eckel22 " + RETURN-VALUE).
        CREATE ProdutoItemR.
        ASSIGN ProdutoItemR.CodigoProduto = ProdutoItem.CodigoProduto.

        IF RETURN-VALUE = "NOK":U THEN  
           ASSIGN ProdutoItemR.PrecoLiquido  = 0.
        ELSE DO:   
            
            IF OPSYS = "UNIX" THEN log-manager:write-message("Eckel1 - MS " + ProdutoItem.CodigoProduto + " preco =  " + string(ProdutoItem.PrecoUnitario) + " de-perc-icms " + STRING(de-perc-icms) + " de-perc-desc-icms " + string(de-perc-desc-icms)).


            IF  de-perc-desc-icms > 0 THEN DO:
                ASSIGN de-perc-desc-icms = ((100 - de-perc-desc-icms) / 100)
                       ProdutoItem.PrecoUnitario  = round(ProdutoItem.PrecoUnitario / de-perc-desc-icms,4).
                IF OPSYS = "UNIX" THEN log-manager:write-message("Dentro calculo icms " + string(ProdutoItem.PrecoUnitario)).
            END.
            
            RUN esp/pdp/espdp098.p(INPUT msg0138.conta,
                                   INPUT ProdutoItem.Estabelecimento,
                                   INPUT ProdutoItem.CodigoProduto,
                                   INPUT ProdutoItem.PrecoUnitario,
                                   INPUT de-perc-icms,
                                   INPUT p-indice-financiamento,
                                   OUTPUT de-valor-item ).

            IF de-valor-item = 0 then 
               ASSIGN ProdutoItemR.PrecoLiquido  = round((ProdutoItem.PrecoUnitario / ((100 - de-perc-icms) / 100)) * p-indice-financiamento,4).
            ELSE
                ASSIGN ProdutoItemR.PrecoLiquido = de-valor-item.
                   
            ASSIGN ProdutoItemR.AliquotaICMS  = round(de-perc-icms,2).

            IF OPSYS = "UNIX" THEN log-manager:write-message("Eckel2 - MS " + string(ProdutoItemR.PrecoLiquido)).

        END.
/*             UNDO blk_principal, LEAVE blk_principal. */
  
    END.
    DELETE PROCEDURE h-msg138a.
END.

IF CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".
    FOR EACH tt-erro:
        IF tt-erro.mensagem = ? THEN
            ASSIGN tt-erro.mensagem = "".
        ASSIGN resultado.Mensagem = resultado.Mensagem +  tt-erro.mensagem + ";".
    END.
END.


DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

RETURN.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.


/*
PROCEDURE pi-config-imposto:

    DEFINE INPUT PARAM  pConta     AS CHAR NO-UNDO.
    DEFINE INPUT PARAM  pEstab     AS CHAR NO-UNDO.
    DEFINE INPUT PARAM  pItem      LIKE ITEM.it-codigo NO-UNDO.
    DEFINE INPUT PARAM  pPrecoUnit AS DEC NO-UNDO.
    DEFINE INPUT PARAM  pPercIcms  AS DEC NO-UNDO.
    DEFINE INPUT PARAM  pIndice    AS DEC NO-UNDO.
    DEFINE OUTPUT PARAM pPreco     AS DEC INIT 0 NO-UNDO.

    find first int-emitente 
         where int-emitente.cod-guid = pConta no-lock no-error.
    find first emitente 
         where emitente.cod-emitente = int-emitente.cod-emitente no-lock no-error.
    
    /*ESTADOS que devem ser desconsideradas*/
    FIND first ponto-programa
         WHERE ponto-programa.nome-programa = "msg0138":U
           AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.
    IF AVAIL ponto-programa THEN DO:
       FIND FIRST conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
              and ENTRY(1,conteudo-programa.conteudo) = pEstab
              and ENTRY(2,conteudo-programa.conteudo) = emitente.estado NO-ERROR.

            IF OPSYS = "UNIX" THEN log-manager:write-message("config-tributos msg0138 -> ponto1").
         
            FIND FIRST ct-clas-item
                 WHERE ct-clas-item.cod-item = pItem  no-lock NO-ERROR.
            if avail ct-clas-item then 
               FIND FIRST ct-clas-fis
                    WHERE ct-clas-fis.cod-clas-fis = ct-clas-item.cod-clas-fis
                      and ct-clas-fis.idi-tip-clas = 1 no-error.
               if avail ct-clas-fis then 
                  find first ct-trib-clas-fisc
                       where ct-trib-clas-fisc.cod-clas-fis = ct-clas-fis.cod-clas-fis no-error.
               if avail ct-trib-clas-fisc then 
                  find first ct-configur-trib
                       where ct-configur-trib.cod-configur-trib = ct-trib-clas-fisc.cod-configur-trib no-error.
                  if avail ct-configur-trib then 
                     find first ct-formul
                          where ct-formul.cod-formul = ct-configur-trib.cod-formul-base-calc.

               IF OPSYS = "UNIX" THEN log-manager:write-message("config-tributos msg0138 -> ponto2").
         
               if ct-configur-trib.cod-tip-trib = 'ICMS' and avail ct-formul and ct-formul.val-perc-reduc > 0 then DO:

                     // IF OPSYS = "UNIX" THEN log-manager:write-message("config-tributos msg0138 -> " + string(ct-formul.val-perc-reduc)).

                     assign pPreco = round(pPrecoUnit / (1 - (1 * ((pPercIcms / 100) *  (1 - (ct-formul.val-perc-reduc / 100))))) * pIndice,4).

                     //IF OPSYS = "UNIX" THEN log-manager:write-message("config-tributos msg0138 -> ProdutoItemR.PrecoLiquido -> " + string(ProdutoItemR.PrecoLiquido)).
               END.
         
    END.
    /*If ProdutoItemR.PrecoLiquido = 0 then 
        ASSIGN ProdutoItemR.PrecoLiquido  = round((ProdutoItem.PrecoUnitario / ((100 - de-perc-icms) / 100)) * p-indice-financiamento,4) */


END PROCEDURE.

*/
