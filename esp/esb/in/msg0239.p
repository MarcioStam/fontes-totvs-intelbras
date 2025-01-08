CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                            */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>shen_liling@dahuatech.com-161953-2-3-4-5</NumeroOperacao>   */
/*     <CodigoMensagem>MSG0239</CodigoMensagem>                                    */
/*     <LoginUsuario>shen_liling@dahuatech.com</LoginUsuario>                      */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0239>                                                                   */
/*       <CodigoFornecedorEMS>161953</CodigoFornecedorEMS>                         */
/*       <MatriculaUsuario>zz99999</MatriculaUsuario>                              */
/*       <FiltroData>                                                              */
/*           <DataInicialPeriodo>2019-02-18</DataInicialPeriodo>                   */
/*           <DataFinalPeriodo>2019-02-18</DataFinalPeriodo>                       */
/*           <PesquisaData>6</PesquisaData>                                        */
/*       </FiltroData>                                                             */
/*       <FiltroAceite>                                                            */
/*         <SituacaoAceitePedido>2</SituacaoAceitePedido>                          */
/*       </FiltroAceite>                                                           */
/*       <FiltroAceite>                                                            */
/*         <SituacaoAceitePedido>3</SituacaoAceitePedido>                          */
/*       </FiltroAceite>                                                           */
/*       <FiltroAceite>                                                            */
/*         <SituacaoAceitePedido>4</SituacaoAceitePedido>                          */
/*       </FiltroAceite>                                                           */
/*       <FiltroAceite>                                                            */
/*         <SituacaoAceitePedido>5</SituacaoAceitePedido>                          */
/*       </FiltroAceite>                                                           */
/*       <I18N>true</I18N>                                                         */
/*       <ApenasStatusPrev>TRUE</ApenasStatusPrev>                                 */
/*     </MSG0239>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

DEFINE BUFFER b-ordens-embarque     FOR ordens-embarque.
DEFINE BUFFER b-historico-inspecao  FOR historico-inspecao.
DEFINE BUFFER b-historico-embarque  FOR historico-embarque.
DEFINE BUFFER b2-historico-embarque FOR historico-embarque.
DEFINE BUFFER b3-historico-embarque FOR historico-embarque.
DEFINE BUFFER b-embarque-imp        FOR embarque-imp.
    DEFINE VARIABLE i-dias-total AS INTEGER     NO-UNDO.


{esp/esb/in/msg0239.i}
{esp/es0018.i}
{esp/esb/esesb000fn1.i}
{include/boerrtab.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0239, ttFiltroData, ttPedidos, ttEmbarques, ttEstabelecimento, ttProdutoFabricante, FiltroAceite
   DATA-RELATION FOR conteudo, MSG0239            RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0239, ttFiltroData        RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0239, ttPedidos           RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0239, ttEmbarques         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0239, ttEstabelecimento   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0239, ttProdutoFabricante RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0239, FiltroAceite        RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0239R1, PedidoOrdemCompra, InspecaoAgendada, resultado
   DATA-RELATION FOR conteudor, MSG0239R1                RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0239R1, PedidoOrdemCompra        RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR PedidoOrdemCompra, InspecaoAgendada RELATION-FIELDS (id-relac, id-relac) NESTED
   DATA-RELATION FOR MSG0239R1, resultado                RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0239R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0239 NO-ERROR.

CREATE conteudor.
CREATE MSG0239R1.
CREATE resultado.

DEFINE VARIABLE h-query                  AS WIDGET-HANDLE.
DEFINE VARIABLE c-querys                 AS CHARACTER            NO-UNDO.
DEFINE VARIABLE c-where-pedido           AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE c-where-ordem            AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE c-where-estabec          AS CHARACTER            NO-UNDO.
DEFINE VARIABLE c-where-item             AS CHARACTER            NO-UNDO.
DEFINE VARIABLE c-where-forn-prod-fabric AS CHARACTER            NO-UNDO.
DEFINE VARIABLE i-situacao-emb           AS INTEGER              NO-UNDO.
DEFINE VARIABLE de-indice                AS DECIMAL              NO-UNDO.
DEFINE VARIABLE i-id-relac               AS INTEGER              NO-UNDO.
DEFINE VARIABLE l-filtro-inspetor        AS LOG NO-UNDO.
DEFINE VARIABLE h-bocx230                AS HANDLE      NO-UNDO.

DEFINE TEMP-TABLE tt-item-fabric-fornec
    FIELD cod-fornec LIKE fab-for.cod-fornec
    FIELD it-codigo  LIKE item-fabric.it-codigo
    INDEX idx1 IS UNIQUE PRIMARY cod-fornec it-codigo.

RUN esp/es0018p.p (INPUT "ESCEP055":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

DEFINE VARIABLE i-time AS INTEGER     NO-UNDO.
ASSIGN i-time = TIME.

IF NOT VALID-HANDLE(h-bocx230) THEN DO:
   RUN cxbo/bocx230a.p persistent set h-bocx230.
END.

RUN pi-carrega-pedido.

IF VALID-HANDLE(h-bocx230) THEN DO:
    delete procedure h-bocx230.
END. 

ASSIGN MSG0239R1.ExibePrecos = fnExibePrecos(MSG0239.MatriculaUsuario).

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-aplica-filtro-estabelecimento:
    ASSIGN c-where-estabec = "".
    IF CAN-FIND(FIRST ttEstabelecimento) THEN DO:
        DEFINE VARIABLE l-encontrou AS LOGICAL INITIAL FALSE NO-UNDO.

        FOR EACH ttEstabelecimento:
            IF l-encontrou = TRUE THEN
                 ASSIGN c-where-estabec = c-where-estabec + " OR ".
            ASSIGN c-where-estabec = c-where-estabec + " pedido-compr.cod-estabel = '" + STRING(ttEstabelecimento.CodigoEstabelecimento) + "'"
                   l-encontrou = TRUE.
        END.
        IF TRIM(c-where-estabec) <> "" THEN DO:
            ASSIGN c-where-pedido = c-where-pedido + " AND ( " + c-where-estabec + ")".
        END.

    END.
END PROCEDURE.

PROCEDURE pi-aplica-filtro-item:
    IF  MSG0239.CodigoProdutoInicial <> ?
    AND MSG0239.CodigoProdutoFinal   <> ? THEN
       ASSIGN c-where-item = " ordem-compra.it-codigo >= '" + STRING(MSG0239.CodigoProdutoInicial) + "'" + "AND" + 
                             " ordem-compra.it-codigo <= '" + STRING(MSG0239.CodigoProdutoFinal) + "'".
    
        IF TRIM(c-where-item) <> "" THEN 
            ASSIGN c-where-ordem = c-where-ordem + " AND ( " + c-where-item + ")".

END PROCEDURE.

PROCEDURE pi-aplica-filtro-prod-fabric:

    IF CAN-FIND(FIRST ttProdutoFabricante) THEN DO:

        FOR EACH ttProdutoFabricante,
            EACH item-fabric NO-LOCK
           WHERE item-fabric.it-fabric = ttProdutoFabricante.PartNumberItemFabricante,
           FIRST fab-for NO-LOCK
           WHERE fab-for.cod-fabric    = item-fabric.cod-fabric:

            IF NOT CAN-FIND(tt-item-fabric-fornec
                            WHERE tt-item-fabric-fornec.cod-fornec = fab-for.cod-fornec 
                              AND tt-item-fabric-fornec.it-codigo  = item-fabric.it-codigo) THEN DO:
                CREATE tt-item-fabric-fornec.
                ASSIGN tt-item-fabric-fornec.cod-fornec = fab-for.cod-fornec
                       tt-item-fabric-fornec.it-codigo  = item-fabric.it-codigo.

            END.
        END.

        IF NOT CAN-FIND (FIRST tt-item-fabric-fornec) THEN DO:
            ASSIGN c-where-ordem = c-where-ordem + " AND ( " + 'FALSE' + ")".
        END. 
        ELSE DO:
            DEFINE VARIABLE l-encontrou-item AS LOGICAL INITIAL FALSE NO-UNDO.
            DEFINE VARIABLE l-encontrou-forn AS LOGICAL INITIAL FALSE NO-UNDO.
    
            FOR EACH tt-item-fabric-fornec:
                IF l-encontrou-item = TRUE THEN
                    ASSIGN c-where-item = c-where-item + " OR ".
                ASSIGN c-where-item = c-where-item + " ordem-compra.it-codigo = '" + STRING(tt-item-fabric-fornec.it-codigo) + "'"
                       l-encontrou-item = TRUE.
    
                IF l-encontrou-forn = TRUE THEN
                     ASSIGN c-where-forn-prod-fabric = c-where-forn-prod-fabric + " OR ".
                ASSIGN c-where-forn-prod-fabric = c-where-forn-prod-fabric + " pedido-compr.cod-emitente = " + STRING(tt-item-fabric-fornec.cod-fornec) + ""
                       l-encontrou-forn = TRUE.
    
            END.
    
            IF TRIM(c-where-item) <> "" THEN
                ASSIGN c-where-ordem = c-where-ordem + " AND ( " + c-where-item + ")".
    
            IF TRIM(c-where-forn-prod-fabric) <> "" THEN DO:
                ASSIGN c-where-pedido = c-where-pedido + " AND ( " + c-where-forn-prod-fabric  + ") ".
            END.        
        END.
    END.

END PROCEDURE.

PROCEDURE pi-aplica-outros-filtros:

    IF CAN-FIND (FIRST FiltroAceite) THEN DO:
        FIND FIRST int-pedido-compr NO-LOCK
             WHERE int-pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

        IF AVAIL int-pedido-compr
             AND NOT CAN-FIND (FIRST FiltroAceite
                               WHERE FiltroAceite.SituacaoAceitePedido = int-pedido-compr.SituacaoAceitePedido) THEN
            RETURN "NOK".
    END.
    
    FIND FIRST ttFiltroData NO-ERROR. 

    IF AVAIL ttFiltroData THEN DO:
    
        CASE ttFiltroData.PesquisaData:
            WHEN 1 THEN DO: /* 1: Data Limite Inspe‡Æo; */ 

                IF NOT CAN-FIND (FIRST ordens-embarque 
                                 WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem
                                   AND ordens-embarque.parcela      = prazo-compra.parcela) THEN 
                    RETURN "NOK".
                
                FOR FIRST ordens-embarque NO-LOCK
                    WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem
                      AND ordens-embarque.parcela      = prazo-compra.parcela:

                    FIND FIRST embarque-imp NO-LOCK
                         WHERE embarque-imp.cod-estabel = ordens-embarque.cod-estabel  
                           AND embarque-imp.embarque    = ordens-embarque.embarque NO-ERROR.
    
                    FOR FIRST historico-embarque
                        WHERE historico-embarque.cod-estabel      = ordens-embarque.cod-estabel
                          AND historico-embarque.embarque         = ordens-embarque.embarque
                          AND historico-embarque.cod-pto-contr    = embarque-imp.cdn-pto-despch:
    
                        IF historico-embarque.dt-efetiva <> ? THEN DO:
                            IF historico-embarque.dt-efetiva - 10 < ttFiltroData.DataInicialPeriodo
                            OR historico-embarque.dt-efetiva - 10 > ttFiltroData.DataFinalPeriodo  THEN 
                                RETURN "NOK".                            
                        END.
                        ELSE DO:
                            IF historico-embarque.dt-ult-previsao - 10 < ttFiltroData.DataInicialPeriodo 
                            OR historico-embarque.dt-ult-previsao - 10 > ttFiltroData.DataFinalPeriodo THEN 
                                RETURN "NOK".
                        END.
                    END.
                END.
                IF NOT AVAIL ordens-embarque
                OR NOT AVAIL historico-embarque THEN
                    RETURN "NOK".
            END.
            WHEN 2 THEN DO:  /* 2 : Data Embarque; */ 

                IF NOT CAN-FIND (FIRST ordens-embarque 
                                 WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem
                                   AND ordens-embarque.parcela      = prazo-compra.parcela) THEN 
                    RETURN "NOK".
    
                FOR FIRST ordens-embarque NO-LOCK
                    WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem
                      AND ordens-embarque.parcela      = prazo-compra.parcela:

                     FOR EACH historico-embarque
                        WHERE historico-embarque.cod-estabel = ordens-embarque.cod-estabel
                          AND historico-embarque.embarque    = ordens-embarque.embarque,
                        FIRST itinerario 
                        WHERE itinerario.cod-itiner   = historico-embarque.cod-itiner
                          AND itinerario.pto-embarque = historico-embarque.cod-pto-contr:
    
                        IF historico-embarque.dt-efetiva <> ? THEN DO:
                            IF historico-embarque.dt-efetiva < ttFiltroData.DataInicialPeriodo
                            OR historico-embarque.dt-efetiva > ttFiltroData.DataFinalPeriodo THEN                        
                                RETURN "NOK".                            
                        END.
                        ELSE DO:
                            IF historico-embarque.dt-ult-previsao < ttFiltroData.DataInicialPeriodo
                            OR historico-embarque.dt-ult-previsao > ttFiltroData.DataFinalPeriodo THEN
                                RETURN "NOK".
                        END.
                    END.
                END.
            END.
            WHEN 3 THEN DO: /* Data do pedido */
    
                IF pedido-compr.data-pedido < ttFiltroData.DataInicialPeriodo 
                OR pedido-compr.data-pedido > ttFiltroData.DataFinalPeriodo THEN DO:
                    RETURN "NOK".
                END.
            END.
            WHEN 4 THEN DO: /* Data de entrega */
    
                IF prazo-compra.data-entrega < ttFiltroData.DataInicialPeriodo  
                OR prazo-compra.data-entrega > ttFiltroData.DataFinalPeriodo THEN DO:
                    RETURN "NOK".
                END.
            END.
            WHEN 5 THEN DO: /* Datas de inspe‡Æo */

                FIND LAST b-historico-inspecao NO-LOCK
                    WHERE b-historico-inspecao.numero-ordem = prazo-compra.numero-ordem
                      AND b-historico-inspecao.parcela      = prazo-compra.parcela NO-ERROR.

                IF NOT AVAIL b-historico-inspecao
                OR b-historico-inspecao.data-prev-inspec = ?
                OR b-historico-inspecao.data-prev-inspec < ttFiltroData.DataInicialPeriodo 
                OR b-historico-inspecao.data-prev-inspec > ttFiltroData.DataFinalPeriodo 
                OR (b-historico-inspecao.data-inspec < ttFiltroData.DataInicialPeriodo AND b-historico-inspecao.data-inspec <> ?)
                OR (b-historico-inspecao.data-inspec > ttFiltroData.DataFinalPeriodo   AND b-historico-inspecao.data-inspec <> ?) THEN DO:

                    RETURN "NOK".
                END.
            END.
            WHEN 6 THEN DO: /* Data de entrega */

                FIND FIRST cotacao-item NO-LOCK
                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                       AND cotacao-item.cod-emitente = pedido-compr.cod-emitente
                       AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.

                FIND FIRST itinerario NO-LOCK
                     WHERE itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.

                FIND FIRST b-ordens-embarque USE-INDEX ordem NO-LOCK
                     WHERE b-ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
                       AND b-ordens-embarque.parcela      = prazo-compra.parcela NO-ERROR.

                FIND FIRST b3-historico-embarque NO-LOCK
                     WHERE b3-historico-embarque.cod-estabel   = pedido-compr.cod-estabel 
                       AND b3-historico-embarque.embarque      = b-ordens-embarque.embarque
                       AND b3-historico-embarque.cod-pto-contr = itinerario.pto-embarque    NO-ERROR.

                IF NOT AVAIL b3-historico-embarque THEN
                    RETURN "NOK".

                IF b3-historico-embarque.dt-efetiva <> ? THEN DO:
                    IF b3-historico-embarque.dt-efetiva < ttFiltroData.DataInicialPeriodo  
                    OR b3-historico-embarque.dt-efetiva > ttFiltroData.DataFinalPeriodo THEN DO:
                        RETURN "NOK".
                    END.
                END.
                ELSE DO:
                    IF b3-historico-embarque.dt-ult-prev < ttFiltroData.DataInicialPeriodo  
                    OR b3-historico-embarque.dt-ult-prev > ttFiltroData.DataFinalPeriodo THEN DO:
                        RETURN "NOK".
                    END.
                END.
            END.
        END CASE.
    END.
    
    IF MSG0239.CodigoInspetor <> ? THEN DO:
        
        /*Se a tabela historico-inspecao est  na query*/
        IF AVAIL historico-inspecao THEN DO:
            /*Considera somente o ultimo status*/
            IF CAN-FIND (FIRST b-historico-inspecao
                         WHERE b-historico-inspecao.numero-ordem      = historico-inspecao.numero-ordem
                           AND b-historico-inspecao.CodigoAgendamento = historico-inspecao.CodigoAgendamento
                           AND b-historico-inspecao.parcel            = historico-inspecao.parcela
                           AND b-historico-inspecao.sequencia         > historico-inspecao.sequencia) THEN
    
                RETURN "NOK".
    
            /*Verifica se o inspetor ‚ diferente*/
            IF MSG0239.CodigoInspetor <> historico-inspecao.cod-inspetor THEN
                 RETURN "NOK".
        END.
        ELSE DO:
            /*Busca o ultimo status*/
            FIND LAST b-historico-inspecao NO-LOCK
                WHERE b-historico-inspecao.numero-ordem = prazo-compra.numero-ordem
                  AND b-historico-inspecao.parcela      = prazo-compra.parcela NO-ERROR.

             /*Verifica se o ultimo status ‚ "pendente"*/
             IF NOT AVAIL b-historico-inspecao
             OR MSG0239.CodigoInspetor <> b-historico-inspecao.cod-inspetor THEN
                 RETURN "NOK".
        END.
    END.
    
    IF MSG0239.NecessitaInspecaoOrigem = YES THEN DO:
        FIND FIRST int-item-fornec-estab NO-LOCK
             WHERE int-item-fornec-estab.it-codigo    = ordem-compra.it-codigo 
               AND int-item-fornec-estab.cod-emitente = pedido-compr.cod-emitente
               AND int-item-fornec-estab.cod-estabel  = pedido-compr.cod-estabel NO-ERROR.

        IF NOT AVAIL int-item-fornec-estab 
        OR NOT int-item-fornec-estab.log-nec-inspec THEN DO:
            RETURN "NOK".
        END.
    END.
    
    IF MSG0239.StatusInspecao <> ? THEN DO:           
        FIND LAST b-historico-inspecao NO-LOCK
            WHERE b-historico-inspecao.numero-ordem = prazo-compra.numero-ordem
              AND b-historico-inspecao.parcela      = prazo-compra.parcela NO-ERROR.

        IF AVAIL b-historico-inspecao THEN DO:
            IF MSG0239.StatusInspecao <> b-historico-inspecao.status-inspec THEN
                RETURN "NOK".
        END.
        ELSE IF MSG0239.StatusInspecao <> 1 /*Agendamento Pendente*/ 
             OR NOT AVAIL int-item-fornec-estab
             OR NOT int-item-fornec-estab.log-nec-inspec THEN DO:
            
            RETURN "NOK".
        END.
    END.
    
    IF MSG0239.CodigoFornecedorEMS <> ? THEN DO:
        IF MSG0239.CodigoFornecedorEMS <> ordem-compra.cod-emitente THEN
            RETURN "NOK".
    END.

    
    IF MSG0239.SomenteInspecoesPendentes THEN DO:

        /*Se a tabela historico-inspecao est  na query*/
        IF AVAIL historico-inspecao THEN DO:

            /*Considera somente o ultimo status*/
            IF CAN-FIND (FIRST b-historico-inspecao
                         WHERE b-historico-inspecao.numero-ordem      = historico-inspecao.numero-ordem
                           AND b-historico-inspecao.CodigoAgendamento = historico-inspecao.CodigoAgendamento
                           AND b-historico-inspecao.parcel            = historico-inspecao.parcela
                           AND b-historico-inspecao.sequencia         > historico-inspecao.sequencia) THEN DO:
    
                RETURN "NOK".
            END.
            
             /*Verifica se o status do historico da query ‚ "pendente"*/
             IF historico-inspecao.status-inspec < 2 
             OR historico-inspecao.status-inspec > 6 THEN
                 RETURN "NOK".
        END.
        ELSE DO:
            /*Busca o ultimo status*/
            FIND LAST b-historico-inspecao NO-LOCK
                WHERE b-historico-inspecao.numero-ordem = prazo-compra.numero-ordem
                  AND b-historico-inspecao.parcela      = prazo-compra.parcela NO-ERROR.

             /*Verifica se o ultimo status ‚ "pendente"*/
             IF NOT AVAIL b-historico-inspecao
             OR b-historico-inspecao.status-inspec < 2 
             OR b-historico-inspecao.status-inspec > 6 THEN
                 RETURN "NOK".
        END.
    END.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

    IF AVAIL ITEM THEN
        RUN pi-busca-criticidade.

    IF MSG0239.NivelCriticidade <> ? THEN DO:
        IF NOT AVAIL int-criticidade-item
        OR (AVAIL int-criticidade-item AND int-criticidade-item.nivel-criticidade <> MSG0239.NivelCriticidade) THEN
            RETURN "NOK". 
    END.

    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-carrega-pedido:

    IF CAN-FIND (FIRST ttPedidos) THEN DO:
        /*Busca pedidos conforme a lista da tag Pedido, ignora demais filtros*/
        FOR EACH ttPedidos:
            CREATE QUERY h-query.
            h-query:SET-BUFFERS(BUFFER pedido-compr:HANDLE, BUFFER ordem-compra:HANDLE, BUFFER prazo-compra:HANDLE).
            ASSIGN c-querys = "FOR EACH pedido-compr NO-LOCK " +
                              "WHERE pedido-compr.num-pedido = " + STRING(ttPedidos.NumeroPedidoCompra) + 
                              ", EACH ordem-compra NO-LOCK
                               WHERE ordem-compra.num-pedido = pedido-compr.num-pedido AND ordem-compra.situacao = 2 
                               , EACH prazo-compra NO-LOCK  
                               WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem AND prazo-compra.situacao = 2 ".
            RUN execute-query.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
    END.
    ELSE IF CAN-FIND (FIRST ttEmbarques) THEN DO:
        /* busca pedidos conforme a lista da tag Embarque */
        FOR EACH ttEmbarques:
            CREATE QUERY h-query.
            h-query:SET-BUFFERS(BUFFER ordens-embarque:HANDLE, BUFFER ordem-compra:HANDLE, BUFFER pedido-compr:HANDLE,BUFFER prazo-compra:HANDLE).
            ASSIGN c-querys = "FOR EACH ordens-embarque NO-LOCK" +
                             " WHERE ordens-embarque.embarque  = '" + STRING(ttEmbarques.NumeroEmbarque) + "'" + 
                             " ,FIRST ordem-compra NO-LOCK" +
                             " WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem  AND ordem-compra.situacao = 2 " +
                             " ,FIRST pedido-compr NO-LOCK " +
                             " WHERE pedido-compr.num-pedido = ordem-compra.num-pedido " +  
                             " ,EACH prazo-compra NO-LOCK" + 
                             " WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem AND prazo-compra.parcela = ordens-embarque.parcela AND prazo-compra.situacao = 2 ".
            RUN execute-query.
        END.
    END.
    ELSE IF msg0239.NumeroOrdemCompra <> ? THEN DO:
        CREATE QUERY h-query.
        h-query:SET-BUFFERS(BUFFER ordem-compra:HANDLE, BUFFER pedido-compr:HANDLE, BUFFER prazo-compra:HANDLE).
        ASSIGN c-querys = "FOR EACH ordem-compra NO-LOCK " +
                          "WHERE ordem-compra.numero-ordem = " + STRING(msg0239.NumeroOrdemCompra) + 
                          ", FIRST pedido-compr NO-LOCK
                           WHERE pedido-compr.num-pedido = ordem-compra.num-pedido AND ordem-compra.situacao = 2 
                           , EACH prazo-compra NO-LOCK  
                           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem AND prazo-compra.situacao = 2 ".
        
        RUN execute-query.
        IF RETURN-VALUE <> "OK" THEN
            RETURN "NOK".
    END.
    ELSE DO:
        RUN pi-aplica-filtro-estabelecimento.
        RUN pi-aplica-filtro-item.
        RUN pi-aplica-filtro-prod-fabric.

        /*Monta query pelos filtros obrigat¢rios*/
        IF MSG0239.MatriculaComprador <> ? THEN DO:
            CREATE QUERY h-query.
            h-query:SET-BUFFERS(BUFFER ordem-compra:HANDLE, BUFFER prazo-compra:HANDLE, BUFFER pedido-compr:HANDLE).
                    ASSIGN c-querys = "FOR EACH ordem-compra NO-LOCK " +
                                      "WHERE ordem-compra.cod-comprado = '" + MSG0239.MatriculaComprador + "' AND ordem-compra.situacao = 2 " + c-where-ordem + 
                                      ", EACH prazo-compra NO-LOCK
                                       WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem AND prazo-compra.situacao = 2
                                       , EACH pedido-compr NO-LOCK
                                       WHERE pedido-compr.num-pedido = ordem-compra.num-pedido " + c-where-pedido.

            RUN execute-query.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
        ELSE IF MSG0239.CodigoFornecedorEMS <> ? THEN DO:
            CREATE QUERY h-query.
            h-query:SET-BUFFERS(BUFFER pedido-compr:HANDLE, BUFFER ordem-compra:HANDLE, BUFFER prazo-compra:HANDLE).
            ASSIGN c-querys = "FOR EACH pedido-compr NO-LOCK " +
                              "WHERE pedido-compr.cod-emitente = " + STRING(MSG0239.CodigoFornecedorEMS) + c-where-pedido +
                              ", EACH ordem-compra NO-LOCK
                               WHERE ordem-compra.num-pedido = pedido-compr.num-pedido AND ordem-compra.situacao = 2 " + c-where-ordem +
                              ", EACH prazo-compra NO-LOCK  
                               WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem AND prazo-compra.situacao = 2 ".
            
            RUN execute-query.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
        ELSE IF MSG0239.CodigoInspetor <> ? THEN DO:
            CREATE QUERY h-query.
            h-query:SET-BUFFERS(BUFFER historico-inspecao:HANDLE, BUFFER prazo-compra:HANDLE, BUFFER ordem-compra:HANDLE, BUFFER pedido-compr:HANDLE).
            ASSIGN c-querys = "FOR EACH historico-inspecao NO-LOCK " +
                              "WHERE historico-inspecao.cod-inspetor = '" + STRING(MSG0239.CodigoInspetor) + "'" +
                              ", EACH prazo-compra NO-LOCK  
                               WHERE prazo-compra.numero-ordem = historico-inspecao.numero-ordem AND prazo-compra.situacao = 2 AND prazo-compra.parcela = historico-inspecao.parcela" +
                              ", EACH ordem-compra NO-LOCK
                               WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem AND ordem-compra.situacao = 2 " + c-where-ordem + 
                              ", EACH pedido-compr NO-LOCK
                               WHERE pedido-compr.num-pedido = ordem-compra.num-pedido " + c-where-pedido.
            
            RUN execute-query.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
        ELSE IF MSG0239.SomenteInspecoesPendentes THEN DO:
            CREATE QUERY h-query.
            h-query:SET-BUFFERS(BUFFER historico-inspecao:HANDLE, BUFFER prazo-compra:HANDLE, BUFFER ordem-compra:HANDLE, BUFFER pedido-compr:HANDLE).
            ASSIGN c-querys = "FOR EACH historico-inspecao NO-LOCK " +
                              "WHERE historico-inspecao.status-inspec >= 2 AND historico-inspecao.status-inspec <= 6"+
                              ", EACH prazo-compra NO-LOCK  
                               WHERE prazo-compra.numero-ordem = historico-inspecao.numero-ordem AND prazo-compra.situacao = 2 AND prazo-compra.parcela = historico-inspecao.parcela" +
                              ", EACH ordem-compra NO-LOCK
                               WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem AND ordem-compra.situacao = 2 " + c-where-ordem + 
                              ", EACH pedido-compr NO-LOCK
                               WHERE pedido-compr.num-pedido = ordem-compra.num-pedido " + c-where-pedido.

            RUN execute-query.
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
    END.

    IF c-querys = "" THEN DO:
        RUN pi-erro (INPUT "NÆo foi poss¡vel executar a consulta com os parƒmentros informados!").
        RETURN "NOK".
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-cria-retorno:
    
    ASSIGN i-id-relac = i-id-relac + 1.
    IF NOT CAN-FIND (FIRST PedidoOrdemCompra
                     WHERE PedidoOrdemCompra.NumeroPedidoCompra = pedido-compr.num-pedido
                       AND PedidoOrdemCompra.NumeroOrdemCompra  = ordem-compra.numero-ordem 
                       AND PedidoOrdemCompra.SequenciaParcela   = prazo-compra.parcela) THEN DO:

        FIND FIRST cotacao-item NO-LOCK
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
               AND cotacao-item.cod-emitente = pedido-compr.cod-emitente
               AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.

        IF  MSG0239.CodigoIncoterm <> ? 
        AND MSG0239.CodigoIncoterm <> SUBSTR(cotacao-item.char-1,21,3) THEN
            RETURN "NOK".

        IF  MSG0239.CodigoItinerario <> ? 
        AND MSG0239.CodigoItinerario <> cotacao-item.int-1 THEN
            RETURN "NOK".

        FIND FIRST b-ordens-embarque USE-INDEX ordem NO-LOCK
             WHERE b-ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
               AND b-ordens-embarque.parcela      = prazo-compra.parcela NO-ERROR.
    
        RELEASE embarque-imp.
        RELEASE b-historico-embarque.
        IF AVAIL b-ordens-embarque THEN DO:
            /*Considera somente parcelas sem embarque, se encontrar ordens-embarque da next*/
            IF MSG0239.SomenteParcelasSoltas THEN
                RETURN "NOK".

            FIND FIRST embarque-imp NO-LOCK
                 WHERE embarque-imp.cod-estabel = b-ordens-embarque.cod-estabel  
                   AND embarque-imp.embarque    = b-ordens-embarque.embarque NO-ERROR.
    
            FIND FIRST b-historico-embarque
                 WHERE b-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch
                   AND b-historico-embarque.cod-estabel   = b-ordens-embarque.cod-estabel
                   AND b-historico-embarque.embarque      = b-ordens-embarque.embarque NO-LOCK NO-ERROR.

        END.

        RUN pi-busca-situacao-embarque.
        FIND FIRST tt-emb NO-ERROR.

        IF msg0239.ApenasStatusPrev THEN DO:
            IF NOT AVAIL tt-emb 
            OR tt-emb.situacao <> 1 THEN
                RETURN "NOK".
        END.

        IF msg0239.SomenteComMovimentacaoPossivel THEN DO:
            IF  AVAIL ordens-embarque 
            AND tt-emb.situacao <> 1  /*Prev*/
            AND tt-emb.situacao <> 96  /*Inst*/
            AND tt-emb.situacao <> 97  /*Manut*/
            AND tt-emb.situacao <> 99 /*Agt*/ 
                THEN DO:
                
                RETURN "NOK".
            END.
            ELSE DO:
                IF AVAIL embarque-imp  THEN DO:
                    FOR EACH invoice-emb-imp OF embarque-imp NO-LOCK:
                        FIND FIRST pagamento-invoice NO-LOCK
                             WHERE pagamento-invoice.embarque   = embarque-imp.embarque
                               AND pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice 
                               AND pagamento-invoice.parcela    = invoice-emb-imp.parcela NO-ERROR.
                    
                        IF AVAIL pagamento-invoice THEN DO:
                            RETURN "NOK".
                        END.
                    END.
                END.
            END.
        END.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-ERROR.
    
        FIND FIRST cond-pagto NO-LOCK
             WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-ERROR.
    
        FIND FIRST int-pedido-compr NO-LOCK
             WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-ERROR.
    
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

        RELEASE int-item-fornec-estab.
        RELEASE item-fornec-estab.
        RELEASE int-item-for-PN.
        RELEASE item-fabric.

        FIND FIRST int-item-for-PN NO-LOCK
            WHERE int-item-for-PN.cod-emitente = pedido-compr.cod-emitente
              AND int-item-for-PN.it-codigo    = ordem-compra.it-codigo NO-ERROR.

        IF AVAIL int-item-for-PN THEN
           FIND FIRST item-fabric USE-INDEX item-fab NO-LOCK
                WHERE item-fabric.it-codigo          = int-item-for-PN.it-codigo
                  AND STRING(item-fabric.cod-fabric) = int-item-for-PN.item-do-forn NO-ERROR.

        IF AVAIL item-fabric THEN
           FIND FIRST item-fornec-estab NO-LOCK
                WHERE item-fornec-estab.it-codigo    = item-fabric.it-codigo
                  AND item-fornec-estab.item-do-forn = STRING(item-fabric.cod-fabric)
                  AND item-fornec-estab.cod-estabel  = pedido-compr.cod-estabel NO-ERROR.

        IF AVAIL item-fornec-estab THEN
           FIND FIRST int-item-fornec-estab OF item-fornec-estab NO-LOCK NO-ERROR.

        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuar = ordem-compra.cod-comprado NO-ERROR.

        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = pedido-compr.end-entrega NO-ERROR.

        FIND FIRST int-analise-ordem-compra NO-LOCK
             WHERE int-analise-ordem-compra.numero-ordem = prazo-compra.numero-ordem
               AND int-analise-ordem-compra.parcela      = prazo-compra.parcela NO-ERROR.

        FIND FIRST unid-negoc NO-LOCK
             WHERE unid-negoc.cod-unid-negoc = ordem-compra.cod-unid-negoc NO-ERROR.

        FIND FIRST int-prazo-compra NO-LOCK
             WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
               AND int-prazo-compra.parcela      = prazo-compra.parcela NO-ERROR.
        
        RUN pi-busca-data-embarque.
        RUN pi-busca-numero-inspecoes.

        FIND FIRST processo-imp USE-INDEX pedido NO-LOCK
             WHERE processo-imp.num-pedido = pedido-compr.num-pedido NO-ERROR.

        FIND FIRST int-processo-imp NO-LOCK
             WHERE int-processo-imp.cod-estabel = processo-imp.cod-estabel
               AND int-processo-imp.nr-proc-imp = processo-imp.nr-proc-imp NO-ERROR.

        CASE pedido-compr.cod-estabel:
            WHEN "101" then assign c-destination  = "SAO JOSE/ SANTA CATARINA/ BRAZIL".
            WHEN "102" then assign c-destination  = "SAO JOSE DOS PINHAIS/ PARANA/ BRAZIL".
            WHEN "103" then assign c-destination  = "SAO JOSE/ SANTA CATARINA/ BRAZIL".
            WHEN "104" then assign c-destination  = "SAO JOSE/ SANTA CATARINA/ BRAZIL".
            WHEN "105" then assign c-destination  = "MANAUS/ AMAZONAS/ BRAZIL".
            OTHERWISE ASSIGN c-destination = "".
        END CASE. 

        RUN calcula-indice (INPUT  prazo-compra.numero-ordem,
                            INPUT  prazo-compra.parcela,     
                            INPUT  ordem-compra.it-codigo,   
                            INPUT  ordem-compra.cod-emitente,
                            OUTPUT de-indice).

        /* montar lista de retorno com as inspe‡äes*/
        ASSIGN l-filtro-inspetor = NO.
        FOR EACH b-historico-inspecao NO-LOCK
            WHERE b-historico-inspecao.numero-ordem = prazo-compra.numero-ordem
              AND b-historico-inspecao.parcela      = prazo-compra.parcela
              BREAK BY b-historico-inspecao.CodigoAgendamento
                    BY b-historico-inspecao.sequencia:

              IF  LAST-OF(b-historico-inspecao.CodigoAgendamento) AND NOT b-historico-inspecao.RegistroRemovido THEN DO:
                    IF (MSG0239.CodigoInspetor <> ? AND b-historico-inspecao.cod-inspetor = MSG0239.CodigoInspetor) 
                    OR (MSG0239.CodigoInspetor = ?) THEN DO:
    
                       CREATE InspecaoAgendada.
                       ASSIGN InspecaoAgendada.id-relac                = i-id-relac
                              InspecaoAgendada.CodigoAgendamento       = b-historico-inspecao.CodigoAgendamento
                              InspecaoAgendada.DataAgendamentoInspecao = b-historico-inspecao.data-prev-inspe    
                              InspecaoAgendada.DuracaoAgendamento      = b-historico-inspecao.duracao-agendamento 
                              InspecaoAgendada.DataExecucaoInspecao    = b-historico-inspecao.data-inspec        
                              InspecaoAgendada.DuracaoExecucao         = b-historico-inspecao.duracao-execucao
                              InspecaoAgendada.StatusInspecao          = b-historico-inspecao.status-inspec         
                              InspecaoAgendada.ObservacoesInspecao     = b-historico-inspecao.obs-inspec      
                              InspecaoAgendada.QuantidadeAgendada      = b-historico-inspecao.qtd-agendada      
                              InspecaoAgendada.QuantidadeInspecionada  = b-historico-inspecao.qtd-inspecionada      
                              InspecaoAgendada.CodigoInspetor          = b-historico-inspecao.cod-inspetor 
                              InspecaoAgendada.NomeInspetor            = b-historico-inspecao.nome-inspetor
                              InspecaoAgendada.RegiaoInspecao          = b-historico-inspecao.regiao-inspec.
                       ASSIGN l-filtro-inspetor = YES.
                    END.
              END.
        END.
        /*
        IF  MSG0239.CodigoInspetor <> ? AND NOT l-filtro-inspetor THEN
            RETURN "NOK".
        */
        CREATE PedidoOrdemCompra.
        ASSIGN PedidoOrdemCompra.NumeroPedidoCompra            = pedido-compr.num-pedido
               PedidoOrdemCompra.DataPedido                    = pedido-compr.data-pedido
               PedidoOrdemCompra.CodigoFornecedorEMS           = pedido-compr.cod-emitente
               PedidoOrdemCompra.NomeAbreviadoFornecedor       = IF AVAIL emitente THEN emitente.nome-abrev ELSE "" 
               PedidoOrdemCompra.CodigoCondicaoPagamento       = pedido-compr.cod-cond-pag
               PedidoOrdemCompra.NomeCondicaoPagamento         = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ""
               PedidoOrdemCompra.CodigoEstabelecimento         = pedido-compr.cod-estabel 
               PedidoOrdemCompra.MatriculaComprador            = ordem-compra.cod-comprado
               PedidoOrdemCompra.NomeComprador                 = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ""
               PedidoOrdemCompra.CodigoTipoPedido              = IF AVAIL int-pedido-compr THEN int-pedido-compr.tp-pedido ELSE 0
               PedidoOrdemCompra.PedidoEmergencial             = pedido-compr.emergencial
               PedidoOrdemCompra.SituacaoAceitePedido          = IF AVAIL int-pedido-compr THEN int-pedido-compr.SituacaoAceitePedido ELSE ?
               PedidoOrdemCompra.NumeroOrdemCompra             = ordem-compra.numero-ordem    
               PedidoOrdemCompra.CodigoProduto                 = ordem-compra.it-codigo   
               PedidoOrdemCompra.PartNumberItemFabricante      = IF AVAIL item-fabric THEN  item-fabric.it-fabric  ELSE ?
               PedidoOrdemCompra.NecessitaLicencaImportacao    = IF AVAIL ITEM THEN ITEM.log-necessita-li ELSE ?
               PedidoOrdemCompra.NecessitaInspecaoOrigem       = IF AVAIL int-item-fornec-estab THEN int-item-fornec-estab.log-nec-inspec ELSE NO 
               PedidoOrdemCompra.ValorUnitarioItem             = ordem-compra.preco-fornec  
               PedidoOrdemCompra.QuantidadeTotalOrdem          = ordem-compra.qt-solic 
               PedidoOrdemCompra.NivelCriticidade              = IF AVAIL int-criticidade-item THEN int-criticidade-item.nivel-criticidade ELSE ?
               PedidoOrdemCompra.SequenciaParcela              = prazo-compra.parcela
               PedidoOrdemCompra.DataParcela                   = prazo-compra.data-entrega 
               PedidoOrdemCompra.QuantidadeParcela             = prazo-compra.quantidade 
               PedidoOrdemCompra.CodigoUnidadeMedida           = prazo-compra.un               
               PedidoOrdemCompra.QuantidadeFornecedor          = prazo-compra.qtd-do-forn      
               PedidoOrdemCompra.CodigoUnidadeMedidaFornecedor = IF AVAIL item-fornec-estab THEN item-fornec-estab.unid-med-for ELSE ?
               PedidoOrdemCompra.SituacaoMovimentoParcela      = IF NOT AVAIL int-analise-ordem-compra OR int-analise-ordem-compra.num-livre-1 = 0 THEN 1 ELSE int-analise-ordem-compra.num-livre-1
               PedidoOrdemCompra.ValorParcela                  = ordem-compra.preco-fornec 
               PedidoOrdemCompra.NumeroEmbarque                = IF AVAIL embarque-imp         THEN embarque-imp.embarque                    ELSE ?
               /*PedidoOrdemCompra.DataInspecaoAgendada        = IF AVAIL b-historico-inspecao THEN b-historico-inspecao.data-prev-inspe     ELSE ?
               PedidoOrdemCompra.DataInspecaoExecutada         = IF AVAIL b-historico-inspecao THEN b-historico-inspecao.data-inspec         ELSE ?
               PedidoOrdemCompra.StatusInspecao                = IF AVAIL b-historico-inspecao THEN b-historico-inspecao.status-inspec       ELSE ?
               PedidoOrdemCompra.DuracaoAgendamento            = IF AVAIL b-historico-inspecao THEN b-historico-inspecao.duracao-agendamento ELSE ? 
               PedidoOrdemCompra.DuracaoExecucao               = IF AVAIL b-historico-inspecao THEN b-historico-inspecao.duracao-execucao    ELSE ? 
               PedidoOrdemCompra.CodigoInspetor                = IF AVAIL b-historico-inspecao THEN b-historico-inspecao.cod-inspetor        ELSE ?
               PedidoOrdemCompra.NomeInspetor                  = IF AVAIL b-historico-inspecao THEN b-historico-inspecao.nome-inspetor       ELSE ?
               PedidoOrdemCompra.RegiaoInspecao                = IF AVAIL b-historico-inspecao THEN b-historico-inspecao.regiao-inspec       ELSE ?*/
               PedidoOrdemCompra.AliquotaIPI                   = IF AVAIL cotacao-item         THEN cotacao-item.aliquota-ipi                ELSE ? 
               PedidoOrdemCompra.ValorUnitarioIPI              = IF AVAIL cotacao-item         THEN cotacao-item.pre-unit-for                ELSE ?
               PedidoOrdemCompra.NCM                           = IF ITEM.ge-codigo = 0 THEN
                                                                     IF AVAIL cotacao-item AND trim(SUBSTRING(cotacao-item.char-1, 81, 10)) <> "" THEN trim(SUBSTRING(cotacao-item.char-1, 81, 10)) ELSE ?
                                                                 ELSE
                                                                     IF AVAIL ITEM AND ITEM.class-fiscal <> "" THEN ITEM.class-fiscal ELSE ?
               PedidoOrdemCompra.DataDespacho                  = IF AVAIL b-historico-embarque THEN 
                                                                     IF b-historico-embarque.dt-efetiva <> ? THEN 
                                                                        b-historico-embarque.dt-efetiva
                                                                     ELSE b-historico-embarque.dt-ult-previsao
                                                                 ELSE ?
              PedidoOrdemCompra.CodigoUnidadeNegocio           = ordem-compra.cod-unid-negoc
              PedidoOrdemCompra.NomeUnidadeNegocio             = IF AVAIL unid-negoc   THEN unid-negoc.des-unid-negoc ELSE ""
              PedidoOrdemCompra.CodigoMoedaEMS                 = IF AVAIL cotacao-item THEN cotacao-item.mo-codigo    ELSE ?
              PedidoOrdemCompra.ConhecimentoEmbarque           = IF AVAIL embarque-imp THEN embarque-imp.cod-conhecto-master ELSE ?
              PedidoOrdemCompra.SituacaoEmbarque               = IF AVAIL tt-emb THEN tt-emb.situacao ELSE ?
              PedidoOrdemCompra.DataEmbarque                   = IF AVAIL b3-historico-embarque 
                                                                    AND b3-historico-embarque.dt-efetiva <> ? THEN 
                                                                        b3-historico-embarque.dt-efetiva 
                                                                    ELSE IF AVAIL b3-historico-embarque THEN
                                                                        b3-historico-embarque.dt-ult-prev
                                                                    ELSE 
                                                                        ?
              PedidoOrdemCompra.QuantidadeSaldo                = prazo-compra.quant-saldo * de-indice
              PedidoOrdemCompra.CodigoViaTransporte            = IF AVAIL embarque-imp     THEN embarque-imp.cod-via-transp  ELSE ?
              PedidoOrdemCompra.NomeDestino                    = IF AVAIL int-processo-imp AND int-processo-imp.NomeDestino <> "" THEN int-processo-imp.NomeDestino ELSE c-destination.

              
          IF msg0239.I18N AND ITEM.desc-inter <> "" THEN
              ASSIGN PedidoOrdemCompra.NomeProduto = ITEM.desc-inter.
          ELSE
              ASSIGN PedidoOrdemCompra.NomeProduto = IF ordem-compra.narrativa = "" THEN (IF AVAIL ITEM THEN TRIM(ITEM.desc-item) ELSE ?) ELSE STRING(ordem-compra.narrativa,"X(60)").

          IF  AVAIL int-item-fornec-estab 
          AND int-item-fornec-estab.log-nec-inspec THEN DO:
         /*     ASSIGN PedidoOrdemCompra.DataLimiteInspecao = IF AVAIL b-historico-embarque THEN 
                                                                IF b-historico-embarque.dt-efetiva <> ? THEN 
                                                                    b-historico-embarque.dt-efetiva - 10 
                                                                ELSE b-historico-embarque.dt-ult-previsao - 10 
                                                            ELSE ?.  
         *******comentado conforme chamado 121600 */
              IF PedidoOrdemCompra.DataEmbarque <> ? THEN
                 ASSIGN PedidoOrdemCompra.DataLimiteInspecao = PedidoOrdemCompra.DataEmbarque - 10.
              ELSE
                 ASSIGN PedidoOrdemCompra.DataLimiteInspecao = IF AVAIL b-historico-embarque THEN 
                                                                   IF b-historico-embarque.dt-efetiva <> ? THEN 
                                                                       b-historico-embarque.dt-efetiva - 10 
                                                                   ELSE b-historico-embarque.dt-ult-previsao - 10 
                                                               ELSE ?.  

          END.
          
          ASSIGN PedidoOrdemCompra.NumeroNotaFiscalPrevista = IF AVAIL int-prazo-compra THEN int-prazo-compra.nro-docto   ELSE ""
                 PedidoOrdemCompra.SerieNotaFiscalPrevista  = IF AVAIL int-prazo-compra THEN int-prazo-compra.serie-docto ELSE ""
                 PedidoOrdemCompra.OrdemInspecao            = i-inspecao
                 PedidoOrdemCompra.CodigoCKD                = IF AVAIL int-pedido-compr AND int-pedido-compr.cod-produto-ckd <> "" THEN int-pedido-compr.cod-produto-ckd ELSE ?
                 PedidoOrdemCompra.QuantidadeCKD            = IF AVAIL int-pedido-compr AND int-pedido-compr.qtd-pedido-ckd  <> 0  THEN int-pedido-compr.qtd-pedido-ckd  ELSE ?
                 PedidoOrdemCompra.id-relac                 = i-id-relac.   
                 /*PedidoOrdemCompra.TipoSDCV = IF AVAIL int-ordem-compra THEN int-ordem-compra.sdc-tipo ELSE "" .muit*/ 


          IF  MSG0239.SomenteInspecoesPendentes 
          AND NOT CAN-FIND(FIRST InspecaoAgendada
                          WHERE InspecaoAgendada.id-relac = i-id-relac) THEN 
              DELETE PedidoOrdemCompra.

          FIND FIRST int-item-uni-estab NO-LOCK
                WHERE int-item-uni-estab.it-codigo    = ordem-compra.it-codigo
                  AND int-item-uni-estab.cod-estabel  = pedido-compr.cod-estabel NO-ERROR.
          IF  AVAIL int-item-uni-estab THEN
              ASSIGN PedidoOrdemCompra.ObservacaoLogistica = int-item-uni-estab.observacao.

