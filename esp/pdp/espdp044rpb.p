/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp044rpb.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Setembro/2010 - Desenvolvimento
**  Descricao.: Integraá∆o WS Pedidos - Ikeda
-----------------------------------------------------------------------*/

create widget-pool.

/*---------------------------  Vari aveis    ---------------------------*/
{utp/ut-glob.i}
{cdp/cd0666.i}
define variable hWebService   as handle   no-undo.


{esp/pdp/espdp044tt.i}
{esp/pdp/espdp044rpb-tt.i}
{esp/pdp/espdp044sh.i "shared"}
{include/i-freeac.i}
{esapi/esapi010tt.i}
{utp/utapi009.i} /* Include API CORREIO ELETRONICO */

{esp/es0018.i}

DEFINE VARIABLE c-dir AS CHARACTER   NO-UNDO.
/*---------------------------  ParÉmetros   ---------------------------*/
define input parameter raw-param as raw no-undo.

create tt-param-rpb.
raw-transfer raw-param to tt-param-rpb.
/* ***************************  Main Block  *************************** */

EMPTY TEMP-TABLE tt-prog-ponto.

define temp-table tt-envio2
    field versao-integracao   as integer format ">>9"
    field servidor            as char
    field porta               as integer init 0
    field exchange            as logical init no
    field destino             as char
    field copia               as char
    field remetente           as char
    field assunto             as char
    field mensagem            as char
    field arq-anexo           as char
    field importancia         as integer init 0
    field log-enviada         as logical
    field log-lida            as logical
    field acomp               as logical init yes    
    field formato             as char init "texto".

DEFINE TEMP-TABLE tt-mensagem
    FIELD seq-mensagem        AS INTEGER
    FIELD mensagem            AS CHAR
    INDEX i-seq-mensagem
          seq-mensagem        ASCENDING.


IF OPSYS = "UNIX":U THEN
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
ELSE
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:
    ASSIGN c-dir = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
END.

IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "/":U THEN
    ASSIGN c-dir = c-dir + "/":U.

do on stop undo, return error "NOK":

    define variable iStatus       as integer     no-undo.
    define variable cStatus       as character   no-undo.
    DEFINE VARIABLE l-pai-igual-filho      AS LOGICAL     NO-UNDO.
    define variable c-atendente            as character   no-undo.
    define variable c-bairro               as character   no-undo.
    define variable c-cidade               as character   no-undo.
    define variable c-data                 as character   no-undo.
    define variable c-desc-suspend         as character   no-undo.
    define variable c-endereco             as character   no-undo.
    define variable c-nat-oper             as character   no-undo.
    define variable c-nat-oper-cabecalho   as character   no-undo.
    define variable c-natureza             as character   no-undo.
    define variable c-natureza-de          as character   no-undo.
    define variable c-natureza-fe          as character   no-undo.
    define variable c-pais                 as character   no-undo.
    define variable d-vl-liq-abe           as decimal     no-undo.
    define variable d-vl-liq-it            as decimal     no-undo.
    define variable de-itemvalor           as decimal     no-undo.
    define variable de-itemvalorfinal      as decimal     no-undo.
    define variable de-juro-total          as decimal     no-undo.
    define variable de-qtde                as decimal     no-undo.
    define variable de-qtde-existente      as decimal     no-undo.
    define variable de-valid-tot           as decimal     no-undo.
    define variable de-val-ValorTotal        as decimal     no-undo.
    define variable de-vl-pre-liq          as decimal     no-undo.
    define variable de-vl-preco            as decimal     no-undo.
    define variable de-total-preco         as decimal     no-undo.
    define variable dt-data                as date        no-undo.
    define variable i-cod-cond-pag         as integer     no-undo.
    define variable i-cod-rep              as integer     no-undo.
    define variable i-cod-sit-aval         as integer     no-undo.
    define variable i-cont-nat-igual       as integer     no-undo.
    define variable i-prioridade           as integer     no-undo.
    define variable i-qt-itens             as integer     no-undo.
    define variable i-sequencia            as integer     no-undo.
    define variable iOutSeqCartao          as integer     no-undo.
    define variable iSeqPedEstab           as integer     no-undo.
    define variable l-mantem-nat           as logical     no-undo.
    define variable l-return               as logical     no-undo.
    define variable l-saldao               as logical     no-undo.
    define variable l-cartid               as logical     no-undo.
    define variable d-vl-sub-total         as decimal     no-undo.
    define variable d-vl-ValorTotal          as decimal     no-undo.
    define variable d-vl-desconto          as decimal     no-undo.
    DEFINE VARIABLE c-nome-transp          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE bo-ped-venda-can       AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i-total-qtdes          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-pedidos              AS CHARACTER   NO-UNDO.
                    
    define variable h-boes505              as handle      no-undo.
    define variable h-cartao               as handle      no-undo.
    define variable c-hora-pagamento       as character   no-undo.
    define variable c-data-pagamento       as character   no-undo.
    define variable dt-data-pagamento      as date        no-undo.
    define variable i-cont                 as integer     no-undo.
    DEFINE VARIABLE de-total-vlr-ipi       AS DECIMAL FORMAT ">>>>9.9999999"     NO-UNDO.
    DEFINE VARIABLE de-percentual          AS DECIMAL FORMAT ">>>>9.9999999"     NO-UNDO.
    DEFINE VARIABLE de-frete-do-item       AS DECIMAL FORMAT ">>>>9.9999999"     NO-UNDO.
    DEFINE VARIABLE de-frete-sem-ipi       AS DECIMAL FORMAT ">>>>9.9999999"     NO-UNDO.
    DEFINE VARIABLE de-frete-total         AS DECIMAL                            NO-UNDO.
    DEFINE VARIABLE de-vl-frete            AS DECIMAL FORMAT ">>>>9.9999999"     NO-UNDO.
    DEFINE VARIABLE de-vlr-ipi-frete       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-ativa-log            AS LOGICAL     NO-UNDO INITIAL NO.
    define variable h-bodi159cal  as handle   no-undo.
    define variable l-erro        as logical  no-undo.
    DEFINE VARIABLE h-utapi019             AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-consumidor-final AS LOGICAL     NO-UNDO.
    find first param-global no-lock no-error.
     
    DEF BUFFER b1-ped-venda FOR ped-venda.
    DEF BUFFER b1-ped-item  FOR ped-item.
    DEFINE VARIABLE i-quant-licenca AS INTEGER     NO-UNDO. /* Licenáa Softphone - Fabiano Sakae Ribeiro (SQL Works / Exponencial TI) - Junho de 2012 */
     
    ASSIGN de-total-vlr-ipi = 0
           l-ativa-log      = YES.
    run esbo/boes505.p persistent set h-boes505.
    
    define buffer b-ttItens for ttItens.
    
    run pi-acompanhar in h-acomp ('Obtendo novos pedidos').
    
    /** Execuá∆o do WS para pegar inforamá‰es na Ikeda **/
    run esp/pdp/espdp044rpb-ws.p persistent set hWebService.
    run conecta in hWebService (output iStatus, output cStatus).
    
    if (iStatus <> 1) then
       run incluiMsgErro in this-procedure ('Erro ao conectar na Ikeda').
    else do:
       if (tt-param-rpb.Unico) and (tt-param-rpb.CodigoPedido > 0) then do:
          run listar in hWebService (input tt-param-rpb.CodigoPedido,
                                     output iStatus,
                                     output cStatus,
                                     output table ttPedido,
                                     output table ttCartao,
                                     output table ttItens).
    
          if (iStatus <> 1) then
             run incluiMsgErro in this-procedure (cStatus).
       end.
       else do:
          if (tt-param-rpb.AguardandoPagamento) then do:
             run listarNovos in hWebService (input 6 /** AguardandoPagamento **/,
                                             output iStatus,
                                             output cStatus,
                                             output table ttAuxPedido,
                                             output table ttAuxCartao,
                                             output table ttAuxItens).
             if (iStatus <> 1) then
                run incluiMsgErro in this-procedure (cStatus).
             else do:
                for each ttAuxPedido:
                   create ttPedido.
                   buffer-copy ttAuxPedido to ttPedido.
                end.
                for each ttAuxCartao:
                   create ttCartao.
                   buffer-copy ttAuxCartao to ttCartao.
                end.
                for each ttAuxItens:
                   create ttItens.
                   buffer-copy ttAuxItens to ttItens.
                end.
             end.
          end.
    
          IF (tt-param-rpb.PagamentoConfirmado) then do:
             run listarNovos in hWebService (input 7 /** PagamentoConfirmado **/,
                                             output iStatus,
                                             output cStatus,
                                             output table ttAuxPedido,
                                             output table ttAuxCartao,
                                             output table ttAuxItens).
             if (iStatus <> 1) then
                run incluiMsgErro in this-procedure (cStatus).
             else do:
                for each ttAuxPedido:
                   create ttPedido.
                   buffer-copy ttAuxPedido to ttPedido.
                end.
                for each ttAuxCartao:
                   create ttCartao.
                   buffer-copy ttAuxCartao to ttCartao.
                end.
                for each ttAuxItens:
                   create ttItens.
                   buffer-copy ttAuxItens to ttItens.
                end.
             end.
             
          END. /*Pagamento Confirmado*/
    
          if (tt-param-rpb.PedidoCancelado) then do:
             run listarNovos in hWebService (input 5 /** PedidosCancelados **/,
                                             output iStatus,
                                             output cStatus,
                                             output table ttAuxPedido,
                                             output table ttAuxCartao,
                                             output table ttAuxItens).
             
             if (iStatus <> 1) then
                run incluiMsgErro in this-procedure (cStatus).
             else do:
                
                 FOR EACH ttAuxPedido:
                       run pi-acompanhar in h-acomp ('Cancelando Pedidos ' + STRING(ttAuxPedido.PedidoCodigo)).
                       FIND first int-ped-venda
                           where int-ped-venda.PedidoCodigo = integer(ttAuxPedido.PedidoCodigo)
                             AND  int-ped-venda.contacodigo = integer(ttAuxPedido.contaCodigo) EXCLUSIVE-LOCK no-error.
                       IF AVAIL int-ped-venda then do:
                          FOR EACH ped-venda
                              WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido 
                                AND ped-venda.cod-sit-ped <> 6  exclusive-lock:
                              run pi-acompanhar in h-acomp ('Efetuando Cancelamento de Pedidos ' + STRING(ped-venda.nr-pedcli)).
                             
                              RUN piCancelaPedidosCanceladosPelaIkeda.
    
                          END.
                          
                       END.
                       FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
                       RELEASE int-ped-venda.

                       run validarBaixa in hWebService (ttAuxPedido.PedidoCodigo, '0', output iStatus, output cStatus).
                       if (iStatus <> 1) then
                           run incluiMsgErro in this-procedure (cStatus).
                       
    
                       /*********************************************************************************
                       **  Prop¢sito:  Liberar Licenáa Softphone no cancelamento do pedido.
                       **  Autor:      Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
                       **  Criaá∆o:    Junho de 2012
                       **********************************************************************************/
                       /****************************************
                       **  Validaá∆o Licenáa Softphone - In°cio
                       *****************************************/
                       FOR EACH int-licenca-softphone EXCLUSIVE-LOCK
                           WHERE int-licenca-softphone.nome-abrev = ped-venda.nome-abrev
                             AND int-licenca-softphone.nr-pedcli  = ped-venda.nr-pedcli:
                           IF int-licenca-softphone.observacao = "":U THEN
                               ASSIGN int-licenca-softphone.observacao = "- Pedido Anterior (Alteraá∆o: ":U + STRING(TODAY, "99/99/9999":U) + " - ":U + STRING(TIME, "hh:mm:ss":U) + ") >> Cliente: ":U + int-licenca-softphone.nome-abrev + " - Pedido Cliente: ":U + int-licenca-softphone.nr-pedcli.
                           ELSE
                               ASSIGN int-licenca-softphone.observacao = int-licenca-softphone.observacao + CHR(10) + "- Pedido Anterior (Alteraá∆o: ":U + STRING(TODAY, "99/99/9999":U) + " - ":U + STRING(TIME, "hh:mm:ss":U) + ") >> Cliente: ":U + int-licenca-softphone.nome-abrev + " - Pedido Cliente: ":U + int-licenca-softphone.nr-pedcli.
    
                           IF int-licenca-softphone.cod-estabel <> "":U OR
                              int-licenca-softphone.serie       <> "":U OR
                              int-licenca-softphone.nr-nota-fis <> "":U THEN DO:
                               IF int-licenca-softphone.observacao = "":U THEN
                                   ASSIGN int-licenca-softphone.observacao = "- Nota Fiscal Anterior (Alteraá∆o: ":U + STRING(TODAY, "99/99/9999":U) + " - ":U + STRING(TIME, "hh:mm:ss":U) + ") >> Estabelecimento: ":U + int-licenca-softphone.cod-estabel + " - SÇrie: ":U + int-licenca-softphone.serie + " - Nr Nota Fiscal: ":U + int-licenca-softphone.nr-nota-fis.
                               ELSE
                                   ASSIGN int-licenca-softphone.observacao = int-licenca-softphone.observacao + CHR(10) + "- Nota Fiscal Anterior (Alteraá∆o: ":U + STRING(TODAY, "99/99/9999":U) + " - ":U + STRING(TIME, "hh:mm:ss":U) + ") >> Estabelecimento: ":U + int-licenca-softphone.cod-estabel + " - SÇrie: ":U + int-licenca-softphone.serie + " - Nr Nota Fiscal: ":U + int-licenca-softphone.nr-nota-fis.
                           END. /* IF int-licenca-softphone.cod-estabel <> "":U OR
                                      int-licenca-softphone.serie       <> "":U OR
                                      int-licenca-softphone.nr-nota-fis <> "":U THEN DO: */
    
                           ASSIGN int-licenca-softphone.nome-abrev  = "":U
                                  int-licenca-softphone.nr-pedcli   = "":U
                                  int-licenca-softphone.cod-estabel = "":U
                                  int-licenca-softphone.serie       = "":U
                                  int-licenca-softphone.nr-nota-fis = "":U.
                       END. /* FOR EACH int-licenca-softphone EXCLUSIVE-LOCK
                                   WHERE int-licenca-softphone.nome-abrev = ped-venda.nome-abrev
                                     AND int-licenca-softphone.nr-pedcli  = ped-venda.nr-pedcli: */
                       /****************************************
                       **  Validaá∆o Licenáa Softphone - Final
                       *****************************************/
                 END.
             END.
          END.
       end.
    end.
    
    run pi-acompanhar in h-acomp ('Implantando pedidos recebidos').
    
    find param-global no-lock no-error.
    find mgcad.empresa no-lock
       where mgcad.empresa.ep-codigo = param-global.empresa-pri no-error.
    find param-b2c no-lock no-error.
    find para-fat no-lock no-error.
    find para-ped no-lock no-error.
    
    
    IF l-ativa-log THEN DO:
        OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
        PUT "espdp044 - Passo antes for each ttPedido " TODAY " " string(time,"HH:MM:SS") SKIP.
        OUTPUT CLOSE.
    END.
    
    pedvenda_blk:
    for each ttPedido no-lock,
       first ttCartao no-lock
          where ttCartao.LojaCodigo   = ttPedido.LojaCodigo
            and ttCartao.PedidoCodigo = ttPedido.PedidoCodigo
       by ttPedido.PedidoCodigo
       transaction on error undo pedvenda_blk, next pedvenda_blk:
        
        IF l-ativa-log THEN DO:
            OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
            PUT "espdp044 - Passo  2 " TODAY " " string(time,"HH:MM:SS") SKIP
                "Pedido " integer(ttPedido.PedidoCodigo) SKIP
                "Conta " integer(ttPedido.contaCodigo)  SKIP
                .
            OUTPUT CLOSE.
        END.
        
       /** Validaá‰es **/
       if not can-find(first ttItens
                       where ttItens.LojaCodigo     = ttPedido.LojaCodigo
                         and ttItens.PedidoCodigo   = ttPedido.PedidoCodigo
                         and ttItens.ItemCodigo    <> ''
                         and ttItens.CodigoInterno <> '') then do:
          run incluiMsgErro in this-procedure ('Pedido n∆o possui itens; pedido ignorado.').
          undo pedvenda_blk, next pedvenda_blk.
       end.
       

