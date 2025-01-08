{utp/ut-api.i}
{utp/ut-api-utils.i}        
/*{fwk/utils/fndApiServices.i}  */
{utp/ut-api-action.i pi-create  POST /~* }
{utp/ut-api-action.i pi-update  PUT  /~* }
{utp/ut-api-action.i pi-delete  DELETE  /~* }

{utp/ut-api-notfound.i}     
{esp/api/v1/simulacao.i}

DEFINE VARIABLE jsonItem          AS JsonObject  NO-UNDO.
DEFINE VARIABLE jsonErrors        AS JsonObject  NO-UNDO.
DEFINE VARIABLE jsonArrayItemR    AS jsonArray   NO-UNDO.
DEFINE VARIABLE jsonArrayErrors   AS jsonArray   NO-UNDO.

DEFINE VARIABLE iCont AS INTEGER NO-UNDO.                           

DEFINE VARIABLE jsonObjectOutput  AS JsonObject   NO-UNDO.        
DEFINE VARIABLE jsonObjectPayload AS jsonObject   NO-UNDO.        
DEFINE VARIABLE jsonObjectItem    AS jsonObject   NO-UNDO.        

DEFINE VARIABLE jsonArrayPayload             AS jsonArray  NO-UNDO.     
DEFINE VARIABLE jsonObjectSimulacaoDevolucao AS JsonObject NO-UNDO.   

DEFINE VARIABLE c-data-simul AS CHAR NO-UNDO.

/******** Inicio ********/

PROCEDURE pi-create:
   DEF INPUT  PARAM jsonInput  AS JsonObject NO-UNDO. 
   DEF OUTPUT PARAM jsonOutput AS JsonObject NO-UNDO.

   RUN pi-ler-json-entrada.
    
   RUN pi-criar-simulacao.

   RUN pi-criar-json-retorno.

   RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT FALSE, OUTPUT jsonOutput).
END.


PROCEDURE pi-update:
    DEF INPUT  PARAM jsonInput  AS JsonObject NO-UNDO. 
    DEF OUTPUT PARAM jsonOutput AS JsonObject NO-UNDO. 
    
    RUN pi-ler-json-entrada.
    
    RUN pi-alterar-simulacao.

    RUN pi-criar-json-retorno.

    RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT false, OUTPUT jsonOutput).
END.


PROCEDURE pi-delete:
    DEF INPUT  PARAM jsonInput  AS JsonObject NO-UNDO. 
    DEF OUTPUT PARAM jsonOutput AS JsonObject NO-UNDO. 

    RUN pi-ler-json-entrada.

    RUN pi-excluir-simulacao.

    RUN pi-criar-json-retorno.

    RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT false, OUTPUT jsonOutput).
END.

/******** Fim ********/