/*           FIND FIRST ext-embarque-imp NO-LOCK                                                                             */
/*                WHERE ext-embarque-imp.embarque = embarque-imp.embarque NO-ERROR.                                          */
/*                                                                                                                           */
/*           ASSIGN LogLiberaAlteracaoComex = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.log-libera-alteracao ELSE YES. */

          ASSIGN PedidoOrdemCompra.DataNecessidade = IF AVAIL int-prazo-compra THEN int-prazo-compra.data-necessidade ELSE ?.

          IF AVAIL embarque-imp THEN DO:
             run calcularDiasAcompanhamentoHistEmb in h-bocx230 (input embarque-imp.cod-estabel,
                                                                 input embarque-imp.embarque,  
                                                                 output i-dias-total,
                                                                 output table tt-bo-erro).
             ASSIGN PedidoOrdemCompra.DataEntregaIdeal = IF AVAIL int-prazo-compra THEN int-prazo-compra.data-necessidade - i-dias-total ELSE ?.

          END.
             
              
    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE execute-query:
    
    IF h-query:QUERY-PREPARE(c-querys) THEN DO:

        IF h-query:QUERY-OPEN THEN DO:
        
            REPEAT:
                h-query:GET-NEXT().
                IF h-query:QUERY-OFF-END THEN LEAVE.

                /*Da next nos registros fora da faixa de datas*/
                RUN pi-aplica-outros-filtros.

                IF RETURN-VALUE <> "OK" THEN
                    NEXT.
        
                RUN pi-cria-retorno.
                IF RETURN-VALUE <> "OK" THEN
                    NEXT.
            END.
            
            h-query:QUERY-CLOSE().
        END.
        ELSE DO:
            RUN pi-erro (INPUT "NÆo foi poss¡vel realizar a consulta solicitada").
            RETURN "NOK".
        END.
    END.
    ELSE DO:
        RUN pi-erro (INPUT "NÆo foi poss¡vel realizar a consulta solicitada").  
        RETURN "NOK".
    END.

    DELETE OBJECT h-query.

    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.


