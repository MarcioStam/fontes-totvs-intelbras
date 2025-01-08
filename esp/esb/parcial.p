
{esp/esb/esesbapi004-benef.i} /* Temp-table tt-beneficio */

/* ERROS */
DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(250)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF TEMP-TABLE tt-erro-apb     LIKE tt-erro.

DEF BUFFER b-int-solicitacao FOR int-solicitacao.

DEF VAR de-atendido   AS DEC NO-UNDO.
DEF VAR de-abatido-ap AS DEC NO-UNDO.
DEF VAR de-a-abater   AS DEC NO-UNDO.

OUTPUT TO c:\temp\relat-teste.txt.

DO TRANS:
    
    /* Enviar as solicitaá‰es com situaá∆o de "pagamento efetuado/pedido gerado"  (c¢digo = 993520004) */
    FOR EACH int-solicitacao NO-LOCK
        WHERE int-solicitacao.log-enviada                  = NO         /* N«O ENVIADADAS AINDA AO CRM. AS Jµ ENVIADAS Jµ BAIXARAM O SALDO DO APB */
          AND int-solicitacao.SituacaoSolicitacaoBeneficio = 993520003  /* PENDENTES */
          AND int-solicitacao.desc-forma-pagto             = "Produto"  /* SOLICITAÄÂES QUE GERAM PEDIDO DE VENDA */
          AND NOT int-solicitacao.log-1                                 /* DESCONSIDERAR AJUSTES */
          AND int-solicitacao.cod-emitente = 12052
        ,
        FIRST int-cc-benef  FIELDS (canal dt-periodo-ini dt-periodo-fim tipo-beneficio unid-neg cod_estab perc-custo num_id_tit_ap) NO-LOCK
            WHERE int-cc-benef.tp-movto       = 2 
              AND int-cc-benef.canal          = int-solicitacao.cod-emitente
              AND int-cc-benef.unid-neg       = int-solicitacao.CodigoUnidadeNegocio
              AND int-cc-benef.tipo-beneficio = int-solicitacao.tipo-beneficio
              AND int-cc-benef.dt-periodo-ini = int-solicitacao.dt-periodo-ini
              AND int-cc-benef.dt-periodo-fim = int-solicitacao.dt-periodo-fim
              AND int-cc-benef.id-status      = 1 /*ativa*/
        , 
         EACH int-solicitacao-item FIELDS(nome-abrev nr-pedcli  CodigoProduto ValorUnitarioAprovado) NO-LOCK
              WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio
              ,
              FIRST ped-item FIELDS(qt-atendida) NO-LOCK
                 WHERE ped-item.nome-abrev   = int-solicitacao-item.nome-abrev
                   AND ped-item.nr-pedcli    = int-solicitacao-item.nr-pedcli
                   AND ped-item.it-codigo    = int-solicitacao-item.CodigoProduto
                   AND (ped-item.cod-sit-item > 1 AND ped-item.cod-sit-item < 4)  /* ITEM ATENDIDO PARCIAL OU TOTAL */
              , FIRST  ped-venda FIELDS() NO-LOCK
                    WHERE ped-venda.nome-abrev = int-solicitacao-item.nome-abrev
                      AND ped-venda.nr-pedcli  = int-solicitacao-item.nr-pedcli
                      AND (ped-venda.cod-sit-ped > 1 AND ped-venda.cod-sit-ped < 4) /* PEDIDOS TOTAL OU PARCIALMENTE ATENDIDOS*/
                             /* ATENDIDO PARCIALMENTE */
              
          BREAK BY int-solicitacao.CodigoSolicitacaoBeneficio:
           
          /* Valor j† abatido da solicitacao anteriormente*/
          IF  FIRST-OF(int-solicitacao.CodigoSolicitacaoBeneficio) THEN
              ASSIGN  de-a-abater   = 0
                      de-atendido   = 0 
                      de-abatido-ap = int-solicitacao.int-1 / 100.
    
          /* Acumula o total atendido de todos itens de todos os pedidos vinculados */
          ASSIGN de-atendido = de-atendido + (ped-item.qt-atendida * int-solicitacao-item.ValorUnitarioAprovado).
    
          MESSAGE "de-atendido: " de-atendido SKIP
                  "de-abatido-ap: " de-abatido-ap
                  "int-solicitacao.valorSolicitado: " int-solicitacao.valorSolicitado
              VIEW-AS ALERT-BOX INFO BUTTONS OK.

          IF  LAST-OF (int-solicitacao.CodigoSolicitacaoBeneficio) 
          AND (de-atendido > 0 AND de-atendido <> de-abatido-ap) THEN DO:
          
              PUT UNFORMATTED "Canal..............: " int-cc-benef.canal              skip
                              "Unid-neg...........: " int-cc-benef.unid-neg           skip
                              "Tipo-beneficio.....: " int-cc-benef.tipo-beneficio     skip
                              "Dt-periodo-ini.....: " int-cc-benef.dt-periodo-ini     skip
                              "Dt-periodo-fim.....: " int-cc-benef.dt-periodo-fim     SKIP
                              "Valor Solicitacao..: " int-solicitacao.ValorSolicitado SKIP
                              "de-abatido-ap......: " de-abatido-ap                   SKIP
                              "de-atendido........: " de-atendido                     SKIP.
              
              ASSIGN de-a-abater = de-atendido - de-abatido-ap.
              
              PUT UNFORMATTED "de-a-abater........: " de-a-abater SKIP.
    
              IF  de-a-abater <= 0 THEN 
                  NEXT.
        
              BLOCO:
              DO TRANS ON ERROR UNDO, NEXT:
    .
                  FIND FIRST tit_ap NO-LOCK
                        WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab
                          AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.
                  PUT UNFORMATTED " AVAIL tit_ap: "  AVAIL tit_ap RETURN-VALUE SKIP.
                  IF  AVAIL tit_ap THEN
                      PUT UNFORMATTED SKIP "Saldo. Titulo antes: " tit_ap.val_sdo_tit_ap RETURN-VALUE SKIP.
    
                  RUN pi-atualiza-titulo (INPUT de-a-abater ).
                  IF  RETURN-VALUE <> "OK" THEN
                      NEXT.
    
                  PUT UNFORMATTED SKIP "Atualizou T°tulo?..: "  RETURN-VALUE SKIP.
    
                  FIND FIRST tit_ap NO-LOCK
                        WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab
                          AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.
                  IF  AVAIL tit_ap THEN
                      PUT UNFORMATTED "Saldo. Titulo novo.: " (tit_ap.val_sdo_tit_ap) SKIP(2).
    
                  FIND b-int-solicitacao
                       WHERE ROWID(b-int-solicitacao) = ROWID(int-solicitacao) EXCLUSIVE-LOCK NO-ERROR.
                  IF  NOT AVAIL b-int-solicitacao THEN DO:
                      UNDO, NEXT.
                  END.
    
                  /* GRAVA O VALOR Jµ CONSDIERADO COMO ATENDIDO, PARA N«O CONSIDERAR FUTURAMENTE*/
                  ASSIGN b-int-solicitacao.int-1 = b-int-solicitacao.int-1 + (de-a-abater * 100).
    
                  PUT UNFORMATTED "Acumulado Atual....: " b-int-solicitacao.int-1 SKIP.
    
                  FIND CURRENT b-int-solicitacao NO-LOCK.

                  RELEASE b-int-solicitacao.
    
              END.
    
          END.
          ELSE IF LAST-OF (int-solicitacao.CodigoSolicitacaoBeneficio) THEN
              PUT UNFORMATTED "Canal..............: " int-cc-benef.canal              skip
                              "Unid-neg...........: " int-cc-benef.unid-neg           skip
                              "Tipo-beneficio.....: " int-cc-benef.tipo-beneficio     skip
                              "Dt-periodo-ini.....: " int-cc-benef.dt-periodo-ini     skip
                              "Dt-periodo-fim.....: " int-cc-benef.dt-periodo-fim     SKIP
                              "Valor Solicitacao..: " int-solicitacao.ValorSolicitado SKIP
                              "de-abatido-ap......: " de-abatido-ap                   SKIP
                              "de-atendido........: " de-atendido                     SKIP
                              "Saiu!                "                  SKIP(2).
    
    
    END.
  
