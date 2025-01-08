/*****************************************************8***************************************/
/* Programa...: esp/esb/out/MSG0154-status.p - 5.159   REGISTRA_SOLICITACAO_REBATE           */
/* Autor......: Roger Marcelino Bruhn                                                        */
/* Data.......: 20/08/2014                                                                   */ 
/* Objetico...: Enviar o status de pagamento efetuado da solicita‡Æo                         */
/*********************************************************************************************/

create widget-pool.
{esp/esb/out/msg0154-status.i}
{esp/esb/esesb000.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.
               
DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

RAW-TRANSFER raw-param TO MSG0154-status.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, MSG0154-status, msg0154-ProdutoSolicitacaoItens, msg0154-ProdutoSolicitacaoItem
   data-relation for conteudo, MSG0154-status                                        relation-fields (idm, idm) NESTED
   data-relation for MSG0154-status, msg0154-ProdutoSolicitacaoItens                 relation-fields (idm, idm) NESTED 
   data-relation for msg0154-ProdutoSolicitacaoItens, msg0154-ProdutoSolicitacaoItem relation-fields (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, MSG0154-statusr, resultado 
   data-relation for conteudor, MSG0154-statusr                                       relation-fields (idm, idm) nested
   data-relation for MSG0154-statusr, resultado                                       relation-fields (idm, idm) NESTED.       


create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0154'.

create conteudo.

FIND FIRST MSG0154-status NO-LOCK NO-ERROR.

IF  NOT AVAIL MSG0154-status THEN
    RETURN.


IF  CAN-FIND (FIRST int-solicitacao-item 
                 WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = MSG0154-status.CodigoSolicitacaoBeneficio) THEN DO:

    CREATE msg0154-ProdutoSolicitacaoItens.
    
    FOR EACH int-solicitacao-item NO-LOCK
        WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = MSG0154-status.CodigoSolicitacaoBeneficio:
        
        CREATE msg0154-ProdutoSolicitacaoItem.
    
        ASSIGN  msg0154-ProdutoSolicitacaoItem.CodigoProdutoSolicitacao      =   int-solicitacao-item.CodigoProdutoSolicitacao  
                msg0154-ProdutoSolicitacaoItem.CodigoSolicitacaoBeneficio    =   int-solicitacao-item.CodigoSolicitacaoBeneficio
                msg0154-ProdutoSolicitacaoItem.CodigoProduto                 =   int-solicitacao-item.CodigoProduto             
                msg0154-ProdutoSolicitacaoItem.CodigoBeneficio               =   int-solicitacao-item.CodigoBeneficio           
                msg0154-ProdutoSolicitacaoItem.ValorUnitario                 =   int-solicitacao-item.ValorUnitario             
                msg0154-ProdutoSolicitacaoItem.Quantidade                    =   int-solicitacao-item.quantidade                
                msg0154-ProdutoSolicitacaoItem.ValorTotal                    =   int-solicitacao-item.ValorTotal                
                msg0154-ProdutoSolicitacaoItem.ValorUnitarioAprovado         =   int-solicitacao-item.ValorUnitarioAprovado     
                msg0154-ProdutoSolicitacaoItem.QuantidadeAprovado            =   int-solicitacao-item.QuantidadeAprovada
                msg0154-ProdutoSolicitacaoItem.ValorTotalAprovado            =   int-solicitacao-item.ValorTotalAprovado        
                msg0154-ProdutoSolicitacaoItem.ChaveIntegracaoNotaFiscal     =   int-solicitacao-item.ChaveIntegracaoNotaFiscal
                msg0154-ProdutoSolicitacaoItem.Proprietario                  =   int-solicitacao-item.proprietario              
                msg0154-ProdutoSolicitacaoItem.TipoProprietario              =   int-solicitacao-item.TipoProprietario          
                msg0154-ProdutoSolicitacaoItem.Acao                          =   int-solicitacao-item.Acao                      
                msg0154-ProdutoSolicitacaoItem.CodigoEstabelecimento         =   int-solicitacao-item.CodigoEstabelecimento     
                msg0154-ProdutoSolicitacaoItem.Situacao                      =   int-solicitacao-item.Situacao                  
                msg0154-ProdutoSolicitacaoItem.QuantidadeCancelada           =   int-solicitacao-item.QuantidadeCancelada       
                msg0154-ProdutoSolicitacaoItem.ValorPago                     =   int-solicitacao-item.ValorPago + int-solicitacao-item.vl-empenho-pago                 
                msg0154-ProdutoSolicitacaoItem.ValorCancelado                =   int-solicitacao-item.ValorCancelado .
    
    END.
END.

DEF VAR c-emitente AS CHAR FORMAT "X(12)" NO-UNDO.
FIND int-solicitacao NO-LOCK
    WHERE int-solicitacao.CodigoSolicitacaoBeneficio = MSG0154-status.CodigoSolicitacaoBeneficio NO-ERROR.

DEF VAR c-identificador AS CHAR NO-UNDO.

IF  AVAIL int-solicitacao THEN
    ASSIGN c-emitente      = TRIM(string(int-solicitacao.cod-emitente))
           c-identificador = int-solicitacao.NomeSolicitacaoBeneficio.

ASSIGN cabecalho.NumeroOperacao = c-identificador.
       /*MSG0154-status.StatusPagamento                 = 993520002
       MSG0154-status.RazaoStatusSolicitacaoBeneficio = 993520004*/.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

/* define variable hDoc    as handle   no-undo.                                              */
/* create x-document hDoc.                                                                   */
/* hDoc:LOAD("longchar", iXML, NO).                                                          */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").   */
/*                                                                                           */
/* define variable hDoc1    as handle   no-undo.                                             */
/* create x-document hDoc1.                                                                  */
/* hDoc1:LOAD("longchar", oXML, NO).                                                         */
/* hDoc1:SAVE("file","C:/temp/oXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").  */


RETURN.

