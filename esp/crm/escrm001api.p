/******************************************************************************
**  Programa.: ESCRM001API.P
**  Objetivo.: Gravar informaá‰es do Datasul EMS 2 na tabela de integraá∆o do
**             Microsoft CRM Dynamics no SQL Server.
**  Autor....: Gustavo Eduardo Tamanini - Exponencial TI - 27.07.2010
**             Fabiano Sakae Ribeiro    - Exponencial TI - 02.08.2010
*******************************************************************************/
{esp/es0018.i}
{esp/crm/escrm001api.i} /* Pre-processadores de conex∆o e variavel c-base-crm */
{esp/crm/escrm001b.i}   /* Definicoes de temp-tables para buscar as Tabelas do ems5 */
{cdp/cd0666.i}
CREATE WIDGET-POOL.

/* DEFINIÄ«O DE VARIAVEIS PARA CONEXAO COM O SQL SERVER */
DEFINE VARIABLE ObjRecordSet      AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE ObjConnection     AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE ObjCommand        AS COM-HANDLE  NO-UNDO.
                                  
DEFINE VARIABLE ODBC-DSN          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ODBC-SERVER       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ODBC-USERID       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ODBC-PASSWD       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ODBC-QUERY        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ODBC-STATUS       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ODBC-NULL         AS CHARACTER   NO-UNDO.
                                  
DEFINE VARIABLE ODBC-RECCOUNT     AS INTEGER     NO-UNDO.
DEFINE VARIABLE ODBC-CURSOR       AS INTEGER     NO-UNDO.

DEFINE VARIABLE lUtilizaWS        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE hWebService       AS HANDLE      NO-UNDO.
DEFINE VARIABLE hService          AS HANDLE      NO-UNDO.

DEFINE VARIABLE h-acomp           AS HANDLE      NO-UNDO.
DEFINE VARIABLE p-name-unid-negoc AS CHAR        NO-UNDO.
DEFINE VARIABLE c-erro            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-valor-dec       AS CHAR        NO-UNDO.
DEFINE VARIABLE d-valor-dec       AS DECIMAL     NO-UNDO. 
DEFINE VARIABLE i-seq-erro        AS INT         NO-UNDO.
DEFINE VARIABLE i-cont            AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-rua             AS CHAR        NO-UNDO. 
DEFINE VARIABLE c-nro             AS CHAR        NO-UNDO. 
DEFINE VARIABLE c-comp            AS CHAR        NO-UNDO.
DEFINE VARIABLE h-cdapi704        AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-seq-contato     AS INT         NO-UNDO.
DEFINE VARIABLE c-cgc             AS CHARACTER   NO-UNDO.  
DEFINE VARIABLE p-prox-emitente   LIKE emitente.cod-emitente NO-UNDO.
DEFINE VARIABLE cevento           AS CHAR INITIAL "W" NO-UNDO.
DEFINE VARIABLE l-log             AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-cont-chamadas   AS INTEGER     NO-UNDO.

DEFINE VARIABLE de-vl-bicms-it    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-icms-it     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-ipi-it      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-bsubs-it    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-icmsub-it   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-frete       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE cErro             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTituloEmail      AS CHARACTER   NO-UNDO.

DEFINE var c-des-msg              as char format "x(36)"     no-undo.
DEFINE var c-cod-erro             as char format "x(20)"     no-undo.
DEFINE var c-cod-ie-sai           like emitente.ins-estadual no-undo.

DEFINE BUFFER b-emitente FOR emitente.
DEFINE BUFFER b-int-emitente FOR int-emitente.

DEFINE TEMP-TABLE Rowerrors NO-UNDO
    FIELD errorsequence     AS INTEGER
    FIELD errornumber       AS INTEGER
    FIELD errordescription  AS CHARACTER FORMAT "x(60)":U
    FIELD errorparameters   AS CHARACTER
    FIELD errortype         AS CHARACTER
    FIELD errorhelp         AS CHARACTER FORMAT "x(60)":U
    FIELD errorsubtype      AS CHARACTER.

{esp/crm/escrm001.i}
{esp/crm/escrm001.i1} /* Definiá∆o das temp-tables de validaá∆o - cdp/cdapi329.p */
{esp/crm/escrm001a.i1}
{esapi/esapi010tt.i}

DEFINE TEMP-TABLE tt-erros-crm NO-UNDO LIKE tt-erros-geral
    FIELD tipo AS INTEGER /* 1 - Erro  2 - Advertencia */.
DEF TEMP-TABLE  tt-nf-astec
    FIELD cgc             LIKE nota-fiscal.cgc
    FIELD nr-nota-fis     LIKE nota-fiscal.nr-nota-fis
    FIELD serie           LIKE nota-fiscal.serie
    FIELD it-codigo       LIKE it-nota-fisc.it-codigo                  
    FIELD nr-os           LIKE int-ped-item.nr-os
    FIELD guid-os         LIKE int-ped-item.vl-guid-os
    FIELD qt-faturada     AS DEC
    FIELD vl-preuni       LIKE it-nota-fisc.vl-preuni      
    FIELD aliquota-ipi    LIKE it-nota-fisc.aliquota-ipi   
    FIELD vl-ipi-it       LIKE it-nota-fisc.vl-ipi-it      
    FIELD vl-icms-it      LIKE it-nota-fisc.vl-icms-it     
    FIELD vl-bicms-it     LIKE it-nota-fisc.vl-bicms-it    
    FIELD it-substituto   LIKE it-nota-fisc.it-codigo
    FIELD qtd-substituida AS DEC
    FIELD cod-estabel     LIKE it-nota-fisc.cod-estabel 
    FIELD dt-emis-nota    LIKE nota-fiscal.dt-emis-nota
    FIELD nr-conhec       LIKE int-nota-conhec.nr-conhec.

ASSIGN l-log = NO.

LOG-MANAGER:WRITE-MESSAGE('ESCRM001API') NO-ERROR.

/* Verifica se a integraá∆o ser† por WebService, ou conex∆o de Bancos SQL */
ASSIGN lUtilizaWS = NO.
FIND FIRST ponto-programa NO-LOCK
    WHERE  ponto-programa.nome-programa = "escrm001api"
    AND    ponto-programa.ponto         = 1 NO-ERROR.
IF  AVAIL  ponto-programa THEN DO:
    FIND FIRST conteudo-programa NO-LOCK
        WHERE  conteudo-programa.cod-programa = ponto-programa.cod-programa
        AND    conteudo-programa.sequencia    = 1 NO-ERROR.
    IF  AVAIL  conteudo-programa THEN
        ASSIGN lUtilizaWS = (ENTRY(1,conteudo-programa.conteudo,",") = "yes":U).
END.



PROCEDURE piConnection:
    ASSIGN i-cont-chamadas = 0.

    IF  lUtilizaWS THEN DO:
        CREATE SERVER hWebService.
        hWebService:CONNECT("-WSDL '":U + c-url-ws-crm + "'":U) NO-ERROR.

        IF  ERROR-STATUS:ERROR THEN DO:
            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence     = 1
                   RowErrors.errornumber       = 1
                   RowErrors.errordescription  = "Erro de integraá∆o do ERP com CRM - WebService n∆o foi conectado":U
                   RowErrors.errorparameters   = "Custom":U
                   RowErrors.errortype         = "Error":U
                   RowErrors.errorhelp         = "Erro na conex∆o do WebService de Integraá∆o"
                   RowErrors.errorsubtype      = "Custom":U.
            
            put SKIP 

                    "**** Erro Conex∆o Integracao EMS X CRM****" SKIP
                    "URL " c-url-ws-crm FORMAT "x(200)" SKIP
                    "WebService Conectado? " IF VALID-HANDLE(hWebService) THEN STRING(hWebService:CONNECTED()) ELSE "Handle inv†lido. N∆o conectado." SKIP
                    "Serviáo Valido? " VALID-HANDLE(hService) SKIP.
        
            RETURN "NOK":U.
        END.

        IF  hWebService:CONNECTED() THEN
            RUN ERPServiceSoap SET hService ON SERVER hWebService.

        IF  l-log THEN
            put SKIP 

                    "**** Conex∆o ****" SKIP
                    "URL " c-url-ws-crm FORMAT "x(200)"  SKIP
                    "WebService Conectado? " IF VALID-HANDLE(hWebService) THEN STRING(hWebService:CONNECTED()) ELSE "Handle inv†lido. N∆o conectado." SKIP
                    "Serviáo Valido? " VALID-HANDLE(hService) SKIP.
    END.
    ELSE DO:
        /* -------- ABRE CONEX«O COM O SQL SERVER ----------------*/
        CREATE "ADODB.Connection" ObjConnection. /* Create the connection object for the link to SQL */
        CREATE "ADODB.RecordSet"  ObjRecordSet.  /* Create a recordset object ready to return the data */
        CREATE "ADODB.Command"    ObjCommand.    /* Create a command object for sending the SQL statement */
    
        ASSIGN ODBC-DSN    = '{&pDns}'
               ODBC-SERVER = c-base-crm    /* '{&pServer}' */
               ODBC-USERID = '{&pUserId}'
               ODBC-PASSWD = '{&pPass}'.
                     
        /* Conex∆o sem ODBC */
        ObjConnection:OPEN("Provider=SQLOLEDB.1;Persist Security Info=True;Initial Catalog=":U + ODBC-DSN + ";Data Source=":U + ODBC-SERVER, ODBC-USERID, ODBC-PASSWD, 0).
      
        ASSIGN ObjCommand:ActiveConnection  = ObjConnection
               ObjCommand:CommandType       = 1 /* adCmdText */
               ObjConnection:CursorLocation = 3 /* adUseClient */
               ObjRecordSet:CursorType      = 3 /* adOpenStatic */.
    END.
END PROCEDURE.

PROCEDURE piCloseConnection:
    ASSIGN i-cont-chamadas = 0.

    IF  lUtilizaWS THEN DO:
        IF  VALID-HANDLE(hService) THEN
            DELETE OBJECT hService.

        IF  VALID-HANDLE(hWebService) THEN DO:
            IF  hWebService:CONNECTED() THEN
                hWebService:DISCONNECT().
    
            DELETE OBJECT hWebService.
        END.

        IF  l-log THEN
            put "**** Encerra Conex∆o ****" SKIP
                    "WebService Conectado? " IF VALID-HANDLE(hWebService) THEN hWebService:CONNECTED() ELSE NO SKIP
                    "Serviáo Valido? " VALID-HANDLE(hService) SKIP.
    END.
    ELSE DO:
        ObjConnection:CLOSE NO-ERROR.
    
        RELEASE OBJECT ObjConnection NO-ERROR.
        RELEASE OBJECT ObjCommand    NO-ERROR.
        RELEASE OBJECT ObjRecordSet  NO-ERROR.
        
        ASSIGN ObjConnection = ?
               ObjCommand    = ?
               ObjRecordSet  = ?.
    END.
END PROCEDURE.

