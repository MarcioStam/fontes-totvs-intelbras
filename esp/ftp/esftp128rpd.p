block-level on error undo, throw.

/** Carrega bibliotecas necessarias **/
//USING OpenEdge.Core.*. 
USING OpenEdge.Core.String.
//USING OpenEdge.Net.HTTP.*. 
USING OpenEdge.Net.HTTP.IHttpClientLibrary.
USING OpenEdge.Net.HTTP.ConfigBuilder.
USING OpenEdge.Net.HTTP.ClientBuilder.
USING OpenEdge.Net.HTTP.Credentials.
USING OpenEdge.Net.HTTP.IHttpClient.
USING OpenEdge.Net.HTTP.IHttpRequest.
USING OpenEdge.Net.HTTP.IHttpResponse.
USING OpenEdge.Net.HTTP.RequestBuilder.
USING OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder. 
USING OpenEdge.Net.URI.
USING com.totvs.framework.api.*.
//USING Progress.Json.ObjectModel.*.
USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.JsonArray.

{esp/ftp/esftp128.i}

DEFINE INPUT PARAMETER p-plp AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttPlp.
DEFINE OUTPUT PARAMETER TABLE FOR ttResumoServicos.
DEFINE OUTPUT PARAMETER TABLE FOR ttDocsExternos.
DEFINE OUTPUT PARAMETER TABLE FOR ttDestinatario.
DEFINE OUTPUT PARAMETER TABLE FOR ttRemetente.
DEFINE OUTPUT PARAMETER TABLE FOR ttAwbs.
DEFINE OUTPUT PARAMETER TABLE FOR ttItens.

DEFINE VARIABLE oRequest AS IHttpRequest NO-UNDO.
DEFINE VARIABLE oResponse AS IHttpResponse NO-UNDO.
DEFINE VARIABLE oResponseMemptrEntity AS OpenEdge.Core.Memptr NO-UNDO. 
DEFINE VARIABLE oByteBucket AS OpenEdge.Core.ByteBucket NO-UNDO. 
DEFINE VARIABLE c-endereco AS CHAR NO-UNDO.
DEFINE VARIABLE c-retorno AS CHAR NO-UNDO.

DEFINE VARIABLE pJsonInput               AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObject               AS JsonObject   NO-UNDO.        
DEFINE VARIABLE jsonObjectPlp            AS JsonObject   NO-UNDO.        
DEFINE VARIABLE jsonObjectResumoServicos AS JsonObject   NO-UNDO. 
DEFINE VARIABLE jsonObjectDocsExternos   AS JsonObject   NO-UNDO.        
DEFINE VARIABLE jsonObjectDestinatario   AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectRemetente      AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectAwbs           AS JsonObject   NO-UNDO.
DEFINE VARIABLE jsonObjectItens          AS JsonObject   NO-UNDO.        
DEFINE VARIABLE jsonArrayResumoServicos  AS jsonArray    NO-UNDO.  
DEFINE VARIABLE jsonArrayDocsExternos    AS jsonArray    NO-UNDO. 
DEFINE VARIABLE jsonArrayAwbs            AS jsonArray    NO-UNDO. 
DEFINE VARIABLE jsonArrayItens           AS jsonArray    NO-UNDO. 

DEFINE VARIABLE iContResumoServicos AS INT NO-UNDO.
DEFINE VARIABLE iContDocsExternos AS INT NO-UNDO.
DEFINE VARIABLE iContItens AS INT NO-UNDO.
DEFINE VARIABLE iContAwbs AS INT NO-UNDO.



ASSIGN c-endereco = "https://api.skyhub.com.br/shipments/b2w/view?plp_id=" + p-plp.

oRequest = RequestBuilder:GET(c-endereco)
                         :AddHeader("x-api-key","KQTK8iqSZzny_JqvJYpL")
                         :AddHeader("x-user-email","leandro.jonk@intelbras.com.br")
                         :AddHeader("accept","application/json")
                         :Request.

oResponse = ClientBuilder:Build():Client:Execute(oRequest).

