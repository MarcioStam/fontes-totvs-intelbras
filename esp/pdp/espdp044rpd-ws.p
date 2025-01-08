/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp044rpd-ws.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Setembro/2010 - Desenvolvimento
**  Descricao.: Integra‡Æo WS Estoque - Ikeda
-----------------------------------------------------------------------*/

create widget-pool.

/** Defini‡Æo das temp-tables **/
{esp/pdp/espdp044rpd-tt.i}

define new global shared variable cXMLDirTestFiles as character no-undo.

define variable cont1         as integer  no-undo.
define variable cont2         as integer  no-undo.

define variable bEstoque      as handle   no-undo.
define variable lcSoapResult  as longchar no-undo.
define variable hWebService   as handle   no-undo.
define variable hRetorno      as handle   no-undo.
define variable hSoapResult   as handle   no-undo.
define variable hAux          as handle   no-undo.
define variable hCampos       as handle   no-undo.
define variable hRegistro     as handle   no-undo.
define variable hValor        as handle   no-undo.
define variable hField        as handle   no-undo.

define variable hEstoqueSoap  as handle   no-undo.

procedure conecta:
   define output parameter iStatus  as integer     no-undo.
   define output parameter cStatus  as character   no-undo.

   find param-b2c no-lock no-error.

   create server hWebService.
   hWebService:connect("-WSDL '" + param-b2c.url-webservices + "/Estoque.asmx?WSDL'") no-error.
   if (hWebService:connected()) then do:
      run EstoqueSoap set hEstoqueSoap on hWebService no-error.
    
      if (error-status:error) then
         assign iStatus = 98
                cStatus = "Erro ao carregar o PortType EstoqueSoap no Web Service Ikeda: " + error-status:get-message(1).
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

procedure retornarProdutoCodigoInterno:
   define input  parameter CodigoInternoProduto as character   no-undo.
   define output parameter iStatus              as integer     no-undo.
   define output parameter cStatus              as character   no-undo.
   define output parameter table for ttEstoque.

   empty temp-table ttEstoque.

   if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hEstoqueSoap) then do:
      run RetornarProdutoCodigoInterno in hEstoqueSoap(input 0 /** LojaCodigo **/, input CodigoInternoProduto, output lcSoapResult) no-error.
         
      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo RetornarProdutoCodigoInterno no Web Service Ikeda.".
      else do:
         create x-document hRetorno.
         create x-noderef  hSoapResult.
         create x-noderef  hCampos.
         create x-noderef  hValor.
         create x-noderef  hAux.

         hRetorno:load("LONGCHAR",lcSoapResult,no).
         hRetorno:get-document-element(hSoapResult).

         create buffer bEstoque for table "ttEstoque".

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
            else if (hAux:name = "clsEstoque") then do:
               bEstoque:buffer-create().
               repeat cont2 = 1 to hAux:num-children:
                  hAux:get-child(hCampos,cont2).
                  if (hCampos:subtype ne 'ELEMENT':U) then next.
                  if (hCampos:num-children < 1) then next.
                  hField = bEstoque:buffer-field(hCampos:name) no-error.
                  if (hField = ?) then next.
                  hCampos:get-child(hValor, 1).
                  hField:buffer-value = trim(hValor:node-value) no-error.
               end.
            end.
         end.

         if (valid-handle(bEstoque)) then
            delete widget bEstoque.

         if (valid-handle(hAux)) then
            delete object hAux.
         if (valid-handle(hValor)) then
            delete object hValor.
         if (valid-handle(hCampos)) then
            delete object hCampos.
         if (valid-handle(hSoapResult)) then
            delete object hSoapResult.
         if (valid-handle(hRetorno)) then
            delete object hRetorno.
      end.
   end.
end procedure.

procedure alterarProdutoCodigoInterno:
   define input  parameter CodigoInternoProduto as character   no-undo.
   define input  parameter QtdEstoque           as integer     no-undo.
   define input  parameter QtdMinima            as integer     no-undo.
   define output parameter iStatus              as integer     no-undo.
   define output parameter cStatus              as character   no-undo.
   define output parameter table for ttEstoque.

   empty temp-table ttEstoque.

   if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hEstoqueSoap) then do:
      run AlterarProdutoCodigoInterno in hEstoqueSoap(input 0 /** LojaCodigo **/,
                                                      input CodigoInternoProduto,
                                                      input QtdEstoque,
                                                      input QtdMinima,
                                                      input 3 /** TipoAlteracao 1-Subtrai, 2-Adiciona, 3-Substitui **/,
                                                      output lcSoapResult) no-error.
         
      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo AlterarProdutoCodigoInterno no Web Service Ikeda: " + error-status:get-message(1).
      else do:
         create x-document hRetorno.
         create x-noderef  hSoapResult.
         create x-noderef  hCampos.
         create x-noderef  hValor.
         create x-noderef  hAux.

         hRetorno:load("LONGCHAR",lcSoapResult,no).
         hRetorno:get-document-element(hSoapResult).

         create buffer bEstoque for table "ttEstoque".

         repeat cont1 = 1 to hSoapResult:num-children:
            hSoapResult:get-child(hAux,cont1).

            if (hAux:name = "CodigoMensagem") then do:
               hAux:get-child(hValor,1).
               iStatus = int(hValor:node-value) no-error.
            end.
            else if (hAux:name = "Mensagem") then do:
               hAux:get-child(hValor,1).
               cStatus = trim(hValor:node-value) no-error.
            end.
            else if (hAux:name = "clsEstoque") then do:
               bEstoque:buffer-create().
               repeat cont2 = 1 to hAux:num-children:
                  hAux:get-child(hCampos,cont2).
                  if (hCampos:subtype ne 'ELEMENT':U) then next.
                  if (hCampos:num-children < 1) then next.
                  hField = bEstoque:buffer-field(hCampos:name) no-error.
                  if (hField = ?) then next.
                  hCampos:get-child(hValor, 1).
                  hField:buffer-value = trim(hValor:node-value) no-error.
               end.
            end.
         end.

         if (valid-handle(bEstoque)) then
            delete widget bEstoque.

         if (valid-handle(hAux)) then
            delete object hAux.
         if (valid-handle(hValor)) then
            delete object hValor.
         if (valid-handle(hCampos)) then
            delete object hCampos.
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
