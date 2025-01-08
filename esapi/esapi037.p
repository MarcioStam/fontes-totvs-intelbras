/****************************************************************************
** Programa : ESAPI037
** Descricao: Atualiza‡Æo Ordem de Compra e Ordem de Produ‡Æo APS
**     Autor: Graziely Lima
**      Data: 21/02/2022
*****************************************************************************/
{esp/esapi506.i} 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD stringToDate Include 
FUNCTION stringToDate RETURNS DATE
  ( cDate AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

define input parameter p-process as integer no-undo. /* 1  - somente OP; 2 - somente OC; 3 - Ambas */

DEF BUFFER bf-las-api-log  FOR es-api-log.
DEF BUFFER bbf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log  FOR es-api-log.

DEFINE VARIABLE l-criado AS LOGICAL.
DEFINE VARIABLE h-acomp  AS HANDLE.
define variable i-seq    as integer no-undo.

{include/i-rpvar.i}
{utp/ut-glob.i}

/*** Definicao de Forms
**********************************/
FORM HEADER 
     FILL("-",132) AT 1 FORMAT "x(132)"
     c-empresa AT 1 c-titulo-relat AT 46
     FILL("-", 110) FORMAT "x(110)" TODAY FORMAT "99/99/9999"
     "-" STRING(TIME, "HH:MM:SS") SKIP(2)
WITH STREAM-IO WIDTH 132 NO-LABELS NO-BOX PAGE-TOP FRAME f-cabecalho.

FORM HEADER 
     FILL("-", 78) FORMAT "x(76)" "DATASUL" c-sistema FORMAT "x(9)" 
     "-" c-programa "-" "V:" c-versao AT 123 FORMAT "x(8)" c-revisao FORMAT "X(3)" AT 131
WITH STREAM-IO WIDTH 140 NO-LABELS NO-BOX PAGE-BOTTOM FRAME f-rodape1.

//RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

/* Inicio */ 
if p-process <> 2
then do:
     FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'UPD_Ordens' EXCLUSIVE-LOCK NO-ERROR.
     IF NOT AVAIL es-api-URI THEN LEAVE.
     
     FIND LAST bf-las-api-log NO-LOCK WHERE bf-las-api-log.id-api-log > 0 NO-ERROR.
     
     FIND FIRST es-api-log
          WHERE es-api-log.id-aplicacao = 'APS'
            AND es-api-log.id-URI       = 'UPD_Ordens'
            AND es-api-log.seqexec      = bf-las-api-log.seqexec EXCLUSIVE-LOCK NO-ERROR.
     IF NOT AVAIL es-api-log THEN DO:
         CREATE es-api-log.
         ASSIGN es-api-log.seqexec        = bf-las-api-log.seqexec + 10   
                es-api-log.id-aplicacao   = 'APS'
                es-api-log.id-URI         = es-api-URI.id-URI
                es-api-log.origem         = es-api-URI.id-URI
                es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).
         
        
         RUN pi-metodo-get-prod. 
     END.
     ELSE 
         RUN pi-metodo-get-prod.
end. /* if p-process <> 2 */

if p-process <> 1
then do:
     FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'UPD_Compras' EXCLUSIVE-LOCK NO-ERROR.
     IF NOT AVAIL es-api-URI THEN LEAVE.
     
     FIND LAST bbf-las-api-log NO-LOCK WHERE bbf-las-api-log.id-api-log > 0 NO-ERROR.
     
     FIND FIRST es-api-log
          WHERE es-api-log.id-aplicacao = 'APS'
            AND es-api-log.id-URI       = 'UPD_Compras'
            AND es-api-log.seqexec      = bbf-las-api-log.seqexec EXCLUSIVE-LOCK NO-ERROR.
     IF NOT AVAIL es-api-log THEN DO:
         CREATE es-api-log.
         ASSIGN es-api-log.seqexec        = bbf-las-api-log.seqexec + 10   
                es-api-log.id-aplicacao   = 'APS'
                es-api-log.id-URI         = es-api-URI.id-URI
                es-api-log.origem         = es-api-URI.id-URI
                es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).
        
         RUN pi-metodo-get-comp. 
     END.
     ELSE 
         RUN pi-metodo-get-comp.
end. /* if p-process <> 1 */

IF RETURN-VALUE = "OK" THEN
    RETURN "OK".

//RUN pi-finalizar IN h-acomp.