/*        IF (ttPedido.FormaPgto = 'Credito')  THEN DO:                                                                                                     */
/*            IF (ttCartao.CarTID <> '') AND ttCartao.CarOperadoraRetornoCodigo = '5' THEN DO:                                                              */
/*                RUN incluiMsgErro in this-procedure ('Pedido ' + string(ttPedido.PedidoCodigo) + ' cart∆o de crÇdito n∆o autorizado; pedido ignorado.').  */
/*                UNDO pedvenda_blk, next pedvenda_blk.                                                                                                     */
/*            END. /* IF (ttCartao.CarTID = '') AND ttCartao.CarOperadoraRetornoCodigo = 5 THEN DO: */                                                      */
/*        END. /* IF (ttPedido.FormaPgto = 'Credito')  THEN DO: */                                                                                          */

       /** Pedido j† existe? Adiciona CarTID e aprova se necess†rio **/
       FIND first int-ped-venda
                    where int-ped-venda.PedidoCodigo = integer(ttPedido.PedidoCodigo)
                      AND  int-ped-venda.contacodigo = integer(ttPedido.contaCodigo) EXCLUSIVE-LOCK no-error.

        IF l-ativa-log THEN DO:
            OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
            PUT "espdp044 - Passo  2aa " TODAY " " string(time,"HH:MM:SS") SKIP
                "Pedido " integer(ttPedido.PedidoCodigo) SKIP
                "Conta " integer(ttPedido.contaCodigo)  SKIP
                AVAIL int-ped-venda  SKIP
                ttPedido.PedidoStatus    SKIP
                ttPedido.FormaPgto
                .
            OUTPUT CLOSE.
        END.
       IF AVAIL int-ped-venda then do:

          assign l-cartid = no.
    
          if (ttPedido.FormaPgto = 'Credito')  then do:
             if (ttCartao.CarTID = '') then do:

                 IF l-ativa-log THEN DO:
                    OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                    PUT "espdp044 - sem CarTID " SKIP.
                    OUTPUT CLOSE.
                 END.

                run incluiMsgErro in this-procedure ('Pedido com pagamento confirmado, mas ainda sem CarTID.').
                next pedvenda_blk.
             end.
             else do:
                for each int-ped-venda exclusive-lock
                   where int-ped-venda.PedidoCodigo = integer(ttPedido.PedidoCodigo)
                    AND  int-ped-venda.contacodigo  = Integer(ttPedido.contaCodigo):
                   assign int-ped-venda.CarTID = ttCartao.CarTID
                          l-cartid             = yes.

                   IF l-ativa-log THEN DO:
                      OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                      PUT "espdp044 - Com CarTID " ttCartao.CarTID SKIP.
                      OUTPUT CLOSE.
                   END.

                end.
                FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
                RELEASE int-ped-venda.
             end.
          end.
          
          IF ttPedido.Texto1 <> "" AND ttPedido.Texto2 <> ""  THEN DO:
             /*Envia e-mail informando que foi realizado um novo
             pedido, e com a data de entrega agendada.*/
             run piEnviaEmailEntrega(INPUT "ems@intelbras.com.br",
                                     INPUT "Entrada de Pedido com Entrega Agendada",
                                     INPUT "grupo.ecommerce@intelbras.com.br",
                                     INPUT "Pedido: " + ttPedido.PedidoCodigo + CHR(13) + 
                                           "Cliente: " + ttPedido.PedidoCodigoCliente + CHR(13) +
                                           "Data escolhida para entrega: " + ttPedido.Texto2 + " per°odo: " + ttPedido.Texto1,
                                     INPUT "").
          END.
          
          if (l-cartid) then do:
             run atualizaGateway in this-procedure.
    
             /** Gambi **/
             for each int-ped-venda no-lock
                where int-ped-venda.PedidoCodigo = integer(ttPedido.PedidoCodigo)
                 AND  int-ped-venda.contacodigo  = integer(ttPedido.contaCodigo),
                each ped-venda no-lock
                   where ped-venda.nr-pedido = int-ped-venda.nr-pedido:
    
                empty temp-table tt-ped-venda.
    
                create tt-ped-venda.
                assign tt-ped-venda.nr-pedcli  = ped-venda.nr-pedcli
                       tt-ped-venda.nome-abrev = ped-venda.nome-abrev.
                
                create tt-ped-valid.
                assign tt-ped-valid.PedidoCodigo = ttPedido.PedidoCodigo
                       tt-ped-valid.contaCodigo  = ttPedido.contacodigo.

                IF l-ativa-log THEN DO:
                      OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                      PUT "espdp044 - Aprovando pedido " ped-venda.nr-pedcli SKIP.
                      OUTPUT CLOSE.
                END.

                run aprovaPedido in this-procedure.
                if (return-value = 'NOK') then
                    run incluiMsgErro in this-procedure ('Erro na aprovaá∆o do pedido. Aprovaá∆o deve ser feita manualmente.').
             end.
          end.
          else
             run incluiMsgErro in this-procedure ('Pedido j† existe no EMS! Ignorando.').
    
          /** N∆o precisa rodar toda a rotina de novo **/
          next pedvenda_blk.
       end. /* IF AVAIL int-ped-venda then do: */

       FIND first int-ped-venda
                    where int-ped-venda.PedidoCodigo = integer(ttPedido.PedidoCodigo)
                      AND  int-ped-venda.contacodigo = integer(ttPedido.contaCodigo) EXCLUSIVE-LOCK no-error.

       IF AVAIL int-ped-venda THEN DO:
          ASSIGN int-ped-venda.vl-frete = decimal(replace(replace(ttPedido.ValorFreteCobrado,'.',''),',','')) / 100.
    
          IF l-ativa-log THEN DO:
             OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
             PUT "espdp044 - Passo  3 " TODAY " " string(time,"HH:MM:SS") SKIP.
             OUTPUT CLOSE.
          END.
          
         ASSIGN de-vl-frete      = int-ped-venda.vl-frete
                de-vlr-ipi-frete = 0.
           
         IF int-ped-venda.vl-frete <> 0 THEN DO:
             FOR EACH ped-venda
                 WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido exclusive-lock:
    
                 ASSIGN de-total-vlr-ipi = 0
                        de-frete-total   = 0.
    
                 FOR EACH ped-item  OF ped-venda NO-LOCK:
                     ASSIGN de-total-vlr-ipi = de-total-vlr-ipi + ped-item.vl-preuni. /* utilizado para calculo do frete sem ipi */
                 END.
                 FOR EACH ped-item  OF ped-venda NO-LOCK:
                     ASSIGN de-percentual    = ped-item.vl-preuni / de-total-vlr-ipi
                            de-frete-do-item = de-vl-frete * de-percentual
                            de-frete-sem-ipi = de-frete-do-item / (1 + (ped-item.aliquota-ipi / 100))
                            de-frete-total   = de-frete-total + de-frete-sem-ipi.
         
                     IF l-ativa-log THEN DO:
                        OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                        PUT "espdp044 - Frete " de-frete-do-item SKIP.
                        OUTPUT CLOSE.
                     END.

                 END.
             END.
             
             ASSIGN de-vlr-ipi-frete         = de-vl-frete - de-frete-total.
          END.
        END.
       FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
       RELEASE int-ped-venda.
    
       IF l-ativa-log THEN DO:
           OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
           PUT "espdp044 - Passo  4 " TODAY " " string(time,"HH:MM:SS")  SKIP.
           OUTPUT CLOSE.
       END.
    
       /** Sald∆o? **/
       assign l-saldao = no.
    
       for each ttItens
          where ttItens.LojaCodigo   = ttPedido.LojaCodigo
            and ttItens.PedidoCodigo = ttPedido.PedidoCodigo
            and (index(ttItens.CodigoInterno,'S') <> 0 OR
                 index(ttItens.CodigoInterno,'p') <> 0):
          IF index(ttItens.CodigoInterno,'S') <> 0 THEN
              assign l-saldao = yes
                     ttItens.CodigoInterno = replace(ttItens.CodigoInterno, 'S', '').
          ELSE
              assign ttItens.CodigoInterno = replace(ttItens.CodigoInterno, 'P', '').
       end.
       IF l-ativa-log THEN DO:
           OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
           PUT "espdp044 - Passo  4a " SKIP.
           OUTPUT CLOSE.
       END.    
       /** Tarefa 3949 - Controle dos produtos compostos **/
       for each ttItens
          where ttItens.LojaCodigo     = ttPedido.LojaCodigo
            and ttItens.PedidoCodigo   = ttPedido.PedidoCodigo
            and ttItens.ItemCodigo    <> ''
            and ttItens.CodigoInterno <> ''
            AND ttItens.ItemMensagem  <> '*.*'
            and can-find(first prod-composto
                         where prod-composto.it-codigo-pai = ttItens.CodigoInterno):
    
           IF l-ativa-log THEN DO:
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "espdp044 - Passo  5 " TODAY " " string(time,"HH:MM:SS") " item " ttItens.CodigoInterno SKIP.
               OUTPUT CLOSE.
           END.
    
          ASSIGN l-pai-igual-filho     = NO
                 de-total-preco = 0.
    
          empty temp-table tt-preco-item.
          for each prod-composto no-lock
             where prod-composto.it-codigo-pai = ttItens.CodigoInterno:
    
             for each preco-item no-lock
                where preco-item.it-codigo = prod-composto.it-codigo-filho
                  and preco-item.nr-tabpre = 'B2C':
                 create tt-preco-item.
                 buffer-copy preco-item to tt-preco-item.
    
                 ASSIGN de-total-preco = de-total-preco + preco-item.preco-venda * prod-composto.qt-filho.
             end.
          end.
          IF CAN-FIND (FIRST prod-composto no-lock
             where prod-composto.it-codigo-pai = ttItens.CodigoInterno) THEN DO:
              find item-estab-b2c no-lock
                 where item-estab-b2c.it-codigo         = ttItens.CodigoInterno
                   and item-estab-b2c.ind-aceita-saldao = l-saldao no-error.
              if available (item-estab-b2c) then do:
                 IF item-estab-b2c.lg-item-pai-pedido = YES and
                    l-pai-igual-filho = no THEN DO:
                   find LAST preco-item no-lock
                        where preco-item.it-codigo = ttItens.CodigoInterno
                          and preco-item.nr-tabpre = 'B2C'
                           and preco-item.dt-inival <= today no-error.
         
                     if not avail preco-item then do:
                        run incluiMsgErro in this-procedure ('Produto Pai composto ' + ttItens.CodigoInterno + ' sem preáo ativo cadastrado.').
                        undo pedvenda_blk, next pedvenda_blk.
                     end.
                     ELSE 
                         for each preco-item no-lock
                            where preco-item.it-codigo = ttItens.CodigoInterno
                              and preco-item.nr-tabpre = 'B2C':
                             create tt-preco-item.
                             buffer-copy preco-item to tt-preco-item.
             
                             ASSIGN de-total-preco = de-total-preco + preco-item.preco-venda.
                         end.
                             
                 END.
    
              END.
          END.
    
          for each prod-composto no-lock
             where prod-composto.it-codigo-pai = ttItens.CodigoInterno:
    
             find last tt-preco-item no-lock
                 where tt-preco-item.it-codigo  = prod-composto.it-codigo-filho
                   and tt-preco-item.situacao   = 1
                   and tt-preco-item.dt-inival <= today no-error.
    
             if not avail tt-preco-item then do:
                run incluiMsgErro in this-procedure ('Item composto ' + prod-composto.it-codigo-filho + ' sem preáo ativo cadastrado.').
                undo pedvenda_blk, next pedvenda_blk.
             end.
          
             if not can-find (first b-ttItens
                              where b-ttItens.LojaCodigo    = ttItens.LojaCodigo
                                and b-ttItens.PedidoCodigo  = ttItens.PedidoCodigo
                                and b-ttItens.CodigoInterno = prod-composto.it-codigo-filho) then do:
    
    
                create b-ttItens.
                buffer-copy ttItens to b-ttItens.
                assign b-ttItens.ItemCodigo     = prod-composto.it-codigo-filho
                       b-ttItens.CodigoInterno  = prod-composto.it-codigo-filho
                       b-ttItens.ItemMensagem   = '*.*' /* Marca que foi criado por aqui para desconsiderar no for each */
    
                       de-qtde            = decimal(replace(replace(ttItens.ItemQtde, ",", ""),".", ","))
                       de-qtde            = de-qtde * prod-composto.qt-filho
                       b-ttItens.ItemQtde = left-trim(replace(string(de-qtde, ">>>>>>>>>>>9.999999"), ',', '.'))
    
                       de-itemvalor      = decimal(replace(replace(ttItens.ItemValor, ",", ""),".", ","))
                       de-itemvalorfinal = decimal(replace(replace(ttItens.ItemValorFinal, ",", ""),".", ","))
    
                       de-itemvalor             = (de-itemvalor * tt-preco-item.preco-venda) / de-total-preco
                       de-itemvalorfinal        = (de-itemvalorfinal * tt-preco-item.preco-venda) / de-total-preco
                       b-ttItens.ItemValor      = left-trim(replace(string(de-itemvalor, ">>>>>>>>>>>9.999999"), ',', '.'))
                       b-ttItens.ItemValorFinal = left-trim(replace(string(de-itemvalorfinal, ">>>>>>>>>>>9.999999"), ',', '.')).
             end.
             else do:
                /** Tarefa 36899: somar itens dos produtos compostos quando j† existirem na temp-table **/
    
                 find b-ttItens
                     where b-ttItens.LojaCodigo    = ttItens.LojaCodigo
                       and b-ttItens.PedidoCodigo  = ttItens.PedidoCodigo
                       and b-ttItens.CodigoInterno = prod-composto.it-codigo-filho no-error.
    
    
                 IF prod-composto.it-codigo-pai <> b-ttItens.CodigoInterno THEN DO:
                     assign de-qtde-existente  = decimal(replace(replace(b-ttItens.ItemQtde, ",", ""),".", ","))
                            de-qtde            = decimal(replace(replace(ttItens.ItemQtde, ",", ""),".", ","))
                            de-qtde            = de-qtde * prod-composto.qt-filho + de-qtde-existente
                            b-ttItens.ItemQtde = left-trim(replace(string(de-qtde, ">>>>>>>>>>>9.999999"), ',', '.'))

                            de-itemvalor      = decimal(replace(replace(ttItens.ItemValor, ",", ""),".", ","))
                            de-itemvalorfinal = decimal(replace(replace(ttItens.ItemValorFinal, ",", ""),".", ","))
                         
                            de-itemvalor             = (de-itemvalor * tt-preco-item.preco-venda) / de-total-preco
                            de-itemvalorfinal        = (de-itemvalorfinal * tt-preco-item.preco-venda) / de-total-preco
                            b-ttItens.ItemValor      = left-trim(replace(string(de-itemvalor, ">>>>>>>>>>>9.999999"), ',', '.'))
                            b-ttItens.ItemValorFinal = left-trim(replace(string(de-itemvalorfinal, ">>>>>>>>>>>9.999999"), ',', '.')).
                 END.
                 ELSE ASSIGN l-pai-igual-filho = YES.
             end.
          end.
    
    
    
          if available (item-estab-b2c) then do:
             IF item-estab-b2c.lg-item-pai-pedido = NO and
                l-pai-igual-filho = no THEN DO:
                 DELETE ttitens.
             END.
             ELSE DO:
                 IF item-estab-b2c.lg-item-pai-pedido = YES THEN DO:
                     find last tt-preco-item no-lock
                         where tt-preco-item.it-codigo  = ttItens.CodigoInterno
                           and tt-preco-item.situacao   = 1
                           and tt-preco-item.dt-inival <= today no-error.
    
                     assign de-itemvalor      = decimal(replace(replace(ttItens.ItemValor, ",", ""),".", ","))
                            de-itemvalorfinal = decimal(replace(replace(ttItens.ItemValorFinal, ",", ""),".", ","))
                         
                            de-itemvalor             = (de-itemvalor * tt-preco-item.preco-venda) / de-total-preco
                            de-itemvalorfinal        = (de-itemvalorfinal * tt-preco-item.preco-venda) / de-total-preco
                            ttItens.ItemValor      = left-trim(replace(string(de-itemvalor, ">>>>>>>>>>>9.999999"), ',', '.'))
                            ttItens.ItemValorFinal = left-trim(replace(string(de-itemvalorfinal, ">>>>>>>>>>>9.999999"), ',', '.')).
                 END.
    
             END.
    
          END.
       end.
    
       IF l-ativa-log THEN DO:
           OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
           PUT "espdp044 - Passo  5aa " TODAY " " string(time,"HH:MM:SS")  SKIP.
           OUTPUT CLOSE.
       END.

       /** Tratamento dos estabelecimentos **/
       empty temp-table ttEstabPedido.
    
       /** Validaá∆o do item x estab **/
       for each ttItens no-lock
          where ttItens.LojaCodigo     = ttPedido.LojaCodigo
            and ttItens.PedidoCodigo   = ttPedido.PedidoCodigo
            and ttItens.ItemCodigo    <> ''
            and ttItens.CodigoInterno <> '':

           IF l-ativa-log THEN DO:
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "espdp044 - Passo  5bb " ttitens.itemcodigo  SKIP.
               OUTPUT CLOSE.
           END.

    
          find item no-lock
             where item.it-codigo = ttItens.CodigoInterno no-error.
    
          if not available (item) then do:
             run incluiMsgErro in this-procedure ('Item ' + ttItens.CodigoInterno + ' inv†lido no pedido -- n∆o existe no EMS.').
             undo pedvenda_blk, next pedvenda_blk.
          end.
    
          find item-estab-b2c no-lock
             where item-estab-b2c.it-codigo         = item.it-codigo
               and item-estab-b2c.ind-aceita-saldao = l-saldao no-error.
    
          if not available (item-estab-b2c) then do:
             run incluiMsgErro in this-procedure ('Item ' + ttItens.CodigoInterno + ' inv†lido no pedido -- n∆o existe Item x Estab B2C.').
             undo pedvenda_blk, next pedvenda_blk.
          end.
    
          if not can-find(first ttEstabPedido where ttEstabPedido.cod-estabel = item-estab-b2c.cod-estabel) then do:
             create ttEstabPedido.
             assign ttEstabPedido.cod-estabel = item-estab-b2c.cod-estabel.
          end.
       end.


       IF l-ativa-log THEN DO:
           OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
           PUT "espdp044 - Passo  5cc "   SKIP.
           OUTPUT CLOSE.
       END.


       if not can-find(first ttEstabPedido) then do:
          run incluiMsgErro in this-procedure ('Problemas ao relacionar Establecimento aos itens do pedido.').
          undo pedvenda_blk, next pedvenda_blk.
       end.
    
       /** SeqÅencial para nr-pedcli **/
       assign iSeqPedEstab = 0.
    
       /** Controle dos juros **/
       assign i-qt-itens    = 0
              de-juro-total = 0.
    
       assign de-juro-total = decimal(replace(replace(ttPedido.ValorJuros, ",", ""),".", ",")).
       ASSIGN c-nome-transp = "".
    
       for each ttItens no-lock
           where ttItens.LojaCodigo     = ttPedido.LojaCodigo
             and ttItens.PedidoCodigo   = ttPedido.PedidoCodigo
             and ttItens.ItemCodigo    <> ''
             and ttItens.CodigoInterno <> '':
    
           assign i-qt-itens    = i-qt-itens + decimal(ttItens.ItemQtde)
                  c-atendente   = ''
                  i-prioridade  = 0
                  c-natureza-de = ''
                  c-natureza-fe = ''.
    
           for first ponto-programa no-lock
              where ponto-programa.nome-programa = "espdp044"
                 and ponto-programa.ponto        = 1,   /** Centrais Embratel **/
              each conteudo-programa no-lock
                 where conteudo-programa.cod-programa = ponto-programa.cod-programa
                   and entry(1,conteudo-programa.conteudo) = ttItens.CodigoInterno:
               assign c-atendente   = entry(2,conteudo-programa.conteudo)
                      i-prioridade  = int(entry(3,conteudo-programa.conteudo))
                      c-natureza-de = entry(4,conteudo-programa.conteudo)  /** Natureza dentro do estado **/
                      c-natureza-fe = entry(5,conteudo-programa.conteudo). /** Natureza fora do estado **/
           end.
           for first ponto-programa no-lock
              where ponto-programa.nome-programa = "espdp044"
                 and ponto-programa.ponto        = 2,   /** Centrais Embratel **/
              each conteudo-programa no-lock
                 where conteudo-programa.cod-programa = ponto-programa.cod-programa
                   and entry(1,conteudo-programa.conteudo) = ttItens.CodigoInterno:
               assign c-nome-transp   = entry(2,conteudo-programa.conteudo).
           end.
       end.
    
       IF l-ativa-log THEN DO:
           OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
           PUT "espdp044 - Passo  5dd "   SKIP.
           OUTPUT CLOSE.
       END.


       /** Criaá∆o dos pedidos por estabelecimento **/
       for each ttEstabPedido no-lock
          on error undo pedvenda_blk, next pedvenda_blk:

           IF l-ativa-log THEN DO:
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "espdp044 - Passo  5ee "   SKIP.
               OUTPUT CLOSE.
           END.
    
          assign d-vl-liq-abe     = 0
                 d-vl-liq-it      = 0
                 i-sequencia      = 0
                 c-desc-suspend   = ''
                 i-cont-nat-igual = 0
                 iSeqPedEstab     = iSeqPedEstab + 1.
    
          /** Limpa temp-tables para as BO's **/
          empty temp-table tt-ped-venda.
          empty temp-table tt-ped-item.
          empty temp-table tt-ped-ent.
          empty temp-table tt-ped-repre.
          empty temp-table tt-ped-antecip.
          empty temp-table tt-cond-ped.
          empty temp-table tt-ped-vendor.
    
          /** Sanity check **/
          find estabelec no-lock
             where estabelec.ep-codigo   = mgcad.empresa.ep-codigo
               and estabelec.cod-estabel = ttEstabPedido.cod-estabel no-error.
          
          if not available (estabelec) then do:
             run incluiMsgErro in this-procedure ('Problemas ao relacionar Empresa ' + string(mgcad.empresa.ep-codigo) + ' e Estabelecimento ' + ttEstabPedido.cod-estabel).
             undo pedvenda_blk, next pedvenda_blk.
          end.
               IF l-ativa-log THEN DO:
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "espdp044 - Passo  5ff "   SKIP.
               OUTPUT CLOSE.
           END.
          /** Relacionamento emitente x cliente Ikeda **/
          find int-emitente-b2c no-lock
             where int-emitente-b2c.ContaCodigo = ttPedido.ContaCodigo no-error.
    
          if not available (int-emitente-b2c) then do:
             run incluiMsgErro in this-procedure ('Relaá∆o entre Conta Ikeda e Cliente EMS n∆o cadastrada').
             undo pedvenda_blk, next pedvenda_blk.
          end.
    
          IF l-ativa-log THEN DO:
              OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
              PUT "espdp044 - Passo  5gg "   SKIP.
              OUTPUT CLOSE.
          END.

          FIND FIRST emitente EXCLUSIVE-LOCK
             where emitente.cod-emitente = int-emitente-b2c.cod-emitente no-error.
          IF NOT AVAIL emitente THEN DO:
              run incluiMsgErro in this-procedure ('Emitente inexistente: CPF/CNPJ ' + ttPedido.CPF + ttPedido.CNPJ).
              undo pedvenda_blk, next pedvenda_blk.
          END.
          ELSE DO:
              IF (emitente.cgc <> (ttPedido.CPF + ttPedido.CNPJ)) THEN DO:
                  run incluiMsgErro in this-procedure ('Emitente inexistente: CPF/CNPJ ' + ttPedido.CPF + ttPedido.CNPJ).
                  undo pedvenda_blk, next pedvenda_blk.
              END.
              ELSE DO:
                  assign emitente.ind-lib-estoque = YES.   
              END.
          END.
    
           IF l-ativa-log THEN DO:
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "espdp044 - Passo  5gg-b "   SKIP.
               OUTPUT CLOSE.
           END.
          
          /** Relacionamento parceiro Ikeda x representante **/
          find repres-parceiros no-lock
             where repres-parceiros.parceiro = ttPedido.ParceiroCodigo no-error.

          IF l-ativa-log THEN DO:                  
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "espdp044 - Passo  5gg_11 " AVAIL repres-parceiros  " "  ttPedido.ParceiroCodigo  " " AVAIL emitente " " int-emitente-b2c.cod-emitente SKIP.
               OUTPUT CLOSE.
           END.
    
          if available (repres-parceiros) then
              assign i-cod-rep = repres-parceiros.cod-rep.
          else do:
              run incluiMsgErro in this-procedure ('Parceiro ' + ttPedido.ParceiroCodigo + ' n∆o possui representante correspondente em repres-parceiros.').
              undo pedvenda_blk, next pedvenda_blk.
          end.
    

          IF l-ativa-log THEN DO:
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "espdp044 - Passo  5hh "   SKIP.
               OUTPUT CLOSE.
           END.
          find repres no-lock
             where repres.cod-rep = i-cod-rep no-error.
    
          if not available (repres) then do:
              run incluiMsgErro in this-procedure ('Representante ' + string(i-cod-rep) + ') n∆o cadastrado, relacionamento incorreto para o parceiro ' + ttPedido.ParceiroCodigo).
              undo pedvenda_blk, next pedvenda_blk.
          end.

           IF l-ativa-log THEN DO:
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "espdp044 - Passo  5ii"   SKIP.
               OUTPUT CLOSE.
           END.
    
           IF (integer(ttPedido.ParceiroCodigo) = 34 OR 
               integer(ttPedido.ParceiroCodigo) = 37 OR
               integer(ttPedido.ParceiroCodigo) = 42) THEN
                find transporte no-lock
                     where transporte.nome-abrev = "RETIRA" no-error.
          ELSE    
              IF c-nome-transp <> "" THEN
                  find transporte no-lock
                       where transporte.nome-abrev = c-nome-transp no-error.
              ELSE
                 if (estabelec.cod-estabel = '101' or estabelec.cod-estabel = '104') and 
                         ( 
                          (integer(ttPedido.ParceiroCodigo) = 2 OR 
                           integer(ttPedido.ParceiroCodigo) = 4) AND 
                           ttPedido.CEP >= '88010000' AND ttPedido.CEP <= '88190000'
                          ) then
                         find transporte no-lock
                            where transporte.nome-abrev = "RETIRA" no-error.
                      else
                          IF ttPedido.ServicoEntregaCodigo = '12' THEN
                             find transporte no-lock
                                where transporte.nome-abrev = "PAC" no-error.
                          ELSE
                              IF ttPedido.ServicoEntregaCodigo = '13' THEN
                                  find transporte no-lock
                                       where transporte.nome-abrev = "SEDEX" no-error.
                              ELSE
                                  IF ttPedido.ServicoEntregaCodigo = '5' THEN
                                      find transporte no-lock
                                           where transporte.nome-abrev = "RETIRA" no-error.
                                  ELSE
                                      find transporte no-lock
                                           where transporte.nome-abrev = "SEDEX" no-error.
    
               IF l-ativa-log THEN DO:
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "espdp044 - Passo  5jj "   SKIP.
               OUTPUT CLOSE.
           END.

    
          if not available (transporte) then do:
              run incluiMsgErro in this-procedure ('Transportador do cliente ' + string(emitente.cod-emitente) + ' n∆o cadastrado no local de entrega.').
              undo pedvenda_blk, next pedvenda_blk.
          end.
    
                     IF l-ativa-log THEN DO:
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "espdp044 - Passo  5kk "   SKIP.
               OUTPUT CLOSE.
           END.

          /** Condiá∆o de pagamento **/
          case ttPedido.FormaPgto:
              when 'Debito' then
                 assign i-cod-cond-pag = param-b2c.cond-pagto-deb /** ∑ Vista - dÇbito - transferencia bancaria**/
                        i-cod-sit-aval = 3. /** Aprovado **/
              when 'Credito' THEN DO:
                    IF  ttPedido.PedidoStatus <> "7" THEN
                        assign i-cod-cond-pag = 74 /*param-b2c.cond-pagto-cred*/ /** ∑ Vista - cart∆o */
                               i-cod-sit-aval = 1. /** N∆o Avaliado **/
                    ELSE
                        assign i-cod-cond-pag = 74 /*param-b2c.cond-pagto-cred*/ /** ∑ Vista - cart∆o */
                               i-cod-sit-aval = 3. /** Aprovado **/
              END.
              when 'Boleto' then
                 assign i-cod-cond-pag = param-b2c.cond-pagto-bol  /** ∑ Vista - boleto **/
                        i-cod-sit-aval = 4. /** N∆o aprovado, retÇm o pedido atÇ que seja feito o pagamento **/
              otherwise do:
                  run incluiMsgErro in this-procedure ('Tipo de cobranáa inv†lido: ' + ttPedido.FormaPgto).
                  undo pedvenda_blk, next pedvenda_blk.
              end.
          end case.
    
          find cond-pagto no-lock
             where cond-pagto.cod-cond-pag = i-cod-cond-pag no-error.
    
                     IF l-ativa-log THEN DO:
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "espdp044 - Passo  5ll "   SKIP.
               OUTPUT CLOSE.
           END.

          if not available (cond-pagto) then do:
              run incluiMsgErro in this-procedure ('Condiá∆o de pagamento ' + string(i-cod-cond-pag) + ' n∆o cadastrada.').
              undo pedvenda_blk, next pedvenda_blk.
          end.

                     IF l-ativa-log THEN DO:
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "espdp044 - Passo  5mm "   SKIP.
               OUTPUT CLOSE.
           END.
    
          /** Criaá∆o das temp-tables comeáa aqui **/
          create tt-ped-venda.
          assign tt-ped-venda.nr-pedido  = next-value(seq-nr-pedido)
                 tt-ped-venda.nome-abrev = emitente.nome-abrev
                 tt-ped-venda.nr-pedcli  = ttPedido.PedidoCodigo + '/' + string(iSeqPedEstab).
          
          if (l-saldao) then
             assign tt-ped-venda.nr-pedcli = trim(tt-ped-venda.nr-pedcli) + 'S'.
    
          /** Data de emiss∆o do pedido **/
          assign c-data  = entry(1, ttPedido.Data, ' ')
                 dt-data = date(integer(entry(2, c-data, '-')), integer(entry(3, c-data, '-')), integer(entry(1, c-data, '-'))) no-error.
    
          if (error-status:error) then
             assign dt-data = today.
    
          IF l-ativa-log THEN DO:
              OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
              PUT "espdp044 - Passo  6 " TODAY " " string(time,"HH:MM:SS") " Criando Pedido " string(tt-ped-venda.nr-pedido) SKIP.
              OUTPUT CLOSE.
          END.
          
          assign tt-ped-venda.cod-estabel             = estabelec.cod-estabel
                 tt-ped-venda.dt-emissao              = dt-data
                 tt-ped-venda.dt-entrega              = today
                 tt-ped-venda.dt-entorig              = today
                 tt-ped-venda.no-ab-reppri            = repres.nome-abrev
                 tt-ped-venda.dt-implant              = today
                 tt-ped-venda.nome-transp             = transporte.nome-abrev
                 tt-ped-venda.cod-emitente            = emitente.cod-emitente
                 tt-ped-venda.cod-cond-pag            = i-cod-cond-pag
                 tt-ped-venda.nr-tab-fin              = cond-pagto.nr-tab-finan
                 tt-ped-venda.nr-ind-finan            = cond-pagto.nr-ind-finan
              
                 tt-ped-venda.e-mail                  = emitente.e-mail
                 tt-ped-venda.cod-sit-aval            = i-cod-sit-aval
                 tt-ped-venda.mo-codigo               = param-b2c.cod-moeda-b2c
                 tt-ped-venda.cod-gr-cli              = emitente.cod-gr-cli
                 tt-ped-venda.tp-faturam              = 1
                 tt-ped-venda.origem                  = 12 /** 12-WEB **/
                 tt-ped-venda.atendido                = no
                 tt-ped-venda.cd-origem               = 1 /** 1-Usuario, 2-EDI, 3-Sistema **/
                 tt-ped-venda.user-impl               = 'adm'
                 tt-ped-venda.dt-userimp              = today
                 tt-ped-venda.tip-cob-desp            = para-fat.tip-cob-desp
                 tt-ped-venda.observacoes             = ttPedido.Observacao 
                 tt-ped-venda.cond-espec              = (IF ttPedido.Referencia <> '' THEN 'Referencia Endereáo: ' + ttPedido.Referencia ELSE '') + ' Pedido B2C. ' + (if (l-saldao) then
                     ' Produtos da loja saldao ,sao remanufaturados e estao sujeitos a pequenas avarias, riscos e danos externos. Esse produto nao possui garantia contratual.'
                                                                          else '')
                 tt-ped-venda.esp-ped                 = 1
                 tt-ped-venda.cod-priori              = 01
                 tt-ped-venda.cod-rota                = ''
                 tt-ped-venda.ind-ent-completa        = yes
                 tt-ped-venda.dsp-pre-fat             = yes
                 tt-ped-venda.log-usa-tabela-desconto = no
                 tt-ped-venda.ind-lib-nota            = para-ped.ind-lib-nota when available para-ped
                 tt-ped-venda.ind-fat-par             = no
                 tt-ped-venda.cod-portador            = 999
                 tt-ped-venda.modalidade              = 6.
           IF tt-ped-venda.nome-transp = "Retira" THEN
              ASSIGN OVERLAY(tt-ped-venda.char-2,109,8) = "9".
           ELSE
              ASSIGN OVERLAY(tt-ped-venda.char-2,109,8)   = "0".

           /*CASE INT(ttPedido.ParceiroCodigo):
               WHEN 52 THEN ASSIGN tt-ped-venda.tp-pedido = "32".
               WHEN 48 THEN ASSIGN tt-ped-venda.tp-pedido = "37".
               WHEN 34 THEN ASSIGN tt-ped-venda.tp-pedido = "80".
               WHEN 37 THEN ASSIGN tt-ped-venda.tp-pedido = "80".
               WHEN 38 THEN ASSIGN tt-ped-venda.tp-pedido = "80".
               WHEN 45 THEN ASSIGN tt-ped-venda.tp-pedido = "80".
               WHEN 57 THEN ASSIGN tt-ped-venda.tp-pedido = "45".
               WHEN 58 THEN ASSIGN tt-ped-venda.tp-pedido = "80".
               OTHERWISE ASSIGN tt-ped-venda.tp-pedido    = "".
           END CASE.*/

           RUN esp/es0018p.p (INPUT  "ESPDP044":U,
                       INPUT  3,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

           FIND FIRST tt-prog-ponto
                WHERE INT(ENTRY(1,tt-prog-ponto.conteudo,";")) = INT(ttPedido.ParceiroCodigo) NO-ERROR.
           IF AVAIL tt-prog-ponto THEN
               ASSIGN tt-ped-venda.tp-pedido = ENTRY(2,tt-prog-ponto.conteudo,";").
           ELSE
               ASSIGN tt-ped-venda.tp-pedido = "".

           IF tt-ped-venda.tp-pedido = "" THEN DO:
               ASSIGN tt-ped-venda.tp-pedido = (if (l-saldao) then "38" else "37"). /** Atendente **/
               IF tt-ped-venda.cod-estabel = "105" THEN
                   ASSIGN tt-ped-venda.nome-transp           = "IBL LOGIST02"
                          OVERLAY(tt-ped-venda.char-2,109,8) = "0".
           END.
                     
           IF l-ativa-log THEN DO:
               OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
               PUT "Pedido -2---->> " tt-ped-venda.nr-pedcli " " tt-ped-venda.nr-pedido " " tt-ped-venda.cod-priori SKIP.
               OUTPUT CLOSE.
           END.
    
          /** Tratamento do endereáo **/
          /** Busca do pa°s pelo c¢digo da Ikeda **/
          find int-pais-b2c no-lock
             where int-pais-b2c.cod-pais = int(ttPedido.Pais) no-error.
          
          if not avail (int-pais-b2c) then
             assign c-pais = ttPedido.Pais. 
          else
             assign c-pais = int-pais-b2c.nome-pais.
    
          assign c-endereco = (if ttPedido.TipoLogradouro = 'Nenhum' then '' else ttPedido.TipoLogradouro + ' ')
                               + ttPedido.Logradouro + ', '
                               + ttPedido.Numero + ' '
                               + ttPedido.Complemento
                 c-endereco = fn-free-accent(upper(trim(string(c-endereco))))
                 c-bairro   = fn-free-accent(upper(trim(string(ttPedido.Bairro, 'x(30)'))))
                 c-cidade   = fn-free-accent(upper(trim(string(ttPedido.Cidade, 'x(25)')))). 
    
          find first loc-entr no-lock use-index ch-entrega
             where loc-entr.nome-abrev = emitente.nome-abrev
               and loc-entr.endereco   = c-endereco
               and loc-entr.bairro     = c-bairro
               and loc-entr.cidade     = c-cidade
               and loc-entr.estado     = ttPedido.Estado
               and loc-entr.cep        = ttPedido.CEP
               and loc-entr.pais       = upper(c-pais)
               and loc-entr.cgc        = emitente.cgc no-error.
     
          if not available (loc-entr) then do:
             /** Passa a criar o local de entrega ao invÇs de mandar e-mail de inconsistància **/
             create loc-entr.
             assign loc-entr.nome-abrev            = emitente.nome-abrev
                    loc-entr.cod-entrega           = 'PD' + ttPedido.PedidoCodigo
                    loc-entr.endereco              = c-endereco
                    loc-entr.cidade                = c-cidade
                    loc-entr.bairro                = c-bairro
                    loc-entr.estado                = ttPedido.Estado
                    loc-entr.cep                   = ttPedido.CEP
                    loc-entr.pais                  = upper(c-pais)
                    loc-entr.cgc                   = emitente.cgc
                    loc-entr.ins-estadual          = emitente.ins-estadual
                    loc-entr.nome-transp = string(transporte.nome-abrev, 'x(12)')
                    loc-entr.nom-cidad-cif  = string(c-cidade, 'x(25)').  
          end.
    
          if (length(c-endereco) > 40) then do:
             find int-loc-entr exclusive-lock
                where int-loc-entr.nome-abrev  = emitente.nome-abrev
                  and int-loc-entr.cod-entrega = loc-entr.cod-entrega no-error.
            
             if not available (int-loc-entr) then do:
                create int-loc-entr.
                assign int-loc-entr.nome-abrev  = emitente.nome-abrev
                       int-loc-entr.cod-entrega = loc-entr.cod-entrega.
             end.
    
             assign int-loc-entr.endereco-completo = c-endereco.
            
             run incluiMsgErro in this-procedure ('Local de entrega do cliente maior que 40 caracteres, revise no CD0705. C¢d. emitente: ' + string(emitente.cod-emitente) + ', C¢d. Loc. Entr: ' + loc-entr.cod-entrega).
          end.
    
          assign tt-ped-venda.local-entreg = loc-entr.endereco
                 tt-ped-venda.bairro       = loc-entr.bairro
                 tt-ped-venda.cidade       = loc-entr.cidade
                 tt-ped-venda.pais         = loc-entr.pais
                 tt-ped-venda.estado       = loc-entr.estado
                 tt-ped-venda.cep          = loc-entr.cep
                 tt-ped-venda.caixa-postal = loc-entr.caixa-postal
                 tt-ped-venda.cgc          = loc-entr.cgc
                 tt-ped-venda.ins-estadual = loc-entr.ins-estadual
                 tt-ped-venda.cod-entrega  = loc-entr.cod-entrega
                 tt-ped-venda.cidade-cif   = loc-entr.cidade. 
                                                              /** Alterado porque um pedido entrou como FOB,
                                                                  pois o cadastro do cliente j† tinha o local de entrega
                                                                  com cidade-cif = '' **/
    
          IF l-ativa-log THEN DO:
              OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
              PUT "Pedido -2B ---->> " tt-ped-venda.nr-pedcli " Endereco " tt-ped-venda.local-entreg SKIP.
              PUT "Pedido -2B ---->> ttEstabPedido.cod-estabel " ttEstabPedido.cod-estabel SKIP.
              PUT "Pedido -2B ---->> emitente.cod-emitente " + STRING(emitente.cod-emitente) SKIP.
              PUT "Pedido -2B ---->> loc-entr.cod-entrega " loc-entr.cod-entrega SKIP.
              PUT "Pedido -2B ---->>  ttPedido.PedidoCodigo " ttPedido.PedidoCodigo SKIP.
              OUTPUT CLOSE.
          END.

          IF emitente.contrib-icms = YES THEN 
              ASSIGN l-consumidor-final = NO.
          ELSE 
              ASSIGN l-consumidor-final = YES.

          /** Tratamento para natureza de operaá∆o **/
          run defineNatOperacao in h-boes505 (input ttEstabPedido.cod-estabel,
                                             input emitente.cod-emitente,
                                             input loc-entr.cod-entrega,
                                             input '',
                                             input l-consumidor-final,
                                             output c-natureza,
                                             output l-return).
          if not (l-return) then do:
             run incluiMsgErro in this-procedure ('Natureza de operaá∆o n∆o cadastrada para cliente ' + string(emitente.cod-emitente)).
             undo pedvenda_blk, next pedvenda_blk.
          end.
    
          find natur-oper no-lock
             where natur-oper.nat-operacao = c-natureza no-error.
    
          if not available (natur-oper) then do:
              run incluiMsgErro in this-procedure ('Natureza de operaá∆o ' + c-natureza + ' n∆o encontrada; pedido do cliente ' + string(emitente.cod-emitente)).
              undo pedvenda_blk, next pedvenda_blk.
          end.
    
          assign c-nat-oper                   = natur-oper.nat-operacao
                 c-nat-oper-cabecalho         = natur-oper.nat-operacao
                 l-mantem-nat                 = no
                 tt-ped-venda.nat-operacao    = natur-oper.nat-operacao
                 tt-ped-venda.cod-mensagem    = natur-oper.cod-mensagem
                 tt-ped-venda.cod-canal-venda = (if (natur-oper.cod-canal-venda <> 0) then natur-oper.cod-canal-venda else emitente.cod-canal-venda)
                 tt-ped-venda.cod-des-merc    = (if (natur-oper.consum-final) then 2 else 1).
    
          IF l-ativa-log THEN DO:
              OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
              PUT "Pedido -2C ---->> " tt-ped-venda.nr-pedcli " NatOp " tt-ped-venda.nat-operacao SKIP.
              OUTPUT CLOSE.
          END.
          /** Representantes do pedido **/
          if not can-find (first tt-ped-repre
                           where tt-ped-repre.nr-pedido   = tt-ped-venda.nr-pedido
                             and tt-ped-repre.nome-ab-rep = repres.nome-abrev) then do:
             create tt-ped-repre.
             assign tt-ped-repre.nr-pedido   = tt-ped-venda.nr-pedido
                    tt-ped-repre.ind-repbase = yes
                    tt-ped-repre.perc-comis  = 0
                    tt-ped-repre.nome-ab-rep = repres.nome-abrev.
          end.
    
          /** TAREFA 37145: C†lculo de desconto para pedido **/
          assign d-vl-sub-total = decimal(replace(replace(ttPedido.ValorSubTotal, ',', ''),'.', ','))
                 d-vl-ValorTotal  = decimal(replace(replace(ttPedido.ValorTotal, ',', ''),'.', ','))  /* mudou em 15/04/15 n∆o Ç mais informado o valor ValorTotal mas sim o valor total */
                 d-vl-desconto  = (1 - (d-vl-ValorTotal / d-vl-sub-total)) * 100.

          
    
/*           if (d-vl-desconto > 0) then                                                              */
/*              assign tt-ped-venda.des-pct-desconto-inform = trim(string(d-vl-desconto, ">9.9999")). */
/*                                                                                                    */

/*           Foi retirado porque:                                                                                                                                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                                                                                                                       */
/*           Vinicius Guimaraes (Suporte Rakuten)                                                                                                                                                                                                                                                                                                        */
/*             15 de abr 10:15                                                                                                                                                                                                                                                                                                                           */
/*             Anderson,                                                                                                                                                                                                                                                                                                                                 */
/*             Conforme conversamos, a tag do XML                                                                                                                                                                                                                                                                                                        */
/*             <ValorValorTotal></ValorValorTotal> s¢ Ç preenchida quando o cliente utiliza crÇditos no site da Intelbras e por isso n∆o ser† preenchida em todos os pedidos. Antigamente, n¢s pass†vamos o valor cheio do pedido nesse campo, porÇm foi mudado porque o funcionamento correto era preencher apenas quando tivesse o uso do crÇdito no site. */



          /** Criaá∆o dos itens do pedido **/
          for each ttItens no-lock
              where ttItens.LojaCodigo     = ttPedido.LojaCodigo
                and ttItens.PedidoCodigo   = ttPedido.PedidoCodigo
                and ttItens.ItemCodigo    <> ''
                and ttItens.CodigoInterno <> '',
             first item-estab-b2c no-lock
                where item-estab-b2c.cod-estabel       = ttEstabPedido.cod-estabel
                  and item-estab-b2c.it-codigo         = ttItens.CodigoInterno
                  and item-estab-b2c.ind-aceita-saldao = l-saldao,
             first item no-lock
                where item.it-codigo = item-estab-b2c.it-codigo:
    
             if can-find(first tt-ped-item
                         where tt-ped-item.nome-abrev = tt-ped-venda.nome-abrev
                           and tt-ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli
                           and tt-ped-item.it-codigo  = item.it-codigo) then
                next.

             IF emitente.contrib-icms = YES THEN 
                 ASSIGN l-consumidor-final = NO.
             ELSE 
                 ASSIGN l-consumidor-final = YES.
    
             /** Natureza de operaá∆o do item **/
             run defineNatOperacao in h-boes505 (input ttEstabPedido.cod-estabel,
                                                 input emitente.cod-emitente,
                                                 input loc-entr.cod-entrega,
                                                 input item.it-codigo,
                                                 input l-consumidor-final,
                                                 output c-nat-oper,
                                                 output l-return).
    
             IF l-ativa-log THEN DO:
                 OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                 PUT "espdp044 - Passo  7 " TODAY " " string(time,"HH:MM:SS") " Criando Item " SKIP.
                 OUTPUT CLOSE.
             END.
    
             if not (l-return) then do:
                run incluiMsgErro in this-procedure ('Natureza de operaá∆o nao encontrada para cliente ' + string(emitente.cod-emitente)).
                undo pedvenda_blk, next pedvenda_blk.
             end.
    
             find natur-oper no-lock 
                where natur-oper.nat-operacao = c-nat-oper no-error.
    
             if (c-nat-oper-cabecalho = c-nat-oper) then
                assign i-cont-nat-igual = i-cont-nat-igual + 1.
    
             if not available (natur-oper) then do:
                run incluiMsgErro in this-procedure ('Natureza de operaá∆o ' + c-nat-oper + ' inv†lida ou n∆o cadastrada no cliente ' + string(emitente.cod-emitente)).
                undo pedvenda_blk, next pedvenda_blk.
             end.
    
             IF l-ativa-log THEN DO:
                 OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                 PUT "espdp044 - Passo  8 " TODAY " " string(time,"HH:MM:SS") " Criando Item " item.it-codigo SKIP.
                 OUTPUT CLOSE.
             END.
/** ***********************************************************************/
/** ***********************************************************************/
/** ***********    M U I T O   I M P O R T A N T E    *********************/
/** ***********************************************************************/
/** ***********************************************************************/
/** ** O assign ABAIXO NAO PODE SER ALTERADO. TEM QUE FICAR 2 ASSIGNS,   **/
/** ** POIS O DISPARO DAS TRIGGERS TEM QUE SER NESTA SEQUENCIA.          **/
/** ** QUANTO EH DADO O CREATE DO tt-ped-item, O SISTEMA JA GRAVA NA DATA DE**/
/** ** ENTREGA O DATA CORRENTE E QDO A DATA DE ENTREGA EH DE MES DIFERENTE */
/** ** A TRIGGER DIMINUI A QTDE DO MES ANTERIOR E SOMA NO MES CORRETO   ***/
/** ***********************************************************************/
/** ***********************************************************************/
/** ***********************************************************************/
/** ********************************************************************** */
             
             create tt-ped-item.
             assign tt-ped-item.aliquota-ipi            = item.aliquota-ipi
                    tt-ped-item.nr-pedcli               = tt-ped-venda.nr-pedcli
                    tt-ped-item.cod-entrega             = tt-ped-venda.cod-entrega
                    tt-ped-item.dt-entrega              = tt-ped-venda.dt-entrega
                    overlay(tt-ped-item.char-2,1,8)     = item.class-fiscal
                    tt-ped-item.qt-pedida               = decimal(replace(replace(ttItens.ItemQtde, ',', ''),'.', ','))
                    tt-ped-item.qt-un-fat               = tt-ped-item.qt-pedida
                    tt-ped-item.cod-sit-item            = tt-ped-venda.cod-sit-ped
                    tt-ped-item.cod-sit-pre             = tt-ped-venda.cod-sit-pre
                    tt-ped-item.dt-entorig              = tt-ped-venda.dt-entorig
                    tt-ped-item.dt-userimp              = tt-ped-venda.dt-userimp
                    tt-ped-item.esp-ped                 = 1
                    tt-ped-item.it-codigo               = item.it-codigo
                    tt-ped-item.nat-operacao            = natur-oper.nat-operacao
                    tt-ped-item.nome-abrev              = tt-ped-venda.nome-abrev
                    tt-ped-item.per-des-icms            = natur-oper.per-des-icms
                    tt-ped-item.tp-adm-lote             = 1
                    tt-ped-item.tp-preco                = 0
                    tt-ped-item.user-impl               = tt-ped-venda.user-impl
                    tt-ped-item.log-usa-tabela-desconto = no
                    tt-ped-item.observacao              = IF ttItens.ItemMensagem  = '*.*' THEN "" ELSE ttItens.ItemMensagem
                    tt-ped-item.observacao              = tt-ped-item.observacao + ";" + ttItens.ItemNome
                    tt-ped-item.per-minfat              = (if available (emitente) then emitente.per-minfat else tt-ped-item.per-minfat)
                    tt-ped-item.cd-origem               = 2
                    tt-ped-item.tipo-atend              = (if (tt-ped-venda.ind-fat-par) then 2 else 1)
                    tt-ped-item.cod-unid-negoc          = ITEM.cod-unid-negoc
                    tt-ped-item.des-un-medida           = ITEM.un.
                    
/*              IF l-ativa-log THEN DO:                                                                     */
/*                  OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.                         */
/*                  PUT "espdp044 - Passo  8A "                                                             */
/*                      " tt-ped-item.aliquota-ipi             "  tt-ped-item.aliquota-ipi             skip */
/*                      " tt-ped-item.nr-pedcli                "  tt-ped-item.nr-pedcli                skip */
/*                      " tt-ped-item.cod-entrega              "  tt-ped-item.cod-entrega              skip */
/*                      " tt-ped-item.dt-entrega               "  tt-ped-item.dt-entrega               skip */
/*                      " overlay(tt-ped-item.char-2,1,8)      "  SUBSTRING(tt-ped-item.char-2,1,8)    skip */
/*                      " tt-ped-item.qt-pedida                "  tt-ped-item.qt-pedida                skip */
/*                      " tt-ped-item.qt-un-fat                "  tt-ped-item.qt-un-fat                skip */
/*                      " tt-ped-item.cod-sit-item             "  tt-ped-item.cod-sit-item             skip */
/*                      " tt-ped-item.cod-sit-pre              "  tt-ped-item.cod-sit-pre              skip */
/*                      " tt-ped-item.dt-entorig               "  tt-ped-item.dt-entorig               skip */
/*                      " tt-ped-item.dt-userimp               "  tt-ped-item.dt-userimp               skip */
/*                      " tt-ped-item.esp-ped                  "  tt-ped-item.esp-ped                  skip */
/*                      " tt-ped-item.it-codigo                "  tt-ped-item.it-codigo                skip */
/*                      " tt-ped-item.nat-operacao             "  tt-ped-item.nat-operacao             skip */
/*                      " tt-ped-item.nome-abrev               "  tt-ped-item.nome-abrev               skip */
/*                      " tt-ped-item.per-des-icms             "  tt-ped-item.per-des-icms             skip */
/*                      " tt-ped-item.tp-adm-lote              "  tt-ped-item.tp-adm-lote              skip */
/*                      " tt-ped-item.tp-preco                 "  tt-ped-item.tp-preco                 skip */
/*                      " tt-ped-item.user-impl                "  tt-ped-item.user-impl                skip */
/*                      " tt-ped-item.log-usa-tabela-desconto  "  tt-ped-item.log-usa-tabela-desconto  skip */
/*                      " tt-ped-item.observacao               "  tt-ped-item.observacao               skip */
/*                      " tt-ped-item.observacao               "  tt-ped-item.observacao               skip */
/*                      " tt-ped-item.per-minfat               "  tt-ped-item.per-minfat               skip */
/*                      " tt-ped-item.cd-origem                "  tt-ped-item.cd-origem                skip */
/*                      " tt-ped-item.tipo-atend               "  tt-ped-item.tipo-atend               skip */
/*                      " tt-ped-item.cod-unid-negoc           "  tt-ped-item.cod-unid-negoc           skip */
/*                      " tt-ped-item.des-un-medida            "  tt-ped-item.des-un-medida                 */
/*                      SKIP.                                                                               */
/*                  OUTPUT CLOSE.                                                                           */
/*              END.                                                                                        */

             /*Verifica item 4994663, e envia e-mail avisando.*/
             IF tt-ped-item.it-codigo = '4994663' THEN DO:
                
                                
                run piEnviaEmailEntrega(INPUT "ems@intelbras.com.br",
                                        INPUT "Pedido com item 4994663 realizado.",
                                        INPUT "grupo.ecommerce@intelbras.com.br",
                                        INPUT "Pedido: " + tt-ped-venda.nr-pedcli + " realizado, possui o item 4994663.",
                                        INPUT "").
              
             END.
    
             if (c-atendente <> '') and (i-prioridade <> 0) and (c-natureza-de <> '') and (c-natureza-fe <> '') then do:
                if (estabelec.estado = emitente.estado) then
                   assign tt-ped-item.nat-operacao = c-natureza-de.
                else
                   assign tt-ped-item.nat-operacao = c-natureza-fe. 
             end.
    
             if (item.tipo-contr = 4) then
                assign overlay(tt-ped-item.char-2,09,02) = item.un.
    
             /** C†lculo do preáo **/
             assign de-vl-preco = decimal(replace(replace(ttItens.ItemValorFinal, ',', ''),'.', ',')). /** Valor com IPI **/
    
             /** Soma juro **/
             assign de-vl-preco = de-vl-preco + (de-juro-total / i-qt-itens).
    
             /*** TRATAMENTO IPI ** */
             if (item.cd-trib-ipi = 1) and /** tributado **/ ((natur-oper.cd-trib-ipi = 1) /** tributado **/ or (natur-oper.cd-trib-ipi = 4) /** reduzido **/) then
                assign de-vl-pre-liq = de-vl-preco / (1 + (tt-ped-item.aliquota-ipi / 100)).
             else
                assign de-vl-pre-liq = de-vl-preco.
    
             /** assign separado por causa da trigger **/
             assign tt-ped-item.vl-pretab = de-vl-pre-liq
                    tt-ped-item.vl-preori = de-vl-pre-liq

                    tt-ped-item.vl-preuni = de-vl-pre-liq
             /* AQUI - estevan
             ver se os campos est∆o sendo gravados certos na tt-ped-item, pois a soma total dos itens
             n∆o est† batendo com o valor quando o pedido Ç efetivado...
             no exemplo do pedido 107080:
             item A: qtd = 2 vl unit = 10
             item B: qtd = 1 vl unit = 10
             
             quando calcula o pedido, est† ficando com 30 reais... ou seja, 20 reais do item A e 10 do item B..
             mas o total apresentado aqui no programa Ç 20 reais... parece que 10 reais do item A e 10 do Item B
             */
    
                    tt-ped-item.vl-liq-abe = de-vl-pre-liq
                    tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
                    tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
                    tt-ped-item.vl-liq-abe  = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
                    OVERLAY(tt-ped-item.char-2,56,5) = string(ITEM.cod-servico).
    
             /** Substituiá∆o tribut†ria **/
             find unid-feder no-lock
                where unid-feder.pais   = emitente.pais
                  and unid-feder.estado = emitente.estado no-error.
    
             if (emitente.contrib-icms) and available (unid-feder) and (unid-feder.ind-uf-subs) then do:
                find item-uf no-lock
                   where item-uf.it-codigo       = item.it-codigo
                     and item-uf.cod-estado-orig = estabelec.estado
                     and item-uf.estado          = emitente.estado no-error.
    
                find dist-emitente of emitente no-lock no-error.
    
                if (natur-oper.subs-trib) and available (item-uf) and available (dist-emitente) and (dist-emitente.nr-tb-pauta = '') and (emitente.insc-subs-trib = '') then
                   assign tt-ped-item.ind-icm-ret = yes.
             end.
    
             assign i-sequencia              = i-sequencia + 10
                    tt-ped-item.nr-sequencia = i-sequencia.
    
             create tt-ped-ent.
             assign tt-ped-ent.nr-pedcli    = tt-ped-item.nr-pedcli
                    tt-ped-ent.cod-sit-ent  = tt-ped-item.cod-sit-item
                    tt-ped-ent.cod-sit-pre  = tt-ped-item.cod-sit-pre
                    tt-ped-ent.dt-entorig   = tt-ped-item.dt-entorig
                    tt-ped-ent.dt-entrega   = tt-ped-item.dt-entrega
                    tt-ped-ent.dt-userimp   = tt-ped-item.dt-userimp
                    tt-ped-ent.it-codigo    = tt-ped-item.it-codigo
                    tt-ped-ent.nome-abrev   = tt-ped-item.nome-abrev
                    tt-ped-ent.qt-pedida    = tt-ped-item.qt-pedida
                    tt-ped-ent.user-impl    = tt-ped-item.user-impl
                    tt-ped-ent.vl-liq-it    = tt-ped-item.vl-liq-it
                    tt-ped-ent.nr-sequencia = tt-ped-item.nr-sequencia
                    tt-ped-ent.vl-liq-abe   = tt-ped-item.vl-liq-abe.
    
             /** Acumula valores totais do pedido **/
             assign d-vl-liq-it  = d-vl-liq-it  + tt-ped-item.vl-liq-it
                    d-vl-liq-abe = d-vl-liq-abe + tt-ped-item.vl-liq-abe.
          end.
    
          /** Valida classificaá∆o fiscal **/
          for each tt-ped-item no-lock,
             first item no-lock where item.it-codigo = tt-ped-item.it-codigo:
    
             if (item.class-fisc = '') or not can-find(first classif-fisc
                                                       where classif-fisc.class-fiscal = item.class-fisc) then do:
                run incluiMsgErro in this-procedure ('Item ' + tt-ped-item.it-codigo + ' sem classificaá∆o fiscal cadastrada.').
                undo pedvenda_blk, next pedvenda_blk.
             end.
          end.
    
    
          /** Valida naturezas dos itens. Se n∆o h† nenhuma igual Ö do cabeáalho do pedido, altera o cabeáalho do pedido **/
          if (i-cont-nat-igual = 0) then
             assign tt-ped-venda.nat-operacao = c-nat-oper.
    
          if (c-atendente <> '') and (i-prioridade <> 0) and (c-natureza-de <> '') and (c-natureza-fe <> '') then do:
             assign tt-ped-venda.tp-pedido  = c-atendente   
                    tt-ped-venda.cod-priori = i-prioridade.
             
             if (estabelec.estado = emitente.estado) then
                assign tt-ped-venda.nat-operacao = c-natureza-de.
             else
                assign tt-ped-venda.nat-operacao = c-natureza-fe. 
          end.
    
          IF l-ativa-log THEN DO:
              OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
              PUT "Pedido -3- -----> " tt-ped-venda.nr-pedcli " " tt-ped-venda.cod-priori SKIP.
              OUTPUT CLOSE.
          END.
          
    
          /** Totaliza pedido **/
          assign tt-ped-venda.vl-tot-ped = d-vl-liq-abe
                 tt-ped-venda.vl-liq-abe = d-vl-liq-abe
                 tt-ped-venda.vl-mer-abe = d-vl-liq-it
                 tt-ped-venda.vl-liq-ped = d-vl-liq-it.
    
          /** Efetiva pedido no EMS **/
    
          IF l-ativa-log THEN DO:
             OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
             PUT "espdp044 - Passo  9 " TODAY " " string(time,"HH:MM:SS") " Antes executar bo " SKIP.
             OUTPUT CLOSE.
          END.
    
          run pi-executar-bos.
    
          IF l-ativa-log THEN DO:
              OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
              PUT "espdp044 - Passo  10 " TODAY " " string(time,"HH:MM:SS") " Apos executar bo " RETURN-VALUE SKIP.
              OUTPUT CLOSE.
          END.
    
          if (return-value = 'NOK') THEN DO:
              IF l-ativa-log THEN DO:
                  OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                  PUT "espdp044 - Passo  10--- " TODAY " " string(time,"HH:MM:SS") " Apos executar bo e encontrar erro " RETURN-VALUE SKIP.
                  OUTPUT CLOSE.
              END.
              undo pedvenda_blk, next pedvenda_blk.
          END.
    
          /*********************************************************************************
          **  Prop¢sito:  Alocar Licenáa Softphone na implantaá∆o do pedido.
          **  Autor:      Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
          **  Criaá∆o:    Junho de 2012
          **********************************************************************************/
          /****************************************
          **  Validaá∆o Licenáa Softphone - In°cio
          *****************************************/
          FOR FIRST ped-venda NO-LOCK
              WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido,
              EACH ped-item OF ped-venda NO-LOCK:


              FIND FIRST int-licenca-softphone
                  WHERE int-licenca-softphone.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
    
              IF AVAILABLE int-licenca-softphone THEN DO:
                  DO i-quant-licenca = 1 TO ped-item.qt-pedida:
                      FIND FIRST int-licenca-softphone
                          WHERE int-licenca-softphone.it-codigo   = ped-item.it-codigo
                            AND int-licenca-softphone.nome-abrev  = "":U
                            AND int-licenca-softphone.nr-pedcli   = "":U
                            AND int-licenca-softphone.cod-estabel = "":U
                            AND int-licenca-softphone.serie       = "":U
                            AND int-licenca-softphone.nr-nota-fis = "":U EXCLUSIVE-LOCK NO-ERROR.
    
                      IF NOT AVAILABLE int-licenca-softphone THEN DO:
                          RUN incluiMsgErro IN THIS-PROCEDURE (INPUT "Licenáa do Softphone indispon°vel para atender o pedido.":U).
    
                          UNDO pedvenda_blk, NEXT pedvenda_blk.
                      END. /* IF NOT AVAILABLE int-licenca-softphone THEN DO: */
    
                      ASSIGN int-licenca-softphone.nome-abrev = ped-venda.nome-abrev
                             int-licenca-softphone.nr-pedcli  = ped-venda.nr-pedcli.
                  END. /* DO i-quant-licenca = 1 TO ped-item.qt-pedida: */
              END. /* IF AVAILABLE int-licenca-softphone THEN DO: */
          END. /* FOR FIRST ped-venda NO-LOCK */
          /****************************************
          **  Validaá∆o Licenáa Softphone - Final
          *****************************************/
    
          /** Gravou certo, armazena os campos extra do pedido na int-ped-venda **/
          assign c-data  = entry(1, ttPedido.SedexData, ' ')
                 dt-data = date(integer(entry(2, c-data, '-')), integer(entry(3, c-data, '-')), integer(entry(1, c-data, '-'))) no-error.
    
          if (error-status:error) then
             assign dt-data = today.
    
          find int-ped-venda exclusive-lock
             where int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido no-error.
    
          if not available (int-ped-venda) then do:
              create int-ped-venda.
              assign int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido.
          end.
    
          assign int-ped-venda.cod-estabel            = estabelec.cod-estabel
                 int-ped-venda.PedidoCodigo           = integer(ttPedido.PedidoCodigo)
                 int-ped-venda.LojaCodigo             = integer(ttPedido.LojaCodigo)
                 int-ped-venda.UsuarioCodigo          = integer(ttPedido.UsuarioCodigo)
                 int-ped-venda.ContaCodigo            = integer(ttPedido.ContaCodigo)
                 int-ped-venda.ContaCorrenteCodigo    = ttPedido.ContaCorrenteCodigo
                 int-ped-venda.GrupoCodigo            = integer(ttPedido.GrupoCodigo)
                 int-ped-venda.CupomCodigo            = integer(ttPedido.CupomCodigo)
                 int-ped-venda.ParceiroCodigo         = integer(ttPedido.ParceiroCodigo)
                 /*int-ped-venda.FornecedorCodigo       = integer(ttPedido.FornecedorCodigo)*/ /** REMOVIDO NA LOJA NOVA **/
                 /*int-ped-venda.CategoriaCodigo        = integer(ttPedido.CategoriaCodigo)*/ /** REMOVIDO NA LOJA NOVA **/
                 int-ped-venda.VitrineCodigo          = integer(ttPedido.VitrineCodigo)
                 /*int-ped-venda.PromocaoGCodigo        = integer(ttPedido.PromocaoGCodigo)*/ /** REMOVIDO NA LOJA NOVA **/
                 /*int-ped-venda.PromocaoPCodigo        = integer(ttPedido.PromocaoPCodigo)*/ /** REMOVIDO NA LOJA NOVA **/
                 int-ped-venda.ParcelamentoGCodigo    = integer(ttPedido.ParcelamentoGCodigo)
                 int-ped-venda.ParcelamentoPCodigo    = integer(ttPedido.ParcelamentoPCodigo)
                 int-ped-venda.ServicoEntregaCodigo   = integer(ttPedido.ServicoEntregaCodigo)
                 int-ped-venda.nr-parcelas            = integer(ttPedido.QtdeParcelas)
                 int-ped-venda.Score                  = integer(ttPedido.Score)
                 int-ped-venda.CestaCodigo            = ttPedido.CestaCodigo
                 int-ped-venda.CestaMensagem          = ttPedido.CestaMensagem
                 int-ped-venda.Sedex                  = ttPedido.Sedex
                 int-ped-venda.SedexData              = dt-data
                 int-ped-venda.MotivoCancel           = ttPedido.MotivoCancel
                 int-ped-venda.Desconto               = decimal(replace(replace(ttPedido.Desconto,'.',''),',','')) / 100
                 int-ped-venda.FormaPgto              = ttPedido.FormaPgto
                 int-ped-venda.ValorSubTotal          = decimal(replace(replace(ttPedido.ValorSubTotal,'.',''),',','')) / 100
                 int-ped-venda.ValorParcela           = decimal(replace(replace(ttPedido.ValorParcela,'.',''),',','')) / 100
                 int-ped-venda.ValorJuros             = decimal(replace(replace(ttPedido.ValorJuros,'.',''),',','')) / 100
                 int-ped-venda.Mensagem               = ttPedido.Mensagem
                 int-ped-venda.ValorFrete             = decimal(replace(replace(ttPedido.ValorFrete,'.',''),',','')) / 100
                 int-ped-venda.ValorPresente          = decimal(replace(replace(ttPedido.ValorPresente,'.',''),',','')) / 100
                 int-ped-venda.PedidoStatus           = ttPedido.PedidoStatus
                 int-ped-venda.StatusIntegracao       = ttPedido.StatusIntegracao
                 int-ped-venda.StatusClearSale        = ttPedido.StatusClearSale
                 int-ped-venda.AvisoBoleto            = ttPedido.AvisoBoleto
                 int-ped-venda.FreteGratis            = ttPedido.FreteGratis
                 int-ped-venda.ValorVale              = decimal(replace(replace(ttPedido.ValorVale,'.',''),',','')) / 100
/*                  int-ped-venda.ValorValorTotal          = decimal(replace(replace(ttPedido.ValorValorTotal,'.',''),',','')) / 100 */
                 /*int-ped-venda.ContaCorrenteTipo      = ttPedido.ContaCorrenteTipo.*/ /** REMOVIDO NA LOJA NOVA **/
                 int-ped-venda.vl-frete               = decimal(replace(replace(ttPedido.ValorFreteCobrado,'.',''),',','')) / 100
                 overlay(int-ped-venda.char-1,26,15)  = ttpedido.CpfCnpjOrigem.
    
          ASSIGN ttPedido.ValorFreteCobrado = "0".
    
          IF emitente.cod-gr-cli = 8 THEN do:
             IF tt-ped-venda.cgc <> ttpedido.CpfCnpjOrigem THEN DO:
                  RUN piEnviaEmail (INPUT "Pedido com CNPJ/CPF diferente do Origem",
                                    INPUT "Prezado, " + chr(13) + chr(10) +
                                          "Compra do Cliente " + 
                                           emitente.nome-emit + 
                                           "(" + 
                                           STRING(emitente.cod-emitente) + 
                                           ")" + 
                                           " CNPJ/CPF " + 
                                           tt-ped-venda.cgc + 
                                           " diferente do CNPJ/CPF origem: " + 
                                           ttpedido.CpfCnpjOrigem +
                                           "Pedido " + 
                                           tt-ped-venda.nr-pedcli + chr(13) + chr(10)).
             END.
             ASSIGN i-total-qtdes = 0
                    c-pedidos = "".
             FOR EACH b1-ped-venda NO-LOCK
                 WHERE b1-ped-venda.nome-abrev = ped-venda.nome-abrev
                   AND b1-ped-venda.dt-implant >= TODAY - 60,
                 EACH b1-ped-item OF b1-ped-venda NO-LOCK,
                 FIRST ITEM 
                 WHERE ITEM.it-codigo = b1-ped-item.it-codigo NO-LOCK:
                 ASSIGN i-total-qtdes = i-total-qtdes + b1-ped-item.qt-pedida.
                 ASSIGN c-pedidos = c-pedidos + b1-ped-venda.nr-pedcli + " de " + string(b1-ped-venda.dt-implant) + " Item: " + b1-ped-item.it-codigo + " - " + ITEM.desc-item +  " Quantidade: " + string(b1-ped-item.qt-pedida) + chr(13) + chr(10).
             END.
             IF i-total-qtdes > 10 THEN DO:
                 RUN piEnviaEmail (INPUT "Colaborador ultrapassou a quantidade de compra",
                                   INPUT "Prezado, " + chr(13) + chr(10) +
                                         "Compra do Cliente " + emitente.nome-emit + 
                                          "(" + 
                                          STRING(emitente.cod-emitente) + 
                                          ")" + 
                                          " CNPJ/CPF " + 
                                          tt-ped-venda.cgc +
                                          " ultrapassou o nro de 10 itens nos ultimos 60 dias " +
                                         "Pedido " + tt-ped-venda.nr-pedcli + chr(13) + chr(10) +
                                         c-pedidos).
    
             END.
          END.
    
          IF l-ativa-log THEN DO:
              OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
              PUT "espdp044 - Passo  12 " TODAY " " string(time,"HH:MM:SS") " Apos executar bo " RETURN-VALUE SKIP.
              OUTPUT CLOSE.
          END.
    
    
          /** Executa criaá∆o do registro do cart∆o de crÇdito apenas quando a forma de pagamento for com cart∆o **/
          assign iOutSeqCartao = 0.
          if (int-ped-venda.FormaPgto = 'Credito') then do:
             run esapi/esapi014.p persistent set h-cartao.
    
             run incluiCartao in h-cartao (emitente.cod-emitente,
                                           ttCartao.Numero,
                                           integer(ttCartao.Seguranca),
                                           lookup(ttPedido.Operadora,'AmericanExpress,Aura,BancoDoBrasil,Boleto,Bradesco,Diners,HiperCard,HSBC,Itau,MasterCard,Visa,Boleto_HSBC,Boleto_Bradesco,CartaoLoja'),
                                           ttCartao.Titular,
                                           integer(ttCartao.ValidadeMes),
                                           integer(ttCartao.ValidadeAno),
                                           2 /*B2C*/,
                                           output iOutSeqCartao).
    
             delete procedure h-cartao.
             ASSIGN h-cartao = ?.
    
             if (iOutSeqCartao = 0) then do:
                run incluiMsgErro in this-procedure ('Erro na criaá∆o do registro de cart∆o de crÇdito para o emitente.').
                undo pedvenda_blk, next pedvenda_blk.
             end.
    
             /** Avisa quando o CarTID for em branco, mas permite ainda a inserá∆o do pedido no EMS **/
             if (ttCartao.CarTID = '') then
                run incluiMsgErro in this-procedure ('Pedido com Cart∆o de CrÇdito, porÇm sem informaá∆o de autorizaá∆o da administradora (CARTID). N∆o ficar† aprovado para atendimento!').
          end.
    
          assign int-ped-venda.seq-cartao-cred = iOutSeqCartao
                 int-ped-venda.CarTID          = ttCartao.CarTID.
                 int-ped-venda.atualizaIkeda   = no.

          /* Coloquei a aprovaPed no alocaPedido - Rubia (Jan/2015) */
          run alocaPedido in this-procedure (input l-saldao).
          IF l-ativa-log THEN DO:
              OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
              PUT "espdp044 - Passo  12c " TODAY " " string(time,"HH:MM:SS") " depois alocaPedido " RETURN-VALUE SKIP.
              OUTPUT CLOSE.
          END.
          if (return-value = 'NOK') THEN DO:
              IF l-ativa-log THEN DO:
                  OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                  PUT "espdp044 - Passo  12e " TODAY "Erro na alocaá∆o de itens no estoque para o pedido." RETURN-VALUE SKIP.
                  OUTPUT CLOSE.
              END.
              run incluiMsgErro in this-procedure ('Erro na alocaá∆o de itens no estoque para o pedido.').
          END.
    
          /** S¢ deixa aprovado caso o pedido esteja como PagamentoConfirmado, que Ç DÇbito, e Cart∆o de CrÇdito, apenas os que tàm o CarTID preenchido **/
          /*if not (ttPedido.PedidoStatus = 'PagamentoConfirmado') and ((ttPedido.FormaPgto = 'Debito') or ((ttPedido.FormaPgto = 'Credito') and (ttCartao.CarTID <> ''))) then do:*/
          /* Coloquei as validaá‰es de forma mais clara - Rubia (Jan/2015) */
          IF  ttPedido.FormaPgto = 'Credito' AND ttCartao.CarTID <> '' then do:
              run aprovaPedido in this-procedure.
              IF l-ativa-log THEN DO:
                  OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                  PUT "espdp044 - Passo  12f " TODAY " " string(time,"HH:MM:SS") " depois desaprovaPedido " RETURN-VALUE SKIP.
                  OUTPUT CLOSE.
              END.
              if (return-value = 'NOK') THEN DO:
                  if (return-value = 'NOK') THEN DO:
                      IF l-ativa-log THEN DO:
                          OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                          PUT "espdp044 - Passo  12g " TODAY "Erro na aprovaá∆o do pedido" RETURN-VALUE SKIP.
                          OUTPUT CLOSE.
                      END.
                      run incluiMsgErro in this-procedure ('Erro na aprovaá∆o do pedido.').
                  END.
              END.
          END.
    
          IF  ttPedido.FormaPgto = 'Credito' AND ttCartao.CarTID = '' then do:
             run desaprovaPedido in this-procedure ('Pedido B2C com pagamento n∆o confirmado').
             IF l-ativa-log THEN DO:
                 OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                 PUT "espdp044 - Passo  12f " TODAY " " string(time,"HH:MM:SS") " depois desaprovaPedido " RETURN-VALUE SKIP.
                 OUTPUT CLOSE.
             END.
             if (return-value = 'NOK') THEN DO:
                 if (return-value = 'NOK') THEN DO:
                     IF l-ativa-log THEN DO:
                         OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                         PUT "espdp044 - Passo  12g " TODAY "Erro na desaprovaá∆o do pedido" RETURN-VALUE SKIP.
                         OUTPUT CLOSE.
                     END.
                     run incluiMsgErro in this-procedure ('Erro na desaprovaá∆o do pedido.').
                 END.
             END.
          END.
    

          /** Validaá∆o do cart∆o de crÇdito no Pagador **/
          if (ttPedido.FormaPgto = 'Credito') and (ttPedido.PedidoStatus = '7') then
             run atualizaGateway in this-procedure.
    

          IF l-ativa-log THEN DO:
              OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
              PUT "AKI8B espdp044 - Final " ttPedido.PedidoCodigo  ttPedido.contacodigo SKIP.
              OUTPUT CLOSE.
          END.

          create tt-ped-valid.
          assign tt-ped-valid.PedidoCodigo = ttPedido.PedidoCodigo
                 tt-ped-valid.contaCodigo  = ttPedido.contacodigo.
    
          IF l-ativa-log THEN DO:
              OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
              PUT "espdp044 - Passo  13 " TODAY " " string(time,"HH:MM:SS") " Apos executar bo " RETURN-VALUE SKIP.
              OUTPUT CLOSE.
          END.
          FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.
          RELEASE int-ped-venda.


       end. /** for each ttEstabPedido **/

    end. /** for each ttPedido **/
    


    if (valid-handle(h-boes505)) then
       delete procedure h-boes505.
    ASSIGN h-boes505 = ?.
    
    IF l-ativa-log THEN DO:
        OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
        PUT "espdp044 - Final " TODAY " " string(time,"HH:MM:SS") SKIP.
        OUTPUT CLOSE.
    END.
    
    /** Tarefa 9616: reprovar no crÇdito o pedido que tiver valor total diferente do informado no XML **/
    ASSIGN de-vlr-ipi-frete = 0
           de-frete-total   = 0.
    IF l-ativa-log THEN DO:
        OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
        PUT skip
            "Pedido apos zerar o valor do frete "  TODAY " Hora " STRING(TIME,"HH:MM:SS") 
            de-vlr-ipi-frete " - "
            de-frete-total  
            SKIP.
        OUTPUT CLOSE.
    END.
    for each tt-ped-valid no-lock,
       first ttPedido no-lock
          where ttPedido.PedidoCodigo = tt-ped-valid.PedidoCodigo
            AND ttPedido.contaCodigo  = tt-ped-valid.contaCodigo:
        ASSIGN de-vlr-ipi-frete = 0
               de-frete-total   = 0.
    
        /* Unifiquei os int-ped-venda - Rubia (Jan/2015) */
        for each int-ped-venda EXCLUSIVE-LOCK
            where int-ped-venda.PedidoCodigo = integer(tt-ped-valid.PedidoCodigo)
              AND  int-ped-venda.contacodigo  = integer(tt-ped-valid.contaCodigo):

            ASSIGN de-vl-frete = int-ped-venda.vl-frete.
    
            IF l-ativa-log THEN DO:
                OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                PUT "0000 - Valor frete total - " de-vl-frete " " int-ped-venda.nr-pedido " int-ped-venda.cod-estabel " int-ped-venda.cod-estabel " " 
                    integer(tt-ped-valid.PedidoCodigo) " "
                    integer(tt-ped-valid.contaCodigo)
                       SKIP.
                OUTPUT CLOSE.
            END.
     
            IF int-ped-venda.vl-frete <> 0 THEN DO:
                FOR EACH ped-venda
                    WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido exclusive-lock:
     
                    IF l-ativa-log THEN DO:
                        OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                        PUT "Pedido " ped-venda.nr-pedcli " Data " TODAY " Hora " STRING(TIME,"HH:MM:SS") SKIP.
                        OUTPUT CLOSE.
                    END.
                    ASSIGN de-total-vlr-ipi = 0
                           de-frete-total   = 0.
     
                    FOR EACH ped-item  OF ped-venda NO-LOCK:
                        ASSIGN de-total-vlr-ipi = de-total-vlr-ipi + ped-item.vl-preuni. /* utilizado para calculo do frete sem ipi */
                    END.
                    FOR EACH ped-item  OF ped-venda NO-LOCK:
                        ASSIGN de-percentual    = ped-item.vl-preuni / de-total-vlr-ipi
                               de-frete-do-item = de-vl-frete * de-percentual
                               de-frete-sem-ipi = de-frete-do-item / (1 + (ped-item.aliquota-ipi / 100))
                               de-frete-total   = de-frete-total + de-frete-sem-ipi.
     
                    END.
                    ASSIGN ped-venda.cod-priori              = 88
                           OVERLAY(ped-venda.char-2,109,8)   = "1".
    
                    IF l-ativa-log THEN DO:
                        OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                        PUT "Pedido " ped-venda.nr-pedcli " " ped-venda.cod-priori SKIP.
                        OUTPUT CLOSE.
                    END.
     
                END.
                FIND CURRENT ped-venda NO-LOCK NO-ERROR.
                RELEASE ped-venda.
                ASSIGN int-ped-venda.vl-frete   = de-frete-total
                       de-vlr-ipi-frete         = de-vl-frete - de-frete-total.
            END.

            /****/

            FIND ped-venda WHERE ped-venda.nr-pedido = int-ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL ped-venda THEN DO:
                ASSIGN ped-venda.completo = NO.

                IF l-ativa-log THEN DO:
                    PUT "Pedido a ser completado --->>>  Data " TODAY " Hora " STRING(TIME,"HH:MM:SS") SKIP.
                    OUTPUT CLOSE.
                END.

                EMPTY TEMP-TABLE RowErrors.
                run dibo/bodi159com.p persistent set h-bodi159cal.
                run completeOrder in h-bodi159cal (input rowid(ped-venda), output table RowErrors).

                /* Caso n∆o tenha pagamento confirmado do cart∆o, n∆o aprova o pedido */
                IF  (ttPedido.FormaPgto = 'Credito') and (ttPedido.PedidoStatus <> '7') THEN DO:
                    run desaprovaPedido in this-procedure ('Pedido B2C com pagamento n∆o confirmado').
                    IF  RETURN-VALUE <> "OK" THEN DO:
                        run incluiMsgErro in this-procedure ('Erro na desaprovaá∆o do pedido.').
                     END.
                END.

                for each RowErrors no-lock
                   where RowErrors.ErrorNumber <> 8259: /** crÇdito n∆o aprovado **/
                   run incluiMsgErro in this-procedure (string(RowErrors.ErrorNumber) + ' - ' + RowErrors.ERRORDescription + ' Cliente: ' + ped-venda.nome-abrev + ' Pedido: ' + ped-venda.nr-pedcli).

                   IF l-ativa-log THEN DO:
                       OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                      PUT "espdp044 - Passo  10f1 " TODAY " " string(time,"HH:MM:SS") " Executar BOs - erro description " rowerrors.errordescription SKIP.
                      OUTPUT CLOSE.
                   END.
                   assign l-erro = yes.
                end.
                DELETE PROCEDURE h-bodi159cal.
                ASSIGN h-bodi159cal = ?.

                IF l-ativa-log THEN DO:
                    OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                    PUT "0 - Valor frete total - " de-frete-total SKIP
                          " Valor Ikeda : " de-val-ValorTotal       SKIP
                         " Valor total EMS : " de-valid-tot       SKIP
                         " Valor IPI do frete : " de-vlr-ipi-frete SKIP
                         " Somatoria " de-valid-tot + de-vlr-ipi-frete SKIP.
                    OUTPUT CLOSE.
                END.

                assign de-valid-tot    = 0
                       de-val-ValorTotal = decimal(replace(replace(ttPedido.ValorTotal,'.',''),',','')) / 100.
            END. /* IF AVAIL ped-venda THEN DO: */
            FIND CURRENT ped-venda NO-LOCK NO-ERROR.
            RELEASE ped-venda.

            /****/
            
            FOR each ped-venda no-lock
               where ped-venda.nr-pedido = int-ped-venda.nr-pedido:
                assign de-valid-tot = de-valid-tot + ped-venda.vl-tot-ped.
         IF l-ativa-log THEN DO:
                        OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                        PUT "Depois desaprova teste1.a -   " ped-venda.nr-pedcli SKIP
                            "ttPedido.PedidoStatus " ttPedido.PedidoStatus SKIP
                            "ttPedido.FormaPgto " ttPedido.FormaPgto SKIP
                            
                            
                            .
                        OUTPUT CLOSE.
                    END.
/*                 /* Coloquei as validaá‰es de forma mais clara - Rubia (Jan/2015) */                                                               */
/*                 IF  ttPedido.PedidoStatus <> '7' OR ttPedido.FormaPgto <> 'Debito' AND ttPedido.FormaPgto <> 'Credito' then do:                   */
/*                     run desaprovaPedido in this-procedure ('Pedido B2C com pagamento n∆o confirmado').                                            */
/*                     IF l-ativa-log THEN DO:                                                                                                       */
/*                         OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.                                                           */
/*                         PUT "Depois desaprova teste1  " ped-venda.nr-pedcli SKIP.                                                                 */
/*                         OUTPUT CLOSE.                                                                                                             */
/*                     END.                                                                                                                          */
/*                     if (return-value = 'NOK') then                                                                                                */
/*                        run incluiMsgErro in this-procedure ('Erro na desaprovaá∆o do pedido.').                                                   */
/*                 END. /* IF  ttPedido.PedidoStatus <> '7' OR  ttPedido.FormaPgto    <> 'Debito' AND ttPedido.FormaPgto    <> 'Credito' then do: */ */
/*                                                                                                                                                   */
                IF  ttPedido.FormaPgto = 'Credito' AND ttCartao.CarTID <> '' then do:
                    run aprovaPedido in this-procedure.
                    IF l-ativa-log THEN DO:
                        OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                        PUT "Depois aprova teste2 " ped-venda.nr-pedcli SKIP.
                        OUTPUT CLOSE.
                    END.
                    if (return-value = 'NOK') then
                       run incluiMsgErro in this-procedure ('Erro na desaprovaá∆o do pedido.').
                END. /* IF  ttPedido.FormaPgto = 'Credito' AND ttCartao.CarTID    = '' then do: */
                IF  ttPedido.FormaPgto = 'Credito' AND ttCartao.CarTID = '' then do:
                    run desaprovaPedido in this-procedure ('Pedido B2C com pagamento n∆o confirmado').
                    IF l-ativa-log THEN DO:
                        OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                        PUT "Depois desaprova teste2aa " ped-venda.nr-pedcli SKIP.
                        OUTPUT CLOSE.
                    END.
                    if (return-value = 'NOK') then
                       run incluiMsgErro in this-procedure ('Erro na desaprovaá∆o do pedido.').
                END. /* IF  ttPedido.FormaPgto = 'Credito' AND ttCartao.CarTID    = '' then do: */

            END. /* FOR each ped-venda no-lock */

            IF l-ativa-log THEN DO:
                OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                PUT "2 - "  int(ttPedido.PedidoCodigo) "- Valor Ikeda : " de-val-ValorTotal SKIP
                     " Valor total EMS : " de-valid-tot                                    SKIP
                     " Valor IPI do frete : "  de-vlr-ipi-frete                            SKIP
                     " Somatoria " de-valid-tot + de-vlr-ipi-frete SKIP
                     " de-val-ValorTotal: " de-val-ValorTotal.
                OUTPUT CLOSE.
            END.

      /*        if (abs(de-val-ValorTotal - (de-valid-tot - de-frete-total) ) > 0.5) THEN DO:  */
            IF (abs(de-val-ValorTotal - (de-valid-tot) ) > 0.5) THEN DO:
                IF l-ativa-log THEN DO:
                    OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                    PUT int(ttPedido.PedidoCodigo) " Diferenáa - Valor Ikeda : " de-val-ValorTotal 
                         " Valor total EMS : " de-valid-tot 
                         " Valor IPI do frete : "  de-vlr-ipi-frete
                         " Somatoria " de-valid-tot + de-vlr-ipi-frete SKIP.
                    OUTPUT CLOSE. 
                END.

/*                 run desaprovaPedido in this-procedure ('Pedido B2C com valor divergente').                                              */
/*                 IF l-ativa-log THEN DO:                                                                                                 */
/*                     OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.                                                     */
/*                     PUT '>>>> Depois desaprova Valor do pedido divergente! EMS: ' + left-trim(string(de-valid-tot, '>>>,>>>,>>9.99')) + */
/*                         ', Ikeda: ' + left-trim(string(de-val-ValorTotal, '>>>,>>>,>>9.99')) SKIP.                                      */
/*                     OUTPUT CLOSE.                                                                                                       */
/*                 END.                                                                                                                    */

                run incluiMsgErro in this-procedure ('Valor do pedido divergente! EMS: ' + left-trim(string(de-valid-tot, '>>>,>>>,>>9.99')) +
                                                     ', Ikeda: ' + left-trim(string(de-val-ValorTotal, '>>>,>>>,>>9.99'))).

            END. 

        END. /* for each int-ped-venda EXCLUSIVE-LOCK */
    
    end.
    OUTPUT CLOSE.
    
    /** Marca os pedidos na Ikeda como Integrado **/
    for each tt-ped-valid no-lock:
       run pi-acompanhar in h-acomp ('Confirmando recebimento do Pedido ' + tt-ped-valid.PedidoCodigo).
       
       run validarBaixa in hWebService (tt-ped-valid.PedidoCodigo, '0', output iStatus, output cStatus).
    
       if (iStatus <> 1) then
          run incluiMsgErro in this-procedure (cStatus).
    end.
    IF l-ativa-log THEN DO:
        OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
        PUT "Erros encontrados:  " TODAY " " string(time,"HH:MM:SS") SKIP.
    END.

    FOR EACH msgerro:
        PUT msgerro.DescErro FORMAT "x(500)" SKIP.
    END.

    IF l-ativa-log THEN DO:
        OUTPUT CLOSE.
    END.
    
    run desconecta in hWebService.
    delete procedure hWebService.
    ASSIGN hWebService = ?.
    
    return 'OK'.
end.

procedure alocaPedido:
   define input parameter l-saldao  as logical  no-undo.

   define variable h-alocacao        as handle   no-undo.
   define variable de-qt-a-alocar    as decimal  no-undo.
   define variable de-qt-saldo       as decimal  no-undo.
   define variable l-wms-estab-ativo as logical no-undo.

   run pdp/pdapi002.p persistent set h-alocacao.

   RUN esp/wmp/eswmpapi006.p( INPUT ped-venda.cod-estabel, OUTPUT l-wms-estab-ativo).

   if (ped-venda.cod-sit-ped <= 2) and (ped-venda.completo)  then
      aloca_pedido:
      do transaction on error undo aloca_pedido, return 'NOK':
          
      IF  ttPedido.FormaPgto = 'Credito' AND ttCartao.CarTID <> '' THEN DO:
          run aprovaPedido in this-procedure.
      END.

      IF l-ativa-log THEN DO:
          OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
          PUT "espdp044 - Passo  12a " TODAY " " string(time,"HH:MM:SS") " depois aprovaPedido " RETURN-VALUE SKIP.
          OUTPUT CLOSE.
      END.

      if (return-value = 'NOK') THEN DO:
          IF l-ativa-log THEN DO:
              OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
              PUT "espdp044 - Passo  12b " TODAY "Erro na aprovaá∆o do pedido. Aprovaá∆o e Alocaá∆o de saldo devem ser feitos manualmente." RETURN-VALUE SKIP.
              OUTPUT CLOSE.
          END.
          run incluiMsgErro in this-procedure ('Erro na aprovaá∆o do pedido. Aprovaá∆o e Alocaá∆o de saldo devem ser feitos manualmente.').
          undo aloca_pedido, return 'NOK'.
      END.
      /* fim run aprovaPedido in this-procedure. */

      for each ped-item of ped-venda no-lock
         where ped-item.cod-sit-item <= 2,
         first item no-lock
            where item.it-codigo   = ped-item.it-codigo
              and item.tipo-contr <> 4:

         find ped-ent no-lock
            where ped-ent.nome-abrev   = ped-item.nome-abrev
              and ped-ent.nr-pedcli    = ped-item.nr-pedcli
              and ped-ent.nr-sequencia = ped-item.nr-sequencia
              and ped-ent.it-codigo    = ped-item.it-codigo
              and ped-ent.cod-refer    = ped-item.cod-refer no-error.

         assign de-qt-a-alocar = ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-log-aloca.

         if (de-qt-a-alocar = 0) then
            next.

         if can-find (first item-uni-estab
                      where item-uni-estab.cod-estabel = ped-venda.cod-estabel
                        and item-uni-estab.it-codigo   = ped-item.it-codigo
                        and item-uni-estab.nr-linha    = 20) then do:
            run incluiMsgErro in this-procedure ('Pedido com Produto Composto, pedido desconsiderado na alocaá∆o de estoque.' + ' Cliente: ' + ped-venda.nome-abrev + ' Pedido: ' + ped-venda.nr-pedcli).
            undo aloca_pedido, return 'NOK'.
         end.

         assign de-qt-saldo = 0.

         IF l-wms-estab-ativo THEN
             for first saldo-estoq no-lock
                where  saldo-estoq.it-codigo = ped-item.it-codigo
                  AND  saldo-estoq.cod-estabel = ped-venda.cod-estabel
                  and  saldo-estoq.cod-depos = (if (l-saldao) then param-b2c.cod-depos-saldao else "WEX")
                  AND  saldo-estoq.cod-localiz = ""
                  and (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped)) > 0:
                assign de-qt-saldo = (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped)).
             end.
         ELSE
             for first saldo-estoq no-lock
                where  saldo-estoq.it-codigo = ped-item.it-codigo
                  AND  saldo-estoq.cod-estabel = ped-venda.cod-estabel
                  and  saldo-estoq.cod-depos = (if (l-saldao) then param-b2c.cod-depos-saldao else param-b2c.cod-depos)
                  AND  saldo-estoq.cod-localiz = ""
                  and (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped)) > 0:
                assign de-qt-saldo = (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-prod + saldo-estoq.qt-aloc-ped)).
             end.

         if (de-qt-saldo >= de-qt-a-alocar) then do:
             
            run pi-aloca-fisica-man in h-alocacao(input rowid(ped-ent), input-output de-qt-a-alocar, input rowid(saldo-estoq)).

            if (return-value = "NOK") then do:
               run incluiMsgErro in this-procedure ('N∆o foi possivel efetuar a alocaá∆o f°sica do material! Cliente: ' + ped-venda.nome-abrev + ' Pedido: ' + ped-venda.nr-pedcli).
               undo aloca_pedido, return 'NOK'.
            end.
         end.
         else do:
            run incluiMsgErro in this-procedure ('Item do Pedido sem Saldo, alocaá∆o n∆o efetuada.').
            undo aloca_pedido, return 'NOK'.
         end.

         find int-ped-item exclusive-lock
            where int-ped-item.nome-abrev      = ped-venda.nome-abrev
              and int-ped-item.nr-pedcli       = ped-venda.nr-pedcli
              and int-ped-item.nr-sequencia    = ped-item.nr-sequencia
              and int-ped-item.it-codigo       = ped-item.it-codigo
              and int-ped-item.cod-refer       = ped-item.cod-refer no-error.
         
         if not available (int-ped-item) then do:
            create int-ped-item.
            assign int-ped-item.nome-abrev      = ped-venda.nome-abrev
                   int-ped-item.nr-pedcli       = ped-venda.nr-pedcli
                   int-ped-item.nr-sequencia    = ped-item.nr-sequencia
                   int-ped-item.it-codigo       = ped-item.it-codigo
                   int-ped-item.cod-refer       = ped-item.cod-refer.
         end.

         assign int-ped-item.log-transferido = yes.

         FIND CURRENT int-ped-item NO-LOCK NO-ERROR.
         RELEASE int-ped-item.
      end.
   end.

   if (valid-handle(h-alocacao)) then
      delete procedure h-alocacao.
   ASSIGN h-alocacao = ?.
