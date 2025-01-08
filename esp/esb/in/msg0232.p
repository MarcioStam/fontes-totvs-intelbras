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
/*     <NumeroOperacao>MSG0232</NumeroOperacao>                                    */
/*     <CodigoMensagem>MSG0232</CodigoMensagem>                                    */
/*     <LoginUsuario>ToolSystems</LoginUsuario>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*      <MSG0232>                                                                  */
/*           <CodigoFornecedorEMS>196273</CodigoFornecedorEMS>                     */
/*           <CodigoProdutoInicial></CodigoProdutoInicial>                         */
/*           <CodigoProdutoFinal>ZZZZZZZZZZZZZZZZ</CodigoProdutoFinal>             */
/*           <SomenteAnalisadas>NO</SomenteAnalisadas>                             */
/*           <FiltroDemandaDependente>YES</FiltroDemandaDependente>                */
/*           <FiltroDemandaIndependente>YES</FiltroDemandaIndependente>            */
/*           <ExibirCotadas>YES</ExibirCotadas>                                    */
/*           <ExibirEmCotacao>NO</ExibirEmCotacao>                                 */
/*           <ExibirNaoConfirmadas>NO</ExibirNaoConfirmadas>                       */
/*      </MSG0232>                                                                 */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */
/*                                                                                 */

/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>MSG0232</NumeroOperacao>                                    */
/*     <CodigoMensagem>MSG0232</CodigoMensagem>                                    */
/*     <LoginUsuario>ToolSystems</LoginUsuario>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*      <MSG0232>                                                                  */
/*           <MatriculaComprador></MatriculaComprador>                             */
/*           <CodigoFornecedorEMS>4533</CodigoFornecedorEMS>                       */
/*           <SomenteAnalisadas></SomenteAnalisadas>                               */
/*           <CodigoProdutoInicial></CodigoProdutoInicial>                         */
/*           <CodigoProdutoFinal></CodigoProdutoFinal>                             */
/*           <FiltroDemandaDependente></FiltroDemandaDependente>                   */
/*           <FiltroDemandaIndependente></FiltroDemandaIndependente>               */
/*           <ExibirCotadas></ExibirCotadas>                                       */
/*           <ExibirEmCotacao></ExibirEmCotacao>                                   */
/*           <ExibirNaoConfirmadas></ExibirNaoConfirmadas>                         */
/*      </MSG0232>                                                                 */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */
/*                                                                                 */