/************************* Procedures *************************/
PROCEDURE pi-metodo-get-prod:
    DEFINE VARIABLE myParserAux        AS ObjectModelParser   NO-UNDO.
    DEFINE VARIABLE JsonAux            AS JsonObject          NO-UNDO.
    DEFINE VARIABLE oJsonArray         AS jsonArray           NO-UNDO.
    DEFINE VARIABLE oJsonObj           AS jsonObject          NO-UNDO.
    DEFINE VARIABLE cOrdemAps          AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE dDataIni           AS DATE                NO-UNDO.
    DEFINE VARIABLE dDataFim           AS DATE                NO-UNDO.
    DEFINE VARIABLE i                  AS INTEGER             NO-UNDO.
    define variable lg-inicializou     as logical             no-undo.
    
    ASSIGN es-api-URI.metodo = 'GET' 
           c-endereco = es-api-URI.ent-PRD.
   
    fc-chamada-2().

    IF SUBSTRING(es-api-log.cod-retorno,1,2) = '20' THEN DO:

        myParserAux = NEW ObjectModelParser().
        JsonAux = CAST(myParserAux:Parse(cLongJson), JsonObject).

        ASSIGN oJsonArray = NEW JsonArray().

        IF JsonAux:has("value") THEN DO:
            oJsonArray = JsonAux:getJsonArray("value"). 
        END.

        ASSIGN c-sistema      = "ATUALIZACAO"
               c-titulo-relat = "ATUALIZACAO ORDENS PRODUCAO - APS"
               c-empresa      = "INTELBRAS"
               c-programa     = "ESAPI037"
               c-versao       = "1.00.00."
               c-revisao      = "002".

        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "atualizacao-op-aps.txt") PAGE-SIZE 64 NO-CONVERT.

        VIEW FRAME f-cabecalho.
        VIEW FRAME f-rodape1.

        array:
        DO i = 1 TO oJsonArray:LENGTH ON ERROR UNDO, NEXT:

            oJsonObj = oJsonArray:GetJsonObject(i).

            ASSIGN cOrdemAps = oJsonObj:GetJsonText("ordem")
                   dDataIni  = stringToDate(STRING(oJsonObj:GetJsonText("datainicio"))) 
                   dDataFim  = stringToDate(STRING(oJsonObj:GetJsonText("dataentrega"))).
            assign lg-inicializou = yes
                   i-seq          = 0.

            IF CAN-FIND(FIRST int-upd-prod-aps WHERE 
                              int-upd-prod-aps.nr-ord-prod = INT(cOrdemAps)
                              no-lock)
            then for last int-upd-prod-aps no-lock
                    where int-upd-prod-aps.nr-ord-prod = INT(cOrdemAps):
                     assign i-seq = int-upd-prod-aps.sequencia.
                 end.

            RUN pi-inicializar IN h-acomp (INPUT "Integrando Ordem APS " + cOrdemAps + "...").

            // Cria a tabela com as ordens de compra enviadas pelo APS
            CREATE int-upd-prod-aps.
            ASSIGN int-upd-prod-aps.nr-ord-prod      = INT(oJsonObj:GetJsonText("ordem"))
                   int-upd-prod-aps.dt-inicio        = stringToDate(STRING(oJsonObj:GetJsonText("datainicio")))
                   int-upd-prod-aps.dt-fim           = stringToDate(STRING(oJsonObj:GetJsonText("dataentrega")))
                   int-upd-prod-aps.log-atualizado   = NO
                   int-upd-prod-aps.sequencia        = i-seq + 10
                   int-upd-prod-aps.usuar-integr-in  = c-seg-usuario
                   int-upd-prod-aps.dt-integr-in     = now
                   int-upd-prod-aps.data-atualizacao = today.
            find current int-upd-prod-aps no-lock no-error.
            release int-upd-prod-aps.
            
            ASSIGN l-criado = YES.
        END.

        IF l-criado THEN DO:
            PUT UNFORMATTED "Tabela de Integra‡Æo de ordem de produ‡Æo criada com sucesso." SKIP.
        END.

        OUTPUT CLOSE.

        if valid-handle(h-acomp)
        then if lg-inicializou
             then RUN pi-finalizar IN h-acomp.
             else delete procedure h-acomp no-error.

        RETURN "OK".
        
    END.
END PROCEDURE.

