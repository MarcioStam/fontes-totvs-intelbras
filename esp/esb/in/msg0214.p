CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.                                       */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.                                       */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>104-4-2016-02-29-ga046926</NumeroOperacao>                  */
/*     <CodigoMensagem>MSG0214</CodigoMensagem>                                    */
/*     <LoginUsuario>gi041250</LoginUsuario>                                       */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0214>                                                                   */
/*       <CodigoEstabelecimento>104</CodigoEstabelecimento>                        */
/*       <CodigoPlano>4</CodigoPlano>                                              */
/*       <MatriculaComprador>ga046926</MatriculaComprador>                         */
/*       <DataCalculoCriticidade>2016-02-29</DataCalculoCriticidade>               */
/*     </MSG0214>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0214.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0214, FiltroUnidadeNegocio, FiltroCriticidade
   DATA-RELATION FOR conteudo, MSG0214             RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0214, FiltroUnidadeNegocio RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0214, FiltroCriticidade    RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0214R1, MSG_ListaFalta_R1, MSG_Faltas_R1, resultado
   DATA-RELATION FOR conteudor, MSG0214R1             RELATION-FIELDS (idm, idm)             NESTED
   DATA-RELATION FOR MSG0214R1, MSG_ListaFalta_R1     RELATION-FIELDS (idm, idm)             NESTED
   DATA-RELATION FOR MSG_ListaFalta_R1, MSG_Faltas_R1 RELATION-FIELDS (idm-falta, idm-falta) NESTED
   DATA-RELATION FOR MSG0214R1, resultado             RELATION-FIELDS (idm, idm)             NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

DEFINE BUFFER b-int-criticidade-item FOR int-criticidade-item.
DEFINE BUFFER b-historico-embarque   FOR historico-embarque.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0214R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0214 NO-ERROR.

CREATE conteudor.
CREATE MSG0214R1.
CREATE resultado.

RUN pi-busca-falta.


IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.



PROCEDURE pi-busca-falta:

    IF MSG0214.CodigoProdutoInicial = "?" THEN
        ASSIGN c-produto-inicial = "".
    ELSE
        ASSIGN c-produto-inicial = MSG0214.CodigoProdutoInicial.

    IF MSG0214.CodigoProdutoFinal = "?" OR MSG0214.CodigoProdutoFinal = "" THEN
        ASSIGN c-produto-final   = "ZZZZZZZZZZZZZZZZ".
    ELSE 
        ASSIGN c-produto-final = MSG0214.CodigoProdutoFinal.


    ASSIGN i-ident-falta = 0.

    FOR EACH int-criticidade-item NO-LOCK
       WHERE int-criticidade-item.cod-estabel   = MSG0214.CodigoEstabelecimento
         AND int-criticidade-item.cd-plano      = MSG0214.CodigoPlano          
         AND int-criticidade-item.it-codigo    >= c-produto-inicial        
         AND int-criticidade-item.it-codigo    <= c-produto-final
         AND int-criticidade-item.data-calculo  = MSG0214.DataCalculoCriticidade,
       FIRST ITEM NO-LOCK 
           WHERE ITEM.it-codigo = int-criticidade-item.it-codigo
       BREAK BY int-criticidade-item.sequencia:

        /*Considera somente o £ltimo c lculo do dia*/
        IF CAN-FIND (FIRST b-int-criticidade-item
                     WHERE b-int-criticidade-item.cod-estabel  = int-criticidade-item.cod-estabel
                       AND b-int-criticidade-item.cd-plano     = int-criticidade-item.cd-plano
                       AND b-int-criticidade-item.it-codig     = int-criticidade-item.it-codig
                       AND b-int-criticidade-item.data-calculo = int-criticidade-item.data-calculo
                       AND b-int-criticidade-item.sequencia    > int-criticidade-item.sequencia) THEN
            NEXT.
        
        IF CAN-FIND(FIRST FiltroUnidadeNegocio 
                    WHERE FiltroUnidadeNegocio.CodigoUnidadeNegocio > "")
        AND NOT CAN-FIND(FIRST FiltroUnidadeNegocio 
                         WHERE FiltroUnidadeNegocio.CodigoUnidadeNegocio = ITEM.cod-unid-negoc ) THEN
            NEXT.

        IF CAN-FIND(FIRST FiltroCriticidade 
                    WHERE FiltroCriticidade.NivelCriticidade > -1 ) 
        AND NOT CAN-FIND(FIRST FiltroCriticidade 
                         WHERE FiltroCriticidade.NivelCriticidade = int-criticidade-item.nivel-criticidade ) THEN   
            NEXT.
        
        /* Obter Fornecedor padrao do item */
        FIND FIRST item-fornec-estab NO-LOCK      
             WHERE item-fornec-estab.it-codigo    = ITEM.it-codigo
               AND item-fornec-estab.cod-estabel  = int-criticidade-item.cod-estabel
               AND item-fornec-estab.ativo        = YES
               AND item-fornec-estab.perc-compra  > 0 NO-ERROR.

        IF NOT AVAIL item-fornec-estab THEN
            NEXT.
        
        FIND FIRST emitente NO-LOCK 
             WHERE emitente.cod-emitente = item-fornec-estab.cod-emitente NO-ERROR.

        FIND FIRST item-uni-estab NO-LOCK 
             WHERE item-uni-estab.cod-estabel = int-criticidade-item.cod-estabel
               AND item-uni-estab.it-codigo   = int-criticidade-item.it-codigo NO-ERROR.
                  
        IF  AVAIL item-uni-estab 
        AND item-uni-estab.cod-comprado <> "" THEN
            ASSIGN c-comprador = trim(item-uni-estab.cod-comprado).
        ELSE
            ASSIGN c-comprador = trim(ITEM.cod-comprado).
                            
        /* Demais Filtros */
        IF  MSG0214.MatriculaComprador > "" 
        AND MSG0214.MatriculaComprador <> c-comprador THEN
             NEXT.

        FIND FIRST usuar_mestre NO-LOCK 
             WHERE usuar_mestre.cod_usuar = c-comprador NO-ERROR.

        FIND FIRST unid-negoc NO-LOCK 
             WHERE unid-negoc.cod-unid-negoc = ITEM.cod-unid-negoc NO-ERROR.

        IF AVAIL item-uni-estab THEN
            FIND FIRST tipo-rec-desp NO-LOCK 
                 WHERE tipo-rec-desp.tp-codigo = item-uni-estab.tp-desp-padrao NO-ERROR.

        /*Busca a £ltima a‡Æo do usu rio "NOT acao-sistema"*/
        FIND LAST int-acao-criticidade-item NO-LOCK
            WHERE int-acao-criticidade-item.cod-estabel     = int-criticidade-item.cod-estabel 
              AND int-acao-criticidade-item.cd-plano        = int-criticidade-item.cd-plano    
              AND int-acao-criticidade-item.it-codigo       = int-criticidade-item.it-codigo 
              AND NOT int-acao-criticidade-item.acao-sistema NO-ERROR.  
        
        ASSIGN r-prox-prazo-compra           = ?
               r-embarque-historico-embarque = ?.

        /*Pr¢xima chegada*/
        RUN pi-proxima-chegada (INPUT  ITEM.it-codigo,            
                                INPUT  item-uni-estab.res-for-comp,  
                                INPUT  item-uni-estab.tp-desp-padrao, 
                                INPUT  int-criticidade-item.cod-estabel,
                                INPUT  int-criticidade-item.cd-plano,
                                OUTPUT r-prox-prazo-compra,         
                                OUTPUT r-embarque-historico-embarque,   
                                OUTPUT l-tem-entrega-prevista).

        /*Pr¢xima entrega*/
        FIND FIRST prazo-compra NO-LOCK
             WHERE ROWID(prazo-compra) = r-prox-prazo-compra NO-ERROR.

        FIND FIRST ordem-compra NO-LOCK
             WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-ERROR.

        /*Embarque da pr¢xima entrega*/
        FIND FIRST historico-embarque NO-LOCK
             WHERE ROWID(historico-embarque) = r-embarque-historico-embarque NO-ERROR.

        /*éltimo ponto de controle efetivado para pr¢xima entrega*/
        RELEASE b-historico-embarque.
        RELEASE pto-contr.
        IF AVAIL historico-embarque THEN DO:
            FIND LAST b-historico-embarque NO-LOCK
                WHERE b-historico-embarque.cod-estabel = historico-embarque.cod-estabel
                  AND b-historico-embarque.embarque    = historico-embarque.embarque 
                  AND b-historico-embarque.dt-efetiva <> ? NO-ERROR.

            FIND FIRST pto-contr NO-LOCK
                 WHERE pto-contr.cod-pto-contr = b-historico-embarque.cod-pto-contr NO-ERROR.
        END.
        
        ASSIGN i-ident-falta = i-ident-falta + 1.

        CREATE MSG_ListaFalta_R1.
        ASSIGN MSG_ListaFalta_R1.CodigoEstabelecimento       = int-criticidade-item.cod-estabel    
               MSG_ListaFalta_R1.CodigoPlano                 = int-criticidade-item.cd-plano       
               MSG_ListaFalta_R1.DataCalculoCriticidade      = int-criticidade-item.data-calculo   
               MSG_ListaFalta_R1.SequenciaCalculoCriticidade = int-criticidade-item.sequencia      
               MSG_ListaFalta_R1.MatriculaComprador          = c-comprador
               MSG_ListaFalta_R1.NomeComprador               = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ?
               MSG_ListaFalta_R1.CodigoUnidadeNegocio        = ITEM.cod-unid-negoc
               MSG_ListaFalta_R1.NomeUnidadeNegocio          = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE ?
               MSG_ListaFalta_R1.CodigoFornecedorEMS         = IF AVAIL item-fornec-estab THEN item-fornec-estab.cod-emitente ELSE ?
               MSG_ListaFalta_R1.NomeAbreviadoFornecedor     = IF AVAIL emitente THEN emitente.nome-abrev ELSE ?
               MSG_ListaFalta_R1.CodigoProduto               = int-criticidade-item.it-codigo      
               MSG_ListaFalta_R1.NomeProduto                 = IF msg0214.I18N AND ITEM.desc-inter <> "" THEN ITEM.desc-inter ELSE ITEM.desc-item 
               MSG_ListaFalta_R1.DataPrevisaoChegada         = IF AVAIL prazo-compra THEN prazo-compra.data-entrega ELSE ?
               MSG_ListaFalta_R1.QuantidadeChegada           = IF AVAIL prazo-compra THEN prazo-compra.quantidade ELSE ?
               MSG_ListaFalta_R1.NumeroEmbarque              = IF AVAIL historico-embarque THEN historico-embarque.embarque ELSE ?
               MSG_ListaFalta_R1.CodigoPontoControle         = IF AVAIL b-historico-embarque THEN b-historico-embarque.cod-pto-contr ELSE ?
               MSG_ListaFalta_R1.DescricaoPontoControle      = IF AVAIL pto-contr THEN pto-contr.descricao ELSE ?
               MSG_ListaFalta_R1.DataPontoControle           = IF AVAIL b-historico-embarque THEN b-historico-embarque.dt-efetiva ELSE ?
               MSG_ListaFalta_R1.NivelCriticidade            = int-criticidade-item.nivel-criticidade
               MSG_ListaFalta_R1.CodigoTipoDespesa           = IF AVAIL item-uni-estab AND item-uni-estab.tp-desp-padrao > 0 THEN 
                                                                   item-uni-estab.tp-desp-padrao 
                                                               ELSE 
                                                                   IF item.tp-desp-padrao > 0 THEN 
                                                                      item.tp-desp-padrao 
                                                                   ELSE ?
               MSG_ListaFalta_R1.DescricaoTipoDespesa        = IF AVAIL tipo-rec-desp THEN tipo-rec-desp.descricao ELSE ?
               MSG_ListaFalta_R1.AcaoAnterior                = IF AVAIL int-acao-criticidade-item THEN STRING(int-acao-criticidade-item.data-acao) + " - " + int-acao-criticidade-item.comentario-acao ELSE ?
               MSG_ListaFalta_R1.DataPrimeiraFalta           = int-criticidade-item.dt-primeira-falta
               MSG_ListaFalta_R1.QuantidadeFinalFalta        = int-criticidade-item.de-ultima-quantidade
               MSG_ListaFalta_R1.idm-falta                   = i-ident-falta
               MSG_ListaFalta_R1.SituacaoItemEMS             = IF item-uni-estab.cod-obsoleto <> 0 THEN item-uni-estab.cod-obsoleto ELSE 4
               MSG_ListaFalta_R1.NumeroPedidoCompra          = IF AVAIL ordem-compra THEN ordem-compra.num-pedido ELSE ?.

        FOR EACH int-falta-criticidade-item NO-LOCK
           WHERE int-falta-criticidade-item.cod-estabel  = int-criticidade-item.cod-estabel        
             AND int-falta-criticidade-item.cd-plano     = int-criticidade-item.cd-plano           
             AND int-falta-criticidade-item.it-codigo    = int-criticidade-item.it-codigo          
             AND int-falta-criticidade-item.data-calculo = int-criticidade-item.data-calculo       
             AND int-falta-criticidade-item.sequencia    = int-criticidade-item.sequencia:

            CREATE MSG_Faltas_R1.
            ASSIGN MSG_Faltas_R1.DataFalta       = int-falta-criticidade-item.data-falta
                   MSG_Faltas_R1.QuantidadeFalta = int-falta-criticidade-item.quantidade-falta
                   MSG_Faltas_R1.idm-falta       = i-ident-falta.
        END.
        
    END. /* FOR EACH int-criticidade-item */
   
    RETURN "OK":U.

END PROCEDURE.

/*pi-proxima-chegada*/
{esp/cep/escep082a.i}