/******** Procedure Internas ********/
PROCEDURE pi-ler-json-entrada:

    IF jsonInput:has("payload") THEN DO:
       ASSIGN jsonObjectPayload            = jsonInput:GetJsonObject("payload").
       ASSIGN jsonObjectSimulacaoDevolucao = jsonObjectPayload:GetJsonObject("SimulacaoDevolucao").
    
       CREATE ttSimulacaoDevolucao.
       ASSIGN ttSimulacaoDevolucao.tipoDocumentoCliente   = JsonAPIUtils:getPropertyJsonObject(jsonObjectSimulacaoDevolucao, "tipoDocumentoCliente")  
              ttSimulacaoDevolucao.numeroDocumentoCliente = JsonAPIUtils:getPropertyJsonObject(jsonObjectSimulacaoDevolucao, "numeroDocumentoCliente")
              c-data-simul                                = JsonAPIUtils:getPropertyJsonObject(jsonObjectSimulacaoDevolucao, "dataSimulacao")   
              ttSimulacaoDevolucao.numeroSequencia        = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectSimulacaoDevolucao, "numeroSequencia"))  
              ttSimulacaoDevolucao.cnpjEstabelecimento    = JsonAPIUtils:getPropertyJsonObject(jsonObjectSimulacaoDevolucao, "cnpjEstabelecimento")   
              ttSimulacaoDevolucao.tipoNFe                = JsonAPIUtils:getPropertyJsonObject(jsonObjectSimulacaoDevolucao, "tipoNFe")               
              ttSimulacaoDevolucao.email                  = JsonAPIUtils:getPropertyJsonObject(jsonObjectSimulacaoDevolucao, "email")                 
              ttSimulacaoDevolucao.observacoes            = JsonAPIUtils:getPropertyJsonObject(jsonObjectSimulacaoDevolucao, "observacoes")           
              ttSimulacaoDevolucao.cnpjTransportadora     = JsonAPIUtils:getPropertyJsonObject(jsonObjectSimulacaoDevolucao, "cnpjTransportadora")    
              ttSimulacaoDevolucao.freteCIF               = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectSimulacaoDevolucao, "freteCIF")) .
    
       IF c-data-simul <> '' THEN
          ASSIGN c-data-simul = ENTRY(3,c-data-simul,'-') + '/' + ENTRY(2,c-data-simul,'-') + '/' + ENTRY(1,c-data-simul,'-').
                 ttSimulacaoDevolucao.dataSimulacao = DATE(c-data-simul).
    
       ASSIGN jsonArrayPayload = jsonObjectSimulacaoDevolucao:GetJsonArray("Item").
    
       DO iCont = 1 TO jsonArrayPayload:LENGTH:                     
          ASSIGN jsonObjectItem = jsonArrayPayload:GetJsonObject(iCont).
    
          CREATE ttItem.
          ASSIGN ttItem.codigoItem = JsonAPIUtils:getPropertyJsonObject(jsonObjectItem, "codigoItem").    
                 ttItem.quantidade = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectItem, "quantidade")).    
       END. 
    END.

END PROCEDURE.