PROCEDURE pi-busca-situacao-embarque:

    EMPTY TEMP-TABLE tt-emb.
    FOR EACH b-embarque-imp NO-LOCK
       WHERE b-embarque-imp.cod-estabel = pedido-compr.cod-estabel 
         AND b-embarque-imp.embarque    = b-ordens-embarque.embarque:
                              
        IF b-embarque-imp.situacao    = 1 
        THEN DO:
           {esp/imp/esimp000.i}
        END.
    END.


    RETURN "OK".
END PROCEDURE.


PROCEDURE pi-busca-data-embarque:

    FIND FIRST itinerario NO-LOCK
         WHERE itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.

    FIND FIRST b3-historico-embarque NO-LOCK
         WHERE b3-historico-embarque.cod-estabel   = pedido-compr.cod-estabel 
           AND b3-historico-embarque.embarque      = b-ordens-embarque.embarque
           AND b3-historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.
            
    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-busca-criticidade:
    DEFINE VARIABLE i-cd-plano AS INTEGER   NO-UNDO.

    CASE ordem-compra.cod-estabel:
        WHEN "101" THEN
            ASSIGN i-cd-plano = 1.
        WHEN "104" THEN DO:
            IF ITEM.it-codigo >= "4000000" 
                AND ITEM.it-codigo <= "4999999" THEN
                ASSIGN i-cd-plano = 4.
            ELSE
                ASSIGN i-cd-plano = 41.
        END.
        WHEN "105" THEN
            ASSIGN i-cd-plano = 5.
        WHEN "106" THEN
            ASSIGN i-cd-plano = 6.
        WHEN "107" THEN
            ASSIGN i-cd-plano = 7.
    END CASE.

    FIND LAST int-criticidade-item NO-LOCK 
        WHERE int-criticidade-item.cod-estabel = ordem-compra.cod-estabel
          AND int-criticidade-item.cd-plano    = i-cd-plano
          AND int-criticidade-item.it-codigo   = ordem-compra.it-codigo NO-ERROR.
            
