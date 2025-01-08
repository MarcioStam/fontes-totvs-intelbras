/****************************************************************************************************
** API Rest JSON - Integracao Item Klassmatt
**
** 07/05/2021
**
** Autor:Isac Abrahao  
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}         
/* {fwk/utils/fndApiServices.i}  */
{utp/ut-api-action.i piIntegraItem POST /~*}
{utp/ut-api-notfound.i} 

{esapi/esapi025.i}
{esp/es0018.i}
/*{esapi/esapi025a.i}*/

DEFINE VARIABLE c-arquivo-log1 AS CHARACTER   NO-UNDO.
/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/
PROCEDURE piIntegraItem:

   DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.
   DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.    

   DEFINE VARIABLE jsonObjectOutput        AS JsonObject   NO-UNDO.
   DEFINE VARIABLE jsonObjectPayload       AS jsonObject   NO-UNDO.
   DEFINE VARIABLE objItem                 AS JsonObject   NO-UNDO.
   DEFINE VARIABLE objFabric               AS JsonObject   NO-UNDO.
   
   DEFINE VARIABLE arrayItem               AS jsonArray    NO-UNDO.
   DEFINE VARIABLE jsonArrayPayload        AS jsonArray    NO-UNDO.
   DEFINE VARIABLE jsonArrayProjSuframa    AS jsonArray    NO-UNDO.

   DEFINE VARIABLE iCont         AS INTEGER NO-UNDO.
   DEFINE VARIABLE iCont2        AS INTEGER NO-UNDO.
   DEFINE VARIABLE l-ok          AS LOGICAL NO-UNDO.
   DEFINE VARIABLE l-log         AS LOGICAL NO-UNDO.
   DEFINE VARIABLE l-producao    AS LOGICAL NO-UNDO.

   DEFINE VARIABLE i-ini-posicao AS INTEGER NO-UNDO.
   DEFINE VARIABLE i-fim-posicao AS INTEGER NO-UNDO.
   
   EMPTY TEMP-TABLE tt-prog-ponto.

   RUN esp/es0018p.p (INPUT "ambiente":U,
                      INPUT 1,
                      INPUT 0,
                      INPUT "":U,
                      OUTPUT TABLE tt-prog-ponto).

   FIND FIRST tt-prog-ponto NO-ERROR.

   IF  AVAIL tt-prog-ponto
   AND tt-prog-ponto.conteudo = "PRODUCAO":U THEN
       ASSIGN l-producao = YES.
   ELSE
       ASSIGN l-producao = NO.

   /* arquivo de log de execucao do programa */
   EMPTY TEMP-TABLE tt-prog-ponto.

   RUN esp/es0018p.p (INPUT "log-wso2":U,
                     INPUT 2,
                     INPUT 0,
                     INPUT "":U,
                     OUTPUT TABLE tt-prog-ponto).

   FIND FIRST tt-prog-ponto 
      WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'Item_Klasmatt' NO-ERROR.

   IF  AVAIL tt-prog-ponto
   AND ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
       ASSIGN l-log = YES.
   ELSE
       ASSIGN l-log = NO.

   IF  l-log = YES THEN DO:
       IF  OPSYS = 'UNIX' THEN    
           ASSIGN c-arquivo-log1 = "/usr/wrk/totvs/UNIX_Item_Klasmatt_".
       ELSE
           ASSIGN c-arquivo-log1 = "\\erpapp\spool\totvs\WIN_Item_Klasmatt_".

       IF  l-producao THEN
           ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
       ELSE 
           ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.
   END.
   /* arquivo de log de execucao do programa */

   RUN pi-gerar-dados-extrato ( CHR(13) + CHR(13) + " Inicio"  + " - " + STRING(DATETIME(TODAY, MTIME))).

   IF jsonInput:has("payload") THEN DO:
       jsonObjectPayload    = jsonInput:GetJsonObject("payload").
       jsonArrayPayload     = jsonObjectPayload:getJSONArray("FabricaItem").
       jsonArrayProjSuframa = jsonObjectPayload:getJSONArray("ProjetoSuframa").

       FOR EACH tt-item-json:    DELETE tt-item-json.    END.
       FOR EACH tt-item-fabric:  DELETE tt-item-fabric.  END.
       FOR EACH tt-proj-suframa: DELETE tt-proj-suframa. END.

       CREATE tt-item-json.
       ASSIGN tt-item-json.codItem            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "codItem")     
              tt-item-json.descItem           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "descItem")                
              tt-item-json.un                 = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "un")          
              tt-item-json.codEstabel         = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "codEstabel")              
              tt-item-json.fmCodigo           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "familiaMat")                
              tt-item-json.fmCodigoOri        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "familiaMat")                
              tt-item-json.fmTrib             = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "familiaTrib")    
              tt-item-json.classFiscal        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "classFiscal")             
              tt-item-json.narrativa          = STRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "narrativa"))     
              tt-item-json.responsavel        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "logUsuario")                         
              tt-item-json.pesoLiquido        = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "pesoLiquido"))    
              tt-item-json.pesoBruto          = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "pesoBruto"))      
              tt-item-json.comprim            = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "comprim"))             
              tt-item-json.largura            = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "largura"))            
              tt-item-json.altura             = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "altura"))             
              //tt-item-json.folhaEspecif    = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "folhaEspecif")                 
              tt-item-json.tipoControle      = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "tipoControle"))            
              tt-item-json.servMat            = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "servMat"))                 
              tt-item-json.grEstoque          = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "grEstoque"))       
              tt-item-json.contrQualid        = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "contrQualid"))         //verificar - nao esta trazendo    
              tt-item-json.fraciona           = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "fraciona"))            //verificar - nao esta trazendo                          
              tt-item-json.criticidade        = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "criticidade"))    
              tt-item-json.famComerc          = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "FamComerc")           
              tt-item-json.percNQA            = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "percNQA"))        
              tt-item-json.cdPlanejador       = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "cdPlanejador")        
              tt-item-json.destaqNCM          = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "destaqNCM"))        
              tt-item-json.percGATT           = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "percGATT"))           
              tt-item-json.exTarifario        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "exTarifario")        
              tt-item-json.nve                = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "nve")                
              tt-item-json.seqSuframa         = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "seqSuframa")         
              tt-item-json.tipoItem           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "tipoItem")          
              tt-item-json.versao             = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "versao"))             
              //tt-item-json.dataVersao         = DATE(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "dataVersao"))        
              tt-item-json.codAcond           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "codAcond")          
              tt-item-json.desAcond           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "desAcond")           
              tt-item-json.codAmost           = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "codAmost")) 
              tt-item-json.desAmost           = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "desAmost")  
              tt-item-json.infAdic            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "infAdic")           
              tt-item-json.unNeg              = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "unNeg"))        
              tt-item-json.aliquotaII         = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "aliquotaII")) 
              tt-item-json.aliquotaIPI        = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "aliquotaIPI")) 
              tt-item-json.aliquotaPIS        = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "aliquotaPIS")) 
              tt-item-json.aliquotaCOFINS     = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "aliquotaCOFINS")) 
              tt-item-json.necessitaLI        = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "necessitaLI")) 
              tt-item-json.antidumping        = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "antidumping")) 
              tt-item-json.obsAntidumping     = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "obsAntidumping")  
              tt-item-json.cest               = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "cest"))         
              tt-item-json.origem             = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "origem"))   
              tt-item-json.leiInformatica     = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "leiInformatica"))  
              tt-item-json.desc-comp-item     = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "descCompItem")  
              tt-item-json.desc-venda         = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "descVenda")     
              tt-item-json.desc-ingles        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "descIngles")    
              tt-item-json.usuario            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "logUsuario")
              tt-item-json.lei-116            = STRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "lei116Grup"))   
              tt-item-json.lei-116-sub        = STRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "lei116SubGrup"))   
              tt-item-json.tipo-ex            = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "tipoEX")
              tt-item-json.ato-legal-ex       = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "atoLegalEX")
              tt-item-json.ato-num-ex         = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "atoNumEX"))
              tt-item-json.orgao-emis-ex      = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "orgaoEmisEX")
              tt-item-json.ano-ex             = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "anoEX"))    
              tt-item-json.aliquotaPIS-imp    = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "aliquotaPISimp"))
              tt-item-json.aliquotaCOFINS-imp = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "aliquotaCOFINSimp")) 
              tt-item-json.narrativa-manaus   = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "narrativaManaus")
              tt-item-json.faturavel          = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "faturavel"))
              tt-item-json.ped-energia        = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "pedEnergia")
              tt-item-json.FabricaItem        = STRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "FabricaItem"))
              tt-item-json.ProjetoSuframa     = STRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "ProjetoSuframa"))
              tt-item-json.ItemOrigin         = STRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "ItemOrigin"))

              tt-item-json.resum-ingles       = STRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "desResumIngles"))
              tt-item-json.meses-valid        = STRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "mesesValid"))
              tt-item-json.qtde-prod-emb      = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "qtdeProdutosEmbColetiva"))
              tt-item-json.compr-emb          = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "comprEmbColetiva"))
              tt-item-json.larg-emb           = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "largEmbColetiva"))
              tt-item-json.altura-emb         = DEC(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "altEmbColetiva"))
              tt-item-json.ex-ipi             = STRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "exIPI"))
              tt-item-json.pais-ori           = STRING(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "paisOrigem")).
              
       ASSIGN iCont  = 0.

       ASSIGN i-ini-posicao = 0
              i-fim-posicao = 0.

       IF tt-item-json.FabricaItem <> "" THEN DO:
          IF JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(1),"itFabric") <> " " THEN DO:
              REPEAT:  
                 ASSIGN iCont = iCont + 1.
    
                 IF LOGICAL(JsonAPIUtils:getPropertyJsonArray(jsonArrayPayload,iCont)) = NO THEN LEAVE.
    
                 IF JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(iCont),"codFabric") <> '' THEN DO:
                      
                    /*
                    IF INDEX(tt-item-json.FabricaItem,'itFabric')   <> 0 AND 
                       INDEX(tt-item-json.FabricaItem,'referencia') <> 0 THEN
                       ASSIGN i-ini-posicao = INDEX(tt-item-json.FabricaItem,'itFabric')   + 10
                              i-fim-posicao = INDEX(tt-item-json.FabricaItem,'referencia') - 2.

                    RUN pi-gerar-dados-extrato('TESTANDO: ' + JsonAPIUtils:getPropertyJsonObject(jsonArrayProjSuframa:getJSONObject(iCont) ).

                    RUN pi-gerar-dados-extrato ("AQUI tt-item-json.FabricaItem:  " + tt-item-json.FabricaItem).*/

                    DO iCont2 = 1 TO NUM-ENTRIES(JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(iCont),"codFabric"),';'):

                       CREATE tt-item-fabric.
                       ASSIGN tt-item-fabric.it-fabric  = JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(iCont),"itFabric").        //OK
                              tt-item-fabric.cod-fabric = INT(JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(iCont),"codFabric")).  //OK
                              tt-item-fabric.referencia = JsonAPIUtils:getPropertyJsonObject(jsonArrayPayload:getJSONObject(iCont),"referencia").      // Nao esta trazendo 

                       RUN pi-gerar-dados-extrato ("codFabric - " + string(tt-item-fabric.cod-fabric)).
                       RUN pi-gerar-dados-extrato ("itFabric -  " + tt-item-fabric.it-fabric).

                    END.
                    
                    /*
                    RUN pi-gerar-dados-extrato ("AQUI tt-item-json.FabricaItem:  "   +  STRING(i-ini-posicao) + ' - ' + STRING(i-fim-posicao - i-ini-posicao)). 

                    IF i-ini-posicao <> 0 AND i-fim-posicao <> 0 THEN
                       ASSIGN tt-item-fabric.it-fabric = REPLACE(SUBSTRING(tt-item-json.FabricaItem,i-ini-posicao,i-fim-posicao - i-ini-posicao),',','')
                              tt-item-fabric.it-fabric = REPLACE(tt-item-fabric.it-fabric,'"','').

                    RUN pi-gerar-dados-extrato ("AQUI tt-item-json.FabricaItem:  "   +  tt-item-fabric.it-fabric ). */
                    
                 END.
              END.
          END.
       END.

       ASSIGN iCont  = 0
              iCont2 = 0.
       
       IF tt-item-json.ProjetoSuframa <> "" THEN DO: 
          IF JsonAPIUtils:getPropertyJsonObject(jsonArrayProjSuframa:getJSONObject(1),"projSuframa") <> " " THEN DO:
             REPEAT:  
                ASSIGN iCont = iCont + 1.
            
                IF LOGICAL(JsonAPIUtils:getPropertyJsonArray(jsonArrayProjSuframa,iCont)) = NO THEN LEAVE.

                IF JsonAPIUtils:getPropertyJsonObject(jsonArrayProjSuframa:getJSONObject(iCont),"projSuframa") <> '' AND 
                   JsonAPIUtils:getPropertyJsonObject(jsonArrayProjSuframa:getJSONObject(iCont),"seqSuframa")  <> '' THEN DO:

                   DO iCont2 = 1 TO NUM-ENTRIES(JsonAPIUtils:getPropertyJsonObject(jsonArrayProjSuframa:getJSONObject(iCont),"projSuframa"),';'):
                      CREATE tt-proj-suframa.
                      ASSIGN tt-proj-suframa.nr-projeto  = INT(ENTRY(iCont2,JsonAPIUtils:getPropertyJsonObject(jsonArrayProjSuframa:getJSONObject(iCont),"projSuframa"),';')).
                             tt-proj-suframa.seq-suframa = INT(JsonAPIUtils:getPropertyJsonObject(jsonArrayProjSuframa:getJSONObject(iCont),"seqSuframa")). 
                             tt-proj-suframa.controlado  = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonArrayProjSuframa:getJSONObject(iCont),"controladoSuframa")). 
                   END.
                END.
             END.
          END.
       END.
   END.

   RUN pi-gerar-dados-extrato ("codItem           :  "   +  string(   tt-item-json.codItem          )).     
   RUN pi-gerar-dados-extrato ("descItem          :  "   +  string(   tt-item-json.descItem         )).
   RUN pi-gerar-dados-extrato ("un                :  "   +  string(   tt-item-json.un               )).
   RUN pi-gerar-dados-extrato ("codEstabel        :  "   +  string(   tt-item-json.codEstabel       )).
   RUN pi-gerar-dados-extrato ("fmCodigo          :  "   +  string(   tt-item-json.fmCodigo         )).
   RUN pi-gerar-dados-extrato ("fmTrib            :  "   +  string(   tt-item-json.fmTrib           )).
   RUN pi-gerar-dados-extrato ("classFiscal       :  "   +  string(   tt-item-json.classFiscal      )).
   RUN pi-gerar-dados-extrato ("narrativa         :  "   +  string(   tt-item-json.narrativa        )).
   RUN pi-gerar-dados-extrato ("responsavel       :  "   +  string(   tt-item-json.responsavel      )).
   RUN pi-gerar-dados-extrato ("pesoLiquido       :  "   +  string(   tt-item-json.pesoLiquido      )).
   RUN pi-gerar-dados-extrato ("pesoBruto         :  "   +  string(   tt-item-json.pesoBruto        )).
   RUN pi-gerar-dados-extrato ("comprim           :  "   +  string(   tt-item-json.comprim          )).
   RUN pi-gerar-dados-extrato ("largura           :  "   +  string(   tt-item-json.largura          )).
   RUN pi-gerar-dados-extrato ("altura            :  "   +  string(   tt-item-json.altura           )).
   RUN pi-gerar-dados-extrato ("folhaEspecif      :  "   +  string(   tt-item-json.folhaEspecif     )).
   RUN pi-gerar-dados-extrato ("tipoControle      :  "   +  string(   tt-item-json.tipoControle     )).
   RUN pi-gerar-dados-extrato ("servMat           :  "   +  string(   tt-item-json.servMat          )).
   RUN pi-gerar-dados-extrato ("grEstoque         :  "   +  string(   tt-item-json.grEstoque        )).
   RUN pi-gerar-dados-extrato ("contrQualid       :  "   +  string(   tt-item-json.contrQualid      )).
   RUN pi-gerar-dados-extrato ("fraciona          :  "   +  string(   tt-item-json.fraciona         )).
   RUN pi-gerar-dados-extrato ("criticidade       :  "   +  string(   tt-item-json.criticidade      )).
   RUN pi-gerar-dados-extrato ("FamComerc         :  "   +  string(   tt-item-json.famComerc        )).
   RUN pi-gerar-dados-extrato ("percNQA           :  "   +  string(   tt-item-json.percNQA          )).
   RUN pi-gerar-dados-extrato ("cdPlanejador      :  "   +  string(   tt-item-json.cdPlanejador     )).
   RUN pi-gerar-dados-extrato ("destaqNCM         :  "   +  string(   tt-item-json.destaqNCM        )).
   RUN pi-gerar-dados-extrato ("percGATT          :  "   +  string(   tt-item-json.percGATT         )).
   RUN pi-gerar-dados-extrato ("exTarifario       :  "   +  string(   tt-item-json.exTarifario      )).
   RUN pi-gerar-dados-extrato ("nve               :  "   +  string(   tt-item-json.nve              )).
   RUN pi-gerar-dados-extrato ("seqSuframa        :  "   +  string(   tt-item-json.seqSuframa       )).
   RUN pi-gerar-dados-extrato ("tipoItem          :  "   +  string(   tt-item-json.tipoItem         )).
   RUN pi-gerar-dados-extrato ("versao            :  "   +  string(   tt-item-json.versao           )).
   RUN pi-gerar-dados-extrato ("dataVersao        :  "   +  string(   tt-item-json.dataVersao       )).
   RUN pi-gerar-dados-extrato ("codAcond          :  "   +  string(   tt-item-json.codAcond         )).
   RUN pi-gerar-dados-extrato ("desAcond          :  "   +  string(   tt-item-json.desAcond         )).
   RUN pi-gerar-dados-extrato ("codAmost          :  "   +  string(   tt-item-json.codAmost         )).
   RUN pi-gerar-dados-extrato ("desAmost          :  "   +  string(   tt-item-json.desAmost         )).
   RUN pi-gerar-dados-extrato ("infAdic           :  "   +  string(   tt-item-json.infAdic          )).
   RUN pi-gerar-dados-extrato ("unNeg             :  "   +  string(   tt-item-json.unNeg            )).
   RUN pi-gerar-dados-extrato ("aliquotaII        :  "   +  string(   tt-item-json.aliquotaII       )).
   RUN pi-gerar-dados-extrato ("aliquotaIPI       :  "   +  string(   tt-item-json.aliquotaIPI      )).
   RUN pi-gerar-dados-extrato ("aliquotaPIS       :  "   +  string(   tt-item-json.aliquotaPIS      )).
   RUN pi-gerar-dados-extrato ("aliquotaCOFINS    :  "   +  string(   tt-item-json.aliquotaCOFINS   )).
   RUN pi-gerar-dados-extrato ("necessitaLI       :  "   +  string(   tt-item-json.necessitaLI      )).
   RUN pi-gerar-dados-extrato ("antidumping       :  "   +  string(   tt-item-json.antidumping      )).
   RUN pi-gerar-dados-extrato ("obsAntidumping    :  "   +  string(   tt-item-json.obsAntidumping   )).
   RUN pi-gerar-dados-extrato ("cest              :  "   +  string(   tt-item-json.cest             )).
   RUN pi-gerar-dados-extrato ("origem            :  "   +  string(   tt-item-json.origem           )).
   RUN pi-gerar-dados-extrato ("leiInformatica    :  "   +  string(   tt-item-json.leiInformatica   )).
   RUN pi-gerar-dados-extrato ("desc-comp-item    :  "   +  string(   tt-item-json.desc-comp-item   )).
   RUN pi-gerar-dados-extrato ("desc-venda        :  "   +  string(   tt-item-json.desc-venda       )).
   RUN pi-gerar-dados-extrato ("desc-ingles       :  "   +  string(   tt-item-json.desc-ingles      )).
   RUN pi-gerar-dados-extrato ("usuario           :  "   +  string(   tt-item-json.usuario          )).
   RUN pi-gerar-dados-extrato ("lei-116           :  "   +  string(   tt-item-json.lei-116          )).
   RUN pi-gerar-dados-extrato ("tipo-ex           :  "   +  string(   tt-item-json.tipo-ex          )).
   RUN pi-gerar-dados-extrato ("ato-legal-ex      :  "   +  string(   tt-item-json.ato-legal-ex     )).
   RUN pi-gerar-dados-extrato ("ato-num-ex        :  "   +  string(   tt-item-json.ato-num-ex       )).
   RUN pi-gerar-dados-extrato ("orgao-emis-ex     :  "   +  string(   tt-item-json.orgao-emis-ex    )).
   RUN pi-gerar-dados-extrato ("ano-ex            :  "   +  string(   tt-item-json.ano-ex           )).
   RUN pi-gerar-dados-extrato ("aliquotaPIS-imp   :  "   +  string(   tt-item-json.aliquotaPIS-imp  )).
   RUN pi-gerar-dados-extrato ("aliquotaCOFINS-imp:  "   +  string(   tt-item-json.aliquotaCOFINS-imp)).
   RUN pi-gerar-dados-extrato ("narrativa-manaus  :  "   +  string(   tt-item-json.narrativa-manaus )).
   RUN pi-gerar-dados-extrato ("faturavel         :  "   +  string(   tt-item-json.faturavel        )).
   RUN pi-gerar-dados-extrato ("ped-energia       :  "   +  string(   tt-item-json.ped-energia      )).
   RUN pi-gerar-dados-extrato ("FabricaItem       :  "   +  string(   tt-item-json.FabricaItem      )).
   RUN pi-gerar-dados-extrato ("ProjetoSuframa    :  "   +  string(   tt-item-json.ProjetoSuframa   )).
   RUN pi-gerar-dados-extrato ("ItemOrigin        :  "   +  string(   tt-item-json.ItemOrigin       )).
   RUN pi-gerar-dados-extrato ("leiInformatica    :  "   +  string(   tt-item-json.leiInformatica   )).
   RUN pi-gerar-dados-extrato ("paisOrigem        :  "   +  string(   tt-item-json.pais-ori         )).
          
   FOR EACH tt-item-fabric:
       RUN pi-gerar-dados-extrato ("it-fabric    : " +   string(tt-item-fabric.it-fabric   ) ).
       RUN pi-gerar-dados-extrato ("cod-fabric   : " +   string(tt-item-fabric.cod-fabric  ) ).
       RUN pi-gerar-dados-extrato ("referencia   : " +   string(tt-item-fabric.referencia  ) ).
   END.
                               
   FOR EACH tt-proj-suframa:
       RUN pi-gerar-dados-extrato (".nr-projeto  : " +   string(tt-proj-suframa.nr-projeto ) ).
       RUN pi-gerar-dados-extrato (".seq-suframa : " +   string(tt-proj-suframa.seq-suframa) ).
       RUN pi-gerar-dados-extrato (".controlado  : " +   string(tt-proj-suframa.controlado ) ).
   END.

   RUN pi-gerar-dados-extrato ('SEARCH("esapi/esapi025.r")'  +   string(SEARCH("esapi/esapi025.r") ) ).

   
   IF SEARCH("esapi/esapi025.r") <> ?
   OR SEARCH("esapi/esapi025.p") <> ? THEN DO:

        RUN pi-gerar-dados-extrato ("antes esapi/esapi025.p"  ).

        
      RUN esapi/esapi025.p (INPUT TABLE tt-item-json,
                            INPUT TABLE tt-item-fabric,
                            INPUT TABLE tt-proj-suframa,
                            OUTPUT TABLE tt-mensagem-2).

      RUN pi-gerar-dados-extrato ("DEPOIS esapi/esapi025.p"  ).
   END.
   
   FIND FIRST tt-proj-suframa NO-ERROR.
   FIND FIRST tt-item-json    NO-ERROR.

   ASSIGN arrayItem = NEW JsonArray().

   ASSIGN l-ok = NO.

   FOR EACH tt-mensagem-2:
       ASSIGN objItem   = NEW JsonObject().

       objItem:ADD("Code", STRING(tt-mensagem-2.tip-msgs)).
       objItem:ADD("Message", tt-mensagem-2.mensagem).
       
       IF tt-mensagem-2.tip-msgs = 200 THEN DO:
          objItem:ADD("codItem", tt-mensagem-2.informacao).
          ASSIGN l-ok = YES.

           RUN pi-gerar-dados-extrato ("Cod.Item :  "   +  string( tt-mensagem-2.informacao  )).
       END.
       ELSE
          objItem:ADD("error", tt-mensagem-2.informacao).

       arrayItem:ADD(objItem).
   END.                       
   
   jsonObjectOutput = NEW jsonObject().
   jsonObjectOutput:ADD("MensagemRetorno",arrayItem).

   RUN pi-gerar-dados-extrato ("fim"  ).

   IF l-ok THEN 
      RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT FALSE, OUTPUT jsonOutput).
   ELSE DO:
      ASSIGN jsonOutput = NEW jsonObject().
      jsonOutput = JsonAPIResponseBuilder:ok(jsonObjectOutput, 400).
   END.

END PROCEDURE.




PROCEDURE pi-gerar-dados-extrato:
    DEF INPUT PARAM p-string AS CHAR NO-UNDO.
            
    IF c-arquivo-log1 <> "" AND c-arquivo-log1 <> ? THEN DO:
       OUTPUT TO VALUE(c-arquivo-log1) APPEND.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
            
            PUT  p-string  FORMAT "x(200)" SKIP.
       OUTPUT CLOSE. 
    
    end.
END PROCEDURE.
