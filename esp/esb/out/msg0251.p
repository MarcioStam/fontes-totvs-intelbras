/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0002 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0251
**  Objetivo: <comment>
**  Autor...: Carlos Daniel
**  Data....: 07/06/2016
*******************************************************************************/
CREATE WIDGET-POOL.

{esp/esb/out/msg0251.i}.
{esapi/esapi023.i}     /*ttItem*/

DEFINE INPUT  PARAMETER p-num-pedido AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER p-gera-ns    AS LOGICAL NO-UNDO.
DEFINE INPUT  PARAMETER p-gera-mac   AS LOGICAL NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR ItensConsulta.
DEFINE INPUT  PARAMETER TABLE FOR tt-erro-ns.
DEFINE INPUT  PARAMETER TABLE FOR tt-erro-mac.
DEFINE INPUT  PARAMETER TABLE FOR tt-lista-ns.
DEFINE INPUT  PARAMETER TABLE FOR tt-mac-address.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0251, ItensConsulta
    DATA-RELATION FOR conteudo, msg0251       RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR MSG0251,  ItensConsulta RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0251r, resultado
    DATA-RELATION FOR conteudor, msg0251r RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR msg0251r, resultado RELATION-FIELDS (idm, idm) NESTED.
                                                   
CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0251'
        cabecalho.NumeroOperacao   = STRING(p-num-pedido).
     
CREATE conteudo.
CREATE msg0251.

ASSIGN msg0251.NumeroPedidoCompra     = p-num-pedido
       msg0251.CadastrarSerialNumbers = p-gera-ns
       msg0251.CadastrarMacAddresses  = p-gera-mac.

FIND FIRST tt-erro-ns     NO-ERROR.
FIND FIRST tt-erro-mac    NO-ERROR.
FIND FIRST tt-lista-ns    NO-ERROR.
FIND FIRST tt-mac-address NO-ERROR.

IF AVAIL tt-erro-ns THEN DO:
    ASSIGN msg0251.SucessoSerialNumbers = NO.

    FOR EACH tt-erro-ns:
        ASSIGN msg0251.MensagemSerialNumbers = msg0251.MensagemSerialNumbers + (IF msg0251.MensagemSerialNumbers = "" THEN "" ELSE ";") + tt-erro-ns.mensagem.
    END.
END.

IF AVAIL tt-lista-ns THEN DO:
    ASSIGN msg0251.MensagemSerialNumbers = "NS gerado com sucesso."
           msg0251.SucessoSerialNumbers  = YES.
END.

IF msg0251.MensagemSerialNumbers = "" THEN
    ASSIGN msg0251.MensagemSerialNumbers = ?.

IF AVAIL tt-erro-mac THEN DO:
    ASSIGN msg0251.SucessoMacAddresses = NO.
    
    FOR EACH tt-erro-mac:
        ASSIGN msg0251.MensagemMacAddresses = msg0251.MensagemMacAddresses + (IF msg0251.MensagemMacAddresses = "" THEN "" ELSE ";") + tt-erro-mac.mensagem.
    END.
END.

IF AVAIL tt-mac-address THEN DO:
    ASSIGN msg0251.MensagemMacAddresses = "Mac Address gerado com sucesso."
           msg0251.SucessoMacAddresses  = YES.
END.

IF msg0251.MensagemMacAddresses = "" THEN
    ASSIGN msg0251.MensagemMacAddresses = ?.


/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}
/*define variable hDoc    as handle   no-undo.                                                          
create x-document hDoc.  
CREATE X-DOCUMENT hDoc.
hDoc:LOAD("longchar", oXML, NO).
hDoc:SAVE("file","C:/temp/xml-saida2" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").*/

RETURN.