end procedure.

procedure aprovaPedido:

   /*S¢ aprova o pedido caso o cart∆o esteja com PagamentoConfirmado */
   IF  ttPedido.FormaPgto = "Credito" AND ttPedido.PedidoStatus <> "7" THEN
       RETURN "OK".

   do on error undo, return 'NOK':
      find ped-venda exclusive-lock
         where ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
           and ped-venda.nome-abrev = tt-ped-venda.nome-abrev no-error.

      if not available (ped-venda) then
         return 'NOK'.

      assign ped-venda.cod-sit-aval       = 3 /** Aprovado **/
             ped-venda.desc-bloq-cr       = ''
             ped-venda.dsp-pre-fat        = yes
             ped-venda.cod-message-alerta = 0
             ped-venda.dt-mensagem        = ?
             ped-venda.nome-prog          = ''
             ped-venda.dt-apr-cred        = TODAY.

       IF l-ativa-log THEN DO:
                  OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                  PUT "espdp044 - apos aprovar o pedido  -> " int(ped-venda.cod-sit-aval) SKIP
                      ped-venda.nr-pedcli SKIP.
                  OUTPUT CLOSE.
              END.

   end.

   return 'OK'.
end procedure.

procedure desaprovaPedido:
   define input parameter c-desc-bloq as character no-undo.

   do on error undo, return 'NOK':
      find ped-venda exclusive-lock
         where ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
           and ped-venda.nome-abrev = tt-ped-venda.nome-abrev no-error.

      if not available (ped-venda) then
         return 'NOK'.
      
      assign ped-venda.cod-sit-aval       = 4 /** Nao Aprovado **/
             ped-venda.desc-bloq-cr       = c-desc-bloq
             ped-venda.dsp-pre-fat        = no
             ped-venda.cod-message-alerta = 0
             ped-venda.dt-mensagem        = ?
             ped-venda.nome-prog          = ''.
   end.

   return 'OK'.
