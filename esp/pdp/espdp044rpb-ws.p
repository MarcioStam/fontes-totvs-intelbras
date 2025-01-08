/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp044rpb-ws.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Setembro/2010 - Desenvolvimento
**  Descricao.: Integra‡Æo WS Pedidos - Ikeda
-----------------------------------------------------------------------*/

create widget-pool.

/** Defini‡Æo das temp-tables **/
{esp/pdp/espdp044rpb-tt.i}

define new global shared variable cXMLDirTestFiles as character no-undo.

define variable iNumRecords         as integer  no-undo.
define variable iNumFields          as integer  no-undo.
define variable cont1               as integer  no-undo.
define variable cont2               as integer  no-undo.

/** Vari veis de TT dinƒmica **/
define variable bPedido             as handle   no-undo.
define variable bCartao             as handle   no-undo.
define variable bItens              as handle   no-undo.
define variable hField              as handle   no-undo.

define variable hPedidosListagem    as handle   no-undo.
define variable hclsPedidosList     as handle   no-undo.
define variable hItens              as handle   no-undo.

define variable hSoapResult         as handle   no-undo.
define variable hAux                as handle   no-undo.
define variable hCampos             as handle   no-undo.
define variable hRegistro           as handle   no-undo.
define variable hValor              as handle   no-undo.

define variable lcSoapResult        as longchar no-undo.
define variable hWebService         as handle   no-undo.
define variable hPedidoSoap         as handle   no-undo.
define variable hRetorno            as handle   no-undo.
DEFINE VARIABLE cCpfCnpjOrigem      AS CHARACTER   NO-UNDO.

procedure conecta:
   define output parameter iStatus  as integer     no-undo.
   define output parameter cStatus  as character   no-undo.

   find param-b2c no-lock no-error.

   create server hWebService.
   hWebService:connect("-WSDL '" + param-b2c.url-webservices + "/Pedido.asmx?WSDL'") no-error.
   if (hWebService:connected()) then do:
      run PedidoSoap set hPedidoSoap on hWebService no-error.
    
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
   define input  parameter PedidoStatus   as integer     no-undo.
   define output parameter iStatus        as integer     no-undo.
   define output parameter cStatus        as character   no-undo.
   define output parameter table for ttPedido.
   define output parameter table for ttCartao.
   define output parameter table for ttItens.

   empty temp-table ttPedido.
   empty temp-table ttCartao.
   empty temp-table ttItens.

   if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hPedidoSoap) then do:
      run ListarNovos in hPedidoSoap(input 0 /** LojaCodigo **/, input PedidoStatus, input '' /** PedidoStatusInterno **/, output lcSoapResult) no-error.
         
      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo ListarNovos no Web Service Ikeda.".
      else do:
         create x-document hRetorno.
         create x-noderef  hSoapResult.
         create x-noderef  hPedidosListagem.
         create x-noderef  hclsPedidosList.
         create x-noderef  hRegistro.
         create x-noderef  hItens.
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
            else if (hAux:name = "PedidosListagem") then do:
               hPedidosListagem = hAux.
            end.
         end.

         if (iStatus = 1) then do:
            create buffer bPedido for table "ttPedido".
            create buffer bCartao for table "ttCartao".
            create buffer bItens  for table "ttItens".

            assign cCpfCnpjOrigem = "".

            repeat cont1 = 1 to hPedidosListagem:num-children:
               hPedidosListagem:get-child(hclsPedidosList,cont1).

               repeat cont2 = 1 to hclsPedidosList:num-children:
                  hclsPedidosList:get-child(hRegistro,cont2).
                  
                   if (hRegistro:name = "CpfCnpjOrigem") then do:
                      if (hRegistro:num-children < 1) then next.
                      hRegistro:get-child(hValor,1).
                      cCpfCnpjOrigem = trim(hValor:node-value) no-error.
                  end.
                  if (hRegistro:name = "Pedido") then do:
                     bPedido:buffer-create().
                     repeat iNumFields = 1 to hRegistro:num-children:
                        hRegistro:get-child(hCampos, iNumFields).
                        if (hCampos:subtype ne 'ELEMENT':U) then next.
                        if (hCampos:num-children < 1) then next.
                        hField = bPedido:buffer-field(hCampos:name) no-error.
                        if (hField = ?) then next.
                        hCampos:get-child(hValor, 1).
                        hField:buffer-value = trim(hValor:node-value) no-error.
                     end.
                     hField = bPedido:buffer-field("CpfCnpjOrigem") no-error.
                     if (hField = ?) then next.
                     hField:buffer-value = cCpfCnpjOrigem no-error.
                  end.
                  else if (hRegistro:name = "Cartao") then do:
                     bCartao:buffer-create().
                     repeat iNumFields = 1 to hRegistro:num-children:
                        hRegistro:get-child(hCampos, iNumFields).
                        if (hCampos:subtype ne 'ELEMENT':U) then next.
                        if (hCampos:num-children < 1) then next.
                        hField = bCartao:buffer-field(hCampos:name) no-error.
                        if (hField = ?) then next.
                        hCampos:get-child(hValor, 1).
                        hField:buffer-value = trim(hValor:node-value) no-error.
                     end.
                  end.
                  else if (hRegistro:name = "Itens") then do:
                     repeat iNumRecords = 1 to hRegistro:num-children:
                        hRegistro:get-child(hItens, iNumRecords).
                        bItens:buffer-create().
                        repeat iNumFields = 1 to hItens:num-children:
                           hItens:get-child(hCampos, iNumFields).
                           if (hCampos:subtype ne 'ELEMENT':U) then next.
                           if (hCampos:num-children < 1) then next.
                           hField = bItens:buffer-field(hCampos:name) no-error.
                           if (hField = ?) then next.
                           hCampos:get-child(hValor, 1).
                           hField:buffer-value = trim(hValor:node-value) no-error.
                        end.
                     end.
                  end.
               end.
            end.
         end.

         if (valid-handle(bPedido)) then
            delete widget bPedido.
         if (valid-handle(bCartao)) then
            delete widget bCartao.
         if (valid-handle(bItens)) then
            delete widget bItens.

         if (valid-handle(hAux)) then
            delete object hAux.
         if (valid-handle(hValor)) then
            delete object hValor.
         if (valid-handle(hCampos)) then
            delete object hCampos.
         if (valid-handle(hItens)) then
            delete object hItens.
         if (valid-handle(hRegistro)) then
            delete object hRegistro.
         if (valid-handle(hclsPedidosList)) then
            delete object hclsPedidosList.
         if (valid-handle(hPedidosListagem)) then
            delete object hPedidosListagem.
         if (valid-handle(hSoapResult)) then
            delete object hSoapResult.
         if (valid-handle(hRetorno)) then
            delete object hRetorno.
      end.
   end.
