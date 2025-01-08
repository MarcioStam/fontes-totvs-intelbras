/*****************************************************************************
*
* This file contains sample code which may assist you in creating applications.
* You may use the code as you see fit. If you modify the code or include it in
* another software program, you will refrain from identifying Progress Software
* as the supplier of the code, or using any Progress Software trademarks in 
* connection with your use of the code. THE CODE IS NOT SUPPORTED BY PROGRESS
* SOFTWARE AND IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, INCLUDING,
* WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
* PURPOSE OR NONINFRINGEMENT.
*
*******************************************************************************/

/*------------------------------------------------------------------------
  File: soaptest.p

  Description: This procedure does the translation from XML to an AppServer
  call. This has to be handcoded for each AppServer call exported as SOAP.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: David Cleary

  Version: 0.1
------------------------------------------------------------------------*/
{soap/xmlutil.i}
{soap/soap-xml.i}
{include/i-freeac.i}

define variable hutil as handle no-undo.
run soap/xmlutil.p persistent set hutil.

define variable hhtml as handle no-undo.
run html-util.p persistent set hhtml.

procedure process-soap-request:

    define input parameter soap-application-name as character no-undo.
    define input parameter soap-element as handle no-undo.
    define output parameter soap-response as handle no-undo.

    define variable soap-procedure as handle no-undo.
    define variable soap-response-text as character no-undo.
    define variable soap-memptr as memptr no-undo.
    define variable i as integer no-undo.
    define variable j as integer no-undo.
    define variable found as integer no-undo.
    define variable ret as logical no-undo.
    define variable aname as character no-undo.
    define variable anames as character no-undo.
    define variable ns-prefix as character no-undo.
    define variable ns-uri as character no-undo.

    create x-document soap-response.
    create x-noderef soap-procedure.

    /* This is the template we use to wrap our response. */
    soap-response-text = 
    "<?xml version='1.0' ?>
     <SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'
     SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'>~n
     <SOAP-ENV:Body>~n
     </SOAP-ENV:Body>~n
     </SOAP-ENV:Envelope>".
    set-size(soap-memptr) = length(soap-response-text) + 1.
    put-string(soap-memptr, 1) = soap-response-text.
    soap-response:load("memptr", soap-memptr, false).

    /* Get the procedure we want to call */
    repeat i = 1 to soap-element:num-children:
        ret = soap-element:get-child(soap-procedure, i).
        if (ret = true) and (soap-procedure:subtype = "element") then do:
            /* Loop through our attributes looking for xmlns */
            anames = soap-procedure:attribute-names.
            repeat j = 1 to num-entries(anames):
                aname = entry(j,anames).
                /* This is looking for our namespace URI and prefix */
                if index(aname, "xmlns") = 1 then do:
                    found = index(aname, ":").
                    if found > 0 then
                        ns-prefix = substring(aname, found + 1) + ":".
                    else
                        ns-prefix = "".
                    ns-uri = soap-procedure:get-attribute(aname).
                end.
            end.

            /* Here we statically look at our element name to determine what
             * AppServer procedure to call.
             */
            if soap-procedure:name = ns-prefix + "login-usuario" then
               run process-login-usuario(input soap-application-name, input soap-procedure, input ns-prefix, input-output soap-response).
            else if soap-procedure:name = ns-prefix + "cria-usuario" then
               run process-cria-usuario(input soap-application-name, input soap-procedure, input ns-prefix, input-output soap-response).
            else if soap-procedure:name = ns-prefix + "altera-usuario" then
               run process-altera-usuario(input soap-application-name, input soap-procedure, input ns-prefix, input-output soap-response).
            else if soap-procedure:name = ns-prefix + "esqueci-senha" then
               run process-esqueci-senha(input soap-application-name, input soap-procedure, input ns-prefix, input-output soap-response).
            else if soap-procedure:name = ns-prefix + "saldo-pontos" then
               run process-saldo-pontos(input soap-application-name, input soap-procedure, input ns-prefix, input-output soap-response).
            else if soap-procedure:name = ns-prefix + "cadastro-produto" then
               run process-cadastro-produto(input soap-application-name, input soap-procedure, input ns-prefix, input-output soap-response).
            else if soap-procedure:name = ns-prefix + "lista-tabela-pontos" then
               run process-lista-tabela-pontos(input soap-application-name, input soap-procedure, input ns-prefix, input-output soap-response).
            else if soap-procedure:name = ns-prefix + "lista-usuario" then
               run process-lista-usuario(input soap-application-name, input soap-procedure, input ns-prefix, input-output soap-response).
            else if soap-procedure:name = ns-prefix + "lista-tabela-premios" then
               run process-lista-tabela-premios(input soap-application-name, input soap-procedure, input ns-prefix, input-output soap-response).
            else if soap-procedure:name = ns-prefix + "cria-resgate" then
               run process-cria-resgate(input soap-application-name, input soap-procedure, input ns-prefix, input-output soap-response).
            else if soap-procedure:name = ns-prefix + "lista-cidades" then
               run process-lista-cidades(input soap-application-name, input soap-procedure, input ns-prefix, input-output soap-response).
        end.
    end.

    /* Clean up */
    delete object soap-procedure.
    delete procedure hutil.

    delete procedure hhtml.

    return.
end procedure.

procedure process-login-usuario:
   define input param appservice             as character no-undo.
   define input param soap-procedure         as handle    no-undo.
   define input param ns-prefix              as character no-undo.
   define input-output param soap-response   as handle    no-undo.

   define variable happ       as handle    no-undo.
   define variable rspNode    as handle    no-undo.
   define variable xmlParam   as handle    no-undo.
   define variable xmlText    as handle    no-undo.

   define variable hDoc       as handle    no-undo.
   define variable hCustRoot  as handle    no-undo.
   define variable hCustNode  as handle    no-undo.
   define variable hOrdRoot   as handle    no-undo.
   define variable hOrdNode   as handle    no-undo.
   define variable hField     as handle    no-undo.
   define variable hText      as handle    no-undo.
   define variable hBuf       as handle    no-undo.
   define variable hDBFld     as handle    no-undo.
   define variable i          as integer   no-undo.

   /* Variaveis referentes aos campos */
   define variable c-login    as character no-undo.
   define variable c-senha    as character no-undo case-sensitive.

   /* Create our handles */
   create server happ.
   create x-noderef rspNode.
   create x-noderef xmlParam.
   create x-noderef xmlText.
   create x-noderef hOrdRoot.
   create x-noderef hOrdNode.

   /** Variaveis para o SAX **/
   define variable hParser  as handle.
   define variable hHandler as handle.

   create sax-reader hParser.

   /** Procedures de callback para o SAX **/
   run soap/soap-xml.p persistent set hHandler.

   hParser:handler = hHandler.
   hParser:set-input-source("HANDLE", web-context).
   hParser:sax-parse() no-error.

   run retorna-tt in hHandler (output table tt-xml).
   run Cleanup    in hHandler.

   /** Apaga da memoria o objeto e procedure do SAX **/
   delete object hParser.
   delete procedure hHandler.

   for each tt-xml no-lock:
      case tt-xml.elementName:
         when "login" then
            c-login = tt-xml.elementValue.
         when "senha" then
            c-senha = tt-xml.elementValue.
      end case.
   end.

   soap-response:get-document-element(rspNode).
   run getElementsByTagName in hutil(input rspNode, 'SOAP-ENV:Body', output table ttElements).
   find first ttElements.

   find first usuario-fidelidade no-lock
      where usuario-fidelidade.login = trim(c-login) no-error.

   if not available (usuario-fidelidade) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "25".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Usuario nao encontrado".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else if (usuario-fidelidade.senha <> encode(c-senha)) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "21".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Senha incorreta".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else if not (usuario-fidelidade.ativo) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "22".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Usuario inativo".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else if (usuario-fidelidade.senha = encode(trim(c-senha))) then do:
      /** Cria o cabecalho de resposta **/
      soap-response:create-node(rspNode, "m:login-response", "ELEMENT").
      rspNode:set-attribute("xmlns:m", "urn:x-progress-1.0:login-response").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(hOrdNode,"login","ELEMENT").
      rspNode:append-child(hOrdNode).

      hOrdNode:set-attribute("ativo", (if usuario-fidelidade.ativo then "true" else "false")) no-error.

      soap-response:create-node(xmlParam, "login", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.login no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "nome", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.nome no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).
   
      soap-response:create-node(xmlParam, "cpf-cnpj", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.cpf-cnpj no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).
   
      soap-response:create-node(xmlParam, "e-mail", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.e-mail no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).
   end.

   /* Clean up */
   delete object xmlText.
   delete object xmlParam.
   delete object rspNode.
   delete object happ.

end procedure.

procedure process-cria-usuario:
   define input param appservice             as character no-undo.
   define input param soap-procedure         as handle    no-undo.
   define input param ns-prefix              as character no-undo.
   define input-output param soap-response   as handle    no-undo.

   define variable happ       as handle    no-undo.
   define variable rspNode    as handle    no-undo.
   define variable xmlParam   as handle    no-undo.
   define variable xmlText    as handle    no-undo.

   define variable hDoc       as handle    no-undo.
   define variable hCustRoot  as handle    no-undo.
   define variable hCustNode  as handle    no-undo.
   define variable hOrdRoot   as handle    no-undo.
   define variable hOrdNode   as handle    no-undo.
   define variable hField     as handle    no-undo.
   define variable hText      as handle    no-undo.
   define variable hBuf       as handle    no-undo.
   define variable hDBFld     as handle    no-undo.
   define variable i          as integer   no-undo.

   /* Variaveis referentes aos campos */
   define variable c-login       as character   no-undo.
   define variable c-senha       as character   no-undo case-sensitive.
   define variable c-email       as character   no-undo.
   define variable c-nome        as character   no-undo.
   define variable c-cpf-cnpj    as character   no-undo.
   define variable c-empresa     as character   no-undo.
   define variable c-endereco    as character   no-undo.
   define variable c-bairro      as character   no-undo.
   define variable c-cidade      as character   no-undo.
   define variable c-uf          as character   no-undo.
   define variable c-cep         as character   no-undo.
   define variable c-telefone-1  as character   no-undo.
   define variable c-telefone-2  as character   no-undo.
   define variable c-mailing     as character   no-undo.
   define variable c-revenda     as character   no-undo.
