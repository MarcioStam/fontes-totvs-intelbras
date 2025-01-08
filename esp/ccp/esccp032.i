
/******************************************************************************
***
**  Include: CD0420.i - C lculo de Simula‡Æo de Estoque
**
*****************************************************************************/

procedure pi-simulacao.

    def param buffer b-item for item.
    def input parameter l-item-pai as logical no-undo.
    &IF defined(bf_man_206b) &THEN
        def input parameter l-usa-unid-negoc as logical no-undo.
    &ENDIF
    def var c-saldo as char format "x(5)" no-undo.
    def var l-sald-terc as logical init yes no-undo.
    DEFINE VARIABLE de-saldo-aux AS DECIMAL     NO-UNDO.
    {cdp/cdcfgman.i}

    FOR EACH tt-itens-excluir:
        DELETE tt-itens-excluir.
    END.

    assign c-descricao        = b-item.desc-item
           de-saldo-inic      = 0
           de-saldo-terc      = 0
           de-saldo-inic-teor = 0
           de-saldo-terc-teor = 0
           l-imprimiu         = no
           l-sald-est         = tt-param.l-sld-est
           l-remessa-con      = tt-param.l-re-con                                                                      
           l-ent-con          = tt-param.l-en-con
           da-dt-corte        = tt-param.da-corte
           da-op-corte        = tt-param.da-op-corte
           l-ord-comp         = tt-param.l-ord-com
           l-res-comp         = tt-param.l-res-com
           l-pedidos          = tt-param.l-ped-crt
           l-res-plan         = tt-param.l-res-pla
           l-sld-ter          = tt-param.l-sld-ter
           c-plan-ini         = tt-param.c-plan-ini
           c-plan-fim         = tt-param.c-plan-fim
           i-nr-linha-ini     = tt-param.i-linha-ini
           i-nr-linha-fim     = tt-param.i-linha-fim
           &IF defined(bf_man_206b) &THEN
           c-un-neg-ini       = tt-param.c-cod-unid-negoc-ini
           c-un-neg-fim       = tt-param.c-cod-unid-negoc-fim
           &ENDIF
           .

    /*     {cdp/cd0284.i b-item} */
    RUN pi-simulacao-estoque (BUFFER b-item,
                              INPUT  l-sald-est,
                              INPUT  l-remessa,
                              INPUT  l-entrada,
                              INPUT  l-transfer,
                              INPUT  l-remessa-con, 
                              INPUT  l-ent-con,
                              INPUT  c-plan-ini,
                              INPUT  c-plan-fim,
                              INPUT  i-nr-linha-ini,
                              INPUT  i-nr-linha-fim,
                              INPUT  l-sald-terc,
                              INPUT  c-estab-ini,
                              INPUT  c-estab-fim,
                              INPUT  l-ord-prod,
                              INPUT  i-benefic,
                              INPUT  l-cred-aprov,
                              INPUT  l-planejada,
                              INPUT  l-res-plan,
                              INPUT  i-cod-plano
                              &IF defined(bf_man_206b) &THEN
                                 ,INPUT c-un-neg-ini,
                                  INPUT c-un-neg-fim
                              &ENDIF
                              ).
    
    find first tt-estoq
         where tt-estoq.tipo <> "" no-lock no-error.
    if  tt-param.l-it-sem-mov
    or (tt-param.l-it-sem-mov = no and avail tt-estoq) then do:

        if tt-param.l-componente AND l-item-pai then 
            PUT SKIP.

        assign l-lista    = no
               l-zero     = no
               l-seg      = no
               c-tipo-ant = string(tt-param.i-tipo).

        repeat while l-lista = no:
            &IF defined(bf_man_205) &THEN
            IF param-globa.modulo-per-ppm AND 
               b-item.tipo-formula >= 2   AND 
               b-item.tipo-formula <= 3 THEN
                assign de-saldo     = de-saldo-inic-teor
                       de-saldo-aux = de-saldo-inic-teor.
            ELSE
            &ENDIF
                assign de-saldo     = de-saldo-inic
                       de-saldo-aux = de-saldo-inic.
            assign l-zero    = no
                   l-seg     = no.

            if c-tipo-ant = "4" then do:
                for each  tt-estoq no-lock
                    where tt-estoq.tipo <> ""
                    by    tt-estoq.dt-termino
                    by    tt-estoq.tipo:
    
                    if  tt-estoq.tipo = c-liter[5]
                    or  tt-estoq.tipo = c-liter[6]
                    or  tt-estoq.tipo = c-liter[8] then
                        assign de-saldo-aux      = de-saldo-aux - tt-estoq.quantidade.
                    else
                        assign de-saldo-aux = de-saldo-aux + if tt-estoq.tipo <> c-liter[2] then
                                                                tt-estoq.quantidade else 0.
                END.
                if  de-saldo-aux <= 0 THEN DO:
                        CREATE tt-itens-excluir.
                        ASSIGN tt-itens-excluir.it-codigo = b-item.it-codigo
                               de-saldo                   = de-saldo-aux.
                END.
            END.
            IF c-tipo-ant <> "4" or
               (c-tipo-ant = "4"  AND
                NOT CAN-FIND(FIRST tt-itens-excluir WHERE tt-itens-excluir.it-codigo = b-item.it-codigo)) THEN
                
                blk-estoq:
                for each  tt-estoq no-lock
                    where tt-estoq.tipo <> ""
                    by    tt-estoq.dt-termino
                    by    tt-estoq.tipo:
              
                    if l-imprimiu = no then
                       if line-counter >= 62 then
                           page.
              
                    if  tt-estoq.tipo = c-liter[5]
                    or  tt-estoq.tipo = c-liter[6]
                    or  tt-estoq.tipo = c-liter[8] then
                        assign de-saldo      = de-saldo - tt-estoq.quantidade
                               de-quantidade = (tt-estoq.quantidade * (-1)).
                    else
                        assign de-saldo      = de-saldo
                                             + if tt-estoq.tipo <> c-liter[2]
                                                  then tt-estoq.quantidade else 0
                               de-quantidade = tt-estoq.quantidade.
              
                    if  de-saldo <= 0 then do:
                        assign c-observ = c-liter[9]
                               l-zero   = yes.
                        if  de-saldo = 0 then do:
                            if  de-saldo < de-quant-segur then do:
                                if  c-tipo-ant = "2" then
                                    assign l-seg = yes.
                                else
                                    assign c-observ = c-liter[10]
                                           l-seg    = yes.
                            end.
                        end.
                        else
                            assign l-seg = yes.
                    end.
                    else
                    if  de-saldo < de-quant-segur then
                        assign c-observ = c-liter[10]
                               l-seg    = yes.
                    else
                        assign c-observ = "".
              
                    if  c-tipo-ant = "2" then do:
                        if  l-zero = no then next.
                        else do:
                            assign c-tipo-ant = "1".
                            leave.
                        end.
                    end.
                    if  c-tipo-ant = "3" then do:
                        if  l-seg = no then next.
                        else do:
                            assign c-tipo-ant = "1".
                            leave.
                        end.
                    end.
                    /*if c-tipo-ant = "4" then do:
 *                         if l-zero then next blk-estoq. /*
 *                         else do:
 *                             assign c-tipo-ant = "1".
 *                             leave.
 *                         end. */
 *                     end.  */
                    assign l-lista = yes.



                       if  line-counter <= 63 then do:
                           if  l-imprimiu = no  then do:
                               if l-ref = no then do:
                                   put b-item.it-codigo
                                       string(de-quant-segur,tt-param.c-formato)     at 18  format "x(16)"
                                       b-item.un                                     at 37
                                       c-cod-refer                                   at 41
                                       c-descricao                                   at 50  FORMAT "x(40)"
                                       string(de-saldo-inic-teor,tt-param.c-formato) at 95  format "x(16)"
                                       string(de-saldo-inic,tt-param.c-formato)      at 111 format "x(16)".
                               end.
                               else do:
                                   put string(de-quant-segur,tt-param.c-formato)     at 18  format "x(16)"
                                       c-cod-refer                                   at 41
                                       string(de-saldo-inic-teor,tt-param.c-formato) at 95  format "x(16)"
                                       string(de-saldo-inic,tt-param.c-formato)      at 111 format "x(16)".
                               end.
                           end.
                           put tt-estoq.tipo                            at 6    format "x(4)"
                               tt-estoq.referencia                      at 15   format "x(36)"
                               string(de-quantidade,tt-param.c-formato) at 56   format "x(16)"
                               tt-estoq.dt-inicio                       at 73   
                               tt-estoq.dt-termino                      at 84   
                               string(de-saldo,tt-param.c-formato)      at 95   format "x(16)"
                               c-observ                                 at 114  format "x(16)".
                               &IF defined(bf_man_206b) &THEN
                                   if l-usa-unid-negoc then do:
                                       RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT  item.cod-estabel,
                                                                                INPUT  item.it-codigo,
                                                                                INPUT  "",
                                                                                OUTPUT c-cod-unid-negoc).
                                       put c-cod-unid-negoc at 130 format "x(3)".  
                                   end.
                               &endif
                       end.
                       ELSE DO:
                           put b-item.it-codigo
                               de-quant-segur                                at 18
                               b-item.un                                     at 37
                               c-cod-refer                                   at 41
                               c-descricao                                   at 50
                               string(de-saldo-inic-teor,tt-param.c-formato) at 95  format "x(16)"
                               string(de-saldo-inic,tt-param.c-formato)      at 111 format "x(16)"
                               tt-estoq.tipo                                 at 6   format "x(4)"
                               tt-estoq.referencia                           at 15
                               string(de-quantidade,tt-param.c-formato)      at 56  format "x(16)"
                               tt-estoq.dt-inicio                            at 73
                               tt-estoq.dt-termino                           at 84
                               string(de-saldo,tt-param.c-formato)           at 95  format "x(16)"
                               c-observ                                      at 114 format "x(16)".
                       END.
                      

                       //IF c-item-impr <> b-item.it-codigo THEN
                          put STREAM str-excel UNFORMATTED 
                              b-item.it-codigo                              ";"
                              c-descricao                                   ";" 
                              de-quant-segur                                ";" 
                              b-item.un                                     ";" 
                              c-cod-refer                                   ";" 
                              tt-estoq.tipo                                 ";" 
                              string(de-saldo-inic,tt-param.c-formato)      ";" .
                              //tt-estoq.referencia                           ";"  NOVO
                              //string(de-saldo-inic-teor,tt-param.c-formato) ";" 
                              //string(de-saldo-inic,tt-param.c-formato)      ";". NOVO
                       /*ELSE
                          put STREAM str-excel UNFORMATTED 
                              ";" ";" ";" ";" ";" ";" ";".  */
                         
                       put STREAM str-excel UNFORMATTED 
                           tt-estoq.referencia                           ";" 
                           string(de-quantidade,tt-param.c-formato)      ";" 
                           tt-estoq.dt-inicio                            ";" 
                           tt-estoq.dt-termino                           ";" 
                           string(de-saldo,tt-param.c-formato)           ";" 
                           c-observ                                      ";".

                       FIND LAST int-acao-criticidade-item NO-LOCK
                           WHERE int-acao-criticidade-item.cod-estabel     = c-estab-ini 
                             AND int-acao-criticidade-item.cd-plano        = tt-param.i-cod-plano         
                             AND int-acao-criticidade-item.it-codigo       = b-item.it-codigo               
                             AND NOT int-acao-criticidade-item.acao-sistema NO-ERROR.  

                       IF AVAIL int-acao-criticidade-item THEN 
                          PUT STREAM str-excel UNFORMATTED 
                              STRING(int-acao-criticidade-item.data-acao) + " - " + replace(replace(int-acao-criticidade-item.comentario-acao,CHR(13),""),CHR(10),"") SKIP.
                       ELSE 
                          PUT STREAM str-excel UNFORMATTED SKIP.

                    
                    ASSIGN c-item-impr = b-item.it-codigo.


                    assign l-imprimiu = yes
                           l-ref      = yes.
                end. /* for each tt-item */

            if  (c-tipo-ant      = "2" and l-zero  = no)
            or  (c-tipo-ant      = "3" and l-seg   = no)
            or  (tt-param.i-tipo = 1   and l-lista = no) then
                assign l-lista = yes.

            if (c-tipo-ant = "4"    and l-zero  = no)
            or (tt-param.i-tipo = 4 and l-lista = no) then
                assign l-lista = yes.

        end. /*repeat */
        
        if  l-imprimiu = no then do:
            if  de-saldo < 0 then do:
                assign c-observ = c-liter[9]
                       l-zero   = yes.
                if  de-saldo = 0 then do:
                    if  de-saldo < de-quant-segur then do:
                        if  c-tipo-ant = "2" then
                            assign l-seg = yes.
                        else
                            assign c-observ = c-liter[10]
                                   l-seg    = yes.
                    end.
                end.
                else
                    assign l-seg = yes.
            end.
            else
                if  de-saldo < de-quant-segur then
                    assign c-observ = c-liter[10]
                           l-seg    = yes.
                else
                    assign c-observ = "".

            {utp/ut-liter.i Saldo * r}
            assign c-saldo = trim(return-value).


            if (c-tipo-ant = "1") or
               (c-tipo-ant = "2" and de-saldo <= 0) or
               (c-tipo-ant = "3" and de-saldo < de-quant-segur) or
               (c-tipo-ant = "4" and de-saldo > 0) THEN DO:
                put b-item.it-codigo
                    string(de-quant-segur,tt-param.c-formato)     at 18  format "x(16)"
                    b-item.un                                     at 37
                    c-cod-refer                                   at 41.
                   &IF defined(bf_man_206b) &THEN
                            if  param-global.modulo-per-ppm = YES then 
                                PUT c-descricao                               at 50 format  "x(40)"
                                string(de-saldo-inic-teor,tt-param.c-formato) at 95  format "x(16)"
                                string(de-saldo,tt-param.c-formato)           at 111 format "x(16)" + " " SKIP.
                            ELSE
                                PUT c-descricao  at 50 format  "x(40)"
                                    /*c-saldo format "x(5)" + ":"*/
                                    string(de-saldo,tt-param.c-formato)   at 111 format "x(16)" + " " SKIP.
                    &else  
                            PUT c-descricao  at 50 format  "x(40)"
                            /* c-saldo format "x(5)" + ":"*/
                            string(de-saldo,tt-param.c-formato)   at 111 format "x(16)" + " " SKIP.
                    &ENDIF 
            END.


