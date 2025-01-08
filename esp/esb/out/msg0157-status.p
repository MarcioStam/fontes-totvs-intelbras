/*********************************************************************************************/
/* Programa...: esp/esb/out/MSG0157-status.p -  REGISTRA_SOLICITACAO_REBATE_SHOW_ROOM        */
/* Autor......: Roger Marcelino Bruhn                                                        */
/* Data.......: 20/08/2014                                                                   */ 
/* Objetico...: Enviar o status de pagamento efetuado da solicita‡Æo                         */
/*********************************************************************************************/

create widget-pool.
{esp/esb/out/msg0157-status.i}
{esp/esb/esesb000.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.
               
DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

RAW-TRANSFER raw-param TO MSG0157-status.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, MSG0157-status, msg0157-ProdutoSolicitacaoItens, msg0157-ProdutoSolicitacaoItem
    data-relation for conteudo, MSG0157-status                                        relation-fields (idm, idm) NESTED
    data-relation for MSG0157-status, msg0157-ProdutoSolicitacaoItens                 relation-fields (idm, idm) NESTED 
    data-relation for msg0157-ProdutoSolicitacaoItens, msg0157-ProdutoSolicitacaoItem relation-fields (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, MSG0157-statusr, resultado 
   data-relation for conteudor, MSG0157-statusr                                       relation-fields (idm, idm) nested
   data-relation for MSG0157-statusr, resultado                                       relation-fields (idm, idm) NESTED.       


create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0157'.

create conteudo.

FIND FIRST MSG0157-status NO-LOCK NO-ERROR.

IF  NOT AVAIL MSG0157-status THEN
    RETURN.


IF  CAN-FIND (FIRST int-solicitacao-item 
                 WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = MSG0157-status.CodigoSolicitacaoBeneficio) THEN DO:

    CREATE msg0157-ProdutoSolicitacaoItens.
    
    FOR EACH int-solicitacao-item NO-LOCK
        WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = MSG0157-status.CodigoSolicitacaoBeneficio:
        
        CREATE msg0157-ProdutoSolicitacaoItem.
    
        ASSIGN  msg0157-ProdutoSolicitacaoItem.CodigoProdutoSolicitacao      =   int-solicitacao-item.CodigoProdutoSolicitacao  
                msg0157-ProdutoSolicitacaoItem.CodigoSolicitacaoBeneficio    =   int-solicitacao-item.CodigoSolicitacaoBeneficio
                msg0157-ProdutoSolicitacaoItem.CodigoProduto                 =   int-solicitacao-item.CodigoProduto             
                msg0157-ProdutoSolicitacaoItem.CodigoBeneficio               =   int-solicitacao-item.CodigoBeneficio           
                msg0157-ProdutoSolicitacaoItem.ValorUnitario                 =   int-solicitacao-item.ValorUnitario             
                msg0157-ProdutoSolicitacaoItem.Quantidade                    =   int-solicitacao-item.quantidade                
                msg0157-ProdutoSolicitacaoItem.ValorTotal                    =   int-solicitacao-item.ValorTotal                
                msg0157-ProdutoSolicitacaoItem.ValorUnitarioAprovado         =   int-solicitacao-item.ValorUnitarioAprovado     
                msg0157-ProdutoSolicitacaoItem.QuantidadeAprovado            =   int-solicitacao-item.QuantidadeAprovada
                msg0157-ProdutoSolicitacaoItem.ValorTotalAprovado            =   int-solicitacao-item.ValorTotalAprovado        
                msg0157-ProdutoSolicitacaoItem.ChaveIntegracaoNotaFiscal     =   int-solicitacao-item.ChaveIntegracaoNotaFiscal
                msg0157-ProdutoSolicitacaoItem.Proprietario                  =   int-solicitacao-item.proprietario              
                msg0157-ProdutoSolicitacaoItem.TipoProprietario              =   int-solicitacao-item.TipoProprietario          
                msg0157-ProdutoSolicitacaoItem.Acao                          =   int-solicitacao-item.Acao                      
                msg0157-ProdutoSolicitacaoItem.CodigoEstabelecimento         =   int-solicitacao-item.CodigoEstabelecimento     
                msg0157-ProdutoSolicitacaoItem.Situacao                      =   int-solicitacao-item.Situacao                  
                msg0157-ProdutoSolicitacaoItem.QuantidadeCancelada           =   int-solicitacao-item.QuantidadeCancelada       
                msg0157-ProdutoSolicitacaoItem.ValorPago                     =   int-solicitacao-item.ValorPago                 
                msg0157-ProdutoSolicitacaoItem.ValorCancelado                =   int-solicitacao-item.ValorCancelado            .
    
    END.
END.

DEF VAR c-emitente AS CHAR FORMAT "X(12)" NO-UNDO.
FIND int-solicitacao NO-LOCK
    WHERE int-solicitacao.CodigoSolicitacaoBeneficio = MSG0157-status.CodigoSolicitacaoBeneficio NO-ERROR.

DEF VAR c-identificador AS CHAR NO-UNDO.

IF  AVAIL int-solicitacao THEN
    ASSIGN c-emitente      = TRIM(string(int-solicitacao.cod-emitente))
           c-identificador = int-solicitacao.NomeSolicitacaoBeneficio.

ASSIGN cabecalho.NumeroOperacao = c-identificador.
       /*MSG0157-status.StatusPagamento                 = 993520002
       MSG0157-status.RazaoStatusSolicitacaoBeneficio = 993520004*/.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

/* FIND FIRST resultado NO-ERROR.                      */
/*                                                     */
/* IF  AVAIL resultado AND resultado.sucesso THEN DO:  */
/*     DO TRANS:                                                                                                       */
/*                                                                                                                     */
/*         FIND FIRST MSG0157-status NO-ERROR.                                                                         */
/*         IF  NOT AVAIL MSG0157-status THEN                                                                           */
/*             RETURN.                                                                                                 */
/*                                                                                                                     */
/*         FIND FIRST int-solicitacao EXCLUSIVE-LOCK                                                                   */
/*             WHERE int-solicitacao.CodigoSolicitacaoBeneficio = MSG0157-status.CodigoSolicitacaoBeneficio NO-ERROR.  */
/*                                                                                                                     */
/*         IF  AVAIL int-solicitacao THEN                                                                              */
/*             ASSIGN int-solicitacao.log-enviada                     = YES                                            */
/*                    int-solicitacao.StatusPagamento                 = 993520002                                      */
/*                    int-solicitacao.RazaoStatusSolicitacaoBeneficio = 993520004 /* REEMBOLSADO */.                   */
/*         FIND CURRENT int-solicitacao NO-LOCK NO-ERROR.                                                              */
/*                                                                                                                     */
/*     END.                                                                                                            */
/* END.  */

/* define variable hDoc    as handle   no-undo.                                             */
/* create x-document hDoc.                                                                  */
/* hDoc:LOAD("longchar", iXML, NO).                                                         */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").  */

RETURN.

