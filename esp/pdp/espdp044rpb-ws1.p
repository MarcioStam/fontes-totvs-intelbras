/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp044rpb-ws1.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Setembro/2010 - Desenvolvimento
**  Descricao.: Integra‡Æo WS Pagador - Braspag
-----------------------------------------------------------------------*/

create widget-pool.

/** Defini‡Æo das temp-tables **/
{esp/pdp/espdp044rpb-tt.i}

define variable cont1               as integer  no-undo.

define variable hSoapResult         as handle   no-undo.
define variable hCampos             as handle   no-undo.
define variable hValor              as handle   no-undo.
define variable hField              as handle   no-undo.

define variable lcSoapResult        as longchar no-undo.
define variable hWebService         as handle   no-undo.
define variable hPedidoSoap         as handle   no-undo.
define variable hRetorno            as handle   no-undo.

/** Vari veis de TT dinƒmica **/
define variable bDadosPedido        as handle   no-undo.

procedure conecta:
   define output parameter iStatus  as integer     no-undo.
   define output parameter cStatus  as character   no-undo.

   create server hWebService.
   hWebService:connect("-WSDL 'https://www.pagador.com.br/pagador/webservice/pedido.asmx?WSDL' -nohostverify") no-error.
   if (hWebService:connected()) then do:
      run PedidoSoap set hPedidoSoap on hWebService no-error.
    
      if (error-status:error) then
         assign iStatus = 98
                cStatus = "Erro ao carregar o PortType PedidoSoap no Web Service Pagador: " + error-status:get-message(1).
      else
         assign iStatus = 1.
   end.
   else
      if (error-status:error) then
         assign iStatus = 99
                cStatus = "Web Service Pagador nao disponivel para conexao: " + error-status:get-message(1).
      else
         assign iStatus = 97
                cStatus = "Web Service Pagador nao disponivel para conexao, sem retornar erro".
end procedure.

procedure getDadosPedido:
   define input  parameter NumeroPedido   as character   no-undo.
   define output parameter iStatus        as integer     no-undo.
   define output parameter cStatus        as character   no-undo.
   define output parameter table for ttDadosPedido.

   empty temp-table ttDadosPedido.

   if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hPedidoSoap) then do:
      run GetDadosPedido in hPedidoSoap(input 'C534C2A6-AA0F-ADF9-39A6-DFBAE0614F77', input NumeroPedido, output lcSoapResult) no-error.

      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo GetDadosPedido no Web Service Pagador.".
      else do:
         assign iStatus = 1.

         create x-document hRetorno.
         create x-noderef  hSoapResult.
         create x-noderef  hValor.
         create x-noderef  hCampos.

         hRetorno:load("LONGCHAR",lcSoapResult,no).
         hRetorno:get-document-element(hSoapResult).

         create buffer bDadosPedido for table "ttDadosPedido".
         bDadosPedido:buffer-create().

         repeat cont1 = 1 to hSoapResult:num-children:
            hSoapResult:get-child(hCampos,cont1).
            if (hCampos:subtype ne 'ELEMENT':U) then next.
            if (hCampos:num-children < 1) then next.
            hField = bDadosPedido:buffer-field(hCampos:name) no-error.
            if (hField = ?) then next.
            hCampos:get-child(hValor, 1).
            hField:buffer-value = trim(hValor:node-value) no-error.
         end.

         delete widget bDadosPedido.

         if (valid-handle(hField)) then
            delete object hField.
         if (valid-handle(hCampos)) then
            delete object hCampos.
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
