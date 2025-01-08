/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp044rpa-ws.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Setembro/2010 - Desenvolvimento
**  Descricao.: Integra‡Æo WS Clientes - Ikeda
-----------------------------------------------------------------------*/

create widget-pool.

/** Defini‡Æo das temp-tables **/
{esp/pdp/espdp044rpa-tt.i}

define new global shared variable cXMLDirTestFiles as character no-undo.

define variable iNumRecords         as integer  no-undo.
define variable iNumFields          as integer  no-undo.
define variable cont1               as integer  no-undo.
define variable cont2               as integer  no-undo.

/* Variaveis de TT dinamica */
define variable bUsuario            as handle   no-undo.
define variable bConta              as handle   no-undo.
define variable bGrupos             as handle   no-undo.
define variable bEnderecos          as handle   no-undo.
define variable hField              as handle   no-undo.

define variable hClientesListagem   as handle   no-undo.
define variable hclsClientesList    as handle   no-undo.
define variable hGrupos             as handle   no-undo.
define variable hEnderecos          as handle   no-undo.

define variable hSoapResult         as handle   no-undo.
define variable hAux                as handle   no-undo.
define variable hCampos             as handle   no-undo.
define variable hRegistro           as handle   no-undo.
define variable hValor              as handle   no-undo.

define variable lcSoapResult        as longchar no-undo.
define variable hWebService         as handle   no-undo.
define variable hClienteSoap        as handle   no-undo.
define variable hRetorno            as handle   no-undo.

procedure conecta:
   define output parameter iStatus  as integer     no-undo.
   define output parameter cStatus  as character   no-undo.

   find param-b2c no-lock no-error.

   create server hWebService.
   hWebService:connect("-WSDL '" + param-b2c.url-webservices + "/Cliente.asmx?WSDL'") no-error.
   if (hWebService:connected()) then do:
      run ClienteSoap set hClienteSoap on hWebService no-error.
    
      if (error-status:error) then
         assign iStatus = 98
                cStatus = "Erro ao carregar o PortType ClienteSoap no Web Service Ikeda: " + error-status:get-message(1).
      else
         assign iStatus = 1.
   end.
   else
      if (error-status:error) then
         assign iStatus = 99
                cStatus = "Web Service B2C Ikeda nao disponivel para conexao: " + error-status:get-message(1).
      else
         assign iStatus = 97
                cStatus = "Web Service B2C Ikeda nao disponivel para conexao, sem retornar erro".
end procedure.