end procedure.

procedure pi-executar-bos:
   
   define variable h-bodi159     as handle   no-undo.
   define variable h-bodi154     as handle   no-undo.
   define variable h-bodi157     as handle   no-undo.

   bloco:
   do transaction on error  undo bloco, return 'nok'
                  on endkey undo bloco, return 'nok':

      run dibo/bodi159.p persistent set h-bodi159.

      run openQueryStatic in h-bodi159(input 'Main':U).
      run setRecord       in h-bodi159(input table tt-ped-venda).
      run inputRowVendor  in h-bodi159(input table tt-ped-vendor).
      run emptyRowErrors  in h-bodi159.
      run createMPLog     in h-bodi159(input no).
      run createRecord    in h-bodi159.
      run getRowErrors    in h-bodi159(output table RowErrors).
      
      ASSIGN l-erro = NO.

      for each RowErrors no-lock
         where RowErrors.ErrorType   <> 'INTERNAL':U
           and RowErrors.ErrorSubType = 'Error':U:
         run incluiMsgErro in this-procedure (string(RowErrors.errorNumber) + '-' + RowErrors.ERRORDescription  + ' Cliente: ' + tt-ped-venda.nome-abrev).

         IF l-ativa-log THEN DO:
            OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
            PUT "espdp044 - Passo  10a " TODAY " " string(time,"HH:MM:SS") " Executar BOs - erro description " rowerrors.errordescription SKIP.
            OUTPUT CLOSE.
         END.

         assign l-erro = yes.
      end.

      if (valid-handle(h-bodi159)) and (h-bodi159:file-name = 'dibo/bodi159.p') and (h-bodi159:type = 'procedure') then
         run destroyBO in h-bodi159.
      if (valid-handle(h-bodi159)) then do:
         delete procedure h-bodi159.
         assign h-bodi159 = ?.
      end.


      IF l-ativa-log THEN DO:
          OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
          PUT "espdp044 - Passo  10b " TODAY " " string(time,"HH:MM:SS") " Executar BOs - " l-erro SKIP.
          OUTPUT CLOSE.
      END.

      if (l-erro) then
         undo bloco, return 'nok'.

      run dibo/bodi157.p persistent set h-bodi157.

      for each tt-ped-repre:
         run openQueryStatic in h-bodi157(input 'Default':U).

         run emptyRowErrors in h-bodi157.
         run setRecord in h-bodi157(input table tt-ped-repre).
         run createMPLog  in h-bodi157(input no).
         run createRecord in h-bodi157.
         run getRowErrors in h-bodi157(output table RowErrors).
         
         for each RowErrors no-lock
            where RowErrors.ErrorType   <> 'INTERNAL':U
              and RowErrors.ErrorSubType = 'Error':U:
            run incluiMsgErro in this-procedure (string(RowErrors.errorNumber) + '-' + RowErrors.ERRORDescription  + ' Cliente: ' + tt-ped-venda.nome-abrev).

            IF l-ativa-log THEN DO:
                OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                PUT "espdp044 - Passo  10c " TODAY " " string(time,"HH:MM:SS") " Executar BOs - erro description " rowerrors.errordescription SKIP.
                OUTPUT CLOSE.
            END.
            assign l-erro = yes.
         end.

         delete tt-ped-repre.
      end.

      /* MÇtodo n∆o existe nesta BO */
      /*
      if (valid-handle(h-bodi157)) and (h-bodi157:file-name = 'dibo/bodi157.p') and (h-bodi157:type = 'procedure') then
         run destroyBO in h-bodi157.*/
      if (valid-handle(h-bodi157)) then do:
         delete procedure h-bodi157.
         assign h-bodi157 = ?.
      end.

      IF l-ativa-log THEN DO:
          OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
          PUT "espdp044 - Passo  10d " TODAY " " string(time,"HH:MM:SS") " Executar BOs " l-erro SKIP.
          OUTPUT CLOSE.
      END.
      
      if (l-erro) then
         undo bloco, return 'nok'.

      run dibo/bodi154.p persistent set h-bodi154.

      for each tt-ped-item:

         run openQueryStatic in h-bodi154(input 'Default':U).

         run emptyRowErrors in h-bodi154.
         run setRecord in h-bodi154(input table tt-ped-item).
         run createMPLog  in h-bodi154(input no).
         run createRecord in h-bodi154.
         run getRowErrors in h-bodi154(output table RowErrors).

         for each RowErrors no-lock
            where RowErrors.ErrorType   <> 'INTERNAL':U
              and RowErrors.ErrorSubType = 'Error':U:
            run incluiMsgErro in this-procedure (string(RowErrors.errorNumber) + '-' + RowErrors.ERRORDescription  + ' Cliente: ' + tt-ped-venda.nome-abrev).

            IF l-ativa-log THEN DO:
                OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
                PUT "espdp044 - Passo  10e " TODAY " " string(time,"HH:MM:SS") " Executar BOs - erro description " rowerrors.errordescription SKIP.
                OUTPUT CLOSE.
            END.
            assign l-erro = yes.
         end.
          
         delete tt-ped-item.
      end.

      if (valid-handle(h-bodi154)) and (h-bodi154:file-name = 'dibo/bodi154.p') and (h-bodi154:type = 'procedure') then
         run destroyBO in h-bodi154.
      if (valid-handle(h-bodi154)) then do:
         delete procedure h-bodi154.
         assign h-bodi154 = ?.
      end.
      
      if (l-erro) then
         undo bloco, return 'nok'.

      find ped-venda exclusive-lock
          where ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli
            and ped-venda.nome-abrev = tt-ped-venda.nome-abrev no-error.

      EMPTY TEMP-TABLE RowErrors.
      run dibo/bodi159com.p persistent set h-bodi159cal.
      run completeOrder in h-bodi159cal (input rowid(ped-venda), output table RowErrors).

      /* Caso n∆o tenha pagamento confirmado do cart∆o, n∆o aprova o pedido */
      IF  (ttPedido.FormaPgto = 'Credito') and (ttPedido.PedidoStatus <> '7') THEN DO:
          run desaprovaPedido in this-procedure ('Pedido B2C com pagamento n∆o confirmado').
      END.

      for each RowErrors no-lock
         where RowErrors.ErrorNumber <> 8259: /** crÇdito n∆o aprovado **/
         run incluiMsgErro in this-procedure (string(RowErrors.ErrorNumber) + ' - ' + RowErrors.ERRORDescription + ' Cliente: ' + ped-venda.nome-abrev + ' Pedido: ' + ped-venda.nr-pedcli).

         IF l-ativa-log THEN DO:
            OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
            PUT "espdp044 - Passo  10f2 " TODAY " " string(time,"HH:MM:SS") " Executar BOs - erro description " rowerrors.errordescription SKIP.
            OUTPUT CLOSE.
         END.

         assign l-erro = yes.
      end.
       
      if (valid-handle(h-bodi159cal)) and (h-bodi159cal:file-name = 'dibo/bodi159com.p') and (h-bodi159cal:type = 'procedure') then
         run destroyBO in h-bodi159cal.
      if (valid-handle(h-bodi159cal)) then do:
         delete procedure h-bodi159cal.
         assign h-bodi159cal = ?.
      end.
      
      if (l-erro) then
         undo bloco, return 'nok'.
   end.