PROCEDURE InsertIntegrationLog:
    DEFINE INPUT  PARAMETER pOrigin    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER pEntity    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER pAction    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER pStatus    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER pTempTable AS HANDLE        NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-atributo.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE cXML     AS LONGCHAR    NO-UNDO.
    DEFINE VARIABLE cRetorno AS CHARACTER   NO-UNDO.

    ASSIGN i-cont-chamadas = i-cont-chamadas + 1.
         
    RUN createXML (INPUT  pTempTable,
                   INPUT  pEntity,
                   INPUT  TABLE tt-atributo,
                   OUTPUT cXML).

    /*IF '{&ativar-envio}' = 'no' THEN
        RETURN "OK":U.*/

    IF  l-log THEN
        put "Utiliza o WebService do CRM? " lUtilizaWS SKIP.

    IF l-log THEN DO:

        define variable hDoc    as handle   no-undo.
        create x-document hDoc.
        
        hDoc:LOAD("longchar", cXML, NO).
        hDoc:SAVE("file","C:/temp/" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").

        MESSAGE "Gravou arquivo " "C:/temp/" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        
        IF  VALID-HANDLE(hDoc) THEN
            DELETE OBJECT hDoc.


    END.

    
    IF  lUtilizaWS THEN DO:
        IF  l-log THEN
            PUT i-cont-chamadas " - WebService dispon°vel? " VALID-HANDLE(hService) " - Conectado? " IF VALID-HANDLE(hWebService) THEN STRING(hWebService:CONNECTED()) ELSE "Handle inv†lido. N∆o conectado.".

        IF  VALID-HANDLE(hService) THEN DO:
            RUN InsertIntoIntegrationLog IN hService (INPUT  "Intelbras"   /* OrganizationName */,
                                                      INPUT  pOrigin       /* Origin           */,
                                                      INPUT  pEntity       /* Entity           */,
                                                      INPUT  pAction       /* Action           */,
                                                      INPUT  cXML          /* Message          */,
                                                      INPUT  NOW           /* MessageDate      */,
                                                      INPUT  pStatus       /* Status           */,
                                                      OUTPUT cRetorno).
        END.
        ELSE DO:
            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence     = 1
                   RowErrors.errornumber       = 1
                   RowErrors.errordescription  = "Erro de integraá∆o do ERP com CRM - WebService n∆o est† dipon°vel":U
                   RowErrors.errorparameters   = "Custom":U
                   RowErrors.errortype         = "Error":U
                   RowErrors.errorhelp         = "Tabela: " + pEntity + " - N∆o foi integrado.":U + CHR(10) + cXML
                   RowErrors.errorsubtype      = "Custom":U.


            RETURN "NOK":U.
        END.

    END.
    ELSE DO:
        IF VALID-HANDLE(ObjCommand) THEN DO:
            ASSIGN ObjCommand:CommandText = "INSERT INTO integrationLog (OrganizationName, Origin, Entity, Action, Message, MessageDate, Status) VALUES(":U +
                                            "'":U + "Intelbras":U + "',":U +
                                            "'":U + pOrigin       + "',":U +
                                            "'":U + pEntity       + "',":U +
                                            "'":U + pAction       + "',":U +
                                            "'":U + cXML          + "',":U +
                                                    "getdate()":U + ",":U  +
                                                    pStatus       + ")":U.
             
            IF ERROR-STATUS:ERROR AND
               ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
                CREATE RowErrors.
                ASSIGN RowErrors.errorsequence     = 1
                       RowErrors.errornumber       = 1
                       RowErrors.errordescription  = "Erro de integraá∆o do ERP com CRM - Inserá∆o/Atualizaá∆o de dados":U + ERROR-STATUS:GET-MESSAGE(1)
                       RowErrors.errorparameters   = "Custom"
                       RowErrors.errortype         = "Error"
                       RowErrors.errorhelp         = "Tabela: " + pEntity + " - N∆o foi integrado." + CHR(10) + cXML
                       RowErrors.errorsubtype      = "Custom".
                RETURN "NOK":U.
            END.
        
            ObjCommand:EXECUTE(OUTPUT ODBC-NULL, "", 32).
    
            IF ERROR-STATUS:ERROR AND
               ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
                CREATE RowErrors.
                ASSIGN RowErrors.errorsequence     = 1
                       RowErrors.errornumber       = 1
                       RowErrors.errordescription  = "Erro de integraá∆o do ERP com CRM - Inserá∆o/Atualizaá∆o de dados":U + ERROR-STATUS:GET-MESSAGE(1)
                       RowErrors.errorparameters   = "Custom"
                       RowErrors.errortype         = "Error"
                       RowErrors.errorhelp         = "Tabela: " + pEntity + " - N∆o foi integrado." + CHR(10) + cXML
                       RowErrors.errorsubtype      = "Custom".
                RETURN "NOK":U.
            END.
        END.
        ELSE DO:
            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence     = 1
                   RowErrors.errornumber       = 1
                   RowErrors.errordescription  = "Erro de integraá∆o do ERP com CRM - Conex∆o":U + ERROR-STATUS:GET-MESSAGE(1)
                   RowErrors.errorparameters   = "Custom":U
                   RowErrors.errortype         = "Error":U
                   RowErrors.errorhelp         = "Tabela: " + pEntity + " - N∆o foi integrado.":U + CHR(10) + cXML
                   RowErrors.errorsubtype      = "Custom":U.
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE UpdateIntegrationLogStatus:
    DEFINE INPUT  PARAMETER pLogId     AS INTEGER       NO-UNDO.
    DEFINE INPUT  PARAMETER pStatus    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER pResultado AS CHARACTER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i AS INTEGER     NO-UNDO.

    ASSIGN ERROR-STATUS:ERROR = NO.

    IF VALID-HANDLE(ObjCommand) THEN DO:
        ASSIGN ObjCommand:CommandText = "UPDATE integrationLog SET Status=":U + pStatus + ", Result='":U + pResultado + "', ProcessingDate=getdate() WHERE LogId=":U + STRING(pLogId).
    
        IF ERROR-STATUS:ERROR AND
           ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
            IF ERROR-STATUS:GET-NUMBER(i) = 565 THEN NEXT.

            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence     = 1
                   RowErrors.errornumber       = 1
                   RowErrors.errordescription  = "Erro de integraá∆o do ERP com CRM - Atualizaá∆o Status":U
                   RowErrors.errorparameters   = "Custom"
                   RowErrors.errortype         = "Error"
                   RowErrors.errorhelp         = "LogId: ":U + STRING(pLogId) + " - N∆o atualizado status.":U
                   RowErrors.errorsubtype      = "Custom".
            RETURN "NOK":U.
        END.
    
        ObjCommand:EXECUTE(OUTPUT ODBC-NULL, "", 32).

        IF ERROR-STATUS:ERROR AND
           ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
            IF ERROR-STATUS:GET-NUMBER(i) = 565 THEN NEXT.
            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence     = 2
                   RowErrors.errornumber       = 1
                   RowErrors.errordescription  = "Erro de integraá∆o do ERP com CRM - Atualizaá∆o Status":U
                   RowErrors.errorparameters   = "Custom"
                   RowErrors.errortype         = "Error"
                   RowErrors.errorhelp         = "LogId: ":U + STRING(pLogId) + " - N∆o atualizado status.":U
                   RowErrors.errorsubtype      = "Custom".
            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        CREATE RowErrors.
        ASSIGN RowErrors.errorsequence     = 3
               RowErrors.errornumber       = 1
               RowErrors.errordescription  = "Erro de integraá∆o do ERP com CRM - Conex∆o":U
               RowErrors.errorparameters   = "Custom":U
               RowErrors.errortype         = "Error":U
               RowErrors.errorhelp         = "LogId: ":U + STRING(pLogId) + " - N∆o atualizado status.":U
               RowErrors.errorsubtype      = "Custom":U.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE SelectIntegrationLog:
    DEFINE INPUT  PARAMETER pEntity AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pOrigin AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pStatus AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pLogId  AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-integrationLogAux.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.

    EMPTY TEMP-TABLE tt-integrationLogAux.

    IF VALID-HANDLE(ObjCommand) THEN DO:
        ASSIGN ODBC-CURSOR = 0
               l-ok        = YES.
    
        ASSIGN ObjCommand:CommandText = "SELECT TOP 1 * FROM integrationLog ":U +
                                                       "WHERE integrationLog.Entity = '":U + pEntity + "' ":U +
                                                       "  AND integrationLog.Origin = '":U + pOrigin + "' ":U +
                                                       "  AND integrationLog.Status =  ":U + pStatus + "  ":U +
                                                       "  and integrationLog.LogId  >  ":U + pLogId  + "  ":U +
                                                       "  ORDER BY integrationLog.LogId":U.

        IF ERROR-STATUS:ERROR AND
           ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
            DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
                IF ERROR-STATUS:GET-NUMBER(i) = 565 THEN NEXT.

                CREATE RowErrors.
                ASSIGN RowErrors.errorsequence     = 1
                       RowErrors.errornumber       = 1
                       RowErrors.errordescription  = "Erro na seleá∆o do 'integrationLog' no CRM - Seleá∆o":U
                       RowErrors.errorparameters   = "Custom":U
                       RowErrors.errortype         = "Error":U
                       RowErrors.errorhelp         = "Tabela: ":U + pEntity + " - Origem: ":U + pOrigin + " - (":U + STRING(ERROR-STATUS:GET-NUMBER(i)) + ") ":U + ERROR-STATUS:GET-MESSAGE(i)
                       RowErrors.errorsubtype      = "Custom":U
                       l-ok                        = NO.
            END.

            IF NOT l-ok THEN
                RETURN "NOK":U.
        END.

        ObjCommand:CommandTimeOut = 0. /* adCmdText */
        ObjRecordSet              = ObjCommand:EXECUTE(OUTPUT ODBC-NULL, "", 32).
        ODBC-RECCOUNT             = ObjRecordSet:RecordCount.

        IF ERROR-STATUS:ERROR AND
           ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
            DO i = 1 TO ERROR-STATUS:NUM-MESSAGES:
                IF ERROR-STATUS:GET-NUMBER(i) = 565 THEN NEXT.

                CREATE RowErrors.
                ASSIGN RowErrors.errorsequence     = 2
                       RowErrors.errornumber       = 1
                       RowErrors.errordescription  = "Erro na seleá∆o do 'integrationLog' no CRM - Seleá∆o":U
                       RowErrors.errorparameters   = "Custom":U
                       RowErrors.errortype         = "Error":U
                       RowErrors.errorhelp         = "Tabela: ":U + pEntity + " - Origem: ":U + pOrigin + " - Status: ":U + pStatus + CHR(10) + "(":U + STRING(ERROR-STATUS:GET-NUMBER(i)) + ") ":U + ERROR-STATUS:GET-MESSAGE(i)
                       RowErrors.errorsubtype      = "Custom":U
                       l-ok                        = NO.
            END.

            IF NOT l-ok THEN
                RETURN "NOK":U.
        END.
    
        IF ODBC-RECCOUNT  > 0 AND
           ODBC-RECCOUNT <> ? THEN DO:
            ObjRecordSet:MoveFirst NO-ERROR.

            DO WHILE ODBC-CURSOR < ODBC-RECCOUNT:
                CREATE tt-integrationLogAux.
                ASSIGN tt-integrationLogAux.Origin         = ObjRecordSet:FIELDS("Origin"):VALUE
                       tt-integrationLogAux.entity         = ObjRecordSet:FIELDS("Entity"):VALUE
                       tt-integrationLogAux.action         = ObjRecordSet:FIELDS("Action"):VALUE
                       tt-integrationLogAux.cMESSAGE       = ObjRecordSet:FIELDS("Message"):VALUE
                       tt-integrationLogAux.messageDate    = ObjRecordSet:FIELDS("MessageDate"):VALUE
                       tt-integrationLogAux.cSTATUS        = ObjRecordSet:FIELDS("Status"):VALUE
                       tt-integrationLogAux.processingDate = ObjRecordSet:FIELDS("ProcessingDate"):VALUE
                       tt-integrationLogAux.cRESULT        = ObjRecordSet:FIELDS("Result"):VALUE
                       tt-integrationLogAux.LogId          = ObjRecordSet:FIELDS("LogId"):VALUE
                       ODBC-CURSOR                         = ODBC-CURSOR + 1.
                ObjRecordSet:MoveNext NO-ERROR.
            END.
        END.
        ELSE
            RETURN "NOK":U.

    END.
    ELSE DO:
        CREATE RowErrors.
        ASSIGN RowErrors.errorsequence     = 1
               RowErrors.errornumber       = 1
               RowErrors.errordescription  = "Erro na seleá∆o do 'integrationLog' no CRM - Conex∆o":U
               RowErrors.errorparameters   = "Custom":U
               RowErrors.errortype         = "Error":U
               RowErrors.errorhelp         = "Tabela: ":U + pEntity + " - Origem: ":U + pOrigin + " - Status: ":U + pStatus
               RowErrors.errorsubtype      = "Custom":U.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE CountIntegrationLog:
    DEFINE INPUT  PARAMETER pEntity AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER pStatus AS CHARACTER     NO-UNDO.
    DEFINE OUTPUT PARAMETER pCount  AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF VALID-HANDLE(ObjCommand) THEN DO:
        ASSIGN ODBC-CURSOR = 0.

        ASSIGN ObjCommand:CommandText = "SELECT COUNT(*) iContador FROM integrationLog WHERE integrationLog.Entity = ":U + pEntity + " AND integrationLog.Status = ":U + pStatus.

        IF ERROR-STATUS:ERROR THEN DO:
            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence     = 1
                   RowErrors.errornumber       = 1
                   RowErrors.errordescription  = "Erro de contagem do 'integrationLog' do CRM - Seleá∆o":U
                   RowErrors.errorparameters   = "Custom":U
                   RowErrors.errortype         = "Error":U
                   RowErrors.errorhelp         = "Tabela: " + pEntity + " - Status: ":U + pStatus
                   RowErrors.errorsubtype      = "Custom":U.
            RETURN "NOK":U.
        END.

        ObjRecordSet  = ObjCommand:EXECUTE(OUTPUT ODBC-NULL, "", 32).
        ODBC-RECCOUNT = ObjRecordSet:RecordCount.

        IF ERROR-STATUS:ERROR THEN DO:
            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence     = 1
                   RowErrors.errornumber       = 1
                   RowErrors.errordescription  = "Erro de contagem do 'integrationLog' do CRM - Seleá∆o":U
                   RowErrors.errorparameters   = "Custom":U
                   RowErrors.errortype         = "Error":U
                   RowErrors.errorhelp         = "Tabela: " + pEntity + " - Status: ":U + pStatus
                   RowErrors.errorsubtype      = "Custom":U.
            RETURN "NOK":U.
        END.

        IF (ODBC-RECCOUNT > 0)      AND
            NOT (ODBC-RECCOUNT = ?) THEN DO:
            ObjRecordSet:MoveFirst NO-ERROR.
                
            DO WHILE ODBC-CURSOR < ODBC-RECCOUNT:
                ASSIGN pCount      = ObjRecordSet:FIELDS("iContador":U):VALUE
                       ODBC-CURSOR = ODBC-CURSOR + 1.

                ObjRecordSet:MoveNext NO-ERROR.
            END.
        END.
    END.
    ELSE DO:
        CREATE RowErrors.
        ASSIGN RowErrors.errorsequence     = 1
               RowErrors.errornumber       = 1
               RowErrors.errordescription  = "Erro de contagem do 'integrationLog' do CRM - Conex∆o":U
               RowErrors.errorparameters   = "Custom":U
               RowErrors.errortype         = "Error":U
               RowErrors.errorhelp         = "Tabela: " + pEntity + " - Status: ":U + pStatus
               RowErrors.errorsubtype      = "Custom":U.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE DeleteIntegrationLog:
    DEFINE INPUT  PARAMETER pEntity AS CHARACTER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF VALID-HANDLE(ObjCommand) THEN DO:
        ASSIGN ObjCommand:CommandText = "DELETE FROM integrationLog WHERE integrationLog.Entity = '":U + pEntity  + "'":U.
    
        IF ERROR-STATUS:ERROR THEN DO:            
            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence     = 1
                   RowErrors.errornumber       = 1
                   RowErrors.errordescription  = "Erro de exclus∆o do 'integrationLog' do CRM - Exclus∆o":U
                   RowErrors.errorparameters   = "Custom":U
                   RowErrors.errortype         = "Error":U
                   RowErrors.errorhelp         = "Tabela: " + pEntity
                   RowErrors.errorsubtype      = "Custom":U.
            RETURN "NOK":U.
        END.
    
        ObjCommand:CommandTimeOut = 0.
        ObjRecordSet              = ObjCommand:EXECUTE(OUTPUT ODBC-NULL, "":U, 32).

        IF ERROR-STATUS:ERROR THEN DO:            
            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence     = 1
                   RowErrors.errornumber       = 1
                   RowErrors.errordescription  = "Erro de exclus∆o do 'integrationLog' do CRM - Exclus∆o":U
                   RowErrors.errorparameters   = "Custom":U
                   RowErrors.errortype         = "Error":U
                   RowErrors.errorhelp         = "Tabela: " + pEntity
                   RowErrors.errorsubtype      = "Custom":U.
            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        CREATE RowErrors.
        ASSIGN RowErrors.errorsequence     = 1
               RowErrors.errornumber       = 1
               RowErrors.errordescription  = "Erro de exclus∆o do 'integrationLog' do CRM - Conex∆o":U
               RowErrors.errorparameters   = "Custom":U
               RowErrors.errortype         = "Error":U
               RowErrors.errorhelp         = "Tabela: " + pEntity
               RowErrors.errorsubtype      = "Custom":U.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE ReadIntegrationLogFromCRM:
    DEFINE INPUT PARAMETER pEntity AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-integrationLog.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE cLogId AS CHARACTER INITIAL "0"   NO-UNDO.

    EMPTY TEMP-TABLE tt-integrationLog.    

    REPEAT:
        RUN SelectIntegrationLog (INPUT  pEntity,
                                  INPUT  "fromCRM":U,
                                  INPUT  "0":U,
                                  INPUT  cLogId,
                                  OUTPUT TABLE tt-integrationLogAux,
                                  OUTPUT TABLE RowErrors).

        IF RETURN-VALUE = "NOK":U THEN LEAVE.

        FIND FIRST tt-integrationLogAux NO-ERROR.
        IF NOT AVAILABLE tt-integrationLogAux THEN LEAVE.

        FIND FIRST tt-integrationLog
            WHERE tt-integrationLog.logId = tt-integrationLogAux.logId NO-LOCK NO-ERROR.

        IF AVAILABLE tt-integrationLog THEN LEAVE.

        FOR EACH tt-integrationLogAux:
            CREATE tt-integrationLog.
            BUFFER-COPY tt-integrationLogAux TO tt-integrationLog.

            ASSIGN cLogId = STRING(tt-integrationLog.logId).
            ASSIGN tt-integrationLog.cStatus = "4":U.

            RUN UpdateIntegrationLogStatus (INPUT  tt-integrationLog.logId,
                                            INPUT  "4":U,
                                            INPUT  "Processando...":U,
                                            OUTPUT TABLE RowErrors).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE createXML:
    DEFINE INPUT  PARAMETER pTempTable AS HANDLE      NO-UNDO.
    DEFINE INPUT  PARAMETER pEntidade  AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-atributo.
    DEFINE OUTPUT PARAMETER pXML       AS LONGCHAR    NO-UNDO.

    DEFINE VARIABLE hQuery AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hField AS HANDLE      NO-UNDO.

    DEFINE VARIABLE cBufferValue AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i            AS INTEGER     NO-UNDO.

    DEFINE VARIABLE hXml     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hRoot    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE xmlParam AS HANDLE      NO-UNDO.
    DEFINE VARIABLE xmlText  AS HANDLE      NO-UNDO.

    CREATE X-DOCUMENT hXml.
    CREATE X-NODEREF  hRoot.
    CREATE X-NODEREF  xmlParam.
    CREATE X-NODEREF  xmlText.

    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(pTempTable).
    hQuery:QUERY-PREPARE("FOR EACH ":U + pTempTable:NAME + " EXCLUSIVE-LOCK":U).
    hQuery:QUERY-OPEN.

    DO TRANSACTION ON ERROR UNDO, LEAVE:
        hQuery:GET-FIRST.

        hXml:CREATE-NODE(hRoot, pEntidade, "ELEMENT":U).
        hXml:APPEND-CHILD(hRoot).

        /** Percorre a temp-table **/
        DO WHILE NOT hQuery:QUERY-OFF-END:

            DO i = 1 TO pTempTable:NUM-FIELDS:
                ASSIGN hField       = pTempTable:BUFFER-FIELD(i)
                       cBufferValue = "":U.

                /** Ignora esse campo **/
                IF hField:DATA-TYPE = "rowid":U THEN NEXT.

                IF l-log THEN
                    PUT "gravando xml " TRIM(STRING(REPLACE(hField:BUFFER-VALUE, CHR(13), CHR(32)))) SKIP.

                IF hField:DATA-TYPE = "character":U THEN DO:
                    IF hField:BUFFER-VALUE <> ? THEN
                        ASSIGN cBufferValue = TRIM(STRING(REPLACE(hField:BUFFER-VALUE, CHR(13), CHR(32))))
                               cBufferValue = TRIM(STRING(REPLACE(cBufferValue, CHR(10), CHR(32))))
                               cBufferValue = TRIM(STRING(REPLACE(cBufferValue, "'":U, "`":U))).
                END.
                ELSE DO:
                    IF hField:DATA-TYPE = "decimal" THEN DO:
                        IF hField:BUFFER-VALUE <> ? THEN
                            ASSIGN cBufferValue = TRIM(STRING(hField:BUFFER-VALUE, hField:FORMAT)).
                    END.
                    ELSE DO:
                        ASSIGN cBufferValue = TRIM(STRING(hField:BUFFER-VALUE)).
    
                        IF hField:DATA-TYPE = "date":U THEN DO:
                            IF hField:BUFFER-VALUE <> ? THEN DO:
                                IF hField:BUFFER-VALUE <= 01/01/1900 THEN
                                    ASSIGN cBufferValue = "1900-01-01":U.
                                ELSE DO:
                                    IF hField:BUFFER-VALUE >= 12/31/2999 THEN
                                        ASSIGN cBufferValue = "2999-12-31":U.
                                    ELSE
                                        ASSIGN cBufferValue = STRING(YEAR(hField:BUFFER-VALUE), "9999":U) + "-":U + STRING(MONTH(hField:BUFFER-VALUE), "99":U) + "-":U + STRING(DAY(hField:BUFFER-VALUE), "99":U).
                                END.
                            END.
                        END.
    
                        IF hField:DATA-TYPE = "logical":U THEN DO:
                            IF hField:BUFFER-VALUE = ?  OR
                               hField:BUFFER-VALUE = NO THEN
                                ASSIGN cBufferValue = "0":U.
                            ELSE
                                ASSIGN cBufferValue = "1":U.
                        END.
                    END.

                    IF hField:DATA-TYPE = "decimal":U OR
                       hField:DATA-TYPE = "integer":U THEN
                        ASSIGN cBufferValue = REPLACE(cBufferValue, ".":U, "":U)
                               cBufferValue = REPLACE(cBufferValue, ",":U, ".":U).
                END.

                hXml:CREATE-NODE(xmlParam, hField:NAME, "ELEMENT":U).

                IF hField:DATA-TYPE = "character":U OR
                   hField:DATA-TYPE = "date":U      THEN
                    hXml:CREATE-NODE(xmlText, ?, "CDATA-SECTION":U).
                ELSE
                    hXml:CREATE-NODE(xmlText, ?, "TEXT":U).

                xmlText:NODE-VALUE = cBufferValue NO-ERROR.
                xmlParam:APPEND-CHILD(xmlText).

                FOR EACH tt-atributo
                    WHERE tt-atributo.r-temp-table = pTempTable:ROWID
                      AND tt-atributo.nome-campo   = hField:NAME:
                    xmlParam:SET-ATTRIBUTE(tt-atributo.nome-atrib, tt-atributo.vl-atrib).
                END.

                hRoot:APPEND-CHILD(xmlParam).
            END.

            hQuery:GET-NEXT.

        END.
    END.

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.

    hXml:SAVE("LONGCHAR":U, pXML).

    DELETE OBJECT xmlText.
    DELETE OBJECT xmlParam.
    DELETE OBJECT hRoot.
    DELETE OBJECT hXml.

    EMPTY TEMP-TABLE tt-atributo.

    /* apenas para acompanhar a geracao do XML */
    
/*     IF '{&ativar-log}' = 'yes' THEN DO:                  */
/*         OUTPUT TO VALUE("C:/temp/log-xml.txt":U) APPEND. */
/*         PUT UNFORMATTED STRING(pXML) SKIP.               */
/*         OUTPUT CLOSE.                                    */
/*     END.                                                 */
    
           
     
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE readXML:
    DEFINE INPUT  PARAMETER pTempTable AS HANDLE      NO-UNDO.
    DEFINE INPUT  PARAMETER pXML       AS LONGCHAR    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-atributo-entrada.

    DEFINE VARIABLE l-ok    AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE hXML    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hRoot   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hTags   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hValor  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE hField  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE j       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE k       AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE tt-atributo-entrada.

    CREATE X-DOCUMENT hXML.
    CREATE X-NODEREF  hRoot.

    hXML:LOAD("LONGCHAR":U, pXML, FALSE).
    hXML:GET-DOCUMENT-ELEMENT(hRoot).

    CREATE X-NODEREF hTags.
    CREATE X-NODEREF hValor.

    REPEAT i = 1 TO hRoot:NUM-CHILDREN:
        l-ok = hRoot:GET-CHILD(hTags, i).

        IF NOT l-ok THEN LEAVE.

        IF hTags:SUBTYPE <> "element":U THEN NEXT.

        DO j = 1 TO pTempTable:NUM-FIELDS:
            IF pTempTable:BUFFER-FIELD(j):NAME = hTags:NAME AND
               hTags:NUM-CHILDREN > 0                       AND
               hTags:GET-CHILD(hValor, 1)                   THEN DO:
                CASE pTempTable:BUFFER-FIELD(j):DATA-TYPE:
                    WHEN "date":U THEN DO:
                        CASE SESSION:DATE-FORMAT:
                            WHEN "dmy":U THEN DO:
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN DATE(ENTRY(3, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(2, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(1, hValor:NODE-VALUE, "-":U)) ELSE ?.
                            END.
                            WHEN "mdy":U THEN DO:
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN DATE(ENTRY(2, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(3, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(1, hValor:NODE-VALUE, "-":U)) ELSE ?.
                            END.
                            WHEN "ymd":U THEN DO:
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN DATE(ENTRY(1, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(2, hValor:NODE-VALUE, "-":U) + "/":U + ENTRY(3, hValor:NODE-VALUE, "-":U)) ELSE ?.
                            END.
                        END CASE.
                    END.
                    WHEN "integer" THEN DO:
                        ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN INTEGER(hValor:NODE-VALUE) ELSE ?.
                    END.
                    WHEN "decimal" THEN DO:
                                
                        if index(hValor:NODE-VALUE,".") > 0
                        then do:                                                      
                           assign d-valor-dec = int(substring(hValor:NODE-VALUE, 1, r-index(hValor:NODE-VALUE,".") - 1))                           
                                  c-valor-dec = "0," + string((substring(hValor:NODE-VALUE, r-index(hValor:NODE-VALUE,".") + 1, 5))). 
                                
                           ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN decimal(d-valor-dec + dec(c-valor-dec)) ELSE ?.
                        end.
                        else if hValor:NODE-VALUE <> "":U then
                          ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = decimal(hValor:NODE-VALUE).                        
                        else 
                          ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = ?.                        

                    END.
                    WHEN "logical" THEN DO:                         
                        CASE hValor:NODE-VALUE:
                            WHEN "1":U    OR
                            WHEN "TRUE":U OR
                            WHEN "T":U    OR
                            WHEN "YES":U  OR
                            WHEN "Y":U    OR
                            WHEN "Sim":U  OR
                            WHEN "S":U    THEN
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = YES.
                            WHEN "0":U     OR
                            WHEN "FALSE":U OR
                            WHEN "F":U     OR
                            WHEN "NO":U    OR
                            WHEN "N":U     OR
                            WHEN "N∆o":U   OR
                            WHEN "Nao":U   THEN
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = NO.
                            OTHERWISE DO:
                                ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = LOGICAL(TRIM(pTempTable:BUFFER-FIELD(j):INITIAL)).
                            END.
                        END CASE.
                    END.
                    WHEN "character" THEN DO:                       
                        
                        ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = STRING(hValor:NODE-VALUE).                     
                         
                    END.
                    OTHERWISE DO:
                        ASSIGN pTempTable:BUFFER-FIELD(j):BUFFER-VALUE = IF hValor:NODE-VALUE <> "":U THEN hValor:NODE-VALUE ELSE ?.
                    END.
                END CASE.                
            END.
        END.

        REPEAT j = 1 TO NUM-ENTRIES(hTags:ATTRIBUTE-NAMES):
            CREATE tt-atributo-entrada.
            ASSIGN tt-atributo-entrada.tipo     = "atributo":U
                   tt-atributo-entrada.nome     = ENTRY(j, hTags:ATTRIBUTE-NAMES)
                   tt-atributo-entrada.nome-pai = hTags:NAME
                   tt-atributo-entrada.valor    = hTags:GET-ATTRIBUTE(ENTRY(j, hTags:ATTRIBUTE-NAMES)).
        END.
    END.

    DELETE OBJECT hXML.
    DELETE OBJECT hRoot.
    DELETE OBJECT hTags.
    DELETE OBJECT hValor.
END PROCEDURE.

PROCEDURE piCarregaCanalVenda:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH canal-venda NO-LOCK:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Canal Venda: ":U + STRING(canal-venda.cod-canal-venda)).
          
        empty temp-table tt-canal-venda-atu.
        create tt-canal-venda-atu.
        buffer-copy canal-venda to tt-canal-venda-atu.
         
        {esp/crm/escrm001a.i "Canal-Venda"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-canal-venda:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-canal-venda.
        empty temp-table tt-canal-venda-atu.
        
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaCondPagto:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH cond-pagto NO-LOCK:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Cond Pagto: ":U + STRING(cond-pagto.cod-cond-pag)).
         
        empty temp-table tt-cond-pagto-atu.
        create tt-cond-pagto-atu.
        buffer-copy cond-pagto to tt-cond-pagto-atu.
         
        {esp/crm/escrm001a.i "Cond-Pagto"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-cond-pagto:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-cond-pagto.
        EMPTY TEMP-TABLE tt-cond-pagto-atu.
        
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaGrupoCliente:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH gr-cli NO-LOCK:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Grupo Cliente: ":U + STRING(gr-cli.cod-gr-cli)).

        empty temp-table tt-gr-cli-atu.
        create tt-gr-cli-atu.
        buffer-copy gr-cli to tt-gr-cli-atu.
         
        {esp/crm/escrm001a.i "Gr-Cli"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-gr-cli:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-gr-cli.
        EMPTY TEMP-TABLE tt-gr-cli-atu.
        
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaPortador:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH mgcad.portador NO-LOCK:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Portador: ":U + STRING(mgcad.portador.cod-portador)).
          
        empty temp-table tt-portador-atu.
        create tt-portador-atu.
        buffer-copy mgcad.portador to tt-portador-atu.
         
        {esp/crm/escrm001a.i "Portador"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-portador:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-portador.
        empty temp-table tt-portador-atu.
        
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaReceitaPadrao:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH tipo-rec-desp NO-LOCK:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Receita Padr∆o: ":U + STRING(tipo-rec-desp.tp-codigo)).
                
        empty temp-table tt-receita-padrao-atu.
        create tt-receita-padrao-atu.
        buffer-copy tipo-rec-desp to tt-receita-padrao-atu.
         
        {esp/crm/escrm001a.i "Receita-Padrao"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-receita-padrao:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-receita-padrao.
        empty temp-table tt-receita-padrao-atu.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaRepresentante:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH repres NO-LOCK:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Representante: ":U + STRING(repres.cod-rep)).
       
        empty temp-table tt-repres-atu.
        create tt-repres-atu.
        buffer-copy repres to tt-repres-atu.
         
        {esp/crm/escrm001a.i "Repres"}       

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-repres:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-repres.
        empty temp-table tt-repres-atu.        
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaTransportadora:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH transporte NO-LOCK:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Transporte: ":U + STRING(transporte.cod-transp)).
           
        empty temp-table tt-transporte-atu.
        create tt-transporte-atu.
        buffer-copy transporte to tt-transporte-atu.
        
        {esp/crm/escrm001a.i "Transporte"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-transportadora:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-transportadora.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaFamiliaMaterial:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH familia NO-LOCK:
        
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Fam°lia Material: ":U + STRING(familia.fm-codigo)).
        
        empty temp-table tt-familia-material-atu.
        create tt-familia-material-atu.
        buffer-copy familia to tt-familia-material-atu.
        
        {esp/crm/escrm001a.i "Familia"}
        
        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-familia-material:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-familia-material.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaFamiliaComercial:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.


    FOR EACH fam-comerc NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Fam°lia Comercial: ":U + STRING(fam-comerc.fm-cod-com)).
        
        empty temp-table tt-familia-comercial-atu.
        create tt-familia-comercial-atu.
        buffer-copy fam-comerc to tt-familia-comercial-atu.
        
        {esp/crm/escrm001a.i "Fam-comerc"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-familia-comercial:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-familia-comercial.
    END.

    FOR EACH fam-com-item NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "Estrutura Fam°lia Comercial: ":U + STRING(fam-com-item.fm-cod-com)).
           IF fam-com-item.segmento = "" THEN DO:
               empty temp-table tt-new_unidade_familia-atu.
                create tt-new_unidade_familia-atu.
                ASSIGN tt-new_unidade_familia-atu.codigo      = fam-com-item.unidade
                       tt-new_unidade_familia-atu.descricao   = fam-com-item.descricao.
                ASSIGN pEntidade = "new_unidade_familia".
                {esp/crm/escrm001a.i "new_unidade_familia"}
        
                RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                          INPUT  pEntidade,
                                          INPUT  "W":U,
                                          INPUT  "0":U,
                                          INPUT  BUFFER tt-new_unidade_familia:HANDLE,
                                          INPUT  TABLE tt-atributo,
                                          OUTPUT TABLE RowErrors).
        
                EMPTY TEMP-TABLE tt-new_unidade_familia.
           END.
           ELSE
           IF fam-com-item.familia1 = "" THEN DO:
               empty temp-table tt-new_segmento-atu.
                create tt-new_segmento-atu.
                ASSIGN tt-new_segmento-atu.unidade      = fam-com-item.unidade
                       tt-new_segmento-atu.codigo       = fam-com-item.unidade + fam-com-item.segmento
                       tt-new_segmento-atu.descricao    = fam-com-item.descricao.

                ASSIGN pEntidade = "new_segmento".
                {esp/crm/escrm001a.i "new_segmento"}
        
                RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                          INPUT  pEntidade,
                                          INPUT  "W":U,
                                          INPUT  "0":U,
                                          INPUT  BUFFER tt-new_segmento:HANDLE,
                                          INPUT  TABLE tt-atributo,
                                          OUTPUT TABLE RowErrors).
        
                EMPTY TEMP-TABLE tt-new_segmento.
           END.
           ELSE
           IF fam-com-item.familia2 = "" THEN DO:
               empty temp-table tt-new_familia-atu.
                create tt-new_familia-atu.
                ASSIGN tt-new_familia-atu.segmento   = fam-com-item.unidade + fam-com-item.segmento
                       tt-new_familia-atu.codigo     = fam-com-item.unidade + fam-com-item.segmento + fam-com-item.familia1
                       tt-new_familia-atu.descricao  = fam-com-item.descricao.

                ASSIGN pEntidade = "new_familia".
                {esp/crm/escrm001a.i "new_familia"}
        
                RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                          INPUT  pEntidade,
                                          INPUT  "W":U,
                                          INPUT  "0":U,
                                          INPUT  BUFFER tt-new_familia:HANDLE,
                                          INPUT  TABLE tt-atributo,
                                          OUTPUT TABLE RowErrors).
        
                EMPTY TEMP-TABLE tt-new_familia.
           END.
           ELSE
           IF fam-com-item.origem = "" THEN DO:
               empty temp-table tt-new_subfamilia-atu.
                create tt-new_subfamilia-atu.
                ASSIGN tt-new_subfamilia-atu.familia       = fam-com-item.unidade + fam-com-item.segmento + fam-com-item.familia1
                       tt-new_subfamilia-atu.codigo        = fam-com-item.unidade + fam-com-item.segmento + fam-com-item.familia1 + fam-com-item.familia2
                       tt-new_subfamilia-atu.descricao     = fam-com-item.descricao.
                
                ASSIGN pEntidade = "new_subfamilia".
                {esp/crm/escrm001a.i "new_subfamilia"}
        
                RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                          INPUT  pEntidade,
                                          INPUT  "W":U,
                                          INPUT  "0":U,
                                          INPUT  BUFFER tt-new_subfamilia:HANDLE,
                                          INPUT  TABLE tt-atributo,
                                          OUTPUT TABLE RowErrors).
        
                EMPTY TEMP-TABLE tt-new_subfamilia.
           END.
           ELSE
           IF fam-com-item.origem <> "" THEN DO:
               empty temp-table tt-new_origem-atu.
                create tt-new_origem-atu.
                ASSIGN tt-new_origem-atu.subfamilia    = fam-com-item.unidade + fam-com-item.segmento + fam-com-item.familia1 + fam-com-item.familia2
                       tt-new_origem-atu.codigo        = fam-com-item.unidade + fam-com-item.segmento + fam-com-item.familia1 + fam-com-item.familia2 + fam-com-item.origem
                       tt-new_origem-atu.descricao     = fam-com-item.descricao.

                ASSIGN pEntidade = "new_origem".
                {esp/crm/escrm001a.i "new_origem"}
        
                RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                          INPUT  pEntidade,
                                          INPUT  "W":U,
                                          INPUT  "0":U,
                                          INPUT  BUFFER tt-new_origem:HANDLE,
                                          INPUT  TABLE tt-atributo,
                                          OUTPUT TABLE RowErrors).
        
                EMPTY TEMP-TABLE tt-new_origem.
           END.
/*         fam-com-item.descricao                                                     */
/*                 WHERE fam-com-item.unidade  = SUBSTRING(fam-comerc.fm-cod-com,1,2) */
/*                   AND fam-com-item.segmento = SUBSTRING(fam-comerc.fm-cod-com,3,2) */
/*                   AND fam-com-item.familia1 = "" NO-ERROR.                         */
    END.
    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaGrupoEstoque:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH grup-estoque NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Grupo Estoque: ":U + STRING(grup-estoque.ge-codigo)).

        empty temp-table tt-grup-estoque-atu.
        create tt-grup-estoque-atu.
        buffer-copy grup-estoque to tt-grup-estoque-atu.
        
        {esp/crm/escrm001a.i "Grup-estoque"}
        
        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-grup-estoque:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-grup-estoque.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaFaixaProduto:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pItInicial        AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pItFinal          AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH item NO-LOCK
        WHERE item.it-codigo >= pItInicial
          AND item.it-codigo <= pItFinal:
        
        IF VALID-HANDLE(h-acomp) THEN
           RUN pi-acompanhar IN h-acomp (INPUT "Produto: ":U + STRING(ITEM.it-codigo)).
         
        empty temp-table tt-item-atu.
        create tt-item-atu.
        buffer-copy item to tt-item-atu.
        
        {esp/crm/escrm001a.i "Item"}
        IF tt-item-atu.it-codigo = "" THEN 
            ASSIGN tt-item-atu.it-codigo = "BRANCO".
    
        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-item:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).
        
        EMPTY TEMP-TABLE tt-item.
      
        FOR EACH tt-productpricelevel: 
   
             EMPTY TEMP-TABLE tt-productpricelevel-atu.
             CREATE tt-productpricelevel-atu.
             BUFFER-COPY tt-productpricelevel TO tt-productpricelevel-atu. 
             
             RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                     INPUT  "productpricelevel":U,
                                     INPUT  cevento,
                                     INPUT  "0":U,
                                     INPUT  BUFFER tt-productpricelevel-atu:HANDLE,
                                     INPUT  TABLE tt-atributo,
                                     OUTPUT TABLE RowErrors).
        END.

        EMPTY TEMP-TABLE tt-productpricelevel.
        
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaProduto:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.
   

    FOR EACH ITEM NO-LOCK :
        
/*         IF ITEM.ge-codigo <> 0  and /* Debito direto */ */
/*            ITEM.ge-codigo <> 20 and /* Semi acabado */ */
/*            ITEM.ge-codigo <> 25 and /* Semi acabado */ */
/*            ITEM.ge-codigo <> 30  /* Material de Consumo */  THEN NEXT. */
  
/*         IF ITEM.ind-item-fat = NO THEN do:                                       ENVIAR TODOS CONFORME SOLICITACAO DE MUDANCA CR 9269 */
/*            if not can-find (first it-nota-fisc no-lock                            */
/*                         where it-nota-fisc.it-codigo = item.it-codigo             */
/*                           and it-nota-fisc.dt-emis-nota >= 01/01/2010) then next. */
/*         end.                                                                      */
        
        IF VALID-HANDLE(h-acomp) THEN
           RUN pi-acompanhar IN h-acomp (INPUT "Produto: ":U + STRING(ITEM.it-codigo)).
         
        empty temp-table tt-item-atu.
        create tt-item-atu.
        buffer-copy item to tt-item-atu.
        
        {esp/crm/escrm001a.i "Item"}
        IF tt-item-atu.it-codigo = "" THEN 
            ASSIGN tt-item-atu.it-codigo = "BRANCO".
    
        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-item:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).
        
        EMPTY TEMP-TABLE tt-item.
      
        FOR EACH tt-productpricelevel: 
   
             EMPTY TEMP-TABLE tt-productpricelevel-atu.
             CREATE tt-productpricelevel-atu.
             BUFFER-COPY tt-productpricelevel TO tt-productpricelevel-atu. 
             
             RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                     INPUT  "productpricelevel":U,
                                     INPUT  cevento,
                                     INPUT  "0":U,
                                     INPUT  BUFFER tt-productpricelevel-atu:HANDLE,
                                     INPUT  TABLE tt-atributo,
                                     OUTPUT TABLE RowErrors).
        END.

        EMPTY TEMP-TABLE tt-productpricelevel.
        
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaEstruturaProduto:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH ITEM NO-LOCK,
        EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = ITEM.it-codigo:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Estrutura Produto: ":U + STRING(estrutura.it-codigo) + " - ":U + STRING(estrutura.sequencia) + "-":U + STRING(estrutura.es-codigo)).

        empty temp-table tt-estrutura-atu.
        create tt-estrutura-atu.
        buffer-copy estrutura to tt-estrutura-atu.
        
       {esp/crm/escrm001a.i "Estrutura"}
 

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT BUFFER tt-estrutura:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-estrutura.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaTabelaPreco:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.
   
    FOR EACH tb-preco NO-LOCK:
        IF tb-preco.situacao = 3 THEN NEXT.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Tabela Preáo: ":U + STRING(tb-preco.nr-tabpre)).
   
        FIND FIRST moeda WHERE 
                   moeda.mo-codigo = tb-preco.mo-codigo NO-LOCK NO-ERROR.

        CREATE tt-tb-preco.
        ASSIGN tt-tb-preco.nr-tabpre = tb-preco.nr-tabpre
               tt-tb-preco.descricao = tb-preco.descricao
               tt-tb-preco.dt-inival = tb-preco.dt-inival
               tt-tb-preco.dt-fimval = tb-preco.dt-fimval               
               tt-tb-preco.mo-codigo = IF AVAILABLE moeda THEN moeda.descricao ELSE "":U
               pContaLinhasTrace     = pContaLinhasTrace + 1.

        CASE tb-preco.situacao:
            WHEN 1 THEN
                ASSIGN tt-tb-preco.situacao = 0.
            WHEN 2 THEN
                ASSIGN tt-tb-preco.situacao = 1.
        END CASE.

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-tb-preco:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-tb-preco.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaPrecoItem:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH preco-item NO-LOCK:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Preáo Item: ":U + STRING(preco-item.nr-tabpre) + " - ":U + STRING(preco-item.it-codigo)).

        FIND FIRST tb-preco
            WHERE tb-preco.nr-tabpre = preco-item.nr-tabpre NO-LOCK NO-ERROR.

        IF NOT AVAILABLE tb-preco OR
          (AVAILABLE tb-preco     AND
           tb-preco.situacao = 3) THEN NEXT.

        CREATE tt-preco-item.
        ASSIGN tt-preco-item.it-codigo           = preco-item.it-codigo
               tt-preco-item.nr-tabpre           = preco-item.nr-tabpre
               tt-preco-item.dt-inival           = preco-item.dt-inival
               tt-preco-item.quant-min           = preco-item.quant-min
               tt-preco-item.preco-venda         = preco-item.preco-venda
               tt-preco-item.preco-fob           = preco-item.preco-fob
               tt-preco-item.preco-min-cif       = preco-item.preco-min-cif
               tt-preco-item.preco-min-fob       = preco-item.preco-min-fob
               tt-preco-item.situacao            = preco-item.situacao
               tt-preco-item.new_chaveintegracao = TRIM(STRING(preco-item.it-codigo)) + ",":U + TRIM(STRING(preco-item.cod-refer)) + ",":U + TRIM(STRING(preco-item.nr-tabpre)) + ",":U + TRIM(STRING(preco-item.dt-inival)) + ",":U + TRIM(STRING(preco-item.quant-min))
               pContaLinhasTrace                 = pContaLinhasTrace + 1.

        FIND FIRST int-preco-item
            WHERE int-preco-item.it-codigo = preco-item.it-codigo
              AND int-preco-item.cod-refer = preco-item.cod-refer
              AND int-preco-item.nr-tabpre = preco-item.nr-tabpre
              AND int-preco-item.dt-inival = preco-item.dt-inival
              AND int-preco-item.quant-min = preco-item.quant-min NO-LOCK NO-ERROR.

        IF AVAILABLE int-preco-item THEN
            ASSIGN tt-preco-item.preco-unico = int-preco-item.preco-unico
                   tt-preco-item.pma         = int-preco-item.pma
                   tt-preco-item.pmd         = int-preco-item.pmd.

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-preco-item:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-preco-item.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaRota:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH rota NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
           RUN pi-acompanhar IN h-acomp (INPUT "Rota: ":U + STRING(rota.cod-rota) + " - ":U + STRING(rota.descricao)).

        empty temp-table tt-rota-atu.
        create tt-rota-atu.
        buffer-copy rota to tt-rota-atu.
        
       {esp/crm/escrm001a.i "Rota"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-rota:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-rota.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaEstabelecimento:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH estabelec NO-LOCK,
        FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = estabelec.cod-emitente,
        FIRST b-int-emitente NO-LOCK
        WHERE b-int-emitente.cod-emitente = emitente.cod-emitente:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Estabelecimento: ":U + STRING(estabelec.cod-estabel)).

        empty temp-table tt-estabelec-atu.
        create tt-estabelec-atu.
        buffer-copy estabelec to tt-estabelec-atu.
        
        ASSIGN tt-estabelec-atu.nome-abrev = emitente.nome-abrev.

        IF b-int-emitente.id-ativo THEN 
           ASSIGN tt-estabelec-atu.id-ativo = 0.
        ELSE
           ASSIGN tt-estabelec-atu.id-ativo = 1.
        
       {esp/crm/escrm001a.i "Estabelec"}

       RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-estabelec:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-estabelec.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaTabelaFinancimento:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i AS INTEGER     NO-UNDO.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH tab-finan NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
           RUN pi-acompanhar IN h-acomp (INPUT "Tabela Financimento: ":U + STRING(tab-finan.nr-tab-finan)).

        empty temp-table tt-tab-finan-atu.
        create tt-tab-finan-atu.
        buffer-copy tab-finan to tt-tab-finan-atu.
         
        {esp/crm/escrm001a.i "Tab-finan"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-tab-finan:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-tab-finan.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaIndiceTabelaFinancimento:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i AS INTEGER     NO-UNDO.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH tab-finan NO-LOCK:
        REPEAT i = 1 TO 12:
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "÷ndice Tabela Financimento: ":U + STRING(tab-finan.nr-tab-finan) + " - ":U + STRING(i)).

            empty temp-table tt-ind-tab-finan-atu.
            
            CREATE tt-ind-tab-finan-atu.
            ASSIGN tt-ind-tab-finan-atu.nr-tab-finan        = tab-finan.nr-tab-finan
                   tt-ind-tab-finan-atu.nr-ind-finan        = i
                   tt-ind-tab-finan-atu.tab-dia-fin         = tab-finan.tab-dia-fin[i]
                   tt-ind-tab-finan-atu.tab-ind-fin         = tab-finan.tab-ind-fin[i].

            {esp/crm/escrm001a.i "ind-tab-finan"}
                   
            RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                      INPUT  pEntidade,
                                      INPUT  "W":U,
                                      INPUT  "0":U,
                                      INPUT  BUFFER tt-ind-tab-finan:HANDLE,
                                      INPUT  TABLE tt-atributo,
                                      OUTPUT TABLE RowErrors).

            EMPTY TEMP-TABLE tt-ind-tab-finan.
        END.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaNaturOper:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH natur-oper NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Natureza de Operaá∆o: ":U + STRING(natur-oper.nat-operacao)).
                       
        empty temp-table tt-natur-oper-atu.
        create tt-natur-oper-atu.
        buffer-copy natur-oper to tt-natur-oper-atu.
        
       {esp/crm/escrm001a.i "Natur-oper"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-natur-oper:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-natur-oper.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaMensagem:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH mensagem NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Mensagem: ":U + STRING(mensagem.cod-mensagem)).

        empty temp-table tt-mensagem-atu.
        create tt-mensagem-atu.
        buffer-copy mensagem to tt-mensagem-atu.
        
       {esp/crm/escrm001a.i "Mensagem"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-mensag-crm:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-mensag-crm.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaCliente:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.
     
    assign cevento = "W".
       
    /* Carregar primeiro as matrizes, ... */
    FOR EACH emitente NO-LOCK
        WHERE emitente.identific <> 2:

        IF emitente.nome-abrev <> emitente.nome-matriz THEN NEXT. /* Apenas matriz */

        {esp/crm/escrm001cliente.i}
        
        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                          INPUT  pEntidade,
                          INPUT  cevento,
                          INPUT  "0":U,
                          INPUT  BUFFER tt-cliente:HANDLE,
                          INPUT  TABLE tt-atributo,
                          OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-cliente.
    END.
    
    /* ...depois as filiais */
    FOR EACH emitente NO-LOCK
        WHERE emitente.identific <> 2:

        IF emitente.nome-abrev = emitente.nome-matriz THEN NEXT. /* Apenas filial */

        {esp/crm/escrm001cliente.i}
        
        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                          INPUT  pEntidade,
                          INPUT  cevento,
                          INPUT  "0":U,
                          INPUT  BUFFER tt-cliente:HANDLE,
                          INPUT  TABLE tt-atributo,
                          OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-cliente.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaContato:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.
        
    FOR EACH emitente NO-LOCK
        WHERE emitente.identific <> 2,
        EACH cont-emit
        WHERE cont-emit.cod-emitente = emitente.cod-emitente NO-LOCK:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Contato Emitente: ":U + STRING(emitente.nome-abrev) + " - ":U + STRING(cont-emit.sequencia)).
        
        empty temp-table tt-cont-emit-atu.
        create tt-cont-emit-atu.
        buffer-copy cont-emit to tt-cont-emit-atu.
         
        {esp/crm/escrm001a.i "Cont-emit"}        

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-cont-emit:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-cont-emit.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaLocalEntrega:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.
  
    
    FOR EACH emitente NO-LOCK
        WHERE emitente.identific <> 2,
        EACH loc-entr  WHERE 
             loc-entr.nome-abrev = emitente.nome-abrev NO-LOCK:
             
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Local Entrega: ":U + STRING(loc-entr.nome-abrev) + " - ":U + STRING(loc-entr.cod-entrega)).
         
        empty temp-table tt-loc-entr-atu.
        create tt-loc-entr-atu.
        buffer-copy loc-entr to tt-loc-entr-atu.
         
        {esp/crm/escrm001a.i "Loc-entr"}
        
        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-loc-entr:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-loc-entr.
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaCidade:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    FOR EACH mgcad.cidade NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Cidade: ":U + STRING(cidade.cidade)).

        empty temp-table tt-cidade-atu.
        create tt-cidade-atu.
        buffer-copy cidade to tt-cidade-atu.
        
       {esp/crm/escrm001a.i "Cidade"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-cidade:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-cidade.
    END.
    
    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaUnidFeder:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.
  
    FOR EACH unid-feder WHERE
        unid-feder.pais = "BRASIL" NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Unidade Federaá∆o: ":U + STRING(unid-feder.no-estado)).

        empty temp-table tt-unid-feder-atu.
        create tt-unid-feder-atu.
        buffer-copy unid-feder to tt-unid-feder-atu.
        
       {esp/crm/escrm001a.i "uf"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-unid-feder:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-unid-feder.
    END.
    
    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaRelacionamentoCliente:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
        
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.
    
    FOR EACH crm-relacionamento-cliente NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Relacionamento Cliente: ":U + STRING(crm-relacionamento-cliente.cod-emitente) + " - ":U + STRING(crm-relacionamento-cliente.seq)).
            
        empty temp-table tt-relacionamento-cliente-atu.
        create tt-relacionamento-cliente-atu.
        buffer-copy crm-relacionamento-cliente to tt-relacionamento-cliente-atu.
       
         
        {esp/crm/escrm001a.i "Crm-Relacionamento-Cliente"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-relacionamento-cliente:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-relacionamento-cliente.
        empty temp-table tt-relacionamento-cliente-atu.
        
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.


PROCEDURE piCarregaPedido:
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-param-mov.
    DEFINE INPUT        PARAMETER TABLE FOR tt-raw-transfer.
    DEFINE OUTPUT       PARAMETER TABLE FOR RowErrors.
   
    DEFINE VAR l-trigger     AS LOGICAL INITIAL NO.
    DEFINE VAR rw-ped-venda  AS ROWID.   
    DEFINE VAR rw-ped-item   AS ROWID.

    FIND FIRST tt-param-mov NO-ERROR.
    IF AVAIL tt-param-mov THEN
       ASSIGN l-trigger    = tt-param-mov.prog-orig BEGINS "wdi"
              rw-ped-venda = tt-param-mov.rw-tabela-pai
              rw-ped-item  = tt-param-mov.rw-tabela-filho.

    IF NOT VALID-HANDLE(h-acomp) AND l-trigger = NO THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.
    
    EMPTY TEMP-TABLE tt-ped-venda-atu.
    EMPTY TEMP-TABLE tt-ped-item-atu.


    IF l-trigger = YES THEN DO:
       IF tt-param-mov.action = "w" THEN DO:
          FOR FIRST ped-venda NO-LOCK  WHERE
                  rowid(ped-venda) = rw-ped-venda :

             CREATE tt-ped-venda-atu.
             BUFFER-COPY ped-venda TO tt-ped-venda-atu.

             ASSIGN tt-ped-venda-atu.user-impl = "crmadmin":U. /*tt-ped-venda-atu.user-impl*/
            
             IF tt-param-mov.prog-orig = "wdi159-com" THEN DO:
            
                FOR EACH crm-ped-item EXCLUSIVE-LOCK WHERE
                         crm-ped-item.nr-pedcli  = ped-venda.nr-pedcli  AND
                         crm-ped-item.nome-abrev = ped-venda.nome-abrev :
    
                    IF crm-ped-item.sit-crm = 2 /* Efetivado */  THEN 
                       DELETE  crm-ped-item.
                    ELSE DO:
                       
                      FIND FIRST ped-item OF ped-venda NO-LOCK NO-ERROR.
                      IF AVAIL ped-item THEN DO: 
    
                         CREATE tt-ped-item-atu.
                         BUFFER-COPY ped-item EXCEPT it-codigo nr-sequencia TO tt-ped-item-atu.
                         ASSIGN tt-ped-item-atu.action        = crm-ped-item.action
                                tt-ped-item-atu.sit-crm       = crm-ped-item.sit-crm
                                tt-ped-item-atu.it-codigo     = crm-ped-item.it-codigo
                                tt-ped-item-atu.nr-sequencia  = crm-ped-item.nr-sequencia.

                      END.
    
                    END.
                END.
            
                FOR EACH ped-item OF ped-venda NO-LOCK  WHERE
                         ped-item.cod-sit-item < 3 : 
                             
                        CREATE tt-ped-item-atu.
                        BUFFER-COPY ped-item TO tt-ped-item-atu.
                        ASSIGN tt-ped-item-atu.sit-crm =  1
                               tt-ped-item-atu.action  = "W".  
        
                END.
             END.
             ELSE DO:
                IF ped-venda.cod-sit-ped < 3  /* Cancelado , suspenso ... nao precisa enviar os itens */ THEN DO:
                   FOR EACH ped-item NO-LOCK WHERE
                      rowid(ped-item) = rw-ped-item : 
                                 
                       CREATE tt-ped-item-atu.
                       BUFFER-COPY ped-item TO tt-ped-item-atu.
                           ASSIGN tt-ped-item-atu.sit-crm =  1
                                  tt-ped-item-atu.action  = "W".  
                   END.
                END.
             END.
          END.   
       END.
       ELSE DO:
           IF tt-param-mov.prog-orig = "wdi159"   /* Elimina o pedido */ THEN DO:
               find first tt-raw-transfer no-error.
               
               create tt-ped-venda-atu.
       
               raw-transfer tt-raw-transfer.record to tt-ped-venda-atu.

               FOR EACH ped-item NO-LOCK WHERE 
                        ped-item.nome-abrev    = tt-ped-venda-atu.nome-abrev AND 
                        ped-item.nr-pedcli     = tt-ped-venda-atu.nr-pedcli  :
                 
                 CREATE tt-ped-item-atu.
                 BUFFER-COPY ped-item TO tt-ped-item-atu.    
                 ASSIGN tt-ped-item-atu.action = tt-param-mov.action.

               END.
           END.
           ELSE DO:   /* Elimina o item do pedido */
              find first tt-raw-transfer no-error.
               
               create tt-ped-item-atu.
       
               raw-transfer tt-raw-transfer.record to tt-ped-item-atu. 


               FIND FIRST tt-ped-venda-atu WHERE
                          tt-ped-venda-atu.nr-pedcli  = tt-ped-item-atu.nr-pedcli AND
                          tt-ped-venda-atu.nome-abrev = tt-ped-item-atu.nome-abrev NO-ERROR.
               IF NOT AVAIL tt-ped-venda-atu THEN DO:
                   FIND FIRST ped-venda NO-LOCK  WHERE
                              ped-venda.nr-pedcli  = tt-ped-item-atu.nr-pedcli AND
                              ped-venda.nome-abrev = tt-ped-item-atu.nome-abrev NO-ERROR.
                   IF AVAIL ped-venda THEN DO:
                     CREATE tt-ped-venda-atu.
                     BUFFER-COPY ped-venda TO tt-ped-venda-atu.
                   END.
               END.
           END.
       END.
    END.
    ELSE DO:
        IF tt-param-mov.automatico THEN DO:
            FOR EACH int-ped-venda
                WHERE int-ped-venda.atualizacrm = YES EXCLUSIVE-LOCK,
                FIRST ped-venda NO-LOCK                            WHERE
                     ped-venda.nr-pedido = int-ped-venda.nr-pedido AND
                     ped-venda.completo    = yes :

                ASSIGN int-ped-venda.atualizacrm = NO.
                CREATE tt-ped-venda-atu.
                BUFFER-COPY ped-venda TO tt-ped-venda-atu.

                FOR EACH ped-item NO-LOCK WHERE 
                         ped-item.nome-abrev    = ped-venda.nome-abrev AND 
                         ped-item.nr-pedcli     = ped-venda.nr-pedcli  :

                    CREATE tt-ped-item-atu.
                    BUFFER-COPY ped-item TO tt-ped-item-atu.    
                    ASSIGN tt-ped-item-atu.action = tt-param-mov.action.

                END.
            END.
        END.
        ELSE DO:
            FOR EACH ped-venda NO-LOCK  WHERE
                     ped-venda.dt-implant >= tt-param-mov.dt-ini-pedido AND
                     ped-venda.dt-implant <= tt-param-mov.dt-fim-pedido AND
                     ped-venda.completo    = yes :

                CREATE tt-ped-venda-atu.
                BUFFER-COPY ped-venda TO tt-ped-venda-atu.

                FOR EACH ped-item NO-LOCK WHERE 
                         ped-item.nome-abrev    = ped-venda.nome-abrev AND 
                         ped-item.nr-pedcli     = ped-venda.nr-pedcli  :

                    CREATE tt-ped-item-atu.
                    BUFFER-COPY ped-item TO tt-ped-item-atu.    
                    ASSIGN tt-ped-item-atu.action = tt-param-mov.action.

                END.
            END.
        END.
        
    END.
     
    FOR EACH tt-ped-venda-atu:
        
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Pedido: ":U + STRING(tt-ped-venda-atu.nr-pedido)).
    
        CREATE tt-ped-venda.
        
        CREATE tt-atributo.
        ASSIGN tt-atributo.r-temp-table = ROWID(tt-ped-venda)
               tt-atributo.nome-campo   = "cod-emitente":U
               tt-atributo.nome-atrib   = "entity":U
               tt-atributo.vl-atrib     = "account":U.

        CREATE tt-atributo.
        ASSIGN tt-atributo.r-temp-table = ROWID(tt-ped-venda)
               tt-atributo.nome-campo   = "cod-emitente":U
               tt-atributo.nome-atrib   = "keyfield":U
               tt-atributo.vl-atrib     = "accountnumber":U.

        FIND FIRST int-ped-venda WHERE 
                   int-ped-venda.nr-pedido = tt-ped-venda-atu.nr-pedido NO-LOCK NO-ERROR.

        IF AVAILABLE int-ped-venda       AND
           int-ped-venda.vl-guid <> "":U AND
           int-ped-venda.vl-guid <> ?    THEN DO:
            CREATE tt-atributo.
            ASSIGN tt-atributo.r-temp-table = ROWID(tt-ped-venda)
                   tt-atributo.nome-campo   = "nr-pedido":U
                   tt-atributo.nome-atrib   = "crmid":U
                   tt-atributo.vl-atrib     = int-ped-venda.vl-guid.
        END.


        FIND FIRST moeda WHERE 
                   moeda.mo-codigo = tt-ped-venda-atu.mo-codigo NO-LOCK NO-ERROR.

        FIND FIRST transporte WHERE 
                   transporte.nome-abrev = tt-ped-venda-atu.nome-transp NO-LOCK NO-ERROR.

        FIND FIRST repres WHERE 
                   repres.nome-abrev =  tt-ped-venda-atu.no-ab-reppri NO-LOCK NO-ERROR.

        FIND FIRST emitente WHERE 
                   emitente.nome-abrev = tt-ped-venda-atu.nome-abrev-tri NO-LOCK NO-ERROR.
        
        ASSIGN tt-ped-venda.name            = tt-ped-venda-atu.nr-pedido
               tt-ped-venda.cod-estabel     = tt-ped-venda-atu.cod-estabel
               tt-ped-venda.nome-abrev      = tt-ped-venda-atu.nome-abrev
               tt-ped-venda.nr-pedcli       = tt-ped-venda-atu.nr-pedcli
               tt-ped-venda.nr-pedido       = tt-ped-venda-atu.nr-pedido
               tt-ped-venda.nr-pedrep       = tt-ped-venda-atu.nr-pedrep
               tt-ped-venda.dt-emissao      = tt-ped-venda-atu.dt-emissao
               tt-ped-venda.dt-implant      = tt-ped-venda-atu.dt-implant
               tt-ped-venda.user-impl       = "crmadmin"      
               tt-ped-venda.dt-entrega      = tt-ped-venda-atu.dt-entrega
               tt-ped-venda.dt-cancela      = tt-ped-venda-atu.dt-cancela
               tt-ped-venda.desc-cancela    = tt-ped-venda-atu.desc-cancela
               tt-ped-venda.dt-minfat       = tt-ped-venda-atu.dt-minfat
               tt-ped-venda.dt-lim-fat      = tt-ped-venda-atu.dt-lim-fat
               tt-ped-venda.dt-entorig      = tt-ped-venda-atu.dt-entorig
               tt-ped-venda.dt-reativ       = tt-ped-venda-atu.dt-reativ
               tt-ped-venda.nat-operacao    = tt-ped-venda-atu.nat-operacao
               tt-ped-venda.cod-cond-pag    = tt-ped-venda-atu.cod-cond-pag
               tt-ped-venda.nr-tabpre       = tt-ped-venda-atu.nr-tabpre
               tt-ped-venda.nr-tab-finan    = tt-ped-venda-atu.nr-tab-finan
               tt-ped-venda.tp-pedido       = tt-ped-venda-atu.tp-pedido
               tt-ped-venda.origem          = tt-ped-venda-atu.origem
               tt-ped-venda.cod-priori      = tt-ped-venda-atu.cod-priori
               tt-ped-venda.cod-entrega     = tt-ped-venda-atu.cod-entrega
               tt-ped-venda.local-entreg    = STRING(tt-ped-venda-atu.local-entreg, "x(40)":U)
               tt-ped-venda.bairro          = tt-ped-venda-atu.bairro
               tt-ped-venda.cidade          = tt-ped-venda-atu.cidade
               tt-ped-venda.estado          = tt-ped-venda-atu.estado
               tt-ped-venda.cep             = tt-ped-venda-atu.cep
               tt-ped-venda.pais            = tt-ped-venda-atu.pais
               tt-ped-venda.cgc             = tt-ped-venda-atu.cgc
               tt-ped-venda.ins-estadual    = tt-ped-venda-atu.ins-estadual
               tt-ped-venda.perc-desco1     = tt-ped-venda-atu.perc-desco1
               tt-ped-venda.perc-desco2     = tt-ped-venda-atu.perc-desco2
               tt-ped-venda.cond-redespa    = tt-ped-venda-atu.cond-redespa
               tt-ped-venda.cidade-cif      = tt-ped-venda-atu.cidade-cif
               tt-ped-venda.cod-portador    = tt-ped-venda-atu.cod-portador
               tt-ped-venda.modalidade      = tt-ped-venda-atu.modalidade
               tt-ped-venda.cod-mensagem    = tt-ped-venda-atu.cod-mensagem
               tt-ped-venda.observacoes     = TRIM(STRING(tt-ped-venda-atu.observacoes, "x(4000)":U))
               tt-ped-venda.cond-espec      = tt-ped-venda-atu.cond-espec
               tt-ped-venda.dt-userimp      = tt-ped-venda-atu.dt-userimp
               tt-ped-venda.user-alte       = tt-ped-venda-atu.user-alte
               tt-ped-venda.dt-useralt      = tt-ped-venda-atu.dt-useralt
               tt-ped-venda.user-canc       = tt-ped-venda-atu.user-canc
               tt-ped-venda.dt-usercan      = tt-ped-venda-atu.dt-usercan
               tt-ped-venda.user-reat       = tt-ped-venda-atu.user-reat
               tt-ped-venda.dt-userrea      = tt-ped-venda-atu.dt-userrea
               tt-ped-venda.user-suspen     = tt-ped-venda-atu.user-suspen
               tt-ped-venda.dt-usersusp     = tt-ped-venda-atu.dt-usersusp
               tt-ped-venda.ind-aprov       = tt-ped-venda-atu.ind-aprov
               tt-ped-venda.quem-aprovou    = tt-ped-venda-atu.quem-aprovou
               tt-ped-venda.dt-apr-cred     = tt-ped-venda-atu.dt-apr-cred
               tt-ped-venda.cod-des-merc    = tt-ped-venda-atu.cod-des-merc
               tt-ped-venda.nome-transp     = IF AVAILABLE transporte THEN transporte.cod-transp ELSE ?
               tt-ped-venda.tp-preco        = tt-ped-venda-atu.tp-preco
               tt-ped-venda.ind-fat-par     = tt-ped-venda-atu.ind-fat-par
               tt-ped-venda.mo-codigo       = IF AVAILABLE moeda THEN moeda.descricao ELSE "":U
               tt-ped-venda.cod-rota        = tt-ped-venda-atu.cod-rota
               tt-ped-venda.vl-tot-ped      = tt-ped-venda-atu.vl-tot-ped
               tt-ped-venda.vl-liq-ped      = tt-ped-venda-atu.vl-liq-ped
               tt-ped-venda.vl-liq-abe      = tt-ped-venda-atu.vl-liq-abe
               tt-ped-venda.nr-ind-finan    = STRING(tt-ped-venda-atu.nr-tab-finan) + ",":U + STRING(tt-ped-venda-atu.nr-ind-finan)
               tt-ped-venda.user-aprov      = tt-ped-venda-atu.user-aprov
               tt-ped-venda.no-ab-reppri    = IF AVAILABLE repres THEN repres.cod-rep ELSE 0
               tt-ped-venda.vl-mer-abe      = tt-ped-venda-atu.vl-mer-abe
               tt-ped-venda.cod-sit-aval    = tt-ped-venda-atu.cod-sit-aval
               tt-ped-venda.desc-suspend    = tt-ped-venda-atu.desc-suspend
               tt-ped-venda.desc-bloq-cr    = tt-ped-venda-atu.desc-bloq-cr
               tt-ped-venda.desc-forc-cr    = tt-ped-venda-atu.desc-forc-cr
               tt-ped-venda.cod-emitente    = tt-ped-venda-atu.cod-emitente
               tt-ped-venda.cod-sit-pre     = tt-ped-venda-atu.cod-sit-pre
               tt-ped-venda.per-des-icms    = tt-ped-venda-atu.per-des-icms
               tt-ped-venda.vl-cred-lib     = tt-ped-venda-atu.vl-cred-lib
               tt-ped-venda.aprov-forcado   = tt-ped-venda-atu.aprov-forcado
               tt-ped-venda.cod-gr-cli      = tt-ped-venda-atu.cod-gr-cli
               tt-ped-venda.completo        = tt-ped-venda-atu.completo
               tt-ped-venda.cod-canal-venda = tt-ped-venda-atu.cod-canal-venda
               tt-ped-venda.nome-abrev-tri  = IF AVAILABLE emitente THEN emitente.cod-emitente ELSE 0
               tt-ped-venda.cod-entrega-tri = tt-ped-venda-atu.cod-entrega-tri
               tt-ped-venda.pricelevelid    = IF moeda.descricao = "Real":U THEN "CRM Real":U ELSE "CRM Dolar":U
               tt-param-mov.iContaLinhasTracePai = tt-param-mov.iContaLinhasTracePai + 1.

        FIND FIRST param-global NO-LOCK NO-ERROR.

        FIND FIRST emitente
            WHERE emitente.cod-emitente = tt-ped-venda-atu.cod-emitente NO-LOCK NO-ERROR.

        IF AVAILABLE emitente     AND
           AVAILABLE param-global THEN DO:
            CASE emitente.natureza:
                WHEN 1 THEN
                    ASSIGN tt-ped-venda.cgc = STRING(tt-ped-venda.cgc, param-global.formato-id-pessoal).
                WHEN 2 THEN
                    ASSIGN tt-ped-venda.cgc = STRING(tt-ped-venda.cgc, param-global.formato-id-federal).
            END CASE.
        END.

        /*************************************************************************************************** 
        ** Os c¢digos das Situaá‰es do Pedido no CRM s∆o diferentes do EMS. Seguir a tabela abaixo:       **
        **   Sit EMS -     Desc Sit     - Sit CRM                                                         **
        **     1     - Aberto           - 1                                                               **
        **     2     - Atendido Parcial - 200006                                                          **
        **     3     - Atendido Total   - 200007                                                          **
        **     4     - Pendente         - 2                                                               **
        **     5     - Suspenso         - 200005                                                          **
        **     6     - Cancelado        - 200004                                                          **
        **     7     - Fatur Balc∆o     - 200008                                                          **
        ****************************************************************************************************/
        CASE tt-ped-venda-atu.cod-sit-ped:
            WHEN 1 THEN
                ASSIGN tt-ped-venda.cod-sit-ped = 1.
            WHEN 2 THEN
                ASSIGN tt-ped-venda.cod-sit-ped = 200006.
            WHEN 3 THEN
                ASSIGN tt-ped-venda.cod-sit-ped = 200007.
            WHEN 4 THEN
                ASSIGN tt-ped-venda.cod-sit-ped = 2.
            WHEN 5 THEN
                ASSIGN tt-ped-venda.cod-sit-ped = 200005.
            WHEN 6 THEN
                ASSIGN tt-ped-venda.cod-sit-ped = 200004.
            WHEN 7 THEN
                ASSIGN tt-ped-venda.cod-sit-ped = 200008.
        END CASE.


        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  tt-param-mov.tabela-pai,
                                  INPUT  tt-param-mov.action,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-ped-venda:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).


        FOR EACH tt-ped-item-atu NO-LOCK WHERE 
                 tt-ped-item-atu.nome-abrev    = tt-ped-venda-atu.nome-abrev AND 
                 tt-ped-item-atu.nr-pedcli     = tt-ped-venda-atu.nr-pedcli :

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Item Pedido: ":U + STRING(tt-ped-venda-atu.nr-pedido) + " - ":U + STRING(tt-ped-item-atu.it-codigo)).

            CREATE tt-ped-item.

            FIND FIRST int-ped-item NO-LOCK
                WHERE  int-ped-item.nome-abrev   = tt-ped-item-atu.nome-abrev
                  AND  int-ped-item.nr-pedcli    = tt-ped-item-atu.nr-pedcli
                  AND  int-ped-item.nr-sequencia = tt-ped-item-atu.nr-sequencia
                  AND  int-ped-item.it-codigo    = tt-ped-item-atu.it-codigo
                  AND  int-ped-item.cod-refer    = tt-ped-item-atu.cod-refer NO-ERROR.

            IF  l-log THEN
                put "ANTES LIETURA IT-PED-ITEM tt-ped-item-atu.nome-abrev   " tt-ped-item-atu.nome-abrev       SKIP
                        "                          tt-ped-item-atu.nr-pedcli    " tt-ped-item-atu.nr-pedcli        SKIP
                        "                          tt-ped-item-atu.nr-sequencia " tt-ped-item-atu.nr-sequencia     SKIP
                        "                          tt-ped-item-atu.it-codigo    " tt-ped-item-atu.it-codigo        SKIP
                        "                          tt-ped-item-atu.cod-refer    " tt-ped-item-atu.cod-refer        SKIP           
                        "                          int-ped-item.vl-guid         " int-ped-item.vl-guid             SKIP.


            
            IF AVAILABLE int-ped-item       AND
               int-ped-item.vl-guid <> "":U AND
               int-ped-item.vl-guid <> ?    THEN DO:
                CREATE tt-atributo.
                ASSIGN tt-atributo.r-temp-table = ROWID(tt-ped-item)
                       tt-atributo.nome-campo   = "new_chaveintegracao":U
                       tt-atributo.nome-atrib   = "crmid":U
                       tt-atributo.vl-atrib     = int-ped-item.vl-guid.
                IF  l-log THEN
                    put "gravou atributo "  tt-atributo.vl-atrib SKIP.
            END.

            FIND FIRST item
                WHERE item.it-codigo = tt-ped-item-atu.it-codigo NO-LOCK NO-ERROR.

            ASSIGN tt-ped-item.nome-abrev          = tt-ped-item-atu.nome-abrev   
                   tt-ped-item.nr-pedcli           = tt-ped-item-atu.nr-pedcli    
                   tt-ped-item.nr-sequencia        = tt-ped-item-atu.nr-sequencia 
                   tt-ped-item.it-codigo           = tt-ped-item-atu.it-codigo    
                   tt-ped-item.un                  = IF AVAILABLE item THEN item.un ELSE "":U
                   tt-ped-item.dt-entorig          = tt-ped-item-atu.dt-entorig   
                   tt-ped-item.dt-entrega          = tt-ped-item-atu.dt-entrega   
                   tt-ped-item.dt-canseq           = tt-ped-item-atu.dt-canseq    
                   tt-ped-item.desc-cancela        = tt-ped-item-atu.desc-cancela 
                   tt-ped-item.dt-reativ           = tt-ped-item-atu.dt-reativ    
                   tt-ped-item.dt-suspensao        = tt-ped-item-atu.dt-suspensao 
                   tt-ped-item.qt-pedida           = tt-ped-item-atu.qt-pedida    
                   tt-ped-item.qt-atendida         = tt-ped-item-atu.qt-atendida  
                   tt-ped-item.qt-pendente         = tt-ped-item-atu.qt-pendente  
                   tt-ped-item.qt-devolvida        = tt-ped-item-atu.qt-devolvida 
                   tt-ped-item.dt-devolucao        = tt-ped-item-atu.dt-devolucao 
                   tt-ped-item.desc-devol          = tt-ped-item-atu.desc-devol   
                   tt-ped-item.vl-pretab           = tt-ped-item-atu.vl-pretab    
                   tt-ped-item.vl-preori           = tt-ped-item-atu.vl-preori    
                   tt-ped-item.vl-preuni           = tt-ped-item-atu.vl-preuni    
                   tt-ped-item.per-des-item        = tt-ped-item-atu.per-des-item 
                   tt-ped-item.per-minfat          = tt-ped-item-atu.per-minfat   
                   tt-ped-item.cod-sit-item        = tt-ped-item-atu.cod-sit-item 
                   tt-ped-item.user-impl           = "crmadmin" /* tt-ped-item-atu.user-impl */
                   tt-ped-item.dt-userimp          = tt-ped-item-atu.dt-userimp   
                   tt-ped-item.user-alte           = tt-ped-item-atu.user-alte    
                   tt-ped-item.dt-useralt          = tt-ped-item-atu.dt-useralt   
                   tt-ped-item.user-canc           = tt-ped-item-atu.user-canc    
                   tt-ped-item.dt-usercan          = tt-ped-item-atu.dt-usercan   
                   tt-ped-item.user-reat           = tt-ped-item-atu.user-reat    
                   tt-ped-item.dt-userrea          = tt-ped-item-atu.dt-userrea   
                   tt-ped-item.user-devol          = tt-ped-item-atu.user-devol   
                   tt-ped-item.dt-userdev          = tt-ped-item-atu.dt-userdev   
                   tt-ped-item.user-susp           = tt-ped-item-atu.user-susp    
                   tt-ped-item.dt-usersusp         = tt-ped-item-atu.dt-usersusp  
                   tt-ped-item.aliquota-ipi        = tt-ped-item-atu.aliquota-ipi 
                   tt-ped-item.ind-icm-ret         = tt-ped-item-atu.ind-icm-ret  
                   tt-ped-item.vl-merc-abe         = tt-ped-item-atu.vl-merc-abe  
                   tt-ped-item.vl-liq-it           = tt-ped-item-atu.vl-liq-it    
                   tt-ped-item.vl-liq-abe          = tt-ped-item-atu.vl-liq-abe   
                   tt-ped-item.vl-tot-it           = tt-ped-item-atu.vl-tot-it    
                   tt-ped-item.nr-tabpre           = tt-ped-item-atu.nr-tabpre    
                   tt-ped-item.tp-preco            = tt-ped-item-atu.tp-preco     
                   tt-ped-item.per-des-icms        = tt-ped-item-atu.per-des-icms 
                   tt-ped-item.nat-operacao        = tt-ped-item-atu.nat-operacao 
                   tt-ped-item.observacao          = tt-ped-item-atu.observacao   
                   tt-ped-item.desc-txt            = tt-ped-item-atu.desc-txt     
                   tt-ped-item.qt-alocada          = tt-ped-item-atu.qt-alocada   
                   tt-ped-item.cod-sit-pre         = tt-ped-item-atu.cod-sit-pre  
                   tt-ped-item.dt-max-fat          = tt-ped-item-atu.dt-max-fat   
                   tt-ped-item.dt-min-fat          = tt-ped-item-atu.dt-min-fat   
                   tt-ped-item.qt-log-aloca        = tt-ped-item-atu.qt-log-aloca 
                   tt-ped-item.ind-fat-qtfam       = tt-ped-item-atu.ind-fat-qtfam
                   tt-ped-item.new_chaveintegracao = IF AVAILABLE emitente THEN STRING(emitente.cod-emitente) ELSE STRING(0)
                   tt-ped-item.new_chaveintegracao = tt-ped-item.new_chaveintegracao + ",":U + STRING(tt-ped-item-atu.nr-pedcli) + ",":U + STRING(tt-ped-item-atu.nr-sequencia) + ",":U + STRING(tt-ped-item-atu.it-codigo) + ",":U + STRING(tt-ped-item-atu.cod-refer)
                   tt-ped-item.nr-pedido           = tt-ped-venda-atu.nr-pedido
                   tt-ped-item.ispriceoverridden   = 1
                   tt-param-mov.iContaLinhasTraceFilho = tt-param-mov.iContaLinhasTraceFilho + 1.

                   IF tt-ped-item.it-codigo = "" THEN 
                      ASSIGN tt-ped-item.it-codigo = "Branco".  

            RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                      INPUT  tt-param-mov.tabela-filho,
                                      INPUT  tt-ped-item-atu.action,
                                      INPUT  "0":U,
                                      INPUT  BUFFER tt-ped-item:HANDLE,
                                      INPUT  TABLE tt-atributo,
                                      OUTPUT TABLE RowErrors).


            IF tt-param-mov.prog-orig = "wdi159-com"   /* esta completando o pedido de venda */ THEN DO:
               FIND FIRST crm-ped-item EXCLUSIVE-LOCK WHERE
                          crm-ped-item.action       = tt-ped-item-atu.action       AND
                          crm-ped-item.nr-pedcli    = tt-ped-item-atu.nr-pedcli    AND
                          crm-ped-item.nome-abrev   = tt-ped-item-atu.nome-abrev   AND
                          crm-ped-item.it-codigo    = tt-ped-item-atu.it-codigo    AND
                          crm-ped-item.nr-sequencia = tt-ped-item-atu.nr-sequencia NO-ERROR.
               IF NOT AVAIL crm-ped-item 
               THEN DO:
                  CREATE crm-ped-item.
                  ASSIGN crm-ped-item.action       = tt-ped-item-atu.action
                         crm-ped-item.sit-crm      = 2  /* Efetivado */          
                         crm-ped-item.nr-pedcli    = tt-ped-item-atu.nr-pedcli   
                         crm-ped-item.nome-abrev   = tt-ped-item-atu.nome-abrev  
                         crm-ped-item.it-codigo    = tt-ped-item-atu.it-codigo   
                         crm-ped-item.nr-sequencia = tt-ped-item-atu.nr-sequencia.
               END.
               ELSE 
                  ASSIGN crm-ped-item.sit-crm  = 2.  
            END.

            EMPTY TEMP-TABLE tt-ped-item.
        END.

        /* Como o c¢digo do pedido j† Ç enviado corretamente da primeira vez, n∆o precisa enviar novamente - 13-01-2011
        IF  tt-ped-venda-atu.cod-sit-ped <> 1 THEN DO:
            FIND FIRST tt-ped-venda NO-ERROR.

            CREATE tt-atributo.
            ASSIGN tt-atributo.r-temp-table = ROWID(tt-ped-venda)
                   tt-atributo.nome-campo   = "cod-emitente":U
                   tt-atributo.nome-atrib   = "entity":U
                   tt-atributo.vl-atrib     = "account":U.
    
            CREATE tt-atributo.
            ASSIGN tt-atributo.r-temp-table = ROWID(tt-ped-venda)
                   tt-atributo.nome-campo   = "cod-emitente":U
                   tt-atributo.nome-atrib   = "keyfield":U
                   tt-atributo.vl-atrib     = "accountnumber":U.
                  
            /* Quando for enviar a situaá∆o real do Pedido para o CRM, deve seguir a tabela de c¢digo abaixo:
               Sit EMS -     Desc Sit     - Sit CRM
                 1     - Aberto           - 1
                 2     - Atendido Parcial - 200006
                 3     - Atendido Total   - 200007
                 4     - Pendente         - 2
                 5     - Suspenso         - 200005
                 6     - Cancelado        - 200004
                 7     - Fatur Balc∆o     - 200008
            */

            CASE tt-ped-venda-atu.cod-sit-ped:
                WHEN 1 THEN
                    ASSIGN tt-ped-venda.cod-sit-ped = 1.
                WHEN 2 THEN
                    ASSIGN tt-ped-venda.cod-sit-ped = 200006.
                WHEN 3 THEN
                    ASSIGN tt-ped-venda.cod-sit-ped = 200007.
                WHEN 4 THEN
                    ASSIGN tt-ped-venda.cod-sit-ped = 2.
                WHEN 5 THEN
                    ASSIGN tt-ped-venda.cod-sit-ped = 200005.
                WHEN 6 THEN
                    ASSIGN tt-ped-venda.cod-sit-ped = 200004.
                WHEN 7 THEN
                    ASSIGN tt-ped-venda.cod-sit-ped = 200008.
            END CASE.

            RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                      INPUT  tt-param-mov.tabela-pai,
                                      INPUT  tt-param-mov.action,
                                      INPUT  "0":U,
                                      INPUT BUFFER tt-ped-venda:HANDLE,
                                      INPUT  TABLE tt-atributo,
                                      OUTPUT TABLE RowErrors).
        END.*/

        EMPTY TEMP-TABLE tt-ped-venda.
    END.
    
    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaNotaFiscal:
    DEFINE INPUT  PARAMETER TABLE FOR tt-param-mov.
    DEFINE INPUT  PARAMETER pEntidadeNF             AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pEntidadeItemNF         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTraceNF     AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTraceItemNF AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTraceOcor   AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTraceDuplic AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE iContaLinhasTraceNF     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iContaLinhasTraceItemNF AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iContaLinhasTraceOcor   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iContaLinhasTraceDuplic AS INTEGER     NO-UNDO.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.
   
    FIND FIRST tt-param-mov NO-ERROR.


    IF tt-param-mov.automatico THEN DO: 
        bk-pedido1:
        FOR EACH  nota-fiscal NO-LOCK USE-INDEX ch-distancia
            WHERE nota-fiscal.dt-emis-nota >= TODAY - 3:

            RUN piEnviaNotaFiscal IN THIS-PROCEDURE (INPUT  pEntidadeNF,
                                                     INPUT  pEntidadeItemNF,
                                                     OUTPUT iContaLinhasTraceNF,
                                                     OUTPUT iContaLinhasTraceItemNF,
                                                     OUTPUT iContaLinhasTraceOcor,
                                                     OUTPUT iContaLinhasTraceDuplic).

            ASSIGN pContaLinhasTraceNF     = pContaLinhasTraceNF     + iContaLinhasTraceNF
                   pContaLinhasTraceItemNF = pContaLinhasTraceItemNF + iContaLinhasTraceItemNF
                   pContaLinhasTraceOcor   = pContaLinhasTraceOcor   + iContaLinhasTraceOcor
                   pContaLinhasTraceDuplic = pContaLinhasTraceDuplic + iContaLinhasTraceDuplic.
        END.
        /* TMS FOR EACH ocorrencia
            WHERE ocorrencia.cd-tp-docto = 2 AND 
                  ocorrencia.dt-criacao  >= TODAY - 3 NO-LOCK:
            FIND estabelec
                 WHERE estabelec.cgc = ocorrencia.cgc-rem
                 NO-LOCK NO-ERROR.
            CREATE tt-ocorrencia.
            ASSIGN tt-ocorrencia.nr-ocorrencia  = ocorrencia.nr-ocorrencia
                   tt-ocorrencia.dt-ocorrencia  = ocorrencia.dt-ocorrencia
                   tt-ocorrencia.ds-ocorrencia  = ocorrencia.ds-ocorrencia   
                   tt-ocorrencia.des-tipo       = "Nota Fiscal" 
                   tt-ocorrencia.chave-integracao-nota-fiscal = STRING(estabelec.cod-estabel) + ",":U + STRING(ocorrencia.cd-serie) + ",":U + STRING(ocorrencia.nr-docto,"9999999")
                   tt-ocorrencia.chave-integracao-ocorrencia  = STRING(estabelec.cod-estabel)  + ",":U + STRING(ocorrencia.nr-ocorrencia).

        END.*/


    END.
    ELSE DO:
        bk-pedido:
/*         FOR EACH  nota-fiscal NO-LOCK                   */
/*             WHERE nota-fiscal.cod-estabel = "101"       */
/*             AND   nota-fiscal.serie = "7"               */
/*             AND   nota-fiscal.nr-nota-fis = "0150475 ": */
/*             MESSAGE nota-fiscal.nr-nota-fis             */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.      */

        FOR EACH  nota-fiscal NO-LOCK USE-INDEX ch-distancia
            WHERE nota-fiscal.dt-emis-nota >= tt-param-mov.dt-ini-nota
            AND   nota-fiscal.dt-emis-nota <= tt-param-mov.dt-fim-nota:

            RUN piEnviaNotaFiscal IN THIS-PROCEDURE (INPUT  pEntidadeNF,
                                                     INPUT  pEntidadeItemNF,
                                                     OUTPUT iContaLinhasTraceNF,
                                                     OUTPUT iContaLinhasTraceItemNF,
                                                     OUTPUT iContaLinhasTraceOcor,
                                                     OUTPUT iContaLinhasTraceDuplic).

            ASSIGN pContaLinhasTraceNF     = pContaLinhasTraceNF     + iContaLinhasTraceNF
                   pContaLinhasTraceItemNF = pContaLinhasTraceItemNF + iContaLinhasTraceItemNF
                   pContaLinhasTraceOcor   = pContaLinhasTraceOcor   + iContaLinhasTraceOcor
                   pContaLinhasTraceDuplic = pContaLinhasTraceDuplic + iContaLinhasTraceDuplic.
        END.

    END.


    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piCarregaCep:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
     
    /******************************* Desabilitar por enquanto ******** 
     
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    
      FOR EACH cep NO-LOCK :

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "CEP: ":U + STRING(cep.cep)).
                
        empty temp-table tt-cep-atu.
        create tt-cep-atu.
        buffer-copy cep to tt-cep-atu.
         
        {esp/crm/escrm001a.i "CEP"}

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidade,
                                  INPUT  cevento,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-cep:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-cep.
        empty temp-table tt-cep-atu.
    END.
    
    
    
    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
        
    *********************************************/    
END PROCEDURE.

/*
*/
PROCEDURE piIncluirAlterarCliente:
    DEFINE INPUT  PARAMETER pEntidade         AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pRowid            AS ROWID       NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.
    
    /* Carregar primeiro as matrizes, ... */

    FOR EACH emitente NO-LOCK WHERE 
        ROWID(emitente) = pRowid:
     
        {esp/crm/escrm001cliente.i}
    END.

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
END PROCEDURE.

PROCEDURE piRetornaCliente:
    DEFINE INPUT  PARAMETER pEntidade AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST param-global NO-LOCK NO-ERROR.
   
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
 
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).
   
    RUN piConnection.

    RUN readIntegrationLogFromCRM (INPUT pEntidade,
                                   OUTPUT TABLE tt-integrationLog,
                                   OUTPUT TABLE RowErrors).

    RUN piAtualizaCliente (INPUT pEntidade,
                           INPUT-OUTPUT pContaLinhasTrace,
                           INPUT-OUTPUT TABLE rowerrors).


    RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piRecebeIntegration: /* recebe temptable do integration quando chamado via webservice online */ 
    DEFINE INPUT PARAMETER        pEntidade AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-integrationLog.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    RUN readIntegrationLogFromCRM (INPUT pEntidade,
                                   OUTPUT TABLE tt-integrationLog,
                                   OUTPUT TABLE RowErrors).

    RUN piAtualizaCliente (INPUT pEntidade,
                           INPUT-OUTPUT pContaLinhasTrace,
                           INPUT-OUTPUT TABLE rowerrors).
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piAtualizaCliente:
    DEFINE INPUT  PARAMETER pEntidade AS CHARACTER   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE tt-versao-integr.

    CREATE tt-versao-integr.
    ASSIGN tt-versao-integr.cod-versao-integracao = 001.
                     
    bk-integrationLog:
    FOR EACH tt-integrationLog:
        EMPTY TEMP-TABLE tt-atributo-entrada.
        EMPTY TEMP-TABLE tt-cliente.
        EMPTY TEMP-TABLE tt-cliente-valid.
        EMPTY TEMP-TABLE tt-loc-entr-valid.
        EMPTY TEMP-TABLE tt-dist-emit-valid.
        EMPTY TEMP-TABLE tt-erros-geral.
        empty temp-table tt-erros-crm.
                                                 
        CREATE tt-cliente.
                
        RUN readXML (INPUT BUFFER tt-cliente:HANDLE,
                     INPUT tt-integrationLog.cMessage,
                     OUTPUT TABLE tt-atributo-entrada).        
                   
        FIND FIRST tt-cliente NO-ERROR.
        
        IF AVAILABLE tt-cliente             
        THEN DO:     
                                       
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Emitente: ":U + STRING(tt-cliente.cod-emitente)).

            ASSIGN tt-cliente.address1_addresstypecode = 3
                   tt-cliente.address1_name            = "Principal":U
                   tt-cliente.address2_addresstypecode = 200000
                   tt-cliente.address2_name            = "Cobranáa":U
                   tt-cliente.new_exporta_erp          = "":U
                   tt-cliente.new_mensagem             = "":U.
                           
            CREATE tt-cliente-valid.
                                   
            FIND FIRST emitente WHERE 
                       emitente.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE emitente 
            THEN DO:
               if tt-integrationLog.action <> "d":U
               then do:             
                                 
                 FIND FIRST emitente WHERE 
                            emitente.nome-abrev = tt-cliente.nome-abrev NO-LOCK NO-ERROR.
                 IF AVAILABLE emitente 
                 THEN DO:
                  
                    ASSIGN tt-cliente.cod-emitente          = ?
                           tt-cliente.new_status_integracao = "N∆o integrado.":U                           
                           tt-cliente.new_mensagem          = "Erro: nome abreviado j† existe no sistema. Erro na integraá∆o CRM com ERP (Tabela emitente).":U.

                    RUN UpdateIntegrationLogStatus (INPUT  tt-integrationLog.logId,
                                                    INPUT  3,
                                                    INPUT  tt-cliente.new_mensagem,
                                                    OUTPUT TABLE RowErrors).

                    EMPTY TEMP-TABLE tt-atributo.
    
                    FOR EACH tt-atributo-entrada:
                        CREATE tt-atributo.
                        ASSIGN tt-atributo.r-temp-table = ROWID(tt-cliente)
                               tt-atributo.nome-campo   = tt-atributo-entrada.nome-pai
                               tt-atributo.nome-atrib   = tt-atributo-entrada.nome
                               tt-atributo.vl-atrib     = tt-atributo-entrada.valor.
                    END.
    
                    RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                              INPUT  tt-integrationlog.entity,
                                              INPUT  "W":U,
                                              INPUT  "0":U,
                                              INPUT  BUFFER tt-cliente:HANDLE,
                                              INPUT  TABLE tt-atributo,
                                              OUTPUT TABLE RowErrors).                                                 
                    NEXT bk-integrationLog.                   

                 END.
                 else do:
                    find first gr-cli no-lock where
                               gr-cli.cod-gr-cli   = tt-cliente.cod-gr-cli no-error.
                     if avail gr-cli then 
                        assign tt-cliente-valid.modalidade  = gr-cli.modalidade
                               tt-cliente-valid.portador    = gr-cli.portador
                               tt-cliente-valid.mod-prefer  = gr-cli.modalidade
                               tt-cliente-valid.port-prefer = gr-cli.portador.    
                 end.

                 FIND LAST emitente NO-LOCK NO-ERROR.

                 IF AVAILABLE emitente 
                 THEN DO:
                     /* Busca o proximo cliente valido */

                     run cdp/cd9960.p (output p-prox-emitente).

                     ASSIGN tt-cliente.cod-emitente = p-prox-emitente.
                     
                 END.
                 ELSE
                     ASSIGN tt-cliente.cod-emitente = 0.                 
     
                 ASSIGN tt-cliente-valid.ind-tipo-movto = 1.
               end.  
            END.
            ELSE DO:
                                        
                BUFFER-COPY emitente except cod-emitente TO tt-cliente-valid .
                                  
                if tt-integrationLog.action = "d" then
                  ASSIGN tt-cliente-valid.ind-tipo-movto = 3. /* Eliminacao */                   
                else       
                  ASSIGN tt-cliente-valid.ind-tipo-movto = 2.
            END.

            ASSIGN tt-cliente-valid.endereco = "":U.

            IF tt-cliente.endereco <> "":U THEN
                ASSIGN tt-cliente-valid.endereco = tt-cliente.endereco.

            IF tt-cliente.new_numero_endereco_principal <> "":U THEN DO:
                IF tt-cliente-valid.endereco <> "":U THEN
                    ASSIGN tt-cliente-valid.endereco = tt-cliente-valid.endereco + ", ":U + tt-cliente.new_numero_endereco_principal.
                ELSE
                    ASSIGN tt-cliente-valid.endereco = tt-cliente.new_numero_endereco_principal.
            END.

            IF tt-cliente.address1_line2 <> "":U THEN DO:
                IF tt-cliente-valid.endereco <> "":U THEN
                    ASSIGN tt-cliente-valid.endereco = tt-cliente-valid.endereco + " - ":U + tt-cliente.address1_line2.
                ELSE
                    ASSIGN tt-cliente-valid.endereco = tt-cliente.address1_line2.
            END.

            ASSIGN tt-cliente-valid.endereco-cob = "":U.

            IF tt-cliente.endereco-cob <> "":U THEN
                ASSIGN tt-cliente-valid.endereco-cob = tt-cliente.endereco-cob.

            IF tt-cliente.new_numero_endereco_cobranca <> "":U THEN DO:
                IF tt-cliente-valid.endereco-cob <> "":U THEN
                    ASSIGN tt-cliente-valid.endereco-cob = tt-cliente-valid.endereco-cob + ", ":U + tt-cliente.new_numero_endereco_cobranca.
                ELSE
                    ASSIGN tt-cliente-valid.endereco-cob = tt-cliente.new_numero_endereco_cobranca.
            END.

            IF tt-cliente.address2_line2 <> "":U THEN DO:
                IF tt-cliente-valid.endereco-cob <> "":U THEN
                    ASSIGN tt-cliente-valid.endereco-cob = tt-cliente-valid.endereco-cob + " - ":U + tt-cliente.address2_line2.
                ELSE
                    ASSIGN tt-cliente-valid.endereco-cob = tt-cliente.address2_line2.
            END.

            ASSIGN tt-cliente-valid.cod-emitente            = tt-cliente.cod-emitente
                   tt-cliente-valid.nome-emit               = tt-cliente.nome-emit
                   tt-cliente-valid.nome-abrev              = tt-cliente.nome-abrev
                   tt-cliente-valid.identific               = tt-cliente.identific                   
                   tt-cliente-valid.cep                     = REPLACE(tt-cliente.cep, "-":U, "":U)
                   tt-cliente-valid.bairro                  = tt-cliente.bairro
                   tt-cliente-valid.cidade                  = tt-cliente.cidade
                   tt-cliente-valid.estado                  = tt-cliente.estado
                   tt-cliente-valid.pais                    = tt-cliente.pais
                   tt-cliente-valid.cep-cob                 = REPLACE(tt-cliente.cep-cob, "-":U, "":U)
                   tt-cliente-valid.end-cobranca            = tt-cliente.cod-emitente
                   tt-cliente-valid.bairro-cob              = tt-cliente.bairro-cob  
                   tt-cliente-valid.cidade-cob              = tt-cliente.cidade-cob  
                   tt-cliente-valid.estado-cob              = tt-cliente.estado-cob  
                   tt-cliente-valid.pais-cob                = tt-cliente.pais-cob    
                   tt-cliente-valid.telefone[1]             = tt-cliente.telephone   
                   tt-cliente-valid.ramal[1]                = tt-cliente.ramal       
                   tt-cliente-valid.telefone[2]             = tt-cliente.telephone2  
                   tt-cliente-valid.ramal[2]                = tt-cliente.ramal2      
                   tt-cliente-valid.telefax                 = tt-cliente.fax         
                   tt-cliente-valid.ramal-fax               = tt-cliente.ramalfax    
                   tt-cliente-valid.e-mail                  = tt-cliente.email       
                   tt-cliente-valid.home-page               = tt-cliente.home-page
                   tt-cliente-valid.cod-rep                 = 1 /*tt-cliente.cod-rep*/
                   tt-cliente-valid.natureza                = tt-cliente.natureza    
                   tt-cliente-valid.ins-municipal           = tt-cliente.ins-municipal  
                   tt-cliente-valid.cod-gr-cli              = tt-cliente.cod-gr-cli          
                   tt-cliente-valid.contrib-icms            = tt-cliente.contrib-icms   
                   tt-cliente-valid.cod-suframa             = tt-cliente.cod-suframa    
                   tt-cliente-valid.cod-transp              = tt-cliente.cod-transp
                   tt-cliente-valid.nome-tr-red             = tt-cliente.nome-tr-red
                   tt-cliente-valid.cod-canal-venda         = tt-cliente.cod-canal-venda
                   tt-cliente-valid.insc-subs-trib          = tt-cliente.insc-subs-trib
                   OVERLAY(tt-cliente-valid.char-1,  21, 1) = IF tt-cliente.i-susp-ipi             THEN "2":U ELSE "1":U
                   tt-cliente-valid.agente-retencao         = tt-cliente.agente-retencao
                   OVERLAY(tt-cliente-valid.char-1,  29, 1) = IF tt-cliente.i-calc-pis-cofins-unid THEN "S":U ELSE "N":U
                   OVERLAY(tt-cliente-valid.char-1, 100, 1) = IF tt-cliente.i-recebe-nfe           THEN "1":U ELSE "0":U                   
                   tt-cliente-valid.data-implant            = tt-cliente.data-implant
                   tt-cliente-valid.cgc-cob                 = tt-cliente.cgc
                   tt-cliente-valid.ins-est-cob             = tt-cliente.ins-estadual
                   pContaLinhasTrace                        = pContaLinhasTrace + 1.
                            
                         
             DO i-cont = 1 TO 2:

                 ASSIGN tt-cliente-valid.telefone[i-cont] = REPLACE(tt-cliente-valid.telefone[i-cont],"(","")
                        tt-cliente-valid.telefone[i-cont] = REPLACE(tt-cliente-valid.telefone[i-cont],") ","")
                        tt-cliente-valid.telefone[i-cont] = REPLACE(tt-cliente-valid.telefone[i-cont],"-","").
             END.       

             ASSIGN tt-cliente-valid.telefax = REPLACE(tt-cliente-valid.telefax,"(","")
                    tt-cliente-valid.telefax = REPLACE(tt-cliente-valid.telefax,") ","")
                    tt-cliente-valid.telefax = REPLACE(tt-cliente-valid.telefax,"-","").

             FIND FIRST loc-entr WHERE 
                        loc-entr.nome-abrev  = tt-cliente.nome-abrev AND 
                        loc-entr.cod-entrega = "Padr∆o":U NO-LOCK NO-ERROR.  
             IF NOT AVAIL loc-entr THEN
                ASSIGN tt-cliente-valid.cod-entrega = "Padr∆o".    

            /* Campos que devem integrar EMS/CRM mas nao podem ser enviados do CRM/EMS */
 
            if avail emitente then 
            assign tt-cliente-valid.lim-credito             = emitente.lim-credito    
                   tt-cliente-valid.dt-lim-cred             = emitente.dt-lim-cred 
                   tt-cliente-valid.modalidade              = emitente.modalidade
                   tt-cliente-valid.portador                = emitente.portador
                   tt-cliente-valid.cod-banco               = emitente.cod-banco
                   tt-cliente-valid.agencia                 = emitente.agencia
                   tt-cliente-valid.conta-corren            = emitente.conta-corren
                   tt-cliente-valid.tp-rec-padrao           = emitente.tp-rec-padrao
                   tt-cliente-valid.cod-cond-pag            = emitente.cod-cond-pag
                   tt-cliente-valid.emite-bloq              = emitente.emite-bloq
                   tt-cliente-valid.gera-ad                 = emitente.gera-ad
                   tt-cliente-valid.calcula-multa           = emitente.calcula-multa
                   tt-cliente-valid.recebe-inf-sci          = emitente.recebe-inf-sci.             
         
            IF tt-cliente.nome-matriz = ? OR 
               tt-cliente.nome-matriz = 0 OR 
               tt-cliente.nome-matriz = -1 THEN
                ASSIGN tt-cliente-valid.nome-matriz = tt-cliente.nome-abrev.
            ELSE DO:
                FIND FIRST b-emitente
                    WHERE b-emitente.cod-emitente = tt-cliente.nome-matriz NO-LOCK NO-ERROR.

                IF AVAILABLE b-emitente THEN
                    ASSIGN tt-cliente-valid.nome-matriz = b-emitente.nome-abrev.
                ELSE
                    ASSIGN tt-cliente-valid.nome-matriz = tt-cliente.nome-abrev.                   
                    
            END.  

            FIND FIRST b-emitente NO-LOCK
                 WHERE b-emitente.nome-abrev  = tt-cliente-valid.nome-matriz
                   AND b-emitente.nome-abrev <> tt-cliente-valid.nome-abrev NO-ERROR.
 
             IF AVAIL b-emitente THEN DO:
                 ASSIGN tt-cliente-valid.port-prefer = b-emitente.port-prefer
                        tt-cliente-valid.mod-prefer  = b-emitente.mod-prefer.
             END.
            
            CASE tt-cliente.natureza:
                WHEN 1 THEN DO:
                    ASSIGN tt-cliente-valid.cgc          = REPLACE(REPLACE(tt-cliente.new_cpf, ".":U, "":U), "-":U, "":U)
                           tt-cliente-valid.ins-estadual = tt-cliente.ins-estadual.
                END.
                WHEN 2 THEN DO:
                    ASSIGN tt-cliente-valid.cgc          = REPLACE(REPLACE(REPLACE(tt-cliente.cgc, ".":U, "":U), "-":U, "":U), "~/":U, "":U)
                           tt-cliente-valid.ins-estadual = tt-cliente.ins-estadual.
                END.
                OTHERWISE DO:
                    ASSIGN tt-cliente-valid.cgc          = tt-cliente.cgc
                           tt-cliente-valid.ins-estadual = tt-cliente.ins-estadual.
                END.
            END CASE.
                        
            /* Atualiza campos para mandar para o xml */
                       
            assign tt-cliente.lim-credito    = tt-cliente-valid.lim-credito                
                   tt-cliente.dt-lim-cred    = tt-cliente-valid.dt-lim-cred             
                   tt-cliente.modalidade     = tt-cliente-valid.modalidade        
                   tt-cliente.portador       = tt-cliente-valid.portador        
                   tt-cliente.cod-banco      = tt-cliente-valid.cod-banco        
                   tt-cliente.agencia        = tt-cliente-valid.agencia        
                   tt-cliente.conta-corren   = tt-cliente-valid.conta-corren        
                   tt-cliente.tp-rec-padrao  = tt-cliente-valid.tp-rec-padrao                        
                   tt-cliente.cod-cond-pag   = string(tt-cliente-valid.cod-cond-pag)         
                   tt-cliente.emite-bloq     = tt-cliente-valid.emite-bloq        
                   tt-cliente.gera-ad        = tt-cliente-valid.gera-ad       
                   tt-cliente.calcula-multa  = tt-cliente-valid.calcula-multa        
                   tt-cliente.recebe-inf-sci = tt-cliente-valid.recebe-inf-sci
                   tt-cliente.cgc            = tt-cliente-valid.cgc          
                   tt-cliente.ins-estadual   = tt-cliente-valid.ins-estadual.                   
            
            FIND FIRST b-emitente  WHERE 
                       b-emitente.cod-emitente = tt-cliente.nome-matriz NO-LOCK NO-ERROR.

            IF AVAILABLE b-emitente THEN
               ASSIGN tt-cliente.nome-matriz = b-emitente.cod-emitente.
                                                
            /*Tarefa 2171: grupo 26 - BNDES seja parametrizado para n∆o enviar a cart¢rio.*/
            IF tt-cliente-valid.cod-gr-cli = 26 THEN
                ASSIGN tt-cliente-valid.ins-banc = 7.


            /* ALTERACAO SOLICITADA POR ANDRE ANDRESEN EM 10/04/11 */
            IF tt-cliente-valid.cod-gr-cli = 30 THEN
                ASSIGN tt-cliente-valid.ind-cre-cli = 1
                       tt-cliente-valid.observacoes = "Liberado sem avaliaá∆o de crÇdito para p¢s venda"
                       tt-cliente-valid.lim-credito = 0 .   /* novos clientes Embratel entra com Automatico */
                       tt-cliente-valid.dt-lim-cred = 01/01/90.




            /* ALTERACAO SOLICITADA POR ANDRE ANDRESEN EM 10/04/11 */
/*             IF tt-cliente-valid.cod-gr-cli = 5 THEN                                                           */
/*                 ASSIGN tt-cliente-valid.ind-cre-cli = 2.   /* novos clientes Embratel entra com Automatico */ */
/*             ELSE IF tt-cliente-valid.cod-gr-cli = 8 OR tt-cliente-valid.cod-gr-cli = 18                       */
/*             THEN                                                                                              */
/*                ASSIGN tt-cliente-valid.ind-cre-cli = 1.   /* novos clientes Embratel entra com Automatico */  */
/*                                                                                                               */
/*             ELSE                                                                                              */
/*                ASSIGN tt-cliente-valid.ind-cre-cli = 4.   /* novos clientes ficam com credito suspenso */     */
                                                     
            if tt-cliente-valid.ind-tipo-movto <> 3
            then do:
                
                assign i-seq-erro = 1.
                               
                for last tt-erros-crm by tt-erros-crm.num-sequencia-erro:
                    assign i-seq-erro = tt-erros-crm.num-sequencia-erro + 1.
                end.    
                                                                          
                RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
                RUN pi-trata-endereco IN h-cdapi704 (INPUT  tt-cliente-valid.endereco,
                                                     OUTPUT c-rua, 
                                                     OUTPUT c-nro, 
                                                     OUTPUT c-comp). 
                DELETE PROCEDURE h-cdapi704.
                IF c-nro = "" THEN DO:
                     create tt-erros-crm.
                     assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                            tt-erros-crm.cod-erro           = 1000
                            tt-erros-crm.tipo               = 1  
                            tt-erros-crm.des-erro           = "Cliente com endereáo sem numero, favor informar o numero no endereáo do cliente"
                            i-seq-erro                      = i-seq-erro + 1.              
                     
                END.
      
                IF length(trim(c-comp)) = 1 
                THEN DO:
                   create tt-erros-crm.
                   assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                          tt-erros-crm.cod-erro           = 1001
                          tt-erros-crm.tipo               = 1 
                          tt-erros-crm.des-erro           = "Complemento do Endereco apenas com uma posiá∆o, SEFAZ exige que tenha mais de uma posiá∆o"
                          i-seq-erro                      = i-seq-erro + 1.            
                END.
                        
                IF tt-cliente-valid.natureza = 2 /* Pessoa Juridica */
                THEN DO: 
                    IF tt-cliente-valid.ins-estadual = "isento" AND 
                       tt-cliente-valid.contrib-icms = YES  
                    THEN DO:
                       create tt-erros-crm.
                       assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                              tt-erros-crm.cod-erro           = 1002
                              tt-erros-crm.tipo               = 1
                              tt-erros-crm.des-erro           = "Cliente n∆o possui inscriá∆o estadual e esta marcado o campo Contribuinte ICMS."
                              i-seq-erro                      = i-seq-erro + 1.            
                    END.
    
                    IF tt-cliente-valid.ins-estadual <> "isento" AND 
                       NOT tt-cliente-valid.contrib-icms = YES  
                    THEN DO:
                       create tt-erros-crm.
                       assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                              tt-erros-crm.cod-erro           = 1003
                              tt-erros-crm.tipo               = 1
                              tt-erros-crm.des-erro           = "Cliente possui inscriá∆o estadual e n∆o esta marcado o campo Contribuinte ICMS."
                              i-seq-erro                      = i-seq-erro + 1.            
                    END.
                END.

                IF tt-cliente-valid.natureza <> 2 OR
                   tt-cliente-valid.cod-gr-cli = 5 
                THEN DO:
                   IF tt-cliente.ind-forma-tributo <> 4 
                   THEN DO:
                      create tt-erros-crm.
                      assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                             tt-erros-crm.cod-erro           = 1004
                             tt-erros-crm.tipo               = 1
                             tt-erros-crm.des-erro           = "Para Pessoa Fisica ou Exportaá∆o ou grupo 5 Informe a forma de tributacao 4," + 
                                                               "qualquer duvida entre em contato com a controladoria"
                             i-seq-erro                      = i-seq-erro + 1.            
                   END.
                END.
                ELSE DO:
                  IF (tt-cliente.ind-forma-tributo = 0 OR
                      tt-cliente.ind-forma-tributo = 4) 
                  THEN do:
                      create tt-erros-crm.
                      assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                             tt-erros-crm.cod-erro           = 1005
                             tt-erros-crm.tipo               = 1
                             tt-erros-crm.des-erro           = "Informe a forma de tributacao para vendas de Manaus, " + 
                                                               "qualquer duvida entre em contato com a controladoria"
                             i-seq-erro                      = i-seq-erro + 1.            
                  END.
                END.
                 
                /*** Valida CGC/CPF Cliente ***/

                IF NOT CAN-FIND(tt-erros-crm WHERE 
                                tt-erros-crm.tipo = 1) 
                THEN DO:
                    RUN esp/cdp/escdp027.p (INPUT  tt-cliente-valid.cgc       ,
                                            INPUT  tt-cliente-valid.natureza  ,
                                            OUTPUT TABLE tt-erros-geral).                
        
                    FOR EACH tt-erros-geral WHERE
                             tt-erros-geral.identif-msg = "1" :
                         
                        create tt-erros-crm.
                        assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                               tt-erros-crm.tipo               = 1
                               tt-erros-crm.cod-erro           = tt-erros-geral.cod-erro
                               tt-erros-crm.des-erro           = tt-erros-geral.des-erro
                               i-seq-erro                      = i-seq-erro + 1.            
                               
                    END.
                END.

                IF NOT CAN-FIND(tt-erros-crm WHERE 
                                tt-erros-crm.tipo = 1) AND
                   tt-cliente-valid.natureza = 2       AND
                   tt-cliente-valid.ins-estadual <> "ISENTO"
                THEN DO:
                   run cdp/cd6667.p(Input  tt-cliente-valid.pais,
                                    Input  tt-cliente-valid.estado,
                                    Input  tt-cliente-valid.ins-estadual,
                                    Output c-cod-erro,
                                    Output c-cod-ie-sai).
                   assign c-des-msg = " ".                 
                   case c-cod-erro:                             
                        when "ERRO FORMATO" then 
                           assign c-des-msg = "Erro no formato da I.E".
                        when "ERRO PRIM DIG" then 
                           assign c-des-msg = "UF tem dig. fixos nao inform. na IE".
                        when "ERRO DV" then
                           assign c-des-msg = "Digito verificador da I.E. Invalido".
                    end.

                    IF c-des-msg <> " " 
                    THEN DO:
                       create tt-erros-crm.
                       assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                              tt-erros-crm.cod-erro           = 1006
                              tt-erros-crm.tipo               = 1
                              tt-erros-crm.des-erro           = c-des-msg
                              i-seq-erro                      = i-seq-erro + 1.
                    END.
                END.
                
                EMPTY TEMP-TABLE tt-erros-geral.

            END.
                         
            if not can-find(first tt-erros-crm WHERE
                                  tt-erros-crm.tipo = 1)
            then do:           
               
                bloco_trans:
                DO  ON ERROR UNDO bloco_trans, LEAVE bloco_trans:

                    EMPTY TEMP-TABLE tt-versao-integr.
                    CREATE tt-versao-integr.
                    ASSIGN tt-versao-integr.cod-versao-integracao = 001.

                    RUN cdp/cdapi329.p (INPUT  TABLE tt-versao-integr,
                                        OUTPUT TABLE tt-erros-geral,
                                        INPUT  TABLE tt-cliente-valid,
                                        INPUT  TABLE tt-loc-entr-valid,
                                        INPUT  TABLE tt-dist-emit-valid).           

                   for each tt-erros-geral:

                     create tt-erros-crm.
                     buffer-copy tt-erros-geral to tt-erros-crm.
                    end.

                    IF CAN-FIND(FIRST tt-erros-geral) THEN UNDO bloco_trans.  
             
                END.

                for each tt-erros-crm WHERE
                         tt-erros-crm.tipo = 1  :

                   create tt-erros-geral.
                   buffer-copy tt-erros-crm to tt-erros-geral.
                end.

            end.
            else do:
               for each tt-erros-crm WHERE
                        tt-erros-crm.tipo = 1 :

                   create tt-erros-geral.
                   buffer-copy tt-erros-crm to tt-erros-geral.

               end.             
            end.
                       
              
            IF CAN-FIND(FIRST tt-erros-geral) 
            THEN DO:
                
                FOR EACH tt-erros-geral:
                    CREATE RowErrors.
                    ASSIGN RowErrors.errorsequence    = tt-erros-geral.num-sequencia-erro
                           RowErrors.errornumber      = tt-erros-geral.cod-erro
                           RowErrors.errordescription = tt-erros-geral.des-erro
                           RowErrors.errorparameters  = "Custom":U
                           RowErrors.errortype        = "Error":U
                           RowErrors.errorhelp        = "Erro na integraá∆o CRM com ERP. (Tabela emitente).":U
                           RowErrors.errorsubtype     = "Custom":U
                           c-erro                     = STRING(tt-erros-geral.des-erro) + " (":U + STRING(tt-erros-geral.cod-erro) + ") - ":U.
                END.
                 
                if tt-integrationLog.action = "C" then 
                   assign tt-cliente.cod-emitente = ?. 
                 
                ASSIGN tt-cliente.new_status_integracao = "N∆o integrado.":U
                       tt-cliente.new_mensagem          = "Erro: ":U + c-erro + ". Erro na integraá∆o CRM com ERP (Tabela emitente).":U.

                RUN UpdateIntegrationLogStatus (INPUT  tt-integrationLog.logId,
                                                INPUT  3,
                                                INPUT tt-cliente.new_mensagem,
                                                OUTPUT TABLE RowErrors).                

                EMPTY TEMP-TABLE tt-atributo.

                FOR EACH tt-atributo-entrada:
                    CREATE tt-atributo.
                    ASSIGN tt-atributo.r-temp-table = ROWID(tt-cliente)
                           tt-atributo.nome-campo   = tt-atributo-entrada.nome-pai
                           tt-atributo.nome-atrib   = tt-atributo-entrada.nome
                           tt-atributo.vl-atrib     = tt-atributo-entrada.valor.
                END.

                RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                          INPUT  tt-integrationlog.entity,
                                          INPUT  tt-integrationLog.action,
                                          INPUT  "0":U,
                                          INPUT  BUFFER tt-cliente:HANDLE,
                                          INPUT  TABLE tt-atributo,
                                          OUTPUT TABLE RowErrors).

                EMPTY TEMP-TABLE tt-atributo.
    
                NEXT bk-integrationLog.                

            END.
            else do:
               /**** Grava o cod-suframa e insc-subs-trib, a api da datasul n∆o grava esses campos ****/
               
               if tt-cliente-valid.ind-tipo-movto <> 3
               then do:               
                  find first emitente exclusive-lock where  
                             emitente.cod-emitente = tt-cliente.cod-emitente no-error.
                  if avail emitente 
                  then do: 
                    assign emitente.cod-suframa    = tt-cliente.cod-suframa
                           emitente.insc-subs-trib = tt-cliente.insc-subs-trib
                           emitente.nome-matriz    = tt-cliente-valid.nome-matriz.  
                  end.  
               end. 
            end.
                        
            if tt-cliente-valid.ind-tipo-movto <> 3
            then do:                    
                    IF tt-cliente.cod-emitente = ? 
                    THEN DO:
                         FIND FIRST b-emitente  WHERE 
                                    b-emitente.nome-abrev = tt-cliente.nome-abrev NO-LOCK NO-ERROR.
                
                            IF AVAILABLE b-emitente THEN
                                ASSIGN tt-cliente.cod-emitente = b-emitente.cod-emitente.
                    end.
                                   
                    FOR EACH tt-atributo-entrada  WHERE 
                             tt-atributo-entrada.tipo = "atributo":U:
                                 
                        IF tt-atributo-entrada.nome = "crmid":U 
                        THEN DO:
                            CASE tt-atributo-entrada.nome-pai:
                                WHEN "cod-emitente":U THEN DO:
                                    FIND FIRST int-emitente
                                        WHERE int-emitente.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
            
                                    IF AVAILABLE int-emitente THEN
                                        ASSIGN int-emitente.vl-guid = tt-atributo-entrada.valor.
                                    ELSE DO:
                                        CREATE int-emitente.
                                        ASSIGN int-emitente.cod-emitente = tt-cliente.cod-emitente
                                               int-emitente.vl-guid      = tt-atributo-entrada.valor.
                                    END.
                                    
                                    FIND FIRST int-emitente-cex WHERE 
                                               int-emitente-cex.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
                                            
                                    IF NOT AVAILABLE int-emitente-cex 
                                    THEN do:
                                        CREATE int-emitente-cex.
                                        ASSIGN int-emitente-cex.cod-emitente = tt-cliente.cod-emitente.
                                    END.
            
                                END.
                                WHEN "nome-matriz":U THEN DO:
                                    FIND FIRST int-emitente
                                        WHERE int-emitente.cod-emitente = tt-cliente.nome-matriz EXCLUSIVE-LOCK NO-ERROR.
            
                                    IF AVAILABLE int-emitente THEN
                                        ASSIGN int-emitente.vl-guid = tt-atributo-entrada.valor.
                                    ELSE DO:
                                        CREATE int-emitente.
                                        ASSIGN int-emitente.cod-emitente = tt-cliente.cod-emitente
                                               int-emitente.vl-guid      = tt-atributo-entrada.valor.
                                    END.
                                    
                                    FIND FIRST int-emitente-cex WHERE 
                                               int-emitente-cex.cod-emitente = tt-cliente.nome-matriz EXCLUSIVE-LOCK NO-ERROR.
                                    
                                    IF NOT AVAILABLE int-emitente-cex 
                                    THEN do:
                                        CREATE int-emitente-cex.
                                        ASSIGN int-emitente-cex.cod-emitente = tt-cliente.nome-matriz.
                                    END.
                                END.
                            END CASE.
                        END.
                    END.
                    
                    FIND FIRST int-emitente WHERE 
                               int-emitente.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE int-emitente THEN DO:
                       ASSIGN int-emitente.vl-desconto-cat   = tt-cliente.vl-desconto-cat
                              int-emitente.tipo-embalagem    = tt-cliente.tipo-embalagem
                              int-emitente.observacao-ped    = tt-cliente.observacao-ped
                              int-emitente.dispositivo-legal = tt-cliente.dispositivo-legal
                              int-emitente.dt-vcto-concessao = tt-cliente.dt-vcto-concessao
                              int-emitente.ind-forma-tributo = tt-cliente.ind-forma-tributo
                              int-emitente.ind-vendas-alc    = IF tt-cliente.ind-vendas-alc THEN 1 /* YES */ ELSE 0 /* NO */
                              int-emitente.logradouro        = tt-cliente.endereco                         
                              int-emitente.numero            = tt-cliente.new_numero_endereco_principal    
                              int-emitente.complemento       = tt-cliente.address1_line2.                  
          
                       IF tt-cliente.id-ativo = 1 THEN
                          ASSIGN int-emitente.id-ativo = YES.
                       ELSE 
                          ASSIGN int-emitente.id-ativo = no.
                    END.

                    FIND FIRST int-emitente-cex WHERE 
                               int-emitente-cex.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
                    if not avail int-emitente-cex
                    then do:
                       CREATE int-emitente-cex.
                       ASSIGN int-emitente-cex.cod-emitente = tt-cliente.cod-emitente.              
                    end.                    
                    
                    IF AVAILABLE int-emitente-cex THEN
                        ASSIGN int-emitente-cex.local-embarque  = tt-cliente.local-embarque
                               int-emitente-cex.embarque-via    = tt-cliente.embarque-via.
                    
                    find emitente-cex where 
                         emitente-cex.cod-emitente = tt-cliente.cod-emitente exclusive-lock no-error.
                    if not avail emitente-cex 
                    then do:
                       create emitente-cex.
                       assign emitente-cex.cod-emitente = tt-cliente.cod-emitente.
                    end.
                    
                    assign emitente-cex.cod-incoterm-exp = tt-cliente.cod-incoterm-exp.

                    FIND FIRST int-emitente-b2c
                        WHERE int-emitente-b2c.cod-emitente = tt-cliente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.

                    IF NOT AVAILABLE int-emitente-b2c THEN DO:
                        CREATE int-emitente-b2c.
                        ASSIGN int-emitente-b2c.cod-emitente = tt-cliente.cod-emitente.
                    END.

                    ASSIGN int-emitente-b2c.Newsletter = IF tt-cliente.donotsendmm THEN "Sim":U ELSE "N∆o":U.
          
                    FIND FIRST loc-entr WHERE 
                               loc-entr.nome-abrev  = tt-cliente.nome-abrev AND 
                               loc-entr.cod-entrega = "Padr∆o":U EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE loc-entr THEN DO:
                        CREATE loc-entr.
                        ASSIGN loc-entr.nome-abrev   = tt-cliente.nome-abrev
                               loc-entr.cod-entrega  = "Padr∆o":U
                               loc-entr.endereco     = substring(tt-cliente.endereco,1,40)
                               loc-entr.bairro       = tt-cliente.bairro
                               loc-entr.cidade       = tt-cliente.cidade
                               loc-entr.estado       = tt-cliente.estado
                               loc-entr.cep          = REPLACE(tt-cliente.cep, "-":U, "":U)
                               loc-entr.pais         = tt-cliente.pais
                               loc-entr.cgc          = tt-cliente.cgc
                               loc-entr.ins-estadual = tt-cliente.ins-estadual
                               loc-entr.e-mail       = tt-cliente.email.
                    END.
                    
                    FIND FIRST transporte NO-LOCK WHERE
                               transporte.cod-transp = tt-cliente.cod-transp NO-ERROR.
                    IF AVAIL transporte THEN
                       ASSIGN loc-entr.nome-transp = transporte.nome-abrev.

                    FIND FIRST int-loc-entr
                        WHERE int-loc-entr.nome-abrev  = loc-entr.nome-abrev
                          AND int-loc-entr.cod-entrega = loc-entr.cod-entrega EXCLUSIVE-LOCK NO-ERROR.
        
                    IF NOT AVAILABLE int-loc-entr THEN DO:
                        CREATE int-loc-entr.
                        ASSIGN int-loc-entr.nome-abrev  = loc-entr.nome-abrev
                               int-loc-entr.cod-entrega = loc-entr.cod-entrega.
                    END.
        
                    ASSIGN int-loc-entr.endereco-completo = tt-cliente.endereco
                           int-loc-entr.logradouro        = tt-cliente.endereco
                           int-loc-entr.numero            = tt-cliente.new_numero_endereco_principal
                           int-loc-entr.complemento       = tt-cliente.address1_line2.
            end.
            
            ASSIGN tt-cliente.new_status_integracao = "Integrado com sucesso.":U.

            RUN UpdateIntegrationLogStatus (INPUT  tt-integrationLog.logId,
                                            INPUT  1,
                                            INPUT  tt-cliente.new_status_integracao,
                                            OUTPUT TABLE RowErrors).
          
            /*
                        
            FOR EACH tt-atributo-entrada:
                CREATE tt-atributo.
                ASSIGN tt-atributo.r-temp-table = ROWID(tt-cliente)
                       tt-atributo.nome-campo   = tt-atributo-entrada.nome-pai
                       tt-atributo.nome-atrib   = tt-atributo-entrada.nome
                       tt-atributo.vl-atrib     = tt-atributo-entrada.valor.
            END.


             RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                      INPUT  tt-integrationlog.entity,
                                      INPUT  if tt-integrationLog.action <> "D" then "W" else "D",
                                      INPUT  "0":U,
                                      INPUT  BUFFER tt-cliente:HANDLE,
                                      INPUT  TABLE tt-atributo,
                                      OUTPUT TABLE RowErrors).
            */
            
            EMPTY TEMP-TABLE tt-atributo.           
          
            
        END. /* if avail tt-cliente */
        
    END. /* for each bloco */

END PROCEDURE.

PROCEDURE piRetornaContato:
    DEFINE INPUT  PARAMETER pEntidade AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    RUN piConnection.

    RUN readIntegrationLogFromCRM (INPUT pEntidade,
                                   OUTPUT TABLE tt-integrationLog,
                                   OUTPUT TABLE RowErrors).
    
          
    FOR EACH tt-integrationLog:
        EMPTY TEMP-TABLE tt-cont-emit.
        empty temp-table tt-atributo-entrada. 
         
        CREATE tt-cont-emit.

        RUN readXML (INPUT BUFFER tt-cont-emit:HANDLE,
                     INPUT tt-integrationLog.cMessage,
                     OUTPUT TABLE tt-atributo-entrada).                      
       
        FIND FIRST tt-cont-emit NO-ERROR.

        IF AVAILABLE tt-cont-emit 
        THEN DO:
        
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Contato: ":U + STRING(tt-cont-emit.cod-emitente) + " - ":U + STRING(tt-cont-emit.sequencia)).
                        
            if tt-integrationLog.action <> "D"
            then do:             
                assign i-seq-contato = 10.
                
                for last cont-emit NO-LOCK where
                         cont-emit.cod-emitente = tt-cont-emit.cod-emitente 
                    by cont-emit.sequencia:
                       assign i-seq-contato = cont-emit.sequencia + 10.
                end.    
               
                find first tt-atributo-entrada where
                           tt-atributo-entrada.nome-pai = "new_chaveintegracao" no-error.
                if avail tt-atributo-entrada 
                then do:   
                    FIND FIRST int-cont-emit NO-LOCK WHERE
                               int-cont-emit.vl-guid = tt-atributo-entrada.valor NO-ERROR.
                    IF AVAIL int-cont-emit THEN
                       ASSIGN i-seq-contato = int-cont-emit.sequencia.
                end.   

                FIND FIRST cont-emit WHERE 
                           cont-emit.cod-emitente = tt-cont-emit.cod-emitente AND 
                           cont-emit.sequencia    = i-seq-contato EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE cont-emit 
                THEN DO:
                
                    find first int-cont-emit where
                               int-cont-emit.cod-emitente = tt-cont-emit.cod-emitente and
                               int-cont-emit.sequencia    = i-seq-contato exclusive-lock no-error.
                    if not avail int-cont-emit
                    then do:                       
                         CREATE int-cont-emit.
                         ASSIGN int-cont-emit.cod-emitente = tt-cont-emit.cod-emitente
                                int-cont-emit.sequencia    = i-seq-contato.                      
                    end.
                    
                    find first tt-atributo-entrada where
                               tt-atributo-entrada.nome-pai = "new_chaveintegracao" no-error.
                    if avail tt-atributo-entrada 
                    then do:                                               
                       assign int-cont-emit.vl-guid      = tt-atributo-entrada.valor.
                    end.   
                          
                    CREATE cont-emit.
                    ASSIGN cont-emit.cod-emitente = tt-cont-emit.cod-emitente
                           cont-emit.sequencia    = i-seq-contato
                           cont-emit.identific    = 1.                           
                END.
                ELSE DO:
                    IF cont-emit.identific = 2 THEN
                        ASSIGN cont-emit.identific = 3.
                END.
                 
                ASSIGN cont-emit.nome       = tt-cont-emit.nome
                       cont-emit.cargo      = tt-cont-emit.cargo
                       cont-emit.area       = tt-cont-emit.area
                       cont-emit.telefone   = tt-cont-emit.telefone
                       cont-emit.ramal      = tt-cont-emit.ramal
                       cont-emit.telefax    = tt-cont-emit.telefax
                       cont-emit.ramal-fax  = tt-cont-emit.ramal-fax
                       cont-emit.e-mail     = tt-cont-emit.e-mail
                       cont-emit.observacao = tt-cont-emit.observacao
                       pContaLinhasTrace    = pContaLinhasTrace + 1.                              
              
            end.
            else do:
                
                find first tt-atributo-entrada where
                           tt-atributo-entrada.nome-pai = "new_chaveintegracao" no-error.
                if avail tt-atributo-entrada 
                then do: 
                                        
                   for first int-cont-emit exclusive-lock where 
                             int-cont-emit.vl-guid = tt-atributo-entrada.valor,
                       first cont-emit exclusive-lock where
                             cont-emit.cod-emitente = int-cont-emit.cod-emitente and 
                             cont-emit.sequencia    = int-cont-emit.sequencia :
                         
                        assign pContaLinhasTrace    = pContaLinhasTrace + 1.
                          
                        delete cont-emit.                 
                   end.                     
                   

                end.                      
                
            end.
            
            RUN UpdateIntegrationLogStatus (INPUT  tt-integrationLog.logId,
                                            INPUT  1,
                                            INPUT  "Processado com sucesso",
                                            OUTPUT TABLE RowErrors).
        
        END.                                   
              
              
        EMPTY TEMP-TABLE tt-cont-emit.
    END.
         
    RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piRetornaLocalEntrega:
    DEFINE INPUT  PARAMETER pEntidade AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
          
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    RUN piConnection.
          
    RUN readIntegrationLogFromCRM (INPUT pEntidade,
                                   OUTPUT TABLE tt-integrationLog,
                                   OUTPUT TABLE RowErrors).    
          
    FOR EACH tt-integrationLog:
        EMPTY TEMP-TABLE tt-loc-entr.
        empty temp-table tt-atributo-entrada. 
        empty temp-table tt-atributo.   
        empty temp-table tt-erros-crm.     
                         
        CREATE tt-loc-entr.

        RUN readXML (INPUT BUFFER tt-loc-entr:HANDLE,
                     INPUT tt-integrationLog.cMessage,
                     OUTPUT TABLE tt-atributo-entrada).                      
        
        FOR EACH tt-atributo-entrada :
        
            if tt-atributo-entrada.nome-pai  = "nome-abrev":U and
               tt-atributo-entrada.nome      = "crmid":U then next.
                        
                          
            CREATE tt-atributo.
            ASSIGN tt-atributo.r-temp-table = ROWID(tt-loc-entr)
                   tt-atributo.nome-campo   = tt-atributo-entrada.nome-pai
                   tt-atributo.nome-atrib   = tt-atributo-entrada.nome
                   tt-atributo.vl-atrib     = tt-atributo-entrada.valor.
        END.            

        FIND FIRST tt-loc-entr NO-ERROR.                       
          
        IF AVAILABLE tt-loc-entr 
        THEN DO:
        
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Contato: ":U + STRING(tt-loc-entr.nome-abrev) + " - ":U + STRING(tt-loc-entr.cod-entrega)).
                        
            if tt-integrationLog.action <> "D"
            then do:                      
            
                ASSIGN tt-loc-entr.new_chaveintegracao = TRIM(STRING(tt-loc-entr.nome-abrev)) + ",":U + TRIM(STRING(tt-loc-entr.cod-entrega))
                       tt-loc-entr.addresstypecode     = 1
                       tt-loc-entr.objecttypecode      = "account":U
                       tt-loc-entr.new_exporta_erp     = "":U
                       pContaLinhasTrace    = pContaLinhasTrace + 1.
                              
                assign i-seq-erro = 1.
                               
                for last tt-erros-crm by tt-erros-crm.num-sequencia-erro:
                    assign i-seq-erro = tt-erros-crm.num-sequencia-erro + 1.
                end.    
                                   
                RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
                RUN pi-trata-endereco IN h-cdapi704 (INPUT  tt-loc-entr.endereco,
                                                     OUTPUT c-rua, 
                                                     OUTPUT c-nro, 
                                                     OUTPUT c-comp). 
                DELETE PROCEDURE h-cdapi704.
                IF c-nro = "" THEN DO:
                     create tt-erros-crm.
                     assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                            tt-erros-crm.cod-erro           = 1000
                            tt-erros-crm.des-erro           = "Cliente com endereáo sem numero, favor informar o numero no endereáo do cliente"
                            i-seq-erro                      = i-seq-erro + 1.              
                     
                END.
      
                IF length(trim(c-comp)) = 1 
                THEN DO:
                   create tt-erros-crm.
                   assign tt-erros-crm.num-sequencia-erro = i-seq-erro
                          tt-erros-crm.cod-erro           = 1001
                          tt-erros-crm.des-erro           = "Complemento do Endereco apenas com uma posiá∆o, SEFAZ exige que tenha mais de uma posiá∆o"
                          i-seq-erro                      = i-seq-erro + 1.            
                END.
                                                
                CREATE tt-atributo.
                ASSIGN tt-atributo.r-temp-table = ROWID(tt-loc-entr)
                       tt-atributo.nome-campo   = "nome-abrev":U
                       tt-atributo.nome-atrib   = "entity":U
                       tt-atributo.vl-atrib     = "account":U.
            
                CREATE tt-atributo.
                ASSIGN tt-atributo.r-temp-table = ROWID(tt-loc-entr)
                       tt-atributo.nome-campo   = "nome-abrev":U
                       tt-atributo.nome-atrib   = "keyfield":U
                       tt-atributo.vl-atrib     = "accountnumber":U.
            
                FIND FIRST int-emitente WHERE 
                           int-emitente.cod-emitente = tt-loc-entr.nome-abrev NO-LOCK NO-ERROR.
            
                IF AVAILABLE int-emitente       AND
                   int-emitente.vl-guid <> "":U AND
                   int-emitente.vl-guid <> ?    THEN DO:
                    CREATE tt-atributo.
                    ASSIGN tt-atributo.r-temp-table = ROWID(tt-loc-entr)
                           tt-atributo.nome-campo   = "nome-abrev":U
                           tt-atributo.nome-atrib   = "crmid":U
                           tt-atributo.vl-atrib     = int-emitente.vl-guid.
                END.
                            
                                 
                if can-find(first tt-erros-crm)
                then do:
                    FOR EACH tt-erros-crm:
                      CREATE RowErrors.
                      ASSIGN RowErrors.errorsequence    = tt-erros-crm.num-sequencia-erro
                             RowErrors.errornumber      = tt-erros-crm.cod-erro
                             RowErrors.errordescription = tt-erros-crm.des-erro
                             RowErrors.errorparameters  = "customeraddress":U
                             RowErrors.errortype        = "Error":U
                             RowErrors.errorhelp        = "Erro na integraá∆o CRM com ERP. (Tabela Local Entraga).":U
                             RowErrors.errorsubtype     = "Custom":U
                             c-erro                     = STRING(tt-erros-crm.des-erro) + " (":U + STRING(tt-erros-crm.cod-erro) + ") - ":U.
                 
                    end.
                                        
                    ASSIGN tt-loc-entr.new_status_integracao = "N∆o integrado.":U
                           tt-loc-entr.new_mensagem          = "Erro: ":U + c-erro + ". Erro na integraá∆o CRM com ERP (Tabela Local de entrega).":U.
    
                    RUN UpdateIntegrationLogStatus (INPUT  tt-integrationLog.logId,
                                                    INPUT  3,
                                                    INPUT tt-loc-entr.new_mensagem,
                                                    OUTPUT TABLE RowErrors).                
                                           

                    RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                              INPUT  tt-integrationlog.entity,
                                              INPUT  if tt-integrationLog.action = "C" then "W" else tt-integrationLog.action ,
                                              INPUT  "0":U,
                                              INPUT  BUFFER tt-loc-entr:HANDLE,
                                              INPUT  TABLE tt-atributo,
                                              OUTPUT TABLE RowErrors).

                    EMPTY TEMP-TABLE tt-atributo.                                                               
                
                end.
                else do:
                     find first b-emitente no-lock where
                                b-emitente.cod-emitente = tt-loc-entr.nome-abrev no-error. 
                                                                                          
                     FIND FIRST int-loc-entr WHERE 
                                int-loc-entr.nome-abrev  = b-emitente.nome-abrev AND 
                                int-loc-entr.cod-entrega = tt-loc-entr.cod-entrega EXCLUSIVE-LOCK NO-ERROR.
        
                    IF NOT AVAILABLE int-loc-entr THEN DO:
                        CREATE int-loc-entr.
                        ASSIGN int-loc-entr.nome-abrev  = b-emitente.nome-abrev
                               int-loc-entr.cod-entrega = tt-loc-entr.cod-entrega. 

                        ASSIGN int-loc-entr.endereco-completo = "":U.

                        IF tt-loc-entr.endereco <> "":U THEN
                            ASSIGN int-loc-entr.endereco-completo = tt-loc-entr.endereco.

                        IF tt-loc-entr.new_numero_endereco <> "":U THEN DO:
                            IF int-loc-entr.endereco-completo <> "":U THEN
                                ASSIGN int-loc-entr.endereco-completo = int-loc-entr.endereco-completo + ", ":U + tt-loc-entr.new_numero_endereco.
                            ELSE
                                ASSIGN int-loc-entr.endereco-completo = tt-loc-entr.new_numero_endereco.
                        END.

                        IF tt-loc-entr.line3 <> "":U THEN DO:
                            IF int-loc-entr.endereco-completo <> "":U THEN
                                ASSIGN int-loc-entr.endereco-completo = loc-entr.endereco + " - ":U + tt-loc-entr.line3.
                            ELSE
                                ASSIGN int-loc-entr.endereco-completo = tt-loc-entr.line3.
                        END.

                        find first tt-atributo-entrada
                            where tt-atributo-entrada.nome-pai = "new_chaveintegracao":U
                              and tt-atributo-entrada.nome     = "crmid" no-error.

                        if avail tt-atributo-entrada then
                            assign int-loc-entr.vl-guid = tt-atributo-entrada.valor.
                    END.
                    ELSE DO:
                        ASSIGN int-loc-entr.endereco-completo = "":U.

                        IF tt-loc-entr.endereco <> "":U THEN
                            ASSIGN int-loc-entr.endereco-completo = tt-loc-entr.endereco.

                        IF tt-loc-entr.new_numero_endereco <> "":U THEN DO:
                            IF int-loc-entr.endereco-completo <> "":U THEN
                                ASSIGN int-loc-entr.endereco-completo = int-loc-entr.endereco-completo + ", ":U + tt-loc-entr.new_numero_endereco.
                            ELSE
                                ASSIGN int-loc-entr.endereco-completo = tt-loc-entr.new_numero_endereco.
                        END.

                        IF tt-loc-entr.line3 <> "":U THEN DO:
                            IF int-loc-entr.endereco-completo <> "":U THEN
                                ASSIGN int-loc-entr.endereco-completo = loc-entr.endereco + " - ":U + tt-loc-entr.line3.
                            ELSE
                                ASSIGN int-loc-entr.endereco-completo = tt-loc-entr.line3.
                        END.
                    END.
                    
                    FIND FIRST loc-entr  WHERE 
                               loc-entr.nome-abrev  = b-emitente.nome-abrev AND 
                               loc-entr.cod-entrega = tt-loc-entr.cod-entrega EXCLUSIVE-LOCK NO-ERROR.
        
                    IF NOT AVAILABLE loc-entr THEN DO:        
                        CREATE loc-entr.
                        ASSIGN loc-entr.nome-abrev   = b-emitente.nome-abrev 
                               loc-entr.cod-entrega  = tt-loc-entr.cod-entrega.                               
                    END.

                    ASSIGN loc-entr.endereco = "":U.

                    IF tt-loc-entr.endereco <> "":U THEN
                        ASSIGN loc-entr.endereco = tt-loc-entr.endereco.

                    IF tt-loc-entr.new_numero_endereco <> "":U THEN DO:
                        IF loc-entr.endereco <> "":U THEN
                            ASSIGN loc-entr.endereco = loc-entr.endereco + ", ":U + tt-loc-entr.new_numero_endereco.
                        ELSE
                            ASSIGN loc-entr.endereco = tt-loc-entr.new_numero_endereco.
                    END.

                    IF tt-loc-entr.line3 <> "":U THEN DO:
                        IF loc-entr.endereco <> "":U THEN
                            ASSIGN loc-entr.endereco = loc-entr.endereco + " - ":U + tt-loc-entr.line3.
                        ELSE
                            ASSIGN loc-entr.endereco = tt-loc-entr.line3.
                    END.

                    assign loc-entr.bairro       = tt-loc-entr.bairro
                           loc-entr.cidade       = tt-loc-entr.cidade
                           loc-entr.estado       = tt-loc-entr.estado
                           loc-entr.pais         = tt-loc-entr.pais
                           loc-entr.cep          = REPLACE(tt-loc-entr.cep, "-":U, "":U)  
                           loc-entr.ins-estadual = tt-loc-entr.ins-estadual
                           loc-entr.e-mail       = tt-loc-entr.e-mail.                         
                              
                    ASSIGN c-cgc        = REPLACE(tt-loc-entr.cgc,".","")
                           c-cgc        = REPLACE(c-cgc,"/","")    
                           c-cgc        = REPLACE(c-cgc,"-","")    
                           loc-entr.cgc = c-cgc.  

                    if loc-entr.cgc = "" 
                    then assign loc-entr.cgc = b-emitente.cgc. 

    
                    ASSIGN tt-loc-entr.new_status_integracao = "Integrado com sucesso."
                           tt-loc-entr.new_mensagem          = "".         
                           
                           
                    RUN UpdateIntegrationLogStatus (INPUT  tt-integrationLog.logId,
                                                    INPUT  1,
                                                    INPUT tt-loc-entr.new_mensagem,
                                                    OUTPUT TABLE RowErrors).              
                
                end.
                                 
            end. 
            else do:
                                                        
                find first tt-atributo-entrada where
                           tt-atributo-entrada.nome-pai = "new_chaveintegracao" no-error.
                if avail tt-atributo-entrada 
                then do:                    
                                        
                   for first int-loc-entr exclusive-lock where 
                             int-loc-entr.vl-guid = tt-atributo-entrada.valor,
                       first loc-entr exclusive-lock where
                             loc-entr.nome-abrev  = int-loc-entr.nome-abrev and 
                             loc-entr.cod-entrega = int-loc-entr.cod-entrega :
                         
                        assign pContaLinhasTrace    = pContaLinhasTrace + 1.
                          
                        delete loc-entr.       
                        
                        RUN UpdateIntegrationLogStatus (INPUT  tt-integrationLog.logId,
                                                        INPUT  1,
                                                        INPUT tt-loc-entr.new_mensagem,
                                                        OUTPUT TABLE RowErrors).           
                   end.                                       

                end.                             
            end.
                    
        end.
    end.
     
    RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piRetornaRelacionamentoCliente:
    DEFINE INPUT  PARAMETER pEntidade AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTrace AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    RUN piConnection.
                        
    RUN readIntegrationLogFromCRM (INPUT pEntidade,
                                   OUTPUT TABLE tt-integrationLog,
                                   OUTPUT TABLE RowErrors).    
          
    FOR EACH tt-integrationLog:
        EMPTY TEMP-TABLE tt-relacionamento-cliente.
        empty temp-table tt-atributo-entrada. 
        empty temp-table tt-atributo.   
                         
        CREATE tt-relacionamento-cliente.

        RUN readXML (INPUT BUFFER tt-relacionamento-cliente:HANDLE,
                     INPUT tt-integrationLog.cMessage,
                     OUTPUT TABLE tt-atributo-entrada).                      
        
        FOR EACH tt-atributo-entrada :
            
            CREATE tt-atributo.
            ASSIGN tt-atributo.r-temp-table = ROWID(tt-loc-entr)
                   tt-atributo.nome-campo   = tt-atributo-entrada.nome-pai
                   tt-atributo.nome-atrib   = tt-atributo-entrada.nome
                   tt-atributo.vl-atrib     = tt-atributo-entrada.valor.
        END.            

        FIND FIRST tt-relacionamento-cliente where
                   tt-relacionamento-cliente.cod-emitente > 0  NO-ERROR.                      
          
        IF AVAILABLE tt-relacionamento-cliente 
        THEN DO:
        
            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Relacionamento Cliente: ":U + STRING(tt-relacionamento-cliente.cod-emitente) + " - ":U + STRING(tt-relacionamento-cliente.seq)).
                        
            if tt-integrationLog.action <> "D"
            then do:                      
                
                assign i-seq-contato = 10.
                
                for last crm-relacionamento-cliente NO-LOCK where
                         crm-relacionamento-cliente.cod-emitente = tt-relacionamento-cliente.cod-emitente 
                    by crm-relacionamento-cliente.seq:

                       assign i-seq-contato = crm-relacionamento-cliente.seq + 10.
                end.

                find first tt-atributo-entrada where
                           tt-atributo-entrada.nome-pai = "new_chaveintegracao" no-error.
                if avail tt-atributo-entrada 
                then do:   
                    FIND FIRST crm-relacionamento-cliente NO-LOCK WHERE
                               crm-relacionamento-cliente.vl-guid = tt-atributo-entrada.valor NO-ERROR.
                    IF AVAIL crm-relacionamento-cliente THEN
                       ASSIGN i-seq-contato = crm-relacionamento-cliente.seq.
                end.          

                find first crm-relacionamento-cliente exclusive-lock where
                           crm-relacionamento-cliente.cod-emitente = tt-relacionamento-cliente.cod-emitente and
                           crm-relacionamento-cliente.seq          = i-seq-contato no-error.
                if not avail crm-relacionamento-cliente
                then do:
                    
                    create crm-relacionamento-cliente.
                    assign crm-relacionamento-cliente.cod-emitente = tt-relacionamento-cliente.cod-emitente
                           crm-relacionamento-cliente.seq          = i-seq-contato.                                                   

                    find first tt-atributo-entrada where
                               tt-atributo-entrada.nome-pai = "new_chaveintegracao" no-error.
                    if avail tt-atributo-entrada 
                    then do:
                       ASSIGN crm-relacionamento-cliente.vl-guid = tt-atributo-entrada.valor.     
                    END. 
                end.      
                
                ASSIGN crm-relacionamento-cliente.cod-rep         = int(tt-relacionamento-cliente.cod-rep)
                       crm-relacionamento-cliente.cd-categoria    = tt-relacionamento-cliente.cd-categoria
                       crm-relacionamento-cliente.dt-vigencia-ini = tt-relacionamento-cliente.dt-vigencia-ini
                       crm-relacionamento-cliente.dt-vigencia-fim = tt-relacionamento-cliente.dt-vigencia-fim. 
                
                IF  CAN-FIND(FIRST unid-comer NO-LOCK
                             WHERE unid-comerc.cd-unid-comerc = INT(tt-relacionamento-cliente.cd-unid-negoc)) THEN
                    ASSIGN crm-relacionamento-cliente.cd-unid-negoc = tt-relacionamento-cliente.cd-unid-negoc.

                
                ASSIGN  tt-relacionamento-cliente.new_status_integracao = "Integrado com Sucesso."
                        tt-relacionamento-cliente.new_mensagem          = ""
                        pContaLinhasTrace    = pContaLinhasTrace + 1.
                       
                RUN UpdateIntegrationLogStatus (INPUT  tt-integrationLog.logId,
                                                INPUT  1,
                                                INPUT   tt-relacionamento-cliente.new_mensagem,
                                                OUTPUT TABLE RowErrors).
                                                  

            end.
            ELSE DO:
                find first tt-atributo-entrada where
                           tt-atributo-entrada.nome-pai = "new_chaveintegracao" no-error.
                if avail tt-atributo-entrada 
                then do: 
                                        
                   for first crm-relacionamento-cliente exclusive-lock where 
                             crm-relacionamento-cliente.vl-guid = tt-atributo-entrada.valor:
                         
                        assign pContaLinhasTrace    = pContaLinhasTrace + 1.
                          
                        delete crm-relacionamento-cliente.                 
                   end.      

                end. 
            END.
       end.       
       
    END.
       
       
    RUN piCloseConnection.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piIntegraNotaFiscal:
    DEFINE INPUT  PARAMETER pEntidadeNF     AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pEntidadeItemNF AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pRowNotaFiscal  AS ROWID       NO-UNDO.

    DEFINE VARIABLE iContaLinhasTraceNF     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iContaLinhasTraceItemNF AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iContaLinhasTraceOcor   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iContaLinhasTraceDuplic AS INTEGER     NO-UNDO.


    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o EMS X Microsoft CRM Dynamics":U).

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

   
    FIND FIRST nota-fiscal NO-LOCK
        WHERE  ROWID(nota-fiscal) = pRowNotaFiscal NO-ERROR.
    IF  AVAIL  nota-fiscal THEN DO:
        RUN piEnviaNotaFiscal IN THIS-PROCEDURE (INPUT  pEntidadeNF,
                                                 INPUT  pEntidadeItemNF,
                                                 OUTPUT iContaLinhasTraceNF,
                                                 OUTPUT iContaLinhasTraceItemNF,
                                                 OUTPUT iContaLinhasTraceOcor,
                                                 OUTPUT iContaLinhasTraceDuplic).
    END.


    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piEnviaNotaFiscal:
    DEFINE INPUT  PARAMETER pEntidadeNF             AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pEntidadeItemNF         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTraceNF     AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTraceItemNF AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTraceOcor   AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER pContaLinhasTraceDuplic AS INTEGER     NO-UNDO.

    IF  NOT AVAIL nota-fiscal THEN
        RETURN "NOK":U.

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente: END.
    IF  AVAIL emitente AND emitente.identific = 2 THEN
        NEXT.

    FIND natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.
    IF  AVAIL natur-oper AND natur-oper.tipo = 1 THEN
        NEXT.

    FOR FIRST ped-venda NO-LOCK
        WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
          AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli: END.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Nota Fiscal: ":U + STRING(nota-fiscal.cod-estabel) + " - ":U + STRING(nota-fiscal.serie) + " - ":U + STRING(nota-fiscal.nr-nota-fis)).
      
    FIND FIRST transporte NO-LOCK
        WHERE  transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.


    CREATE tt-nota-fiscal.

    CREATE tt-atributo.
    ASSIGN tt-atributo.r-temp-table = ROWID(tt-nota-fiscal)
           tt-atributo.nome-campo   = "cod-emitente":U
           tt-atributo.nome-atrib   = "entity":U
           tt-atributo.vl-atrib     = "account":U.

    CREATE tt-atributo.
    ASSIGN tt-atributo.r-temp-table = ROWID(tt-nota-fiscal)
           tt-atributo.nome-campo   = "cod-emitente":U
           tt-atributo.nome-atrib   = "keyfield":U
           tt-atributo.vl-atrib     = "accountnumber":U.

    ASSIGN tt-nota-fiscal.cod-estabel           = nota-fiscal.cod-estabel
           tt-nota-fiscal.serie                 = nota-fiscal.serie
           tt-nota-fiscal.nr-nota-fis           = nota-fiscal.nr-nota-fis
           tt-nota-fiscal.NAME                  = STRING(nota-fiscal.nr-nota-fis) + "-":U + STRING(nota-fiscal.serie)
           tt-nota-fiscal.nome-ab-cli           = nota-fiscal.nome-ab-cli
           tt-nota-fiscal.dt-emis-nota          = nota-fiscal.dt-emis-nota
           tt-nota-fiscal.ind-sit-nota          = /*1*/ nota-fiscal.ind-sit-nota
           tt-nota-fiscal.dt-confirma           = nota-fiscal.dt-confirma
           tt-nota-fiscal.dt-cancela            = nota-fiscal.dt-cancela
           tt-nota-fiscal.cod-cond-pag          = nota-fiscal.cod-cond-pag
           tt-nota-fiscal.nr-pedcli             = nota-fiscal.nr-pedcli
           tt-nota-fiscal.cod-entrega           = nota-fiscal.cod-entrega
           tt-nota-fiscal.endereco              = STRING(nota-fiscal.endereco, "x(40)":U)
           tt-nota-fiscal.bairro                = nota-fiscal.bairro
           tt-nota-fiscal.cidade                = nota-fiscal.cidade
           tt-nota-fiscal.estado                = nota-fiscal.estado
           tt-nota-fiscal.cep                   = nota-fiscal.cep
           tt-nota-fiscal.pais                  = nota-fiscal.pais
           tt-nota-fiscal.cgc                   = nota-fiscal.cgc
           tt-nota-fiscal.ins-estadual          = nota-fiscal.ins-estadual
           tt-nota-fiscal.nome-transp           = IF AVAILABLE transporte THEN transporte.cod-transp ELSE ?
           tt-nota-fiscal.vl-tot-nota           = nota-fiscal.vl-tot-nota
           tt-nota-fiscal.vl-mercad             = nota-fiscal.vl-mercad
           tt-nota-fiscal.nat-operacao          = nota-fiscal.nat-operacao
           tt-nota-fiscal.peso-liq-tot          = nota-fiscal.peso-liq-tot
           tt-nota-fiscal.peso-bru-tot          = nota-fiscal.peso-bru-tot
           tt-nota-fiscal.cod-emitente          = nota-fiscal.cod-emitente
           tt-nota-fiscal.nr-pedido             = IF AVAIL ped-venda THEN ped-venda.nr-pedido ELSE 0
           tt-nota-fiscal.dt-saida              = nota-fiscal.dt-saida
           tt-nota-fiscal.nr-volume             = nota-fiscal.nr-volumes
           tt-nota-fiscal.cidade-cif            = nota-fiscal.cidade-cif
           tt-nota-fiscal.new_chaveintegracao   = STRING(nota-fiscal.cod-estabel) + ",":U + STRING(nota-fiscal.serie) + ",":U + STRING(nota-fiscal.nr-nota-fis)
           tt-nota-fiscal.pricelevelid          = "CRM Real":U
           tt-nota-fiscal.transactioncurrencyid = "Real":U
           tt-nota-fiscal.observ-nota           = nota-fiscal.observ-nota
           pContaLinhasTraceNF                  = pContaLinhasTraceNF + 1.

    /*** Valores da Nota Fiscal ***/
    ASSIGN de-vl-bicms-it  = 0.00
           de-vl-icms-it   = 0.00
           de-vl-ipi-it    = 0.00
           de-vl-bsubs-it  = 0.00
           de-vl-icmsub-it = 0.00
           de-vl-frete     = 0.00.

    FOR EACH  it-nota-fisc NO-LOCK
        WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
          AND it-nota-fisc.serie       = nota-fiscal.serie
          AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis:
        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Item Nota Fiscal (Impostos): ":U + STRING(it-nota-fisc.cod-estabel) + " - ":U + STRING(it-nota-fisc.serie) + " - ":U + STRING(it-nota-fisc.nr-nota-fis) + " - ":U + STRING(it-nota-fisc.nr-seq-fat) + " - ":U + STRING(it-nota-fisc.it-codigo)).

        ASSIGN de-vl-bicms-it  = de-vl-bicms-it  + it-nota-fisc.vl-bicms-it
               de-vl-icms-it   = de-vl-icms-it   + it-nota-fisc.vl-icms-it
               de-vl-ipi-it    = de-vl-ipi-it    + it-nota-fisc.vl-ipi-it
               de-vl-bsubs-it  = de-vl-bsubs-it  + it-nota-fisc.vl-bsubs-it
               de-vl-icmsub-it = de-vl-icmsub-it + it-nota-fisc.vl-icmsub-it.
    END.

    RUN esp/crm/escrm001d.p (INPUT ROWID(nota-fiscal),
                             OUTPUT de-vl-frete).

    ASSIGN tt-nota-fiscal.vl-bicms-it = de-vl-bicms-it
           tt-nota-fiscal.vl-icms-it  = de-vl-icms-it
           tt-nota-fiscal.vl-ipi-it   = de-vl-ipi-it
           tt-nota-fiscal.vl-bsubs-it = de-vl-bsubs-it
           tt-nota-fiscal.vl-subs-it  = de-vl-icmsub-it
           tt-nota-fiscal.vl-frete    = de-vl-frete.

    RUN InsertIntegrationLog (INPUT  "fromERP":U,
                              INPUT  pEntidadeNF,
                              INPUT  "W":U,
                              INPUT  "0":U,
                              INPUT  BUFFER tt-nota-fiscal:HANDLE,
                              INPUT  TABLE tt-atributo,
                              OUTPUT TABLE RowErrors).

    FOR EACH  it-nota-fisc NO-LOCK
        WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
          AND it-nota-fisc.serie       = nota-fiscal.serie
          AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis:
        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Item Nota Fiscal: ":U + STRING(it-nota-fisc.cod-estabel) + " - ":U + STRING(it-nota-fisc.serie) + " - ":U + STRING(it-nota-fisc.nr-nota-fis) + " - ":U + STRING(it-nota-fisc.nr-seq-fat) + " - ":U + STRING(it-nota-fisc.it-codigo)).

        FIND FIRST item NO-LOCK
            WHERE  item.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

        CREATE tt-it-nota-fisc.
        ASSIGN tt-it-nota-fisc.it-codigo             = it-nota-fisc.it-codigo
               tt-it-nota-fisc.qt-faturada           = it-nota-fisc.qt-faturada[1]
               tt-it-nota-fisc.vl-pretab             = ROUND(it-nota-fisc.vl-pretab,2)
               tt-it-nota-fisc.vl-preori             = ROUND(it-nota-fisc.vl-preori,2)
               tt-it-nota-fisc.vl-preuni             = ROUND(it-nota-fisc.vl-preuni,2)
               tt-it-nota-fisc.vl-merc-tab           = it-nota-fisc.vl-merc-tab
               tt-it-nota-fisc.vl-merc-ori           = it-nota-fisc.vl-merc-ori
               tt-it-nota-fisc.vl-merc-liq           = it-nota-fisc.vl-merc-liq
               tt-it-nota-fisc.vl-tot-item           = it-nota-fisc.vl-tot-item
               tt-it-nota-fisc.nat-operacao          = it-nota-fisc.nat-operacao
               tt-it-nota-fisc.nota-fiscal           = STRING(nota-fiscal.cod-estabel) + ",":U + 
                                                       STRING(nota-fiscal.serie)       + ",":U + 
                                                       STRING(nota-fiscal.nr-nota-fis)
               tt-it-nota-fisc.isproductoverridden   = "0"
               tt-it-nota-fisc.ispriceoverridden     = "1"
               tt-it-nota-fisc.un                    = item.un
               tt-it-nota-fisc.new_chaveintegracao   = STRING(it-nota-fisc.cod-estabel) + ",":U + 
                                                       STRING(it-nota-fisc.serie)       + ",":U + 
                                                       STRING(it-nota-fisc.nr-nota-fis) + ",":U + 
                                                       STRING(it-nota-fisc.nr-seq-fat)  + ",":U + 
                                                       STRING(it-nota-fisc.it-codigo)
               tt-it-nota-fisc.vl-bicms-it           = it-nota-fisc.vl-bicms-it  WHEN it-nota-fisc.vl-bicms-it > 0
               tt-it-nota-fisc.vl-bsubs-it           = it-nota-fisc.vl-bsubs-it  WHEN it-nota-fisc.vl-bsubs-it > 0
               tt-it-nota-fisc.aliquota-icm          = it-nota-fisc.aliquota-icm
               tt-it-nota-fisc.vl-icms-it            = it-nota-fisc.vl-icms-it   WHEN it-nota-fisc.vl-icms-it   > 0
               tt-it-nota-fisc.vl-icmsub-it          = it-nota-fisc.vl-icmsub-it WHEN it-nota-fisc.vl-icmsub-it > 0
               tt-it-nota-fisc.vl-icmsnt-it          = it-nota-fisc.vl-icmsnt-it WHEN it-nota-fisc.vl-icmsnt-it > 0  
               tt-it-nota-fisc.vl-icmsou-it          = it-nota-fisc.vl-icmsou-it WHEN it-nota-fisc.vl-icmsou-it > 0
               tt-it-nota-fisc.vl-biss-it            = it-nota-fisc.vl-biss-it   WHEN it-nota-fisc.vl-biss-it   > 0
               tt-it-nota-fisc.vl-bipi-it            = it-nota-fisc.vl-bipi-it   WHEN it-nota-fisc.vl-bipi-it   > 0
               tt-it-nota-fisc.aliquota-ISS          = it-nota-fisc.aliquota-iss
               tt-it-nota-fisc.aliquota-ipi          = it-nota-fisc.aliquota-ipi
               tt-it-nota-fisc.vl-iss-it             = it-nota-fisc.vl-iss-it    WHEN it-nota-fisc.vl-iss-it    > 0   
               tt-it-nota-fisc.vl-ipi-it             = it-nota-fisc.vl-ipi-it    WHEN it-nota-fisc.vl-ipi-it    > 0 
               tt-it-nota-fisc.vl-issnt-it           = it-nota-fisc.vl-issnt-it  WHEN it-nota-fisc.vl-issnt-it  > 0 
               tt-it-nota-fisc.vl-ipint-it           = it-nota-fisc.vl-ipint-it  WHEN it-nota-fisc.vl-ipint-it  > 0 
               tt-it-nota-fisc.vl-issou-it           = it-nota-fisc.vl-issou-it  WHEN it-nota-fisc.vl-issou-it  > 0 
               tt-it-nota-fisc.vl-ipiou-it           = it-nota-fisc.vl-ipiou-it  WHEN it-nota-fisc.vl-ipiou-it  > 0 
               tt-it-nota-fisc.vl-precon             = ROUND(it-nota-fisc.vl-precon,2)   
               tt-it-nota-fisc.cd-trib-icm           = {ininc/i07in122.i 04 it-nota-fisc.cd-trib-icm}
               tt-it-nota-fisc.cd-trib-iss           = {ininc/i07in122.i 04 it-nota-fisc.cd-trib-iss}
               tt-it-nota-fisc.cd-trib-ipi           = {ininc/i07in122.i 04 it-nota-fisc.cd-trib-ipi}
               pContaLinhasTraceItemNF               = pContaLinhasTraceItemNF + 1.

        IF  tt-it-nota-fisc.it-codigo = "" THEN 
            ASSIGN tt-it-nota-fisc.it-codigo = "Branco".

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  pEntidadeItemNF,
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-it-nota-fisc:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-it-nota-fisc.
    END.

    
    /*** Ocorrencias da Nota fiscal ***/
    EMPTY TEMP-TABLE tt-ocorrencia.
    RUN esp/crm/escrm001c.p (INPUT  ROWID(nota-fiscal),
                             OUTPUT TABLE tt-ocorrencia).
    
    FOR EACH tt-ocorrencia :
        ASSIGN pContaLinhasTraceOcor = pContaLinhasTraceOcor + 1.
        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  "new_nota_ocorrncia",
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-ocorrencia:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors). 
    END.


    /*** Duplicatas da Nota Fiscal ***/
    EMPTY TEMP-TABLE tt-fat-duplic.

    FIND FIRST tt-nota-fiscal NO-ERROR.

    FOR EACH  fat-duplic NO-LOCK
        WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
        AND   fat-duplic.serie       = nota-fiscal.serie
        AND   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:
        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Duplicata Nota Fiscal: ":U + STRING(nota-fiscal.cod-estabel) + " - ":U + STRING(nota-fiscal.serie) + " - ":U + STRING(nota-fiscal.nr-nota-fis) + " - ":U + STRING(nota-fiscal.nr-fatura)).

        CREATE tt-fat-duplic.
        ASSIGN tt-fat-duplic.nr-fatura           = tt-nota-fiscal.new_chaveintegracao
               tt-fat-duplic.dt-venciment        = fat-duplic.dt-venciment
               tt-fat-duplic.vl-parcela          = fat-duplic.vl-parcela
               tt-fat-duplic.name                = STRING(fat-duplic.dt-venciment, "99/99/9999") + STRING(fat-duplic.vl-parcela)
               tt-fat-duplic.new_chaveintegracao = fat-duplic.cod-estabel + "," + fat-duplic.serie + "," + fat-duplic.nr-fatura + "," +
                                                   STRING(fat-duplic.ind-fat-nota) + "," + STRING(fat-duplic.flag-atualiz) + "," + fat-duplic.parcela
               pContaLinhasTraceDuplic           = pContaLinhasTraceDuplic + 1.

        RUN InsertIntegrationLog (INPUT  "fromERP":U,
                                  INPUT  "new_duplicata",
                                  INPUT  "W":U,
                                  INPUT  "0":U,
                                  INPUT  BUFFER tt-fat-duplic:HANDLE,
                                  INPUT  TABLE tt-atributo,
                                  OUTPUT TABLE RowErrors).

        EMPTY TEMP-TABLE tt-fat-duplic.
    END.

    EMPTY TEMP-TABLE tt-nota-fiscal.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piIntegraTituloACR:
