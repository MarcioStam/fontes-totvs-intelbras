CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

DEFINE BUFFER b_usuar_mestre FOR usuar_mestre.
/* DEFINE VARIABLE iXML AS LONGCHAR NO-UNDO.                                       */
/* DEFINE VARIABLE oXML AS LONGCHAR NO-UNDO.                                       */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='utf-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>DETALHAR_SOLICITACAO_INTERNA_PAGAMENTO</NumeroOperacao>     */
/*     <CodigoMensagem>MSG0257</CodigoMensagem>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0257>                                                                   */
/*       <CodigoSolicitacaoInterna>42119</CodigoSolicitacaoInterna>                */
/*     </MSG0257>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0257.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0257
   DATA-RELATION FOR conteudo, msg0257                       RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0257R1, SolicitacaoInterna, HistoricoSolicitacaoInterna, Fatura, FinanceiroFiscalSolicitacao, resultado
   DATA-RELATION FOR conteudor, msg0257R1                             RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0257R1, SolicitacaoInterna                    RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR SolicitacaoInterna, HistoricoSolicitacaoInterna  RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR SolicitacaoInterna, Fatura                       RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR SolicitacaoInterna, FinanceiroFiscalSolicitacao  RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0257R1, resultado                             RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

DEFINE BUFFER b-int-criticidade-item FOR int-criticidade-item.
DEFINE BUFFER b-historico-embarque   FOR historico-embarque.
DEFINE BUFFER b-emitente             FOR emitente.

DEF VAR c-cod-unid-negoc  AS CHAR NO-UNDO.
DEF VAR c-desc-unid-negoc AS CHAR NO-UNDO.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0257R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0257 NO-ERROR.

CREATE conteudor.
CREATE msg0257R1.
CREATE resultado.

RUN pi-detalha-pagamento.


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

PROCEDURE pi-detalha-pagamento:

    FIND FIRST pagamento NO-LOCK
         WHERE pagamento.nr-pagamento = msg0257.CodigoSolicitacaoInterna NO-ERROR.

    IF AVAIL pagamento THEN DO:
        RUN pi-cria-retorno.
    END.
    ELSE DO:
        RUN pi-erro (INPUT "NÆo contrada SIP informada.").
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-retorno:

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = pagamento.cod-emitente NO-ERROR.

    FIND FIRST b-emitente NO-LOCK
         WHERE b-emitente.cod-emitente = pagamento.cod-despachante NO-ERROR.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = pagamento.cod-estabel NO-ERROR.

    FIND FIRST moeda NO-LOCK
         WHERE moeda.mo-codigo = pagamento.cod-moeda NO-ERROR.

    FIND FIRST cond-pagto NO-LOCK
         WHERE cond-pagto.cod-cond-pag = pagamento.cod-cond-pag NO-ERROR.

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuar = pagamento.usuario NO-ERROR.

    FIND FIRST b_usuar_mestre NO-LOCK
         WHERE b_usuar_mestre.cod_usuar = pagamento.cod-comprador NO-ERROR.

    FIND FIRST tipo-rec-desp
         WHERE tipo-rec-desp.tp-codigo = pagamento.tipo-despesa NO-ERROR.

    CREATE SolicitacaoInterna.
    ASSIGN SolicitacaoInterna.CodigoSolicitacaoInterna    = pagamento.nr-pagamento          
           SolicitacaoInterna.DataEmissao                 = IF pagamento.data-ci <> ? THEN pagamento.data-ci ELSE 01/01/0001
           /*SolicitacaoInterna.PrevFechaCambio             = pagamento.dt-prev-fecha-cam*/
           SolicitacaoInterna.Urgente                     = pagamento.log-urgente           
           SolicitacaoInterna.CodigoFornecedorEMS         = pagamento.cod-emitente          
           SolicitacaoInterna.NomeAbreviadoFornecedor     = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
           SolicitacaoInterna.CodigoEstabelecimento       = IF pagamento.cod-estabel <> "" THEN pagamento.cod-estabel ELSE ?
           SolicitacaoInterna.NomeEstabelecimento         = IF AVAIL estabelec THEN estabelec.nome ELSE ""
           SolicitacaoInterna.ValorSolicitacaoInterna     = pagamento.valor-pag             
           SolicitacaoInterna.CodigoMoedaEMS              = pagamento.cod-moeda             
           SolicitacaoInterna.NomeMoeda                   = IF AVAIL moeda THEN moeda.descricao ELSE ""
           SolicitacaoInterna.TipoSolicitacaoInterna      = pagamento.tipo-ci               
           SolicitacaoInterna.StatusSolicitacaoInterna    = pagamento.ind-status-solicitacao
           SolicitacaoInterna.CodigoCondicaoPagamento     = pagamento.cod-cond-pag          
           SolicitacaoInterna.NomeCondicaoPagamento       = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ""
           SolicitacaoInterna.CodigoTipoDespesa           = pagamento.tipo-despesa          
           SolicitacaoInterna.DescricaoTipoDespesa        = IF AVAIL tipo-rec-desp THEN tipo-rec-desp.descricao ELSE ""
           SolicitacaoInterna.MatriculaResponsavel        = pagamento.usuario               
           SolicitacaoInterna.NomeResponsavel             = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuar ELSE ""
           SolicitacaoInterna.MatriculaComprador          = pagamento.cod-comprador         
           SolicitacaoInterna.NomeComprador               = IF AVAIL b_usuar_mestre THEN b_usuar_mestre.nom_usuar ELSE ""        
           SolicitacaoInterna.PossuiAnexos                = pagamento.log-possui-anexos                               
           SolicitacaoInterna.Observacoes                 = pagamento.txt-observacao        
           SolicitacaoInterna.PagamentoAntecipado         = pagamento.log-pag-antecipado
           SolicitacaoInterna.DataFFT                     = pagamento.dat-fft               
           SolicitacaoInterna.DISiscomex                  = "" /*isso esta no embarque como pegar no pagamento?*/
           SolicitacaoInterna.CodigoDespachante           = IF AVAIL b-emitente THEN b-emitente.cod-emitente ELSE ?
           SolicitacaoInterna.NomeDespachante             = IF AVAIL b-emitente THEN b-emitente.nome-abrev   ELSE ?.

    RUN pi-cria-unid-negocio-embarque (OUTPUT c-cod-unid-negoc,
                                       OUTPUT c-desc-unid-negoc).

    ASSIGN SolicitacaoInterna.CodigoUnidadeNegocio    = c-cod-unid-negoc
           SolicitacaoInterna.DescricaoUnidadeNegocio = c-desc-unid-negoc.


    FOR EACH int-hist-pagamento NO-LOCK
       WHERE int-hist-pagamento.nr-pagamento = pagamento.nr-pagamento
          BY int-hist-pagamento.num-seq-hist DESC:

        CREATE HistoricoSolicitacaoInterna.
        ASSIGN HistoricoSolicitacaoInterna.MatriculaUsuario    = int-hist-pagamento.cod-usuario    
               HistoricoSolicitacaoInterna.DataHistorico       = int-hist-pagamento.dat-hist       
               HistoricoSolicitacaoInterna.HoraHistorico       = int-hist-pagamento.hor-hist       
               HistoricoSolicitacaoInterna.AcaoHistorico       = int-hist-pagamento.ind-acao       
               HistoricoSolicitacaoInterna.ObservacaoHistorico = int-hist-pagamento.txt-historico.
    END.

    FOR EACH pagamento-invoice NO-LOCK
       WHERE pagamento-invoice.nr-pagamento = pagamento.nr-pagamento:

        FIND FIRST historico-embarque NO-LOCK  
             WHERE historico-embarque.cod-estabel = pagamento.cod-estabel 
               AND historico-embarque.embarque    = pagamento-invoice.embarque NO-ERROR.

        FIND FIRST itinerario NO-LOCK
             WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.

        FIND FIRST historico-embarque NO-LOCK
             WHERE historico-embarque.cod-estabel   = pagamento.cod-estabel
               AND historico-embarque.embarque      = pagamento-invoice.embarque
               AND historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-ERROR.

        FIND FIRST invoice-emb-imp NO-LOCK 
             WHERE invoice-emb-imp.cod-estabel = pagamento.cod-estabel
               AND invoice-emb-imp.embarque    = pagamento-invoice.embarque
               AND invoice-emb-imp.nr-invoice  = pagamento-invoice.nr-invoice
               AND invoice-emb-imp.parcela     = pagamento-invoice.parcela NO-ERROR.

        FIND FIRST moeda NO-LOCK
             WHERE moeda.mo-codigo = invoice-emb-imp.mo-codigo NO-ERROR.

        CREATE Fatura.
        ASSIGN Fatura.NumeroEmbarque        = pagamento-invoice.embarque   
               Fatura.CodigoEstabelecimento = pagamento.cod-estabel       
               Fatura.DataEmbarque          = IF AVAIL historico-embarque 
                                                   AND historico-embarque.dt-efetiva <> ? THEN 
                                                       historico-embarque.dt-efetiva 
                                                   ELSE IF AVAIL historico-embarque THEN
                                                       historico-embarque.dt-ult-prev
                                                   ELSE ?
               Fatura.NumeroInvoice         = pagamento-invoice.nr-invoice 
               Fatura.ParcelaInvoice        = pagamento-invoice.parcela    
               Fatura.CodigoMoedaEMS        = IF AVAIL invoice-emb-imp THEN invoice-emb-imp.mo-codigo ELSE 0
               Fatura.NomeMoeda             = IF AVAIL moeda THEN moeda.descricao ELSE ""
               Fatura.ValorInvoice          = pagamento-invoice.valor      
               Fatura.DataInvoice           = pagamento.dt-prev-fecha-cam /*IF AVAIL invoice-emb-imp THEN invoice-emb-imp.dt-vencim ELSE ?*/ .

        ASSIGN SolicitacaoInterna.PrevFechaCambio = IF AVAIL invoice-emb-imp THEN invoice-emb-imp.dt-vencim ELSE ?.

    END.

    FIND FIRST moeda NO-LOCK
         WHERE moeda.mo-codigo = pagamento.cod-moeda NO-ERROR.

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuar = pagamento.usuar-receb NO-ERROR.

    CREATE FinanceiroFiscalSolicitacao.
    ASSIGN FinanceiroFiscalSolicitacao.Recebida                    = pagamento.recebido-ap      
           FinanceiroFiscalSolicitacao.MatriculaUsuarioRecebimento = pagamento.usuar-receb      
           FinanceiroFiscalSolicitacao.NomeColaboradorIntelbras    = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuar ELSE ""
           FinanceiroFiscalSolicitacao.DataRecebimento             = pagamento.dat-receb-financ
           FinanceiroFiscalSolicitacao.ValorContratoME             = pagamento.valor-contrato-me
           FinanceiroFiscalSolicitacao.NaturezaCambial             = pagamento.tipo-contr-cambio
           FinanceiroFiscalSolicitacao.ContratoCambio              = pagamento.nr-cont-cambio   
           FinanceiroFiscalSolicitacao.DataContratoCambio          = pagamento.data-emissao
           FinanceiroFiscalSolicitacao.CodigoSwift                 = pagamento.swift            
           FinanceiroFiscalSolicitacao.DataSwift                   = pagamento.data-swift       
           FinanceiroFiscalSolicitacao.InstituicaoCambio           = pagamento.instit-cambio    
           FinanceiroFiscalSolicitacao.PracaCambio                 = pagamento.praca-cambio     
           FinanceiroFiscalSolicitacao.TaxaCambioPagamento         = pagamento.taxa-cambio-pag  
           FinanceiroFiscalSolicitacao.TaxaCambio                  = pagamento.taxa-cambio      
           FinanceiroFiscalSolicitacao.ValorContrato               = pagamento.valor-contrato-me
           FinanceiroFiscalSolicitacao.ValorOrdem                  = pagamento.valor-ord-pag    
           FinanceiroFiscalSolicitacao.CodigoMoedaEMS              = pagamento.cod-moeda        
           FinanceiroFiscalSolicitacao.NomeMoeda                   = IF AVAIL moeda THEN moeda.descricao ELSE ""
           FinanceiroFiscalSolicitacao.ValorFechamento             = pagamento.valor-fechamento 
           FinanceiroFiscalSolicitacao.DataFechamentoCambio        = pagamento.dt-fecha-cam
           FinanceiroFiscalSolicitacao.NaturezaFinanceira          = pagamento.ind-natureza        
           FinanceiroFiscalSolicitacao.CreditNote                  = pagamento.val-credit-note     
           FinanceiroFiscalSolicitacao.Ptax                        = pagamento.val-taxa-ptax       
           FinanceiroFiscalSolicitacao.CustoFftLcUsd               = pagamento.val-custo-fft-lc-usd
           FinanceiroFiscalSolicitacao.CustoFftLcRs                = pagamento.val-custo-fft-lc-rs 
           FinanceiroFiscalSolicitacao.DataDebitoCustoFftLc        = pagamento.dat-custo-fft-lc.  

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

   /*Busca pto de controle base*/
   FIND FIRST pagamento-invoice NO-LOCK
        WHERE pagamento-invoice.nr-pagamento = pagamento.nr-pagamento NO-ERROR.

   IF AVAIL pagamento-invoice THEN DO:
   
       FIND FIRST embarque-imp NO-LOCK
            WHERE embarque-imp.cod-estabel = pagamento.cod-estabel 
              AND embarque-imp.embarque    = pagamento-invoice.embarque NO-ERROR.
    
       IF AVAIL embarque-imp THEN DO:
       
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
       END.
   END.

END PROCEDURE.
