/*********************************************************************************************/
/* Programa...: esp/esb/out/MSG0195.p                                                        */
/* Autor......: Roger Marcelino Bruhn                                                        */
/* Data.......: 31/08/2016                                                                   */ 
/* Objetico...: Registrar Tabela de Pre‡o e Itens                                            */
/*********************************************************************************************/

create widget-pool.
{esp/esb/out/msg0195.i}
{esp/esb/esesb000.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.
               
DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

RAW-TRANSFER raw-param TO msg0195.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, MSG0195
   data-relation for conteudo, MSG0195          relation-fields (idm, idm) NESTED.
   
/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, MSG0195r, resultado 
   data-relation for conteudor, MSG0195r           relation-fields (idm, idm) nested
   data-relation for MSG0195r, resultado    relation-fields (idm, idm) NESTED.       


create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0195'.

create conteudo.


IF  NOT CAN-FIND (FIRST msg0195) THEN
    RETURN "OK".
       
DEF VAR c-identificador AS CHAR NO-UNDO.

ASSIGN c-identificador = IF msg0195.CodigoProduto <> "?" THEN
                            msg0195.TabelaPrecoEMS + " / " +  msg0195.CodigoProduto
                         ELSE
                            msg0195.TabelaPrecoEMS.

ASSIGN cabecalho.NumeroOperacao = c-identificador.

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

