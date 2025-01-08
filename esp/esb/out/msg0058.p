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

FIND FIRST repres 
    WHERE repres.cod-rep =  tt-repres.cod-rep NO-LOCK NO-ERROR.

/*Definiá∆o da mensagem de envio de atualizaá∆o*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0058, EnderecoPrincipal
   DATA-RELATION FOR conteudo, msg0058 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0058, EnderecoPrincipal RELATION-FIELDS (idm, idm) NESTED.

/*Definiá∆o e leitura da mensagem de resposta da atualizaá∆o.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0058r, resultado
   DATA-RELATION FOR conteudor, msg0058r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0058r, resultado RELATION-FIELDS (idm, idm) NESTED.
         
CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0058'.
     
CREATE conteudo.
CREATE msg0058.

FOR EACH tt-repres NO-LOCK:
   ASSIGN cabecalho.NumeroOperacao = string(tt-repres.nome,"x(40)").

   ASSIGN msg0058.CodigoContato            = ?
          msg0058.CodigoCliente            = ?          
          msg0058.Canal                    = ?
          msg0058.TipoObjetoCanal          = ?
          msg0058.CodigoRepresentante      = tt-repres.cod-rep
          msg0058.NomeContato              = entry(1,tt-repres.nome," ")
          msg0058.SegundoNome              = ?
          msg0058.Sobrenome                = SUBSTRING(tt-repres.nome,LENGTH(entry(1,tt-repres.nome," ")) + 1,LENGTH(tt-repres.nome))
          msg0058.DescricaoContato         = ?
          msg0058.Email                    = tt-repres.e-mail
          msg0058.EmailAlternativo         = ?
          msg0058.Telefone                 = STRING(tt-repres.telefone[1],'X(15)')
          msg0058.Ramal                    = ?                    
          msg0058.TelefoneAlternativo      = ?
          msg0058.RamalTelefoneAlternativo = ?
          msg0058.Celular                  = string(tt-repres.telefone[2],'X(15)')
          msg0058.NomeAssistente           = ?
          msg0058.TelefoneAssistente       = ?
          msg0058.NomeGerente              = ?
          msg0058.TelefoneGerente          = ?
          msg0058.Fax                      = STRING(tt-repres.telefax,'X(15)')
          msg0058.RamalFax                 = ?
          msg0058.Area                     = ?
          msg0058.Cargo                    = ?
          msg0058.DescricaoCargo           = ?
          msg0058.Funcao                   = ?
          msg0058.MetodoEntrega            = ?
          msg0058.DataEspecial             = ?
          msg0058.SuspensaoCredito         = ?
          msg0058.Sexo                     = ?
          msg0058.TipoContato              = 993520007
          msg0058.TipoFrete                = ?
          msg0058.LimiteCredito            = ?
          msg0058.DataNascimento           = ?
          msg0058.Moeda                    = "Real"
          msg0058.ListaPreco               = "Lista Padr∆o"
          msg0058.Saudacao                 = ?
          msg0058.Formacao                 = ?
          msg0058.Escolaridade             = ?
          msg0058.EstadoCivil              = ?
          msg0058.Nacionalidade            = ?
          msg0058.Naturalidade             = ?
          msg0058.RG                       = ?
          msg0058.OrgaoExpeditor           = ?
          msg0058.Procuracao               = ?
          msg0058.TemFilhos                = ?
          msg0058.NomeFilhos               = ?
          msg0058.NumeroFilhos             = ?
          msg0058.Departamento             = ?
          msg0058.ClientePotencialOriginad = ?
          msg0058.ContatoNFE               = ?
          msg0058.NumeroContato            = ?
          msg0058.Proprietario             = ?
          msg0058.TipoProprietario         = ?
          msg0058.PapelCanal               = ?
          msg0058.Loja                     = ?
          msg0058.Situacao                 = IF AVAIL repres THEN 0 ELSE 1
          msg0058.Regiao                   = ?. 

   IF tt-repres.natureza = 1 THEN          
       ASSIGN msg0058.CPF                  = IF tt-repres.cgc <> "" THEN tt-repres.cgc ELSE ?
              msg0058.CNPJ                 = ?.
   ELSE                                    
       ASSIGN msg0058.CNPJ                 = IF tt-repres.cgc <> "" THEN tt-repres.cgc ELSE ?
              msg0058.CPF                  = ?.

   ASSIGN c-endereco = tt-repres.endereco.

   ASSIGN c-rua      = ""
          c-nro      = ""
          c-comp     = "".

   IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
       ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").

   RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
   RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                        OUTPUT c-rua, 
                                        OUTPUT c-nro, 
                                        OUTPUT c-comp).
   DELETE PROCEDURE h-cdapi704.
   CREATE EnderecoPrincipal.
   ASSIGN /*NomeEndereco*/   
          EnderecoPrincipal.TipoEndereco = 3
          EnderecoPrincipal.CaixaPostal  = tt-repres.caixa-postal 
          EnderecoPrincipal.CEP          = tt-repres.cep 
          EnderecoPrincipal.Logradouro   = string(c-rua,'X(35)')
          EnderecoPrincipal.Numero       = string(c-nro,'X(5)') 
          EnderecoPrincipal.Complemento  = c-comp
          EnderecoPrincipal.Bairro       = tt-repres.bairro
          EnderecoPrincipal.NomeCidade   = tt-repres.cidade 
          EnderecoPrincipal.Cidade       = tt-repres.cidade + "," + tt-repres.estado + "," + tt-repres.pais
          EnderecoPrincipal.UF           = IF tt-repres.estado <> "" THEN tt-repres.estado ELSE ?
          EnderecoPrincipal.Estado       = IF tt-repres.estado <> "" THEN tt-repres.pais + "," + tt-repres.estado ELSE ?
          EnderecoPrincipal.NomePais     = tt-repres.pais
          EnderecoPrincipal.Pais         = tt-repres.pais
          EnderecoPrincipal.NomeContato  = tt-repres.nome 
          EnderecoPrincipal.Telefone     = string(tt-repres.telefone[1],'X(15)') 
          EnderecoPrincipal.Fax          = string(tt-repres.telefax,'X(15)').
END.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

RETURN.
