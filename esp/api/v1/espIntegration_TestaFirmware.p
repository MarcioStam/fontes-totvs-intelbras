/****************************************************************************************************
** Autor: Isac Abrahao
**
** Objetivo: API armazena estado da gravacao do Firmware no produto 
**
** Data: 31/05/2022
**
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}        /*
{fwk/utils/fndApiServices.i}  */
{utp/ut-api-action.i piTestaFirmware POST /~*}
{utp/ut-api-notfound.i} 

DEFINE VARIABLE num-serie  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-data     AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-gravou   AS LOGICAL   NO-UNDO.

DEFINE VARIABLE c-arquivo-log1 AS CHARACTER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar AS CHAR NO-UNDO.

/* Temp-table de retorno, com as mensagens do processo */
DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD tip-msgs   AS INTEGER   FORMAT ">9":U INITIAL 1
    FIELD informacao AS CHARACTER FORMAT "x(250)"
    FIELD mensagem   AS CHARACTER FORMAT "x(250)":U.

/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/

PROCEDURE piTestaFirmware:

    DEFINE INPUT  PARAMETER jsonInput   AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER jsonOutput  AS JsonObject NO-UNDO.    

    DEFINE VARIABLE jsonObjectOutput    AS JsonObject NO-UNDO.
    DEFINE VARIABLE jsonObjectPayload   AS jsonObject NO-UNDO.

    DEFINE VARIABLE objTesteFirmware          AS JsonObject NO-UNDO.
    DEFINE VARIABLE arrayTesteFirmware        AS jsonArray  NO-UNDO.
    
    IF jsonInput:has("payload") THEN DO:
       ASSIGN jsonObjectPayload = jsonInput:GetJsonObject("payload").
         
       ASSIGN num-serie = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "serialNumber")
              l-gravou  = LOGICAL(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "firmware"))
              c-data    = JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "dateTime").
    END.
    
    FIND FIRST num-serie WHERE num-serie.n-serie = num-serie EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL num-serie THEN DO:
       RUN pi-cria-mensagem (INPUT 412,
                             INPUT "ERRO_DE_VALIDACAO",
                             INPUT 'Numero de serie nao encontrado.').
    END.
    ELSE DO:

        FIND FIRST num-serie-firmware EXCLUSIVE-LOCK 
             WHERE num-serie-firmware.n-serie = num-serie.n-serie
        NO-ERROR.

        IF NOT AVAIL num-serie-firmware THEN DO:
           CREATE num-serie-firmware.
           ASSIGN num-serie-firmware.n-serie = num-serie.n-serie.
        END.
                  
        ASSIGN num-serie-firmware.log-1  = l-gravou
               num-serie-firmware.char-1 = c-data.

        RUN pi-cria-mensagem (INPUT 200,
                              INPUT STRING(num-serie),
                              INPUT "OK").
    END.
    
    ASSIGN arrayTesteFirmware  = NEW JsonArray().

    FOR EACH tt-mensagem:
        ASSIGN objTesteFirmware = NEW JsonObject(). 
        
        objTesteFirmware:ADD("code", STRING(tt-mensagem.tip-msgs)).
        objTesteFirmware:ADD("message", tt-mensagem.mensagem).

        arrayTesteFirmware:ADD(objTesteFirmware).
    END.        
    
    jsonObjectOutput = NEW jsonObject().
    jsonObjectOutput:ADD("return", arrayTesteFirmware ).
    
    RUN createJsonResponse(INPUT jsonObjectOutput, INPUT TABLE rowErrors, INPUT false, OUTPUT jsonOutput).

END PROCEDURE.


      


PROCEDURE pi-cria-mensagem:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-codigo   AS INT  NO-UNDO.
    DEF INPUT PARAM p-inform   AS CHAR NO-UNDO.
    DEF INPUT PARAM p-mensagem AS CHAR NO-UNDO.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.tip-msgs   = p-codigo
           tt-mensagem.informacao = p-inform
           tt-mensagem.mensagem   = p-mensagem.

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

