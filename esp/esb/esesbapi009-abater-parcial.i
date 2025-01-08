/* Atualizaá‰es no t°tulo vinculado a uma conta corrente que deve estar dispon°vel*/

PROCEDURE pi-atualiza-titulo:

     DEF  INPUT PARAM p-valor              AS DEC NO-UNDO.
     DEF  INPUT PARAM p-desconto-duplicata AS LOG NO-UNDO.
     DEF OUTPUT PARAM TABLE FOR tt-erro.
     DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.
     
     /* ATUALIZAR O CONTAS A PAGAR */
     DEF VAR h-esesb003-apb AS HANDLE NO-UNDO.

     /* N∆o fazer nada no AP caso o ajuste seja negativo e n∆o exista saldo mais no AP */
     FIND FIRST tit_ap NO-LOCK
         WHERE tit_ap.cod_estab     = {1}.cod_estab
           AND tit_ap.num_id_tit_ap = {1}.num_id_tit_ap NO-ERROR.
     
      /* Se o ajustes estiver reduzindo o saldo mas o APB n∆o tiver mais saldo, n∆o deve nem chamar a api */
     IF  AVAIL tit_ap AND tit_ap.val_sdo_tit_ap = 0 THEN DO:
         ASSIGN p-ok = YES.
         RETURN "OK".
     END.

     EMPTY TEMP-TABLE tt-beneficio.

     CREATE tt-beneficio.
     ASSIGN tt-beneficio.tipo-beneficio = {1}.tipo-beneficio
            tt-beneficio.unid-neg       = {1}.unid-neg
            tt-beneficio.cod-estabel    = {1}.cod_estab
            tt-beneficio.perc-custo     = {1}.perc-custo.

     IF  NOT VALID-HANDLE(h-esesb003-apb) THEN
         RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.

     RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT ROWID({1}),
                                                    INPUT p-valor * (- 1) ,
                                                    INPUT NO,
                                                    INPUT TODAY,
                                                    INPUT {1}.dt-periodo-fim,
                                                    INPUT p-desconto-duplicata,
                                                    INPUT TABLE tt-beneficio,
                                                    OUTPUT TABLE tt-erro-apb).

      IF  VALID-HANDLE(h-esesb003-apb) THEN
          DELETE PROCEDURE h-esesb003-apb.

      IF  CAN-FIND (FIRST tt-erro-apb)
      OR  RETURN-VALUE <> "OK" THEN DO:
          DEF VAR l-erro AS LOG NO-UNDO.
          FOR EACH tt-erro-apb:
    
              CREATE tt-erro.
              ASSIGN tt-erro.codigo = 17006
                     tt-erro.mensagem =  " (1) Erro abatendo valor do t°tulo do Contas a Pagar"
                     tt-erro.ajuda    =  " Canal........: " + STRING({1}.canal)              + CHR(10) +
                                         " Benef°cio....: " + STRING({1}.tipo-beneficio)     + CHR(10) +
                                         " Unidade......: " + {1}.unid-neg                   + CHR(10) +
                                         " Per°odo Ini..: " + STRING({1}.dt-periodo-ini)     + CHR(10) +
                                         " Per°odo Fim..: " + STRING({1}.dt-periodo-fim)     + CHR(10) +
                                         " Vl Pagamento.: " + STRING(int-solicitacao.ValorSolicitado) + CHR(10) + 
                                         tt-erro-apb.mensagem + " - HELP: " + tt-erro-apb.ajuda.
              l-erro = YES.
          END.

          IF  NOT l-erro THEN DO:
              CREATE tt-erro.        
              ASSIGN tt-erro.codigo  = 17006
                     tt-erro.mensagem = " (2) Erro abatendo valor do t°tulo do Contas a Pagar"
                     tt-erro.ajuda    = " Canal........: " + STRING({1}.canal)              + CHR(10) +  
                                        " Benef°cio....: " + STRING({1}.tipo-beneficio)     + CHR(10) +  
                                        " Unidade......: " + {1}.unid-neg                   + CHR(10) +  
                                        " Per°odo Ini..: " + STRING({1}.dt-periodo-ini)     + CHR(10) +  
                                        " Per°odo Fim..: " + STRING({1}.dt-periodo-fim)     + CHR(10) +  
                                        " Vl Pagamento.: " + STRING(int-solicitacao.ValorSolicitado) + CHR(10) +  
                                        "Retorno com erro, mas n∆o retornou descriá∆o do mesmo.".
          END.

          RETURN "NOK".
      END.

      ASSIGN p-ok = YES.
      RETURN "OK".
END.