PROCEDURE pi-criar-json-retorno:

   jsonObjectOutput = NEW JSONObject().

   IF NOT CAN-FIND (FIRST RowErrors) THEN DO:
      jsonObjectOutput:ADD("Status",200).

      FOR EACH ttSimulacaoDevolucaoR:
          jsonObjectOutput:ADD("cnpj"           ,ttSimulacaoDevolucaoR.cnpj).            
          jsonObjectOutput:ADD("dataSimulacao"  ,ttSimulacaoDevolucaoR.dataSimulacao  ).
          jsonObjectOutput:ADD("numeroSequencia",ttSimulacaoDevolucaoR.numeroSequencia).
          jsonObjectOutput:ADD("estabelecimento",ttSimulacaoDevolucaoR.estabelecimento).
      END.

      
      ASSIGN jsonArrayItemR = NEW JsonArray().
    
      FOR EACH ttItemR:
          jsonItem = NEW JSONObject().

          jsonItem:ADD("codigoItem"                  , ttItemR.codigoItem                 ).
          jsonItem:ADD("quantidade"                  , ttItemR.quantidade                 ).
          jsonItem:ADD("sequencia"                   , ttItemR.sequencia                  ).
          jsonItem:ADD("valorUnitario"               , ttItemR.valorUnitario              ).
          jsonItem:ADD("valorIPI"                    , ttItemR.valorIPI                   ).
          jsonItem:ADD("percentualIPI"               , ttItemR.percentualIPI              ).
          jsonItem:ADD("valorICMS"                   , ttItemR.valorICMS                  ).
          jsonItem:ADD("percentualICMS"              , ttItemR.percentualICMS             ).
          jsonItem:ADD("valorICMSST"                 , ttItemR.valorICMSST                ).
          jsonItem:ADD("valorICMSDifal"              , ttItemR.valorICMSDifal             ).
          jsonItem:ADD("valorPIS"                    , ttItemR.valorPIS                   ).
          jsonItem:ADD("valorCofins"                 , ttItemR.valorCofins                ).
          jsonItem:ADD("valorTotalItem"              , ttItemR.valorTotalItem             ).
          jsonItem:ADD("observacoes"                 , ttItemR.observacoes                ).
          jsonItem:ADD("numeroNotaOrigem"            , ttItemR.numeroNotaOrigem           ).
          jsonItem:ADD("serieOrigem"                 , ttItemR.serieOrigem                ).
          jsonItem:ADD("codigoEstabelecimentoOrigem" , ttItemR.codigoEstabelecimentoOrigem).
          jsonItem:ADD("garantia"                    , ttItemR.garantia                   ).
          jsonItem:ADD("baseICMSST"                  , ttItemR.baseICMSST                 ).
     
          jsonArrayItemR:ADD(jsonItem).
      END.

      jsonObjectOutput:ADD("Item",jsonArrayItemR).
   END.
   ELSE DO:
      ASSIGN jsonArrayErrors = NEW JsonArray().

      FOR EACH rowErrors:
          jsonErrors = NEW JSONObject().

          jsonErrors:ADD("ErrorNumber"      ,rowErrors.ErrorNumber      ).
          jsonErrors:ADD("ErrorDescription" ,rowErrors.ErrorDescription ).
          jsonErrors:ADD("ErrorParameters"  ,rowErrors.ErrorParameters  ).
          jsonErrors:ADD("ErrorType"        ,rowErrors.ErrorType        ).
          jsonArrayErrors:ADD(jsonErrors).
      END.
      
      /* Teste
      FOR EACH ttSimulacaoDevolucao:

            jsonErrors = NEW JSONObject().
    
            jsonErrors:ADD("tipoDocumentoCliente"   , ttSimulacaoDevolucao.tipoDocumentoCliente  ).  
            jsonErrors:ADD("numeroDocumentoCliente" , ttSimulacaoDevolucao.numeroDocumentoCliente). 
            jsonErrors:ADD("numeroSequencia"        , ttSimulacaoDevolucao.numeroSequencia       ). 
            jsonErrors:ADD("cnpjEstabelecimento"    , ttSimulacaoDevolucao.cnpjEstabelecimento   ). 
            jsonErrors:ADD("tipoNFe"                , ttSimulacaoDevolucao.tipoNFe               ). 
            jsonErrors:ADD("email"                  , ttSimulacaoDevolucao.email                 ). 
            jsonErrors:ADD("observacoes"            , ttSimulacaoDevolucao.observacoes           ). 
            jsonErrors:ADD("cnpjTransportadora"     , ttSimulacaoDevolucao.cnpjTransportadora    ). 
            jsonErrors:ADD("freteCIF"               , ttSimulacaoDevolucao.freteCIF              ).
            jsonErrors:ADD("dataSimulacao"          , ttSimulacaoDevolucao.dataSimulacao         ).

            FOR EACH ttItem:
                  jsonErrors:ADD("codigoItem"           , 'DELETE' ).   
                  jsonErrors:ADD("quantidade"            , ttItem.quantidade ).   
              END.
    
            jsonArrayErrors:ADD(jsonErrors).
      END.*/

      jsonObjectOutput:ADD("Errors",jsonArrayErrors).
   END. 
        
END PROCEDURE.