{esp/esb/in/msg0232.i}
{esp/es0018.i}
{esp/esb/esesb000fn1.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0232, FiltroEstabelecimento 
   DATA-RELATION FOR conteudo, MSG0232              RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0232, FiltroEstabelecimento RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0232_R1, MSG_OrdemCompra_R1, MSG_ParcelaOrdemCompra_R1, resultado
   DATA-RELATION FOR conteudor, MSG0232_R1                         RELATION-FIELDS (idm, idm)                             NESTED
   DATA-RELATION FOR MSG0232_R1, MSG_OrdemCompra_R1                RELATION-FIELDS (idm, idm)                             NESTED
   DATA-RELATION FOR MSG_OrdemCompra_R1, MSG_ParcelaOrdemCompra_R1 RELATION-FIELDS (NumeroOrdemCompra, NumeroOrdemCompra) NESTED
   DATA-RELATION FOR MSG0232_R1, resultado                         RELATION-FIELDS (idm, idm)                             NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0232R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0232 NO-ERROR.

CREATE conteudor.
CREATE MSG0232_R1.
CREATE resultado.

RUN pi-gera-ordens.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* DEFINE VARIABLE hDoc AS HANDLE   NO-UNDO.                                                    */
/* CREATE X-DOCUMENT hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + REPLACE(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-gera-ordens:
             
    ASSIGN MSG0232_R1.ExibePrecos = fnExibePrecos(MSG0232.MatriculaUsuario).
    
    blk_ordem:
    FOR EACH ordem-compra NO-LOCK
       WHERE ordem-compra.num-pedido   = 0
         AND ordem-compra.cod-comprado = MSG0232.MatriculaComprador  
         AND ordem-compra.it-codigo   >= MSG0232.CodigoProdutoInicial
         AND ordem-compra.it-codigo   <= MSG0232.CodigoProdutoFinal:

        /*Filtro fornecedor*/
        IF MSG0232.CodigoFornecedorEMS <> ? THEN DO:
            IF ordem-compra.situacao = 5 /*Em cota‡Æo*/ THEN DO:

                /*Considera fornecedor da primeira cota‡Æo parametrizado no cc0531 (data <> 11/11/1111)*/
                FIND FIRST cotacao-item NO-LOCK 
                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                       AND cotacao-item.data-cotacao <> 11/11/1111 NO-ERROR.

                IF  AVAIL cotacao-item
                AND cotacao-item.cod-emitente <> MSG0232.CodigoFornecedorEMS THEN
                    NEXT blk_ordem. 
    
            END.
            ELSE DO:
                IF ordem-compra.cod-emitente <> MSG0232.CodigoFornecedorEMS THEN
                    NEXT blk_ordem. 
            END.
        END.
        
        /*Filtro por estabelecimento*/
        IF CAN-FIND (FIRST FiltroEstabelecimento) THEN DO:
            IF NOT CAN-FIND (FIRST FiltroEstabelecimento
                             WHERE FiltroEstabelecimento.CodigoEstabelecimento = ordem-compra.cod-estabel) THEN DO:

                NEXT blk_ordem.
            END.
        END.

        /*Mostra somente ordens com todas as parcelas analisadas*/
        IF MSG0232.SomenteAnalisadas THEN DO:
            FOR EACH prazo-compra OF ordem-compra NO-LOCK:
                IF NOT CAN-FIND (FIRST int-analise-ordem-compra 
                                 WHERE int-analise-ordem-compra.numero-ordem = prazo-compra.numero-ordem 
                                   AND int-analise-ordem-compra.parcela      = prazo-compra.parcela
                                   AND int-analise-ordem-compra.log-analisada) THEN
                    NEXT blk_ordem.
            END.
        END.

        /*Filtro por situa‡Æo*/
        IF (NOT MSG0232.ExibirCotadas
        AND ordem-compra.situacao = 3)
        OR (NOT MSG0232.ExibirEmCotacao
        AND ordem-compra.situacao = 5)
        OR (NOT MSG0232.ExibirNaoConfirmadas
        AND ordem-compra.situacao = 1)
        OR (ordem-compra.situacao = 2 OR ordem-compra.situacao = 4 OR ordem-compra.situacao = 6) THEN
            NEXT blk_ordem.
        
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-ERROR.

        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuar = ordem-compra.cod-comprado NO-ERROR.        

        FIND FIRST item-fornec-estab NO-LOCK
             WHERE item-fornec-estab.cod-emitente = ordem-compra.cod-emitente
               AND item-fornec-estab.it-codigo    = ordem-compra.it-codigo
               AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-ERROR.

        FIND FIRST item-uni-estab NO-LOCK
             WHERE item-uni-estab.it-codigo   = ordem-compra.it-codigo
               AND item-uni-estab.cod-estabel = ordem-compra.cod-estabel NO-ERROR.

        FIND FIRST int-item-uni-estab no-lock
             WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel 
               AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo no-error.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

        /*Filtro Demanda*/
        IF  (NOT MSG0232.FiltroDemandaDependente 
        AND item-uni-estab.demanda = 1)
        OR  (NOT MSG0232.FiltroDemandaIndependente 
        AND item-uni-estab.demanda = 2) THEN
            NEXT blk_ordem.
          
        CREATE MSG_OrdemCompra_R1.
        ASSIGN MSG_OrdemCompra_R1.CodigoProduto                = ordem-compra.it-codigo            
               MSG_OrdemCompra_R1.NomeProduto                  = IF msg0232.I18N AND ITEM.desc-inter <> "" THEN TRIM(ITEM.desc-inter) ELSE  TRIM(ITEM.desc-item)
               MSG_OrdemCompra_R1.CodigoEstabelecimento        = ordem-compra.cod-estabel          
               MSG_OrdemCompra_R1.NomeEstabelecimento          = IF AVAIL estabelec         THEN estabelec.nome                 ELSE ?
               MSG_OrdemCompra_R1.MatriculaComprador           = ordem-compra.cod-comprado         
               MSG_OrdemCompra_R1.NomeComprador                = IF AVAIL usuar_mestre      THEN usuar_mestre.nom_usuario       ELSE ?
               MSG_OrdemCompra_R1.NumeroOrdemCompra            = ordem-compra.numero-ordem         
               MSG_OrdemCompra_R1.SituacaoOrdemCompra          = ordem-compra.situacao             
               MSG_OrdemCompra_R1.LoteMultiploItemFornecedor   = IF AVAIL item-fornec-estab THEN item-fornec-estab.lote-mul-for ELSE ?
               MSG_OrdemCompra_R1.LoteMinimoItemFornecedor     = IF AVAIL item-fornec-estab THEN item-fornec-estab.lote-minimo  ELSE ?   
               MSG_OrdemCompra_R1.UnidadeFornecedor            = IF AVAIL item-fornec-estab THEN item-fornec-estab.unid-med-for ELSE ?   
               MSG_OrdemCompra_R1.TempoRessuprimentoFornecedor = IF AVAIL item-uni-estab    THEN item-uni-estab.res-for-comp    ELSE ?.      

        IF ordem-compra.situacao = 5 /*Em cota‡Æo*/ THEN DO:
            /*Busca primeira cota‡Æo com fornecedor parametrizado no cc0531 (data <> 11/11/1111)*/
            FIND FIRST cotacao-item NO-LOCK 
                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                   AND cotacao-item.data-cotacao <> 11/11/1111 NO-ERROR.

            IF AVAIL cotacao-item THEN DO:
                FIND FIRST emitente NO-LOCK
                     WHERE emitente.cod-emitente = cotacao-item.cod-emitente NO-ERROR.

                ASSIGN MSG_OrdemCompra_R1.CodigoFornecedorEMS     = cotacao-item.cod-emitente
                       MSG_OrdemCompra_R1.NomeAbreviadoFornecedor = IF AVAIL emitente THEN emitente.nome-abrev ELSE ?
                       MSG_OrdemCompra_R1.OrigemFornecedor        = IF  AVAIL emitente 
                                                                    AND emitente.natureza = 3  THEN "I"        ELSE "N"
                       MSG_OrdemCompra_R1.ValorUnitarioItem       = cotacao-item.pre-unit.
            END.
            ELSE DO:
                ASSIGN MSG_OrdemCompra_R1.CodigoFornecedorEMS     = ordem-compra.cod-emitente
                       MSG_OrdemCompra_R1.NomeAbreviadoFornecedor = IF AVAIL emitente THEN emitente.nome-abrev ELSE ?
                       MSG_OrdemCompra_R1.OrigemFornecedor        = IF  AVAIL emitente 
                                                                    AND emitente.natureza = 3  THEN "I"        ELSE "N"
                        MSG_OrdemCompra_R1.ValorUnitarioItem      = ordem-compra.pre-unit-for.
            END.
        END.
        ELSE DO:
            ASSIGN MSG_OrdemCompra_R1.CodigoFornecedorEMS     = ordem-compra.cod-emitente
                   MSG_OrdemCompra_R1.NomeAbreviadoFornecedor = IF AVAIL emitente THEN emitente.nome-abrev ELSE ?
                   MSG_OrdemCompra_R1.OrigemFornecedor        = IF  AVAIL emitente 
                                                                AND emitente.natureza = 3  THEN "I"        ELSE "N"
                   MSG_OrdemCompra_R1.ValorUnitarioItem       = ordem-compra.pre-unit-for.         
        END.

        FOR EACH prazo-compra OF ordem-compra NO-LOCK:

            FIND FIRST int-analise-ordem-compra NO-LOCK
                 WHERE int-analise-ordem-compra.numero-ordem = prazo-compra.numero-ordem 
                   AND int-analise-ordem-compra.parcela      = prazo-compra.parcela NO-ERROR.

            FIND FIRST int-prazo-compra
                 WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                   AND int-prazo-compra.parcela      = prazo-compra.parcela NO-LOCK NO-ERROR.

            CREATE MSG_ParcelaOrdemCompra_R1.
            ASSIGN MSG_ParcelaOrdemCompra_R1.NumeroOrdemCompra = prazo-compra.numero-ordem
                   MSG_ParcelaOrdemCompra_R1.SequenciaParcela  = prazo-compra.parcela     
                   MSG_ParcelaOrdemCompra_R1.DataParcela       = prazo-compra.data-entrega
                   MSG_ParcelaOrdemCompra_R1.QuantidadeParcela = prazo-compra.quantidade  
                   MSG_ParcelaOrdemCompra_R1.Analisada         = IF AVAIL int-analise-ordem-compra THEN int-analise-ordem-compra.log-analisada ELSE NO
                   MSG_ParcelaOrdemCompra_R1.DataNecessidade   = IF AVAIL int-prazo-compra THEN int-prazo-compra.data-necessidade ELSE ?
                   MSG_ParcelaOrdemCompra_R1.RequerAvaliacao   = IF AVAIL int-item-uni-estab THEN int-item-uni-estab.log-requer-aval ELSE NO.

        END.
    END.

    RETURN "OK".
END PROCEDURE.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.

