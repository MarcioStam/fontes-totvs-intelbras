{utp/ut-api.i}
{utp/ut-api-utils.i}
{utp/ut-api-action.i pi-consulta-nf get /~*}
{utp/ut-api-notfound.i} 
{esp/es0018.i}

define temp-table tt-erro no-undo
  field codigo     as integer
  field informacao as CHAR
  field mensagem   as character format "x(255)".

/************************************************************************************
* Programa ..: API Rest espIntegration_NotaSAP                                        *
* Data ......: 22/02/2022                                                           *
* Empresa ...: iDBA                                                                 *
* Versao ....: 1.00.00.000                                                          *
* Autor .....: Mauricio C.                                                          *
*************************************************************************************
* VERSAO      DATA       RESPONSAVEL              *
* 1.00.00.000 13/11/2024 Marcio Stammerjohann     *
*************************************************************************************/

def var jNF          as JsonObject no-undo.

def var jItens       as jsonObject no-undo.
def var jItem        as JsonObject no-undo.
def var jArrayItem   as JsonArray  no-undo.

def var jFaturas     as jsonObject no-undo.
def var jFatura      as JsonObject no-undo.
def var jArrayFatura as JsonArray  no-undo.

def var jArrayNF     as JsonArray  no-undo.

DEF VAR arrayNotas  AS jsonArray    NO-UNDO.
DEF VAR objNotas    AS JsonObject   NO-UNDO.

//de para cabecalho nota
DEF VAR c-empresa-sap    as char no-undo.
DEF VAR c-estab-sap      as char no-undo.
DEF VAR c-local-neg-sap  as char no-undo.

//de para itens nota
define var c-TribICM-sap    as char no-undo.
define var c-TribIPI-sap    as char no-undo.
define var c-TribCofins-sap as char no-undo.
define var c-TribPis-sap    as char no-undo.
define var c-NatOper-sap    as char no-undo. 

define var c-TribICM-totvs    as char no-undo.
define var c-TribIPI-totvs    as char no-undo.
define var c-TribCofins-totvs as char no-undo.
define var c-TribPis-totvs    as char no-undo.
define var c-NatOper-totvs    as char no-undo. 

DEFINE VAR c-arquivo-log1  AS CHAR NO-UNDO.
DEFINE VAR l-producao      AS LOG  NO-UNDO.
DEFINE VAR l-log           AS LOG  NO-UNDO.
DEFINE VAR l-erro          AS LOG  NO-UNDO.

