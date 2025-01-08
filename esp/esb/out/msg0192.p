/*********************************************************************************************/
/* Programa...: esp/esb/out/MSG0192.p - 5.159                                                */
/* Autor......: Roger Marcelino Bruhn                                                        */
/* Data.......: 20/08/2014                                                                   */ 
/*********************************************************************************************/

create widget-pool.
{esp/esb/out/msg0192.i}
{esp/esb/esesb000.i}

DEF TEMP-TABLE tt-repres LIKE repres
    FIELD situacao AS INT.

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.
               
DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

RAW-TRANSFER raw-param TO tt-repres.

/*Definiá∆o da mensagem de envio de atualizaá∆o*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, MSG0192, MSG0192-endereco
   data-relation for conteudo, MSG0192          relation-fields (idm, idm) NESTED
   data-relation for MSG0192, msg0192-Endereco  relation-fields (idm, idm) NESTED. 

/*Definiá∆o e leitura da mensagem de resposta da atualizaá∆o.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, MSG0192-statusr, resultado 
   data-relation for conteudor, MSG0192-statusr                                       relation-fields (idm, idm) nested
   data-relation for MSG0192-statusr, resultado                                       relation-fields (idm, idm) NESTED.       


create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem = 'MSG0192'.

create conteudo.

FIND tt-repres NO-LOCK NO-ERROR.

IF  NOT CAN-FIND (FIRST tt-repres) THEN
    RETURN "OK".

ASSIGN cabecalho.NumeroOperacao = string(tt-repres.cod-emitente) + " / " + tt-repres.nome-abrev.

CREATE msg0192.
ASSIGN  msg0192.CodigoRepresentante = tt-repres.cod-rep
        msg0192.NomeRepresentante   = tt-repres.nome
        msg0192.NomeAbreviado       = tt-repres.nome-abrev.

CASE tt-repres.natureza:
    WHEN 1 THEN msg0192.natureza = 993520003.
    WHEN 2 THEN msg0192.natureza = 993520000.
    WHEN 3 THEN msg0192.natureza = 993520001.
    WHEN 4 THEN msg0192.natureza = 993520002.
END CASE.


ASSIGN msg0192.Situacao            = tt-repres.situacao
       msg0192.Email               = tt-repres.e-mail
       msg0192.Site                = tt-repres.home-page.

/* TRATAMENTO DO NÈMERO */
DEFINE VARIABLE i-TipoEndereco AS INT NO-UNDO.
DEFINE VARIABLE c-endereco     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rua          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-cdapi704     AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-valida       AS INTEGER     NO-UNDO.

/* IF  tt-repres.endereco = tt-loc-entr.endereco THEN  */
    ASSIGN i-TipoEndereco = 3. /* Prim†rio */
/* ELSE                                                       */
/*     IF  emitente.endereco-cob = tt-loc-entr.endereco THEN  */
/*         ASSIGN i-TipoEndereco = 1. /* Cobranáa */          */
/*     ELSE                                                   */
/*         ASSIGN i-TipoEndereco = 2. /* Entrega */           */

ASSIGN c-endereco = tt-repres.endereco
       c-rua      = ""
       c-nro      = ""
       c-comp     = "".

RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                     OUTPUT c-rua, 
                                     OUTPUT c-nro, 
                                     OUTPUT c-comp).

ASSIGN i-valida = INT(c-nro) NO-ERROR.

CREATE MSG0192-Endereco.

ASSIGN  MSG0192-Endereco.NomeEndereco   = tt-repres.endereco
        MSG0192-Endereco.TipoEndereco   = i-TipoEndereco
        MSG0192-Endereco.CaixaPostal    = tt-repres.Caixa-postal
        MSG0192-Endereco.CEP            = tt-repres.cep
        MSG0192-Endereco.Logradouro     = c-rua
        MSG0192-Endereco.Numero         = string(i-valida)
        MSG0192-Endereco.Complemento    = tt-repres.complemento
        MSG0192-Endereco.Bairro         = tt-repres.Bairro
        MSG0192-Endereco.NomeCidade     = tt-repres.cidade      
        MSG0192-Endereco.Cidade         = tt-repres.cidade + "," + tt-repres.estado + "," + tt-repres.pais      
        MSG0192-Endereco.UF             = tt-repres.estado       
        MSG0192-Endereco.Estado         = tt-repres.pais   + "," + tt-repres.estado  
        MSG0192-Endereco.NomePais       = tt-repres.pais       
        MSG0192-Endereco.Pais           = tt-repres.pais       
        MSG0192-Endereco.telefone       = tt-repres.telefone[1]
        MSG0192-Endereco.Fax            = tt-repres.teleFax.    

DEF VAR c-identificador AS CHAR NO-UNDO.

ASSIGN c-identificador = tt-repres.nome-abrev.

ASSIGN cabecalho.NumeroOperacao = c-identificador.

/* Grava o xml com o registro, conecta com o Barramento Pollux  */
/* e devolve a resposta.                                        */
{esp/esb/esesb003a.i}

/* define variable hDoc    as handle   no-undo.                                              */
/* create x-document hDoc.                                                                   */
/* hDoc:LOAD("longchar", iXML, NO).                                                          */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").   */
/*                                                                                           */
/* define variable hDoc1    as handle   no-undo.                                             */
/* create x-document hDoc1.                                                                  */
/* hDoc1:LOAD("longchar", oXML, NO).                                                         */
/* hDoc1:SAVE("file","C:/temp/oXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").  */


RETURN.