procedure listarNovos:
   define output parameter iStatus  as integer     no-undo.
   define output parameter cStatus  as character   no-undo.
   define output parameter table for ttUsuario.
   define output parameter table for ttConta.
   define output parameter table for ttGrupos.
   define output parameter table for ttEnderecos.

   empty temp-table ttUsuario.  
   empty temp-table ttConta.    
   empty temp-table ttGrupos.   
   empty temp-table ttEnderecos.

   if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hClienteSoap) then do:
      run ListarNovos in hClienteSoap(input 0 /** LojaCodigo **/, output lcSoapResult) no-error.
         
      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo ListarNovos no Web Service Ikeda.".
      else do:
         create x-document hRetorno.
         create x-noderef  hSoapResult.
         create x-noderef  hClientesListagem.
         create x-noderef  hclsClientesList.
         create x-noderef  hRegistro.
         create x-noderef  hGrupos.
         create x-noderef  hEnderecos.
         create x-noderef  hCampos.
         create x-noderef  hValor.
         create x-noderef  hAux.

         hRetorno:load("LONGCHAR",lcSoapResult,no).
         hRetorno:get-document-element(hSoapResult).

         repeat cont1 = 1 to hSoapResult:num-children:
            hSoapResult:get-child(hAux,cont1).

            if (hAux:name = "CodigoMensagem") then do:
               hAux:get-child(hValor,1).
               iStatus = int(hValor:node-value) no-error.
            end.
            else if (hAux:name = "Mensagem") then do:
               hAux:get-child(hValor,1).
               cStatus = hValor:node-value no-error.
            end.
            else if (hAux:name = "ClientesListagem") then do:
               hClientesListagem = hAux.
            end.
         end.

         if (iStatus = 1) then do:
            create buffer bUsuario   for table "ttUsuario".
            create buffer bConta     for table "ttConta".
            create buffer bGrupos    for table "ttGrupos".
            create buffer bEnderecos for table "ttEnderecos".

            repeat cont1 = 1 to hClientesListagem:num-children:
               hClientesListagem:get-child(hclsClientesList,cont1).

               repeat cont2 = 1 to hclsClientesList:num-children:
                  hclsClientesList:get-child(hRegistro,cont2).

                  if (hRegistro:name = "Usuario") then do:
                     bUsuario:buffer-create().
                     repeat iNumFields = 1 to hRegistro:num-children:
                        hRegistro:get-child(hCampos, iNumFields).
                        if (hCampos:subtype ne 'ELEMENT':U) then next.
                        if (hCampos:num-children < 1) then next.
                        hField = bUsuario:buffer-field(hCampos:name) no-error.
                        if (hField = ?) then next.
                        hCampos:get-child(hValor, 1).
                        hField:buffer-value = trim(hValor:node-value) no-error.
                     end.
                  end.
                  else if (hRegistro:name = "Conta") then do:
                     bConta:buffer-create().
                     repeat iNumFields = 1 to hRegistro:num-children:
                        hRegistro:get-child(hCampos, iNumFields).
                        if (hCampos:subtype ne 'ELEMENT':U) then next.
                        if (hCampos:num-children < 1) then next.
                        hField = bConta:buffer-field(hCampos:name) no-error.
                        if (hField = ?) then next.
                        hCampos:get-child(hValor, 1).
                        hField:buffer-value = trim(hValor:node-value) no-error.
                     end.
                  end.
                  else if (hRegistro:name = "Grupos") then do:
                     repeat iNumRecords = 1 to hRegistro:num-children:
                        hRegistro:get-child(hGrupos, iNumRecords).
                        bGrupos:buffer-create().
                        repeat iNumFields = 1 to hGrupos:num-children:
                           hGrupos:get-child(hCampos, iNumFields).
                           if (hCampos:subtype ne 'ELEMENT':U) then next.
                           if (hCampos:num-children < 1) then next.
                           hField = bGrupos:buffer-field(hCampos:name) no-error.
                           if (hField = ?) then next.
                           hCampos:get-child(hValor, 1).
                           hField:buffer-value = trim(hValor:node-value) no-error.
                        end.
                     end.
                  end.
                  else if (hRegistro:name = "Enderecos") then do:
                     repeat iNumRecords = 1 to hRegistro:num-children:
                        hRegistro:get-child(hEnderecos, iNumRecords).
                        bEnderecos:buffer-create().
                        repeat iNumFields = 1 to hEnderecos:num-children:
                           hEnderecos:get-child(hCampos, iNumFields).
                           if (hCampos:subtype ne 'ELEMENT':U) then next.
                           if (hCampos:num-children < 1) then next.
                           hField = bEnderecos:buffer-field(hCampos:name) no-error.
                           if (hField = ?) then next.
                           hCampos:get-child(hValor, 1).
                           hField:buffer-value = trim(hValor:node-value) no-error.
                        end.
                     end.
                  end.
               end.
            end.
         end.

         if (valid-handle(bUsuario)) then
            delete widget bUsuario.
         if (valid-handle(bConta)) then
            delete widget bConta.
         if (valid-handle(bGrupos)) then
            delete widget bGrupos.
         if (valid-handle(bEnderecos)) then
            delete widget bEnderecos.

         if (valid-handle(hAux)) then
            delete object hAux.
         if (valid-handle(hValor)) then
            delete object hValor.
         if (valid-handle(hCampos)) then
            delete object hCampos.
         if (valid-handle(hEnderecos)) then
            delete object hEnderecos.
         if (valid-handle(hGrupos)) then
            delete object hGrupos.
         if (valid-handle(hRegistro)) then
            delete object hRegistro.
         if (valid-handle(hclsClientesList)) then
            delete object hclsClientesList.
         if (valid-handle(hClientesListagem)) then
            delete object hClientesListagem.
         if (valid-handle(hSoapResult)) then
            delete object hSoapResult.
         if (valid-handle(hRetorno)) then
            delete object hRetorno.
      end.
   end.