IF  oResponse:StatusCode = 200
AND oResponse:ContentType = "application/json" THEN DO:
    CAST(oResponse:Entity, JsonObject):Write(c-retorno, true).

    pJsonInput = CAST(oResponse:Entity, JsonObject).
    ASSIGN jsonObjectPlp = pJsonInput:GetJsonObject("plp").
    
    CREATE ttPlp.
    ASSIGN ttPlp.id            = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPlp, "id")).
           ttPlp.codExterno    = JsonAPIUtils:getPropertyJsonObject(jsonObjectPlp, "codExterno").
           ttPlp.dtEnvio       = JsonAPIUtils:getPropertyJsonObject(jsonObjectPlp, "dtEnvio").
           ttPlp.tpAgrupamento = JsonAPIUtils:getPropertyJsonObject(jsonObjectPlp, "tpAgrupamento").
    
    ASSIGN jsonArrayResumoServicos = jsonObjectPlp:GetJsonArray("resumoServicos").
    
    DO iContResumoServicos = 1 TO jsonArrayResumoServicos:LENGTH: 

        ASSIGN jsonObjectResumoServicos = jsonArrayResumoServicos:GetJsonObject(iContResumoServicos).
    
        CREATE ttResumoServicos.
        ASSIGN ttResumoServicos.idm            = iContResumoServicos.
               ttResumoServicos.codServico     = JsonAPIUtils:getPropertyJsonObject(jsonObjectResumoServicos, "codServico").    
               ttResumoServicos.nomeServico    = JsonAPIUtils:getPropertyJsonObject(jsonObjectResumoServicos, "nomeServico").    
               ttResumoServicos.quantidadeAwbs = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectResumoServicos, "quantidadeAwbs")).

    END.

    ASSIGN jsonArrayDocsExternos = pJsonInput:getJsonArray("docsExternos").
    DO iContDocsExternos = 1 TO jsonArrayDocsExternos:LENGTH: 

        ASSIGN jsonObjectDocsExternos = jsonArrayDocsExternos:GetJsonObject(iContDocsExternos).

        CREATE ttDocsExternos.
        ASSIGN ttDocsExternos.idm                       = iContDocsExternos.
               ttDocsExternos.codCliente                = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "codCliente").                 
               ttDocsExternos.docExterno                = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "docExterno").                 
               ttDocsExternos.dtPrometida               = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "dtPrometida").                
               ttDocsExternos.dtLimiteExpedicao         = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "dtLimiteExpedicao").          
               ttDocsExternos.dtLimiteExpedicaoCompleta = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "dtLimiteExpedicaoCompleta").  
               ttDocsExternos.tpEntrega                 = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "tpEntrega").                  
               ttDocsExternos.pesoTotal                 = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "pesoTotal")).                  
               ttDocsExternos.marca                     = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "marca").                      
               ttDocsExternos.qtVolumes                 = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "qtVolumes")).                  
               ttDocsExternos.numeroContratoTransp      = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "numeroContratoTransp").       
               ttDocsExternos.nomeEmbarcador            = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "nomeEmbarcador").             
               ttDocsExternos.telefoneEmbarcador        = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "telefoneEmbarcador")).         
               ttDocsExternos.emailEmbarcador           = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "emailEmbarcador").            
               ttDocsExternos.tpServico                 = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "tpServico").                  
               ttDocsExternos.numNotaFiscal             = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "numNotaFiscal").              
               ttDocsExternos.serieNotaFiscal           = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "serieNotaFiscal").            
               ttDocsExternos.megaRota                  = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "megaRota").                   
               ttDocsExternos.rota                      = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "rota").                       
               ttDocsExternos.telefoneContato           = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "telefoneContato").            
               ttDocsExternos.vlEntrega                 = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "vlEntrega")).                  
               ttDocsExternos.cartaoPostagem            = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "cartaoPostagem").             
               ttDocsExternos.servicoAdicional          = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "servicoAdicional").           
               ttDocsExternos.pedInLoja                 = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "pedInLoja").                  
               ttDocsExternos.tpLoja                    = JsonAPIUtils:getPropertyJsonObject(jsonObjectDocsExternos, "tpLoja").


        ASSIGN jsonObjectDestinatario = jsonObjectDocsExternos:GetJsonObject("destinatario").
    
        CREATE ttDestinatario.
        ASSIGN ttDestinatario.idm                 = iContDocsExternos.
               ttDestinatario.nome                = JsonAPIUtils:getPropertyJsonObject(jsonObjectDestinatario, "nome").                 
               ttDestinatario.enderecoLogradouro  = JsonAPIUtils:getPropertyJsonObject(jsonObjectDestinatario, "enderecoLogradouro").                 
               ttDestinatario.enderecoNumero      = JsonAPIUtils:getPropertyJsonObject(jsonObjectDestinatario, "enderecoNumero").                
               ttDestinatario.enderecoComplemento = JsonAPIUtils:getPropertyJsonObject(jsonObjectDestinatario, "enderecoComplemento").          
               ttDestinatario.enderecoBairro      = JsonAPIUtils:getPropertyJsonObject(jsonObjectDestinatario, "enderecoBairro").  
               ttDestinatario.enderecoReferencia  = JsonAPIUtils:getPropertyJsonObject(jsonObjectDestinatario, "enderecoReferencia").                  
               ttDestinatario.enderecoCidade      = JsonAPIUtils:getPropertyJsonObject(jsonObjectDestinatario, "enderecoCidade").                  
               ttDestinatario.enderecoUf          = JsonAPIUtils:getPropertyJsonObject(jsonObjectDestinatario, "enderecoUf").                      
               ttDestinatario.enderecoCep         = JsonAPIUtils:getPropertyJsonObject(jsonObjectDestinatario, "enderecoCep").  

        ASSIGN jsonObjectRemetente = jsonObjectDocsExternos:GetJsonObject("remetente").

        CREATE ttRemetente.
        ASSIGN ttRemetente.idm                 = iContDocsExternos.
               ttRemetente.nome                = JsonAPIUtils:getPropertyJsonObject(jsonObjectRemetente, "nome").                 
               ttRemetente.enderecoLogradouro  = JsonAPIUtils:getPropertyJsonObject(jsonObjectRemetente, "enderecoLogradouro").                 
               ttRemetente.enderecoNumero      = JsonAPIUtils:getPropertyJsonObject(jsonObjectRemetente, "enderecoNumero").                
               ttRemetente.enderecoComplemento = JsonAPIUtils:getPropertyJsonObject(jsonObjectRemetente, "enderecoComplemento").          
               ttRemetente.enderecoBairro      = JsonAPIUtils:getPropertyJsonObject(jsonObjectRemetente, "enderecoBairro").  
               ttRemetente.enderecoCidade      = JsonAPIUtils:getPropertyJsonObject(jsonObjectRemetente, "enderecoCidade").                  
               ttRemetente.enderecoUf          = JsonAPIUtils:getPropertyJsonObject(jsonObjectRemetente, "enderecoUf").                      
               ttRemetente.enderecoCep         = JsonAPIUtils:getPropertyJsonObject(jsonObjectRemetente, "enderecoCep").
               ttRemetente.enderecoReferencia  = JsonAPIUtils:getPropertyJsonObject(jsonObjectRemetente, "enderecoReferencia").

        ASSIGN jsonArrayAwbs = jsonObjectDocsExternos:getJsonArray("awbs").
        DO iContAwbs = 1 TO jsonArrayAwbs:LENGTH:
            ASSIGN jsonObjectAwbs = jsonArrayAwbs:GetJsonObject(iContAwbs).

            CREATE ttAwbs.
            ASSIGN ttAwbs.idm            = iContDocsExternos.
                   ttAwbs.codigoAwb      = JsonAPIUtils:getPropertyJsonObject(jsonObjectAwbs, "codigoAwb").                 
                   ttAwbs.posicaoVolume  = int(JsonAPIUtils:getPropertyJsonObject(jsonObjectAwbs, "posicaoVolume")).                 

            ASSIGN jsonArrayItens = jsonObjectAwbs:getJsonArray("itens").
            DO iContItens = 1 TO jsonArrayItens:LENGTH:
                ASSIGN jsonObjectItens = jsonArrayItens:GetJsonObject(iContItens).
    
                CREATE ttItens.
                ASSIGN ttItens.idm        = iContDocsExternos.
                       ttItens.descricao  = JsonAPIUtils:getPropertyJsonObject(jsonObjectItens, "descricao").                 
                       ttItens.quantidade = int(JsonAPIUtils:getPropertyJsonObject(jsonObjectItens, "quantidade")).
                       ttItens.peso       = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectItens, "peso")).
    
            END.
        END.
    END.
END.

RETURN "OK".