procedure pi-consulta-nf:
    def input  param jsonInput  as JsonObject no-undo.
    def output param jsonOutput as JsonObject no-undo.

    EMPTY TEMP-TABLE tt-erro.
    RUN pi-valida-arquivo-saida.

    //ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_esintegrationDocFiscal-homolog.txt'.

    RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 1").

    def var oResponse       as JsonAPIResponse      no-undo.
    def var oRequestParser  as JsonAPIRequestParser no-undo.
    def var oJsonObject     as JsonObject           no-undo.
    def var jPrincipal      as JsonObject           no-undo.
    def var jArrayPrincipal as JsonArray            no-undo.

    def var jPrincipalErro   as JsonObject           no-undo.
    def var oJsonObjectErro  as JsonObject           no-undo.

    def var c-estab      as char no-undo.
    def var c-nota       AS CHAR no-undo.
    def var c-serie      as CHAR no-undo.
    def var i-aux        as inte no-undo.
    def var i-num-param  as inte no-undo.

    delete object jNF          no-error.
    delete object jItens       no-error.
    delete object jItem        no-error.
    delete object jArrayItem   no-error.
    delete object jFaturas     no-error.
    delete object jFatura      no-error.
    delete object jArrayFatura no-error.
    delete object jArrayNF     no-error.

    empty temp-table RowErrors.

    assign oRequestParser = new JsonAPIRequestParser(jsonInput) no-error.

    assign jArrayPrincipal = new JsonArray().
    jArrayPrincipal = oRequestParser:getPathParams() no-error.

    assign i-num-param = jArrayPrincipal:length no-error.

    RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 2").

    if i-num-param > 1 
    then.
    else return.

    do i-aux = 1 to i-num-param:
       case i-aux:
            when 1
            then assign c-nota  = JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux) no-error.
            when 2 
            then assign c-serie = JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux) no-error.
            when 3
            then assign c-estab   = JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux) no-error.
        end case.
    end.

    RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 3").
    RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 3 - " + c-nota).
    RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 3 - " + c-serie).
    RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 3 - " + c-estab).

    assign i-aux = 0.

    RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 4").

    assign jArrayNF = new JsonArray().

    RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 5").
       
    for each nota-fiscal no-lock
       where nota-fiscal.nr-nota-fis = c-nota
         AND nota-fiscal.serie       = c-serie
         AND nota-fiscal.cod-estabel = c-estab:
         
        assign i-aux = i-aux + 1.

        RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 6").

        run pi-array-NF.
    end. 
    
    if i-aux = 0 then 
       return.

    assign jPrincipal  = new JsonObject().
    assign oJsonObject = new JsonObject().
    jPrincipal:add("nf",jArrayNF).
    oJsonObject:add("nfs",jPrincipal). 

    IF NOT CAN-FIND(tt-erro) THEN DO:
      /* assign jPrincipal  = new JsonObject().
       assign oJsonObject = new JsonObject().
     
       jPrincipal:add("nf",jArrayNF).
       oJsonObject:add("nfs",jPrincipal). */
     
       run createJsonResponse(input  oJsonObject, 
                              input  table RowErrors, 
                              input  false,
                              output jsonOutput).  
    END.
    ELSE DO:

       /* assign jPrincipalErro  = new JsonObject().
        assign oJsonObjectErro = new JsonObject().
        jPrincipalErro:add("erro",arrayNotas).
        oJsonObjectErro:add("erros",jPrincipalErro). */

        ASSIGN arrayNotas = NEW JsonArray(). 
        FOR EACH tt-erro:

            ASSIGN objNotas    = NEW JsonObject().

            objNotas:ADD("errorCode", tt-erro.codigo).
            objNotas:ADD("errorInfo",tt-erro.informacao).
            objNotas:ADD("errorDescription", tt-erro.mensagem).

            arrayNotas:ADD(objNotas).

        END. 

        //oJsonObject:ADD("returnErrors", jArrayNF).
        RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs ERRO6").
        //oJsonObject:ADD("Erros", jArrayNF).
        jPrincipal:ADD("Erros", arrayNotas).

         RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs ERRO7").

        ASSIGN jsonOutput = NEW jsonObject().

         RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs ERRO8").
        jsonOutput = JsonAPIResponseBuilder:ok(oJsonObject, 400). 

         RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs ERRO9").
    END.
end procedure. /* procedure pi-consulta-nf */

