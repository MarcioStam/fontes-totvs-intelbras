/********************************************************************************************/
/* Programa...: esp/esb/out/MSG0156-status.p - 5.159 REGISTRA_SOLICITACAO_STOCK_ROTATION    */
/* Autor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 20/08/2014                                                                  */ 
/* Objetico...: Enviar o status de pagamento efetuado da solicitaá∆o                        */
/********************************************************************************************/

create widget-pool.
{esp/esb/out/msg0156-status.i}
{esp/esb/esesb000.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.
               
DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

RAW-TRANSFER raw-param TO MSG0156-status.

/*Definiá∆o da mensagem de envio de atualizaá∆o*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, MSG0156-status, msg0156-ProdutoSolicitacaoItens, msg0156-ProdutoSolicitacaoItem
   data-relation for conteudo, MSG0156-status                                        relation-fields (idm, idm) NESTED
   data-relation for MSG0156-status, msg0156-ProdutoSolicitacaoItens                 relation-fields (idm, idm) NESTED 
   data-relation for msg0156-ProdutoSolicitacaoItens, msg0156-ProdutoSolicitacaoItem relation-fields (idm, idm) NESTED.

/*Definiá∆o e leitura da mensagem de resposta da atualizaá∆o.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, MSG0156-statusr, resultado 
   data-relation for conteudor, MSG0156-statusr                                       relation-fields (idm, idm) nested
   data-relation for MSG0156-statusr, resultado                                       relation-fields (idm, idm) NESTED.       


create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0156'.

create conteudo.

FIND FIRST MSG0156-status NO-LOCK NO-ERROR.

IF  NOT AVAIL MSG0156-status THEN
    RETURN.


IF  CAN-FIND (FIRST int-solicitacao-item 
                 WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = MSG0156-status.CodigoSolicitacaoBeneficio) THEN DO:

    CREATE msg0156-ProdutoSolicitacaoItens.
    
    FOR EACH int-solicitacao-item NO-LOCK
        WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = MSG0156-status.CodigoSolicitacaoBeneficio:
        
        CREATE msg0156-ProdutoSolicitacaoItem.
    
        ASSIGN  msg0156-ProdutoSolicitacaoItem.CodigoProdutoSolicitacao      =   int-solicitacao-item.CodigoProdutoSolicitacao  
                msg0156-ProdutoSolicitacaoItem.CodigoSolicitacaoBeneficio    =   int-solicitacao-item.CodigoSolicitacaoBeneficio
                msg0156-ProdutoSolicitacaoItem.CodigoProduto                 =   int-solicitacao-item.CodigoProduto             
                msg0156-ProdutoSolicitacaoItem.CodigoBeneficio               =   int-solicitacao-item.CodigoBeneficio           
                msg0156-ProdutoSolicitacaoItem.ValorUnitario                 =   int-solicitacao-item.ValorUnitario             
                msg0156-ProdutoSolicitacaoItem.Quantidade                    =   int-solicitacao-item.quantidade                
                msg0156-ProdutoSolicitacaoItem.ValorTotal                    =   int-solicitacao-item.ValorTotal                
                msg0156-ProdutoSolicitacaoItem.ValorUnitarioAprovado         =   int-solicitacao-item.ValorUnitarioAprovado     
                msg0156-ProdutoSolicitacaoItem.QuantidadeAprovado            =   int-solicitacao-item.QuantidadeAprovada
                msg0156-ProdutoSolicitacaoItem.ValorTotalAprovado            =   int-solicitacao-item.ValorTotalAprovado        
                msg0156-ProdutoSolicitacaoItem.ChaveIntegracaoNotaFiscal     =   int-solicitacao-item.ChaveIntegracaoNotaFiscal
                msg0156-ProdutoSolicitacaoItem.Proprietario                  =   int-solicitacao-item.proprietario              
                msg0156-ProdutoSolicitacaoItem.TipoProprietario              =   int-solicitacao-item.TipoProprietario          
                msg0156-ProdutoSolicitacaoItem.Acao                          =   int-solicitacao-item.Acao                      
                msg0156-ProdutoSolicitacaoItem.CodigoEstabelecimento         =   int-solicitacao-item.CodigoEstabelecimento     
                msg0156-ProdutoSolicitacaoItem.Situacao                      =   int-solicitacao-item.Situacao                  
                msg0156-ProdutoSolicitacaoItem.QuantidadeCancelada           =   int-solicitacao-item.QuantidadeCancelada       
                msg0156-ProdutoSolicitacaoItem.ValorPago                     =   int-solicitacao-item.ValorPago                 
                msg0156-ProdutoSolicitacaoItem.ValorCancelado                =   int-solicitacao-item.ValorCancelado            .
    
    END.
END.
/*
993520000: N∆o Pago
993520001: Pago Parcial
993520002: Pago Total Padr∆o
993520000: N∆o Pago
*/
DEF VAR c-emitente AS CHAR FORMAT "X(12)" NO-UNDO.
FIND int-solicitacao NO-LOCK
    WHERE int-solicitacao.CodigoSolicitacaoBeneficio = MSG0156-status.CodigoSolicitacaoBeneficio NO-ERROR.

DEF VAR c-identificador AS CHAR NO-UNDO.

IF  AVAIL int-solicitacao THEN
    ASSIGN c-emitente      = TRIM(string(int-solicitacao.cod-emitente))
           c-identificador = int-solicitacao.NomeSolicitacaoBeneficio.

ASSIGN cabecalho.NumeroOperacao = c-identificador.       /*MSG0156-status.StatusPagamento                 = 993520002
       MSG0156-status.RazaoStatusSolicitacaoBeneficio = 993520004.*/

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

/* FIND FIRST resultado NO-ERROR.                                                                                      */
/*                                                                                                                     */
/* IF  AVAIL resultado AND resultado.sucesso THEN DO:                                                                  */
/*     DO TRANS:                                                                                                       */
/*                                                                                                                     */
/*         FIND FIRST MSG0156-status NO-ERROR.                                                                         */
/*         IF  NOT AVAIL MSG0156-status THEN                                                                           */
/*             RETURN.                                                                                                 */
/*                                                                                                                     */
/*         FIND FIRST int-solicitacao EXCLUSIVE-LOCK                                                                   */
/*             WHERE int-solicitacao.CodigoSolicitacaoBeneficio = MSG0156-status.CodigoSolicitacaoBeneficio NO-ERROR.  */
/*                                                                                                                     */
/*         IF  AVAIL int-solicitacao THEN                                                                              */
/*             ASSIGN int-solicitacao.log-enviada                     = YES                                            */
/*                    int-solicitacao.StatusPagamento                 = 993520002                                      */
/*                    int-solicitacao.RazaoStatusSolicitacaoBeneficio = 993520004 /* REEMBOLSADO */.                   */
/*                                                                                                                     */
/*         FIND CURRENT int-solicitacao NO-LOCK NO-ERROR.                                                              */
/*                                                                                                                     */
/*     END.                                                                                                            */
/* END.                                                                                                                */

/* define variable hDoc    as handle   no-undo.                                            */
/* create x-document hDoc.                                                                 */
/* hDoc:LOAD("longchar", iXML, NO).                                                        */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */
/*                                                                                         */
RETURN.