end procedure.

procedure listarCpfCnpj:
   define input  parameter cpf      as character   no-undo.
   define input  parameter cnpj     as character   no-undo.
   define output parameter iStatus  as integer     no-undo.
   define output parameter cStatus  as character   no-undo.
   define output parameter table for ttUsuario.
   define output parameter table for ttConta.
   define output parameter table for ttGrupos.
   define output parameter table for ttEnderecos.

   empty temp-table ttUsuario.  
   empty temp-table ttConta.    
   empty temp-table ttGrupos.   
   empty temp-table ttEnderecos.

   if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hClienteSoap) then do:
      run ListarCpfCnpj in hClienteSoap(input 0 /** LojaCodigo **/, input cpf, input cnpj, output lcSoapResult) no-error.
         
      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo ListarCpfCnpj no Web Service Ikeda.".
      else do:
         create x-document hRetorno.
         create x-noderef  hSoapResult.
         create x-noderef  hClientesListagem.
         create x-noderef  hclsClientesList.
         create x-noderef  hRegistro.
         create x-noderef  hGrupos.
         create x-noderef  hEnderecos.
         create x-noderef  hCampos.
         create x-noderef  hValor.
         create x-noderef  hAux.

         hRetorno:load("LONGCHAR",lcSoapResult,no).
         hRetorno:get-document-element(hSoapResult).

         repeat cont1 = 1 to hSoapResult:num-children:
            hSoapResult:get-child(hAux,cont1).

            if (hAux:name = "CodigoMensagem") then do:
               hAux:get-child(hValor,1).
               iStatus = int(hValor:node-value) no-error.
            end.
            else if (hAux:name = "Mensagem") then do:
               hAux:get-child(hValor,1).
               cStatus = hValor:node-value no-error.
            end.
            else if (hAux:name = "ClientesListagem") then do:
               hClientesListagem = hAux.
            end.
         end.

         if (iStatus = 1) then do:
            create buffer bUsuario   for table "ttUsuario".
            create buffer bConta     for table "ttConta".
            create buffer bGrupos    for table "ttGrupos".
            create buffer bEnderecos for table "ttEnderecos".

            repeat cont1 = 1 to hClientesListagem:num-children:
               hClientesListagem:get-child(hclsClientesList,cont1).

               repeat cont2 = 1 to hclsClientesList:num-children:
                  hclsClientesList:get-child(hRegistro,cont2).

                  if (hRegistro:name = "Usuario") then do:
                     bUsuario:buffer-create().
                     repeat iNumFields = 1 to hRegistro:num-children:
                        hRegistro:get-child(hCampos, iNumFields).
                        if (hCampos:subtype ne 'ELEMENT':U) then next.
                        if (hCampos:num-children < 1) then next.
                        hField = bUsuario:buffer-field(hCampos:name) no-error.
                        if (hField = ?) then next.
                        hCampos:get-child(hValor, 1).
                        hField:buffer-value = trim(hValor:node-value) no-error.
                     end.
                  end.
                  else if (hRegistro:name = "Conta") then do:
                     bConta:buffer-create().
                     repeat iNumFields = 1 to hRegistro:num-children:
                        hRegistro:get-child(hCampos, iNumFields).
                        if (hCampos:subtype ne 'ELEMENT':U) then next.
                        if (hCampos:num-children < 1) then next.
                        hField = bConta:buffer-field(hCampos:name) no-error.
                        if (hField = ?) then next.
                        hCampos:get-child(hValor, 1).
                        hField:buffer-value = trim(hValor:node-value) no-error.
                     end.
                  end.
                  else if (hRegistro:name = "Grupos") then do:
                     repeat iNumRecords = 1 to hRegistro:num-children:
                        hRegistro:get-child(hGrupos, iNumRecords).
                        bGrupos:buffer-create().
                        repeat iNumFields = 1 to hGrupos:num-children:
                           hGrupos:get-child(hCampos, iNumFields).
                           if (hCampos:subtype ne 'ELEMENT':U) then next.
                           if (hCampos:num-children < 1) then next.
                           hField = bGrupos:buffer-field(hCampos:name) no-error.
                           if (hField = ?) then next.
                           hCampos:get-child(hValor, 1).
                           hField:buffer-value = trim(hValor:node-value) no-error.
                        end.
                     end.
                  end.
                  else if (hRegistro:name = "Enderecos") then do:
                     repeat iNumRecords = 1 to hRegistro:num-children:
                        hRegistro:get-child(hEnderecos, iNumRecords).
                        bEnderecos:buffer-create().
                        repeat iNumFields = 1 to hEnderecos:num-children:
                           hEnderecos:get-child(hCampos, iNumFields).
                           if (hCampos:subtype ne 'ELEMENT':U) then next.
                           if (hCampos:num-children < 1) then next.
                           hField = bEnderecos:buffer-field(hCampos:name) no-error.
                           if (hField = ?) then next.
                           hCampos:get-child(hValor, 1).
                           hField:buffer-value = trim(hValor:node-value) no-error.
                        end.
                     end.
                  end.
               end.
            end.
         end.

         if (valid-handle(bUsuario)) then
            delete widget bUsuario.
         if (valid-handle(bConta)) then
            delete widget bConta.
         if (valid-handle(bGrupos)) then
            delete widget bGrupos.
         if (valid-handle(bEnderecos)) then
            delete widget bEnderecos.

         if (valid-handle(hAux)) then
            delete object hAux.
         if (valid-handle(hValor)) then
            delete object hValor.
         if (valid-handle(hCampos)) then
            delete object hCampos.
         if (valid-handle(hEnderecos)) then
            delete object hEnderecos.
         if (valid-handle(hGrupos)) then
            delete object hGrupos.
         if (valid-handle(hRegistro)) then
            delete object hRegistro.
         if (valid-handle(hclsClientesList)) then
            delete object hclsClientesList.
         if (valid-handle(hClientesListagem)) then
            delete object hClientesListagem.
         if (valid-handle(hSoapResult)) then
            delete object hSoapResult.
         if (valid-handle(hRetorno)) then
            delete object hRetorno.
      end.
   end.
