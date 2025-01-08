/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp044rpe-ws.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Setembro/2010 - Desenvolvimento
**  Descricao.: Integra‡Æo WS Itens - Ikeda
-----------------------------------------------------------------------*/

create widget-pool.

/** Defini‡Æo das temp-tables **/
{esp/pdp/espdp063rpa-tt.i}

define new global shared variable cXMLDirTestFiles as character no-undo.

define variable cont1               as integer  no-undo.
define variable cont2               as integer  no-undo.

define variable bProduto            as handle   no-undo.
define variable hSoapResult         as handle   no-undo.
define variable hAux                as handle   no-undo.
define variable hProdutos           as handle   no-undo.
define variable hclsProduto         as handle   no-undo.
define variable hCampos             as handle   no-undo.
define variable hRegistro           as handle   no-undo.
define variable hValor              as handle   no-undo.
define variable hField              as handle   no-undo.

define variable lcSoapResult        as longchar no-undo.
define variable hWebService         as handle   no-undo.
define variable hProdutoSoap        as handle   no-undo.
define variable hRetorno            as handle   no-undo.

procedure conecta:
   define output parameter iStatus  as integer     no-undo.
   define output parameter cStatus  as character   no-undo.

   find param-b2c no-lock no-error.

   create server hWebService.
   hWebService:connect("-WSDL '" + param-b2c.url-webservices + "/Produto.asmx?WSDL'") no-error.
   if (hWebService:connected()) then do:
      run ProdutoSoap set hProdutoSoap on hWebService no-error.
    
      if (error-status:error) then
         assign iStatus = 98
                cStatus = "Erro ao carregar o PortType ProdutoSoap no Web Service Ikeda.".
      else
         assign iStatus = 1.
   end.
   else
      assign iStatus = 99
             cStatus = "Web Service B2C Ikeda nao disponivel para conexao.".
end procedure.

procedure salvarProdutoPai:
   define input  parameter CodigoInternoProduto          as character   no-undo.
   define input  parameter CodigoInternoFabricante       as character   no-undo.
   define input  parameter NomeProduto                   as character   no-undo.
   define input  parameter TituloProduto                 as character   no-undo.
   define input  parameter SubTituloProduto              as character   no-undo.
   define input  parameter DescricaoProduto              as character   no-undo.
   define input  parameter CaracteristicaProduto         as character   no-undo.
   define input  parameter CodigoInternoEnquadramento    as character   no-undo.
   define input  parameter ModeloProduto                 as character   no-undo.
   define input  parameter PesoProduto                   as decimal     no-undo.
   define input  parameter PesoEmbalagemProduto          as decimal     no-undo.
   define input  parameter AlturaProduto                 as decimal     no-undo.
   define input  parameter AlturaEmbalagemProduto        as decimal     no-undo.
   define input  parameter LarguraProduto                as decimal     no-undo.
   define input  parameter LarguraEmbalagemProduto       as decimal     no-undo.
   define input  parameter ProfundidadeProduto           as decimal     no-undo.
   define input  parameter ProfundidadeEmbalagemProduto  as decimal     no-undo.
   define input  parameter VoltagemProduto               as integer     no-undo.
   define input  parameter EntregaProduto                as integer     no-undo.
   define input  parameter QuantidadeMaximaPorVenda      as integer     no-undo.
   define input  parameter ProdutoStatus                 as integer     no-undo.
   define input  parameter StatusIntegracao              as integer     no-undo.
   define input  parameter TipoProduto                   as character   no-undo.
   define input  parameter Presente                      as integer     no-undo.
   define input  parameter PrecoCheioProduto             as decimal     no-undo.
   define input  parameter PrecoPor                      as decimal     no-undo.
   define input  parameter PersonalizacaoExtra           as integer     no-undo.
   define input  parameter PersonalizacaoLabel           as character   no-undo.
   define output parameter iStatus                       as integer     no-undo.
   define output parameter cStatus                       as character   no-undo.

   if (valid-handle(hWebService)) and (hWebService:connected()) and (valid-handle(hProdutoSoap)) then do:
      run SalvarProdutoPai in hProdutoSoap(input 0 /** LojaCodigo **/,
                                           input CodigoInternoProduto,
                                           input CodigoInternoFabricante /** ?? **/,
                                           input NomeProduto,
                                           input TituloProduto,
                                           input SubTituloProduto,
                                           input DescricaoProduto,
                                           input CaracteristicaProduto,
                                           input '', input '', input '', input '', input '', input '', input '', input '', input '', input '', /** Texto1..10Produto **/
                                           input 0, input 0, input 0, input 0, input 0, input 0, input 0, input 0, input 0, input 0, /** Numero1..10Produto **/
                                           input CodigoInternoEnquadramento /** ?? **/,
                                           input ModeloProduto /** ?? **/,
                                           input PesoProduto,
                                           input PesoEmbalagemProduto,
                                           input AlturaProduto,
                                           input AlturaEmbalagemProduto,
                                           input LarguraProduto,
                                           input LarguraEmbalagemProduto,
                                           input ProfundidadeProduto,
                                           input ProfundidadeEmbalagemProduto,
                                           input VoltagemProduto,
                                           input EntregaProduto,
                                           input QuantidadeMaximaPorVenda,
                                           input ProdutoStatus,
                                           input StatusIntegracao,
                                           input TipoProduto,
                                           input Presente,
                                           input PrecoCheioProduto,
                                           input PrecoPor,
                                           input PersonalizacaoExtra,
                                           input PersonalizacaoLabel,
                                           output lcSoapResult) no-error.

      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo SalvarProdutoPai no Web Service Ikeda. " + error-status:get-message(1).
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