/*    define variable c-atuacao     as character   no-undo. */
   define variable c-dealers     as character   no-undo.
   define variable c-telecom     as character   no-undo.
   define variable c-seguran     as character   no-undo.
   define variable c-inform      as character   no-undo.

   /* Create our handles */
   create server happ.
   create x-noderef rspNode.
   create x-noderef xmlParam.
   create x-noderef xmlText.
   create x-noderef hOrdRoot.
   create x-noderef hOrdNode.

   /** Variaveis para o SAX **/
   define variable hParser  as handle.
   define variable hHandler as handle.

   create sax-reader hParser.

   /** Procedures de callback para o SAX **/
   run soap/soap-xml.p persistent set hHandler.

   hParser:handler = hHandler.
   hParser:set-input-source("HANDLE", web-context).
   hParser:sax-parse() no-error.

   run retorna-tt in hHandler (output table tt-xml).
   run Cleanup    in hHandler.

   /** Apaga da memoria o objeto e procedure do SAX **/
   delete object hParser.
   delete procedure hHandler.

   for each tt-xml no-lock:
      case tt-xml.elementName:
         when "login" then
            c-login = tt-xml.elementValue.
         when "nome" then
            c-nome = tt-xml.elementValue.
         when "senha" then
            c-senha = tt-xml.elementValue.
         when "cpf-cnpj" then
            c-cpf-cnpj = tt-xml.elementValue.
         when "email" then
            c-email = tt-xml.elementValue.
         when "empresa" then
            c-empresa = tt-xml.elementValue.
         when "endereco" then
            c-endereco = tt-xml.elementValue.
         when "bairro" then
            c-bairro = tt-xml.elementValue.
         when "cidade" then
            c-cidade = tt-xml.elementValue.
         when "uf" then
            c-uf = tt-xml.elementValue.
         when "cep" then
            c-cep = tt-xml.elementValue.
         when "telefone-1" then
            c-telefone-1 = tt-xml.elementValue.
         when "telefone-2" then
            c-telefone-2 = tt-xml.elementValue.
         when "mailing" then
            c-mailing = tt-xml.elementValue.
         when "revenda" then
            c-revenda = tt-xml.elementValue.
         /*when "atuacao" then
            c-atuacao = tt-xml.elementValue.*/
         when "dealers" then
            c-dealers = tt-xml.elementValue.
         when "telecom" then
            c-telecom = tt-xml.elementValue.
         when "seguran" then
            c-seguran = tt-xml.elementValue.
         when "inform" then
            c-inform = tt-xml.elementValue.
      end case.
   end.

   soap-response:get-document-element(rspNode).
   run getElementsByTagName in hutil(input rspNode, 'SOAP-ENV:Body', output table ttElements).
   find first ttElements.

   assign c-cpf-cnpj = replace(replace(replace(c-cpf-cnpj, '.', ''), '-', ''), '/', '')
          c-cep      = replace(replace(c-cep, '.', ''), '-', '').

   if can-find (first usuario-fidelidade
                where usuario-fidelidade.cpf-cnpj = trim(c-cpf-cnpj)) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "11".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "CPF/CNPJ ja cadastrado".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else if can-find (first usuario-fidelidade
                     where usuario-fidelidade.login = trim(c-login)) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "12".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Login ja cadastrado".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else if can-find (first usuario-fidelidade
                     where usuario-fidelidade.e-mail = lower(trim(c-email))) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "13".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "e-mail ja cadastrado".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else do:
      /** Cria o registro do usuario **/
      do transaction:
         assign c-login    = fn-free-accent(c-login)
                c-nome     = fn-free-accent(c-nome)
                c-email    = fn-free-accent(c-email)
                c-empresa  = fn-free-accent(c-empresa)
                c-endereco = fn-free-accent(c-endereco)
                c-bairro   = fn-free-accent(c-bairro)
                c-cidade   = fn-free-accent(c-cidade)
                c-dealers  = fn-free-accent(c-dealers).

         create usuario-fidelidade.
         assign usuario-fidelidade.cpf-cnpj    = trim(c-cpf-cnpj)
                usuario-fidelidade.login       = trim(lower(c-login))
                usuario-fidelidade.nome        = trim(upper(c-nome))
                usuario-fidelidade.senha       = encode(trim(c-senha))
                usuario-fidelidade.e-mail      = trim(lower(c-email))
                usuario-fidelidade.empresa     = trim(upper(c-empresa))
                usuario-fidelidade.endereco    = trim(upper(c-endereco))
                usuario-fidelidade.bairro      = trim(upper(c-bairro))
                usuario-fidelidade.cidade      = trim(upper(c-cidade))
                usuario-fidelidade.uf          = trim(upper(c-uf))
                usuario-fidelidade.cep         = trim(upper(c-cep))
                usuario-fidelidade.telefone[1] = trim(upper(c-telefone-1))
                usuario-fidelidade.telefone[2] = trim(upper(c-telefone-2))
                usuario-fidelidade.mailing     = (if c-mailing = 'true' then yes else no)
                usuario-fidelidade.id-revenda  = int(trim(c-revenda))
                /*usuario-fidelidade.id-atuacao  = int(trim(c-atuacao))*/
                usuario-fidelidade.dealers     = trim(upper(c-dealers))
                usuario-fidelidade.l-telecom   = (if c-telecom = 'true' then yes else no)
                usuario-fidelidade.l-seguran   = (if c-seguran = 'true' then yes else no)
                usuario-fidelidade.l-inform    = (if c-inform  = 'true' then yes else no).
      end.

      /** Cria o cabecalho de resposta **/
      soap-response:create-node(rspNode, "m:cria-usuario-response", "ELEMENT").
      rspNode:set-attribute("xmlns:m", "urn:x-progress-1.0:cria-usuario").
      rspNode:set-attribute("xmlns:rpc", "http://www.w3.org/2001/09/soap-rpc").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(hOrdNode,"rpc:result","ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "OK".
      hOrdNode:append-child(xmlText).
      rspNode:append-child(hOrdNode).
   end.

   /* Clean up */
   delete object xmlText.
   delete object xmlParam.
   delete object rspNode.
   delete object happ.

end procedure.

procedure process-altera-usuario:
   define input param appservice             as character no-undo.
   define input param soap-procedure         as handle    no-undo.
   define input param ns-prefix              as character no-undo.
   define input-output param soap-response   as handle    no-undo.

   define variable happ       as handle    no-undo.
   define variable rspNode    as handle    no-undo.
   define variable xmlParam   as handle    no-undo.
   define variable xmlText    as handle    no-undo.

   define variable hDoc       as handle    no-undo.
   define variable hCustRoot  as handle    no-undo.
   define variable hCustNode  as handle    no-undo.
   define variable hOrdRoot   as handle    no-undo.
   define variable hOrdNode   as handle    no-undo.
   define variable hField     as handle    no-undo.
   define variable hText      as handle    no-undo.
   define variable hBuf       as handle    no-undo.
   define variable hDBFld     as handle    no-undo.
   define variable i          as integer   no-undo.

   /* Variaveis referentes aos campos */
   define variable c-senha       as character   no-undo case-sensitive.
   define variable c-email       as character   no-undo.
   define variable c-nome        as character   no-undo.
   define variable c-cpf-cnpj    as character   no-undo.
   define variable c-empresa     as character   no-undo.
   define variable c-endereco    as character   no-undo.
   define variable c-bairro      as character   no-undo.
   define variable c-cidade      as character   no-undo.
   define variable c-uf          as character   no-undo.
   define variable c-cep         as character   no-undo.
   define variable c-telefone-1  as character   no-undo.
   define variable c-telefone-2  as character   no-undo.
   define variable c-revenda     as character   no-undo.
   /*define variable c-atuacao     as character   no-undo.*/
   define variable c-dealers     as character   no-undo.
   define variable c-telecom     as character   no-undo.
   define variable c-seguran     as character   no-undo.
   define variable c-inform      as character   no-undo.

   /* Create our handles */
   create server happ.
   create x-noderef rspNode.
   create x-noderef xmlParam.
   create x-noderef xmlText.
   create x-noderef hOrdRoot.
   create x-noderef hOrdNode.

   /** Variaveis para o SAX **/
   define variable hParser  as handle.
   define variable hHandler as handle.

   create sax-reader hParser.

   /** Procedures de callback para o SAX **/
   run soap/soap-xml.p persistent set hHandler.

   hParser:handler = hHandler.
   hParser:set-input-source("HANDLE", web-context).
   hParser:sax-parse() no-error.

   run retorna-tt in hHandler (output table tt-xml).
   run Cleanup    in hHandler.

   /** Apaga da memoria o objeto e procedure do SAX **/
   delete object hParser.
   delete procedure hHandler.

   for each tt-xml no-lock:
      case tt-xml.elementName:
         when "nome" then
            c-nome = tt-xml.elementValue.
         when "senha" then
            c-senha = tt-xml.elementValue.
         when "cpf-cnpj" then
            c-cpf-cnpj = tt-xml.elementValue.
         when "email" then
            c-email = tt-xml.elementValue.
         when "empresa" then
            c-empresa = tt-xml.elementValue.
         when "endereco" then
            c-endereco = tt-xml.elementValue.
         when "bairro" then
            c-bairro = tt-xml.elementValue.
         when "cidade" then
            c-cidade = tt-xml.elementValue.
         when "uf" then
            c-uf = tt-xml.elementValue.
         when "cep" then
            c-cep = tt-xml.elementValue.
         when "telefone-1" then
            c-telefone-1 = tt-xml.elementValue.
         when "telefone-2" then
            c-telefone-2 = tt-xml.elementValue.
         when "revenda" then
            c-revenda = tt-xml.elementValue.
         /*when "atuacao" then
            c-atuacao = tt-xml.elementValue.*/
         when "dealers" then
            c-dealers = tt-xml.elementValue.
         when "telecom" then
            c-telecom = tt-xml.elementValue.
         when "seguran" then
            c-seguran = tt-xml.elementValue.
         when "inform" then
            c-inform = tt-xml.elementValue.
      end case.
   end.

   soap-response:get-document-element(rspNode).
   run getElementsByTagName in hutil(input rspNode, 'SOAP-ENV:Body', output table ttElements).
   find first ttElements.

   assign c-cpf-cnpj = replace(replace(replace(c-cpf-cnpj, '.', ''), '-', ''), '/', '')
          c-cep      = replace(replace(c-cep, '.', ''), '-', '').

   find first usuario-fidelidade no-lock
      where usuario-fidelidade.cpf-cnpj = trim(c-cpf-cnpj) no-error.

   if not available (usuario-fidelidade) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "25".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Usuario nao encontrado".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else do:
      do transaction:
         find current usuario-fidelidade exclusive-lock.

         assign c-nome     = fn-free-accent(c-nome)
                c-email    = fn-free-accent(c-email)
                c-empresa  = fn-free-accent(c-empresa)
                c-endereco = fn-free-accent(c-endereco)
                c-bairro   = fn-free-accent(c-bairro)
                c-cidade   = fn-free-accent(c-cidade)
                c-dealers  = fn-free-accent(c-dealers).
         
         if (trim(c-nome) <> '') and (trim(c-nome) <> usuario-fidelidade.nome) then
            assign usuario-fidelidade.nome = trim(upper(c-nome)).
         if (trim(c-senha) <> '') and (encode(trim(c-senha)) <> usuario-fidelidade.senha) then
            assign usuario-fidelidade.senha = encode(trim(c-senha)).
         if (trim(c-email) <> '') and (lower(trim(c-email)) <> usuario-fidelidade.e-mail) then
            assign usuario-fidelidade.e-mail = trim(lower(c-email)).
         if (trim(c-empresa) <> '') and (trim(c-empresa) <> usuario-fidelidade.empresa) then
            assign usuario-fidelidade.empresa = trim(upper(c-empresa)).
         if (trim(c-endereco) <> '') and (trim(c-endereco) <> usuario-fidelidade.endereco) then
            assign usuario-fidelidade.endereco = trim(upper(c-endereco)).
         if (trim(c-bairro) <> '') and (trim(c-bairro) <> usuario-fidelidade.bairro) then
            assign usuario-fidelidade.bairro = trim(upper(c-bairro)).
         if (trim(c-cidade) <> '') and (trim(c-cidade) <> usuario-fidelidade.cidade) then
            assign usuario-fidelidade.cidade = trim(upper(c-cidade)).
         if (trim(c-uf) <> '') and (trim(c-uf) <> usuario-fidelidade.uf) then
            assign usuario-fidelidade.uf = trim(upper(c-uf)).
         if (trim(c-cep) <> '') and (trim(c-cep) <> usuario-fidelidade.cep) then
            assign usuario-fidelidade.cep = trim(upper(c-cep)).
         if (trim(c-telefone-1) <> '') and (trim(c-telefone-1) <> usuario-fidelidade.telefone[1]) then
            assign usuario-fidelidade.telefone[1] = trim(upper(c-telefone-1)).
         if (trim(c-telefone-2) <> '') and (trim(c-telefone-2) <> usuario-fidelidade.telefone[2]) then
            assign usuario-fidelidade.telefone[2] = trim(upper(c-telefone-2)).
         if (trim(c-revenda) <> '') and (int(trim(c-revenda)) <> usuario-fidelidade.id-revenda) then
            assign usuario-fidelidade.id-revenda = int(trim(upper(c-revenda))).
         if (trim(c-telecom) <> '') and ((c-telecom = 'true'  and usuario-fidelidade.l-telecom = no)   or 
                                         (c-telecom = 'false' and usuario-fidelidade.l-telecom = yes)) then
            assign usuario-fidelidade.l-telecom = if trim(c-telecom) = 'true' then yes else no.
         if (trim(c-seguran) <> '') and ((c-seguran = 'true'  and usuario-fidelidade.l-seguran = no)   or 
                                         (c-seguran = 'false' and usuario-fidelidade.l-seguran = yes)) then
            assign usuario-fidelidade.l-seguran = if trim(c-seguran) = 'true' then yes else no.
         if (trim(c-inform) <> '') and ((c-inform = 'true'  and usuario-fidelidade.l-inform = no)   or 
                                        (c-inform = 'false' and usuario-fidelidade.l-inform = yes)) then
            assign usuario-fidelidade.l-inform = if trim(c-inform) = 'true' then yes else no.
         if (trim(c-dealers) <> '') and (trim(c-dealers) <> usuario-fidelidade.dealers) then
            assign usuario-fidelidade.dealer = trim(upper(c-dealers)).

         assign usuario-fidelidade.dt-ult-modific = today.

         /** Cria o cabecalho de resposta **/
         soap-response:create-node(rspNode, "m:altera-usuario-response", "ELEMENT").
         rspNode:set-attribute("xmlns:m", "urn:x-progress-1.0:altera-usuario").
         ttElements.nhandle:append-child(rspNode).
   
         soap-response:create-node(hOrdNode,"login","ELEMENT").
         rspNode:append-child(hOrdNode).

         hOrdNode:set-attribute("ativo", (if usuario-fidelidade.ativo then "true" else "false")) no-error.

         soap-response:create-node(xmlParam, "login", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = usuario-fidelidade.login no-error.
         xmlParam:append-child(xmlText).
         hOrdNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "nome", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = usuario-fidelidade.nome no-error.
         xmlParam:append-child(xmlText).
         hOrdNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "cpf-cnpj", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = usuario-fidelidade.cpf-cnpj no-error.
         xmlParam:append-child(xmlText).
         hOrdNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "e-mail", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = usuario-fidelidade.e-mail no-error.
         xmlParam:append-child(xmlText).
         hOrdNode:append-child(xmlParam).
         
         release usuario-fidelidade.

      end.
   end.

   /* Clean up */
   delete object xmlText.
   delete object xmlParam.
   delete object rspNode.
   delete object happ.

end procedure.

procedure process-esqueci-senha:
   define input param appservice             as character no-undo.
   define input param soap-procedure         as handle    no-undo.
   define input param ns-prefix              as character no-undo.
   define input-output param soap-response   as handle    no-undo.

   define variable happ       as handle    no-undo.
   define variable rspNode    as handle    no-undo.
   define variable xmlParam   as handle    no-undo.
   define variable xmlText    as handle    no-undo.

   define variable hDoc       as handle    no-undo.
   define variable hCustRoot  as handle    no-undo.
   define variable hCustNode  as handle    no-undo.
   define variable hOrdRoot   as handle    no-undo.
   define variable hOrdNode   as handle    no-undo.
   define variable hField     as handle    no-undo.
   define variable hText      as handle    no-undo.
   define variable hBuf       as handle    no-undo.
   define variable hDBFld     as handle    no-undo.
   define variable i          as integer   no-undo.

   /* Variaveis referentes aos campos */
   define variable c-login    as character no-undo.
   define variable c-senha    as character no-undo case-sensitive.
   define variable c-cpf-cnpj as character no-undo.
   define variable c-array    as character no-undo extent 36
      init [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
             "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1",
             "2", "3", "4", "5", "6", "7", "8", "9" ].

   /* Create our handles */
   create server happ.
   create x-noderef rspNode.
   create x-noderef xmlParam.
   create x-noderef xmlText.
   create x-noderef hOrdRoot.
   create x-noderef hOrdNode.

   /** Variaveis para o SAX **/
   define variable hParser  as handle.
   define variable hHandler as handle.

   create sax-reader hParser.

   /** Procedures de callback para o SAX **/
   run soap/soap-xml.p persistent set hHandler.

   hParser:handler = hHandler.
   hParser:set-input-source("HANDLE", web-context).
   hParser:sax-parse() no-error.

   run retorna-tt in hHandler (output table tt-xml).
   run Cleanup    in hHandler.

   /** Apaga da memoria o objeto e procedure do SAX **/
   delete object hParser.
   delete procedure hHandler.

   for each tt-xml no-lock:
      case tt-xml.elementName:
         when "login" then
            c-login = tt-xml.elementValue.
         when "cpf-cnpj" then
            c-cpf-cnpj = tt-xml.elementValue.
      end case.
   end.

   soap-response:get-document-element(rspNode).
   run getElementsByTagName in hutil(input rspNode, 'SOAP-ENV:Body', output table ttElements).
   find first ttElements.

   find first usuario-fidelidade no-lock
      where usuario-fidelidade.login = trim(c-login) no-error.

   if not available (usuario-fidelidade) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "25".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Usuario nao encontrado".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else if (usuario-fidelidade.cpf-cnpj <> trim(c-cpf-cnpj)) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "23".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "CPF/CNPJ incorreto".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else do:
      do transaction:
         find current usuario-fidelidade exclusive-lock.

         assign c-senha                  = c-array[random(1,36)] + c-array[random(1,36)] + c-array[random(1,36)] + 
                                           c-array[random(1,36)] + c-array[random(1,36)] + c-array[random(1,36)]
                usuario-fidelidade.senha = encode(c-senha).

         find current usuario-fidelidade no-lock.
      end.

      /** Cria o cabecalho de resposta **/
      soap-response:create-node(rspNode, "m:esqueci-senha-response", "ELEMENT").
      rspNode:set-attribute("xmlns:m", "urn:x-progress-1.0:esqueci-senha-response").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(hOrdNode,"login","ELEMENT").
      rspNode:append-child(hOrdNode).

      soap-response:create-node(xmlParam, "nome", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.nome no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "e-mail", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.e-mail no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "senha", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = c-senha no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).
   end.

   /* Clean up */
   delete object xmlText.
   delete object xmlParam.
   delete object rspNode.
   delete object happ.

end procedure.

define temp-table tt-saldo no-undo
   field data-movto  like pontos-fidelidade.data-movto
   field id-movto    like pontos-fidelidade.id-movto
   field pontos      like pontos-fidelidade.pontos
   field descricao   like item.desc-nacional
   field dealer      like pontos-fidelidade.dealer
   FIELD ptos-disp   AS DECIMAL
   FIELD expirado    AS LOGICAL
   FIELD tabela      AS CHARACTER
   FIELD r-rowid     AS ROWID
   index ch-pri is primary data-movto.

procedure process-saldo-pontos:
   define input param appservice             as character no-undo.
   define input param soap-procedure         as handle    no-undo.
   define input param ns-prefix              as character no-undo.
   define input-output param soap-response   as handle    no-undo.

   define variable happ       as handle    no-undo.
   define variable rspNode    as handle    no-undo.
   define variable xmlParam   as handle    no-undo.
   define variable xmlText    as handle    no-undo.

   define variable hDoc       as handle    no-undo.
   define variable hCustRoot  as handle    no-undo.
   define variable hCustNode  as handle    no-undo.
   define variable hOrdRoot   as handle    no-undo.
   define variable hOrdNode   as handle    no-undo.
   define variable hDetNode   as handle    no-undo.
   define variable hField     as handle    no-undo.
   define variable hText      as handle    no-undo.
   define variable hBuf       as handle    no-undo.
   define variable hDBFld     as handle    no-undo.
   define variable i          as integer   no-undo.

   /* Variaveis referentes aos campos */
   define variable c-login    as character no-undo.
   define variable c-cpf-cnpj as character no-undo.
   define variable dt-inicial as date      no-undo.
   define variable dt-final   as date      no-undo.
   define variable de-saldo   as decimal   no-undo.
   define variable de-resgate as decimal   no-undo.
   define variable de-avencer as decimal   no-undo.
   define variable dt-avencer as date      no-undo.
   define variable de-vencido as decimal   no-undo.


   /* Create our handles */
   create server happ.
   create x-noderef rspNode.
   create x-noderef xmlParam.
   create x-noderef xmlText.
   create x-noderef hOrdRoot.
   create x-noderef hOrdNode.
   create x-noderef hDetNode.

   /** Variaveis para o SAX **/
   define variable hParser  as handle.
   define variable hHandler as handle.

   create sax-reader hParser.

   /** Procedures de callback para o SAX **/
   run soap/soap-xml.p persistent set hHandler.

   hParser:handler = hHandler.
   hParser:set-input-source("HANDLE", web-context).
   hParser:sax-parse() no-error.

   run retorna-tt in hHandler (output table tt-xml).
   run Cleanup    in hHandler.

   /** Apaga da memoria o objeto e procedure do SAX **/
   delete object hParser.
   delete procedure hHandler.

   for each tt-xml no-lock:
      case tt-xml.elementName:
         when "login" then
            c-login = tt-xml.elementValue.
         when "cpf-cnpj" then
            c-cpf-cnpj = tt-xml.elementValue.
      end case.
   end.

   /** Para a data estar no formato de acordo com o XML Schema **/
   session:date-format = "ymd".

   soap-response:get-document-element(rspNode).
   run getElementsByTagName in hutil(input rspNode, 'SOAP-ENV:Body', output table ttElements).
   find first ttElements.

   find first usuario-fidelidade no-lock
      where usuario-fidelidade.cpf-cnpj = trim(c-cpf-cnpj) no-error.

   if not available (usuario-fidelidade) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "25".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Usuario nao encontrado".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else do:
      assign de-saldo   = 0
             de-resgate = 0
             dt-avencer = ?
             de-vencido = 0.

      run cria-tt-saldo (input usuario-fidelidade.cpf-cnpj, output table tt-saldo).

      /** Cria o cabecalho de resposta **/
      soap-response:create-node(rspNode, "m:saldo-pontos-response", "ELEMENT").
      rspNode:set-attribute("xmlns:m", "urn:x-progress-1.0:saldo-pontos-response").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(hOrdNode,"saldo-pontos","ELEMENT").
      rspNode:append-child(hOrdNode).
   
      for each tt-saldo NO-LOCK:

         if tt-saldo.expirado then
            assign de-vencido = de-vencido + tt-saldo.ptos-disp.

         if not(tt-saldo.expirado) then
            assign de-saldo = de-saldo + tt-saldo.ptos-disp.

         /* Resgate */
         if tt-saldo.id-movto = NO then
             assign de-resgate = de-resgate + tt-saldo.pontos.

         if tt-saldo.id-movto and tt-saldo.expirado = no and 
             date(month(tt-saldo.data-movto), day(tt-saldo.data-movto), year(tt-saldo.data-movto) + 1) < (TODAY + 15) then do:
             assign de-avencer = de-avencer + tt-saldo.ptos-disp.

            IF dt-avencer = ? THEN
                ASSIGN dt-avencer = ADD-INTERVAL(tt-saldo.data-movto, 1, "YEARS":U).
         end.

         soap-response:create-node(hDetNode, "detalhe", "ELEMENT").
         hOrdNode:append-child(hDetNode).

         soap-response:create-node(xmlParam, "data-movto", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = string(tt-saldo.data-movto, '9999-99-99') no-error.
         xmlParam:append-child(xmlText).
         hDetNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "id-movto", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = string(tt-saldo.id-movto) no-error.
         xmlParam:append-child(xmlText).
         hDetNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "pontos", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = string(tt-saldo.pontos) no-error.
         xmlParam:append-child(xmlText).
         hDetNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "dealer", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = tt-saldo.dealer no-error.
         xmlParam:append-child(xmlText).
         hDetNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "descricao", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = tt-saldo.descricao no-error.
         xmlParam:append-child(xmlText).
         hDetNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "expirado", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = string(tt-saldo.expirado) no-error.
         xmlParam:append-child(xmlText).
         hDetNode:append-child(xmlParam).
      end.
      
      soap-response:create-node(xmlParam, "data-inicial", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = string(dt-inicial, '9999-99-99') no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).
      
      soap-response:create-node(xmlParam, "data-final", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = string(dt-final, '9999-99-99') no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "saldo", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = string(de-saldo) no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      ASSIGN de-resgate = de-resgate * -1.

      soap-response:create-node(xmlParam, "resgate", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = string(de-resgate) no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "vencido", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = string(de-vencido) no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "avencer", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = string(de-avencer) no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).
      
      soap-response:create-node(xmlParam, "data-avencer", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = string(dt-avencer, '9999-99-99') no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      blk-premios:
      for each  premios-fidelidade no-lock
          where premios-fidelidade.dt-inival <= today
            and premios-fidelidade.situacao   = 1
            and premios-fidelidade.qt-pontos  > de-saldo
             by premios-fidelidade.qt-pontos:

          soap-response:create-node(xmlParam, "produto", "ELEMENT").
          soap-response:create-node(xmlText, ?, "TEXT").
          xmlText:node-value = fn-free-accent(premios-fidelidade.descricao) no-error.
          xmlParam:append-child(xmlText).
          hOrdNode:append-child(xmlParam).

          soap-response:create-node(xmlParam, "diferenca", "ELEMENT").
          soap-response:create-node(xmlText, ?, "TEXT").
          xmlText:node-value = string((premios-fidelidade.qt-pontos - de-saldo)) no-error.
          xmlParam:append-child(xmlText).
          hOrdNode:append-child(xmlParam).

          leave blk-premios.
      end.
   end.

   /* Clean up */
   delete object xmlText.
   delete object xmlParam.
   delete object rspNode.
   delete object happ.

end procedure.

procedure process-cadastro-produto:
   define input param appservice             as character no-undo.
   define input param soap-procedure         as handle    no-undo.
   define input param ns-prefix              as character no-undo.
   define input-output param soap-response   as handle    no-undo.

   define variable happ       as handle    no-undo.
   define variable rspNode    as handle    no-undo.
   define variable xmlParam   as handle    no-undo.
   define variable xmlText    as handle    no-undo.

   define variable hDoc       as handle    no-undo.
   define variable hCustRoot  as handle    no-undo.
   define variable hCustNode  as handle    no-undo.
   define variable hOrdRoot   as handle    no-undo.
   define variable hOrdNode   as handle    no-undo.
   define variable hDetNode   as handle    no-undo.
   define variable hField     as handle    no-undo.
   define variable hText      as handle    no-undo.
   define variable hBuf       as handle    no-undo.
   define variable hDBFld     as handle    no-undo.
   define variable i          as integer   no-undo.
   DEFINE VARIABLE l-encontrou AS LOGICAL  NO-UNDO.

   /* Variaveis referentes aos campos */
   define variable c-cpf-cnpj    as character no-undo.
   define variable c-serial      as character no-undo.
   define variable c-keycode     as character no-undo.
   define variable c-nro-docto   as character no-undo.
   define variable c-serie-docto as character no-undo.
   define variable c-dealer      as character no-undo.
   define variable c-cnpj-dealer as character no-undo.
   define variable v-data        as character no-undo.

   /* Create our handles */
   create server happ.
   create x-noderef rspNode.
   create x-noderef xmlParam.
   create x-noderef xmlText.
   create x-noderef hOrdRoot.
   create x-noderef hOrdNode.
   create x-noderef hDetNode.

   /** Variaveis para o SAX **/
   define variable hParser  as handle.
   define variable hHandler as handle.

   create sax-reader hParser.

   /** Procedures de callback para o SAX **/
   run soap/soap-xml.p persistent set hHandler.

   hParser:handler = hHandler.
   hParser:set-input-source("HANDLE", web-context).
   hParser:sax-parse() no-error.

   run retorna-tt in hHandler (output table tt-xml).
   run Cleanup    in hHandler.

   /** Apaga da memoria o objeto e procedure do SAX **/
   delete object hParser.
   delete procedure hHandler.

   for each tt-xml no-lock:
      case tt-xml.elementName:
         when "cpf-cnpj" then
            c-cpf-cnpj = tt-xml.elementValue.
         when "serial" then
            c-serial = tt-xml.elementValue.
         when "keycode" then
            c-keycode = tt-xml.elementValue.
         when "nro-docto" then
            c-nro-docto = tt-xml.elementValue.
         when "serie-docto" then
            c-serie-docto = tt-xml.elementValue.
         when "dealer" then
            c-dealer = tt-xml.elementValue.
         when "cnpj-dealer" then
            c-cnpj-dealer = tt-xml.elementValue.
      end case.
   end.

   /** Para a data estar no formato de acordo com o XML Schema **/
   session:date-format = "ymd".

   soap-response:get-document-element(rspNode).
   run getElementsByTagName in hutil(input rspNode, 'SOAP-ENV:Body', output table ttElements).
   find first ttElements.

   assign c-cnpj-dealer = replace(replace(replace(c-cnpj-dealer, '.', ''), '-', ''), '/', '').

   find first usuario-fidelidade no-lock
      where usuario-fidelidade.cpf-cnpj = trim(c-cpf-cnpj) no-error.

   if not available (usuario-fidelidade) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "25".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Usuario nao encontrado".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else do:

       /**/

      ASSIGN l-encontrou = FALSE.

      FOR FIRST num-serie NO-LOCK
          WHERE num-serie.n-serie = c-serial:

          IF date(num-serie.data) < 01/07/2013 THEN DO:

              IF num-serie.ns-keycode = c-keycode THEN
                  ASSIGN l-encontrou = TRUE.

          END.
          ELSE
              ASSIGN l-encontrou = TRUE.

      END.

      find first preco-item no-lock use-index ch-itemtab
         where preco-item.it-codigo  = num-serie.it-codigo
           and preco-item.cod-refer  = ''
           and preco-item.nr-tabpre  = 'PONTOS'
           and preco-item.quant-min <= 1
           and preco-item.dt-inival <= today
           and preco-item.situacao   = 1 no-error.

      if NOT l-encontrou then do:
         soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
         ttElements.nhandle:append-child(rspNode).

         soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = "31".
         xmlParam:append-child(xmlText).
         rspNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = "Serial/keycode invalido".
         xmlParam:append-child(xmlText).
         rspNode:append-child(xmlParam).
      end.
      ELSE if (date(num-serie.data) < 01/07/2013 AND
              CAN-FIND(FIRST pontos-fidelidade
                       where pontos-fidelidade.n-serie = num-serie.n-serie
                       and   pontos-fidelidade.ns-keycode = num-serie.ns-keycode
                       and   pontos-fidelidade.id-movto)) 
              OR
             (date(num-serie.data) >= 01/07/2013 AND
              CAN-FIND(FIRST pontos-fidelidade
                       where pontos-fidelidade.n-serie = num-serie.n-serie
                       and   pontos-fidelidade.id-movto)) THEN DO:

         soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
         ttElements.nhandle:append-child(rspNode).

         soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = "32".
         xmlParam:append-child(xmlText).
         rspNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = "Serial/keycode ja utilizado".
         xmlParam:append-child(xmlText).
         rspNode:append-child(xmlParam).
      end.
      else if not available (preco-item) then do:
         soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
         ttElements.nhandle:append-child(rspNode).

         soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = "33".
         xmlParam:append-child(xmlText).
         rspNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = "Pontuacao nao encontrada para o item".
         xmlParam:append-child(xmlText).
         rspNode:append-child(xmlParam).
      end.
      else if not can-find (first emitente no-lock
                            where emitente.cgc          = c-cnpj-dealer
                            and   emitente.natureza     = 2
                            and   emitente.identific   <> 2
                            and  (emitente.cod-gr-cli   = 15 
                             or   emitente.cod-gr-cli   = 5)) AND
              not can-find (first emitente
                            where emitente.cgc          = c-cnpj-dealer
                              and emitente.nome-abrev   BEGINS "INTELBRAS") and
         /** Tarefa 43301 **/
              not can-find (first emitente
                            where emitente.cgc          = c-cnpj-dealer
                              and emitente.cod-emitente = 132890) then do:

         soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
         ttElements.nhandle:append-child(rspNode).

         soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = "34".
         xmlParam:append-child(xmlText).
         rspNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = "Emitente nao cadastrado".
         xmlParam:append-child(xmlText).
         rspNode:append-child(xmlParam).
      end.
      else do transaction:
         assign c-dealer = fn-free-accent(c-dealer).

         create pontos-fidelidade.
         assign pontos-fidelidade.cpf-cnpj    = usuario-fidelidade.cpf-cnpj
                pontos-fidelidade.n-serie     = num-serie.n-serie
                pontos-fidelidade.ns-keycode  = num-serie.ns-keycode
                pontos-fidelidade.id-movto    = yes
                pontos-fidelidade.data-movto  = today
                pontos-fidelidade.pontos      = preco-item.preco-venda
                pontos-fidelidade.ptos-disp   = pontos-fidelidade.pontos
                pontos-fidelidade.it-codigo   = num-serie.it-codigo
                pontos-fidelidade.serie-docto = trim(upper(c-serie-docto))
                pontos-fidelidade.nro-docto   = trim(upper(c-nro-docto))
                pontos-fidelidade.dealer      = trim(upper(c-dealer))
                pontos-fidelidade.cnpj-dealer = trim(c-cnpj-dealer).

         /** Cria o cabecalho de resposta **/
         soap-response:create-node(rspNode, "m:cadastro-produto-response", "ELEMENT").
         rspNode:set-attribute("xmlns:m", "urn:x-progress-1.0:cadastro-produto-response").
         ttElements.nhandle:append-child(rspNode).
   
         soap-response:create-node(hOrdNode,"cadastro-produto","ELEMENT").
         rspNode:append-child(hOrdNode).
   
         soap-response:create-node(xmlParam, "pontos", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = string(pontos-fidelidade.pontos) no-error.
         xmlParam:append-child(xmlText).
         hOrdNode:append-child(xmlParam).
      end.
   end.

   /* Clean up */
   delete object xmlText.
   delete object xmlParam.
   delete object rspNode.
   delete object happ.

end procedure.

define temp-table tt-pontos no-undo
   field descricao like item.desc-nacional
   field pontuacao like preco-item.preco-venda
   index ch-pontos is primary unique descricao pontuacao.

procedure process-lista-tabela-pontos:
   define input param appservice             as character no-undo.
   define input param soap-procedure         as handle    no-undo.
   define input param ns-prefix              as character no-undo.
   define input-output param soap-response   as handle    no-undo.

   define variable happ       as handle    no-undo.
   define variable rspNode    as handle    no-undo.
   define variable xmlParam   as handle    no-undo.
   define variable xmlText    as handle    no-undo.

   define variable hDoc       as handle    no-undo.
   define variable hCustRoot  as handle    no-undo.
   define variable hCustNode  as handle    no-undo.
   define variable hOrdRoot   as handle    no-undo.
   define variable hOrdNode   as handle    no-undo.
   define variable hField     as handle    no-undo.
   define variable hText      as handle    no-undo.
   define variable hBuf       as handle    no-undo.
   define variable hDBFld     as handle    no-undo.
   define variable i          as integer   no-undo.

   /* Variaveis referentes aos campos */
   define variable c-login    as character no-undo.
   define variable c-senha    as character no-undo case-sensitive.

   /* Create our handles */
   create server happ.
   create x-noderef rspNode.
   create x-noderef xmlParam.
   create x-noderef xmlText.
   create x-noderef hOrdRoot.
   create x-noderef hOrdNode.

   /* Comentado, n’o precisa de entrada nessa procedure */
   /*
   /** Variaveis para o SAX **/
   define variable hParser  as handle.
   define variable hHandler as handle.

   create sax-reader hParser.

   /** Procedures de callback para o SAX **/
   run soap/soap-xml.p persistent set hHandler.

   hParser:handler = hHandler.
   hParser:set-input-source("HANDLE", web-context).
   hParser:sax-parse() no-error.

   run retorna-tt in hHandler (output table tt-xml).
   run Cleanup    in hHandler.

   /** Apaga da memoria o objeto e procedure do SAX **/
   delete object hParser.
   delete procedure hHandler.

   for each tt-xml no-lock:
      case tt-xml.elementName:
         when "login" then
            c-login = tt-xml.elementValue.
         when "senha" then
            c-senha = tt-xml.elementValue.
      end case.
   end.
   */

   soap-response:get-document-element(rspNode).
   run getElementsByTagName in hutil(input rspNode, 'SOAP-ENV:Body', output table ttElements).
   find first ttElements.

   if not can-find (first preco-item
                    where preco-item.nr-tabpre   = 'PONTOS'
                      and preco-item.situacao    = 1
                      and preco-item.dt-inival  <= today
                      and preco-item.preco-venda > 0) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "41".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Tabela de precos nao encontrada".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else do:
      /** Cria o cabecalho de resposta **/
      soap-response:create-node(rspNode, "m:lista-tabela-pontos-response", "ELEMENT").
      rspNode:set-attribute("xmlns:m", "urn:x-progress-1.0:lista-tabela-pontos-response").
      ttElements.nhandle:append-child(rspNode).

      for each preco-item fields (preco-venda) no-lock use-index ch-itemtab
         where preco-item.nr-tabpre   = 'PONTOS'
           and preco-item.situacao    = 1
           and preco-item.dt-inival  <= today
           and preco-item.preco-venda > 0,
         first item fields (desc-nacional) no-lock
           where item.it-codigo = preco-item.it-codigo
         break by preco-item.it-codigo:

         /* Coisa feia pra trazer um s½ registro quando tiver hist½rico na tabela */
         if not first-of (preco-item.it-codigo) then
            next.

         find first tt-pontos exclusive-lock
            where tt-pontos.descricao = item.desc-nacional
              and tt-pontos.pontuacao = preco-item.preco-venda no-error.

         if not available tt-pontos then do:
            create tt-pontos.
            assign tt-pontos.descricao = item.desc-nacional
                   tt-pontos.pontuacao = preco-item.preco-venda.
         end.
      end.

      for each tt-pontos no-lock
         by tt-pontos.pontuacao DESC
         by tt-pontos.descricao:
      
         soap-response:create-node(hOrdNode,"tabela","ELEMENT").
         rspNode:append-child(hOrdNode).

         soap-response:create-node(xmlParam, "descricao", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = tt-pontos.descricao no-error.
         xmlParam:append-child(xmlText).
         hOrdNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "pontos", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = string(tt-pontos.pontuacao) no-error.
         xmlParam:append-child(xmlText).
         hOrdNode:append-child(xmlParam).
      end.
   end.

   /* Clean up */
   delete object xmlText.
   delete object xmlParam.
   delete object rspNode.
   delete object happ.

end procedure.

procedure process-lista-usuario:
   define input param appservice             as character no-undo.
   define input param soap-procedure         as handle    no-undo.
   define input param ns-prefix              as character no-undo.
   define input-output param soap-response   as handle    no-undo.

   define variable happ       as handle    no-undo.
   define variable rspNode    as handle    no-undo.
   define variable xmlParam   as handle    no-undo.
   define variable xmlText    as handle    no-undo.

   define variable hDoc       as handle    no-undo.
   define variable hCustRoot  as handle    no-undo.
   define variable hCustNode  as handle    no-undo.
   define variable hOrdRoot   as handle    no-undo.
   define variable hOrdNode   as handle    no-undo.
   define variable hField     as handle    no-undo.
   define variable hText      as handle    no-undo.
   define variable hBuf       as handle    no-undo.
   define variable hDBFld     as handle    no-undo.
   define variable i          as integer   no-undo.

   /* Variaveis referentes aos campos */
   define variable c-cpf-cnpj as character no-undo.

   /* Create our handles */
   create server happ.
   create x-noderef rspNode.
   create x-noderef xmlParam.
   create x-noderef xmlText.
   create x-noderef hOrdRoot.
   create x-noderef hOrdNode.

   /** Variaveis para o SAX **/
   define variable hParser  as handle.
   define variable hHandler as handle.

   create sax-reader hParser.

   /** Procedures de callback para o SAX **/
   run soap/soap-xml.p persistent set hHandler.

   hParser:handler = hHandler.
   hParser:set-input-source("HANDLE", web-context).
   hParser:sax-parse() no-error.

   run retorna-tt in hHandler (output table tt-xml).
   run Cleanup    in hHandler.

   /** Apaga da memoria o objeto e procedure do SAX **/
   delete object hParser.
   delete procedure hHandler.

   for each tt-xml no-lock:
      case tt-xml.elementName:
         when "cpf-cnpj" then
            c-cpf-cnpj = tt-xml.elementValue.
      end case.
   end.

   soap-response:get-document-element(rspNode).
   run getElementsByTagName in hutil(input rspNode, 'SOAP-ENV:Body', output table ttElements).
   find first ttElements.

   assign c-cpf-cnpj = replace(replace(replace(c-cpf-cnpj, '.', ''), '-', ''), '/', '').

   find first usuario-fidelidade no-lock
      where usuario-fidelidade.cpf-cnpj = trim(c-cpf-cnpj) no-error.

   if not available (usuario-fidelidade) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "25".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Usuario nao encontrado".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else do:
      /** Cria o cabecalho de resposta **/
      soap-response:create-node(rspNode, "m:lista-usuario-response", "ELEMENT").
      rspNode:set-attribute("xmlns:m", "urn:x-progress-1.0:lista-usuario-response").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(hOrdNode,"usuario","ELEMENT").
      rspNode:append-child(hOrdNode).

      hOrdNode:set-attribute("ativo", (if usuario-fidelidade.ativo then "true" else "false")) no-error.

      soap-response:create-node(xmlParam, "cpf-cnpj", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.cpf-cnpj no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "nome", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.nome no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "e-mail", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.e-mail no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).
   
      soap-response:create-node(xmlParam, "empresa", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.empresa no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "endereco", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.endereco no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "bairro", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.bairro no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).
   
      soap-response:create-node(xmlParam, "cidade", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.cidade no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "uf", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.uf no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "cep", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.cep no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).
   
      soap-response:create-node(xmlParam, "telefone-1", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.telefone[1] no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "telefone-2", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.telefone[2] no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "id-revenda", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = string(usuario-fidelidade.id-revenda) no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).
   
/*       soap-response:create-node(xmlParam, "id-atuacao", "ELEMENT").        */
/*       soap-response:create-node(xmlText, ?, "TEXT").                       */
/*       xmlText:node-value = string(usuario-fidelidade.id-atuacao) no-error. */
/*       xmlParam:append-child(xmlText).                                      */
/*       hOrdNode:append-child(xmlParam).                                     */

      soap-response:create-node(xmlParam, "l-telecom", "ELEMENT").       
      soap-response:create-node(xmlText, ?, "TEXT").                      
      xmlText:node-value = string(usuario-fidelidade.l-telecom) no-error.
      xmlParam:append-child(xmlText).                                     
      hOrdNode:append-child(xmlParam).                                    

      soap-response:create-node(xmlParam, "l-seguran", "ELEMENT").       
      soap-response:create-node(xmlText, ?, "TEXT").                      
      xmlText:node-value = string(usuario-fidelidade.l-seguran) no-error.
      xmlParam:append-child(xmlText).                                     
      hOrdNode:append-child(xmlParam).                                    

      soap-response:create-node(xmlParam, "l-inform", "ELEMENT").       
      soap-response:create-node(xmlText, ?, "TEXT").                      
      xmlText:node-value = string(usuario-fidelidade.l-inform) no-error.
      xmlParam:append-child(xmlText).                                     
      hOrdNode:append-child(xmlParam).                                    

      soap-response:create-node(xmlParam, "dealers", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = usuario-fidelidade.dealers no-error.
      xmlParam:append-child(xmlText).
      hOrdNode:append-child(xmlParam).

   end.

   /* Clean up */
   delete object xmlText.
   delete object xmlParam.
   delete object rspNode.
   delete object happ.

end procedure.

procedure process-lista-tabela-premios:
   define input param appservice             as character no-undo.
   define input param soap-procedure         as handle    no-undo.
   define input param ns-prefix              as character no-undo.
   define input-output param soap-response   as handle    no-undo.

   define variable happ       as handle    no-undo.
   define variable rspNode    as handle    no-undo.
   define variable xmlParam   as handle    no-undo.
   define variable xmlText    as handle    no-undo.

   define variable hDoc       as handle    no-undo.
   define variable hCustRoot  as handle    no-undo.
   define variable hCustNode  as handle    no-undo.
   define variable hOrdRoot   as handle    no-undo.
   define variable hOrdNode   as handle    no-undo.
   define variable hField     as handle    no-undo.
   define variable hText      as handle    no-undo.
   define variable hBuf       as handle    no-undo.
   define variable hDBFld     as handle    no-undo.
   define variable i          as integer   no-undo.

   define variable c-descricao   as character no-undo.

   /* Create our handles */
   create server happ.
   create x-noderef rspNode.
   create x-noderef xmlParam.
   create x-noderef xmlText.
   create x-noderef hOrdRoot.
   create x-noderef hOrdNode.

   /*
   /** Variaveis para o SAX **/
   define variable hParser  as handle.
   define variable hHandler as handle.

   create sax-reader hParser.

   /** Procedures de callback para o SAX **/
   run soap/soap-xml.p persistent set hHandler.

   hParser:handler = hHandler.
   hParser:set-input-source("HANDLE", web-context).
   hParser:sax-parse() no-error.

   run retorna-tt in hHandler (output table tt-xml).
   run Cleanup    in hHandler.

   /** Apaga da memoria o objeto e procedure do SAX **/
   delete object hParser.
   delete procedure hHandler.

   for each tt-xml no-lock:
      case tt-xml.elementName:
         when "login" then
            c-login = tt-xml.elementValue.
         when "senha" then
            c-senha = tt-xml.elementValue.
      end case.
   end.
   */

   soap-response:get-document-element(rspNode).
   run getElementsByTagName in hutil(input rspNode, 'SOAP-ENV:Body', output table ttElements).
   find first ttElements.

   if not can-find (first premios-fidelidade
                    where premios-fidelidade.dt-inival <= today
                      and premios-fidelidade.situacao   = 1
                      and premios-fidelidade.qt-pontos  > 0) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "44".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Tabela de premios nao encontrada".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else do:
      /** Cria o cabecalho de resposta **/
      soap-response:create-node(rspNode, "m:lista-tabela-premios-response", "ELEMENT").
      rspNode:set-attribute("xmlns:m", "urn:x-progress-1.0:lista-tabela-premios-response").
      ttElements.nhandle:append-child(rspNode).

      for each premios-fidelidade no-lock
         where premios-fidelidade.dt-inival <= today
           and premios-fidelidade.situacao   = 1
           and premios-fidelidade.qt-pontos  > 0
            by premios-fidelidade.qt-pontos
            by premios-fidelidade.descricao:
      
         soap-response:create-node(hOrdNode, "premio", "ELEMENT").
         rspNode:append-child(hOrdNode).

         hOrdNode:set-attribute("codigo", string(premios-fidelidade.cod-premio)) no-error.

         /* Evitar problemas de charset ao mandar para o PHP */
         run html-entities in hhtml(input premios-fidelidade.descricao, output c-descricao).

         soap-response:create-node(xmlParam, "descricao", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = c-descricao no-error.
         xmlParam:append-child(xmlText).
         hOrdNode:append-child(xmlParam).

         soap-response:create-node(xmlParam, "pontos", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = string(premios-fidelidade.qt-pontos) no-error.
         xmlParam:append-child(xmlText).
         hOrdNode:append-child(xmlParam).
      end.
   end.

   /* Clean up */
   delete object xmlText.
   delete object xmlParam.
   delete object rspNode.
   delete object happ.

end procedure.

procedure process-cria-resgate:
   define input param appservice             as character no-undo.
   define input param soap-procedure         as handle    no-undo.
   define input param ns-prefix              as character no-undo.
   define input-output param soap-response   as handle    no-undo.

   define variable happ       as handle    no-undo.
   define variable rspNode    as handle    no-undo.
   define variable xmlParam   as handle    no-undo.
   define variable xmlText    as handle    no-undo.

   define variable hDoc       as handle    no-undo.
   define variable hCustRoot  as handle    no-undo.
   define variable hCustNode  as handle    no-undo.
   define variable hOrdRoot   as handle    no-undo.
   define variable hOrdNode   as handle    no-undo.
   define variable hField     as handle    no-undo.
   define variable hText      as handle    no-undo.
   define variable hBuf       as handle    no-undo.
   define variable hDBFld     as handle    no-undo.
   define variable i          as integer   no-undo.

   define variable c-cpf-cnpj    as character   no-undo.
   define variable c-cod-premio  as character   no-undo.
   define variable i-cod-premio  as integer     no-undo.
   define variable c-quantidade  as character   no-undo.
   define variable i-quantidade  as integer     no-undo.
   define variable i-sequencia   as integer     no-undo.
   define variable dt-inicial    as date        no-undo.
   define variable dt-final      as date        no-undo.
   define variable de-saldo      as decimal     no-undo.
   define variable de-total      as decimal     no-undo.
   define variable de-resgate    as decimal     no-undo.

   define buffer b-resgate for resgate-premios.

   /* Create our handles */
   create server happ.
   create x-noderef rspNode.
   create x-noderef xmlParam.
   create x-noderef xmlText.
   create x-noderef hOrdRoot.
   create x-noderef hOrdNode.

   /** Variaveis para o SAX **/
   define variable hParser  as handle.
   define variable hHandler as handle.

   create sax-reader hParser.

   /** Procedures de callback para o SAX **/
   run soap/soap-xml.p persistent set hHandler.

   hParser:handler = hHandler.
   hParser:set-input-source("HANDLE", web-context).
   hParser:sax-parse() no-error.

   run retorna-tt in hHandler (output table tt-xml).
   run Cleanup    in hHandler.

   /** Apaga da memoria o objeto e procedure do SAX **/
   delete object hParser.
   delete procedure hHandler.

   for each tt-xml no-lock:
      case tt-xml.elementName:
         when "cpf-cnpj" then
            c-cpf-cnpj = tt-xml.elementValue.
         when "cod-premio" then
            c-cod-premio = tt-xml.elementValue.
         when "quantidade" then
            c-quantidade = tt-xml.elementValue.
      end case.
   end.

   assign i-cod-premio = int(c-cod-premio)
          i-quantidade = int(c-quantidade).

   soap-response:get-document-element(rspNode).
   run getElementsByTagName in hutil(input rspNode, 'SOAP-ENV:Body', output table ttElements).
   find first ttElements.

   find first usuario-fidelidade no-lock
      where usuario-fidelidade.cpf-cnpj = trim(c-cpf-cnpj) no-error.

   find first premios-fidelidade no-lock
        where premios-fidelidade.cod-premio = i-cod-premio
          and premios-fidelidade.dt-inival <= today
          and premios-fidelidade.situacao   = 1
          and premios-fidelidade.qt-pontos  > 0 no-error.

   run cria-tt-saldo (input trim(c-cpf-cnpj), output table tt-saldo).

   for each  tt-saldo 
       where tt-saldo.expirado = NO no-lock:
       assign de-saldo = de-saldo + tt-saldo.ptos-disp.
   end.

   IF AVAIL premios-fidelidade THEN DO:
       IF i-quantidade > 1 THEN
           ASSIGN de-total = (premios-fidelidade.qt-pontos * i-quantidade).
       ELSE
           ASSIGN de-total = premios-fidelidade.qt-pontos.
   END.

   if not available (usuario-fidelidade) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "25".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Usuario nao encontrado".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else if (i-quantidade = 0) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "45".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Quantidade nao pode ser 0".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else if not available (premios-fidelidade) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "46".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Premio nao encontrado".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else if (de-saldo < de-total) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "47".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Saldo insuficiente".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else do:
      do transaction:
         find last b-resgate no-lock
            where b-resgate.cpf-cnpj   = usuario-fidelidade.cpf-cnpj
              and b-resgate.data-movto = today no-error.

         if available (b-resgate) then
            assign i-sequencia = b-resgate.sequencia + 10.
         else
            assign i-sequencia = 10.

         create resgate-premios.
         assign resgate-premios.cpf-cnpj   = usuario-fidelidade.cpf-cnpj
                resgate-premios.data-movto = today
                resgate-premios.sequencia  = i-sequencia
                resgate-premios.cod-premio = premios-fidelidade.cod-premio
                resgate-premios.pontos     = premios-fidelidade.qt-pontos
                resgate-premios.quantidade = i-quantidade.

         /* Reserva dos pontos fidelidade/extra para resgate dos prˆmios - In¡cio - Sakae */
         bk-tt-saldo:
         FOR EACH  tt-saldo USE-INDEX ch-pri EXCLUSIVE-LOCK:
             IF de-total           = 0 THEN LEAVE bk-tt-saldo.
             IF tt-saldo.ptos-disp = 0 THEN NEXT  bk-tt-saldo.
             IF tt-saldo.expirado      THEN NEXT  bk-tt-saldo.

             IF (de-total - tt-saldo.ptos-disp) >= 0 THEN
                 ASSIGN de-resgate         = tt-saldo.ptos-disp
                        de-total           = de-total - tt-saldo.ptos-disp
                        tt-saldo.ptos-disp = 0.
             ELSE
                 ASSIGN de-resgate         = de-total
                        tt-saldo.ptos-disp = tt-saldo.ptos-disp - de-total
                        de-total           = 0.

             IF tt-saldo.tabela = "ponto-extra":U THEN DO:
                 FIND FIRST ponto-extra
                     WHERE ROWID(ponto-extra) = tt-saldo.r-rowid EXCLUSIVE-LOCK NO-ERROR.

                 IF AVAILABLE ponto-extra THEN DO:
                     CREATE int-reserva-pontos.
                     ASSIGN int-reserva-pontos.cpf-cnpj        = resgate-premios.cpf-cnpj
                            int-reserva-pontos.data-movto-pto  = ponto-extra.data-movto
                            int-reserva-pontos.data-movto-resg = resgate-premios.data-movto
                            int-reserva-pontos.n-serie         = ""
                            int-reserva-pontos.ns-keycode      = "":U
                            int-reserva-pontos.seq-pto-extra   = ponto-extra.sequencia
                            int-reserva-pontos.seq-resgate     = resgate-premios.sequencia
                            int-reserva-pontos.ind-tp-pto      = 2 /* ponto-extra */
                            int-reserva-pontos.pto-fidel-extr  = ponto-extra.pontos
                            int-reserva-pontos.pto-resg        = de-resgate
                            int-reserva-pontos.concluido       = NO.

                     ASSIGN ponto-extra.ptos-disp = tt-saldo.ptos-disp.
                 END.
             END.
             ELSE DO:
                 FIND FIRST pontos-fidelidade
                     WHERE ROWID(pontos-fidelidade) = tt-saldo.r-rowid EXCLUSIVE-LOCK NO-ERROR.

                 IF AVAILABLE pontos-fidelidade THEN DO:
                     CREATE int-reserva-pontos.
                     ASSIGN int-reserva-pontos.cpf-cnpj        = resgate-premios.cpf-cnpj
                            int-reserva-pontos.data-movto-pto  = pontos-fidelidade.data-movto
                            int-reserva-pontos.data-movto-resg = resgate-premios.data-movto
                            int-reserva-pontos.n-serie         = pontos-fidelidade.n-serie
                            int-reserva-pontos.ns-keycode      = pontos-fidelidade.ns-keycode
                            int-reserva-pontos.seq-pto-extra   = 0
                            int-reserva-pontos.seq-resgate     = resgate-premios.sequencia
                            int-reserva-pontos.ind-tp-pto      = 1 /* pontos-fidelidade */
                            int-reserva-pontos.pto-fidel-extr  = pontos-fidelidade.pontos
                            int-reserva-pontos.pto-resg        = de-resgate
                            int-reserva-pontos.concluido       = NO.

                     ASSIGN pontos-fidelidade.ptos-disp = tt-saldo.ptos-disp.
                 END.
             END.
         END.
         /* Reserva dos pontos fidelidade/extra para resgate dos prˆmios - Final - Sakae */

         /** Cria o cabecalho de resposta **/
         soap-response:create-node(rspNode, "m:cria-resgate-response", "ELEMENT").
         rspNode:set-attribute("xmlns:m", "urn:x-progress-1.0:cria-resgate").
         rspNode:set-attribute("xmlns:rpc", "http://www.w3.org/2001/09/soap-rpc").
         ttElements.nhandle:append-child(rspNode).

         soap-response:create-node(hOrdNode,"rpc:result","ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = "OK".
         hOrdNode:append-child(xmlText).
         rspNode:append-child(hOrdNode).
      end.
   end.

   /* Clean up */
   delete object xmlText.
   delete object xmlParam.
   delete object rspNode.
   delete object happ.

end procedure.

procedure process-lista-cidades:
   define input param appservice             as character no-undo.
   define input param soap-procedure         as handle    no-undo.
   define input param ns-prefix              as character no-undo.
   define input-output param soap-response   as handle    no-undo.

   define variable happ       as handle    no-undo.
   define variable rspNode    as handle    no-undo.
   define variable xmlParam   as handle    no-undo.
   define variable xmlText    as handle    no-undo.

   define variable hDoc       as handle    no-undo.
   define variable hCustRoot  as handle    no-undo.
   define variable hCustNode  as handle    no-undo.
   define variable hOrdRoot   as handle    no-undo.
   define variable hOrdNode   as handle    no-undo.
   define variable hField     as handle    no-undo.
   define variable hText      as handle    no-undo.
   define variable hBuf       as handle    no-undo.
   define variable hDBFld     as handle    no-undo.
   define variable i          as integer   no-undo.

   define variable c-cidade   as character no-undo.
   define variable c-uf       as character no-undo.

   /* Create our handles */
   create server happ.
   create x-noderef rspNode.
   create x-noderef xmlParam.
   create x-noderef xmlText.
   create x-noderef hOrdRoot.
   create x-noderef hOrdNode.

   /** Variaveis para o SAX **/
   define variable hParser  as handle.
   define variable hHandler as handle.

   create sax-reader hParser.

   /** Procedures de callback para o SAX **/
   run soap/soap-xml.p persistent set hHandler.

   hParser:handler = hHandler.
   hParser:set-input-source("HANDLE", web-context).
   hParser:sax-parse() no-error.

   run retorna-tt in hHandler (output table tt-xml).
   run Cleanup    in hHandler.

   /** Apaga da memoria o objeto e procedure do SAX **/
   delete object hParser.
   delete procedure hHandler.

   for each tt-xml no-lock:
      case tt-xml.elementName:
         when "uf" then
            c-uf = tt-xml.elementValue.
      end case.
   end.

   soap-response:get-document-element(rspNode).
   run getElementsByTagName in hutil(input rspNode, 'SOAP-ENV:Body', output table ttElements).
   find first ttElements.

   if not can-find (first mgcad.cidade
                    where cidade.pais   = 'Brasil'
                      and cidade.estado = c-uf) then do:
      soap-response:create-node(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(xmlParam, "faultcode", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "48".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).

      soap-response:create-node(xmlParam, "faultstring", "ELEMENT").
      soap-response:create-node(xmlText, ?, "TEXT").
      xmlText:node-value = "Cidades nao encontradas".
      xmlParam:append-child(xmlText).
      rspNode:append-child(xmlParam).
   end.
   else do:
      /** Cria o cabecalho de resposta **/
      soap-response:create-node(rspNode, "m:lista-cidades-response", "ELEMENT").
      rspNode:set-attribute("xmlns:m", "urn:x-progress-1.0:lista-cidades-response").
      ttElements.nhandle:append-child(rspNode).

      soap-response:create-node(hOrdNode, "cidades", "ELEMENT").
      rspNode:append-child(hOrdNode).

      for each mgcad.cidade no-lock
         where cidade.pais   = 'Brasil'
           and cidade.estado = c-uf
            by cidade.cidade:
      
         /* Evitar problemas de charset ao mandar para o PHP */
         assign c-cidade = fn-free-accent(cidade.cidade).

         soap-response:create-node(xmlParam, "cidade", "ELEMENT").
         soap-response:create-node(xmlText, ?, "TEXT").
         xmlText:node-value = c-cidade no-error.
         xmlParam:append-child(xmlText).
         hOrdNode:append-child(xmlParam).
      end.
   end.

   /* Clean up */
   delete object xmlText.
   delete object xmlParam.
   delete object rspNode.
   delete object happ.

end procedure.

PROCEDURE cria-tt-saldo:
   DEFINE INPUT  PARAMETER pcpf-cnpj LIKE usuario-fidelidade.cpf-cnpj NO-UNDO.
   DEFINE OUTPUT PARAMETER TABLE FOR tt-saldo.

   DEFINE BUFFER bf-pontos-fidelidade FOR pontos-fidelidade.
   DEFINE BUFFER bf-ponto-extra FOR ponto-extra.

   FIND FIRST usuario-fidelidade NO-LOCK
        WHERE usuario-fidelidade.cpf-cnpj = pcpf-cnpj NO-ERROR.

   IF NOT AVAILABLE usuario-fidelidade THEN
       NEXT.

   FOR EACH pontos-fidelidade NO-LOCK
      WHERE pontos-fidelidade.cpf-cnpj = usuario-fidelidade.cpf-cnpj,
      FIRST ITEM NO-LOCK
      WHERE ITEM.it-codigo = pontos-fidelidade.it-codigo:

       /* Verifica se expirou */
       IF NOT pontos-fidelidade.expirado AND (ADD-INTERVAL(pontos-fidelidade.data-movto, 1, 'years') < TODAY) THEN DO:

           /* Atualiza como expirado e zera pontos dispon¡veis */
           FIND FIRST bf-pontos-fidelidade 
               WHERE ROWID(bf-pontos-fidelidade) = ROWID(pontos-fidelidade) EXCLUSIVE-LOCK NO-ERROR.
           ASSIGN bf-pontos-fidelidade.expirado  = YES.

           /* Somente para exibir no Extrato Pontos */
           CREATE tt-saldo.
           ASSIGN tt-saldo.data-movto = pontos-fidelidade.data-movto
                  tt-saldo.id-movto   = pontos-fidelidade.id-movto
                  tt-saldo.pontos     = pontos-fidelidade.pontos
                  tt-saldo.dealer     = pontos-fidelidade.dealer
                  tt-saldo.descricao  = ITEM.desc-nacional
                  tt-saldo.ptos-disp  = pontos-fidelidade.ptos-disp
                  tt-saldo.expirado   = YES.

           NEXT.
       END.

       CREATE tt-saldo.
       ASSIGN tt-saldo.data-movto = pontos-fidelidade.data-movto
              tt-saldo.id-movto   = pontos-fidelidade.id-movto
              tt-saldo.pontos     = pontos-fidelidade.pontos
              tt-saldo.dealer     = pontos-fidelidade.dealer
              tt-saldo.descricao  = ITEM.desc-nacional
              tt-saldo.ptos-disp  = pontos-fidelidade.ptos-disp
              tt-saldo.expirado   = pontos-fidelidade.expirado
              tt-saldo.tabela     = "pontos-fidelidade"
              tt-saldo.r-rowid    = ROWID(pontos-fidelidade).
   END.   

   FOR EACH ponto-extra NO-LOCK
      WHERE ponto-extra.cpf-cnpj = usuario-fidelidade.cpf-cnpj:

       FIND FIRST emitente 
            WHERE emitente.cgc = ponto-extra.cnpj-dealer NO-LOCK NO-ERROR.

       /* Verifica se expirou */
       IF NOT ponto-extra.expirado AND (ADD-INTERVAL(ponto-extra.data-movto, 1, 'years') < TODAY) THEN DO:

           /* Atualiza como expirado e zera pontos dispon¡veis */
           FIND FIRST bf-ponto-extra 
               WHERE ROWID(bf-ponto-extra) = ROWID(ponto-extra) EXCLUSIVE-LOCK NO-ERROR.
           ASSIGN bf-ponto-extra.expirado  = YES.

           /* Somente para exibir no Extrato Pontos */
           CREATE tt-saldo.
           ASSIGN tt-saldo.data-movto = ponto-extra.data-movto
                  tt-saldo.id-movto   = YES
                  tt-saldo.pontos     = ponto-extra.pontos
                  tt-saldo.descricao  = ponto-extra.descricao                  
                  tt-saldo.ptos-disp  = ponto-extra.ptos-disp
                  tt-saldo.expirado   = YES.

           IF AVAIL emitente THEN
               ASSIGN tt-saldo.dealer = emitente.nome-abrev.

           NEXT.
       END.

       CREATE tt-saldo.
       ASSIGN tt-saldo.data-movto = ponto-extra.data-movto
              tt-saldo.id-movto   = YES
              tt-saldo.pontos     = ponto-extra.pontos
              tt-saldo.descricao  = ponto-extra.descricao
              tt-saldo.ptos-disp  = ponto-extra.ptos-disp
              tt-saldo.expirado   = ponto-extra.expirado
              tt-saldo.tabela     = "ponto-extra"
              tt-saldo.r-rowid    = ROWID(ponto-extra).

       IF AVAIL emitente THEN
           ASSIGN tt-saldo.dealer = emitente.nome-abrev.
   END.

   FOR EACH resgate-premios NO-LOCK
      WHERE resgate-premios.cpf-cnpj = usuario-fidelidade.cpf-cnpj
        AND resgate-premios.concluido:       

       CREATE tt-saldo.
       ASSIGN tt-saldo.data-movto = resgate-premios.data-movto
              tt-saldo.id-movto   = NO
              tt-saldo.pontos     = (resgate-premios.pontos * resgate-premios.quantidade) * -1
              tt-saldo.descricao  = 'Resgate de pontos'
              tt-saldo.ptos-disp  = 0.
   END.

END PROCEDURE.
