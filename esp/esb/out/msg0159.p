/********************************************************************************************/
/* Programa...: esp/esb/out/msg0159.p - 5.159	ATUALIZAR_SALDO_BENEFICIO_CANAL             */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 20/08/2014                                                                  */ 
/* Objetico...: Enviar o saldo atualizado do canal para o CRM                               */
/********************************************************************************************/

create widget-pool.
{esp/esb/out/msg0159.i}
{esp/esb/esesb000.i}

DEFINE INPUT PARAM TABLE FOR msg0159.
DEFINE INPUT PARAM TABLE FOR msg0159-BeneficioCanalItens.
DEFINE INPUT PARAM TABLE FOR msg0159-BeneficioCanalItem.
DEFINE OUTPUT PARAM TABLE FOR resultado.
               
DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, MSG0159, msg0159-BeneficioCanalItens, msg0159-BeneficioCanalItem
   data-relation for conteudo, MSG0159                                       relation-fields (idm, idm) NESTED
   data-relation for MSG0159, msg0159-BeneficioCanalItens                    relation-fields (idm, idm) nested
   data-relation for msg0159-BeneficioCanalItens, msg0159-BeneficioCanalItem relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, MSG0159r, resultado 
   data-relation for conteudor, MSG0159r                                       relation-fields (idm, idm) nested
   data-relation for MSG0159r, resultado                                       relation-fields (idm, idm) NESTED.       


create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0159'.

create conteudo.

FIND FIRST MSG0159 NO-LOCK NO-ERROR.

IF  NOT AVAIL MSG0159 THEN
    RETURN.

FIND FIRST msg0159-BeneficioCanalItem NO-ERROR.

IF  AVAIL msg0159-BeneficioCanalItem THEN
    ASSIGN cabecalho.NumeroOperacao = msg0159-BeneficioCanalItem.CodigoBeneficioCanal.
ELSE
    ASSIGN cabecalho.NumeroOperacao = "msg0159".

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

/*
define variable hDoc    as handle   no-undo.
create x-document hDoc.
hDoc:LOAD("longchar", iXML, NO).
hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").
*/
RETURN.