END PROCEDURE.     

PROCEDURE pi-busca-numero-inspecoes:
    DEFINE BUFFER b-historico-inspecao FOR historico-inspecao.

    ASSIGN i-inspecao = 1.

    FOR EACH historico-inspecao NO-LOCK
       WHERE historico-inspecao.numero-ordem = prazo-compra.numero-ordem
         AND historico-inspecao.parcela      = prazo-compra.parcela:
         /* BY historico-inspecao.sequencia: */

        IF historico-inspecao.status-inspec = 8
       AND CAN-FIND (FIRST b-historico-inspecao
                     WHERE b-historico-inspecao.numero-ordem      = prazo-compra.numero-ordem
                       AND b-historico-inspecao.parcela           = prazo-compra.parcela
                       AND b-historico-inspecao.CodigoAgendamento = historico-inspecao.CodigoAgendamento
                       AND b-historico-inspecao.sequencia         > historico-inspecao.sequencia
                       AND b-historico-inspecao.status-inspec     < historico-inspecao.status-inspec) THEN DO:
                                                                
            ASSIGN i-inspecao = i-inspecao + 1.
        END.
    END.

    RETURN "OK".
END PROCEDURE.

PROCEDURE calcula-indice:
    DEFINE INPUT  PARAM p-numero-ordem LIKE ordem-compra.numero-ordem.
    DEFINE INPUT  PARAM p-parcela      LIKE prazo-compra.parcela.
    DEFINE INPUT  PARAM p-it-codigo    LIKE ITEM.it-codigo.
    DEFINE INPUT  PARAM p-cod-emitente LIKE ordem-compra.cod-emitente.
    DEFINE OUTPUT PARAM p-indice       AS DEC.

    DEFINE BUFFER b-prazo-compra FOR prazo-compra.

    FIND FIRST b-prazo-compra NO-LOCK USE-INDEX ordem
         WHERE b-prazo-compra.numero-ordem = p-numero-ordem
           AND b-prazo-compra.parcela      = p-parcela NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    ASSIGN p-indice = 1.

    IF AVAILABLE ITEM THEN DO:
        FIND FIRST item-fornec NO-LOCK
             WHERE item-fornec.it-codigo    = ITEM.it-codigo
               AND item-fornec.cod-emitente = p-cod-emitente NO-ERROR.

        IF  (ITEM.tipo-contr = 4 
        AND NOT AVAILABLE item-fornec 
        OR  ITEM.it-codigo = "":U) THEN DO:

            IF  AVAILABLE cotacao-item            
            AND cotacao-item.un <> b-prazo-compra.un THEN DO:

                FIND FIRST tab-conv-un NO-LOCK
                     WHERE tab-conv-un.un           = b-prazo-compra.un
                       AND tab-conv-un.unid-med-for = cotacao-item.un NO-ERROR.

                IF AVAILABLE tab-conv-un THEN
                    ASSIGN p-indice = tab-conv-un.fator-conver / EXP(10, tab-conv-un.num-casa-dec).
            END.
        END.
        ELSE IF AVAILABLE item-fornec THEN
            ASSIGN p-indice = item-fornec.fator-conver / EXP(10, item-fornec.num-casa-dec).
    END.
END PROCEDURE.