procedure listarCodigoInterno:
   define input  parameter CodigoInternoProduto          as character   no-undo.
   define input  parameter CodigoInternoFabricante       as character   no-undo.
   define input  parameter NomeProduto                   as character   no-undo.
   define input  parameter ProdutoStatus                 as integer     no-undo.
   define input  parameter TipoProduto                   as character   no-undo.
   define output parameter iStatus                       as integer     no-undo.
   define output parameter cStatus                       as character   no-undo.
   define output parameter table for ttProduto.

   empty temp-table ttProduto.

   if (valid-handle(hWebService)) and (hWebService:connected()) and (valid-handle(hProdutoSoap)) then do:
      run ListarCodigoInterno in hProdutoSoap(input 0 /** LojaCodigo **/,
                                              input CodigoInternoProduto,
                                              input CodigoInternoFabricante /** ?? **/,
                                              input NomeProduto,
                                              input ProdutoStatus,
                                              input TipoProduto,
                                              output lcSoapResult) no-error.

      if (error-status:error) then
         assign iStatus = 97
                cStatus = "Erro ao carregar o Metodo ListarCodigoInterno no Web Service Ikeda. " + error-status:get-message(1).
      else do:
         create x-document hRetorno.
         create x-noderef  hSoapResult.
         create x-noderef  hCampos.
         create x-noderef  hValor.
         create x-noderef  hAux.
         create x-noderef  hProdutos.
         create x-noderef  hclsProduto.

         hRetorno:load("LONGCHAR",lcSoapResult,no).
         hRetorno:get-document-element(hSoapResult).

         create buffer bProduto for table "ttProduto".

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
            else if (hAux:name = "Produtos") then
               hProdutos = hAux.
         end.

         repeat cont1 = 1 to hProdutos:num-children:
            hProdutos:get-child(hclsProduto,cont1).

            bProduto:buffer-create().
            repeat cont2 = 1 to hclsProduto:num-children:
               hclsProduto:get-child(hCampos,cont2).
               if hCampos:subtype ne 'ELEMENT':U then next.
               if hCampos:num-children < 1 then next.
               hField = bProduto:buffer-field(hCampos:name) no-error.
               if (hField = ?) then next.
               hCampos:get-child(hValor, 1).
               hField:buffer-value = hValor:node-value no-error.
            end.
         end.

         delete widget bProduto.

         if (valid-handle(hclsProduto)) then
            delete object hclsProduto.
         if (valid-handle(hProdutos)) then
            delete object hProdutos.
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
