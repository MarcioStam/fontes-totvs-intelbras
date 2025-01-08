/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0058 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0058
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-repres LIKE repres.

{esp/esb/out/msg0058.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEFINE VARIABLE c-endereco          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rua               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-cdapi704          AS HANDLE      NO-UNDO.

CREATE tt-repres.
RAW-TRANSFER raw-param TO tt-repres.

/*Defini‡Æo da mensagem de envio de atualiza‡Æo*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0058
   DATA-RELATION FOR conteudo, msg0058 RELATION-FIELDS (idm, idm) NESTED.

/*Defini‡Æo e leitura da mensagem de resposta da atualiza‡Æo.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0058r, resultado
   DATA-RELATION FOR conteudor, msg0058r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0058r, resultado RELATION-FIELDS (idm, idm) NESTED.
         
CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0058'.
     
CREATE conteudo.
CREATE msg0058.

FOR EACH tt-repres NO-LOCK:
   ASSIGN /*msg0058.CodigoContato*/
          /*msg0058.CodigoCliente*/           
          /*msg0058.Canal*/
          /*msg0058.TipoObjetoCanal*/
          msg0058.CodigoRepresentante      = tt-repres.cod-rep
          msg0058.NomeContato              = tt-repres.nome
          /*msg0058.SegundoNome*/             
          /*msg0058.Sobrenome*/
          /*msg0058.DescricaoContato*/
          msg0058.Email                    = tt-repres.e-mail
          /*msg0058.EmailAlternativo*/
          msg0058.Telefone                 = tt-repres.telefone[1]
          /*msg0058.Ramal*/                    
          /*msg0058.TelefoneAlternativo*/
          /*msg0058.RamalTelefoneAlternativo*/
          /*msg0058.Celular*/
          /*msg0058.NomeAssistente*/
          /*msg0058.TelefoneAssistente*/
          /*msg0058.NomeGerente*/
          /*msg0058.TelefoneGerente*/
          msg0058.Fax                      = tt-repres.telefax
          /*msg0058.RamalFax*/
          /*msg0058.Area*/
          /*msg0058.Cargo*/
          /*msg0058.DescricaoCargo*/
          /*msg0058.Funcao*/
          /*msg0058.MetodoEntrega*/
          /*msg0058.DataEspecial*/
          /*msg0058.SuspensaoCredito*/
          /*msg0058.Sexo*/
          msg0058.TipoContato              = 993520007
          /*msg0058.TipoFrete*/
          /*msg0058.LimiteCredito*/
          /*msg0058.DataNascimento*/
          msg0058.Moeda                    = "Real"
          msg0058.ListaPreco               = "Lista PadrÆo"
          /*msg0058.Saudacao*/
          /*msg0058.Formacao*/
          /*msg0058.Escolaridade*/
          /*msg0058.EstadoCivil*/
          /*msg0058.Nacionalidade*/
          /*msg0058.Naturalidade*/
          /*msg0058.RG*/
          /*msg0058.OrgaoExpeditor*/
          msg0058.CPF                      = tt-repres.cgc
          msg0058.CNPJ                     = tt-repres.cgc
          /*msg0058.Procuracao*/
          /*msg0058.TemFilhos*/
          /*msg0058.NomeFilhos*/
          /*msg0058.NumeroFilhos*/
          /*msg0058.Departamento*/
          /*msg0058.ClientePotencialOriginad*/
          /*msg0058.ContatoNFE*/
          /*msg0058.NumeroContato*/
          /*msg0058.Proprietario*/
          /*msg0058.TipoProprietario*/
          /*msg0058.PapelCanal*/
          /*msg0058.Loja*/
          msg0058.Situacao                 = 1.

   ASSIGN c-endereco = tt-repres.endereco.

   ASSIGN c-rua      = ""
          c-nro      = ""
          c-comp     = "".

   IF  INDEX(c-endereco,CHR(ASC("§"))) > 0 THEN /* Retirar caracter especial */
       ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("§")),"").

   RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
   RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                        OUTPUT c-rua, 
                                        OUTPUT c-nro, 
                                        OUTPUT c-comp).
   DELETE PROCEDURE h-cdapi704.
   CREATE EnderecoPrincipal.
   ASSIGN /*NomeEndereco*/   
          TipoEndereco = 3
          CaixaPostal  = tt-repres.caixa-postal 
          CEP          = tt-repres.cep 
          Logradouro   = c-rua
          Numero       = c-nro
          Complemento  = c-comp
          Bairro       = tt-repres.bairro
          NomeCidade   = tt-repres.cidade 
          Cidade       = tt-repres.cidade
          UF           = tt-repres.estado 
          Estado       = tt-repres.estado
          NomePais     = tt-repres.pais
          Pais         = tt-repres.pais
          NomeContato  = tt-repres.nome 
          Telefone     = tt-repres.telefone[1] 
          Fax          = tt-repres.telefax.
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
