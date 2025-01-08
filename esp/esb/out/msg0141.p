/********************************************************************************************/
/* Programa...: esp/esb/out/msg0141.p - LISTAR_BENEFICIO_CANAL                              */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 01/04/2014                                                                  */ 
/********************************************************************************************/

create widget-pool.
{esp/esb/out/msg0141.i}

DEFINE INPUT   PARAM p-guid-canal           AS CHAR NO-UNDO.
DEFINE INPUT   PARAM p-unid-neg             AS CHAR NO-UNDO. 
DEFINE INPUT   PARAM p-controle-cc          AS LOG  INIT ? NO-UNDO.
DEFINE OUTPUT  PARAM TABLE FOR resultado.
DEFINE OUTPUT  PARAM TABLE FOR msg0141r-beneficioItem.
               
DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0141
   data-relation for conteudo, msg0141 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0141r, msg0141r-BeneficioItens, msg0141r-beneficioItem, resultado
   data-relation for conteudor, msg0141r                              relation-fields (idm, idm) NESTED 
   data-relation for msg0141r, msg0141r-BeneficioItens                relation-fields (idm, idm) NESTED
   data-relation for msg0141r-BeneficioItens, msg0141r-beneficioItem  relation-fields (idm, idm) NESTED
   data-relation for msg0141r, resultado                              relation-fields (idm, idm) NESTED.       

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0141'.
     
create conteudo.
create msg0141.

ASSIGN msg0141.CodigoConta                 = p-guid-canal
       msg0141.PassivelSolicitacao         = TRUE
       msg0141.CodigoUnidadeNegocio        = p-unid-neg.


IF  p-controle-cc = YES THEN
    ASSIGN msg0141.PossuiControleContaCorrente = 993520000. /*SIM*/
ELSE 
    IF p-controle-cc = NO THEN
        ASSIGN msg0141.PossuiControleContaCorrente = 993520001. /*NÇO*/
     ELSE
        ASSIGN msg0141.PossuiControleContaCorrente = ?. /*Todos*/


ASSIGN cabecalho.NumeroOperacao  = STRING(msg0141.CodigoConta).

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                 */
{esp/esb/esesb003a.i}

RETURN.