PROCEDURE pi-criar-simulacao:
    DEFINE VARIABLE prox-nr-sequencia AS INTEGER     NO-UNDO.
    DEFINE BUFFER b-int-simula-dev-it FOR int-simula-dev-it.

    FIND FIRST ttSimulacaoDevolucao.
    
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cgc = ttSimulacaoDevolucao.numeroDocumentoCliente NO-ERROR.

    IF NOT AVAIL emitente THEN DO:
        RUN incluiMsgErro IN THIS-PROCEDURE (17006, 'Cliente n∆o cadastrado', 'Cliente n∆o cadastrado: ' + STRING(ttSimulacaoDevolucao.numeroDocumentoCliente), "error").
        RETURN "NOK".
    END.

    FIND FIRST transporte NO-LOCK
         WHERE transporte.cgc = ttSimulacaoDevolucao.cnpjTransportadora NO-ERROR.

    IF NOT AVAIL transporte THEN DO:
        RUN incluiMsgErro IN THIS-PROCEDURE (17006, 'Transportadora n∆o cadastrada', 'Transportadora n∆o cadastrada: ' + STRING(ttSimulacaoDevolucao.cnpjTransportadora), "error").
        RETURN "NOK".
    END.

    IF ttSimulacaoDevolucao.cnpjEstabelecimento <> "" THEN DO:
       FIND FIRST estabelec NO-LOCK
            WHERE estabelec.cgc = ttSimulacaoDevolucao.cnpjEstabelecimento NO-ERROR.
    
       IF NOT AVAIL estabelec THEN DO:
           RUN incluiMsgErro IN THIS-PROCEDURE (17006, 'Estabelecimento n∆o cadastrado', 'Estabelecimento n∆o cadastrado: ' + STRING(ttSimulacaoDevolucao.cnpjEstabelecimento), "error").
           RETURN "NOK".
       END.
    END.

    FIND LAST int-simula-dev NO-LOCK
        WHERE int-simula-dev.cod-emitente = emitente.cod-emitente
          AND int-simula-dev.dt-simula    = ttSimulacaoDevolucao.DataSimulacao NO-ERROR.
    
    IF AVAIL int-simula-dev THEN
        ASSIGN prox-nr-sequencia = int-simula-dev.nr-sequencia + 1.
    ELSE 
        ASSIGN prox-nr-sequencia = 1.

    CREATE int-simula-dev.
    ASSIGN int-simula-dev.cod-emitente = emitente.cod-emitente
           int-simula-dev.dt-simula    = ttSimulacaoDevolucao.DataSimulacao   
           int-simula-dev.nr-sequencia = prox-nr-sequencia     
           int-simula-dev.cod-estabel  = IF ttSimulacaoDevolucao.cnpjEstabelecimento <> "" THEN estabelec.cod-estabel ELSE ""
           int-simula-dev.email        = ttSimulacaoDevolucao.Email           
           int-simula-dev.narrativa    = ttSimulacaoDevolucao.observacoes
           int-simula-dev.nome-transp  = transporte.nome-abrev
           int-simula-dev.frete-cif    = ttSimulacaoDevolucao.freteCIF.

    IF ttSimulacaoDevolucao.TipoNfe = "1" THEN
        ASSIGN int-simula-dev.id-tipo-nota = 1.
    ELSE IF ttSimulacaoDevolucao.TipoNfe = "2" THEN
        ASSIGN int-simula-dev.id-tipo-nota = 2.
    ELSE /*Ambos*/
        ASSIGN int-simula-dev.id-tipo-nota = 3.

    FOR EACH ttItem:
        RUN esp/ftp/esftp210e.p (INPUT ROWID(int-simula-dev),
                                 INPUT ttItem.CodigoItem,
                                 INPUT ttItem.Quantidade,
                                 OUTPUT TABLE tt-int-simula-dev-it,
                                 OUTPUT TABLE tt-erro).

        IF CAN-FIND (FIRST tt-erro) THEN DO:
            FOR EACH tt-erro:
                RUN incluiMsgErro IN THIS-PROCEDURE (17006, tt-erro.mensagem, tt-erro.mensagem, "error").
            END.
            RETURN "NOK".
        END.

        FOR EACH tt-int-simula-dev-it:
            FIND FIRST b-int-simula-dev-it EXCLUSIVE-LOCK
                 WHERE b-int-simula-dev-it.nr-nota-origem     = tt-int-simula-dev-it.nr-nota-origem    
                   AND b-int-simula-dev-it.cod-estabel-origem = tt-int-simula-dev-it.cod-estabel-origem
                   AND b-int-simula-dev-it.serie-origem       = tt-int-simula-dev-it.serie-origem
                   AND b-int-simula-dev-it.cod-emitente       = tt-int-simula-dev-it.cod-emitente
                   AND b-int-simula-dev-it.dt-simula          = tt-int-simula-dev-it.dt-simula
                   AND b-int-simula-dev-it.nr-sequencia       = tt-int-simula-dev-it.nr-sequencia
                   AND b-int-simula-dev-it.it-codigo          = tt-int-simula-dev-it.it-codigo
                   AND b-int-simula-dev-it.vl-unitario        = tt-int-simula-dev-it.vl-unitario 
            NO-ERROR.                                        
    
            IF AVAIL b-int-simula-dev-it THEN DO:
                ASSIGN b-int-simula-dev-it.qt-devolvida = b-int-simula-dev-it.qt-devolvida + tt-int-simula-dev-it.qt-devolvida
                       b-int-simula-dev-it.observacao   = b-int-simula-dev-it.observacao   + " " + tt-int-simula-dev-it.observacao
                       b-int-simula-dev-it.vl-cofins    = b-int-simula-dev-it.vl-cofins    + tt-int-simula-dev-it.vl-cofins   
                       b-int-simula-dev-it.vl-icms      = b-int-simula-dev-it.vl-icms      + tt-int-simula-dev-it.vl-icms     
                       b-int-simula-dev-it.vl-icmsdifal = b-int-simula-dev-it.vl-icmsdifal + tt-int-simula-dev-it.vl-icmsdifal
                       b-int-simula-dev-it.vl-icmsst    = b-int-simula-dev-it.vl-icmsst    + tt-int-simula-dev-it.vl-icmsst   
                       b-int-simula-dev-it.vl-ipi       = b-int-simula-dev-it.vl-ipi       + tt-int-simula-dev-it.vl-ipi      
                       b-int-simula-dev-it.vl-pis       = b-int-simula-dev-it.vl-pis       + tt-int-simula-dev-it.vl-pis      
                       b-int-simula-dev-it.vl-tot-it    = b-int-simula-dev-it.vl-tot-it    + tt-int-simula-dev-it.vl-tot-it
                      
                       b-int-simula-dev-it.vl-bsubs-it  = b-int-simula-dev-it.vl-bsubs-it  + tt-int-simula-dev-it.vl-bsubs-it.
            END.
            ELSE DO:
                FIND FIRST int-estrutura NO-LOCK 
                     WHERE int-estrutura.it-codigo = tt-int-simula-dev-it.it-codigo
                       AND int-estrutura.es-codigo = tt-int-simula-dev-it.it-codigo NO-ERROR.
    
                CREATE int-simula-dev-it.
                BUFFER-COPY tt-int-simula-dev-it TO int-simula-dev-it.
    
                IF AVAIL int-estrutura THEN
                    ASSIGN int-simula-dev-it.garantia = int-estrutura.garantia.
            END.
        END.

        CREATE ttSimulacaoDevolucaoR.
        ASSIGN ttSimulacaoDevolucaoR.cnpj            = emitente.cgc               
               ttSimulacaoDevolucaoR.dataSimulacao   = int-simula-dev.dt-simula   
               ttSimulacaoDevolucaoR.numeroSequencia = int-simula-dev.nr-sequencia
               ttSimulacaoDevolucaoR.estabelecimento = int-simula-dev.cod-estabe. 

        FOR EACH int-simula-dev-it OF int-simula-dev NO-LOCK:

            FIND FIRST it-nota-fisc NO-LOCK
                 WHERE it-nota-fisc.nr-nota-fis  = int-simula-dev-it.nr-nota-origem 
                   AND it-nota-fisc.cod-estabel  = int-simula-dev-it.cod-estabel-origem 
                   AND it-nota-fisc.serie        = int-simula-dev-it.serie-origem 
                   AND it-nota-fisc.it-codigo    = int-simula-dev-it.it-codigo NO-ERROR.

            CREATE ttItemR.
            ASSIGN ttItemR.codigoItem       = int-simula-dev-it.it-codigo         
                   ttItemR.quantidade       = int-simula-dev-it.qt-devolvida      
                   ttItemR.sequencia        = int-simula-dev-it.nr-seq-it         
                   ttItemR.valorUnitario    = int-simula-dev-it.vl-unitario       
                   ttItemR.valorIPI         = int-simula-dev-it.vl-ipi            
                   ttItemR.percentualIPI    = it-nota-fisc.aliquota-ip            
                   ttItemR.valorICMS        = int-simula-dev-it.vl-icms           
                   ttItemR.percentualICMS   = it-nota-fisc.aliquota-icm           
                   ttItemR.valorICMSST      = int-simula-dev-it.vl-icmsst         
                   ttItemR.valorICMSDifal   = int-simula-dev-it.vl-icmsdifal      
                   ttItemR.valorPIS         = int-simula-dev-it.vl-pis            
                   ttItemR.valorCofins      = int-simula-dev-it.vl-cofins         
                   ttItemR.valorTotalItem   = int-simula-dev-it.vl-tot-it         
                   ttItemR.observacoes      = int-simula-dev-it.observacao        
                   ttItemR.numeroNotaOrigem = int-simula-dev-it.nr-nota-origem    
                   ttItemR.serieOrigem      = int-simula-dev-it.serie-origem      
                   ttItemR.codigoEstabelecimentoOrigem = int-simula-dev-it.cod-estabel-origem
                   ttItemR.garantia         = int-simula-dev-it.garantia. 
                   ttItemR.baseICMSST       = int-simula-dev-it.vl-bsubs-it * ttItemR.quantidade.
        END.
    END.
    
    RETURN "OK".