end procedure.

procedure atualizaGateway:
   define variable hWebServicePag         as handle      no-undo.
   define variable c-pedido-gateway       as character   no-undo.

   IF l-ativa-log THEN DO:
      OUTPUT TO VALUE(c-dir + "an046325/espdp044-log2.txt":U) APPEND.
      PUT "dentro atualizaGateway" SKIP.
      OUTPUT CLOSE.
   END.

   define variable l-ok as logical  no-undo.

   run esp/pdp/espdp044rpb-ws1.p persistent set hWebServicePag.

   run conecta in hWebServicePag (output iStatus, output cStatus).

   if (iStatus <> 1) then
      run incluiMsgErro in this-procedure ('Erro ao conectar ao Pagador: ' + cStatus).
   else do:
      assign l-ok   = no
             i-cont = 0.

      do while i-cont < 5 and not (l-ok):
         assign i-cont = i-cont + 1.

         case i-cont:
            when 1 then
               assign c-pedido-gateway = ttPedido.PedidoCodigo.
            when 2 then
               assign c-pedido-gateway = ttPedido.PedidoCodigo + "r".
            when 3 then
               assign c-pedido-gateway = ttPedido.PedidoCodigo + "r1".
            when 4 then
               assign c-pedido-gateway = ttPedido.PedidoCodigo + "r2".
            when 5 then
               assign c-pedido-gateway = ttPedido.PedidoCodigo + "r3".
         end case.

         run getDadosPedido in hWebServicePag (input c-pedido-gateway, output iStatus, output cStatus, output table ttDadosPedido).

         if (iStatus <> 1) then
            run incluiMsgErro in this-procedure ('Erro na consulta ao Pagador: ' + cStatus).
         else do:
            find ttDadosPedido.

            if (ttDadosPedido.DataPagamento = '') and (i-cont = 5) then
               run incluiMsgErro in this-procedure ('Pedido com Cart∆o de CrÇdito, porÇm sem informaá∆o de Data de Processamento Cart∆o').
            else do:
               /** Atualiza tabela **/
               find gateway-ikeda exclusive-lock
                  where gateway-ikeda.PedidoCodigo = int(ttPedido.PedidoCodigo) no-error.

               if not available (gateway-ikeda) then do:
                  create gateway-ikeda.
                  assign gateway-ikeda.PedidoCodigo = int(ttPedido.PedidoCodigo).
               end.

               assign c-data-pagamento  = entry(1, ttDadosPedido.DataPagamento, ' ')
                      dt-data-pagamento = date(int(entry(1, c-data-pagamento, '/')),
                                               int(entry(2, c-data-pagamento, '/')),
                                               int(entry(3, c-data-pagamento, '/')))
                      c-hora-pagamento  = entry(2, ttDadosPedido.DataPagamento, ' ').

               /** Trata as horas de AM/PM para 24h **/
               if (entry(3, ttDadosPedido.DataPagamento, ' ') = 'PM') and (int(entry(1, c-hora-pagamento, ':')) < 12) then
                  assign c-hora-pagamento = string(12 + int(entry(1, c-hora-pagamento, ':'))) + entry(2, c-hora-pagamento, ':') + entry(3, c-hora-pagamento, ':').
               else
                  assign c-hora-pagamento = (if (int(entry(1, c-hora-pagamento, ':')) < 10) then '0' else '') + entry(1, c-hora-pagamento, ':') + entry(2, c-hora-pagamento, ':') + entry(3, c-hora-pagamento, ':').

               assign gateway-ikeda.DataProcessamento = dt-data-pagamento
                      gateway-ikeda.HoraProcessamento = c-hora-pagamento
                      gateway-ikeda.CodigoAutorizacao = ttDadosPedido.CodigoAutorizacao.
               release gateway-ikeda.

               assign l-ok = yes.
            end.
         end.
      end.
   end.

   run desconecta in hWebServicePag.
   delete procedure hWebServicePag.
   ASSIGN hWebServicePag = ?.

   return 'OK'.
