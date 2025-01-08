
CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                            */
/*                                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                           */
/* <MENSAGEM>                                                                                      */
/*   <CABECALHO>                                                                                   */
/*     <IdentidadeEmissor>95061229-FF31-4FD1-A875-96A98D67280C</IdentidadeEmissor>                 */
/*     <NumeroOperacao>2105896</NumeroOperacao>                                                    */
/*     <CodigoMensagem>MSG0093</CodigoMensagem>                                                    */
/*     <LoginUsuario>antonio.pavao@plantec.com</LoginUsuario>                                      */
/*   </CABECALHO>                                                                                  */
/*   <CONTEUDO>                                                                                    */
/*     <MSG0093>                                                                                   */
/*       <NumeroPedido>2105896</NumeroPedido>                                                      */
/*       <NumeroPedidoCliente>0</NumeroPedidoCliente>                                              */
/*       <Representante>1703</Representante>                                                       */
/*       <CodigoClienteCRM>0c33c6f8-d800-e411-9420-00155d013d39</CodigoClienteCRM>                 */
/*       <TipoObjetoCliente>account</TipoObjetoCliente>                                            */
/*       <Atendente>60</Atendente>                                                                 */
/*       <CodigoSupervisorEMS>el647512</CodigoSupervisorEMS>                                       */
/*       <Estabelecimento>103</Estabelecimento>                                                    */
/*       <CondicaoPagamento>521</CondicaoPagamento>                                                */
/*       <CondicaoEspecial xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' /> */
/*       <Observacao xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' />       */
/*       <FaturamentoParcial>true</FaturamentoParcial>                                             */
/*       <Vendor>false</Vendor>                                                                    */
/*       <DataEmissao>2020-10-14</DataEmissao>                                                     */
/*       <DataEntrega>2020-10-15</DataEntrega>                                                     */
/*       <DataNegociacao xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' />   */
/*       <DiasNegociacao xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' />   */
/*       <Situacao>2</Situacao>                                                                    */
/*       <NomeUsuarioCriacao>ANTONIO</NomeUsuarioCriacao>                                          */
/*       <TipoUsuarioCriacao>993520001</TipoUsuarioCriacao>                                        */
/*       <PedidoProgramado>false</PedidoProgramado>                                                */
/*       <PedidoItens>                                                                             */
/*         <PedidoItem>                                                                            */
/*           <ChaveIntegracao>134638,2105896,10,4503003,</ChaveIntegracao>                         */
/*           <Produto>4503003</Produto>                                                            */
/*           <Sequencia>10</Sequencia>                                                             */
/*           <QuantidadePedida>10</QuantidadePedida>                                               */
/*           <PrecoOriginal>238.92</PrecoOriginal>                                                 */
/*           <Acao>A</Acao>                                                                        */
/*           <CalcularRebate>true</CalcularRebate>                                                 */
/*           <PercentualDescontoVerde>0.0000</PercentualDescontoVerde>                             */
/*           <PercentualDescontoTopMilhao>0.0062</PercentualDescontoTopMilhao>                     */
/*           <PercentualRebateAntecipado>0.0000</PercentualRebateAntecipado>                       */
/*           <ItemPai xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' />      */
/*         </PedidoItem>                                                                           */
/*         <PedidoItem>                                                                            */
/*           <ChaveIntegracao>134638,2105896,20,4503001,</ChaveIntegracao>                         */
/*           <Produto>4503001</Produto>                                                            */
/*           <Sequencia>20</Sequencia>                                                             */
/*           <QuantidadePedida>15</QuantidadePedida>                                               */
/*           <PrecoOriginal>342.66</PrecoOriginal>                                                 */
/*           <Acao>A</Acao>                                                                        */
/*           <CalcularRebate>true</CalcularRebate>                                                 */
/*           <PercentualDescontoVerde>0.0000</PercentualDescontoVerde>                             */
/*           <PercentualDescontoTopMilhao>0.0062</PercentualDescontoTopMilhao>                     */
/*           <PercentualRebateAntecipado>0.0000</PercentualRebateAntecipado>                       */
/*           <ItemPai xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:nil='true' />      */
/*         </PedidoItem>                                                                           */
/*       </PedidoItens>                                                                            */
/*     </MSG0093>                                                                                  */
/*   </CONTEUDO>                                                                                   */
/* </MENSAGEM>".                                                                                   */

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                                                  */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                                                  */
/*                                                                                                                       */
/* ASSIGN iXML = "<?xml version='1.0' encoding='utf-16'?>                                                                */
/* <MENSAGEM>                                                                                                            */
/*   <CABECALHO>                                                                                                         */
/*     <IdentidadeEmissor>FD95494F-95B8-48ED-8831-D280C53CBCA1</IdentidadeEmissor>                                       */
/*     <NumeroOperacao>ENVIA PEDIDO EMS</NumeroOperacao>                                                                 */
/*     <CodigoMensagem>MSG0093</CodigoMensagem>                                                                          */
/*   </CABECALHO>                                                                                                        */
/*   <CONTEUDO>                                                                                                          */
/*     <MSG0093>                                                                                                         */
/*       <NumeroPedido>0</NumeroPedido>                                                                                  */
/*       <NumeroPedidoCliente>EXP_105</NumeroPedidoCliente>                                                              */
/*       <Representante>2000</Representante>                                                                             */
/*       <CodigoClienteCRM>e0b4423b-e7f8-e411-9418-00155d01421e</CodigoClienteCRM>                                       */
/*       <TipoObjetoCliente>account</TipoObjetoCliente>                                                                  */
/*       <Atendente>99</Atendente>                                                                                       */
/*       <CodigoSupervisorEMS>ca037830</CodigoSupervisorEMS>                                                             */
/*       <Estabelecimento>104</Estabelecimento>                                                                          */
/*       <CondicaoPagamento>0</CondicaoPagamento>                                                                        */
/*       <CondicaoEspecial>Reposicao de pecas em garantia</CondicaoEspecial>                                             */
/*       <Observacao>0006000018 - 2880830, 0006000019 - 2880830, 0006000020 - 2880830, 0006000021 - 4310003</Observacao> */
/*       <FaturamentoParcial>false</FaturamentoParcial>                                                                  */
/*       <Vendor>false</Vendor>                                                                                          */
/*       <DataEmissao>2019-02-26</DataEmissao>                                                                           */
/*       <DataEntrega>2019-02-26</DataEntrega>                                                                           */
/*       <Situacao>2</Situacao>                                                                                          */
/*       <NomeUsuarioCriacao>NomeUsuarioCriacao</NomeUsuarioCriacao>                                                     */
/*       <TipoUsuarioCriacao>993520004</TipoUsuarioCriacao>                                                              */
/*       <TipoNaturezaOperacao>2</TipoNaturezaOperacao>                                                                  */
/*       <TabelaPrecoEMS>LAI02</TabelaPrecoEMS>                                                                          */
/*       <OrigemPedido>993520016</OrigemPedido>                                                                          */
/*       <PedidoItens>                                                                                                   */
/*         <PedidoItem>                                                                                                  */
/*           <ChaveIntegracao></ChaveIntegracao>                                                                         */
/*           <Produto>2880830</Produto>                                                                                  */
/*           <Sequencia></Sequencia>                                                                                     */
/*           <QuantidadePedida>3</QuantidadePedida>                                                                      */
/*           <PrecoOriginal>0.00</PrecoOriginal>                                                                         */
/*           <Acao>A</Acao>                                                                                              */
/*           <CalcularRebate>true</CalcularRebate>                                                                       */
/*           <PercentualDescontoVerde>0</PercentualDescontoVerde>                                                        */
/*           <PercentualDescontoTopMilhao>0</PercentualDescontoTopMilhao>                                                */
/*           <PercentualRebateAntecipado>0</PercentualRebateAntecipado>                                  */
/*         </PedidoItem>                                                                                                 */
/*         <PedidoItem>                                                                                                  */
/*           <ChaveIntegracao></ChaveIntegracao>                                                                         */
/*           <Produto>4310003</Produto>                                                                                  */
/*           <Sequencia></Sequencia>                                                                                     */
/*           <QuantidadePedida>1</QuantidadePedida>                                                                      */
/*           <PrecoOriginal>0.00</PrecoOriginal>                                                                         */
/*           <Acao>A</Acao>                                                                                              */
/*           <CalcularRebate>true</CalcularRebate>                                                                       */
/*           <PercentualDescontoVerde>0</PercentualDescontoVerde>                                                        */
/*           <PercentualDescontoTopMilhao>0</PercentualDescontoTopMilhao>                                                */
/*           <PercentualRebateAntecipado>0</PercentualRebateAntecipado>                                  */
/*         </PedidoItem>                                                                                                 */
/*       </PedidoItens>                                                                                                  */
/*     </MSG0093>                                                                                                        */
/*   </CONTEUDO>                                                                                                         */
/* </MENSAGEM>".                                                                                                         */

/* ativa profiler */
/* assign profiler:coverage = false                                 */
/*     profiler:filename = '/opt/totvs/spool/an046325/profiler.out' */
/*     profiler:listings = false                                    */
/*     profiler:enabled = true                                      */
/*     profiler:Profiling = true.                                   */
/* Fim ativa profiler */
DEFINE VARIABLE raw-param           AS RAW.
DEFINE VARIABLE bo-ped-item         AS HANDLE    NO-UNDO.
DEFINE VARIABLE bo-ped-venda        AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boes505           AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-nat-oper          AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-return            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i-sequencia         AS INTEGER   NO-UNDO.
DEFINE VARIABLE h-bodi317im1br      AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi159cal        AS HANDLE    NO-UNDO.
DEFINE VARIABLE de-perc-icms        AS DECIMAL   NO-UNDO.
DEFINE VARIABLE h-bodi154sdf        AS HANDLE    NO-UNDO.          
DEFINE VARIABLE h-bodi159sus        AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi154cal        AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi154           AS HANDLE    NO-UNDO.
DEFINE VARIABLE bo-ped-venda-can    AS HANDLE    NO-UNDO.
DEFINE VARIABLE bo-ped-item-can     AS HANDLE    NO-UNDO.
DEFINE VARIABLE de-valor-st         AS DECIMAL   NO-UNDO.
DEFINE VARIABLE l-abriu-ped         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-erro              AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-servico           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-servicoItemDif    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-NomCliOrigServ    LIKE ped-venda.nome-abrev  NO-UNDO.
DEFINE VARIABLE c-PedidoOrigServ    LIKE ped-venda.nr-pedcli   NO-UNDO.
DEFINE VARIABLE i-item-pai          AS INTEGER  INIT 10        NO-UNDO.
DEFINE VARIABLE l-altera-priori-ped AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE lsuspendeped        AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE l-maisVerde         AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE l-consumidor-final  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-nat-oper-dentro-estado-contrib     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper-dentro-estado-nao-contrib AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper-fora-estado-contrib       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper-fora-estado-nao-contrib   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-icms                              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-ok                                 AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-cont                               AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-off-grid AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-obs-braco AS LOGICAL     NO-UNDO.

DEF BUFFER b-ped-item  FOR ped-item.
DEF BUFFER b1-ped-item FOR ped-item.
DEF BUFFER b-ped-ent   FOR ped-ent.


DEF NEW GLOBAL SHARED VARIABLE g-cod-emitente-bodi317im1br AS INTEGER.
DEF NEW GLOBAL SHARED VARIABLE g-codigo-orig-bodi317sd     AS INTEGER.

{method/dbotterr.i}
{esp/esb/in/msg0093.i}
{utp/ut-glob.i}
{utp/utapi009.i}
{esp/es0018.i}
{include/i-freeac.i}
DEFINE NEW GLOBAL SHARED TEMP-TABLE ProdutoItem NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto            AS CHAR
    FIELD Bloqueado                AS LOG
    FIELD Cached                   AS LOG
    FIELD TipoPortfolio            AS INT.  /* 993520000: Box Mover
                                                993520001: VAD
                                                993520002: Exclusivo
                                                993520003: Cross-Selling
                                                993520004: Soluá∆o */

DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD it-codigo              AS CHAR
    FIELD de-quantidade          AS DEC
    FIELD TipoPortfolio          AS INTEGER
    FIELD CodigoUnidadeNegocio   AS CHAR
    FIELD CodigoFamiliaComercial AS CHAR
    FIELD CodigoEstabelecimento  AS CHAR.

DEFINE TEMP-TABLE ProdutoItemR NO-UNDO XML-NODE-NAME 'ProdutoItem'
    FIELD idm AS INT XML-NODE-TYPE 'hidden'
    FIELD CodigoProduto               AS CHAR
    FIELD PrecoBase                   AS DEC
    FIELD ValorProduto                AS DEC
    FIELD NomePoliticaComercial       AS CHAR
    FIELD TemCache                    AS LOGICAL
    FIELD DataValidade                AS DATE
    FIELD QuantidadeMaxima            AS DEC
    FIELD RebateAntecipado            AS LOGICAL
    FIELD CalcularRebate              AS LOGICAL
    FIELD PrecoAlterado               AS LOGICAL
    FIELD ValorComDesconto            AS DEC
    FIELD PercentualRebateAntecipado  AS DEC
    FIELD PercentualDescontoVerde     AS DEC
    FIELD PercentualDescontoTopMilhao AS DEC.

DEFINE TEMP-TABLE tt-item-aberto NO-UNDO
    FIELD it-codigo    LIKE ped-item.it-codigo
    FIELD nr-sequencia LIKE ped-item.nr-sequencia
    INDEX it        it-codigo nr-sequencia.

