/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i MSG0191-out 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0191
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-loc-entr LIKE loc-entr
    FIELD situacao AS INTEGER.

{esp/esb/out/MSG0191-out.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEFINE VARIABLE i-TipoEndereco AS INT NO-UNDO.
DEFINE VARIABLE c-endereco     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rua          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-cdapi704     AS HANDLE      NO-UNDO.


CREATE tt-loc-entr.
RAW-TRANSFER raw-param TO tt-loc-entr.

/*Definiá∆o da mensagem de envio de atualizaá∆o*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0191
   DATA-RELATION FOR conteudo, MSG0191 RELATION-FIELDS (idm, idm) NESTED.

/*Definiá∆o e leitura da mensagem de resposta da atualizaá∆o.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0191r, resultado
   DATA-RELATION FOR conteudor, MSG0191r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0191r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0191'.
     
CREATE conteudo.
CREATE MSG0191.

FOR FIRST tt-loc-entr NO-LOCK
    , FIRST emitente NO-LOCK
          WHERE emitente.nome-abrev = tt-loc-entr.nome-abrev:

    ASSIGN cabecalho.NumeroOperacao = tt-loc-entr.cod-entrega + " / " + emitente.Nome-abrev.

    IF  emitente.endereco = tt-loc-entr.endereco THEN
        ASSIGN i-TipoEndereco = 3. /* Prim†rio */
    ELSE 
        IF  emitente.endereco-cob = tt-loc-entr.endereco THEN 
            ASSIGN i-TipoEndereco = 1. /* Cobranáa */
        ELSE
            ASSIGN i-TipoEndereco = 2. /* Entrega */

    ASSIGN MSG0191.NomeAbreviado         = tt-loc-entr.nome-abrev
           MSG0191.CodigoEntrega         = tt-loc-entr.cod-entrega
           MSG0191.CodigoCliente         = emitente.cod-emitente
           MSG0191.Situacao              = tt-loc-entr.situacao
           MSG0191.CodigoTaxa            = tt-loc-entr.cod-tax
           MSG0191.CodigoTipoEntrega     = tt-loc-entr.cod-tip-ent
           MSG0191.CpfCnpjCodEstrangeiro = tt-loc-entr.cgc
           MSG0191.InscricaoEstadual     = tt-loc-entr.ins-estadual
           MSG0191.Email                 = tt-loc-entr.e-mail
           MSG0191.TipoEndereco          = i-TipoEndereco
           MSG0191.NomeEndereco          = tt-loc-entr.endereco
           MSG0191.CaixaPostal           = tt-loc-entr.caixa-postal
           MSG0191.CEP                   = tt-loc-entr.cep.

    /* VERIFICA SE TEM O ENDEREÄO COMPLETO */
    FIND FIRST int-loc-entr NO-LOCK 
         WHERE int-loc-entr.nome-abrev  = tt-loc-entr.nome-abrev
           AND int-loc-entr.cod-entrega = tt-loc-entr.cod-entrega NO-ERROR.

    IF  AVAIL int-loc-entr AND trim(int-loc-entr.endereco-completo) <> "" THEN 
        ASSIGN c-endereco = int-loc-entr.endereco-completo.
    ELSE 
        ASSIGN c-endereco = tt-loc-entr.endereco.

    /* TRATAMENTO DO NÈMERO */
    ASSIGN c-rua      = ""
           c-nro      = ""
           c-comp     = "".
    
    RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
    RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                         OUTPUT c-rua, 
                                         OUTPUT c-nro, 
                                         OUTPUT c-comp).
    DELETE PROCEDURE h-cdapi704.

    ASSIGN MSG0191.NomeEndereco       = c-endereco   
           msg0191.Numero             = c-nro
           MSG0191.Complemento        = c-comp
           MSG0191.Bairro             = tt-loc-entr.bairro
           MSG0191.NomeCidade         = tt-loc-entr.cidade
           MSG0191.Cidade             = tt-loc-entr.cidade + "," + tt-loc-entr.estado + "," + tt-loc-entr.pais
           MSG0191.Estado             = tt-loc-entr.pais   + "," + tt-loc-entr.estado
           MSG0191.UF                 = tt-loc-entr.estado
           MSG0191.NomePais           = tt-loc-entr.pais
           MSG0191.Pais               = tt-loc-entr.pais
           MSG0191.Observacao         = tt-loc-entr.obs-entrega.

end.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN "OK".