procedure pi-array-NF:
    def var de-icmsSubValue as deci no-undo.
    def var de-icmsValue    as deci no-undo.

    RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 7").

    RUN pi-busca-de-para-nota(OUTPUT c-empresa-sap,
                              OUTPUT c-estab-sap,
                              OUTPUT c-local-neg-sap).

    assign jNF = new JsonObject().
           jNF:add("dt-emis-nf",nota-fiscal.dt-emis).
           jNF:add("serie",nota-fiscal.serie).
           jNF:add("cod-emitente",nota-fiscal.cod-emitente).
           jNF:add("nr-nota-fis",nota-fiscal.nr-nota-fis).
           jNF:add("chave",substring(nota-fiscal.cod-chave-aces-nf-eletro,36,8)).
           jNF:add("chave-acesso",nota-fiscal.cod-chave-aces-nf-eletro).
           jNF:add("cod-protoc",nota-fiscal.cod-protoc).
           jNF:add("c-empresa",substring(nota-fiscal.cod-estabel,1,1)).
           jNF:add("c-empresa-sap",c-empresa-sap).
           jNF:add("cod-estabel",nota-fiscal.cod-estabel).
           jNF:add("c-estab-sap",c-estab-sap).
           jNF:add("c-local-neg-sap",c-local-neg-sap).


           /*jNF:add("c-empresa-sap",nota-fiscal.cod-estabel).
           jNF:add("cod-estabel",nota-fiscal.cod-estabel).
           jNF:add("cod-estabel",nota-fiscal.cod-estabel).*/
  
    assign jItens     = new JsonObject().
    assign jArrayItem = new JsonArray().

    for each it-nota-fisc no-lock
       where it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
         and it-nota-fisc.serie       = nota-fiscal.serie
         and it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis,
       first item no-lock
       where item.it-codigo = it-nota-fisc.it-codigo:

        FIND FIRST it-doc-fisc NO-LOCK USE-INDEX ch-it-doc            
             WHERE it-doc-fisc.cod-estabel = it-nota-fisc.cod-estabel
               AND it-doc-fisc.nr-doc-fis  = it-nota-fisc.nr-nota-fis
               AND it-doc-fisc.serie       = it-nota-fisc.serie      
               AND it-doc-fisc.it-codigo   = it-nota-fisc.it-codigo
               AND it-doc-fisc.nat-oper    = it-nota-fisc.nat-oper NO-ERROR.
        
        RUN pi-busca-de-para-item-nota(OUTPUT c-TribICM-sap,  
                                       OUTPUT c-TribIPI-sap,   
                                       OUTPUT c-TribCofins-sap,
                                       OUTPUT c-TribPis-sap,
                                       OUTPUT c-TribICM-totvs,  
                                       OUTPUT c-TribIPI-totvs,   
                                       OUTPUT c-TribCofins-totvs,
                                       OUTPUT c-TribPis-totvs,   
                                       OUTPUT c-NatOper-sap,
                                       OUTPUT c-NatOper-totvs).

        RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 7 c-TribICM-sap - "    + c-TribICM-sap  ) .
        RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 7 c-TribIPI-sap - "    + c-TribIPI-sap  ).
        RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 7 c-TribCofins-sap - " + c-TribCofins-sap).
        RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 7 c-TribPis-sap - "    + c-TribPis-sap  ).
        RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 7 c-NatOper-sap - "    + c-NatOper-sap  ).


        RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 7 c-TribICM-totvs - "    + c-TribICM-totvs  ) .
        RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 7 c-TribIPI-totvs - "    + c-TribIPI-totvs  ).
        RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 7 c-TribCofins-totvs - " + c-TribCofins-totvs).
        RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 7 c-TribPis-totvs - "    + c-TribPis-totvs  ).
        RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 7 c-NatOper-totvs - "    + c-NatOper-totvs  ).

        assign jItem = new JsonObject().
               jItem:add("nr-seq-fat",it-nota-fisc.nr-seq-fat).
               jItem:add("it-codigo",item.it-codigo).
               jItem:ADD("quantidade",it-nota-fisc.qt-faturada[1]).
               jItem:add("merc-liq-qtde", (it-nota-fisc.vl-merc-liq / it-nota-fisc.qt-faturada[1]) ).
               jItem:add("vl-merc-liq",it-nota-fisc.vl-merc-liq).
               jItem:add("vl-frete-it",it-nota-fisc.vl-frete-it).
               jItem:add("vl-despes-it",it-nota-fisc.vl-despes-it). //rever pra baixo
               jItem:add("val-base-calc-cofins",it-doc-fisc.val-base-calc-cofins).
               jItem:add("val-base-calc-pis",it-doc-fisc.val-base-calc-pis).
               jItem:add("vl-bicms-it",it-doc-fisc.vl-bicms-it).
               jItem:add("vl-bipi-it",it-doc-fisc.vl-bipi-it).
               jItem:add("vl-bsubs-it",it-doc-fisc.vl-bsubs-it).
               jItem:add("aliq-cofins",trim(SUBSTRING(it-doc-fisc.char-2,30,8))).
               jItem:add("aliq-pis",trim(SUBSTRING(it-doc-fisc.char-2,22,8))).
               jItem:add("aliquota-icm",it-doc-fisc.aliquota-icm).
               jItem:add("aliquota-ipi",it-doc-fisc.aliquota-ipi).
               jItem:add("val-cofins",it-doc-fisc.val-cofins).
               jItem:add("val-pis",it-doc-fisc.val-pis).
               jItem:add("vl-icms-it",it-doc-fisc.vl-icms-it).
               jItem:add("vl-ipi-it",it-doc-fisc.vl-ipi-it).
               jItem:add("vl-icmsub-it",it-doc-fisc.vl-icmsub-it).
               jItem:add("vl-icmsnt-it",it-doc-fisc.vl-icmsnt-it).
               jItem:add("vl-ipint-it",it-doc-fisc.vl-ipint-it).
               jItem:add("vl-icmsou-it",it-doc-fisc.vl-icmsou-it).
               //jItem:add("val-ipisou-it",it-doc-fisc.vl-ipisou-it).
               jItem:add("codigo-orig",ITEM.codigo-orig).

               jItem:add("cd-trib-icm",c-TribICM-totvs).
               jItem:add("c-TribICM-sap",c-TribICM-sap).
               jItem:add("cd-trib-ipi",c-TribIPI-totvs).
               jItem:add("c-TribIPI-sap",c-TribIPI-sap).
               jItem:add("cd-trib-cofins",c-TribCofins-totvs).
               jItem:add("c-TribCofins-sap",c-TribCofins-sap).
               jItem:add("cd-trib-pis",c-TribPis-totvs).
               jItem:add("c-TribPis-sap",c-TribPis-sap).
               jItem:add("nat-operacao",it-doc-fisc.nat-operacao).
               jItem:add("c-NatOper-sap",c-NatOper-sap).
               jItem:add("c-NatOper-totvs",c-NatOper-totvs).

               //Campos com dexpara totvs x sap
              /* jItem:add("cd-trib-icm",it-doc-fisc.cd-trib-icm).
               jItem:add("cd-trib-ipi",it-doc-fisc.cd-trib-ipi).
               jItem:add("cd-trib-cofins",it-doc-fisc.cd-trib-cofins).
               jItem:add("cd-trib-pis",it-doc-fisc.cd-trib-pis).
               jItem:add("nat-operacao",it-doc-fisc.nat-operacao).*/

        jArrayItem:add(jItem).
    end. /* for each it-nota-fisc */

    jItens:add("item",JArrayItem).
    jNF:add("itens",jItens). 

    jArrayNF:add(jNF). 