end procedure.

procedure incluiMsgErro:
   define input parameter pcDescErro as character no-undo.

   define variable iNextMsg as integer no-undo.

   find last MsgErro no-lock no-error.
   if available MsgErro then
      assign iNextMsg = MsgErro.SeqErro + 1.
   else
      assign iNextMsg = 1.

      
   create MsgErro.
   assign MsgErro.SeqErro  = iNextMsg
          MsgErro.DescErro = pcDescErro  + ' - Pedido Ikeda ' + IF AVAIL ttPedido THEN ttPedido.PedidoCodigo ELSE "".
end procedure.

PROCEDURE piCancelaPedidosCanceladosPelaIkeda:
    run dibo/bodi159can.p persistent set bo-ped-venda-can.

    run setUserLog in bo-ped-venda-can (input v_cod_usuar_corren ).      

    run validateCancelation in bo-ped-venda-can (input  ROWID(ped-venda),
                                                 output table Rowerrors).
    
    if  not can-find(first RowErrors
                     where RowErrors.ErrorSubType = "Error":U) then do:

        run updateCancelation in bo-ped-venda-can(input rowid(ped-venda),
                                                  input "Cancelamento Atraves do Site IKEDA - Motivo : " + ttAuxPedido.MotivoCancel,
                                                  input TODAY,
                                                  input 1).


        run incluiMsgErro in this-procedure ('Cancelamento Efetuado Pela Ikeda ' + string(int-ped-venda.PedidoCodigo) + ' Data de Implantacao: ' + STRING(ped-venda.dt-implant)).
    end.
    ELSE DO:
        run incluiMsgErro in this-procedure ('Erro ao tentar efetuar o cancelado Automatico para o Pedido Ikeda ' + string(int-ped-venda.PedidoCodigo) + ' ' + STRING(istatus) + ' ' + STRING(cstatus)).
        
    END.

    IF VALID-HANDLE(bo-ped-venda-can)  THEN DO:
       delete procedure bo-ped-venda-can.
       assign bo-ped-venda-can = ?.
    end.  
    
