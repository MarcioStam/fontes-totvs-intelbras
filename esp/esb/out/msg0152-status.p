/********************************************************************************************/
/* Programa...: esp/esb/out/MSG0152-status.p - 5.159  REGISTRA_SOLICITACAO_VMC              */
/* Autor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 20/08/2014                                                                  */ 
/* Objetico...: Enviar o status de pagamento efetuado da solicita‡Æo                        */
/********************************************************************************************/

create widget-pool.
{esp/esb/out/msg0152-status.i}
{esp/esb/esesb000.i}
{esp/esb/esesbapi010-saldo.i1}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.
               
DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

RAW-TRANSFER raw-param TO MSG0152-status.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, MSG0152-status
   data-relation for conteudo, MSG0152-status relation-fields (idm, idm) nested.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, MSG0152-statusr, resultado 
   data-relation for conteudor, MSG0152-statusr                                       relation-fields (idm, idm) nested
   data-relation for MSG0152-statusr, resultado                                       relation-fields (idm, idm) NESTED.       


create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0152'.

create conteudo.

FIND FIRST MSG0152-status NO-LOCK NO-ERROR.

IF  NOT AVAIL MSG0152-status THEN
    RETURN.

DEF VAR c-emitente AS CHAR FORMAT "X(12)" NO-UNDO.
FIND int-solicitacao NO-LOCK
    WHERE int-solicitacao.CodigoSolicitacaoBeneficio = MSG0152-status.CodigoSolicitacaoBeneficio NO-ERROR.

DEF VAR c-identificador     AS CHAR NO-UNDO.
DEF VAR c-aux-identificador AS CHAR NO-UNDO.
DEF VAR i-cont              AS INT  NO-UNDO.

IF  AVAIL int-solicitacao THEN
    ASSIGN c-emitente          = TRIM(string(int-solicitacao.cod-emitente))
           c-identificador     = int-solicitacao.NomeSolicitacaoBeneficio.

IF  LENGTH(c-identificador) > 40 THEN DO:
    DO  i-cont = 1 TO LENGTH(c-identificador):
        IF  INDEX(" ",SUBSTR(c-identificador,i-cont,1)) > 0 THEN
            NEXT.
        ELSE
            ASSIGN c-aux-identificador = c-aux-identificador + SUBSTR(c-identificador,i-cont,1).
    END.

    ASSIGN c-identificador = c-aux-identificador.
END.

ASSIGN cabecalho.NumeroOperacao = c-identificador.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

/* define variable hDoc    as handle   no-undo.                                             */
/* create x-document hDoc.                                                                  */
/* hDoc:LOAD("longchar", iXML, NO).                                                         */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").  */

RETURN.

