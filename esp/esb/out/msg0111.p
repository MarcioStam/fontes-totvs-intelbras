/********************************************************************************************/
/* Programa...: esp/esb/out/msg0111.p - OBTER_PARAMETRO_GLOBAL                              */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 01/04/2014                                                                  */ 
/* Objetico...: Solicita ao CRM o valor de um parƒmetro Global do programa de Canais        */
/*                                                                                          */
/*    p-parametro poder  assumir os seguintes valores                                       */
/*    21: Porcentagem de VMC                                                                */
/*    22: Porcentagem de Stock Rotation                                                     */
/*    24: Porcentagem de Rebate para canais exclusivos                                      */
/*    29: Porcentagem de Rebate de P¢s-Venda                                                */
/*    37: Porcentagem de Rebate                                                             */
/*    39: Dias Inadimplˆncia                                                                */
/*    40: Cobertura de Stock Rotation                                                       */
/*                                                                                          */
/********************************************************************************************/

create widget-pool.
{esp/esb/out/msg0111.i}

DEFINE  INPUT  PARAM p-classificacao        AS CHAR NO-UNDO.
DEFINE  INPUT  PARAM p-compromisso          AS CHAR NO-UNDO.
DEFINE  INPUT  PARAM p-Categoria            AS CHAR NO-UNDO.
DEFINE  INPUT  PARAM p-Beneficio            AS CHAR NO-UNDO.
DEFINE  INPUT  PARAM p-TipoParametroGlobal  AS INT  NO-UNDO.
DEFINE  INPUT  PARAM p-CodigoNivelPosVenda  AS CHAR NO-UNDO.
DEFINE  INPUT  PARAM p-CodigoUnidadeNegocio AS CHAR NO-UNDO.
DEFINE OUTPUT  PARAM TABLE FOR resultado.
DEFINE OUTPUT  PARAM TABLE FOR msg0111r-ParametroGlobal.
               
DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0111
   data-relation for conteudo, msg0111 relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0111r, resultado, msg0111r-ParametroGlobal
   data-relation for conteudor, msg0111r relation-fields (idm, idm) nested
   data-relation for msg0111r, msg0111r-ParametroGlobal relation-fields (idm, idm) NESTED
   data-relation for msg0111r, resultado relation-fields (idm, idm) NESTED.       

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0111'.
     
create conteudo.
create msg0111.

ASSIGN msg0111.CodigoClassificacao  = p-classificacao      
       msg0111.CodigoCompromisso    = p-compromisso                  
       msg0111.CodigoCategoria      = p-categoria          
       msg0111.CodigoBeneficio      = p-beneficio          
       msg0111.TipoParametroGlobal  = p-TipoParametroGlobal
       msg0111.CodigoNivelPosVenda  = p-CodigoNivelPosVenda                  
       msg0111.CodigoUnidadeNegocio = p-CodigoUnidadeNegocio.
       cabecalho.NumeroOperacao     = STRING(p-TipoParametroGlobal).

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