END PROCEDURE.

PROCEDURE piEnviaEmail:
    
    define input parameter pcTitulo as character no-undo.
    define input parameter pcMensagem as character no-undo.
    
    DEFINE VARIABLE vArqMail             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.

    FOR EACH tt-mail.
        DELETE tt-mail.
    END.
  
    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = "grupo.ecommerce@intelbras.com.br"
           tt-mail.Assunto       = pcTitulo
           tt-mail.Mensagem      = pcMensagem
           tt-mail.Arquivo       = "".
    ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".
    
    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END PROCEDURE.


PROCEDURE piEnviaEmailEntrega :
    
    DEFINE INPUT PARAM pRemetente  AS CHARACTER FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT PARAM pAssunto    AS CHARACTER FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT PARAM pDestino    AS CHARACTER FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT PARAM pDescEmail  AS CHARACTER FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT PARAM pArquivo    AS CHARACTER FORMAT 'x(60)' NO-UNDO.
    
    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   
        DELETE tt-envio2.   
    END.
    FOR EACH tt-mensagem. 
        DELETE tt-mensagem. 
    END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pDestino                              /* Destinatˇrio       */ 
           tt-envio2.remetente         = pRemetente                            /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                              /* Assunto            */
           tt-envio2.arq-anexo         = pArquivo                              /* Arquivo Temporˇrio */
           tt-envio2.formato           = "TEXTO".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = pDescEmail + CHR(13). /* Mensagem */
   
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    
    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros 
    THEN DO:
         OUTPUT TO erros-ava.LOG APPEND.
         FOR EACH tt-erros:
             DISP tt-erros.cod-erro
                  tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
         END.
         OUTPUT CLOSE.
    END.
    
    IF VALID-HANDLE(h-utapi019) 
       THEN DELETE PROCEDURE h-utapi019. 

    ASSIGN h-utapi019 = ?.
   
END PROCEDURE.
