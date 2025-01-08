/****************************************************************************
** Programa : ESAPI035
** Descricao: Integracao Ordem de Compra e Ordem de Produ‡Æo APS
**     Autor: Graziely Lima
**      Data: 21/02/2022
*****************************************************************************/
{esp/esapi506.i} 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD stringToDate Include 
FUNCTION stringToDate RETURNS DATE
  ( cDate AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

DEF BUFFER bf-las-api-log FOR es-api-log.
DEF BUFFER bf-new-api-log FOR es-api-log.

DEFINE VARIABLE l-criado AS LOGICAL.
DEFINE VARIABLE h-acomp  AS HANDLE.

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

/* Inicio */           
FIND FIRST es-api-URI WHERE es-api-URI.id-URI = 'INT_Ordens_MRP' EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAIL es-api-URI THEN LEAVE.

FIND LAST bf-las-api-log NO-LOCK WHERE bf-las-api-log.id-api-log > 0 NO-ERROR.

FIND FIRST es-api-log
     WHERE es-api-log.id-aplicacao = 'APS'
       AND es-api-log.id-URI       = 'INT_Ordens_MRP'
       AND es-api-log.seqexec      = bf-las-api-log.seqexec EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAIL es-api-log THEN DO:
    CREATE es-api-log.
    ASSIGN es-api-log.seqexec        = bf-las-api-log.seqexec + 10   
           es-api-log.id-aplicacao   = 'APS'
           es-api-log.id-URI         = es-api-URI.id-URI
           es-api-log.origem         = es-api-URI.id-URI
           es-api-log.id-api-log     = NEXT-VALUE(seq_api_log).
   
    RUN pi-metodo-get. 
END.
ELSE 
    RUN pi-metodo-get.

/************************* Procedures *************************/
PROCEDURE pi-metodo-get:
    DEFINE VARIABLE myParserAux        AS ObjectModelParser   NO-UNDO.
    DEFINE VARIABLE JsonAux            AS JsonObject          NO-UNDO.
    DEFINE VARIABLE oJsonArray         AS jsonArray           NO-UNDO.
    DEFINE VARIABLE oJsonObj           AS jsonObject          NO-UNDO.
    DEFINE VARIABLE cOrdemAps          AS CHARACTER           NO-UNDO.
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

        ASSIGN c-sistema      = "INTEGRACAO"
               c-titulo-relat = "INTEGRACAO ORDENS PRODUCAO - APS"
               c-empresa      = "INTELBRAS"
               c-programa     = "ESAPI035"
               c-versao       = "1.00.00."
               c-revisao      = "002".

        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "dados-op-aps.txt") PAGE-SIZE 64 NO-CONVERT.

        VIEW FRAME f-cabecalho.
        VIEW FRAME f-rodape1.

        array:
        DO i = 1 TO oJsonArray:LENGTH ON ERROR UNDO, NEXT:

            oJsonObj = oJsonArray:GetJsonObject(i).

            ASSIGN cOrdemAps = oJsonObj:GetJsonText("ordem").
            assign lg-inicializou = yes.

            IF NOT CAN-FIND(FIRST int-ord-prod-aps
                            WHERE int-ord-prod-aps.cod-ordem-aps = cOrdemAps) THEN DO:

                RUN pi-inicializar IN h-acomp (INPUT "Integrando Ordem APS " + cOrdemAps + "...").

                // Cria a tabela com as ordens de produ‡Æo enviadas pelo APS
                CREATE int-ord-prod-aps.
                ASSIGN int-ord-prod-aps.cod-ordem-aps    = oJsonObj:GetJsonText("ordem")
                       int-ord-prod-aps.cod-estabel      = oJsonObj:GetJsonText("estabelecimento")
                       int-ord-prod-aps.it-codigo        = oJsonObj:GetJsonText("codigoitem")
                       int-ord-prod-aps.dt-entrega       = stringToDate(STRING(oJsonObj:GetJsonText("dataentrega")))
                       int-ord-prod-aps.dt-emissao       = stringToDate(STRING(oJsonObj:GetJsonText("dataemissao")))
                       int-ord-prod-aps.dt-inicio        = stringToDate(STRING(oJsonObj:GetJsonText("datainicio")))
                       int-ord-prod-aps.qt-ord-prod      = DEC(REPLACE(oJsonObj:GetJsonText("qtde"),".",","))
                       int-ord-prod-aps.log-integrado    = NO
                       int-ord-prod-aps.usuar-integr-in  = c-seg-usuario
                       int-ord-prod-aps.dt-integr-in     = now.
                
                ASSIGN l-criado = YES.
            END.
            ELSE DO:
                RUN pi-inicializar IN h-acomp (INPUT "Ordem de Produ‡Æo: " + cOrdemAps).
                PUT UNFORMATTED "A Ordem de Produ‡Æo " cOrdemAps " j  encontra-se dispon¡vel para cria‡Æo no Datasul." SKIP. 
            END.
        END.

        IF l-criado THEN DO: 
            PUT UNFORMATTED "Tabela de Integra‡Æo criada com sucesso.".
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