END PROCEDURE.



PROCEDURE pi-alterar-simulacao:

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cgc = ttSimulacaoDevolucao.numeroDocumentoCliente NO-ERROR.

    IF NOT AVAIL emitente THEN DO:
        RUN incluiMsgErro IN THIS-PROCEDURE (17006, 'Cliente n∆o cadastrado', 'Cliente n∆o cadastrado: ' + STRING(ttSimulacaoDevolucao.numeroDocumentoCliente), "error").
        RETURN "NOK".
    END.

    FIND FIRST int-simula-dev NO-LOCK
         WHERE int-simula-dev.cod-emitente = emitente.cod-emitente
           AND int-simula-dev.dt-simula    = ttSimulacaoDevolucao.DataSimulacao
           AND int-simula-dev.nr-sequencia = ttSimulacaoDevolucao.numeroSequencia NO-ERROR.

    IF NOT AVAIL int-simula-dev THEN DO:
        RUN incluiMsgErro IN THIS-PROCEDURE (17006, 'Simulaá∆o n∆o cadastrada', 'N∆o encontrado simulaá∆o com os dados informados', "error").
        RETURN "NOK".
    END.

    FIND CURRENT int-simula-dev EXCLUSIVE-LOCK.

    ASSIGN int-simula-dev.email     = ttSimulacaoDevolucao.Email
           int-simula-dev.narrativa = ttSimulacaoDevolucao.observacoes.

   /* IF ttSimulacaoDevolucao.TipoNfe = "Gerar duplicata" THEN
        ASSIGN int-simula-dev.id-tipo-nota = 1.
    ELSE IF ttSimulacaoDevolucao.TipoNfe = "Nío gera duplicata" THEN
        ASSIGN int-simula-dev.id-tipo-nota = 2.
    ELSE /*Ambos*/
        ASSIGN int-simula-dev.id-tipo-nota = 3.  */

    IF ttSimulacaoDevolucao.TipoNfe = "1" THEN
        ASSIGN int-simula-dev.id-tipo-nota = 1.
    ELSE IF ttSimulacaoDevolucao.TipoNfe = "2" THEN
        ASSIGN int-simula-dev.id-tipo-nota = 2.
    ELSE /*Ambos*/
        ASSIGN int-simula-dev.id-tipo-nota = 3. 

    FIND CURRENT int-simula-dev NO-LOCK.

    CREATE ttSimulacaoDevolucaoR.
    ASSIGN ttSimulacaoDevolucaoR.cnpj            = emitente.cgc               
           ttSimulacaoDevolucaoR.dataSimulacao   = int-simula-dev.dt-simula   
           ttSimulacaoDevolucaoR.numeroSequencia = int-simula-dev.nr-sequencia
           ttSimulacaoDevolucaoR.estabelecimento = int-simula-dev.cod-estabe. 

    FOR EACH int-simula-dev-it OF int-simula-dev NO-LOCK:

        FIND FIRST it-nota-fisc NO-LOCK
             WHERE it-nota-fisc.nr-nota-fis  = int-simula-dev-it.nr-nota-origem 
               AND it-nota-fisc.cod-estabel  = int-simula-dev-it.cod-estabel-origem 
               AND it-nota-fisc.serie        = int-simula-dev-it.serie-origem 
               AND it-nota-fisc.it-codigo    = int-simula-dev-it.it-codigo NO-ERROR.

        CREATE ttItemR.
        ASSIGN ttItemR.codigoItem       = int-simula-dev-it.it-codigo         
               ttItemR.quantidade       = int-simula-dev-it.qt-devolvida      
               ttItemR.sequencia        = int-simula-dev-it.nr-seq-it         
               ttItemR.valorUnitario    = int-simula-dev-it.vl-unitario       
               ttItemR.valorIPI         = int-simula-dev-it.vl-ipi            
               ttItemR.percentualIPI    = it-nota-fisc.aliquota-ip            
               ttItemR.valorICMS        = int-simula-dev-it.vl-icms           
               ttItemR.percentualICMS   = it-nota-fisc.aliquota-icm           
               ttItemR.valorICMSST      = int-simula-dev-it.vl-icmsst         
               ttItemR.valorICMSDifal   = int-simula-dev-it.vl-icmsdifal      
               ttItemR.valorPIS         = int-simula-dev-it.vl-pis            
               ttItemR.valorCofins      = int-simula-dev-it.vl-cofins         
               ttItemR.valorTotalItem   = int-simula-dev-it.vl-tot-it         
               ttItemR.observacoes      = int-simula-dev-it.observacao        
               ttItemR.numeroNotaOrigem = int-simula-dev-it.nr-nota-origem    
               ttItemR.serieOrigem      = int-simula-dev-it.serie-origem      
               ttItemR.codigoEstabelecimentoOrigem = int-simula-dev-it.cod-estabel-origem
               ttItemR.garantia         = int-simula-dev-it.garantia
               ttItemR.baseICMSST       = int-simula-dev-it.vl-bsubs-it * ttItemR.quantidade.
    END.

    RETURN "OK".