end procedure.

procedure validarBaixa:
   define input  parameter CodigoClienteWEB     as integer     no-undo.
   define input  parameter CodigoInternoCliente as character   no-undo.
   define output parameter iStatus              as integer     no-undo.
   define output parameter cStatus              as character   no-undo.

   if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hClienteSoap) then do:
      run ValidarBaixa in hClienteSoap(input 0 /** LojaCodigo **/, input CodigoClienteWEB, input CodigoInternoCliente, output lcSoapResult) no-error.
         
      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo ValidarBaixa no Web Service Ikeda.".
      else do:
         create x-document hRetorno.
         create x-noderef  hSoapResult.
         create x-noderef  hValor.
         create x-noderef  hAux.

         hRetorno:load("LONGCHAR",lcSoapResult,no).
         hRetorno:get-document-element(hSoapResult).

         repeat cont1 = 1 to hSoapResult:num-children:
            hSoapResult:get-child(hAux,cont1).

            if (hAux:name = "CodigoMensagem") then do:
               hAux:get-child(hValor,1).
               iStatus = int(hValor:node-value) no-error.
            end.
            else if (hAux:name = "Mensagem") then do:
               hAux:get-child(hValor,1).
               cStatus = hValor:node-value no-error.
            end.
         end.

         if (valid-handle(hAux)) then
            delete object hAux.
         if (valid-handle(hValor)) then
            delete object hValor.
         if (valid-handle(hSoapResult)) then
            delete object hSoapResult.
         if (valid-handle(hRetorno)) then
            delete object hRetorno.
      end.
   end.
end procedure.

procedure desconecta:
   if (valid-handle(hWebService)) and (hWebService:connected()) then
      hWebService:disconnect() no-error.
   if (valid-handle(hWebService)) then
      delete object hWebService.
end procedure.