end procedure. /* procedure pi-array-NF */


PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log1 <> "" and c-arquivo-log1 <> ? then do:
    
        output to value(c-arquivo-log1) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put "     " + c-lbl-liter-ponto-executado + ": " p-string + " - "  format "x(200)" skip.
        output close. 
    
    end.
END.


PROCEDURE pi-busca-de-para-nota:

    DEFINE OUTPUT PARAM pEmpresa  AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM pEstab    AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM pLocalNeg AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "nf-campo-sap":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FIND FIRST tt-prog-ponto 
         WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = substring(nota-fiscal.cod-estabel,1,1) NO-ERROR.
    IF AVAIL tt-prog-ponto THEN DO:
        ASSIGN pEmpresa = ENTRY(2,tt-prog-ponto.conteudo,";").
    END.
    ELSE DO:
        RUN pi-erro(INPUT 412,
                    INPUT "Sem DE x Para no ES0018",
                    INPUT "Sem DE x Para de empresa no es0018 ponto nf-campo-sap SEQ 1").
        ASSIGN l-erro = YES.
    END.


    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "nf-campo-sap":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto 
         WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = nota-fiscal.cod-estabel NO-ERROR.
    IF AVAIL tt-prog-ponto THEN DO:
       ASSIGN pEstab = ENTRY(2,tt-prog-ponto.conteudo,";").
    END.
    ELSE DO:
        RUN pi-erro(INPUT 412,
                    INPUT "Sem DE x Para no ES0018",
                    INPUT "Sem DE x Para de estabelecimento no es0018 ponto nf-campo-sap SEQ 2").
        ASSIGN l-erro = YES.
    END.


    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "nf-campo-sap":U,
                       INPUT 3,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto 
         WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = nota-fiscal.cod-estabel NO-ERROR.
    IF AVAIL tt-prog-ponto THEN
       ASSIGN pLocalNeg = ENTRY(2,tt-prog-ponto.conteudo,";").

    IF l-erro THEN
        RETURN "NOK".
    ELSE
        RETURN "OK".


END PROCEDURE.


