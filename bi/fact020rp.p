/**
 * Extrator para BI
 * Fato: Ciclo de vida do pedido de vendas
 *
 * Autor: Anderson Hoepers - 25/04/2013
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parÉmetros **/
{bi/fact020tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttCicloPedidoVenda.
define output parameter table for tt-erro.

define variable dt-inicial       as date        no-undo.
define variable dt-final         as date        no-undo.
define variable dt-impl-tmp      as date        no-undo.

/************************************************************************/

find tt-param no-error.

assign dt-inicial = date(month(tt-param.dt-inicial), 1, year(tt-param.dt-inicial))
       dt-final   = date(month(tt-param.dt-final), 1, year(tt-param.dt-final))
       dt-inicial = add-interval(dt-inicial, 1, 'months') - 1
       dt-final   = add-interval(dt-final,   1, 'months') - 1.

/** Gambi **/
if dt-final > today then
   assign dt-final = today.

RUN pi-le-pedidos.

PROCEDURE pi-le-pedidos:

    DO dt-impl-tmp = tt-param.dt-inicial TO dt-final:

        FOR EACH  ped-venda NO-LOCK
            WHERE ped-venda.dt-implant   = dt-impl-tmp,
             EACH ped-item OF ped-venda NO-LOCK:

           if not can-find (first mgcad.cidade
                            where cidade.pais = ped-venda.pais
                              and cidade.estado = ped-venda.estado
                              and cidade.cidade = ped-venda.cidade) then do:
              run createError("Pais/estado/cidade " + ped-venda.pais + "/" + ped-venda.estado + "/" + ped-venda.cidade + " n∆o encontrado - " + ped-venda.nome-abrev + ', ' + ped-venda.nr-pedcli + ', ' + ped-item.it-codigo + ', ' + string(ped-item.nr-sequencia)).
              next.
           end.

            CREATE ttCicloPedidoVenda.
            ASSIGN ttCicloPedidoVenda.CD_Estabelecimento       = fn-free-accent(upper(trim(ped-venda.cod-estabel)))
                   ttCicloPedidoVenda.CD_Emitente              = ped-venda.cod-emitente
                   ttCicloPedidoVenda.CD_Pedido_Cliente        = ped-venda.nr-pedcli  
                   ttCicloPedidoVenda.CD_Sequencia             = ped-item.nr-sequencia
                   ttCicloPedidoVenda.CD_Item                  = fn-free-accent(upper(trim(ped-item.it-codigo)))
                   ttCicloPedidoVenda.CD_Situacao_Item         = ped-item.cod-sit-item
                   ttCicloPedidoVenda.CD_Situacao_Pedido       = ped-venda.cod-sit-ped
                   ttCicloPedidoVenda.CD_Pais                  = fn-free-accent(upper(trim(ped-venda.pais)))   
                   ttCicloPedidoVenda.CD_Estado                = fn-free-accent(upper(trim(ped-venda.estado)))
                   ttCicloPedidoVenda.CD_Cidade                = fn-free-accent(upper(trim(ped-venda.cidade)))
                   ttCicloPedidoVenda.CD_Serie                 = ""
                   ttCicloPedidoVenda.CD_Natureza_Operacao     = fn-free-accent(upper(trim(ped-venda.nat-operacao))) 
                   ttCicloPedidoVenda.CD_Atendente             = ped-venda.tp-pedido
                   ttCicloPedidoVenda.DT_Emissao               = ped-venda.dt-emissao   
                   ttCicloPedidoVenda.DT_Implantacao           = ped-venda.dt-implant  
                   ttCicloPedidoVenda.DT_Aprova_Credito        = ped-venda.dt-apr-cred 
                   ttCicloPedidoVenda.DT_Aprov_Abaixo_Preco    = ?  
                   ttCicloPedidoVenda.DT_Cancela_Pedido        = ped-venda.dt-cancela  
                   ttCicloPedidoVenda.DT_Reativacao            = ped-venda.dt-reativ 
                   ttCicloPedidoVenda.DT_Suspensao             = ped-venda.dt-suspensao
                   ttCicloPedidoVenda.DT_Entrega_Prev          = ped-venda.dt-entorig
                   ttCicloPedidoVenda.DT_Cancela_Nota          = ?
                   ttCicloPedidoVenda.DT_Faturamento           = ?  
                   ttCicloPedidoVenda.DT_Saida_Nota            = ?
                   ttCicloPedidoVenda.DT_Devolucao             = ?
                   ttCicloPedidoVenda.DT_Cancela_Item          = ped-item.dt-canseq
                   ttCicloPedidoVenda.NM_VL_Total_Item         = ped-item.vl-tot-it
                   ttCicloPedidoVenda.NM_VL_Devolucao          = 0.


            /* Verificar liberaá∆o crÇdito por cart∆o intelbras ou hist¢rico */
            IF  ped-venda.cod-sit-ped = 3 AND /* Totalmente Atendido */ 
                ped-venda.dt-apr-cred = ?
            THEN DO:
                FIND FIRST int-cond-pagto NO-LOCK
                    WHERE  int-cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.
                IF  AVAIL int-cond-pagto                                      AND
                         (SUBSTRING(int-cond-pagto.char-1,4,1)          = "S"  OR /* Cart∆o Intelbras Clube (SupplierCard) */
                                    int-cond-pagto.transacao-com-cartao = YES)    /* Transaá∆o com Cart∆o */
                THEN
                    ASSIGN ttCicloPedidoVenda.DT_Aprova_Credito = ttCicloPedidoVenda.DT_Implantacao.
                ELSE DO:
                    FOR EACH  historico-credito NO-LOCK
                        WHERE historico-credito.nome-abrev     = ped-venda.nome-abrev
                          AND historico-credito.nr-pedcli      = ped-venda.nr-pedcli
                          AND historico-credito.tipo-movto     = "Aprov"
                          AND historico-credito.dt-data-movto <> ?:

                        IF  ttCicloPedidoVenda.DT_Aprova_Credito = ?
                        THEN
                            ASSIGN ttCicloPedidoVenda.DT_Aprova_Credito = historico-credito.dt-data-movto.
                        ELSE
                             ASSIGN ttCicloPedidoVenda.DT_Aprova_Credito = MAX(ttCicloPedidoVenda.DT_Aprova_Credito,historico-credito.dt-data-movto).
                    END.
                END. /* else IF  AVAIL int-cond-pagto AND */
            END. /* IF  ped-venda.cod-sit-ped = 3 AND */


            FIND transporte NO-LOCK
                WHERE transporte.nome-abrev = ped-venda.nome-transp NO-ERROR.
            IF  AVAIL transporte
            THEN
                ASSIGN ttCicloPedidoVenda.CD_Transportador = transporte.cod-transp.

            FIND repres NO-LOCK
                WHERE repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.
            IF  AVAIL repres
            THEN
                ASSIGN ttCicloPedidoVenda.CD_Representante = repres.cod-rep.

            /* Verificar se pedido est† pendente de aprovaá∆o abaixo do minimo */

            IF  ped-venda.dt-apr-cred = ?
            THEN DO:
                FOR EACH int-ped-item NO-LOCK
                        WHERE int-ped-item.nome-abrev       = ped-venda.nome-abrev
                          AND int-ped-item.nr-pedcli        = ped-venda.nr-pedcli
                          AND int-ped-item.nr-sequencia     = ped-item.nr-sequencia
                          AND int-ped-item.it-codigo        = ped-item.it-codigo   
                          AND int-ped-item.ind-status-preco > 0:

                        IF   int-ped-item.ind-status-preco = 02 /* Liberado */ 
                        THEN
                            IF  ttCicloPedidoVenda.DT_Aprov_Abaixo_Preco <> ?
                            THEN
                                ASSIGN ttCicloPedidoVenda.DT_Aprov_Abaixo_Preco = MAX(ttCicloPedidoVenda.DT_Aprov_Abaixo_Preco,int-ped-item.data-aprovacao).
                            ELSE
                                ASSIGN ttCicloPedidoVenda.DT_Aprov_Abaixo_Preco = int-ped-item.data-aprovacao.
                        ELSE
                            ASSIGN ttCicloPedidoVenda.DT_Aprov_Abaixo_Preco = 01/01/1900.
                END.
            END.

            /* Obter data de faturamento, saida, cancelamento e devoluá∆o da nota */
            FOR EACH  it-nota-fisc NO-LOCK
                WHERE it-nota-fisc.nome-ab-cli = ped-venda.nome-abrev
                  AND it-nota-fisc.nr-pedcli   = ped-venda.nr-pedcli
                  AND it-nota-fisc.nr-seq-ped  = ped-item.nr-sequencia
                  AND it-nota-fisc.it-codigo   = ped-item.it-codigo:

                FIND nota-fiscal NO-LOCK
                    WHERE nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel
                      AND nota-fiscal.serie       = it-nota-fisc.serie
                      AND nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis NO-ERROR.

                IF  AVAIL nota-fiscal
                THEN DO:
                    FIND transporte NO-LOCK
                        WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.
                    IF  AVAIL transporte
                    THEN
                        ASSIGN ttCicloPedidoVenda.CD_Transportador_Nota = transporte.cod-transp.


                    ASSIGN ttCicloPedidoVenda.CD_Serie          = fn-free-accent(upper(trim(it-nota-fisc.serie)))      
                           ttCicloPedidoVenda.CD_Nota_Fiscal    = it-nota-fisc.nr-nota-fis
                           ttCicloPedidoVenda.CD_Sequencia_Nota = it-nota-fisc.nr-seq-fat.

                    IF  nota-fiscal.dt-emis-nota <> ?
                    THEN DO:
                        IF  ttCicloPedidoVenda.DT_Faturamento <> ?
                        THEN
                            ASSIGN ttCicloPedidoVenda.DT_Faturamento = MAX(ttCicloPedidoVenda.DT_Faturamento,nota-fiscal.dt-emis-nota).
                        ELSE
                            ASSIGN ttCicloPedidoVenda.DT_Faturamento = nota-fiscal.dt-emis-nota.
                    END.

                    IF  nota-fiscal.dt-saida <> ?
                    THEN DO:
                        IF  ttCicloPedidoVenda.DT_Saida_Nota <> ?
                        THEN
                            ASSIGN ttCicloPedidoVenda.DT_Saida_Nota  = MAX(ttCicloPedidoVenda.DT_Saida_Nota, nota-fiscal.dt-saida).
                        ELSE
                            ASSIGN ttCicloPedidoVenda.DT_Saida_Nota  = nota-fiscal.dt-saida.
                    END.

                    IF  nota-fiscal.dt-cancela <> ?
                    THEN DO:
                        IF  ttCicloPedidoVenda.DT_Cancela_Nota <> ?
                        THEN
                            ASSIGN ttCicloPedidoVenda.DT_Cancela_Nota = MAX(ttCicloPedidoVenda.DT_Cancela_Nota,nota-fiscal.dt-cancela).
                        ELSE
                            ASSIGN ttCicloPedidoVenda.DT_Cancela_Nota = nota-fiscal.dt-cancela.
                    END.

                    FIND FIRST devol-cli NO-LOCK
                        WHERE  devol-cli.cod-estabel  = nota-fiscal.cod-estabel
                          AND  devol-cli.serie        = nota-fiscal.serie
                          AND  devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis 
                          AND  devol-cli.nr-sequencia = ped-item.nr-sequencia
                          AND  devol-cli.it-codigo    = ped-item.it-codigo NO-ERROR.

                    IF  AVAIL devol-cli
                    THEN DO:
                        FOR EACH  devol-cli NO-LOCK
                            WHERE devol-cli.cod-estabel   = nota-fiscal.cod-estabel
                              AND devol-cli.serie         = nota-fiscal.serie
                              AND devol-cli.nr-nota-fis   = nota-fiscal.nr-nota-fis
                              AND devol-cli.nr-sequencia  = ped-item.nr-sequencia
                              AND devol-cli.it-codigo     = ped-item.it-codigo:

                            IF  ttCicloPedidoVenda.DT_Devolucao <> ?
                            THEN
                                ASSIGN ttCicloPedidoVenda.DT_Devolucao = MAX(ttCicloPedidoVenda.DT_Devolucao, devol-cli.dt-devol).
                            ELSE
                                ASSIGN ttCicloPedidoVenda.DT_Devolucao = devol-cli.dt-devol.

                            ASSIGN ttCicloPedidoVenda.NM_VL_Devolucao = ttCicloPedidoVenda.NM_VL_Devolucao + devol-cli.vl-devol.
                        END.
                    END.
                END. /* IF  AVAIL nota-fiscal */
            END. /* FOR EACH  it-nota-fisc NO-LOCK */
        END. /* FOR EACH ped-venda NO-LOCK */
    END. /* DO dt-movto-tmp = tt-param.dt-inicial TO dt-final: */

END PROCEDURE.


RETURN "ok".