/*             if  c-tipo-ant = "2" and de-saldo < 0 then                             */
/*                 put b-item.it-codigo                                               */
/*                     string(de-quant-segur,tt-param.c-formato) at 18 format "x(16)" */
/*                     b-item.un                                    at 37             */
/*                     c-cod-refer                               at 41                */
/*                     c-descricao                               at 50                */
/*                     c-saldo                                   format "x(5)" + ":"  */
/*                     string(de-saldo,tt-param.c-formato)       format "x(16)" + " " */
/*                     c-observ                                                       */
/*                     skip.                                                          */
/*                                                                                    */
/*             if  c-tipo-ant = "3" and de-saldo < de-quant-segur then                */
/*                 put b-item.it-codigo                                               */
/*                     string(de-quant-segur,tt-param.c-formato) at 18 format "x(16)" */
/*                     b-item.un                                 at 37                */
/*                     c-cod-refer                               at 41                */
/*                     c-descricao                               at 50                */
/*                     c-saldo                                   format "x(5)" + ":"  */
/*                     string(de-saldo,tt-param.c-formato)       format "x(16)" + " " */
/*                     c-observ                                                       */
/*                     skip.                                                          */
/*                                                                                    */
/*             if  c-tipo-ant = "4" and de-saldo > 0 then                             */
/*                 put b-item.it-codigo                                               */
/*                     string(de-quant-segur,tt-param.c-formato) at 18 format "x(16)" */
/*                     b-item.un                                 at 37                */
/*                     c-cod-refer                               at 41                */
/*                     c-descricao                               at 50                */
/*                     c-saldo                                   format "x(5)" + ":"  */
/*                     string(de-saldo,tt-param.c-formato)       format "x(16)" + " " */
/*                     c-observ                                                       */
/*                     skip.                                                          */

        end.

        if  line-counter <= 63 and l-imprimiu then put SKIP.

        if tt-param.l-componente
           and l-item-pai then
           run pi-processa-componentes.
    end.
end procedure.