PROCEDURE pi-busca-de-para-item-nota:

    DEFINE OUTPUT PARAM pTribICM          AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM pTribIPI          AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM pTribCofins       AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM pTribPis          AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM pTribICM-totvs    AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM pTribIPI-totvs    AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM pTribCofins-totvs AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM pTribPis-totvs    AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM pNatOper          AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM pNatOper-totvs    AS CHAR NO-UNDO.


    IF CAN-FIND(FIRST dwf-docto-item-impto NO-LOCK
                WHERE dwf-docto-item-impto.cod-docto    = it-doc-fisc.nr-doc-fis        
                  AND dwf-docto-item-impto.cod-serie    = it-doc-fisc.serie 
                  AND dwf-docto-item-impto.cod-estab    = it-doc-fisc.cod-estabel    
                  AND dwf-docto-item-impto.cod-item     = it-doc-fisc.it-codigo            
                  AND dwf-docto-item-impto.num-seq-item = it-doc-fisc.nr-seq-do) THEN DO:
    
        FOR EACH dwf-docto-item-impto NO-LOCK USE-INDEX dwfdctta-id        
           WHERE dwf-docto-item-impto.cod-docto    = it-doc-fisc.nr-doc-fis        
             AND dwf-docto-item-impto.cod-serie    = it-doc-fisc.serie 
             AND dwf-docto-item-impto.cod-estab    = it-doc-fisc.cod-estabel    
             AND dwf-docto-item-impto.cod-item     = it-doc-fisc.it-codigo            
             AND dwf-docto-item-impto.num-seq-item = it-doc-fisc.nr-seq-doc :
      
             EMPTY TEMP-TABLE tt-prog-ponto.
           
             RUN esp/es0018p.p (INPUT "nf-campo-sap":U,
                                INPUT 4,
                                INPUT 0,
                                INPUT "":U,
                                OUTPUT TABLE tt-prog-ponto).
           
             IF dwf-docto-item-impto.cod-impto = 'ICMS' AND dwf-docto-item-impto.cod-tributac <> "" THEN DO:
                ASSIGN pTribICM-totvs = SUBSTRING(dwf-docto-item-impto.cod-tributac,2,2).
                FIND FIRST tt-prog-ponto 
                     WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = SUBSTRING(dwf-docto-item-impto.cod-tributac,2,2) NO-ERROR.
                IF AVAIL tt-prog-ponto THEN DO:
                   ASSIGN pTribICM = ENTRY(2,tt-prog-ponto.conteudo,";").
                         // pTribICM-totvs = SUBSTRING(dwf-docto-item-impto.cod-tributac,2,2).
                END.
                ELSE DO:
                    RUN pi-erro(INPUT 412,
                                INPUT "Sem DE x Para no ES0018",
                                INPUT "Sem DE x Para de Tributacao Icms no es0018 ponto nf-campo-sap SEQ 4").      
      
                    ASSIGN l-erro = YES.
                END.
             END.
           
             EMPTY TEMP-TABLE tt-prog-ponto.
           
             RUN esp/es0018p.p (INPUT "nf-campo-sap":U,
                                INPUT 5,
                                INPUT 0,
                                INPUT "":U,
                                OUTPUT TABLE tt-prog-ponto).
           
             IF dwf-docto-item-impto.cod-impto = 'IPI' AND dwf-docto-item-impto.cod-tributac <> "" THEN DO:
                ASSIGN pTribIPI-totvs = string(dwf-docto-item-impto.cod-tributac).
                FIND FIRST tt-prog-ponto 
                     WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = string(dwf-docto-item-impto.cod-tributac) NO-ERROR.
                IF AVAIL tt-prog-ponto THEN DO:
                   ASSIGN pTribIPI = ENTRY(2,tt-prog-ponto.conteudo,";").
                         // pTribIPI-totvs = string(dwf-docto-item-impto.cod-tributac).
                END.
                ELSE DO:
                    RUN pi-erro(INPUT 412,
                                INPUT "Sem DE x Para no ES0018",
                                INPUT "Sem DE x Para de Tributacao IPI no es0018 ponto nf-campo-sap SEQ 5").
                    ASSIGN l-erro = YES.
                END.
             END.
           
             EMPTY TEMP-TABLE tt-prog-ponto.
           
             RUN esp/es0018p.p (INPUT "nf-campo-sap":U,
                                INPUT 6,
                                INPUT 0,
                                INPUT "":U,
                                OUTPUT TABLE tt-prog-ponto).
           
             IF dwf-docto-item-impto.cod-impto = 'COFINS' AND dwf-docto-item-impto.cod-tributac <> "" THEN DO:
                ASSIGN pTribCofins-totvs = string(dwf-docto-item-impto.cod-tributac).
                FIND FIRST tt-prog-ponto 
                     WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = string(dwf-docto-item-impto.cod-tributac) NO-ERROR.
                IF AVAIL tt-prog-ponto THEN DO:
                   ASSIGN pTribCofins = ENTRY(2,tt-prog-ponto.conteudo,";").
                          //pTribCofins-totvs = string(dwf-docto-item-impto.cod-tributac).
                END.
                ELSE DO:
                    RUN pi-erro(INPUT 412,
                                INPUT "Sem DE x Para no ES0018",
                                INPUT "Sem DE x Para de Tributacao Cofins no es0018 ponto nf-campo-sap SEQ 6").
                    ASSIGN l-erro = YES.
                END.
             END.
           
             EMPTY TEMP-TABLE tt-prog-ponto.
           
             RUN esp/es0018p.p (INPUT "nf-campo-sap":U,
                                INPUT 7,
                                INPUT 0,
                                INPUT "":U,
                                OUTPUT TABLE tt-prog-ponto).
           
             IF dwf-docto-item-impto.cod-impto = 'PIS' AND dwf-docto-item-impto.cod-tributac <> "" THEN DO:
                ASSIGN pTribPis-totvs = string(dwf-docto-item-impto.cod-tributac).
                FIND FIRST tt-prog-ponto 
                     WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = string(dwf-docto-item-impto.cod-tributac) NO-ERROR.
                IF AVAIL tt-prog-ponto THEN DO:
                   ASSIGN pTribPis       = ENTRY(2,tt-prog-ponto.conteudo,";").
                         // pTribPis-totvs = string(dwf-docto-item-impto.cod-tributac).
                END.
                ELSE DO:
                    RUN pi-erro(INPUT 412,
                                INPUT "Sem DE x Para no ES0018",
                                INPUT "Sem DE x Para de Tributacao PIS no es0018 ponto nf-campo-sap SEQ 7").
                    ASSIGN l-erro = YES.
                END.
             END.
        END.
    END.
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
           
        RUN esp/es0018p.p (INPUT "nf-campo-sap":U,
                           INPUT 4,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        
        ASSIGN pTribICM-totvs = substring(it-nota-fisc.char-1,466,2).
        FIND FIRST tt-prog-ponto 
             WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = substring(it-nota-fisc.char-1,466,2) NO-ERROR.
        IF AVAIL tt-prog-ponto THEN DO:
           ASSIGN pTribICM = ENTRY(2,tt-prog-ponto.conteudo,";").
                 // pTribICM-totvs = SUBSTRING(dwf-docto-item-impto.cod-tributac,2,2).
        END.
        ELSE DO:
            RUN pi-erro(INPUT 412,
                        INPUT "Sem DE x Para no ES0018",
                        INPUT "Sem DE x Para de Tributacao Icms no es0018 ponto nf-campo-sap SEQ 4").      
      
            ASSIGN l-erro = YES.
        END.
        
        EMPTY TEMP-TABLE tt-prog-ponto.
        
        RUN esp/es0018p.p (INPUT "nf-campo-sap":U,
                           INPUT 5,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        
        ASSIGN pTribIPI-totvs = string(it-nota-fisc.cod-sit-tributar-ipi).
        FIND FIRST tt-prog-ponto 
             WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = string(it-nota-fisc.cod-sit-tributar-ipi) NO-ERROR.
        IF AVAIL tt-prog-ponto THEN DO:
           ASSIGN pTribIPI = ENTRY(2,tt-prog-ponto.conteudo,";").
                 // pTribIPI-totvs = string(dwf-docto-item-impto.cod-tributac).
        END.
        ELSE DO:
            RUN pi-erro(INPUT 412,
                        INPUT "Sem DE x Para no ES0018",
                        INPUT "Sem DE x Para de Tributacao IPI no es0018 ponto nf-campo-sap SEQ 5").
            ASSIGN l-erro = YES.
        END.
        
        EMPTY TEMP-TABLE tt-prog-ponto.
        
        RUN esp/es0018p.p (INPUT "nf-campo-sap":U,
                           INPUT 6,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        
        
        ASSIGN pTribCofins-totvs = string(it-nota-fisc.cod-sit-tributar-cofins).
        FIND FIRST tt-prog-ponto 
             WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = string(it-nota-fisc.cod-sit-tributar-cofins) NO-ERROR.
        IF AVAIL tt-prog-ponto THEN DO:
           ASSIGN pTribCofins = ENTRY(2,tt-prog-ponto.conteudo,";").
                  //pTribCofins-totvs = string(dwf-docto-item-impto.cod-tributac).
        END.
        ELSE DO:
            RUN pi-erro(INPUT 412,
                        INPUT "Sem DE x Para no ES0018",
                        INPUT "Sem DE x Para de Tributacao Cofins no es0018 ponto nf-campo-sap SEQ 6").
            ASSIGN l-erro = YES.
        END.
        
        EMPTY TEMP-TABLE tt-prog-ponto.
        
        RUN esp/es0018p.p (INPUT "nf-campo-sap":U,
                           INPUT 7,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        
        
        ASSIGN pTribPis-totvs = string(it-nota-fisc.cod-sit-tributar-pis).
        FIND FIRST tt-prog-ponto 
             WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = string(it-nota-fisc.cod-sit-tributar-pis) NO-ERROR.
        IF AVAIL tt-prog-ponto THEN DO:
           ASSIGN pTribPis       = ENTRY(2,tt-prog-ponto.conteudo,";").
                 // pTribPis-totvs = string(dwf-docto-item-impto.cod-tributac).
        END.
        ELSE DO:
            RUN pi-erro(INPUT 412,
                        INPUT "Sem DE x Para no ES0018",
                        INPUT "Sem DE x Para de Tributacao PIS no es0018 ponto nf-campo-sap SEQ 7").
            ASSIGN l-erro = YES.
        END.

    END.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "nf-campo-sap":U,
                       INPUT 8,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 8 c-NatOper-sap - "    + it-doc-fisc.nat-operacao + string(AVAIL it-doc-fisc)).

    ASSIGN pNatOper-Totvs = it-doc-fisc.nat-operacao.
    FIND FIRST tt-prog-ponto 
         WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = it-doc-fisc.nat-operacao NO-ERROR.
    IF AVAIL tt-prog-ponto THEN DO:
       RUN pi-gerar-dados-extrato("ENTROU espIntegration_Buscanftotvs 8-111 c-NatOper-sap" ).
       ASSIGN pNatOper = ENTRY(2,tt-prog-ponto.conteudo,";").
    END.
    ELSE DO:
        RUN pi-erro(INPUT 412,
                    INPUT "Sem DE x Para no ES0018",
                    INPUT "Sem DE x Para de Nat Oper no es0018 ponto nf-campo-sap SEQ 8").
        ASSIGN l-erro = YES.
    END.

    IF l-erro THEN
        RETURN "NOK".
    ELSE
        RETURN "OK".

END PROCEDURE.


PROCEDURE pi-valida-arquivo-saida:

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "ambiente":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FIND FIRST tt-prog-ponto NO-ERROR.
    
    IF AVAILABLE tt-prog-ponto               AND
       tt-prog-ponto.conteudo = "PRODUCAO":U THEN
       ASSIGN l-producao = YES.
    ELSE
       ASSIGN l-producao = NO.

    EMPTY TEMP-TABLE tt-prog-ponto.

        //ver se o log esta ativado
    RUN esp/es0018p.p (INPUT "log-wso2":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto 
         WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'integrationBuscaNFTotvs' NO-ERROR.
    IF AVAILABLE tt-prog-ponto AND
       ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
       ASSIGN l-log = YES.
    ELSE
       ASSIGN l-log = NO.
    
    
    IF l-log = YES THEN DO:
       IF OPSYS = 'UNIX' THEN
          ASSIGN c-arquivo-log1 = '/usr/wrk/totvs/UNIX_integrationBuscaNFTotvs-'.
       ELSE
          ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_integrationBuscaNFTotvs-'.
       
       IF l-producao THEN
          ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
       ELSE 
          ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.
    END.


END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM i-code AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM c-info AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM c-erro AS CHARACTER NO-UNDO.
    
    CREATE tt-erro.
    ASSIGN tt-erro.codigo     = i-code
           tt-erro.informacao = c-info
           tt-erro.mensagem   = c-erro.

END PROCEDURE.