DEFINE TEMP-TABLE tt-ped-repre      NO-UNDO LIKE ped-repre
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-venda  NO-UNDO LIKE int-ped-venda
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-item   NO-UNDO LIKE int-ped-item
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-int-ped-item-rebate   NO-UNDO LIKE int-ped-item-rebate
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-item LIKE ped-item 
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-ped-venda LIKE ped-venda 
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0093, parcelas, parcela, Itens, item-pedido, itempai
   DATA-RELATION FOR conteudo,    msg0093     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0093,     parcelas    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR parcelas,    parcela     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0093,     Itens       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR Itens,       item-pedido RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR item-pedido, itempai     RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('longchar', iXML, 'empty', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0093r, pedidor, Itensr, item-pedidor, resultado
   DATA-RELATION FOR conteudor, msg0093r     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0093r,  pedidor      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR pedidor,   Itensr       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR Itensr,    item-pedidor RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0093r,  resultado    RELATION-FIELDS (idm, idm) NESTED.

FIND FIRST msg0093.

IF msg0093.CondicaoEspecial = ? THEN
    ASSIGN msg0093.CondicaoEspecial = "".

IF msg0093.Representante = ? THEN
    ASSIGN msg0093.Representante = 0.

IF msg0093.Observacao = ? THEN
    ASSIGN msg0093.Observacao = "".

FIND FIRST ped-venda EXCLUSIVE-LOCK
     WHERE ped-venda.nr-pedido = int(msg0093.NumeroPedido) NO-ERROR NO-WAIT.
IF LOCKED(ped-venda) THEN DO:
    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedido = int(msg0093.NumeroPedido) NO-ERROR.

    RUN pi-erro (INPUT "Pedido em manutená∆o internamente, por favor tente mais tarde").
    RUN pi-gera-retorno-erro.

END.
FOR EACH ped-item OF ped-venda NO-LOCK:
    FIND b-ped-item 
         WHERE rowid(b-ped-item) = rowid(ped-item)
         EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF LOCKED(b-ped-item) THEN DO:
        RUN pi-erro (INPUT "Pedido em manutená∆o internamente, por favor tente mais tarde").
        RUN pi-gera-retorno-erro.

    END.
    FOR EACH ped-ent OF ped-item NO-LOCK:
        FIND b-ped-ent 
            WHERE rowid(b-ped-ent) = rowid(ped-ent) 
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF LOCKED(b-ped-ent) THEN DO:
            RUN pi-erro (INPUT "Pedido em manutená∆o internamente, por favor tente mais tarde").
            RUN pi-gera-retorno-erro.

        END.
    END.

    /*Grava os valores dos itens filhos da prod-composto na ProdutoItemR*/
    EMPTY TEMP-TABLE tt-itens.
    EMPTY TEMP-TABLE Resultado.
END.

FOR EACH itempai.
    RUN pi-log("ItemPai " + itempai.CodigoProduto + ' - ' + string(itempai.QuantidadePedida)).    
END.

IF NOT CAN-FIND (FIRST tt-erro) THEN DO:
    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedido = int(msg0093.NumeroPedido) NO-ERROR.
    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:
    
        ASSIGN l-abriu-ped = NO.
    
        IF AVAIL ped-venda THEN DO: 
            /*Marca o pedido e os itens suspensos como aberto para poder alterar*/

            RUN pi-log (INPUT "ABRIU PEDIDO : " + STRING(ped-venda.cod-sit-ped)). 

            IF ped-venda.cod-sit-ped = 5 THEN DO:
                FIND CURRENT ped-venda EXCLUSIVE-LOCK.
                ASSIGN ped-venda.cod-sit-ped = 1.
                FIND CURRENT ped-venda NO-LOCK.
                ASSIGN l-abriu-ped = YES.
    
                EMPTY TEMP-TABLE tt-item-aberto.
    
                FOR EACH ped-item OF ped-venda 
                    WHERE ped-item.cod-sit-item = 5 EXCLUSIVE-LOCK:
                    CREATE tt-item-aberto.
                    ASSIGN tt-item-aberto.it-codigo    = ped-item.it-codigo
                           tt-item-aberto.nr-sequencia = ped-item.nr-sequencia.
                    ASSIGN ped-item.cod-sit-item = 1.
                    FOR EACH ped-ent OF ped-item
                        WHERE ped-ent.cod-sit-ent = 5 exclusive-lock:
        
                        ASSIGN ped-ent.cod-sit-ent  = 1.
        
                    END.
                END.
            END.
            /**/

            /************************************
            FOR EACH itempai NO-LOCK.
                MESSAGE itempai.idm              SKIP
                        itempai.CodigoProduto    SKIP
                        itempai.QuantidadePedida VIEW-AS ALERT-BOX.
            END.
            ************************************/
            
            FIND FIRST int-ped-venda NO-LOCK
                 WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
        
            IF  ped-venda.cod-sit-ped <> 1
            AND ped-venda.cod-sit-ped <> 2 THEN DO:
                RUN pi-erro (INPUT "Pedido s¢ pode ser alterado com situaá∆o aberto ou atendido parcial").
            END.
            IF ped-venda.cod-priori = 10 THEN DO:
                RUN pi-erro (INPUT "Pedido j† enviado para o faturamento n∆o pode ser alterado").
            END.
    
            IF msg0093.DataEntrega > TODAY + 730 THEN
                RUN pi-erro (INPUT "Data de entrega superior a 2 anos!").

            IF CAN-FIND (FIRST tt-erro) THEN DO:
                RUN pi-gera-retorno-erro.
                UNDO blk_principal, LEAVE blk_principal.
            END.
    
            IF msg0093.Situacao = 3 THEN DO: /*Cancela Pedido*/
                RUN pi-cancela-pedido.
            END.
            ELSE DO:
                RUN pi-altera-pedido. /*altera o cabeáalho*/
    
                IF RETURN-VALUE = "NOK" THEN DO:
                    RUN pi-gera-retorno-erro.
                    UNDO blk_principal, LEAVE blk_principal.
                END.
                
                FOR EACH ped-item OF ped-venda NO-LOCK:
                    FIND FIRST item-pedido NO-LOCK
                        WHERE item-pedido.Produto   = ped-item.it-codigo 
                          AND item-pedido.Sequencia = ped-item.nr-sequencia NO-ERROR.
                    IF AVAIL item-pedido THEN DO:
                        IF (item-pedido.acao = "E" OR  item-pedido.acao = "A" OR  item-pedido.acao = "C") THEN DO:

                            FIND FIRST int-emitente NO-LOCK
                                 WHERE int-emitente.cod-guid     = msg0093.CodigoClienteCRM NO-ERROR.
                                   
                            IF AVAIL int-emitente AND int-emitente.ind-participa-canais = 993520001 /* Participa canais */ THEN DO:
                                FIND FIRST int-calculo-canal-item EXCLUSIVE-LOCK
                                     WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
                                       AND int-calculo-canal-item.cod-estabel = ped-venda.cod-estabel
                                       AND int-calculo-canal-item.it-codigo   = ped-item.it-codigo NO-ERROR.
                                IF AVAIL int-calculo-canal-item THEN DO:
                                    IF int-calculo-canal-item.data-calculo <> TODAY THEN
                                        ASSIGN int-calculo-canal-item.valor-produto          = item-pedido.PrecoOriginal
                                               int-calculo-canal-item.perc-descto-verde      = item-pedido.PercentualDescontoVerde
                                               int-calculo-canal-item.perc-descto-top-milhao = item-pedido.PercentualDescontoTopMilhao
                                               int-calculo-canal-item.perc-rebate-antec      = item-pedido.PercentualRebateAntecipado
                                               int-calculo-canal-item.data-calculo           = TODAY.
                                END.
                                ELSE DO:
                                    CREATE int-calculo-canal-item.
                                    ASSIGN int-calculo-canal-item.cod-guid               = int-emitente.cod-guid   
                                           int-calculo-canal-item.cod-estabel            = ped-venda.cod-estabel   
                                           int-calculo-canal-item.it-codigo              = ped-item.it-codigo
                                           int-calculo-canal-item.preco-base             = item-pedido.PrecoOriginal
                                           int-calculo-canal-item.valor-produto          = item-pedido.PrecoOriginal
                                           int-calculo-canal-item.tipo-portifolio        = 993520005
                                           int-calculo-canal-item.bloqueado              = NO
                                           int-calculo-canal-item.qtd-range              = 0
                                           int-calculo-canal-item.log-calcrebate         = NO   
                                           int-calculo-canal-item.log-preco-alterado     = NO
                                           int-calculo-canal-item.log-rebate-antec       = NO
                                           int-calculo-canal-item.perc-descto-verde      = item-pedido.PercentualDescontoVerde
                                           int-calculo-canal-item.perc-descto-top-milhao = item-pedido.PercentualDescontoTopMilhao
                                           int-calculo-canal-item.perc-rebate-antec      = item-pedido.PercentualRebateAntecipado
                                           int-calculo-canal-item.data-calculo           = TODAY.
                                END.
                                FIND CURRENT int-calculo-canal-item NO-LOCK NO-ERROR.
                                RELEASE int-calculo-canal-item.
                            END.

                            IF ped-item.qt-alocada   <> 0
                            OR ped-item.qt-log-aloca <> 0 THEN DO:
                                RUN pi-erro (INPUT "ITEM com quantidade alocada n∆o pode ser alterado").
                            END.
                
                            IF ped-item.cod-sit-item <> 1 THEN DO:
                                RUN pi-erro (INPUT "Somente itens com situaá∆o aberto podem ser alterados.").
                            END.
            
                            IF CAN-FIND (FIRST tt-erro) THEN DO:
                                RUN pi-gera-retorno-erro.
                                UNDO blk_principal, LEAVE blk_principal.
                            END.
            
                            IF item-pedido.acao = "A" THEN DO: /*Altera o Item*/
                                RUN pi-altera-item.
                                IF RETURN-VALUE = "NOK" THEN DO:
                                    RUN pi-gera-retorno-erro.
                                    UNDO blk_principal, LEAVE blk_principal.
                                END.
                            END.
                            ELSE IF item-pedido.acao = "E" THEN DO: /*Exclui Item*/
                                RUN pi-exclui-item.
                                IF RETURN-VALUE = "NOK" THEN DO:
                                    RUN pi-gera-retorno-erro.
                                    UNDO blk_principal, LEAVE blk_principal.
                                END.
                            END.
                            ELSE IF item-pedido.acao = "C" THEN DO: /*Cancelar Item*/
                                RUN pi-cancela-item.
                                IF RETURN-VALUE = "NOK" THEN DO:
                                    RUN pi-gera-retorno-erro.
                                    UNDO blk_principal, LEAVE blk_principal.
                                END.
                            
                            END.

                        END. /* IF (item-pedido.acao = "E" OR  item-pedido.acao = "A" OR  item-pedido.acao = "C") THEN DO: */

                    END. /* IF AVAIL item-pedido THEN DO: */

                END.
                FOR EACH item-pedido 
                   WHERE item-pedido.Sequencia = ?:
                     
                    RUN CriaItem (INPUT item-pedido.produto,
                                  INPUT item-pedido.QuantidadePedida,
                                  INPUT item-pedido.PrecoOriginal,
                                  INPUT YES,
                                  INPUT NO).

                    IF RETURN-VALUE = "NOK" THEN DO:
                        RUN pi-gera-retorno-erro.
                        UNDO blk_principal, LEAVE blk_principal.
                    END.
                    
                END.
                FIND CURRENT ped-venda EXCLUSIVE-LOCK.
                IF l-abriu-ped THEN DO:

                    RUN pi-log (INPUT "ABRIU PEDIDO : " + STRING(ped-venda.cod-sit-ped)). 
                    
                    IF ped-venda.cod-sit-ped <>  6 THEN
                        ASSIGN ped-venda.cod-sit-ped = 5.
                    FIND CURRENT ped-venda NO-LOCK.

                    FOR EACH tt-item-aberto:
                        FIND FIRST ped-item OF ped-venda EXCLUSIVE-LOCK
                             WHERE ped-item.it-codigo    = tt-item-aberto.it-codigo
                               AND ped-item.nr-sequencia = tt-item-aberto.nr-sequencia
                               AND ped-item.cod-sit-item = 1 NO-ERROR.

                        IF AVAIL ped-item THEN DO:
                            FOR EACH ped-ent OF ped-item
                                WHERE ped-ent.cod-sit-ent = 1 exclusive-lock:
                
                                ASSIGN ped-ent.cod-sit-ent  = 5.
                
                            END.
                            ASSIGN ped-item.cod-sit-item = 5.    
                        END.
                    END.
                END.

                /* Feito isto para calcular o valor do pedido antes de suspender */

                IF NOT VALID-HANDLE(h-bodi159cal) THEN
                   RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.
            
                for each ped-item of ped-venda exclusive-lock
                    WHERE ped-item.cod-sit-item = 5:
            
                    for each ped-ent of ped-item exclusive-lock:
        
                        assign ped-ent.cod-sit-ent  = 1.
                    end.
        
                    assign ped-item.cod-sit-item = 1.
        
                end.

                //atualiza %ipi e ncm no pedido caso esteja diferente o cadastro do item
                FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK:

                    IF ped-item.cod-sit-item = 3 THEN NEXT.

                    FIND FIRST ITEM NO-LOCK
                         WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.
                    IF AVAIL ITEM THEN DO:
                       IF ped-item.aliquota-ipi <> item.aliquota-ipi THEN
                           ASSIGN ped-item.aliquota-ipi = item.aliquota-ipi.
                     
                       if  item.ind-ipi-dife = no and item.tipo-contr <> 4 then do:
                           assign substring(ped-item.char-2,01,08) = "        ".
                       end.
                       else do:
                           assign substring(ped-item.char-2,01,08) = item.class-fiscal  + fill(" ",8 - length(item.class-fiscal)).
                       end.
                    END.

                END.

                FIND CURRENT ped-venda EXCLUSIVE-LOCK.
                ASSIGN ped-venda.completo = NO.
                FIND CURRENT ped-venda NO-LOCK.
                RUN completeOrder IN h-bodi159cal (INPUT  ROWID(ped-venda),
                                                   OUTPUT TABLE rowErrors).

                FIND FIRST pedidor NO-ERROR.

                FIND CURRENT ped-venda NO-LOCK NO-ERROR.
                
                FOR EACH ped-item OF ped-venda NO-LOCK:
                    ASSIGN de-valor-st = 0.
                    /*Substituiá∆o Tribut†ria */
                    FIND FIRST natur-oper NO-LOCK
                        WHERE  natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.
                
                    IF  AVAIL natur-oper 
                    AND natur-oper.subs-trib THEN DO:
                        ASSIGN de-valor-st = ROUND(ped-item.vl-tot-it - ped-item.vl-liq-it - (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2).
                    END.
        
                    FIND FIRST item-pedidor NO-LOCK
                         WHERE item-pedidor.Produto   = ped-item.it-codigo
                           AND item-pedidor.Sequencia = ped-item.nr-sequencia NO-ERROR.
                    IF AVAIL item-pedidor THEN DO:
                        ASSIGN  item-pedidor.ValorSubstituicaoTributaria = round(de-valor-st,4)
                                item-pedidor.QuantidadePedida            = ped-item.qt-pedida
                                item-pedidor.PrecoOriginal               = round(ped-item.vl-pretab,4)
                                item-pedidor.ValorLiquido                = round(ped-item.vl-liq-it,4)
                                item-pedidor.ValorLiquidoAberto          = round(ped-item.vl-liq-abe,4)
                                item-pedidor.ValorIPI                    = round(ped-item.val-ipi,4)
                                item-pedidor.AliquotaIPI                 = round(ped-item.aliquota-ipi,2)
                                item-pedidor.ValorICMS                   = round(ped-item.vl-liq-it * de-perc-icms / 100,2)
                                item-pedidor.ValorTotal                  = round(ped-item.vl-tot-it,4).            

                        FIND FIRST int-ped-item-rebate
                            WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev  
                              AND int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli   
                              AND int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
                              AND int-ped-item-rebate.it-codigo    = ped-item.it-codigo   
                              AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer   NO-LOCK NO-ERROR.
                        IF AVAIL int-ped-item-rebate THEN DO:
                            ASSIGN item-pedidor.CalcularRebate                = int-ped-item-rebate.log-calcrebate
                                   item-pedidor.PercentualDescontoVerde       = int-ped-item-rebate.perc-descto-verde
                                   //item-pedidor.PercentualDescontoTopMilhao   = int-ped-item-rebate.perc-descto-top-milhao
                                   //item-pedidor.PercentualRebateAntecipado = int-ped-item-rebate.perc-rebate-antec
                                    .
                        END.

                    END.
        
                    IF ped-item.cod-sit-item <> 6 THEN 
                        ASSIGN pedidor.TotalIPI                    = pedidor.TotalIPI + ped-item.val-ipi
                               pedidor.TotalSubstituicaoTributaria = pedidor.TotalSubstituicaoTributaria + de-valor-st.
                    /*
                    IF NOT lsuspendeped AND ped-venda.completo THEN DO:
                        FOR FIRST int-campanha-item
                            WHERE int-campanha-item.it-codigo = ped-item.it-codigo NO-LOCK,
                            FIRST int-campanha
                            WHERE int-campanha.cod-campanha = int-campanha-item.cod-campanha
                            AND   (int-campanha.cod-gr-cli   = ped-venda.cod-gr-cli
                                OR int-campanha.cod-gr-cli   = 0) NO-LOCK:
                        
                            ASSIGN lsuspendeped          = YES
                                   ped-venda.observacoes = ped-venda.observacoes + CHR(10) + int-campanha.cobs.
                        END.
                    END.
                    */
                END.

                ASSIGN pedidor.ValorTotalPedido = round(ped-venda.vl-tot-ped,4).              
                /* Feito isto para calcular o valor do pedido antes de suspender */

                /* TRATAMENTO PEDIDOS PROGRAMADOS */
                IF  msg0093.PedidoProgramado AND msg0093.Situacao = 2 /*Efetivado*/ THEN DO:

                    ASSIGN l-maisVerde = YES.

                    bloco-descto-verde:
                    FOR EACH int-ped-item-rebate NO-LOCK
                       WHERE int-ped-item-rebate.nome-abrev = ped-venda.nome-abrev
                         AND int-ped-item-rebate.nr-pedcli  = ped-venda.nr-pedcli:

                       IF  l-maisVerde = YES 
                       AND int-ped-item-rebate.perc-descto-verde = 0 THEN DO:
                           ASSIGN l-maisVerde = NO.

                           LEAVE bloco-descto-verde.
                       END.
                    END.                    

                    FIND CURRENT ped-venda EXCLUSIVE-LOCK.
                    IF  AVAIL ped-venda THEN
                        IF l-maisVerde THEN
                            ASSIGN ped-venda.cod-priori = 04.
                        ELSE
                            ASSIGN ped-venda.cod-priori = 02 /*Programado*/.

                    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                        WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

                    IF  AVAIL int-ped-venda THEN
                        IF l-maisVerde THEN
                            ASSIGN int-ped-venda.cod-priori-orig = 04.
                        ELSE
                            ASSIGN int-ped-venda.cod-priori-orig = 02.

                    RUN pi-log("Prioridade - Programado: " + STRING(ped-venda.cod-priori)).

                    FIND CURRENT ped-venda NO-LOCK.
                END.

                FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                     WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

                IF AVAIL int-ped-venda THEN DO:
                    ASSIGN int-ped-venda.vl-serv-inst = msg0093.ValorServicoInstalacao.
                END.
                ELSE DO:
                    CREATE int-ped-venda.
                    ASSIGN int-ped-venda.nr-pedido    = ped-venda.nr-pedido
                           int-ped-venda.vl-serv-inst = msg0093.ValorServicoInstalacao.

                END.

                FIND CURRENT int-ped-venda NO-LOCK.

                /*128171 - nao suspender quando TipoNaturezaOperacao = 2 */
                IF msg0093.TipoNaturezaOperacao <> 2 THEN
                    RUN UpdateSuspension.   

                RELEASE ped-venda.
               
                FIND FIRST ped-venda NO-LOCK
                     WHERE ped-venda.nr-pedido = int(msg0093.NumeroPedido) NO-ERROR.
                
                IF NOT ped-venda.completo THEN DO:
                    IF NOT VALID-HANDLE(h-bodi159cal) THEN
                        RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.
            
                    RUN completeOrder IN h-bodi159cal (INPUT  ROWID(ped-venda),
                                                       OUTPUT TABLE rowErrors).
                END.               
                
                FOR EACH rowErrors NO-LOCK
                   WHERE rowErrors.errornumber  = 26468:  
                    FIND ITEM 
                         WHERE ITEM.it-codigo = substring(rowErrors.errorDescription,6,7)
                         NO-LOCK NO-ERROR.
    
                    ASSIGN rowErrors.errorDescription = "O produto " + 
                                                        (IF AVAIL ITEM THEN ITEM.it-codigo + " " + ITEM.desc-item ELSE "") + 
                                                        " est† temporariamente bloqueado para faturamento. Favor remover o item do pedido e entrar em contato com a †rea comercial".
                    
                END.
                
                FOR EACH rowErrors NO-LOCK
                   WHERE rowErrors.errornumber  <> 8259
                     AND RowErrors.ErrorType    <> "INTERNAL":U
                     AND RowErrors.ErrorSubType = "Error":U:  /* credito n∆o aprovado */
                    RUN pi-erro (INPUT RowErrors.errorDescription + " Cliente: " + ped-venda.nome-abrev + " Pedido: " + ped-venda.nr-pedcli).
                    
                END.
            END. /*ELSE msg0093.Situacao = 3*/
    

            IF CAN-FIND (FIRST tt-erro) THEN DO:
                RUN pi-gera-retorno-erro.
                UNDO blk_principal, LEAVE blk_principal.
            END.
        END.
        ELSE DO: /*cria novo pedido*/
            IF msg0093.Situacao = 3 THEN DO: /*Cancela Pedido inexistente*/ 
                RUN pi-erro (INPUT  " Tentativa de cancelar pedido Inexistente ").
                RUN pi-gera-retorno-erro.
                UNDO blk_principal, LEAVE blk_principal.
            END.
            
            RUN esp/esb/in/msg0093a.p (INPUT  TABLE msg0093,
                                       INPUT  TABLE item-pedido,
                                       INPUT  TABLE cabecalho,
                                       INPUT  TABLE parcela,
                                       OUTPUT TABLE tt-erro,
                                       OUTPUT TABLE msg0093r,
                                       OUTPUT TABLE pedidor,
                                       OUTPUT TABLE Itensr,
                                       OUTPUT TABLE item-pedidor).

            FIND FIRST pedidor NO-ERROR.

            ASSIGN c-nat-oper = ''.

            FIND FIRST ped-venda EXCLUSIVE-LOCK
                WHERE ped-venda.nr-pedido = int(pedidor.NumeroPedido) NO-ERROR.

            IF AVAIL ped-venda THEN DO:

                RUN pi-log("Criando pedido2 - ped-venda.nat-operacao " + ped-venda.nat-operacao).
                ASSIGN pedidor.ValorTotalPedido = round(ped-venda.vl-tot-ped,4).
                FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK:

                    FIND FIRST ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.

/*                     IF AVAIL ITEM THEN DO:                                                                              */
/*                         IF ITEM.cod-servico <> 0 THEN DO:                                                               */
/*                             IF ITEM.it-codigo = "9945135"  THEN                                                         */
/*                                ASSIGN c-nat-oper            = "800004"                                                  */
/*                                       ped-item.nat-operacao = c-nat-oper.                                               */
/*                             ELSE                                                                                        */
/*                                ASSIGN c-nat-oper            = "800001"                                                  */
/*                                       ped-item.nat-operacao = c-nat-oper.                                               */
/*                         END.                                                                                            */
/*                         RUN pi-log("Criando pedido - atualizando ITEM ped-item.nat-operacao " + ped-item.nat-operacao). */
/*                     END. /* IF AVAIL ITEM THEN DO: */                                                                   */
                    
                    ASSIGN de-valor-st           = 0.

                    /*Substituiá∆o Tribut†ria */
                    FIND FIRST natur-oper NO-LOCK
                        WHERE  natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.
                    IF  AVAIL natur-oper AND natur-oper.subs-trib THEN DO:
                        ASSIGN de-valor-st = ROUND(ped-item.vl-tot-it - ped-item.vl-liq-it - (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2).
                    END.

                    FIND FIRST item-pedidor NO-LOCK
                         WHERE item-pedidor.Produto   = ped-item.it-codigo
                           AND item-pedidor.Sequencia = ped-item.nr-sequencia NO-ERROR.
                    IF AVAIL item-pedidor THEN
                        ASSIGN  item-pedidor.ValorSubstituicaoTributaria = round(de-valor-st,4)
                                item-pedidor.QuantidadePedida            = ped-item.qt-pedida
                                item-pedidor.PrecoOriginal               = round(ped-item.vl-pretab,4)
                                item-pedidor.ValorLiquido                = round(ped-item.vl-liq-it,4)
                                item-pedidor.ValorLiquidoAberto          = round(ped-item.vl-liq-abe,4)
                                item-pedidor.ValorIPI                    = round(ped-item.val-ipi,4)
                                item-pedidor.AliquotaIPI                 = round(ped-item.aliquota-ipi,2)
                                item-pedidor.ValorICMS                   = round(ped-item.vl-liq-it * de-perc-icms / 100,2)
                                item-pedidor.ValorTotal                  = round(ped-item.vl-tot-it,4).

                    FIND FIRST int-ped-item-rebate
                        WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev  
                          AND int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli   
                          AND int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
                          AND int-ped-item-rebate.it-codigo    = ped-item.it-codigo   
                          AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer   NO-LOCK NO-ERROR.
                    IF AVAIL int-ped-item-rebate THEN DO:
                        ASSIGN item-pedidor.CalcularRebate                = int-ped-item-rebate.log-calcrebate
                               item-pedidor.PercentualDescontoVerde       = int-ped-item-rebate.perc-descto-verde
                               //item-pedidor.PercentualDescontoTopMilhao   = int-ped-item-rebate.perc-descto-top-milhao
                               //item-pedidor.PercentualRebateAntecipado = int-ped-item-rebate.perc-rebate-antec
                               .
                    END.

                    IF ped-item.cod-sit-item <> 6 THEN 
                        ASSIGN pedidor.TotalIPI                    = pedidor.TotalIPI + ped-item.val-ipi
                               pedidor.TotalSubstituicaoTributaria = pedidor.TotalSubstituicaoTributaria + de-valor-st.

                END. /* FOR EACH ped-item OF ped-venda NO-LOCK: */
                FIND CURRENT ped-item NO-LOCK NO-ERROR.
                RELEASE ped-item.

                RUN pi-log("Criando pedido2 - saindo atualiza pedido ITEM ped-item.nat-operacao " + ped-venda.nat-operacao + " " + c-nat-oper).
                IF c-nat-oper <> '' THEN
                    ASSIGN ped-venda.nat-operacao = c-nat-oper.
                RUN pi-log("Criando pedido2 - atualizando PEDIDO ped-venda.nat-operacao " + ped-venda.nat-operacao).
    
                IF RETURN-VALUE = "NOK" THEN DO:
                    RUN pi-gera-retorno-erro.
                    UNDO blk_principal, LEAVE blk_principal.
                END.

            END. /* IF AVAIL ped-venda THEN DO: */

            FIND CURRENT ped-venda NO-LOCK NO-ERROR.
            RELEASE ped-venda.
        END.   
        
        /*Totais*/
        FIND FIRST ped-venda EXCLUSIVE-LOCK
             WHERE ped-venda.nr-pedido = int(pedidor.NumeroPedido) NO-ERROR.
        IF AVAIL ped-venda THEN DO:

            IF ped-venda.observacoes = "" THEN
                ASSIGN l-obs-braco = YES.
            ELSE 
                ASSIGN l-obs-braco = NO.
         
            RUN esp/es0018p.p (INPUT  "pd4000":U,
                               INPUT  11,
                               INPUT  0,
                               INPUT  "":U,
                               OUTPUT TABLE tt-prog-ponto).

            IF  CAN-FIND (FIRST tt-prog-ponto
                          WHERE tt-prog-ponto.conteudo = STRING(ped-venda.cod-cond-pag)) THEN
                ASSIGN ped-venda.observacoes = ped-venda.observacoes + "Atená∆o! Pedido com  condiá∆o Santander.".

            ASSIGN l-off-grid = NO.
            FOR EACH ped-item OF ped-venda:

                RUN esp/es0018p.p (INPUT  "pd4000":U,
                               INPUT  10,
                               INPUT  0,
                               INPUT  "":U,
                               OUTPUT TABLE tt-prog-ponto).

                IF CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = ped-item.it-codigo) THEN
                    ASSIGN l-off-grid = YES.

                FOR EACH itempai NO-LOCK:

                    IF itempai.CodigoProduto <> '' THEN DO:

                        RUN pi-log("ITEM Composto pai  " + itempai.CodigoProduto + " - FILHO " + ped-item.it-codigo).

                        /*Chamado 76565, se Ç prioridade 3 (pedido mais verde), n∆o muda a prioridade para 99*/
                        IF  ped-venda.observacoes = ? THEN DO:
                            ASSIGN ped-venda.observacoes = " Atená∆o! Pedido com produto composto! " + itempai.CodigoProduto.
                        END.
                        ELSE DO:
                            IF NOT ped-venda.observacoes MATCHES "*" + STRING("Atená∆o! Pedido com produto composto! " + itempai.CodigoProduto) + "*" THEN
                                ASSIGN ped-venda.observacoes = ped-venda.observacoes + CHR(10) + "Atená∆o! Pedido com produto composto! " + itempai.CodigoProduto.
                        END.
                                   
                        /*IF  ped-venda.cod-priori <> 3 THEN
                            ASSIGN ped-venda.cod-priori = 99.*/

                        FIND FIRST prod-composto
                            WHERE  prod-composto.it-codigo-pai   = itempai.CodigoProduto
                              AND  prod-composto.it-codigo-filho = ped-item.it-codigo   NO-LOCK NO-ERROR.
                        IF AVAIL prod-composto THEN DO:
                            FIND FIRST int-ped-item-pai
                                WHERE int-ped-item-pai.nome-abrev    = ped-item.nome-abrev  
                                  AND int-ped-item-pai.nr-pedcli     = ped-venda.nr-pedcli
                                  AND int-ped-item-pai.nr-sequencia  = 10
                                  AND int-ped-item-pai.it-codigo     = ped-item.it-codigo   
                                  AND int-ped-item-pai.cod-refer     = ped-item.cod-refer 
                                  AND int-ped-item-pai.it-codigo-pai = itempai.CodigoProduto  NO-LOCK NO-ERROR.
                            IF NOT AVAIL int-ped-item-pai THEN DO:
                                CREATE int-ped-item-pai.
                                ASSIGN int-ped-item-pai.nome-abrev    = ped-item.nome-abrev  
                                       int-ped-item-pai.nr-pedcli     = ped-venda.nr-pedcli
                                       int-ped-item-pai.nr-sequencia  = 10
                                       int-ped-item-pai.it-codigo     = ped-item.it-codigo   
                                       int-ped-item-pai.cod-refer     = ped-item.cod-refer   
                                       int-ped-item-pai.it-codigo-pai = itempai.CodigoProduto  
                                       int-ped-item-pai.qt-pedida     = itempai.QuantidadePedida.
                            END. /* IF NOT AVAIL int-ped-item-pai THEN DO: */
                        END. /* IF AVAIL prod-composto THEN DO: */

                    END. /* IF itempai.CodigoProduto <> '' THEN DO: */

                END. /* FOR EACH itempai NO-LOCK: */

            END. /* FOR EACH ped-item OF ped-venda: */

            IF  l-off-grid THEN
                ASSIGN ped-venda.observacoes = ped-venda.observacoes + " - Atená∆o! Esse gerador off grid possui baterias em sua estrutura. Faturamento somente nas quartas-feiras.".

            ASSIGN pedidor.observacao = ped-venda.observacoes.
            
            IF  ped-venda.cod-priori = 99
            AND msg0093.Situacao = 1 THEN
                ASSIGN ped-venda.cod-priori = 44.

            IF ped-venda.cod-priori <> 44 THEN DO:

                FIND FIRST int-emitente NO-LOCK
                     WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

                IF  AVAIL int-emitente 
                AND NOT ped-venda.observacoes MATCHES "*" + int-emitente.observacao-ped + "*"  THEN DO:
                   ASSIGN ped-venda.observacoes = ped-venda.observacoes + " " + int-emitente.observacao-ped.
                END.

/*                 RUN pi-prod-composto. */

                FIND FIRST cabecalho NO-ERROR.
                
                IF  ped-venda.observacoes <> "" AND ped-venda.observacoes <> ?
                AND ped-venda.cod-sit-ped <>  6
                AND msg0093.TipoNaturezaOperacao <> 2 
                AND cabecalho.IdentidadeEmissor <> "8F4E5DB0-466C-4ED5-9B67-257D5620E67E" THEN DO:
                   
                    ASSIGN ped-venda.cod-sit-ped = 5. 
                END.

                IF RETURN-VALUE = "NOK" THEN DO:
                    UNDO blk_principal, LEAVE blk_principal.
                END.

            END. /* IF ped-venda.cod-priori <> 44 THEN DO: */

        END. /* IF AVAIL ped-venda THEN DO: */
    END.
END.

IF VALID-HANDLE (bo-ped-item) THEN DO:
    RUN Destroy in bo-ped-item.
    ASSIGN bo-ped-item = ?.
END.

IF VALID-HANDLE (bo-ped-venda) THEN DO:
    RUN Destroy in bo-ped-venda.
    ASSIGN bo-ped-venda = ?.
END.

IF VALID-HANDLE (h-bodi317im1br) THEN DO:
    RUN Destroy in h-bodi317im1br.
    ASSIGN h-bodi317im1br = ?.
END.

IF VALID-HANDLE (h-bodi159cal) THEN DO:
    RUN Destroy in h-bodi159cal.
    ASSIGN h-bodi159cal = ?.
END.

IF VALID-HANDLE (h-bodi154sdf) THEN DO:
    RUN Destroy in h-bodi154sdf.
    ASSIGN h-bodi154sdf = ?.
END.

IF VALID-HANDLE (h-bodi154) THEN DO:
    RUN Destroy in h-bodi154.
    ASSIGN h-bodi154 = ?.
END.

IF VALID-HANDLE (bo-ped-venda-can) THEN DO:
    RUN Destroy   IN bo-ped-venda-can.
    ASSIGN bo-ped-venda-can = ?.
END.

IF VALID-HANDLE (bo-ped-item-can) THEN DO:
    RUN destroyBO IN bo-ped-item-can.
    RUN Destroy   IN bo-ped-item-can.
    ASSIGN bo-ped-item-can = ?.
END.

EMPTY TEMP-TABLE Resultado.
FIND cabecalho.
CREATE cabecalhor.
CREATE conteudor.
CREATE resultado.

IF NOT CAN-FIND (FIRST msg0093r) THEN DO:
    CREATE msg0093r.
END.

IF NOT CAN-FIND (FIRST Itensr) THEN DO:
    CREATE Itensr.
END.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.           
ASSIGN cabecalhor.CodigoMensagem = 'MSG0093R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

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
ELSE 
    ASSIGN resultado.Mensagem = "Integraá∆o ocorrida com sucesso.".

IF resultado.Mensagem = "" THEN
    ASSIGN resultado.Mensagem = ?.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).
FIND CURRENT ped-venda NO-LOCK NO-ERROR.
RELEASE ped-venda.

define variable hDoc    as handle   no-undo.
create x-document hDoc.
hDoc:LOAD("longchar", oXML, NO).
hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").

/* Desativa Profiler */
/* profiler:write-data().             */
/* assign profiler:enabled = false    */
/*        profiler:Profiling = false. */
/* Fim Desativa Profiler */

FIND FIRST ped-venda NO-LOCK WHERE ped-venda.nr-pedido = int(msg0093.NumeroPedido) NO-ERROR.
IF AVAIL ped-venda THEN DO:

    FOR EACH int-ped-item-canais
       WHERE int-ped-item-canais.nr-pedcli = ped-venda.nr-pedcli NO-LOCK:
        RUN pi-log (INPUT "ITEM int-ped-item-canais FINAL : " + int-ped-item-canais.it-codigo + " " + string(ped-venda.cod-priori)). 
    END.

/*     RUN pi-log (INPUT "Pedido integra MSG0091 : " + ped-venda.nr-pedcli).                                     */
/*     FOR EACH ped-item OF ped-venda.                                                                           */
/*         RUN pi-log (INPUT "ITEM pedidos FINAL : " + ped-item.it-codigo + " " + string(ped-venda.cod-priori)). */
/*     END.                                                                                                      */
    IF ped-venda.cod-priori <> 44 THEN DO:

        RUN esp/es0018p.p (INPUT "msg0091", /* Nome do programa */
                           INPUT 1,         /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        FIND FIRST tt-prog-ponto 
             WHERE tt-prog-ponto.conteudo = "online" NO-ERROR.

        IF AVAIL tt-prog-ponto THEN DO:
            RUN pi-log (INPUT "Teste RUBIA - INTEGRANDO MSG0093 MSG0091 : " + ped-venda.nr-pedcli). 
            RAW-TRANSFER ped-venda TO raw-param.
            RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                    INPUT        raw-param, /* Tupla do registro */
                                    OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.        
        END.
    END.
    RETURN.

END.


PROCEDURE pi-altera-item:
    EMPTY TEMP-TABLE tt-ped-item.

    CREATE tt-ped-item.
    BUFFER-COPY ped-item TO tt-ped-item.

    IF ped-item.cod-sit-item = 6 THEN
        RETURN "OK":U.

    FIND FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = tt-ped-item.it-codigo NO-ERROR.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-ERROR.

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

    ASSIGN tt-ped-item.qt-pedida = item-pedido.QuantidadePedida
           tt-ped-item.qt-un-fat = item-pedido.QuantidadePedida
           tt-ped-item.r-rowid   = ROWID(ped-item).

    IF msg0093.TabelaPrecoEMS = ""
    OR msg0093.TabelaPrecoEMS = ? THEN DO:
        ASSIGN tt-ped-item.vl-pretab = item-pedido.PrecoOriginal
               tt-ped-item.vl-preori = item-pedido.PrecoOriginal.
    END.
    ELSE DO:
        FIND FIRST preco-item NO-LOCK
             WHERE preco-item.it-codigo  = tt-ped-item.it-codigo 
               AND preco-item.cod-refer  = ""
               AND preco-item.nr-tabpre  = msg0093.TabelaPrecoEMS
               AND preco-item.dt-inival <= TODAY
               AND preco-item.situacao   = 1 NO-ERROR.
       
       IF NOT AVAIL preco-item THEN DO:
           RUN pi-erro (INPUT "O item " + tt-ped-item.it-codigo + " n∆o possui preáo ativo cadastrado na tabela " + msg0093.TabelaPrecoEMS + " - " + " Cod Cliente: " + string(emitente.cod-emitente)).
           RETURN "NOK".
       END.
       
       FIND FIRST unid-feder NO-LOCK
            WHERE unid-feder.pais   = estabelec.pais
              AND unid-feder.estado = estabelec.estado NO-ERROR.
       
       ASSIGN de-icms = 1
              l-ok    = NO.

       ASSIGN tt-ped-item.vl-pretab = round((preco-item.preco-venda / (100 - de-perc-icms) * 100),4) .
              tt-ped-item.vl-preori = tt-ped-item.vl-pretab .


       
       /*** DEFINICAO DO VALOR UNITARIO COM DESCONTO ZFM ** */
       IF natur-oper.per-des-icm > 0 
          THEN ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori - (tt-ped-item.vl-preori * (natur-oper.per-des-icm / 100)).
          ELSE ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori.
    END.
    

    /* C†lculo da Substituiá∆o Tribut†ria */
    FIND FIRST natur-oper NO-LOCK
        WHERE  natur-oper.nat-operacao = tt-ped-item.nat-operacao NO-ERROR.

    ASSIGN de-valor-st = 0.
    IF  AVAIL natur-oper 
    AND natur-oper.subs-trib THEN DO:
        ASSIGN de-valor-st = ROUND(tt-ped-item.vl-tot-it - tt-ped-item.vl-liq-it - (tt-ped-item.qt-pedida * tt-ped-item.vl-preuni) * (tt-ped-item.aliquota-ipi / 100),2).
    END.

    RUN dibo/bodi154.p PERSISTENT SET bo-ped-item.
    RUN emptyRowErrors  IN bo-ped-item.
    RUN openQueryStatic IN bo-ped-item (INPUT "Main"). 
    RUN goToKey         IN bo-ped-item (INPUT tt-ped-item.nome-abrev,
                                        INPUT tt-ped-item.nr-pedcli,
                                        INPUT tt-ped-item.nr-sequencia,
                                        INPUT tt-ped-item.it-codigo,
                                        INPUT tt-ped-item.cod-refer).
        
    RUN setRecord    IN bo-ped-item (INPUT TABLE tt-ped-item).
    RUN updateRecord IN bo-ped-item.
    RUN getRowErrors IN bo-ped-item (OUTPUT TABLE RowErrors).

    
    FOR EACH rowErrors NO-LOCK:
        
        IF rowErrors.errornumber  = 26468 THEN DO:  
            FIND ITEM 
                 WHERE ITEM.it-codigo = substring(rowErrors.errorDescription,6,7)
                 NO-LOCK NO-ERROR.
    
            ASSIGN rowErrors.errorDescription = "O produto " + 
                                                (IF AVAIL ITEM THEN ITEM.it-codigo + " " + ITEM.desc-item ELSE "") + 
                                                " est† temporariamente bloqueado para faturamento. Favor remover o item do pedido e entrar em contato com a †rea comercial".
        END.
    END.


    FOR EACH rowErrors
        WHERE RowErrors.ErrorType <> "INTERNAL"
          AND RowErrors.ErrorSubType = "Error":U:
        RUN pi-erro (INPUT RowErrors.errorDescription).
    END.

    RUN getRecord    IN bo-ped-item (OUTPUT TABLE tt-ped-item).
    FIND FIRST tt-ped-item.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = tt-ped-item.it-codigo NO-ERROR.
           
    FIND FIRST int-ped-item-rebate EXCLUSIVE-LOCK
         WHERE int-ped-item-rebate.nome-abrev   = tt-ped-item.nome-abrev
           AND int-ped-item-rebate.nr-pedcli    = tt-ped-item.nr-pedcli
           AND int-ped-item-rebate.nr-sequencia = tt-ped-item.nr-sequencia
           AND int-ped-item-rebate.it-codigo    = tt-ped-item.it-codigo
           AND int-ped-item-rebate.cod-refer    = tt-ped-item.cod-refer NO-ERROR.
    IF NOT AVAIL int-ped-item-rebate THEN DO:
        RUN pi-log (INPUT "**** Se nao encontrar, cria Rebate ****").
    
            CREATE int-ped-item-rebate.
            ASSIGN int-ped-item-rebate.nome-abrev             = tt-ped-item.nome-abrev  
                   int-ped-item-rebate.nr-pedcli              = tt-ped-item.nr-pedcli   
                   int-ped-item-rebate.nr-sequencia           = tt-ped-item.nr-sequencia
                   int-ped-item-rebate.it-codigo              = tt-ped-item.it-codigo   
                   int-ped-item-rebate.cod-refer              = tt-ped-item.cod-refer 
                   int-ped-item-rebate.log-calcrebate         = item-pedido.CalcularRebate
                   int-ped-item-rebate.perc-descto-verde      = item-pedido.PercentualDescontoVerde    
                   int-ped-item-rebate.perc-descto-top-milhao = item-pedido.PercentualDescontoTopMilhao
                   int-ped-item-rebate.perc-rebate-antec      = item-pedido.PercentualRebateAntecipado.
    END. /* IF NOT AVAIL tt-int-ped-item-rebate THEN DO: */
    ELSE DO:
        RUN pi-log (INPUT "**** Atualiza Log Rebate ****" + string(int-ped-item-rebate.log-calcrebate)).
        ASSIGN int-ped-item-rebate.log-calcrebate         = item-pedido.CalcularRebate               
               int-ped-item-rebate.perc-descto-verde      = item-pedido.PercentualDescontoVerde      
               int-ped-item-rebate.perc-descto-top-milhao = item-pedido.PercentualDescontoTopMilhao  
               int-ped-item-rebate.perc-rebate-antec      = item-pedido.PercentualRebateAntecipado.  
    END.

    FIND CURRENT int-ped-item-rebate NO-LOCK NO-ERROR.
    RELEASE int-ped-item-rebate.

    RUN Destroy in bo-ped-item.
    ASSIGN bo-ped-item = ?.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    IF NOT ped-venda.completo THEN DO:

       IF l-abriu-ped THEN DO:
            FIND CURRENT ped-venda EXCLUSIVE-LOCK.
            IF ped-venda.cod-sit-ped <>  6 THEN ASSIGN ped-venda.cod-sit-ped = 5.

            FIND CURRENT ped-venda NO-LOCK.

            FOR EACH tt-item-aberto:
                FIND FIRST ped-item OF ped-venda EXCLUSIVE-LOCK
                     WHERE ped-item.it-codigo    = tt-item-aberto.it-codigo
                       AND ped-item.nr-sequencia = tt-item-aberto.nr-sequencia
                       AND ped-item.cod-sit-item = 1 NO-ERROR.

                IF AVAIL ped-item THEN DO:
                    FOR EACH ped-ent OF ped-item
                        WHERE ped-ent.cod-sit-ent = 1 exclusive-lock:
        
                        ASSIGN ped-ent.cod-sit-ent  = 5.
        
                    END.
                    ASSIGN ped-item.cod-sit-item = 5.    
                END.
            END.
        END.

        IF NOT VALID-HANDLE(h-bodi159cal) THEN
            RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.

        RUN completeOrder IN h-bodi159cal (INPUT  ROWID(ped-venda),
                                           OUTPUT TABLE rowErrors).

       IF l-abriu-ped THEN DO:
            FIND CURRENT ped-venda EXCLUSIVE-LOCK.
            ASSIGN ped-venda.cod-sit-ped = 1.
            FIND CURRENT ped-venda NO-LOCK.

           FOR EACH tt-item-aberto:
               FIND FIRST ped-item OF ped-venda EXCLUSIVE-LOCK
                    WHERE ped-item.it-codigo    = tt-item-aberto.it-codigo
                      AND ped-item.nr-sequencia = tt-item-aberto.nr-sequencia
                      AND ped-item.cod-sit-item = 5 NO-ERROR.
    
               IF AVAIL ped-item THEN DO:
                   FOR EACH ped-ent OF ped-item
                       WHERE ped-ent.cod-sit-ent = 5 exclusive-lock:
        
                       ASSIGN ped-ent.cod-sit-ent  = 1.
        
                   END.
                   ASSIGN ped-item.cod-sit-item = 1.    
               END.
           END.
       END.

    END.

    /*Calcula ICMS para retornar na mensagem*/
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

    FIND FIRST loc-entr NO-LOCK USE-INDEX ch-entrega
         WHERE loc-entr.cod-entrega = "padrao"
           AND loc-entr.nome-abrev  = emitente.nome-abrev NO-ERROR.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-ERROR.

    ASSIGN g-cod-emitente-bodi317im1br = emitente.cod-emitente.
    ASSIGN g-codigo-orig-bodi317sd     = ITEM.codigo-orig.
    RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.
    ASSIGN de-perc-icms = 0.
    IF emitente.contrib-icm = YES THEN DO:
        FOR FIRST inf-compl  /* conteudo do cd0908 */
            WHERE inf-compl.cdn-identif = 5
            AND inf-compl.cod-indice = item.it-codigo + CHR(2) + estabelec.estado + CHR(2) + loc-entr.estado NO-LOCK:
            ASSIGN de-perc-icms = inf-compl.val-campo.
        END.
    END.
    IF de-perc-icms = 0 THEN DO:
        RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  emitente.contrib-icms,
                                                  INPUT  emitente.natureza,
                                                  INPUT  estabelec.estado,
                                                  INPUT  estabelec.pais,
                                                  INPUT  loc-entr.estado,
                                                  INPUT  item.it-codigo,
                                                  INPUT  natur-oper.nat-operacao,
                                                  OUTPUT de-perc-icms, 
                                                  OUTPUT l-return).
    END.

    RUN Destroy in h-bodi317im1br.
    ASSIGN h-bodi317im1br               = ?
           g-cod-emitente-bodi317im1br  = 0
           g-codigo-orig-bodi317sd      = 0.
    /****************/
    
    FIND FIRST ped-item OF tt-ped-item.

    CREATE item-pedidor.
    ASSIGN item-pedidor.ChaveIntegracao             = string(ped-venda.cod-emitente) + "," + string(ped-venda.nr-pedcli) + "," + string(ped-item.nr-sequencia) + "," + ped-item.it-codigo + "," + item.cod-refer
           item-pedidor.Produto                     = ped-item.it-codigo
           item-pedidor.Sequencia                   = ped-item.nr-sequencia
           item-pedidor.QuantidadePedida            = ped-item.qt-pedida
           item-pedidor.PrecoOriginal               = round(ped-item.vl-pretab,4)
           item-pedidor.ValorLiquido                = round(ped-item.vl-liq-it,4)
           item-pedidor.ValorLiquidoAberto          = round(ped-item.vl-liq-abe,4)
           item-pedidor.ValorSubstituicaoTributaria = round(de-valor-st,4)
           item-pedidor.ValorIPI                    = round(ped-item.val-ipi,4)
           item-pedidor.AliquotaIPI                 = round(ped-item.aliquota-ipi,2)
           item-pedidor.AliquotaICMS                = round(de-perc-icms,2)
           item-pedidor.ValorICMS                   = round(ped-item.vl-liq-it * de-perc-icms / 100,2)
           item-pedidor.ValorTotal                  = round(ped-item.vl-tot-it,4).

    FIND FIRST int-ped-item-rebate
        WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev  
          AND int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli   
          AND int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
          AND int-ped-item-rebate.it-codigo    = ped-item.it-codigo   
          AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer   NO-LOCK NO-ERROR.
    IF AVAIL int-ped-item-rebate THEN DO:
        ASSIGN item-pedidor.CalcularRebate          = int-ped-item-rebate.log-calcrebate
               item-pedidor.PercentualDescontoVerde       = int-ped-item-rebate.perc-descto-verde
               //item-pedidor.PercentualDescontoTopMilhao   = int-ped-item-rebate.perc-descto-top-milhao
               //item-pedidor.PercentualRebateAntecipado = int-ped-item-rebate.perc-rebate-antec
               .
    END.

    RETURN "OK".    
END PROCEDURE.

PROCEDURE pi-exclui-item:
    

    IF OPSYS = "UNIX" THEN log-manager:write-message("pi-exclui-item - ped-item.it-codigo " + ped-item.it-codigo + " " +  STRING(ped-venda.cod-sit-ped)).

    RUN dibo/bodi154.p PERSISTENT SET bo-ped-item.
    RUN openQueryStatic IN bo-ped-item (INPUT "Main"). 
    RUN goToKey IN bo-ped-item (INPUT ped-item.nome-abrev,
                                      ped-item.nr-pedcli,
                                      ped-item.nr-sequenc,
                                      ped-item.it-codigo,
                                      ped-item.cod-refer).

    RUN emptyRowErrors IN bo-ped-item.
    RUN deleteRecord   IN bo-ped-item.
    RUN getRowErrors   IN bo-ped-item(OUTPUT TABLE RowErrors).

    RUN Destroy in bo-ped-item.
    ASSIGN bo-ped-item = ?.

    FOR EACH rowErrors
        WHERE RowErrors.ErrorType <> "INTERNAL"
          AND RowErrors.ErrorSubType = "Error":U:
        IF OPSYS = "UNIX" THEN log-manager:write-message("RowErrors.errorDescription " + RowErrors.errorDescription).
        RUN pi-erro (INPUT RowErrors.errorDescription).
    END.

    IF CAN-FIND (FIRST tt-erro) THEN DO:
        IF OPSYS = "UNIX" THEN log-manager:write-message("ERRO pi-exclui-item").
        RETURN "NOK".
    END.
    ELSE DO:
        IF OPSYS = "UNIX" THEN log-manager:write-message("OK pi-exclui-item").
        RETURN "OK".
    END.

END PROCEDURE.

PROCEDURE pi-altera-pedido:
    EMPTY TEMP-TABLE tt-ped-venda.

    FIND FIRST repres NO-LOCK
         WHERE repres.cod-rep = msg0093.Representante NO-ERROR.

    IF  NOT AVAIL repres THEN DO:
        RUN pi-erro (INPUT "Representante " + STRING(msg0093.Representante) + " n∆o cadastrado.").
    END.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-guid = msg0093.CodigoClienteCRM NO-ERROR.

    
    IF  NOT AVAIL int-emitente THEN DO:
        RUN pi-erro (INPUT "Cliente n∆o encontrado no CRM").
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = int-emitente.cod-emitente NO-ERROR.

    IF  NOT AVAIL emitente THEN DO:
        RUN pi-erro (INPUT "Cliente " + STRING(msg0093.CodigoClienteCRM) + " n∆o cadastrado.").
    END.

    FIND FIRST cond-pagto NO-LOCK
        WHERE  cond-pagto.cod-cond-pag = msg0093.CondicaoPagamento NO-ERROR.

    IF  NOT AVAIL cond-pagto
    AND msg0093.TipoNaturezaOperacao <> 2 THEN DO:
        RUN pi-erro (INPUT "Condiá∆o de Pagamento " + STRING(msg0093.CondicaoPagamento) + " n∆o cadastrada.").
    END.

    IF  msg0093.Situacao = 1 AND ped-venda.cod-priori <> 44  THEN 
        RUN pi-erro (INPUT "Pedido j† efetivado no ERP, mensagem enviada da extranet com status invalida.").

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    CREATE tt-ped-venda.
    BUFFER-COPY ped-venda TO tt-ped-venda.

    RUN dibo/bodi159.p PERSISTENT SET bo-ped-venda.
    
    RUN RetiraAcentos (INPUT-OUTPUT msg0093.CondicaoEspecial).

    ASSIGN tt-ped-venda.no-ab-reppri = repres.nome-abrev
           tt-ped-venda.tp-pedido    = STRING(msg0093.Atendente)
           tt-ped-venda.cod-cond-pag = msg0093.CondicaoPagamento 
           tt-ped-venda.cond-espec   = IF msg0093.NumeroPedidoCliente <> "" AND msg0093.NumeroPedidoCliente <> "0" AND NOT(msg0093.CondicaoEspecial BEGINS "OC:") THEN "OC: " + msg0093.NumeroPedidoCliente + " " + msg0093.CondicaoEspecial ELSE msg0093.CondicaoEspecial.

    RUN RetiraAcentos (INPUT-OUTPUT msg0093.Observacao).

    IF  tt-ped-venda.observacoes = ? THEN tt-ped-venda.observacoes = "".

    ASSIGN tt-ped-venda.observacoes  = msg0093.Observacao 
           tt-ped-venda.ind-fat-par  = msg0093.FaturamentoParcial
           /*tt-ped-venda. = msg0093.Vendor ?? 
           tt-ped-venda. = msg0093.DiasBaseVendor 
           tt-ped-venda. = msg0093.TaxaClienteVendor */
           tt-ped-venda.dt-emissao   = msg0093.DataEmissao 
           tt-ped-venda.r-rowid      = ROWID(ped-venda)
           tt-ped-venda.cod-priori   = IF msg0093.Situacao = 1 THEN 44 ELSE 01.  

    IF  TODAY <= msg0093.DataEntrega THEN
        ASSIGN tt-ped-venda.dt-entrega = msg0093.DataEntrega 
               tt-ped-venda.dt-entorig = msg0093.DataEntrega.
    ELSE
        ASSIGN tt-ped-venda.dt-entrega = TODAY
               tt-ped-venda.dt-entorig = TODAY.



    RUN openQueryStatic IN bo-ped-venda (INPUT "Main"). 
    RUN goToKey         IN bo-ped-venda (INPUT ped-venda.nome-abrev,
                                               ped-venda.nr-pedcli).
    RUN emptyRowErrors IN bo-ped-venda.
    RUN setRecord      IN bo-ped-venda (INPUT TABLE tt-ped-venda).
    RUN updateRecord   IN bo-ped-venda.
    RUN getRowErrors   IN bo-ped-venda (OUTPUT TABLE RowErrors).

    RUN Destroy in bo-ped-venda.
    ASSIGN bo-ped-venda = ?.

    FOR EACH rowErrors
        WHERE RowErrors.ErrorType <> "INTERNAL"
          AND RowErrors.ErrorSubType = "Error":U:
        RUN pi-erro (INPUT RowErrors.errorDescription).
    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    FIND CURRENT int-ped-venda EXCLUSIVE-LOCK.
    ASSIGN /*int-ped-venda.dt-negociacao           = msg0093.DataNegociacao 
           int-ped-venda.dias-negociacao         = msg0093.DiasNegociacao*/
           OVERLAY(int-ped-venda.char-1,53,12)   = msg0093.NumeroPedidoCliente
           OVERLAY(int-ped-venda.char-1,68,8)    = msg0093.CodigoSupervisorEMS
           OVERLAY(int-ped-venda.char-1,100,100) = msg0093.NomeUsuarioCriacao 
           OVERLAY(int-ped-venda.char-1,201,10)  = string(msg0093.TipoUsuarioCriacao)
           int-ped-venda.carTID                  = msg0093.IdentificacaoCartao.


    /* Chamado 63819, alterar prioridade do pedido para 3 quando todos os itens tem desconto verde */
    ASSIGN l-altera-priori-ped = YES.

    bloco-descto-verde:
    FOR EACH int-ped-item-rebate NO-LOCK
       WHERE int-ped-item-rebate.nome-abrev = ped-venda.nome-abrev
         AND int-ped-item-rebate.nr-pedcli  = ped-venda.nr-pedcli:

       IF  l-altera-priori-ped                   = YES AND
           int-ped-item-rebate.perc-descto-verde = 0
       THEN DO:
           ASSIGN l-altera-priori-ped = NO.
           LEAVE bloco-descto-verde.
       END.
    END.

    IF  l-altera-priori-ped = YES
    AND msg0093.Situacao = 2 THEN DO:
        FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.

        IF msg0093.PedidoProgramado THEN
            ASSIGN ped-venda.cod-priori = 4.
        ELSE
            ASSIGN ped-venda.cod-priori = 3.
			
	FIND FIRST int-ped-venda EXCLUSIVE-LOCK
             WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
	IF AVAIL int-ped-venda AND int-ped-venda.cod-priori-orig = 44 THEN
		ASSIGN int-ped-venda.cod-priori-orig = ped-venda.cod-priori.
	FIND CURRENT int-ped-venda NO-LOCK NO-ERROR.	

    END.
	
    FIND CURRENT ped-venda NO-LOCK NO-ERROR.

    FIND CURRENT int-ped-venda NO-LOCK.

    CREATE pedidor.
    ASSIGN pedidor.NumeroPedido       = ped-venda.nr-pedcli
           pedidor.Representante      = msg0093.Representante
           pedidor.CodigoClienteCRM   = int-emitente.cod-guid
           pedidor.Atendente          = INT(ped-venda.tp-pedido)
           pedidor.CodigoSupervisorEMS = msg0093.CodigoSupervisorEMS
           pedidor.Estabelecimento    = ped-venda.cod-estabel
           pedidor.CondicaoPagamento  = ped-venda.cod-cond-pag
           pedidor.CondicaoEspecial   = ped-venda.cond-espec
           pedidor.Observacao         = ped-venda.observacoes
           pedidor.FaturamentoParcial = ped-venda.ind-fat-par
           pedidor.Vendor             = msg0093.Vendor
           pedidor.DiasBaseVendor     = msg0093.DiasBase
           pedidor.TaxaClienteVendor  = msg0093.TaxaCliente
           pedidor.DataEmissao        = ped-venda.dt-emissao
           pedidor.DataEntrega        = ped-venda.dt-entrega
           pedidor.DataNegociacao     = ? /*Caso o canal passar a informar data negociaá∆o tratar essa informaá∆o*/
           pedidor.DiasNegociacao     = ?
           pedidor.TipoObjetoCliente  = msg0093.TipoObjetoCliente
           pedidor.Situacao           = msg0093.Situacao
           .

    RETURN "OK":U.   
END PROCEDURE.

PROCEDURE CriaItem:
    DEFINE INPUT PARAM p-it-codigo         AS CHAR.
    DEFINE INPUT PARAM p-quantidade-pedida AS DEC.
    DEFINE INPUT PARAM p-preco-original    AS DEC.
    DEFINE INPUT PARAM p-cria-retorno      AS LOG.
    DEFINE INPUT PARAM p-muda-natureza     AS LOG.

    DEFINE VARIABLE i-cod-gr-canais        AS INT NO-UNDO.
    
    EMPTY TEMP-TABLE tt-ped-venda.
    EMPTY TEMP-TABLE tt-ped-item.
    CREATE tt-ped-venda.
    BUFFER-COPY ped-venda TO tt-ped-venda.

    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-ERROR.

    FIND FIRST item NO-LOCK
         WHERE item.it-codigo = p-it-codigo NO-ERROR.

    IF  NOT AVAIL ITEM THEN DO:
        RUN pi-erro (INPUT "Item n∆o encontrado - " + p-it-codigo).
    END.

    FIND FIRST emitente NO-LOCK
        WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

    FIND FIRST loc-entr NO-LOCK USE-INDEX ch-entrega
         WHERE loc-entr.cod-entrega = "padrao"
           AND loc-entr.nome-abrev  = emitente.nome-abrev NO-ERROR.

    IF  NOT AVAIL loc-entr THEN DO:
        RUN pi-erro (INPUT "Local de entrega do cliente " + STRING(emitente.cod-emitente) + " n∆o cadastrado.").
    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".


    IF msg0093.TipoNaturezaOperacao = 2 THEN DO:
        FOR FIRST ponto-programa
            WHERE ponto-programa.nome-programa = "escrm034",
            FIRST conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
              AND conteudo-programa.sequencia    = int(ped-venda.cod-estabel):
           
            ASSIGN c-nat-oper-dentro-estado-contrib     = ENTRY(1,conteudo-programa.conteudo)
                   c-nat-oper-dentro-estado-nao-contrib = ENTRY(2,conteudo-programa.conteudo)
                   c-nat-oper-fora-estado-contrib       = ENTRY(3,conteudo-programa.conteudo)
                   c-nat-oper-fora-estado-nao-contrib   = ENTRY(4,conteudo-programa.conteudo).

            FIND FIRST natur-oper NO-LOCK 
                 WHERE natur-oper.nat-operacao = IF emitente.estado =  estabelec.estado AND emitente.contrib-icms = YES THEN c-nat-oper-dentro-estado-contrib
                                            ELSE IF emitente.estado =  estabelec.estado AND emitente.contrib-icms = NO  THEN c-nat-oper-dentro-estado-nao-contrib
                                            ELSE IF emitente.estado <> estabelec.estado AND emitente.contrib-icms = YES THEN c-nat-oper-fora-estado-contrib         
                                            ELSE IF emitente.estado <> estabelec.estado AND emitente.contrib-icms = NO  THEN c-nat-oper-fora-estado-nao-contrib
                                            ELSE "" NO-ERROR.

            IF NOT AVAIL natur-oper THEN
                RUN pi-erro (INPUT "Natureza de operaá∆o parametrizada n∆o cadastrada. - " + " Cod Cliente: " + string(emitente.cod-emitente)).
            ELSE 
                ASSIGN c-nat-oper = natur-oper.nat-operacao.
        END.
    END.
    ELSE DO:
        IF emitente.contrib-icms = YES THEN 
            ASSIGN l-consumidor-final = NO.
        ELSE 
            ASSIGN l-consumidor-final = YES.
    
        IF NOT VALID-HANDLE(h-boes505) THEN
            RUN esbo/boes505.p PERSISTENT SET h-boes505.
    
        RUN defineNatOperacao IN h-boes505 (INPUT  estabelec.cod-estabel,
                                            INPUT  emitente.cod-emitente,
                                            INPUT  "padrao", 
                                            INPUT  item.it-codigo,
                                            INPUT  l-consumidor-final,
                                            OUTPUT c-nat-oper,
                                            OUTPUT l-return).
        RUN Destroy in h-boes505.
        ASSIGN h-boes505 = ?.
    END.
    
    IF  l-return = NO THEN DO:
        RUN pi-erro (INPUT "Natureza de Operaá∆o n∆o encontrada para o cliente/estabelecimento " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel + " Item " + item.it-codigo).
    END.

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = c-nat-oper NO-ERROR.

    IF  NOT AVAIL natur-oper THEN DO:
        RUN pi-erro (INPUT "Natureza de operaá∆o " + c-nat-oper + " inv†lido ou n∆o cadastrada, Cliente: " + STRING(emitente.cod-emitente) + " Estabelec " + estabelec.cod-estabel + " Item " + item.it-codigo).
    END.

    IF p-quantidade-pedida = 0 THEN DO:
        RUN pi-erro (INPUT "Item com quantidade zerada  " + item.it-codigo + " Cliente " + STRING(emitente.cod-emitente)).
    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    
    FIND LAST ped-item NO-LOCK 
        WHERE ped-item.nome-abrev  = tt-ped-venda.nome-abrev
          AND ped-item.nr-pedcli   = tt-ped-venda.nr-pedcli NO-ERROR.

    IF AVAIL ped-item THEN 
        ASSIGN i-sequencia = ped-item.nr-sequencia.
    ELSE
        ASSIGN i-sequencia = 0.
        
    RUN pi-log("CriaItem - criando tt-ped-item ITEM item.it-codigo " + item.it-codigo ).

    CREATE tt-ped-item.
    ASSIGN tt-ped-item.nr-pedcli           = tt-ped-venda.nr-pedcli
           tt-ped-item.nome-abrev          = tt-ped-venda.nome-abrev
           tt-ped-item.it-codigo           = item.it-codigo
           tt-ped-item.aliquota-ipi        = item.aliquota-ipi
           tt-ped-item.des-un-medida       = ITEM.un
           tt-ped-item.cod-entrega         = tt-ped-venda.cod-entrega
           OVERLAY(tt-ped-item.char-2,1,8) = item.class-fiscal.

    ASSIGN i-sequencia              = i-sequencia + 10
           tt-ped-item.nr-sequencia = i-sequencia.

    /* Verifica data de entrega do item */
    
    FIND FIRST int-ped-venda2 NO-LOCK
         WHERE int-ped-venda2.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.

    FIND LAST item-dt-entrega NO-LOCK
        WHERE item-dt-entrega.it-codigo = tt-ped-item.it-codigo 
          AND item-dt-entrega.cod-gr-canais = IF AVAIL int-ped-venda2 THEN int-ped-venda2.int-1 ELSE 0 NO-ERROR.

    IF NOT AVAIL item-dt-entrega THEN DO:

        ASSIGN i-cod-gr-canais = 0.

        FIND FIRST atendente
             WHERE atendente.cd-oper = int(tt-ped-venda.tp-pedido) NO-LOCK NO-ERROR.
        IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO:
            ASSIGN i-cod-gr-canais = atendente.cod-gr-canais.
        END. /* IF AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */
        ELSE DO:
            FIND FIRST emitente
                 WHERE emitente.cod-emitente = tt-ped-venda.cod-emitente NO-LOCK NO-ERROR.
            IF  AVAIL emitente THEN DO:
                FIND FIRST grupo-canais-clientes
                     WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
                IF AVAIL grupo-canais-clientes THEN DO:
                    ASSIGN i-cod-gr-canais = grupo-canais-clientes.cod-gr-canais.
                END.
            END.
        END. /* IF NOT AVAIL atendente AND atendente.cod-gr-canais <> 0 THEN DO: */

        FIND LAST item-dt-entrega NO-LOCK
            WHERE item-dt-entrega.it-codigo = tt-ped-item.it-codigo 
              AND item-dt-entrega.cod-gr-canais = i-cod-gr-canais NO-ERROR.
    END.
    
    IF AVAIL item-dt-entrega
         AND item-dt-entrega.dt-entrega-futura > TODAY 
         AND tt-ped-venda.dt-entrega           < item-dt-entrega.dt-entrega-futura THEN DO:
        ASSIGN tt-ped-item.dt-entrega = item-dt-entrega.dt-entrega-futura
               tt-ped-item.dt-entorig = item-dt-entrega.dt-entrega-futura.
    END.
    ELSE
        ASSIGN tt-ped-item.dt-entrega = tt-ped-venda.dt-entrega.

    IF tt-ped-item.dt-entrega > TODAY + 730 THEN DO:
        RUN pi-erro (INPUT "Data de entrega do item " + tt-ped-item.it-codigo +  " superior a 2 anos!").
    END.

    /* Fim Verifica data de entrega do item */

    ASSIGN g-cod-emitente-bodi317im1br = emitente.cod-emitente.
    ASSIGN g-codigo-orig-bodi317sd     = ITEM.codigo-orig.
    RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.
    ASSIGN de-perc-icms = 0.
    IF emitente.contrib-icm = YES THEN DO:
        FOR FIRST inf-compl  /* conteudo do cd0908 */
            WHERE inf-compl.cdn-identif = 5
            AND inf-compl.cod-indice = item.it-codigo + CHR(2) + estabelec.estado + CHR(2) + loc-entr.estado NO-LOCK:
            ASSIGN de-perc-icms = inf-compl.val-campo.
        END.
    END.
    IF de-perc-icms = 0 THEN DO:
        RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  emitente.contrib-icms,
                                                  INPUT  emitente.natureza,
                                                  INPUT  estabelec.estado,
                                                  INPUT  estabelec.pais,
                                                  INPUT  loc-entr.estado,
                                                  INPUT  item.it-codigo,
                                                  INPUT  c-nat-oper,
                                                  OUTPUT de-perc-icms, 
                                                  OUTPUT l-return).
    END.

    RUN Destroy in h-bodi317im1br.
    ASSIGN h-bodi317im1br              = ?
           g-cod-emitente-bodi317im1br = 0
           g-codigo-orig-bodi317sd     = 0.
   
    ASSIGN tt-ped-item.qt-pedida               = p-quantidade-pedida
           tt-ped-item.qt-un-fat               = p-quantidade-pedida
           tt-ped-item.cod-sit-item            = tt-ped-venda.cod-sit-ped
           tt-ped-item.cod-sit-pre             = tt-ped-venda.cod-sit-pre
           tt-ped-item.dt-entorig              = tt-ped-venda.dt-entorig
           tt-ped-item.dt-userimp              = tt-ped-venda.dt-userimp
           tt-ped-item.esp-ped                 = 1
           tt-ped-item.nat-operacao            = natur-oper.nat-operacao
           tt-ped-item.per-des-icms            = natur-oper.per-des-icms
           tt-ped-item.tp-adm-lote             = 1
           tt-ped-item.tp-preco                = 0
           tt-ped-item.user-impl               = tt-ped-venda.user-impl
           tt-ped-item.log-usa-tabela-desconto = NO
           tt-ped-item.observacao              = tt-ped-venda.observacoes
           tt-ped-item.per-minfat              = IF AVAIL emitente THEN emitente.per-minfat ELSE tt-ped-item.per-minfat
           tt-ped-item.cd-origem               = 2
           tt-ped-item.tipo-atend              = IF item.baixa-estoq = NO OR tt-ped-venda.ind-fat-par THEN 2 ELSE 1.

    CREATE tt-int-ped-item.
    ASSIGN tt-int-ped-item.nome-abrev    = tt-ped-item.nome-abrev
           tt-int-ped-item.nr-pedcli     = tt-ped-item.nr-pedcli
           tt-int-ped-item.nr-sequencia  = tt-ped-item.nr-sequencia
           tt-int-ped-item.it-codigo     = tt-ped-item.it-codigo
           tt-int-ped-item.vl-guid       = "" /*tt-ped-item-xml.guid-crm*/
           /***
           tt-int-ped-item.it-codigo-pai = IF AVAIL item-pedido THEN item-pedido.ProdutoPai ELSE ""
           ***/.

    RUN pi-log (INPUT "**** Criaá∆o da Tabela de Rebate ****").
    CREATE tt-int-ped-item-rebate.
    ASSIGN tt-int-ped-item-rebate.nome-abrev        = tt-ped-item.nome-abrev
           tt-int-ped-item-rebate.nr-pedcli         = tt-ped-item.nr-pedcli
           tt-int-ped-item-rebate.nr-sequencia      = tt-ped-item.nr-sequencia
           tt-int-ped-item-rebate.it-codigo         = tt-ped-item.it-codigo
           tt-int-ped-item-rebate.cod-refer         = tt-ped-item.cod-refer
           tt-int-ped-item-rebate.log-calcrebate    = item-pedido.CalcularRebate
           tt-int-ped-item-rebate.perc-descto-verde      = item-pedido.PercentualDescontoVerde            
           tt-int-ped-item-rebate.perc-descto-top-milhao = item-pedido.PercentualDescontoTopMilhao        
           tt-int-ped-item-rebate.perc-rebate-antec      = item-pedido.PercentualRebateAntecipado.

    RUN pi-log (INPUT "**** Criaá∆o da Tabela de Extens∆o para o Item ****" + CHR(10) +
                      "tt-int-ped-item.nome-abrev.: "   + string(tt-int-ped-item.nome-abrev )  + CHR(10) +
                      "tt-int-ped-item.nr-pedcli.: "    + string(tt-int-ped-item.nr-pedcli  )  + CHR(10) +
                      "tt-int-ped-item.nr-sequencia.: " + string(tt-int-ped-item.nr-sequencia) + CHR(10) +
                      "tt-int-ped-item.it-codigo.: "    + string(tt-int-ped-item.it-codigo  )  + CHR(10) +
                      "tt-int-ped-item.vl-guid.: "      + string(tt-int-ped-item.vl-guid    )  + CHR(10) +
                      "QUANDIDADE DO ITEM DO PEDIDO "   + string(item-pedido.QuantidadePedida)).
    
    IF NOT VALID-HANDLE(h-bodi154sdf) 
    OR h-bodi154sdf:TYPE      <> "PROCEDURE":U 
    OR h-bodi154sdf:FILE-NAME <> "dibo/bodi154sdf.p":U THEN
        RUN dibo/bodi154sdf.p PERSISTENT SET h-bodi154sdf.

    IF  AVAIL emitente 
    AND AVAIL natur-oper THEN DO:    
        RUN setICMRetido IN h-bodi154sdf (INPUT  tt-ped-item.nome-abrev,
                                          INPUT  tt-ped-item.cod-entrega,
                                          INPUT  tt-ped-item.it-codigo,
                                          INPUT  tt-ped-venda.cod-estabel,
                                          INPUT  emitente.insc-subs-trib,
                                          INPUT  natur-oper.subs-trib,
                                          OUTPUT tt-ped-item.ind-icm-ret).   
    END.
    RUN Destroy in h-bodi154sdf.
    ASSIGN h-bodi154sdf = ?.
    /* Fim Busca Indicador ICMS Ret */

    IF msg0093.TabelaPrecoEMS = ""
    OR msg0093.TabelaPrecoEMS = ? THEN DO:
        ASSIGN tt-ped-item.vl-pretab = p-preco-original
               tt-ped-item.vl-preori = p-preco-original.
        
        IF de-perc-icms > 0 THEN
            ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori - (tt-ped-item.vl-preori * (de-perc-icms / 100)).
        ELSE 
            ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori.
    END.
    ELSE DO:
        FIND FIRST preco-item NO-LOCK
             WHERE preco-item.it-codigo  = tt-ped-item.it-codigo 
               AND preco-item.cod-refer  = ""
               AND preco-item.nr-tabpre  = msg0093.TabelaPrecoEMS
               AND preco-item.dt-inival <= TODAY
               AND preco-item.situacao   = 1 NO-ERROR.
       
       IF NOT AVAIL preco-item THEN DO:
           RUN pi-erro (INPUT "O item " + tt-ped-item.it-codigo + " n∆o possui preáo ativo cadastrado na tabela " + msg0093.TabelaPrecoEMS + " - " + " Cod Cliente: " + string(emitente.cod-emitente)).
           RETURN "NOK".
       END.
       
       FIND FIRST unid-feder NO-LOCK
            WHERE unid-feder.pais   = estabelec.pais
              AND unid-feder.estado = estabelec.estado NO-ERROR.
       
       ASSIGN de-icms = 1
              l-ok    = NO.


       ASSIGN tt-ped-item.vl-pretab = round((preco-item.preco-venda / (100 - de-perc-icms) * 100),4) .
              tt-ped-item.vl-preori = tt-ped-item.vl-pretab .


       
       /*** DEFINICAO DO VALOR UNITARIO COM DESCONTO ZFM ** */
       IF natur-oper.per-des-icm > 0 
          THEN ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori - (tt-ped-item.vl-preori * (natur-oper.per-des-icm / 100)).
          ELSE ASSIGN tt-ped-item.vl-preuni = tt-ped-item.vl-preori.
    END.
    
    ASSIGN tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni
           tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * tt-ped-item.vl-preuni.

    /* Tratamento IPI */
    IF  item.cd-trib-ipi       = 1  AND   /* Tributado */
       (natur-oper.cd-trib-ipi = 1  OR    /* Tributado */
        natur-oper.cd-trib-ipi = 4) THEN  /* Reduzido  */
        ASSIGN tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it + (tt-ped-item.vl-liq-it * tt-ped-item.aliquota-ipi / 100).
    ELSE
        ASSIGN tt-ped-item.vl-liq-abe = tt-ped-item.vl-liq-it.

    ASSIGN tt-ped-item.vl-tot-it = tt-ped-item.vl-liq-abe.
    
    FIND FIRST item-uni-estab NO-LOCK
         WHERE item-uni-estab.cod-estabel = tt-ped-venda.cod-estabel
           AND item-uni-estab.it-codigo   = tt-ped-item.it-codigo NO-ERROR.

    IF AVAIL item-uni-estab THEN
        ASSIGN tt-ped-item.cod-unid-negoc = item-uni-estab.cod-unid-negoc.
    ELSE
        ASSIGN tt-ped-item.cod-unid-negoc = ITEM.cod-unid-negoc.
        
    /* conta aplicacao */
    IF item.tipo-contr = 4 AND SUBSTR(tt-ped-item.char-2,09,02) = "  " THEN
        ASSIGN SUBSTR(tt-ped-item.char-2,09,02) = item.un.

    IF  item.tipo-contr <> 4 THEN
        ASSIGN SUBSTR(tt-ped-item.char-2,09,02) = "  ":U.

    FOR FIRST natur-oper
        WHERE natur-oper.nat-operacao = tt-ped-item.nat-operacao NO-LOCK USE-INDEX natureza:
    END.

    IF  ((item.tipo-contr = 4 OR (item.aliquota-iss > 0 AND item.tipo-contr <> 2)) AND
         (item.baixa-estoq AND natur-oper.baixa-estoq)) 
       OR
        ((item.tipo-contr = 1 OR item.tipo-contr = 4) AND
         (natur-oper.terceiros OR natur-oper.transf)) 

       OR
         (item.tipo-contr = 2 OR item.tipo-contr = 3) AND
          natur-oper.terceiros AND
         (NOT item.baixa-estoq OR not natur-oper.baixa-estoq) THEN DO:

         IF item.ct-codigo = "":U THEN DO:
            FIND FIRST para-fat NO-LOCK NO-ERROR.
            ASSIGN tt-ped-item.ct-codigo = para-fat.ct-cuscon.
         END.   
         ELSE 
            ASSIGN tt-ped-item.ct-codigo = item.ct-codigo.    
    END. 
    ELSE 
         ASSIGN tt-ped-item.ct-codigo = "".
    /* Fim Conta Aplicacao */

    FIND FIRST classif-fisc NO-LOCK
         WHERE classif-fisc.class-fiscal = item.class-fisc NO-ERROR.
    IF  NOT AVAIL classif-fisc OR item.class-fisc = "" THEN DO:
        RUN pi-erro (INPUT "Item " + tt-ped-item.it-codigo + " sem classificaá∆o fiscal cadastrada.").
    END.

    IF CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    IF  NOT VALID-HANDLE(h-bodi154) THEN
        RUN dibo/bodi154.p PERSISTENT SET h-bodi154.

    RUN pi-log("CriaItem - criando tt-ped-item BOs ITEM item.it-codigo " + tt-ped-item.it-codigo ).

    RUN openQueryStatic IN h-bodi154(INPUT "Default":U).
    RUN emptyRowErrors  IN h-bodi154.
    RUN setRecord       IN h-bodi154(INPUT TABLE tt-ped-item).
    RUN createRecord    IN h-bodi154.
    RUN getRowErrors    IN h-bodi154(OUTPUT TABLE RowErrors).

    RUN pi-log("CriaItem - Depois criando tt-ped-item BOs ITEM item.it-codigo " + tt-ped-item.it-codigo ).

    FOR EACH rowErrors
        WHERE RowErrors.ErrorType <> "INTERNAL"
          AND RowErrors.ErrorSubType = "Error":U:
        RUN pi-log("CriaItem -  ERRO criando tt-ped-item ITEM item.it-codigo " + tt-ped-item.it-codigo ).
        RUN pi-erro (INPUT RowErrors.errorDescription).
    END.

    RUN pi-log("CriaItem - GetRecord criando tt-ped-item BOs ITEM item.it-codigo " + tt-ped-item.it-codigo ).
    RUN getRecord       IN h-bodi154(OUTPUT TABLE tt-ped-item).

    FIND FIRST tt-ped-item NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = tt-ped-item.it-codigo NO-ERROR.

    RUN Destroy in h-bodi154.
    ASSIGN h-bodi154 = ?.
    ASSIGN de-valor-st = 0.
    IF  AVAIL natur-oper 
    AND natur-oper.subs-trib THEN DO:
        ASSIGN de-valor-st = ROUND(tt-ped-item.vl-tot-it - tt-ped-item.vl-liq-it - (tt-ped-item.qt-pedida * tt-ped-item.vl-preuni) * (tt-ped-item.aliquota-ipi / 100),2).
    END.

    IF CAN-FIND (FIRST tt-erro) THEN DO:
        RUN pi-log("CriaItem - Deu erro criacao ITEM pedido").
        RETURN "NOK".
    END.
    ELSE 
        RUN pi-log("CriaItem - Deu certooooooo criacao ITEM pedido " + tt-ped-item.it-codigo + " / Pedido " + tt-ped-item.nr-pedcli).

    RUN pi-log (INPUT "**** Criaá∆o da Tabela Real de Rebate ****").
    FIND FIRST tt-int-ped-item-rebate
         WHERE tt-int-ped-item-rebate.nome-abrev   = tt-ped-item.nome-abrev
           AND tt-int-ped-item-rebate.nr-pedcli    = tt-ped-item.nr-pedcli
           AND tt-int-ped-item-rebate.nr-sequencia = tt-ped-item.nr-sequencia
           AND tt-int-ped-item-rebate.it-codigo    = tt-ped-item.it-codigo
           AND tt-int-ped-item-rebate.cod-refer    = tt-ped-item.cod-refer NO-LOCK NO-ERROR.
    IF AVAIL tt-int-ped-item-rebate THEN DO:
        RUN pi-log (INPUT "**** Achou TTabel Rebate ****").
    
        FIND FIRST int-ped-item-rebate
             WHERE int-ped-item-rebate.nome-abrev   = tt-ped-item.nome-abrev
               AND int-ped-item-rebate.nr-pedcli    = tt-ped-item.nr-pedcli
               AND int-ped-item-rebate.nr-sequencia = tt-ped-item.nr-sequencia
               AND int-ped-item-rebate.it-codigo    = tt-ped-item.it-codigo
               AND int-ped-item-rebate.cod-refer    = tt-ped-item.cod-refer NO-ERROR.
        IF NOT AVAIL int-ped-item-rebate THEN DO:
            RUN pi-log (INPUT "**** Se nao encontrar, cria Rebate ****").
    
            CREATE int-ped-item-rebate.
            ASSIGN int-ped-item-rebate.nome-abrev        = tt-ped-item.nome-abrev  
                   int-ped-item-rebate.nr-pedcli         = tt-ped-item.nr-pedcli   
                   int-ped-item-rebate.nr-sequencia      = tt-ped-item.nr-sequencia
                   int-ped-item-rebate.it-codigo         = tt-ped-item.it-codigo   
                   int-ped-item-rebate.cod-refer         = tt-ped-item.cod-refer 
                   int-ped-item-rebate.log-calcrebate    = tt-int-ped-item-rebate.log-calcrebate
                   int-ped-item-rebate.perc-descto-verde      = tt-int-ped-item-rebate.perc-descto-verde
                   int-ped-item-rebate.perc-descto-top-milhao = tt-int-ped-item-rebate.perc-descto-top-milhao   
                   int-ped-item-rebate.perc-rebate-antec      = tt-int-ped-item-rebate.perc-rebate-antec.
        END. /* IF NOT AVAIL tt-int-ped-item-rebate THEN DO: */
        RUN pi-log (INPUT "**** Atualiza Log Rebate ****" + string(tt-int-ped-item-rebate.log-calcrebate)).
    
        ASSIGN int-ped-item-rebate.log-calcrebate         = tt-int-ped-item-rebate.log-calcrebate
               int-ped-item-rebate.perc-descto-verde      = tt-int-ped-item-rebate.perc-descto-verde
               int-ped-item-rebate.perc-descto-top-milhao = tt-int-ped-item-rebate.perc-descto-top-milhao   
               int-ped-item-rebate.perc-rebate-antec      = tt-int-ped-item-rebate.perc-rebate-antec. 
    
        IF  l-altera-priori-ped                   = YES AND
            int-ped-item-rebate.perc-descto-verde = 0
        THEN
            ASSIGN l-altera-priori-ped = NO.
    
        FIND CURRENT int-ped-item-rebate NO-LOCK NO-ERROR.
    
    END. /* IF AVAIL tt-int-ped-item-rebate THEN DO: */
    ELSE
        ASSIGN l-altera-priori-ped = NO.
    .

    IF NOT AVAIL int-emitente THEN
        FIND FIRST int-emitente NO-LOCK
             WHERE int-emitente.cod-guid     = msg0093.CodigoClienteCRM NO-ERROR.
           
    IF AVAIL int-emitente AND int-emitente.ind-participa-canais = 993520001 /* Participa canais */ THEN DO:
        FIND FIRST int-calculo-canal-item EXCLUSIVE-LOCK
             WHERE int-calculo-canal-item.cod-guid    = int-emitente.cod-guid
               AND int-calculo-canal-item.cod-estabel = tt-ped-venda.cod-estabel
               AND int-calculo-canal-item.it-codigo   = tt-ped-item.it-codigo NO-ERROR.
        IF AVAIL int-calculo-canal-item THEN DO:
            IF int-calculo-canal-item.data-calculo <> TODAY THEN
                ASSIGN int-calculo-canal-item.valor-produto          = item-pedido.PrecoOriginal
                       int-calculo-canal-item.perc-descto-verde      = item-pedido.PercentualDescontoVerde
                       int-calculo-canal-item.perc-descto-top-milhao = item-pedido.PercentualDescontoTopMilhao
                       int-calculo-canal-item.perc-rebate-antec      = item-pedido.PercentualRebateAntecipado
                       int-calculo-canal-item.data-calculo           = TODAY.
        END.
        ELSE DO:
            CREATE int-calculo-canal-item.
            ASSIGN int-calculo-canal-item.cod-guid               = int-emitente.cod-guid   
                   int-calculo-canal-item.cod-estabel            = tt-ped-venda.cod-estabel   
                   int-calculo-canal-item.it-codigo              = tt-ped-item.it-codigo
                   int-calculo-canal-item.preco-base             = item-pedido.PrecoOriginal
                   int-calculo-canal-item.valor-produto          = item-pedido.PrecoOriginal
                   int-calculo-canal-item.tipo-portifolio        = 993520005
                   int-calculo-canal-item.bloqueado              = NO
                   int-calculo-canal-item.qtd-range              = 0
                   int-calculo-canal-item.log-calcrebate         = NO   
                   int-calculo-canal-item.log-preco-alterado     = NO
                   int-calculo-canal-item.log-rebate-antec       = NO
                   int-calculo-canal-item.perc-descto-verde      = item-pedido.PercentualDescontoVerde
                   int-calculo-canal-item.perc-descto-top-milhao = item-pedido.PercentualDescontoTopMilhao
                   int-calculo-canal-item.perc-rebate-antec      = item-pedido.PercentualRebateAntecipado
                   int-calculo-canal-item.data-calculo           = TODAY.
        END.
        FIND CURRENT int-calculo-canal-item NO-LOCK NO-ERROR.
        RELEASE int-calculo-canal-item.
    END.

    CREATE item-pedidor.
    ASSIGN item-pedidor.ChaveIntegracao             = string(ped-venda.cod-emitente) + "," + string(ped-venda.nr-pedcli) + "," + string(tt-ped-item.nr-sequencia) + "," + tt-ped-item.it-codigo + "," + item.cod-refer
           item-pedidor.Produto                     = tt-ped-item.it-codigo
           item-pedidor.Sequencia                   = tt-ped-item.nr-sequencia
           item-pedidor.QuantidadePedida            = tt-ped-item.qt-pedida
           item-pedidor.PrecoOriginal               = round(tt-ped-item.vl-pretab,4)
           item-pedidor.ValorLiquido                = round(tt-ped-item.vl-liq-it,4)
           item-pedidor.ValorLiquidoAberto          = round(tt-ped-item.vl-liq-abe,4)
           item-pedidor.ValorIPI                    = round(tt-ped-item.val-ipi,4)
           item-pedidor.AliquotaIPI                 = round(tt-ped-item.aliquota-ipi,2)
           item-pedidor.AliquotaICMS                = round(de-perc-icms,2)
           item-pedidor.ValorICMS                   = round(tt-ped-item.vl-liq-it * de-perc-icms / 100,2)
           item-pedidor.ValorTotal                  = round(tt-ped-item.vl-tot-it,4)
           i-item-pai                               = 0.

    FIND FIRST int-ped-item-rebate
        WHERE int-ped-item-rebate.nome-abrev   = tt-ped-item.nome-abrev  
          AND int-ped-item-rebate.nr-pedcli    = tt-ped-item.nr-pedcli   
          AND int-ped-item-rebate.nr-sequencia = tt-ped-item.nr-sequencia
          AND int-ped-item-rebate.it-codigo    = tt-ped-item.it-codigo   
          AND int-ped-item-rebate.cod-refer    = tt-ped-item.cod-refer   NO-LOCK NO-ERROR.
    IF AVAIL int-ped-item-rebate THEN DO:
        ASSIGN item-pedidor.CalcularRebate          = int-ped-item-rebate.log-calcrebate
               item-pedidor.PercentualDescontoVerde            = int-ped-item-rebate.perc-descto-verde
               //item-pedidor.PercentualDescontoTopMilhao        = int-ped-item-rebate.perc-descto-top-milhao
               //item-pedidor.PercentualRebateAntecipado = int-ped-item-rebate.perc-rebate-antec
               .
    END.


    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

