/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0082 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0082
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

create widget-pool.

DEFINE TEMP-TABLE tt-item LIKE ITEM.

{esp/esb/out/msg0082.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

RAW-TRANSFER raw-param TO tt-item.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

/*Definiá∆o da mensagem de envio de atualizaá∆o*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0082
   data-relation for conteudo, msg0082 relation-fields (idm, idm) nested.

/*Definiá∆o e leitura da mensagem de resposta da atualizaá∆o.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0082r, resultado
   data-relation for conteudor, msg0082r relation-fields (idm, idm) nested
   data-relation for msg0082r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0082'.
     
create conteudo.
create msg0082.


FOR FIRST tt-item:
    /*N∆o integra itens com familia em branco, itens de consumo e que a familia inicie com letras*/
    IF tt-item.fm-cod-com = "" 
    OR tt-item.fm-cod-com BEGINS "99"
    OR tt-item.fm-codigo > "A" THEN
        RETURN.

    ASSIGN msg0082.CodigoItemListaPreco = ?
           msg0082.Produto              = tt-item.it-codigo
           msg0082.ListaPreco           = "Lista Padr∆o":U
           msg0082.Valor                = 0
           msg0082.Porcentagem          = 0
           msg0082.ListaDesconto        = ?
           msg0082.MetodoPrecificacao   = 1
           msg0082.OpcaoVendaParcial    = 1
           msg0082.ValorArredondamento  = 0
           msg0082.OpcaoArredondamento  = 2
           msg0082.PoliticaArredondamento       = 1
           msg0082.Moeda                = "Real"
           msg0082.UnidadeMedida        = tt-item.un
           cabecalho.NumeroOperacao     = msg0082.Produto.
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