end procedure.

procedure listar:
   define input  parameter CodigoPedido   as integer     no-undo.
   define output parameter iStatus        as integer     no-undo.
   define output parameter cStatus        as character   no-undo.
   define output parameter table for ttPedido.
   define output parameter table for ttCartao.
   define output parameter table for ttItens.

   empty temp-table ttPedido.
   empty temp-table ttCartao.
   empty temp-table ttItens.

  if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hPedidoSoap) then do:
      run Listar in hPedidoSoap(input 0 /** LojaCodigo **/, input CodigoPedido, input 0 /** PedidoStatus **/, input '' /** PedidoStatusInterno **/, output lcSoapResult) no-error.
         
      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo Listar no Web Service Ikeda.".
      else do:
         create x-document hRetorno.
         create x-noderef  hSoapResult.
         create x-noderef  hPedidosListagem.
         create x-noderef  hclsPedidosList.
         create x-noderef  hRegistro.
         create x-noderef  hItens.
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
            else if (hAux:name = "PedidosListagem") then do:
               hPedidosListagem = hAux.
            end.
         end.

         if (iStatus = 1) then do:
            create buffer bPedido for table "ttPedido".
            create buffer bCartao for table "ttCartao".
            create buffer bItens  for table "ttItens".

            assign cCpfCnpjOrigem = "".

            repeat cont1 = 1 to hPedidosListagem:num-children:
               hPedidosListagem:get-child(hclsPedidosList,cont1).

               repeat cont2 = 1 to hclsPedidosList:num-children:
                  hclsPedidosList:get-child(hRegistro,cont2).

                  if (hRegistro:name = "CpfCnpjOrigem") then do:
                     if (hRegistro:num-children < 1) then next.
                     hRegistro:get-child(hValor,1).
                     cCpfCnpjOrigem = trim(hValor:node-value) no-error.
                  end.
                  if (hRegistro:name = "Pedido") then do:
                     bPedido:buffer-create().
                     repeat iNumFields = 1 to hRegistro:num-children:
                        hRegistro:get-child(hCampos, iNumFields).
                        if (hCampos:subtype ne 'ELEMENT':U) then next.
                        if (hCampos:num-children < 1) then next.
                        hField = bPedido:buffer-field(hCampos:name) no-error.
                        if (hField = ?) then next.
                        hCampos:get-child(hValor, 1).
                        hField:buffer-value = trim(hValor:node-value) no-error.
                     end.
                     hField = bPedido:buffer-field("CpfCnpjOrigem") no-error.
                     if (hField = ?) then next.
                     hField:buffer-value = cCpfCnpjOrigem no-error.

                  end.
                  else if (hRegistro:name = "Cartao") then do:
                     bCartao:buffer-create().
                     repeat iNumFields = 1 to hRegistro:num-children:
                        hRegistro:get-child(hCampos, iNumFields).
                        if (hCampos:subtype ne 'ELEMENT':U) then next.
                        if (hCampos:num-children < 1) then next.
                        hField = bCartao:buffer-field(hCampos:name) no-error.
                        if (hField = ?) then next.
                        hCampos:get-child(hValor, 1).
                        hField:buffer-value = trim(hValor:node-value) no-error.
                     end.
                  end.
                  else if (hRegistro:name = "Itens") then do:
                     repeat iNumRecords = 1 to hRegistro:num-children:
                        hRegistro:get-child(hItens, iNumRecords).
                        bItens:buffer-create().
                        repeat iNumFields = 1 to hItens:num-children:
                           hItens:get-child(hCampos, iNumFields).
                           if (hCampos:subtype ne 'ELEMENT':U) then next.
                           if (hCampos:num-children < 1) then next.
                           hField = bItens:buffer-field(hCampos:name) no-error.
                           if (hField = ?) then next.
                           hCampos:get-child(hValor, 1).
                           hField:buffer-value = trim(hValor:node-value) no-error.
                        end.
                     end.
                  end.
               end.
            end.
         end.

         if (valid-handle(bPedido)) then
            delete widget bPedido.
         if (valid-handle(bCartao)) then
            delete widget bCartao.
         if (valid-handle(bItens)) then
            delete widget bItens.

         if (valid-handle(hAux)) then
            delete object hAux.
         if (valid-handle(hValor)) then
            delete object hValor.
         if (valid-handle(hCampos)) then
            delete object hCampos.
         if (valid-handle(hItens)) then
            delete object hItens.
         if (valid-handle(hRegistro)) then
            delete object hRegistro.
         if (valid-handle(hclsPedidosList)) then
            delete object hclsPedidosList.
         if (valid-handle(hPedidosListagem)) then
            delete object hPedidosListagem.
         if (valid-handle(hSoapResult)) then
            delete object hSoapResult.
         if (valid-handle(hRetorno)) then
            delete object hRetorno.
      end.
   end.
