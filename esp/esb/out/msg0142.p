/********************************************************************************************/
/* Programa...: esp/esb/out/msg0142.p - LISTAR_PARAMETROS_BENEFICIO                       */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 26/06/2014                                                                  */ 
/********************************************************************************************/

create widget-pool.
{esp/esb/out/msg0142.i}

DEFINE  INPUT  PARAM p-guid-beneficio           AS CHAR NO-UNDO.
DEFINE OUTPUT  PARAM TABLE FOR resultado.
DEFINE OUTPUT  PARAM TABLE FOR msg0142r-ParametroBeneficioItem.
               
DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0142
   data-relation for conteudo, msg0142 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0142r, msg0142r-ParametroBeneficioItens, msg0142r-ParametroBeneficioItem, resultado
   data-relation for conteudor, msg0142r                                                relation-fields (idm, idm) NESTED 
   data-relation for msg0142r, msg0142r-ParametroBeneficioItens                         relation-fields (idm, idm) NESTED
   data-relation for msg0142r-ParametroBeneficioItens, msg0142r-ParametroBeneficioItem  relation-fields (idm, idm) NESTED
   data-relation for msg0142r, resultado                                                relation-fields (idm, idm) NESTED.       

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0142'.
     
create conteudo.
create msg0142.

ASSIGN msg0142.CodigoBeneficio   = p-guid-beneficio      
       cabecalho.NumeroOperacao  = STRING(msg0142.CodigoBeneficio).

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