END PROCEDURE.

PROCEDURE piExcluiTituloACR:
END PROCEDURE.

PROCEDURE piIntegraTituloAPB:
END PROCEDURE.

PROCEDURE piExcluiTituloAPB:
END PROCEDURE.


DELETE WIDGET-POOL.


PROCEDURE IntegraNFASTEC:

    DEFINE INPUT  PARAMETER TABLE FOR tt-nf-astec.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE cXML     AS LONGCHAR    NO-UNDO.
    DEFINE VARIABLE cRetorno AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-guid-branco AS CHARACTER   NO-UNDO.

    ASSIGN cTituloEmail =  "Integracao Nota Fiscal ASTEC".



    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    ASSIGN cXml = ""
           c-guid-branco = "".

    FOR EACH tt-nf-astec
        BREAK BY nr-nota-fis:
        
        IF FIRST-OF(tt-nf-astec.nr-nota-fis)  THEN DO:
            ASSIGN cXml = '<?xml version="1.0" ?>' + 
                           '<nota-fiscal numero="' + 
                            trim(tt-nf-astec.nr-nota-fis).
            ASSIGN cXml = cXml + 
                            '" serie="' + 
                            trim(tt-nf-astec.serie) + '"'.
            
            ASSIGN cXml = cXml + ' numeroConhecimento="' + trim(tt-nf-astec.nr-conhec) + '"'
                   cXml = cXml + ' dtEmissao="'  + string(year(tt-nf-astec.dt-emis-nota),'9999') + '-' + string(month(tt-nf-astec.dt-emis-nota),'99') + '-' + string(DAY(tt-nf-astec.dt-emis-nota),'99') + '"'.
                   cXml = cXml + ' estabelecimento="' + string(tt-nf-astec.cod-estabel) + '">'.
                   
                   

        END.
        IF tt-nf-astec.nr-os = "" OR tt-nf-astec.guid-os = "" THEN DO:
            ASSIGN c-guid-branco = c-guid-branco + " " + tt-nf-astec.it-codigo + " Nota " + tt-nf-astec.nr-nota-fis.
        END.
        ELSE DO:
            ASSIGN cXml = cXml + '<item>'.
            ASSIGN cXml = cXml + '
                    <it-codigo><![CDATA[' + trim(tt-nf-astec.it-codigo) + ']]></it-codigo>'.
            ASSIGN cXml = cXml + '
                    <nr-os><![CDATA[' + tt-nf-astec.nr-os + ']]></nr-os>'.
            ASSIGN cXml = cXml + ' 
                    <guid-os><![CDATA[' + tt-nf-astec.guid-os + ']]></guid-os>'.
            ASSIGN cXml = cXml + '
                    <qt-faturada>' + trim(string(tt-nf-astec.qt-faturada * 100,'>>>>>>>>>>9,99')) + '</qt-faturada>'.
            ASSIGN cXml = cXml + '
                    <vl-preuni>' + trim(string(tt-nf-astec.vl-preuni * 100,'>>>>>>>>>>9,99')) + '</vl-preuni>'.
            ASSIGN cXml = cXml + '
                    <aliquota-ipi>' + trim(string(tt-nf-astec.aliquota-ipi * 100,'>>>>>>>>>>9,99')) + '</aliquota-ipi>'.
            ASSIGN cXml = cXml + '
                    <vl-ipi-it>' + trim(string(tt-nf-astec.vl-ipi-it * 100,'>>>>>>>>>>9,99')) + '</vl-ipi-it>'.
            ASSIGN cXml = cXml + '
                    <vl-icms-it>' + trim(string(tt-nf-astec.vl-icms-it * 100,'>>>>>>>>>>9,99')) + '</vl-icms-it>'.
            ASSIGN cXml = cXml + '
                    <vl-bicms-it>' + trim(string(tt-nf-astec.vl-bicms-it * 100,'>>>>>>>>>>9,99')) + '</vl-bicms-it>'.
            ASSIGN cXml = cXml + '
                    <it-substituto><![CDATA[' + tt-nf-astec.it-substituto + ']]></it-substituto>'.
            ASSIGN cXml = cXml + '
                    <qtd-substituida>' + string(tt-nf-astec.qtd-substituida * 100,'>>>>>>>>>>9,99') + '</qtd-substituida>'.
            ASSIGN cXml = cXml + '</item>'.

        END.

         IF LAST-OF(tt-nf-astec.nr-nota-fis)  THEN
            ASSIGN cXml = cXml + '</nota-fiscal>'.
    END.


    IF l-log THEN DO:

        define variable hDoc    as handle   no-undo.
        create x-document hDoc.
        
        hDoc:LOAD("longchar", cXML, NO).
        hDoc:SAVE("file","C:/temp/" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").
        
        IF  VALID-HANDLE(hDoc) THEN
            DELETE OBJECT hDoc.


    END.
    IF  VALID-HANDLE(hService) THEN DO:

        RUN IntegraNFASTEC IN hService (INPUT  cXML          /* put          */,
                                        OUTPUT cRetorno).


        IF cRetorno <> "OK" THEN DO:

            FIND FIRST tt-nf-astec.
            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence     = 1
                   RowErrors.errornumber       = 1
                   RowErrors.errordescription  = cRetorno
                   RowErrors.errorparameters   = "Custom":U
                   RowErrors.errortype         = "Error":U
                   RowErrors.errorhelp         = cRetorno + CHR(10) + cXML
                   RowErrors.errorsubtype      = "Custom":U.
            ASSIGN cErro = cErro + CHR(10) + RowErrors.errordescription.
            RUN piEnviaEmailAstec (INPUT tt-nf-astec.cod-estabel,
                                   INPUT tt-nf-astec.serie,
                                   INPUT tt-nf-astec.nr-nota-fis).
            RUN piCloseConnection.
            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        FIND FIRST tt-nf-astec.
        CREATE RowErrors.
        ASSIGN RowErrors.errorsequence     = 1
               RowErrors.errornumber       = 1
               RowErrors.errordescription  = "Erro de integraá∆o do ERP com CRM - WebService n∆o est† dipon°vel":U
               RowErrors.errorparameters   = "Custom":U
               RowErrors.errortype         = "Error":U
               RowErrors.errorhelp         =  "Erro de integraá∆o do ERP com CRM - WebService n∆o est† dipon°vel":U
               RowErrors.errorsubtype      = "Custom":U.
        ASSIGN cErro = cErro + CHR(10) + RowErrors.errordescription.
        RUN piEnviaEmailAstec (INPUT tt-nf-astec.cod-estabel,
                               INPUT tt-nf-astec.serie,
                               INPUT tt-nf-astec.nr-nota-fis).
        RUN piCloseConnection.
        RETURN "NOK":U.
    END.
    IF c-guid-branco <> "" THEN DO :
        FIND FIRST tt-nf-astec.

        ASSIGN cErro = cErro + CHR(10) + "Itens com GUID em branco, Foram criados manualmente no EMS " + c-guid-branco.
        RUN piEnviaEmailAstec (INPUT tt-nf-astec.cod-estabel,
                               INPUT tt-nf-astec.serie,
                               INPUT tt-nf-astec.nr-nota-fis).

    END.
    IF l-log THEN
        MESSAGE "apos  ".
    
    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.
    
    IF l-log THEN
        MESSAGE "apos desconecte".
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE IntegraNFCanceladaASTEC:
    DEFINE INPUT  PARAMETER pi-cod-estabel LIKE nota-fiscal.cod-estabel.
    DEFINE INPUT  PARAMETER pi-serie       LIKE nota-fiscal.cod-estabel.
    DEFINE INPUT  PARAMETER pi-nr-nota-fis LIKE nota-fiscal.cod-estabel.

    DEFINE VARIABLE cXML     AS LONGCHAR    NO-UNDO.
    DEFINE VARIABLE cRetorno AS CHARACTER   NO-UNDO.

    ASSIGN cTituloEmail =  "Cancelamento Nota Fiscal ASTEC".

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    IF l-log THEN
        PUT "escrm001api cancelando nota " SKIP.
    IF  VALID-HANDLE(hService) THEN DO:
        IF l-log THEN
            PUT "escrm001api antes cancelando nota " 
                                pi-cod-estabel "  "
                                pi-serie           " "
                                pi-nr-nota-fis
                                
                                SKIP.
        RUN IntegraNFCanceladaASTEC IN hService (INPUT pi-cod-estabel,    
                                                 INPUT pi-serie,        
                                                 INPUT pi-nr-nota-fis,    
                                                 OUTPUT cRetorno).

        IF l-log THEN
            PUT "escrm001api apos cancelando nota " 
                                pi-cod-estabel
                                pi-serie
                                pi-nr-nota-fis " "
                                cRetorno
                                SKIP.

        IF cRetorno <> "OK" THEN DO: 
            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence     = 1
                   RowErrors.errornumber       = 1
                   RowErrors.errordescription  = cRetorno
                   RowErrors.errorparameters   = "Custom":U
                   RowErrors.errortype         = "Error":U
                   RowErrors.errorhelp         = cRetorno + CHR(10) + cXML
                   RowErrors.errorsubtype      = "Custom":U.
            ASSIGN cErro = cErro + CHR(10) + cRetorno.
            RUN piEnviaEmailAstec (INPUT pi-cod-estabel,      
                                   INPUT pi-serie,            
                                   INPUT pi-nr-nota-fis).
            RUN piCloseConnection.
            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        CREATE RowErrors.
        ASSIGN RowErrors.errorsequence     = 1
               RowErrors.errornumber       = 1
               RowErrors.errordescription  = "Erro de integraá∆o do ERP com CRM - WebService n∆o est† dipon°vel":U
               RowErrors.errorparameters   = "Custom":U
               RowErrors.errortype         = "Error":U
               RowErrors.errorhelp         =  "Erro de integraá∆o do ERP com CRM - WebService n∆o est† dipon°vel":U
               RowErrors.errorsubtype      = "Custom":U.
        ASSIGN cErro = cErro + CHR(10) + RowErrors.errordescription.
        RUN piEnviaEmailAstec (INPUT pi-cod-estabel,      
                                   INPUT pi-serie,            
                                   INPUT pi-nr-nota-fis).
        RUN piCloseConnection.
        RETURN "NOK":U.
    END.
    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

     RUN piEnviaEmailAstec (INPUT pi-cod-estabel,      
                               INPUT pi-serie,            
                               INPUT pi-nr-nota-fis).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE IntegraRastreamentoASTEC:
    DEFINE INPUT  PARAMETER pi-cod-estabel LIKE nota-fiscal.cod-estabel.
    DEFINE INPUT  PARAMETER pi-serie       LIKE nota-fiscal.serie.
    DEFINE INPUT  PARAMETER pi-nr-nota-fis LIKE nota-fiscal.nr-nota-fis.
    DEFINE INPUT  PARAMETER pi-nr-rastreamento LIKE int-nota-conhec.nr-conhec.
   
    DEFINE VARIABLE cXML     AS LONGCHAR    NO-UNDO.
    DEFINE VARIABLE cRetorno AS CHARACTER   NO-UNDO.

    ASSIGN cTituloEmail =  "Atualizacao Rastreamento ASTEC".

    IF '{&ativar-envio}' = 'yes' THEN
        RUN piConnection.

    IF  VALID-HANDLE(hService) THEN DO:

        RUN IntegraRastreamentoASTEC IN hService (INPUT pi-cod-estabel,       
                                                  INPUT pi-serie,             
                                                  INPUT pi-nr-nota-fis,     
                                                  INPUT pi-nr-rastreamento,
                                                  OUTPUT cRetorno).


        IF cRetorno <> "OK" THEN DO:
            CREATE RowErrors.
            ASSIGN RowErrors.errorsequence     = 1
                   RowErrors.errornumber       = 1
                   RowErrors.errordescription  = cRetorno
                   RowErrors.errorparameters   = "Custom":U
                   RowErrors.errortype         = "Error":U
                   RowErrors.errorhelp         = cRetorno + CHR(10) + cXML
                   RowErrors.errorsubtype      = "Custom":U.
            ASSIGN cErro = "Erro Atualizacao Rastreamento:" + CHR(10) + cRetorno.
            RUN piEnviaEmailAstec (INPUT pi-cod-estabel,      
                                   INPUT pi-serie,            
                                   INPUT pi-nr-nota-fis).
            RUN piCloseConnection.
            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        CREATE RowErrors.
        ASSIGN RowErrors.errorsequence     = 1
               RowErrors.errornumber       = 1
               RowErrors.errordescription  = "Erro de integraá∆o do ERP com CRM - WebService n∆o est† dipon°vel":U
               RowErrors.errorparameters   = "Custom":U
               RowErrors.errortype         = "Error":U
               RowErrors.errorhelp         =  "Erro de integraá∆o do ERP com CRM - WebService n∆o est† dipon°vel":U
               RowErrors.errorsubtype      = "Custom":U.
        ASSIGN cErro = "Erro Atualizacao Rastreamento:" + CHR(10) + RowErrors.errordescription.
            RUN piEnviaEmailAstec (INPUT pi-cod-estabel,      
                                   INPUT pi-serie,            
                                   INPUT pi-nr-nota-fis).
        RUN piCloseConnection.
        RETURN "NOK":U.
    END.
    IF '{&ativar-envio}' = 'yes' THEN
        RUN piCloseConnection.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piEnviaEmailAstec:
    DEF INPUT PARAMETER p-cod-estabel LIKE nota-fiscal.cod-estabel.
    DEF INPUT PARAMETER p-serie       LIKE nota-fiscal.serie.
    DEF INPUT PARAMETER p-nr-nota-fis LIKE nota-fiscal.nr-nota-fis.
    DEFINE VARIABLE cDestinatarioEmail   AS CHARACTER  NO-UNDO INITIAL ''.
    DEFINE VARIABLE cMensagem            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vArqMail             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
    DEF VAR i-nr-pedido LIKE ped-fiscal.nr-pedido.

    FOR EACH tt-mail.
        DELETE tt-mail.
    END.
    
    RUN esp/es0018p.p (INPUT "escrm001", /* Nome do programa */
                       INPUT 1,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    for each tt-prog-ponto:
        assign cDestinatarioEmail = cDestinatarioEmail + ENTRY(1, tt-prog-ponto.conteudo,";") + ";" .
    END.
    
    ASSIGN cMensagem =  "Nota Fiscal - ASTEC" +                CHR(10) + 
                        " EStabel: "     + p-cod-estabel     + CHR(10) + 
                        "   Serie: "     + p-serie           + CHR(10) + 
                        
                        "  Numero: "     + p-nr-nota-fis     + CHR(10).
    
    ASSIGN vArqMail = "".


    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = cDestinatarioEmail
           tt-mail.Assunto       = cTituloEmail
           tt-mail.Mensagem      = cMensagem + CHR(10) + cErro.
           tt-mail.Arquivo       = vArqMail.
    ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".

    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END PROCEDURE.