end procedure.

procedure validarBaixa:
   define input  parameter CodigoPedido         as integer     no-undo.
   define input  parameter CodigoInternoPedido  as character   no-undo.
   define output parameter iStatus              as integer     no-undo.
   define output parameter cStatus              as character   no-undo.

   if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hPedidoSoap) then do:
      run Validar in hPedidoSoap(input 0 /** LojaCodigo **/, input CodigoPedido, input CodigoInternoPedido, output lcSoapResult) no-error.
         
      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo Validar no Web Service Ikeda.".
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

procedure alterarStatus:
   define input  parameter CodigoPedido         as integer     no-undo.
   define input  parameter CodigoInternoPedido  as character   no-undo.
   define input  parameter PedidoStatus         as integer     no-undo.
   define input  parameter PedidoStatusInterno  as character   no-undo.
   define input  parameter ObjetoSedex          as character   no-undo.
   define input  parameter NotaFiscal           as integer     no-undo.
   define input  parameter Serie                as character   no-undo.
   define output parameter iStatus              as integer     no-undo.
   define output parameter cStatus              as character   no-undo.

   if (valid-handle(hWebService)) and (hWebService:connected()) and valid-handle(hPedidoSoap) then do:
      run AlterarStatus in hPedidoSoap(input 0 /** LojaCodigo **/,
                                       input CodigoPedido,
                                       input CodigoInternoPedido,
                                       input PedidoStatus,
                                       input PedidoStatusInterno,
                                       input ObjetoSedex,
                                       input NotaFiscal,
                                       input Serie,
                                       output lcSoapResult) no-error.
         
      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo AlterarStatus no Web Service Ikeda.".
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
