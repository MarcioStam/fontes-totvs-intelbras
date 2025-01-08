/*******************************************************************************/
/* esesbapi012 - chamada no evento EndEfetivaNota da bodi317ef-upc.p           */
/* Objetivo: Toda vez que um pedido vinculado Ö solicitaá‰es de benef°cido     */
/*           for faturado, o esse valor deve ser gravado na solicitaá∆o e      */
/*           abatido do contas a pagar.                                        */
/*******************************************************************************/

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(250)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

/*---------------------------------------------------------------------------*/
/*  Altera o status da solicitaá∆o de benef°cio para "PAGO", quando todos os */
/*  pedidos relaciondos a solicitaá∆o encontrada para o pedido da nota que   */
/*  est† sendo processada neste momento, estiverem atendidos totalemente.    */
/*---------------------------------------------------------------------------*/
DEF BUFFER b-solicitacao-item  FOR int-solicitacao-item.
DEF BUFFER b-pedido-solic      FOR ped-venda.
DEF BUFFER b-pedido-solic-item FOR ped-item.
DEF VAR l-atendido AS LOG NO-UNDO.

DEF INPUT PARAM r-rowid-nf AS ROWID NO-UNDO.

FIND FIRST nota-fiscal NO-LOCK
    WHERE rowid(nota-fiscal) = r-rowid-nf NO-ERROR.

IF  NOT AVAIL nota-fiscal THEN
    RETURN "OK".

FIND b-pedido-solic NO-LOCK
    WHERE b-pedido-solic.nome-abrev = nota-fiscal.nome-ab-cli
      AND b-pedido-solic.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.

IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE("avail b-pedido-solic: " + string(AVAIL b-pedido-solic)).
IF  AVAIL b-pedido-solic THEN DO:
    FOR FIRST int-solicitacao-item FIELDS (CodigoSolicitacaoBeneficio log-historica)
        WHERE int-solicitacao-item.nome-abrev = b-pedido-solic.nome-abrev
          AND int-solicitacao-item.nr-pedcli  = b-pedido-solic.nr-pedcli 
          AND int-solicitacao-item.log-historica = NO /*Nío considera as histΩricas*/ NO-LOCK :
        IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE(" int-solicitacao.log-historica: " + string( int-solicitacao-item.log-historica)).
    END.

    IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE("avail int-solicitacao-item: " + string(AVAIL int-solicitacao-item)).
 
    IF  AVAIL int-solicitacao-item THEN DO:
    
        FIND FIRST int-solicitacao NO-LOCK
            WHERE int-solicitacao.CodigoSolicitacaoBeneficio = int-solicitacao-item.CodigoSolicitacaoBeneficio
              AND int-solicitacao.desc-forma-pagto = "Produto" 
              AND (    int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520006 /* que n∆o esteja Cancelada*/ 
                   AND int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520004) /* que n∆o esteja Pagar*/ 
              AND NOT int-solicitacao.log-historica  NO-ERROR.

        IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE("avail int-solicitacao: " + string(AVAIL int-solicitacao)).

        IF  AVAIL int-solicitacao THEN DO:
            ASSIGN l-atendido = NO.
            FOR EACH b-solicitacao-item NO-LOCK
                  WHERE b-solicitacao-item.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio:

                IF  CAN-FIND (FIRST b-pedido-solic NO-LOCK
                                    WHERE b-pedido-solic.nome-abrev  = b-solicitacao-item.nome-abrev
                                      AND b-pedido-solic.nr-pedcli   = b-solicitacao-item.nr-pedcli
                                      AND b-pedido-solic.cod-sit-ped = 3) THEN DO: /* Atendido total */

                    ASSIGN l-atendido = YES.
                END.
                ELSE DO:
                    ASSIGN l-atendido = NO.

                    LEAVE.
                END.
            END.

            DO TRANS:

                FIND CURRENT int-solicitacao EXCLUSIVE-LOCK NO-ERROR.

                /*-----------------------------------------------------------------------------------------------------*/
                /*                                   ALTERAR OS ITENS DA SOLICITACAO                                   */
                /*-----------------------------------------------------------------------------------------------------*/
                IF  AVAIL int-solicitacao THEN DO:
                    IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE("2 - avail int-solicitacao: " + string(AVAIL int-solicitacao)).

                    DEF VAR de-pago      AS DEC NO-UNDO.
                    DEF VAR de-cancelado AS DEC NO-UNDO.
                    DEF VAR de-total-solicitacao-benef AS DEC NO-UNDO.

                    FOR EACH b-solicitacao-item EXCLUSIVE-LOCK
                        WHERE b-solicitacao-item.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio
                          AND b-solicitacao-item.nome-abrev                 = nota-fiscal.nome-ab-cli
                          AND b-solicitacao-item.nr-pedcli                  = nota-fiscal.nr-pedcli:
                
                          IF OPSYS = "UNIX" THEN log-manager:WRITE-MESSAGE("3 - b-solicitacao-item: " + string(b-solicitacao-item.log-1)).

                          FIND FIRST b-pedido-solic-item NO-LOCK
                               WHERE b-pedido-solic-item.nome-abrev  = b-solicitacao-item.nome-abrev
                                 AND b-pedido-solic-item.nr-pedcli   = b-solicitacao-item.nr-pedcli
                                 AND b-pedido-solic-item.it-codigo   = b-solicitacao-item.CodigoProduto NO-ERROR.
                
                          IF  NOT AVAIL b-pedido-solic-item THEN 
                              NEXT.
                
                          /* Caso a sequencia tenha sido Cancelada */
                          IF  b-pedido-solic-item.dt-canseq <> ? THEN /* Item Cancelado */
                              ASSIGN b-solicitacao-item.ValorCancelado      = (b-pedido-solic-item.qt-pedida - b-pedido-solic-item.qt-atendida) * b-solicitacao-item.ValorUnitarioAprovado
                                     b-solicitacao-item.QuantidadeCancelada =  b-pedido-solic-item.qt-pedida - b-pedido-solic-item.qt-atendida
                                     de-cancelado                           =  de-cancelado + b-solicitacao-item.ValorCancelado.
                                     
                          /* Atualiza o valor pago*/
                          /* Deve-ser considerar que uma solicitaá∆o pode ter sido transferida de um trimestre para outro, com alguma quantia j† paga no trimestre anterior       */
                          /* Neste caso, como sempre pegamos toda a quantidade do item do pedido j† atendida, devemos descontar a parte que j† foi paga anteriormente             */
                          /* Logo, tudo que foi atendido do pedido atÇ ent∆o, menos o que foi transferido como pagamento do trimestre anterior, indica o valor exato que foi pago */
                          /* apenas no trimestre corrente.*/
                          ASSIGN b-solicitacao-item.ValorPago = (b-pedido-solic-item.qt-atendida - b-solicitacao-item.qt-ja-atendida-empenho) * b-solicitacao-item.ValorUnitarioAprovado.
                                
                    END.

                    /*-----------------------------------------------------------------------------------------------------*/
                    /*                                  Alterar status da Solicitacao                                      */
                    /*-----------------------------------------------------------------------------------------------------*/
                    IF  l-atendido THEN
                        ASSIGN int-solicitacao.SituacaoSolicitacaoBeneficio    = 993520004  /* Pagamento Efetuado */
                               int-solicitacao.RazaoStatusSolicitacaoBeneficio = 993520004  /* Pagamento Reembolsado */
                               int-solicitacao.StatusPagamento                 = 993520002. /* Pago Total Padr∆o */
                    ELSE                    
                        ASSIGN int-solicitacao.StatusPagamento = 993520001. /* Pago Parcial */
                           
                    /* ATUALIZA O VALOR Jµ PAGO DA SOLICITAÄ«O */
                    FOR EACH int-solicitacao-item no-lock
                        WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio:
                         ASSIGN de-pago = de-pago + int-solicitacao-item.ValorPago.
                    END.

                    ASSIGN int-solicitacao.ValorPago = de-pago.
                END.
            END.

            FIND CURRENT int-solicitacao NO-LOCK NO-ERROR.


            IF  AVAIL int-solicitacao THEN DO:
                DEF VAR l-ok AS LOG INIT NO NO-UNDO.
                RUN esp/esb/esesbapi009-abater-parcial.p (INPUT int-solicitacao.CodigoSolicitacaoBeneficio,
                                                          OUTPUT TABLE tt-erro,
                                                          OUTPUT l-ok).

                /* CRIA UM PEDIDO DE EXECUÄ«O NO RPW, PARA ENVIAR O STATUS ATUALIZADO DA SOLICITAÄ«O */
                RUN esp/esb/esesbapi011-rpw.p (INPUT int-solicitacao.CodigoSolicitacaoBeneficio).

            END.
            RELEASE int-solicitacao NO-ERROR.

            /*END.*/
        END.
    END.      
END.

RETURN "OK".