PROCEDURE pi-cancela-pedido:
    IF NOT VALID-HANDLE(bo-ped-venda-can) 
    OR bo-ped-venda-can:TYPE <> "PROCEDURE":U 
    OR bo-ped-venda-can:FILE-NAME <> "dibo/bodi159can.p" THEN
        RUN dibo/bodi159can.p PERSISTENT SET bo-ped-venda-can.

    RUN setUserLog IN bo-ped-venda-can (INPUT c-seg-usuario).

    RUN validateCancelation IN bo-ped-venda-can (INPUT  ROWID(ped-venda),
                                                 OUTPUT TABLE Rowerrors).
    IF CAN-FIND(FIRST RowErrors) THEN DO:
        FOR EACH rowErrors
            WHERE RowErrors.ErrorType <> "INTERNAL"
              AND RowErrors.ErrorSubType = "Error":U:
            RUN pi-erro (INPUT RowErrors.errorDescription).
        END.
        RETURN "NOK":U.
    END.
    
    RUN inputReopenQuotation IN bo-ped-venda-can(INPUT NO).
    RUN updateCancelation    IN bo-ped-venda-can(INPUT ROWID(ped-venda),
                                                 INPUT "Cancelamento pedido via integraá∆o Programa Canais",
                                                 INPUT TODAY,
                                                 INPUT 13).

    RUN getRowErrors IN bo-ped-venda-can (OUTPUT TABLE RowErrors). 

    RUN Destroy   IN bo-ped-venda-can.
    ASSIGN bo-ped-venda-can = ?.
    
    RUN pi-gera-retorno-erro.

    IF  CAN-FIND(FIRST RowErrors) THEN DO:
        FOR EACH rowErrors
            WHERE RowErrors.ErrorType <> "INTERNAL"
              AND RowErrors.ErrorSubType = "Error":U:
            RUN pi-erro (INPUT RowErrors.errorDescription).
        END.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-cancela-item:
    IF NOT VALID-HANDLE(bo-ped-item-can) 
    OR bo-ped-item-can:TYPE <> "PROCEDURE":U 
    OR bo-ped-item-can:FILE-NAME <> "dibo/bodi154can.p" THEN
       RUN dibo/bodi154can.p PERSISTENT SET bo-ped-item-can.

    RUN setUserLog IN bo-ped-item-can (INPUT c-seg-usuario).

    RUN validateCancelation IN bo-ped-item-can (INPUT ROWID(ped-item),
                                                INPUT "Cancelamento item do pedido via integraá∆o Programa Canais",
                                                INPUT-OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        FOR EACH rowErrors
            WHERE RowErrors.ErrorType <> "INTERNAL"
              AND RowErrors.ErrorSubType = "Error":U:
            RUN pi-erro (INPUT RowErrors.errorDescription).
        END.
        RETURN "NOK":U.
    END.
                 
    IF ped-item.ind-componen = 2 THEN             
        RUN updateCancelationComposto IN bo-ped-item-can (INPUT  ROWID(ped-item),
                                                          INPUT  "Cancelamento item do pedido via integraá∆o Programa Canais",
                                                          INPUT  TODAY,
                                                          INPUT  13).
    ELSE
        RUN updateCancelation in bo-ped-item-can (INPUT  ROWID(ped-item),
                                                  INPUT  "Cancelamento item do pedido via integraá∆o Programa Canais",
                                                  INPUT  TODAY,
                                                  INPUT  13).

    RUN getRowErrors IN bo-ped-item-can (OUTPUT TABLE RowErrors). 
    
    RUN destroyBO IN bo-ped-item-can.
    RUN Destroy   IN bo-ped-item-can.
    ASSIGN bo-ped-item-can = ?.

    /*Calcula ICMS para retornar na mensagem*/
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

    FIND FIRST loc-entr NO-LOCK USE-INDEX ch-entrega
         WHERE loc-entr.cod-entrega = "padrao"
           AND loc-entr.nome-abrev  = emitente.nome-abrev NO-ERROR.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

    ASSIGN g-cod-emitente-bodi317im1br = emitente.cod-emitente.
    ASSIGN g-codigo-orig-bodi317sd     = ITEM.codigo-orig.
    RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.
    ASSIGN de-perc-icms = 0.
    IF emitente.contrib-icm = YES THEN DO:
        FOR FIRST inf-compl  /* conteudo do cd0908 */
            WHERE inf-compl.cdn-identif = 5
            AND inf-compl.cod-indice = item.it-codigo + CHR(2) + estabelec.estado + CHR(2) + loc-entr.estado NO-LOCK:
            ASSIGN de-perc-icms = inf-compl.val-campo.
        END.
    END.
    IF de-perc-icms = 0 THEN DO:
        RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  emitente.contrib-icms,
                                                  INPUT  emitente.natureza,
                                                  INPUT  estabelec.estado,
                                                  INPUT  estabelec.pais,
                                                  INPUT  loc-entr.estado,
                                                  INPUT  item.it-codigo,
                                                  INPUT  natur-oper.nat-operacao,
                                                  OUTPUT de-perc-icms, 
                                                  OUTPUT l-return).
    END.
    RUN Destroy in h-bodi317im1br.
    ASSIGN h-bodi317im1br              = ?
           g-cod-emitente-bodi317im1br = 0
           g-codigo-orig-bodi317sd     = 0.

    ASSIGN de-valor-st = 0.
    ASSIGN de-valor-st = ROUND(ped-item.vl-tot-it - ped-item.vl-liq-it - (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2).

    CREATE item-pedidor.
    ASSIGN item-pedidor.ChaveIntegracao             = string(ped-venda.cod-emitente) + "," + string(ped-venda.nr-pedcli) + "," + string(ped-item.nr-sequencia) + "," + ped-item.it-codigo + "," + item.cod-refer
           item-pedidor.Produto                     = ped-item.it-codigo
           item-pedidor.Sequencia                   = ped-item.nr-sequencia
           item-pedidor.QuantidadePedida            = ped-item.qt-pedida
           item-pedidor.PrecoOriginal               = round(ped-item.vl-pretab,4)
           item-pedidor.ValorLiquido                = round(ped-item.vl-liq-it,4)
           item-pedidor.ValorLiquidoAberto          = round(ped-item.vl-liq-abe,4)
           item-pedidor.ValorSubstituicaoTributaria = round(de-valor-st,4)
           item-pedidor.ValorIPI                    = round(ped-item.val-ipi,4)
           item-pedidor.AliquotaIPI                 = round(ped-item.aliquota-ipi,2)
           item-pedidor.AliquotaICMS                = round(de-perc-icms,2)
           item-pedidor.ValorICMS                   = round(ped-item.vl-liq-it * de-perc-icms / 100,2)
           item-pedidor.ValorTotal                  = round(ped-item.vl-tot-it,4).
    
    FIND FIRST int-ped-item-rebate
        WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev  
          AND int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli   
          AND int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
          AND int-ped-item-rebate.it-codigo    = ped-item.it-codigo   
          AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer   NO-LOCK NO-ERROR.
    IF AVAIL int-ped-item-rebate THEN DO:
        ASSIGN item-pedidor.CalcularRebate          = int-ped-item-rebate.log-calcrebate
               item-pedidor.PercentualDescontoVerde            = int-ped-item-rebate.perc-descto-verde
               //item-pedidor.PercentualDescontoTopMilhao        = int-ped-item-rebate.perc-descto-top-milhao
               //item-pedidor.PercentualRebateAntecipado = int-ped-item-rebate.perc-rebate-antec
               .
    END.

    IF  CAN-FIND(FIRST RowErrors) THEN DO:
        FOR EACH rowErrors
            WHERE RowErrors.ErrorType <> "INTERNAL"
              AND RowErrors.ErrorSubType = "Error":U:
            RUN pi-erro (INPUT RowErrors.errorDescription).
        END.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE. 

PROCEDURE pi-gera-retorno-erro:

    
    IF  NOT CAN-FIND (FIRST pedidor)
    AND AVAIL ped-venda THEN DO:
        
        CREATE pedidor.
        ASSIGN pedidor.NumeroPedido       = ped-venda.nr-pedcli
               pedidor.Representante      = msg0093.Representante
               pedidor.CodigoClienteCRM   = msg0093.CodigoClienteCRM 
               pedidor.Atendente          = INT(ped-venda.tp-pedido)
               pedidor.CodigoSupervisorEMS = msg0093.CodigoSupervisorEMS
               pedidor.Estabelecimento    = ped-venda.cod-estabel
               pedidor.CondicaoPagamento  = ped-venda.cod-cond-pag
               pedidor.CondicaoEspecial   = ped-venda.cond-espec
               pedidor.Observacao         = ped-venda.observacoes
               pedidor.FaturamentoParcial = ped-venda.ind-fat-par
               pedidor.Vendor             = msg0093.Vendor
               pedidor.DiasBaseVendor     = msg0093.DiasBase
               pedidor.TaxaClienteVendor  = msg0093.TaxaCliente
               pedidor.DataEmissao        = ped-venda.dt-emissao
               pedidor.DataEntrega        = ped-venda.dt-entrega
               pedidor.DataNegociacao     = ? /*Caso o canal passar a informar data negociaá∆o tratar essa informaá∆o*/
               pedidor.DiasNegociacao     = ?
               pedidor.TipoObjetoCliente  = msg0093.TipoObjetoCliente
               pedidor.Situacao           = msg0093.Situacao.
    END.

    FOR EACH ped-item OF ped-venda NO-LOCK:
        ASSIGN de-valor-st = 0.

        /*Calcula ICMS para retornar na mensagem*/
        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
    
        FIND FIRST loc-entr NO-LOCK USE-INDEX ch-entrega
             WHERE loc-entr.cod-entrega = "padrao"
               AND loc-entr.nome-abrev  = emitente.nome-abrev NO-ERROR.
    
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-ERROR.

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.

        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.
    
        ASSIGN g-cod-emitente-bodi317im1br = emitente.cod-emitente.
        ASSIGN g-codigo-orig-bodi317sd     = ITEM.codigo-orig.
        RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.
        ASSIGN de-perc-icms = 0.
        IF emitente.contrib-icm = YES THEN DO:
            FOR FIRST inf-compl  /* conteudo do cd0908 */
                WHERE inf-compl.cdn-identif = 5
                AND inf-compl.cod-indice = item.it-codigo + CHR(2) + estabelec.estado + CHR(2) + loc-entr.estado NO-LOCK:
                ASSIGN de-perc-icms = inf-compl.val-campo.
            END.
        END.
        IF de-perc-icms = 0 THEN DO:
            RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  emitente.contrib-icms,
                                                      INPUT  emitente.natureza,
                                                      INPUT  estabelec.estado,
                                                      INPUT  estabelec.pais,
                                                      INPUT  loc-entr.estado,
                                                      INPUT  item.it-codigo,
                                                      INPUT  natur-oper.nat-operacao,
                                                      OUTPUT de-perc-icms, 
                                                      OUTPUT l-return).
        END.
        RUN Destroy in h-bodi317im1br.
        ASSIGN h-bodi317im1br = ?.

        ASSIGN g-cod-emitente-bodi317im1br = 0.
        ASSIGN g-codigo-orig-bodi317sd     = 0.

        ASSIGN de-valor-st = ROUND(ped-item.vl-tot-it - ped-item.vl-liq-it - (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2).

        CREATE item-pedidor.
        ASSIGN item-pedidor.ChaveIntegracao             = string(ped-venda.cod-emitente) + "," + string(ped-venda.nr-pedcli) + "," + string(ped-item.nr-sequencia) + "," + ped-item.it-codigo + "," + item.cod-refer
               item-pedidor.Produto                     = ped-item.it-codigo
               item-pedidor.Sequencia                   = ped-item.nr-sequencia
               item-pedidor.QuantidadePedida            = ped-item.qt-pedida
               item-pedidor.PrecoOriginal               = round(ped-item.vl-pretab,4)
               item-pedidor.ValorLiquido                = round(ped-item.vl-liq-it,4)
               item-pedidor.ValorLiquidoAberto          = round(ped-item.vl-liq-abe,4)
               item-pedidor.ValorSubstituicaoTributaria = round(de-valor-st,4)
               item-pedidor.ValorIPI                    = round(ped-item.val-ipi,4)
               item-pedidor.AliquotaIPI                 = round(ped-item.aliquota-ipi,2)
               item-pedidor.AliquotaICMS                = round(de-perc-icms,2)
               item-pedidor.ValorICMS                   = round(ped-item.vl-liq-it * de-perc-icms / 100,2)
               item-pedidor.ValorTotal                  = round(ped-item.vl-tot-it,4).

        FIND FIRST int-ped-item-rebate
            WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev  
              AND int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli   
              AND int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
              AND int-ped-item-rebate.it-codigo    = ped-item.it-codigo   
              AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer   NO-LOCK NO-ERROR.
        IF AVAIL int-ped-item-rebate THEN DO:
            ASSIGN item-pedidor.CalcularRebate          = int-ped-item-rebate.log-calcrebate
                   item-pedidor.PercentualDescontoVerde            = int-ped-item-rebate.perc-descto-verde
                   //item-pedidor.PercentualDescontoTopMilhao        = int-ped-item-rebate.perc-descto-top-milhao
                   //item-pedidor.PercentualRebateAntecipado = int-ped-item-rebate.perc-rebate-antec
                   .
        END.

    END.
END.

PROCEDURE pi-prod-composto:

    DEFINE VARIABLE de-total-preco AS DECIMAL     NO-UNDO.

    /**********************************************************/
    /**********************************************************/
    EMPTY TEMP-TABLE tt-itens.
    FOR EACH ped-item OF ped-venda NO-LOCK:

        FIND FIRST ITEM          WHERE ITEM.it-codigo              = ped-item.it-codigo NO-LOCK NO-ERROR.

        FIND FIRST prod-composto WHERE prod-composto.it-codigo-pai = ped-item.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL prod-composto THEN DO:

            FIND FIRST item-uni-estab NO-LOCK
                 WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
                   AND item-uni-estab.it-codigo   = prod-composto.it-codigo-filho NO-ERROR.

            RUN pi-verifica-portfolio-canais.

            FOR EACH  prod-composto NO-LOCK  /* Calcula o total dos itens do produto composto para ratear por item */
                WHERE prod-composto.it-codigo-pai = ped-item.it-codigo:

                FIND FIRST ProdutoItem
                     WHERE ProdutoItem.CodigoProduto = prod-composto.it-codigo-filho
                       AND ProdutoItem.bloqueado     = FALSE NO-LOCK NO-ERROR.
                IF NOT AVAIL produtoitem THEN DO:
                    RUN pi-erro (INPUT "ITEM " + prod-composto.it-codigo-filho + " Nao encontrado n" + "o portfolio d" + "o cliente, ITEM Pertencente ao produto composto : " + prod-composto.it-codigo-pai).
                    RUN pi-gera-retorno-erro.
                    RETURN "NOK":U.
                END.

                CREATE tt-itens.
                ASSIGN tt-itens.it-codigo              = prod-composto.it-codigo-filho
                       tt-itens.de-quantidade          = ped-item.qt-pedida * prod-composto.qt-filho
                       tt-itens.TipoPortfolio          = ProdutoItem.TipoPortfolio
                       tt-itens.CodigoUnidadeNegocio   = item-uni-estab.cod-unid-neg
                       tt-itens.CodigoFamiliaComercial = ITEM.fm-cod-com
                       tt-itens.CodigoEstabelecimento  = ped-venda.cod-estabel.

                IF OPSYS = "UNIX" THEN log-manager:write-message("pi-prod-composto tt-itens.it-codigo " + tt-itens.it-codigo  + " | " + prod-composto.it-codigo-pai).

            END. /* FOR EACH  prod-composto NO-LOCK */

        END. /* IF AVAIL prod-composto THEN DO: */

    END. /* FOR EACH ped-item OF ped-venda NO-LOCK: */

    IF CAN-FIND (FIRST tt-itens) THEN DO:
        
/*         ASSIGN ped-venda.cod-sit-ped = 1. */

        IF OPSYS = "UNIX" THEN log-manager:write-message("msg0093 ----->>>> pi-prod-composto Atualizado STATUS " + STRING(ped-venda.cod-sit-ped)).

        FIND FIRST int-emitente NO-LOCK                                      
             WHERE int-emitente.cod-guid = msg0093.CodigoClienteCRM NO-ERROR.
        IF AVAIL int-emitente THEN DO:

            RUN esp/esb/out/msg0101.p (INPUT int-emitente.cod-guid,              
                                       INPUT TABLE tt-itens,                     
                                       OUTPUT TABLE ProdutoItemR,                
                                       OUTPUT TABLE Resultado).                  
            EMPTY TEMP-TABLE Resultado.                                          
        END.

        FOR EACH b1-ped-item OF ped-venda NO-LOCK:
    
            IF OPSYS = "UNIX" THEN log-manager:write-message("pi-prod-composto " + b1-ped-item.it-codigo).
    
            FIND FIRST prod-composto NO-LOCK
                 WHERE prod-composto.it-codigo-pai = b1-ped-item.it-codigo NO-ERROR.
    
            IF OPSYS = "UNIX" THEN log-manager:write-message("pi-prod-composto Produto composto " + b1-ped-item.it-codigo + STRING(AVAIL prod-composto)).
            IF AVAIL prod-composto THEN DO:
    
                ASSIGN ped-venda.cod-sit-ped = 1. 
                
                FOR EACH  prod-composto NO-LOCK
                    WHERE prod-composto.it-codigo-pai = b1-ped-item.it-codigo:
    
                    IF OPSYS = "UNIX" THEN log-manager:write-message("pi-prod-composto ITEM filho !! " + prod-composto.it-codigo-filho + " " +  STRING(ped-venda.cod-sit-ped)).
    
                    FIND FIRST ProdutoItemR
                         WHERE ProdutoItemR.CodigoProduto = prod-composto.it-codigo-filho NO-ERROR.
                    IF NOT AVAIL produtoitemr  THEN DO:
                         IF OPSYS = "UNIX" THEN log-manager:write-message("pi-prod-composto Produto sem preáo NO Portfolio DO cliente !! " + prod-composto.it-codigo-filho).
                          RUN pi-erro (INPUT "Produto sem preáo NO Portfolio DO cliente !! ITEM " + prod-composto.it-codigo-filho + " Pertencente ao produto composto : " + prod-composto.it-codigo-pai).
                          RUN pi-gera-retorno-erro.
                          RETURN "NOK":U.
                    END.
                    ELSE DO:
    
                        IF OPSYS = "UNIX" THEN log-manager:write-message("pi-prod-composto com preco - CriaItem !! " + prod-composto.it-codigo-filho  + " " +  STRING(ped-venda.cod-sit-ped) + 
                                                  " qtde =  " +
                                                  string(b1-ped-item.qt-pedida) + " qtde Filho =  " + string(prod-composto.qt-filho)
                                                  
                                                  ).
        
                        RUN CriaItem (INPUT prod-composto.it-codigo-filho,
                                      INPUT b1-ped-item.qt-pedida * prod-composto.qt-filho,
                                      INPUT ProdutoItemR.ValorComDesconto,
                                      INPUT NO,
                                      INPUT NO).
        
                        IF OPSYS = "UNIX" THEN log-manager:write-message("pi-prod-composto com preco - Sai CriaItem !! " + prod-composto.it-codigo-filho) .
        
                        IF RETURN-VALUE = "NOK" THEN DO:
                            IF OPSYS = "UNIX" THEN log-manager:write-message("ERRO pi-prod-composto com preco - Sai CriaItem !! " + prod-composto.it-codigo-filho).
    
                            RUN pi-gera-retorno-erro.
                            RETURN "NOK":U.
                        END.
                    END.
    
                END.
    
                FIND ped-item WHERE rowid(ped-item) = ROWID(b1-ped-item) NO-LOCK NO-ERROR.
    
                FIND item-pedidor 
                    WHERE item-pedidor.ChaveIntegracao = string(ped-venda.cod-emitente) + "," + string(ped-venda.nr-pedcli) + "," + string(ped-item.nr-sequencia) + "," + ped-item.it-codigo + "," + item.cod-refer EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL item-pedidor THEN DELETE item-pedidor.

                RUN pi-exclui-item.
    
                IF RETURN-VALUE = "NOK" THEN DO:
                    RUN pi-gera-retorno-erro.
                    RETURN "NOK":U.
                END.
    
            END.
        END.
        
    END. /* IF CAN-FIND (FIRST tt-itens) THEN DO: */
/**********************************************************/
/**********************************************************/

    
    RETURN "OK":U.
END.
PROCEDURE pi-log:
    DEFINE INPUT PARAM c-log AS CHAR.
    IF OPSYS = "UNIX" THEN log-manager:write-message(c-log).
END PROCEDURE.

PROCEDURE UpdateSuspension:
    
    RUN pi-log (INPUT "Observacao em suspensao " + ped-venda.observacoes + " FIM ").
    

    IF  (ped-venda.observacoes <> "" 
    AND ped-venda.cod-priori  <> 44 
    AND ped-venda.cod-sit-ped <>  6 
    AND ped-venda.cod-priori  <>  3) OR lsuspendeped THEN DO:

        RUN pi-log (INPUT "dentro suspensao " + ped-venda.observacoes + " FIM ").

        FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
        for each ped-item of ped-venda
                where ped-item.cod-sit-item <= 2 exclusive-lock:
    
                for each ped-ent of ped-item
                    where ped-ent.cod-sit-ent <= 2 exclusive-lock:
    
                    assign ped-ent.cod-sit-ent  = 5
                           ped-ent.dt-suspensao = today
                           ped-ent.user-susp    = "Integra"
                           ped-ent.dt-usersusp  = today.
                end.

                assign ped-item.dt-suspensao = today
                       ped-item.user-susp    = "Integra"
                       ped-item.dt-usersusp  = today
                       ped-item.cod-sit-item = 5.
        end.
    
        assign ped-venda.dt-suspensao = today
               ped-venda.user-susp    = "Integra"
               ped-venda.dt-usersusp  = today
               ped-venda.desc-suspend = ped-venda.observacoes
               ped-venda.dt-useralt   = TODAY 
               ped-venda.user-alt     = "Integra"
               ped-venda.cod-sit-ped  = 5.

        IF  NOT(msg0093.PedidoProgramado AND msg0093.Situacao = 2) 
        AND NOT ped-venda.observacoes MATCHES "*composto*" THEN 
            ASSIGN ped-venda.cod-priori = 99.
    END.
END PROCEDURE.

PROCEDURE pi-verifica-portfolio-canais:

    RUN pi-log (INPUT "pi-verifica-portfolio-canais"). 

    EMPTY TEMP-TABLE produtoitem.

    FIND FIRST int-emitente NO-LOCK                                      
         WHERE int-emitente.cod-guid = msg0093.CodigoClienteCRM NO-ERROR.
    IF AVAIL int-emitente THEN DO:

        FIND natur-oper
            WHERE natur-oper.nat-operacao = ped-venda.nat-operacao NO-LOCK NO-ERROR.
        IF AVAIL natur-oper THEN DO:

            IF  int-emitente.ind-participa-canais = 993520001 
            AND natur-oper.emite-duplic = YES THEN DO:

                    RUN esp/es0018p.p (INPUT "PD4000",
                                       INPUT 4,
                                       INPUT 0,
                                       INPUT "", 
                                       OUTPUT TABLE tt-prog-ponto).

                    /*Unidade de negocios n∆o faz parte do programa de canais*/
                    IF NOT CAN-FIND (FIRST tt-prog-ponto
                                 WHERE tt-prog-ponto.conteudo = item-uni-estab.cod-unid)  THEN DO:

                        RUN pi-log (INPUT "pi-verifica-portfolio-canais - buscando preáo"). 
                        RUN esp/esb/out/msg0100.p (INPUT  int-emitente.cod-guid,
                                                   OUTPUT TABLE ProdutoItem,                    
                                                   OUTPUT TABLE Resultado). 

/*                         FOR EACH produtoItem.                                                                                      */
/*                             RUN pi-log (INPUT "pi-verifica-portfolio-canais - FOR EACH produtoItem " + ProdutoItem.CodigoProduto). */
/*                         END.                                                                                                       */

                        FIND FIRST ProdutoItem NO-LOCK NO-ERROR.

                        FIND FIRST Resultado   NO-ERROR.
                        IF AVAIL Resultado AND
                           Resultado.Sucesso THEN DO:

                           FOR FIRST ponto-programa NO-LOCK
                               WHERE ponto-programa.nome-programa = "pd4000"
                                 AND ponto-programa.ponto         = 5:
                           END.
                           FIND FIRST conteudo-programa 
                           WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                              AND conteudo-programa.conteudo     = c-seg-usuario NO-LOCK NO-ERROR.
                           IF AVAIL conteudo-programa THEN DO:
                                FIND FIRST int-ped-venda
                                    WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                                IF AVAIL int-ped-venda THEN
                                    ASSIGN OVERLAY(int-ped-venda.char-1, 80, 12) = c-seg-usuario.
                                RELEASE int-ped-venda.
                            END. /* IF AVAIL conteudo-programa THEN DO: */
                            ELSE DO:
                                IF NOT AVAIL  ProdutoItem  THEN DO:
                                    RUN pi-log (INPUT "pi-verifica-portfolio-canais - Nao Encontrado produtos NO portfolio DO canal"). 
                                    RUN pi-erro (INPUT "Nao Encontrado produtos NO portfolio DO canal").
                                END.
                            END. /* IF NOT CAN-FIND (FIRST ProdutoItem */

                        END. /* IF Resultado.Sucesso THEN DO: */
                        ELSE DO:
                            IF AVAIL resultado THEN DO:
                                RUN pi-log (INPUT "pi-verifica-portfolio-canais - Resultado.Mensagem " + Resultado.Mensagem). 
                                RUN pi-erro (INPUT Resultado.Mensagem).
                            END.
                        END. /* IF AVAIL Resultado THEN DO: */

                    END. /* IF NOT CAN-FIND (FIRST tt-prog-ponto */
                
            END. /* IF  int-emitente.ind-participa-canais = 993520001 AND natur-oper.emite-duplic = YES THEN DO: */

        END. /* IF AVAIL natur-oper THEN DO: */

    END. /* IF AVAIL int-emitente THEN DO: */

    RUN pi-log (INPUT "END pi-verifica-portfolio-canais"). 

END PROCEDURE.

PROCEDURE RetiraAcentos:

    DEF INPUT-OUTPUT PARAMETER c-texto AS CHAR.
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-caracter AS CHARACTER   NO-UNDO.
    

    DO i-cont = 1 TO LENGTH(c-texto):
        ASSIGN c-caracter = SUBSTRING(c-texto,i-cont,1).
        CASE trim(c-caracter):
           when "a" THEN next.
           when "b" THEN next.
           when "c" THEN next.
           when "d" THEN next.
           when "e" THEN next.
           when "f" THEN next.
           when "g" THEN next.
           when "h" THEN next.
           when "i" THEN next.
           when "j" THEN next.
           when "k" THEN next.
           when "l" THEN next.
           when "m" THEN next.
           when "n" THEN next.
           when "o" THEN next.
           when "p" THEN next.
           when "q" THEN next.
           when "r" THEN next.
           when "s" THEN next.
           when "t" THEN next.
           when "u" THEN next.
           when "v" THEN next.
           when "w" THEN next.
           when "x" THEN next.
           when "y" THEN next.
           when "z" THEN next.
           when " " THEN next.
           when "0" THEN next.
           when "1" THEN next.
           when "2" THEN next.
           when "3" THEN next.
           when "4" THEN next.
           when "5" THEN next.
           when "6" THEN next.
           when "7" THEN next.
           when "8" THEN next.
           when '9' THEN next.
           when '"' THEN next.
           when "'" THEN next.
           when "!" THEN next.
           when "[" THEN next.
           when "]" THEN next.
           when "@" THEN next.
           when "#" THEN next.
           when "$" THEN next.
           when "%" THEN next.
           when "&" THEN next.
           when "*" THEN next.
           when "(" THEN next.
           when ")" THEN next.
           when "-" THEN next.
           when "_" THEN next.
           when "=" THEN next.
           when "+" THEN next.
           when "<" THEN next.
           when ">" THEN next.
           when "," THEN next.
           when "." THEN next.
           when ":" THEN next.
           when ";" THEN next.
           when "?" THEN next.
           when "/" THEN next.
           when "~\" THEN next.
           OTHERWISE ASSIGN OVERLAY(c-texto,i-cont,1) = "".
       END.
    END.



END PROCEDURE.
