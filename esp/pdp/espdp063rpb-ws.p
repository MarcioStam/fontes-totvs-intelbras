/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp063rpb-ws.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Outubro/2010 - Desenvolvimento
**  Descricao.: Integra‡Æo WS Categoria - Ikeda
-----------------------------------------------------------------------*/

create widget-pool.

define variable cont1               as integer  no-undo.

define variable hSoapResult         as handle   no-undo.
define variable hAux                as handle   no-undo.
define variable hValor              as handle   no-undo.

define variable lcSoapResult        as longchar no-undo.
define variable hWebService         as handle   no-undo.
define variable hCategoriaSoap      as handle   no-undo.
define variable hRetorno            as handle   no-undo.

procedure conecta:
   define output parameter iStatus  as integer     no-undo.
   define output parameter cStatus  as character   no-undo.

   find param-b2c no-lock no-error.

   create server hWebService.
   hWebService:connect("-WSDL '" + param-b2c.url-webservices + "/Categoria.asmx?WSDL'") no-error.
   if (hWebService:connected()) then do:
      run CategoriaSoap set hCategoriaSoap on hWebService no-error.
    
      if (error-status:error) then
         assign iStatus = 98
                cStatus = "Erro ao carregar o PortType CategoriaSoap no Web Service Ikeda.".
      else
         assign iStatus = 1.
   end.
   else
      assign iStatus = 99
             cStatus = "Web Service B2C Ikeda nao disponivel para conexao.".
end procedure.

procedure incluir:
   define input  parameter CodigoInternoCategoria  as character   no-undo.
   define input  parameter NomeCategoria           as character   no-undo.
   define input  parameter CategoriaStatus         as integer     no-undo.
   define input  parameter CategoriaPai            as character   no-undo.
   define output parameter iStatus                 as integer     no-undo.
   define output parameter cStatus                 as character   no-undo.

   if (valid-handle(hWebService)) and (hWebService:connected()) and (valid-handle(hCategoriaSoap)) then do:
      run Incluir in hCategoriaSoap(input 0 /** LojaCodigo **/,
                                    input CodigoInternoCategoria,
                                    input NomeCategoria,
                                    input CategoriaStatus,
                                    input CategoriaPai,
                                    output lcSoapResult) no-error.

      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo Incluir no Web Service Ikeda. " + error-status:get-message(1).
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
