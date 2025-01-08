/****************************************************************************************************
** Autor: Marcio Stammerjohann
**
** Objetivo: API Recuperacao Danfe e XML
**
** Data: 01/06/2022
**
****************************************************************************************************/
{utp/ut-api.i}
{utp/ut-api-utils.i}        /*
{fwk/utils/fndApiServices.i}  */
{utp/ut-api-action.i piBuscaDanfeXml GET /~*}
{utp/ut-api-notfound.i} 

{esp/es0018.i}

//variaveis testes notas
DEFINE VAR c-serie          AS CHAR NO-UNDO.
DEFINE VAR c-nota-fiscal    AS CHAR NO-UNDO.
DEFINE VAR c-estab          AS CHAR NO-UNDO.
DEFINE VAR c-cgc            AS CHAR NO-UNDO.
//DEFINE VAR i-cont           AS INTE NO-UNDO.
DEFINE VAR c-danfe          AS CHAR NO-UNDO.
DEFINE VAR c-xml            AS CHAR NO-UNDO.
DEFINE VAR c-codigo-msg     AS CHAR NO-UNDO.
DEFINE VAR c-msg            AS CHAR NO-UNDO.
//fim

DEFINE VARIABLE c-arquivo-log1 AS CHARACTER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar AS CHAR NO-UNDO.

/* Temp-table de retorno, com as mensagens do processo */
DEFINE TEMP-TABLE tt-mensagem //NO-UNDO
    FIELD tip-msgs   AS INTEGER   FORMAT ">9":U INITIAL 1
    FIELD informacao AS CHARACTER FORMAT "x(250)"
    FIELD mensagem   AS CHARACTER FORMAT "x(250)":U85
    FIELD arquivo    AS CHARACTER.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen AS INT             
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".

/* Inicio */
/****************************************************************************************************/

PROCEDURE piBuscaDanfeXml:
    def input  param jsonInput  as JsonObject no-undo.
    def output param jsonOutput as JsonObject no-undo.

    def var oResponse        as JsonAPIResponse      no-undo.
    def var oRequestParser   as JsonAPIRequestParser no-undo.
    def var oJsonObject      as JsonObject           no-undo.
    def var jPrincipal       as JsonObject           no-undo.
    def var jArrayPrincipal  as JsonArray            no-undo.
    DEF VAR jsonObjectOutput AS JsonObject           NO-UNDO.
    def var i-aux            as INT                  no-undo.
    def var i-num-param      as INT                  NO-UNDO.
    DEF VAR objNotaFiscal    AS JsonObject           NO-UNDO.
    DEF VAR arrayNotaFiscal  AS jsonArray            NO-UNDO.
    DEF VAR encdmptr-danfe   AS MEMPTR               NO-UNDO.
    DEF VAR encdlngc-danfe   AS LONGCHAR             NO-UNDO.
    DEF VAR encdmptr-xml     AS MEMPTR               NO-UNDO.
    DEF VAR encdlngc-xml     AS LONGCHAR             NO-UNDO.

    DELETE OBJECT objNotaFiscal   NO-ERROR.
    DELETE OBJECT arrayNotaFiscal NO-ERROR.
    DELETE OBJECT jArrayPrincipal NO-ERROR.
    DELETE OBJECT oJsonObject     NO-ERROR. 

    empty temp-table RowErrors.

    assign oRequestParser = new JsonAPIRequestParser(jsonInput) no-error.

    assign jArrayPrincipal = new JsonArray().
    jArrayPrincipal = oRequestParser:getPathParams() no-error.

    ASSIGN i-num-param = jArrayPrincipal:length no-error.

    if i-num-param > 1 
    then.
    else return.

    do i-aux = 1 to i-num-param:
        case i-aux:
            when 1 then 
                assign c-nota-fiscal = JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux) no-error.
            when 2 then 
                ASSIGN c-serie = string(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux)) no-error.
            when 3 THEN 
                ASSIGN c-estab = string(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux)) no-error.
            when 4 then 
                assign c-cgc = string(JsonAPIUtils:getPropertyJsonArray(jArrayPrincipal, i-aux)) no-error.
        end case.
    end.

    ASSIGN c-arquivo-log1 = '/mnt/spool/log-danfe-xml/' + c-nota-fiscal + '-buscaDanfe.txt'.

    RUN pi-gerar-dados-extrato ('buscaDanfe 05 ' ).
    RUN pi-gerar-dados-extrato ('buscaDanfe 05 c-nota-fiscal ' + c-nota-fiscal ).
    RUN pi-gerar-dados-extrato ('buscaDanfe 05 c-serie ' + c-serie ).
    RUN pi-gerar-dados-extrato ('buscaDanfe 05 c-estab ' + c-estab ).
    RUN pi-gerar-dados-extrato ('buscaDanfe 05 c-cgc '  + c-cgc).  
    
    RUN piValidacao.

    RUN pi-gerar-dados-extrato ('return value - ' + STRING(RETURN-VALUE)). 
    IF RETURN-VALUE = "OK" THEN DO:

       RUN pi-gerar-dados-extrato ('ANTES esftp0529 - 1' ).
       RUN pi-gerar-dados-extrato (c-nota-fiscal + " " + c-serie + " " + c-estab) .

       if search("esp/ftp/esftp0529.p") <> ?
       or search("esp/ftp/esftp0529.r") <> ? then do:

         RUN pi-gerar-dados-extrato ('ANTES esftp0529 - 2' ).

         RUN esp/ftp/esftp0529.p (INPUT c-nota-fiscal,
                                  INPUT c-serie ,
                                  INPUT c-estab,
                                  OUTPUT c-danfe, //c-danfe
                                  OUTPUT c-xml).   //c-xml

         RUN pi-gerar-dados-extrato (c-danfe ).
         RUN pi-gerar-dados-extrato ('ANTES esftp0529 - 3' ).
         RUN pi-gerar-dados-extrato (c-xml).
         RUN pi-gerar-dados-extrato ('ANTES esftp0529 - 4' ).

       END.

       RUN pi-gerar-dados-extrato ("depois esftp0529 - 3") .

       IF c-danfe <> "" AND c-xml <> "" THEN DO:
           RUN pi-cria-mensagem (INPUT 200,
                                 INPUT '',
                                 INPUT "Sucesso",
                                 INPUT 'Arquivos gerado com sucesso.').
       END.
       ELSE DO:
           RUN pi-cria-mensagem (INPUT 404,
                                 INPUT '',
                                 INPUT "Erro",
                                 INPUT 'Arquivos nao encontrado.'). 
       END.

       RUN pi-gerar-dados-extrato ('ANTES esftp0529 - 5' ).
       
       IF c-danfe <> "" THEN DO:
          COPY-LOB FROM FILE c-danfe TO encdmptr-danfe.
          encdlngc-danfe = BASE64-ENCODE(encdmptr-danfe).
       END.

       IF c-xml <> "" THEN DO:
          COPY-LOB FROM FILE c-xml TO encdmptr-xml.
          encdlngc-xml = BASE64-ENCODE(encdmptr-xml).  
       END.
    END.

    if i-aux = 0
    then return.

    assign arrayNotaFiscal = new JsonArray().
    ASSIGN objNotaFiscal = NEW JsonObject().

    arrayNotaFiscal:ADD(objNotaFiscal).
    
    objNotaFiscal:ADD("code", c-codigo-msg).
    objNotaFiscal:ADD("message",c-msg).
    objNotaFiscal:ADD("danfe",encdmptr-danfe).
    objNotaFiscal:ADD("xml",encdmptr-xml).
    
    RUN pi-gerar-dados-extrato ('buscaDanfe 93').

    //jsonObjectOutput = NEW jsonObject().
    //jsonObjectOutput:ADD("return", arrayNotaFiscal ).
    
    RUN pi-gerar-dados-extrato ('buscaDanfe 94').

    //jsonOutput = JsonAPIResponseBuilder:OK(jsonInput, 404).
    
    RUN createJsonResponse(INPUT objNotaFiscal, //jsonObjectOutput, 
                           INPUT TABLE rowErrors, 
                           INPUT false, 
                           OUTPUT jsonOutput).

    RUN pi-gerar-dados-extrato ('buscaDanfe 95').

