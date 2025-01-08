/********************************************************************************************/
/* Programa...: esp/esb/out/msg0160.p - 5.160	LISTAR_FORMA_PAGAMENTO_BENEFICIO            */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 20/08/2014                                                                  */ 
/* Objetico...: Listar formas de pagamento do CRM                                           */
/********************************************************************************************/

create widget-pool.
{esp/esb/out/msg0160.i}
{esp/esb/esesb000.i}

DEFINE OUTPUT  PARAM TABLE FOR resultado.
DEFINE OUTPUT  PARAM TABLE FOR msg0160r-FormaPagamentoItem.
               
DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0160
   data-relation for conteudo, msg0160 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0160r, resultado, msg0160r-FormaPagamentoItens, msg0160r-FormaPagamentoItem 
   data-relation for conteudor, msg0160r                                       relation-fields (idm, idm) nested
   data-relation for msg0160r, msg0160r-FormaPagamentoItens                    relation-fields (idm, idm) NESTED
   data-relation for msg0160r-FormaPagamentoItens, msg0160r-FormaPagamentoItem relation-fields (idm, idm) NESTED
   data-relation for msg0160r, resultado                                       relation-fields (idm, idm) NESTED.       

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0160'
       cabecalho.NumeroOperacao = 'MSG0160'.
create conteudo.
create msg0160.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

/* define variable hDoc    as handle   no-undo.                                             */
/* create x-document hDoc.                                                                  */
/* hDoc:LOAD("longchar", iXML, NO).                                                         */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").  */

RETURN.

