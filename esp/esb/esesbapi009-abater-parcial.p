/******************************************************************************************************************************************************/
/*  NOME.......: ESESBAPI009.P                                                                                                                        */
/*  OBJETIVO...: APURAR O VALOR ABATIDO POR CANCELAMENTO PARCIAL DA SOLICITA€ÇO.                                                                      */
/*  DATA.......: 27/01/2015                                                                                                                           */
/*  AUTOR......: ROGER BRUHN                                                                                                                          */
/******************************************************************************************************************************************************/

DEF BUFFER b-int-solicitacao FOR int-solicitacao.

DEF VAR de-atendido   AS DEC NO-UNDO.
DEF VAR de-abatido-ap AS DEC NO-UNDO.
DEF VAR de-a-abater   AS DEC NO-UNDO.

{esp/esb/esesbapi004-benef.i} /* Temp-table tt-beneficio */
{esp/esb/in/msg0152.i3} /*tt-erro*/
{utp/ut-glob.i}

DEF TEMP-TABLE tt-erro-apb     LIKE tt-erro.

/* PAR¶METROS */
DEF INPUT  PARAM p-guid-solicitacao   AS CHAR NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-erro.
DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

DEF VAR i-sit-ini AS INTEGER NO-UNDO.
DEF VAR i-sit-fim AS INTEGER NO-UNDO.


/* Enviar as solicita‡äes com situa‡Æo de "pagamento efetuado/pedido gerado"  (c¢digo = 993520004) */
FOR EACH int-solicitacao NO-LOCK
    WHERE (IF p-guid-solicitacao <> ? THEN int-solicitacao.CodigoSolicitacaoBeneficio = p-guid-solicitacao ELSE YES)
      AND (int-solicitacao.SituacaoSolicitacaoBeneficio     >= 993520003 AND  int-solicitacao.SituacaoSolicitacaoBeneficio <= 993520004)
      AND int-solicitacao.desc-forma-pagto                  = "Produto"  /* SOLICITA€åES QUE GERAM PEDIDO DE VENDA */
      AND NOT int-solicitacao.Ajuste                                     /* DESCONSIDERAR AJUSTES */
      AND int-solicitacao.log-enviada = NO
      AND NOT int-solicitacao.log-historica /* NÆo considerar as hist¢ricas */
      AND int-solicitacao.int-1 = 0 /*Distribuidor*/ 
    ,
    FIRST int-cc-benef  FIELDS (canal dt-periodo-ini dt-periodo-fim tipo-beneficio unid-neg cod_estab perc-custo num_id_tit_ap vl-saldo) NO-LOCK
        WHERE int-cc-benef.tp-movto       = 2 
          AND int-cc-benef.canal          = int-solicitacao.cod-emitente
          AND int-cc-benef.unid-neg       = int-solicitacao.CodigoUnidadeNegocio
          AND int-cc-benef.tipo-beneficio = int-solicitacao.tipo-beneficio
          AND int-cc-benef.dt-periodo-ini = int-solicitacao.dt-periodo-ini
          AND int-cc-benef.dt-periodo-fim = int-solicitacao.dt-periodo-fim
          AND int-cc-benef.id-status      = 1 /*ativa*/
    , 
     EACH int-solicitacao-item  NO-LOCK
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

      /* Valor j  abatido da solicitacao anteriormente*/
      IF  FIRST-OF(int-solicitacao.CodigoSolicitacaoBeneficio) THEN
          ASSIGN  de-a-abater   = 0
                  de-atendido   = 0 
                  de-abatido-ap = int-solicitacao.vl-abatido-apb.

      /* Acumula o total atendido de todos itens de todos os pedidos vinculados. Desconta atendimentos em trimestres anteriores, no caso da solicita‡Æo  */
      /* ter sido migrada para preserva‡Æo de empenho. Isso para que o controle de atendimento no t¡tulo atual, considere corretamente apenas o que est  */
      /* sendo atendido no trimestre corrente. Visto que valor j  pago no trimestre anterior, j  foi abatido do t¡tulo do pr¢prio trimestre passaod      */
      ASSIGN de-atendido = de-atendido + ((ped-item.qt-atendida - int-solicitacao-item.qt-ja-atendida-empenho) * int-solicitacao-item.ValorUnitarioAprovado).
      
      IF  LAST-OF (int-solicitacao.CodigoSolicitacaoBeneficio) 
      AND (de-atendido > 0 AND de-atendido <> de-abatido-ap) THEN DO:
          ASSIGN de-a-abater = de-atendido - de-abatido-ap.

          IF  de-a-abater <= 0 THEN  NEXT. 

          BLOCO:
          DO TRANS ON ERROR UNDO, NEXT:

              IF  (int-solicitacao.tipo-beneficio <> 04 /* Backup */ 
              AND int-solicitacao.tipo-beneficio  <> 15 /* ShowRoom */
              AND int-solicitacao.tipo-beneficio  <> 22 /* Stock Rotation */) THEN DO:
                  RUN pi-atualiza-titulo (INPUT de-a-abater,
                                          INPUT NO, /*NÆo ‚ um desconto em duplicata*/
                                          OUTPUT TABLE tt-erro,
                                          OUTPUT p-ok).
    
                  IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
    
                      IF  p-guid-solicitacao <> ? THEN DO:
                          UNDO bloco, RETURN "NOK".
                      END.
                      ELSE DO:
                          UNDO bloco, NEXT.
                      END.
                  
                  END.
              END.
                  
              FIND b-int-solicitacao
                   WHERE ROWID(b-int-solicitacao) = ROWID(int-solicitacao) EXCLUSIVE-LOCK NO-ERROR.
              IF  NOT AVAIL b-int-solicitacao THEN DO:
                  IF  p-guid-solicitacao <> ? THEN DO:
                      UNDO bloco, RETURN "NOK".
                  END.
                  ELSE DO:
                      UNDO bloco, NEXT.
                  END.
              END.

              /* GRAVA O VALOR Jµ CONSDIERADO COMO ATENDIDO, PARA NÇO CONSIDERAR FUTURAMENTE*/
              ASSIGN b-int-solicitacao.vl-abatido-apb = b-int-solicitacao.vl-abatido-apb + de-a-abater.

              FIND CURRENT b-int-solicitacao NO-LOCK NO-ERROR.

              IF  AVAIL b-int-solicitacao THEN
                  RELEASE b-int-solicitacao NO-ERROR.

          END.

      END.

END.

ASSIGN p-ok = YES.

RETURN "OK".

{esp/esb/esesbapi009-abater-parcial.i "int-cc-benef" } /* procedure abater t¡tulo */