/************************* Procedures *************************/
PROCEDURE pi-metodo-get-comp:
    DEFINE VARIABLE myParserAux        AS ObjectModelParser   NO-UNDO.
    DEFINE VARIABLE JsonAux            AS JsonObject          NO-UNDO.
    DEFINE VARIABLE oJsonArray         AS jsonArray           NO-UNDO.
    DEFINE VARIABLE oJsonObj           AS jsonObject          NO-UNDO.
    DEFINE VARIABLE cOrdemAps          AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE cParcela           AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE dNeces             AS DATE                NO-UNDO.
    DEFINE VARIABLE i                  AS INTEGER             NO-UNDO.
    define variable lg-inicializou     as logical             no-undo.
    
    ASSIGN es-api-URI.metodo = 'GET' 
           c-endereco = es-api-URI.ent-PRD.
   
    fc-chamada-2().

    IF SUBSTRING(es-api-log.cod-retorno,1,2) = '20' THEN DO:

        myParserAux = NEW ObjectModelParser().
        JsonAux = CAST(myParserAux:Parse(cLongJson), JsonObject).

        ASSIGN oJsonArray = NEW JsonArray().

        IF JsonAux:has("value") THEN DO:
            oJsonArray = JsonAux:getJsonArray("value"). 
        END.


        ASSIGN c-sistema      = "ATUALIZACAO"
               c-titulo-relat = "ATUALIZACAO ORDENS COMPRA - APS"
               c-empresa      = "INTELBRAS"
               c-programa     = "ESAPI037"
               c-versao       = "1.00.00."
               c-revisao      = "002".

        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "atualizacao-oc-aps.txt") PAGE-SIZE 64 NO-CONVERT.

        VIEW FRAME f-cabecalho.
        VIEW FRAME f-rodape1.

        array:
        DO i = 1 TO oJsonArray:LENGTH ON ERROR UNDO, NEXT:

            oJsonObj = oJsonArray:GetJsonObject(i).

            ASSIGN cOrdemAps = oJsonObj:GetJsonText("ordemcompra")
                   cParcela  = oJsonObj:GetJsonText("item")
                   dNeces    = stringToDate(STRING(oJsonObj:GetJsonText("datanecessidade"))).
            assign lg-inicializou = yes
                   i-seq          = 0.

            IF CAN-FIND(FIRST int-upd-compra-aps WHERE 
                              int-upd-compra-aps.nr-ord-comp = INT(cOrdemAps)
                          AND int-upd-compra-aps.parcela     = INT(cParcela)
                              no-lock)
            then for last int-upd-compra-aps no-lock
                    where int-upd-compra-aps.nr-ord-comp    = INT(cOrdemAps)
                      AND int-upd-compra-aps.parcela        = INT(cParcela):
                     assign i-seq = int-upd-compra-aps.sequencia.
                 end.

            RUN pi-inicializar IN h-acomp (INPUT "Integrando Ordem APS " + cOrdemAps + "...").

            // Cria a tabela com as ordens de compra enviadas pelo APS
            CREATE int-upd-compra-aps.
            ASSIGN int-upd-compra-aps.nr-ord-comp      = INT(cOrdemAps)
                   int-upd-compra-aps.parcela          = INT(cParcela)
                   int-upd-compra-aps.dt-necessidade   = dNeces                      
                   int-upd-compra-aps.log-atualizado   = NO
                   int-upd-compra-aps.sequencia        = i-seq + 10
                   int-upd-compra-aps.usuar-integr-in  = c-seg-usuario
                   int-upd-compra-aps.dt-integr-in     = now
                   int-upd-compra-aps.data-atualizacao = today.
            find current int-upd-compra-aps no-lock no-error.
            release int-upd-compra-aps.
            
            ASSIGN l-criado = YES.
        END.

        IF l-criado THEN DO:
            PUT UNFORMATTED "Tabela de atualiza‡Æo de ordem de compra criada com sucesso." SKIP.
        END.

        OUTPUT CLOSE.

        if valid-handle(h-acomp)
        then if lg-inicializou
             then RUN pi-finalizar IN h-acomp.
             else delete procedure h-acomp no-error.

        RETURN "OK".
        
    END.
END PROCEDURE.

FUNCTION stringToDate RETURNS DATE
    (cDate AS CHAR).

    DEF VAR iAno AS INT.
    DEF VAR iMes AS INT.
    DEF VAR iDia AS INT.

    ASSIGN iAno = INT(SUBSTRING(REPLACE(cDate,"-",""),1,4))
           iMes = INT(SUBSTRING(REPLACE(cDate,"-",""),5,2))
           iDia = INT(SUBSTRING(REPLACE(cDate,"-",""),7,2)).

    RETURN DATE(iMes,iDia,iAno).

END FUNCTION.

