CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.                                       */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.                                       */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='utf-16'?>                          */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>161953-104</NumeroOperacao>                                 */
/*     <CodigoMensagem>MSG0253</CodigoMensagem>                                    */
/*     <LoginUsuario>supero.tiago</LoginUsuario>                                   */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0253>                                                                   */
/*       <CodigoFornecedorEMS>161953</CodigoFornecedorEMS>                         */
/*       <CodigoEstabelecimento>104</CodigoEstabelecimento>                        */
/*       <CodigoSolicitacaoInterna>22880</CodigoSolicitacaoInterna>                */
/*     </MSG0253>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */
    
{esp/esb/in/msg0253.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0253, FiltroStatusSolicitacaoInterna, FiltroData
   DATA-RELATION FOR conteudo, msg0253                       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0253, FiltroStatusSolicitacaoInterna RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0253, FiltroData                     RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0253R1, SolicitacaoInternaPagamentoItens, SolicitacaoInternaPagamentoItem, Fatura, resultado
   DATA-RELATION FOR conteudor, msg0253R1                                              RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0253R1, SolicitacaoInternaPagamentoItens                       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR SolicitacaoInternaPagamentoItens, SolicitacaoInternaPagamentoItem RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR SolicitacaoInternaPagamentoItem, Fatura                           RELATION-FIELDS (CodigoSolicitacaoInterna, CodigoSolicitacaoInterna) NESTED
   DATA-RELATION FOR msg0253R1, resultado                                              RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

DEFINE BUFFER b-int-criticidade-item FOR int-criticidade-item.
DEFINE BUFFER b-historico-embarque   FOR historico-embarque.
DEFINE BUFFER b-emitente FOR emitente.
DEFINE BUFFER b_usuar_mestre FOR usuar_mestre.
DEFINE BUFFER b3-historico-embarque FOR historico-embarque. /*Ponto de Chegada*/

DEF VAR c-cod-unid-negoc  AS CHAR NO-UNDO.
DEF VAR c-desc-unid-negoc AS CHAR NO-UNDO.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0253R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0253 NO-ERROR.

CREATE conteudor.
CREATE msg0253R1.
CREATE resultado.

RUN pi-busca-pagamento.

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

define variable hDoc    as handle   no-undo.
create x-document hDoc.
hDoc:LOAD("longchar", oXML, NO).
hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").

RETURN.

PROCEDURE pi-busca-pagamento:

    IF msg0253.CodigoSolicitacaoInterna <> ? THEN DO:
        FOR EACH pagamento NO-LOCK
           WHERE pagamento.nr-pagamento = msg0253.CodigoSolicitacaoInterna:

            RUN pi-filtros.
            IF RETURN-VALUE <> "OK" THEN
                NEXT.
            
            RUN pi-cria-retorno.

        END.
    END.
    ELSE DO:
        IF msg0253.CodigoFornecedorEMS <> ? THEN DO:
            FOR EACH pagamento NO-LOCK
               WHERE pagamento.cod-emitente = msg0253.CodigoFornecedorEMS:

                RUN pi-filtros.
                IF RETURN-VALUE <> "OK" THEN
                    NEXT.

                RUN pi-cria-retorno.

            END.
        END.
/*         ELSE IF msg0253.CodigoSwift <> ? THEN DO:            */
/*             FOR EACH pagamento NO-LOCK                       */
/*                WHERE pagamento.swift = msg0253.CodigoSwift:  */
/*                                                              */
/*                 RUN pi-filtros.                              */
/*                 IF RETURN-VALUE <> "OK" THEN                 */
/*                     NEXT.                                    */
/*                                                              */
/*                 RUN pi-cria-retorno.                         */
/*             END.                                             */
/*         END.                                                 */
        ELSE DO:
            FOR EACH pagamento NO-LOCK:

                RUN pi-filtros.
                IF RETURN-VALUE <> "OK" THEN
                    NEXT.

                RUN pi-cria-retorno.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-filtros:


    IF msg0253.CodigoDespachante <> ? THEN DO:
        IF msg0253.CodigoDespachante <> pagamento.cod-despachante THEN
            RETURN "NOK".
    END.

    /*CI's anteriores a essa data nao tem condiá∆o de pagamento*/
    IF pagamento.data-ci < 01/01/2011 THEN
        RETURN "NOK".

    IF msg0253.CodigoFornecedorEMS <> ? THEN DO:
        IF msg0253.CodigoFornecedorEMS <> pagamento.cod-emitente THEN
            RETURN "NOK".
    END.
    
    IF msg0253.CodigoEstabelecimento <> ? THEN DO:
        IF msg0253.CodigoEstabelecimento <> pagamento.cod-estabel THEN
            RETURN "NOK".
    END.
    
    IF msg0253.MatriculaResponsavel <> ? THEN DO:
        IF msg0253.MatriculaResponsavel <> pagamento.usuario THEN
            RETURN "NOK".
    END.
    
    IF msg0253.CodigoSolicitacaoInterna <> ? THEN DO:
        IF msg0253.CodigoSolicitacaoInterna <> pagamento.nr-pagamento THEN
            RETURN "NOK".
    END.

    IF msg0253.CodigoCondicaoPagamento <> ? THEN DO:
        IF msg0253.CodigoCondicaoPagamento <> pagamento.cod-cond-pag THEN
            RETURN "NOK".
    END.

    /*
    IF msg0253.CodigoSwift <> ? THEN DO:
        IF msg0253.CodigoSwift <> pagamento.swift THEN
            RETURN "NOK".
    END.
    */
    IF  msg0253.SomenteSwift AND pagamento.swift  = "" THEN
        RETURN "NOK" .


    IF CAN-FIND (FIRST FiltroStatusSolicitacaoInterna) THEN DO:
        IF NOT CAN-FIND (FIRST FiltroStatusSolicitacaoInterna
                         WHERE FiltroStatusSolicitacaoInterna.StatusSolicitacaoInterna = pagamento.ind-status-solicitacao) THEN 
            RETURN "NOK".
    END.

    IF CAN-FIND (FIRST FiltroData) THEN DO:
        FOR EACH FiltroData:

            /*Emiss∆o*/
            IF  FiltroData.PesquisaDataSolicitacao = 1
            AND (pagamento.data-ci < FiltroData.DataInicialPeriodo OR pagamento.data-ci > FiltroData.DataFinalPeriodo OR pagamento.data-ci = ?) THEN
                RETURN "NOK".

            /*Inclus∆o*/
            IF  FiltroData.PesquisaDataSolicitacao = 2
            AND (pagamento.dat-fft < FiltroData.DataInicialPeriodo OR pagamento.dat-fft > FiltroData.DataFinalPeriodo OR pagamento.dat-fft = ?) THEN
                RETURN "NOK".

            /*Previs∆o Fechamento CÉmbio*/
            IF  FiltroData.PesquisaDataSolicitacao = 3
            AND (pagamento.dt-prev-fecha-cam < FiltroData.DataInicialPeriodo OR pagamento.dt-prev-fecha-cam > FiltroData.DataFinalPeriodo OR pagamento.dt-prev-fecha-cam = ?) THEN
                RETURN "NOK".

            /*Data Aprovaá∆o*/
            IF  FiltroData.PesquisaDataSolicitacao = 4
            AND (pagamento.data-aprovacao < FiltroData.DataInicialPeriodo OR pagamento.data-aprovacao > FiltroData.DataFinalPeriodo OR pagamento.data-aprovacao = ?) THEN
                RETURN "NOK".

            /*Data Swift*/
            IF  FiltroData.PesquisaDataSolicitacao = 5
            AND (pagamento.data-swift < FiltroData.DataInicialPeriodo OR pagamento.data-swift > FiltroData.DataFinalPeriodo OR pagamento.data-swift = ?) THEN
                RETURN "NOK".


        END.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-cria-retorno:

    IF NOT CAN-FIND (FIRST SolicitacaoInternaPagamentoItens) THEN
        CREATE SolicitacaoInternaPagamentoItens.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = pagamento.cod-emitente NO-ERROR.

    FIND FIRST b-emitente NO-LOCK
         WHERE b-emitente.cod-emitente = pagamento.cod-despachante NO-ERROR.

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuar = pagamento.usuario NO-ERROR.

    FIND FIRST b_usuar_mestre NO-LOCK
         WHERE b_usuar_mestre.cod_usuar = pagamento.cod-comprador NO-ERROR.

    FIND FIRST cond-pagto NO-LOCK
         WHERE cond-pagto.cod-cond-pag = pagamento.cod-cond-pag NO-ERROR.

    FIND FIRST moeda NO-LOCK
         WHERE moeda.mo-codigo = pagamento.cod-moeda NO-ERROR.

    FIND FIRST int-hist-pagamento NO-LOCK
         WHERE int-hist-pagamento.nr-pagamento = pagamento.nr-pagamento
           AND int-hist-pagamento.ind-acao     = 5 NO-ERROR.

    /*Busca pto de controle base*/
    FIND FIRST pagamento-invoice NO-LOCK
         WHERE pagamento-invoice.nr-pagamento = pagamento.nr-pagamento NO-ERROR.

    FIND FIRST embarque-imp NO-LOCK
         WHERE embarque-imp.cod-estabel = pagamento.cod-estabel 
           AND embarque-imp.embarque    = pagamento-invoice.embarque NO-ERROR.

    FIND FIRST ordens-embarque OF embarque-imp NO-LOCK NO-ERROR.
    FIND FIRST ordem-compra OF ordens-embarque NO-LOCK NO-ERROR.
    FIND FIRST pedido-compr OF ordem-compra NO-LOCK NO-ERROR.

    FIND FIRST cotacao-item NO-LOCK
         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
           AND cotacao-item.cod-emitente = pedido-compr.cod-emitente
           AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.

    FIND FIRST pto-contr NO-LOCK
         WHERE pto-contr.cod-pto-contr = /*cotacao-item.cod-pto-contr*/ int(SUBSTRING(cotacao-item.char-1,41,5)) NO-ERROR.

    CREATE SolicitacaoInternaPagamentoItem.
    ASSIGN SolicitacaoInternaPagamentoItem.CodigoSolicitacaoInterna = pagamento.nr-pagamento          
           SolicitacaoInternaPagamentoItem.CodigoFornecedorEMS      = pagamento.cod-emitente          
           SolicitacaoInternaPagamentoItem.NomeAbreviadoFornecedor  = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
           SolicitacaoInternaPagamentoItem.MatriculaResponsavel     = pagamento.usuario               
           SolicitacaoInternaPagamentoItem.NomeResponsavel          = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuar ELSE ""
           SolicitacaoInternaPagamentoItem.StatusSolicitacaoInterna = pagamento.ind-status-solicitacao
           SolicitacaoInternaPagamentoItem.CodigoCondicaoPagamento  = pagamento.cod-cond-pag          
           SolicitacaoInternaPagamentoItem.NomeCondicaoPagamento    = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "Condiá∆o n∆o cadastrada"
           SolicitacaoInternaPagamentoItem.DataEmissao              = IF pagamento.data-ci <> ? THEN pagamento.data-ci ELSE 01/01/0001
           SolicitacaoInternaPagamentoItem.DataInclusao             = pagamento.dat-fft
/*            SolicitacaoInternaPagamentoItem.DataFechamentoCambio     = pagamento.dt-prev-fecha-cam */
           SolicitacaoInternaPagamentoItem.ValorTotalSolicitacao    = pagamento.valor-pag             
           SolicitacaoInternaPagamentoItem.CodigoEstabelecimento    = IF pagamento.cod-estabel <> "" THEN pagamento.cod-estabel ELSE ?
           SolicitacaoInternaPagamentoItem.DataSwift                = pagamento.data-swift              
           SolicitacaoInternaPagamentoItem.CodigoMoedaEMS           = pagamento.cod-moeda 
           SolicitacaoInternaPagamentoItem.NomeMoeda                = IF AVAIL moeda THEN moeda.descricao ELSE ?  
           SolicitacaoInternaPagamentoItem.CodigoDespachante        = IF AVAIL b-emitente THEN b-emitente.cod-emitente ELSE 0
           SolicitacaoInternaPagamentoItem.NomeDespachante          = IF AVAIL b-emitente THEN b-emitente.nome-abrev   ELSE ""
           SolicitacaoInternaPagamentoItem.Urgente                  = pagamento.log-urgente     
           SolicitacaoInternaPagamentoItem.PagamentoAntecipado      = pagamento.log-pag-antecipado
           SolicitacaoInternaPagamentoItem.DataAprovacao            = pagamento.data-aprovacao
           SolicitacaoInternaPagamentoItem.NaturezaFinanceira       = pagamento.ind-natureza
           SolicitacaoInternaPagamentoItem.MatriculaComprador       = pagamento.cod-comprador         
           SolicitacaoInternaPagamentoItem.NomeComprador            = IF AVAIL b_usuar_mestre THEN b_usuar_mestre.nom_usuar ELSE ""        
           SolicitacaoInternaPagamentoItem.TipoSolicitacaoInterna   = pagamento.tipo-ci
           SolicitacaoInternaPagamentoItem.PontoControleCondicaoPagamento = IF AVAIL pto-contr THEN pto-contr.descricao ELSE ""
           SolicitacaoInternaPagamentoItem.DataRecebimentoCIFinanceiro    = IF AVAIL int-hist-pagamento THEN int-hist-pagamento.dat-hist ELSE ?
           SolicitacaoInternaPagamentoItem.Reaprovada                     = pagamento.log-reaprovada.

    RUN pi-cria-unid-negocio-embarque (OUTPUT c-cod-unid-negoc,
                                       OUTPUT c-desc-unid-negoc).

    ASSIGN SolicitacaoInternaPagamentoItem.CodigoUnidadeNegocio    = c-cod-unid-negoc
           SolicitacaoInternaPagamentoItem.DescricaoUnidadeNegocio = c-desc-unid-negoc.
    

    FOR EACH pagamento-invoice NO-LOCK
       WHERE pagamento-invoice.nr-pagamento = pagamento.nr-pagamento:

        FIND FIRST embarque-imp NO-LOCK
             WHERE embarque-imp.cod-estabel = pagamento.cod-estabel 
               AND embarque-imp.embarque    = pagamento-invoice.embarque NO-ERROR.

        IF NOT AVAIL embarque-imp THEN
            NEXT.

        FIND FIRST historico-embarque NO-LOCK  
             WHERE historico-embarque.cod-estabel = pagamento.cod-estabel 
               AND historico-embarque.embarque    = pagamento-invoice.embarque NO-ERROR.

        FIND FIRST itinerario NO-LOCK
             WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.

        FIND FIRST historico-embarque NO-LOCK
             WHERE historico-embarque.cod-estabel   = pagamento.cod-estabel
               AND historico-embarque.embarque      = pagamento-invoice.embarque
               AND historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.

        /*Ponto de Chegada*/ 
        FIND FIRST b3-historico-embarque NO-LOCK
             WHERE b3-historico-embarque.cod-estabel   = pagamento.cod-estabel
               AND b3-historico-embarque.embarque      = pagamento-invoice.embarque
               AND b3-historico-embarque.cod-itiner    = itinerario.cod-itiner
               AND b3-historico-embarque.cod-pto-contr = itinerario.pto-chegada NO-ERROR.

        FIND FIRST invoice-emb-imp NO-LOCK 
             WHERE invoice-emb-imp.cod-estabel = pagamento.cod-estabel
               AND invoice-emb-imp.embarque    = pagamento-invoice.embarque
               AND invoice-emb-imp.nr-invoice  = pagamento-invoice.nr-invoice
               AND invoice-emb-imp.parcela     = pagamento-invoice.parcela NO-ERROR.

        CREATE Fatura.
        ASSIGN Fatura.CodigoSolicitacaoInterna = pagamento.nr-pagamento
               Fatura.NumeroEmbarque           = pagamento-invoice.embarque     
               Fatura.CodigoEstabelecimento    = pagamento.cod-estabel          
               Fatura.NumeroInvoice            = pagamento-invoice.nr-invoice   
               Fatura.ParcelaInvoice           = pagamento-invoice.parcela
               Fatura.DataEmbarque             = IF AVAIL historico-embarque 
                                                 AND historico-embarque.dt-efetiva <> ? THEN 
                                                     historico-embarque.dt-efetiva 
                                                 ELSE IF AVAIL historico-embarque THEN
                                                          historico-embarque.dt-ult-prev
                                                      ELSE ?
               Fatura.ValorInvoice             = IF AVAIL pagamento-invoice THEN pagamento-invoice.valor ELSE ?
               Fatura.DataVencimento           = pagamento.dt-prev-fecha-cam
               Fatura.CodigoItinerario         = IF AVAIL itinerario THEN itinerario.cod-itiner ELSE ?
               Fatura.DescricaoItinerario      = IF AVAIL itinerario THEN itinerario.descricao  ELSE ?
               Fatura.CodigoViaTransporte      = embarque-imp.cod-via-transp
               Fatura.Master                   = embarque-imp.cod-conhecto-master
               Fatura.House                    = embarque-imp.cod-conhecto-house
               Fatura.DISiscomex               = embarque-imp.declaracao-import.

        ASSIGN SolicitacaoInternaPagamentoItem.DataFechamentoCambio = IF AVAIL invoice-emb-imp THEN invoice-emb-imp.dt-vencim ELSE ?.   

        /*Ponto de Chegada*/
        IF AVAIL b3-historico-embarque THEN DO:
            IF b3-historico-embarque.dt-efetiva <> ? THEN
                ASSIGN Fatura.DataPrevisaoChegada = b3-historico-embarque.dt-efetiva.
            ELSE 
                ASSIGN Fatura.DataPrevisaoChegada = b3-historico-embarque.dt-ult-previsao.
        END.
        ELSE 
            ASSIGN Fatura.DataPrevisaoChegada = ?.

    END.

    RETURN "OK".
END PROCEDURE.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.



PROCEDURE pi-cria-unid-negocio-embarque:

   def output param pCodUnidNegoc  like unid_negoc.cod_unid_negoc.  
   def output param pDescUnidNegoc like unid_negoc.des_unid_negoc.

   FOR EACH UnidNegocioEmbarque: DELETE UnidNegocioEmbarque. END.

   ASSIGN pCodUnidNegoc  = ""
          pDescUnidNegoc = "".

   FOR EACH ordens-embarque OF embarque-imp NO-LOCK,
       FIRST prazo-compra OF ordens-embarque   NO-LOCK,
       FIRST ordem-compra OF prazo-compra      NO-LOCK:

       FIND FIRST UnidNegocioEmbarque
            WHERE UnidNegocioEmbarque.codEstabel = pagamento.cod-estabel          
              and UnidNegocioEmbarque.embarque   = embarque-imp.embarque          
              and UnidNegocioEmbarque.CodigoUnidadeNegocio = ordem-compra.cod-unid-neg 
       NO-ERROR.

       IF NOT AVAIL UnidNegocioEmbarque THEN DO:
          CREATE UnidNegocioEmbarque.
          ASSIGN UnidNegocioEmbarque.codEstabel = pagamento.cod-estabel              
                 UnidNegocioEmbarque.embarque   = embarque-imp.embarque               
                 UnidNegocioEmbarque.CodigoUnidadeNegocio = ordem-compra.cod-unid-neg.
       END.

       ASSIGN UnidNegocioEmbarque.valor = UnidNegocioEmbarque.valor + (ordem-compra.preco-fornec * prazo-compra.qtd-do-forn). 
   END.

   FOR EACH UnidNegocioEmbarque
       BREAK BY UnidNegocioEmbarque.valor:  

       IF LAST(UnidNegocioEmbarque.valor) THEN DO:
          FIND unid_negoc WHERE unid_negoc.cod_unid_negoc = UnidNegocioEmbarque.CodigoUnidadeNegocio NO-LOCK NO-ERROR.

          IF AVAIL unid_negoc THEN
             ASSIGN pCodUnidNegoc  = unid_negoc.cod_unid_negoc
                    pDescUnidNegoc = unid_negoc.des_unid_negoc.
       END.                                                     
   END.                                  

END PROCEDURE.