END PROCEDURE. 

PROCEDURE pi-cria-mensagem:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-codigo   AS INT  NO-UNDO.
    DEF INPUT PARAM p-arquivo  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-inform   AS CHAR NO-UNDO.
    DEF INPUT PARAM p-mensagem AS CHAR NO-UNDO.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.tip-msgs   = p-codigo
           tt-mensagem.arquivo    = p-arquivo
           tt-mensagem.informacao = p-inform
           tt-mensagem.mensagem   = p-mensagem.

    ASSIGN c-codigo-msg = STRING(p-codigo)
           c-msg        = p-mensagem.

    RUN pi-gerar-dados-extrato ("CRIA MENSAGEM - "  + string(tt-mensagem.tip-msgs) + '- ' + tt-mensagem.mensagem + ' - ' + tt-mensagem.arquivo + ' - ' + tt-mensagem.informacao).

END PROCEDURE.


PROCEDURE piValidacao:

    FIND FIRST nota-fiscal NO-LOCK
         WHERE nota-fiscal.nr-nota-fis = c-nota-fiscal
           AND nota-fiscal.serie       = c-serie
           AND nota-fiscal.cod-estabel = c-estab NO-ERROR.
    IF NOT AVAIL nota-fiscal THEN DO:
        RUN pi-cria-mensagem (INPUT 404,
                              INPUT '',
                              INPUT "ERRO_DE_VALIDACAO",
                              INPUT 'Nota fiscal nao encontrada.').

        RETURN "NOK".
    END.  
    ELSE DO:
         IF nota-fiscal.idi-sit-nf-eletro <> 3 THEN DO:
             RUN pi-cria-mensagem (INPUT 404,
                                   INPUT '',
                                   INPUT "Erro",
                                   INPUT 'Nota fiscal nao autorizada.').
             RETURN "NOK".
         END.
         ELSE IF nota-fiscal.cgc <> c-cgc THEN DO:
                RUN pi-cria-mensagem (INPUT 404,
                                      INPUT '',
                                      INPUT "ERRO",
                                      INPUT 'Nota fiscal nao pertence ao cpf/cnpj ' + " " + STRING(c-cgc) ).
                RETURN "NOK".
         END.
         ELSE DO:
             RUN pi-cria-mensagem (INPUT 200,
                                   INPUT '',
                                   INPUT "SUCESSO",
                                   INPUT 'Nota fiscal encontrada' ).
         END.
    END.

    RUN pi-gerar-dados-extrato ("Fim validate").

    RETURN "OK".
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