/*     FIND FIRST int-solicitacao NO-LOCK                                 */
/*         WHERE ROWID(int-solicitacao) = TO-ROWID("0x00000000001f86a7"). */
/*                                                                        */

    MESSAGE "Teste" SKIP
            "int-solicitacao.int-1: " int-solicitacao.int-1
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

    STOP.
END.



PROCEDURE pi-atualiza-titulo:

    DEF INPUT PARAM p-valor AS DEC NO-UNDO.

     /* ATUALIZAR O CONTAS A PAGAR */
     DEF VAR h-esesb003-apb AS HANDLE NO-UNDO.

     EMPTY TEMP-TABLE tt-beneficio.

     CREATE tt-beneficio.
     ASSIGN tt-beneficio.tipo-beneficio = int-cc-benef.tipo-beneficio
            tt-beneficio.unid-neg       = int-cc-benef.unid-neg
            tt-beneficio.cod-estabel    = int-cc-benef.cod_estab
            tt-beneficio.perc-custo     = int-cc-benef.perc-custo.

     IF  NOT VALID-HANDLE(h-esesb003-apb) THEN
         RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.

     RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT ROWID(int-cc-benef),
                                                    INPUT p-valor * (- 1) ,
                                                    INPUT NO,
                                                    INPUT TODAY,
                                                    INPUT int-cc-benef.dt-periodo-fim,
                                                    INPUT TABLE tt-beneficio,
                                                    OUTPUT TABLE tt-erro-apb).

      IF  VALID-HANDLE(h-esesb003-apb) THEN
          DELETE PROCEDURE h-esesb003-apb.

      IF  CAN-FIND (FIRST tt-erro-apb)
      OR  RETURN-VALUE <> "OK" THEN DO:
          DEF VAR l-erro AS LOG NO-UNDO.
          FOR EACH tt-erro-apb:
    
              PUT UNFORMATTED "Erro integrando solicitaá∆o com o Contas a Pagar"           + CHR(10) + 
                              " Canal........: " + STRING(int-cc-benef.canal)              + CHR(10) +
                              " Benef°cio....: " + STRING(int-cc-benef.tipo-beneficio)     + CHR(10) +
                              " Unidade......: " + int-cc-benef.unid-neg                   + CHR(10) +
                              " Per°odo Ini..: " + STRING(int-cc-benef.dt-periodo-ini)     + CHR(10) +
                              " Per°odo Fim..: " + STRING(int-cc-benef.dt-periodo-fim)     + CHR(10) +
                              " Vl Pagamento.: " + STRING(int-solicitacao.ValorSolicitado) + CHR(10) + 
                               tt-erro-apb.mensagem + " - HELP: " tt-erro-apb.ajuda SKIP(1).
              l-erro = YES.
          END.

          IF  NOT l-erro THEN
              PUT UNFORMATTED "Erro integrando solicitaá∆o com o Contas a Pagar"           + CHR(10) + 
                              " Canal........: " + STRING(int-cc-benef.canal)              + CHR(10) +  
                              " Benef°cio....: " + STRING(int-cc-benef.tipo-beneficio)     + CHR(10) +  
                              " Unidade......: " + int-cc-benef.unid-neg                   + CHR(10) +  
                              " Per°odo Ini..: " + STRING(int-cc-benef.dt-periodo-ini)     + CHR(10) +  
                              " Per°odo Fim..: " + STRING(int-cc-benef.dt-periodo-fim)     + CHR(10) +  
                              " Vl Pagamento.: " + STRING(int-solicitacao.ValorSolicitado) + CHR(10) +  
                              "Retorno com erro, mas n∆o retornou descriá∆o do mesmo." SKIP (1).

              RETURN "NOK".
      END.

      RETURN "OK".
END.