END PROCEDURE.


PROCEDURE pi-excluir-simulacao:

    FIND FIRST ttSimulacaoDevolucao NO-ERROR.

    IF NOT AVAIL ttSimulacaoDevolucao THEN DO:
        RUN incluiMsgErro IN THIS-PROCEDURE (17006, 'Nao encontrado registro', 'Nao encontrado registro', "error").
        RETURN "NOK".
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cgc = ttSimulacaoDevolucao.numeroDocumentoCliente NO-ERROR.

    IF NOT AVAIL emitente THEN DO:
        RUN incluiMsgErro IN THIS-PROCEDURE (17006, 'Cliente n∆o cadastrado ', 'Cliente n∆o cadastrado: ' + STRING(ttSimulacaoDevolucao.numeroDocumentoCliente), "error").
        RETURN "NOK".
    END.
    
    FIND FIRST int-simula-dev NO-LOCK
         WHERE int-simula-dev.cod-emitente = emitente.cod-emitente
           AND int-simula-dev.dt-simula    = ttSimulacaoDevolucao.dataSimulacao
           AND int-simula-dev.nr-sequencia = ttSimulacaoDevolucao.numeroSequencia NO-ERROR.

    IF NOT AVAIL int-simula-dev THEN DO:
        RUN incluiMsgErro IN THIS-PROCEDURE (17006, "Simulaá∆o n∆o cadastrada " , "N∆o encontrado simulaá∆o com os dados informados: Cliente: " + STRING(emitente.cod-emitente) + " Data: " + STRING(ttExcluirSimulacao.dataSimulacao,"99/99/9999") + " Sequencia: " + STRING(ttExcluirSimulacao.numeroSequencia), "error").
        RETURN "NOK".
    END.
    
    FOR EACH int-simula-dev-it OF int-simula-dev EXCLUSIVE-LOCK:
        DELETE int-simula-dev-it.
    END.

    FIND CURRENT int-simula-dev EXCLUSIVE-LOCK.

    DELETE int-simula-dev.

    RETURN "OK".

END PROCEDURE.



PROCEDURE incluiMsgErro:

    DEF INPUT PARAM p-ErrorNumber       AS INTEGER   NO-UNDO.
    DEF INPUT PARAM p-ErrorDescription  AS CHARACTER NO-UNDO.
    DEF INPUT PARAM p-ErrorParameters   AS CHARACTER NO-UNDO.
    DEF INPUT PARAM p-ErrorType         AS CHARACTER NO-UNDO.

    CREATE rowErrors.
    ASSIGN rowErrors.ErrorNumber      = p-ErrorNumber      
           rowErrors.ErrorDescription = p-ErrorDescription 
           rowErrors.ErrorParameters  = p-ErrorParameters  
           rowErrors.ErrorType        = p-ErrorType.        

END PROCEDURE.
