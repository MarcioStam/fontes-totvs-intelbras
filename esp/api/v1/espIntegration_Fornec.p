{utp/ut-api.i}
{utp/ut-api-utils.i}
{utp/ut-api-action.i pi-consulta-fornec get /~*}
{utp/ut-api-notfound.i} 

/************************************************************************************
* Programa ..: API Rest espIntegration_Fornec                                       *
* Data ......: 31/01/2023                                                           *
* Autor .....: Andrey M Oliveira                                                    *
* Versao ....: 1.00.00.000                                                          *
************************************************************************************/

{esp/es0018.i}

DEF VAR jEmit         AS JsonObject           NO-UNDO.
DEF VAR jContatos     AS JsonObject           NO-UNDO.
DEF VAR jEmail        AS JsonObject           NO-UNDO.
DEF VAR jArrayContato AS JsonArray            NO-UNDO.
DEF VAR jArrayEmit    AS JsonArray            NO-UNDO.

DEF VAR h-calc        AS HANDLE               NO-UNDO.
DEF VAR c-jason       AS CHAR                 NO-UNDO.

DEF NEW GLOBAL SHARED VAR i-ep-codigo-usuario AS CHAR NO-UNDO.

DEF TEMP-TABLE tt-emitente NO-UNDO
    FIELD identification_number  LIKE emitente.cgc
    FIELD legal_name             LIKE emitente.nome-emit                  
    FIELD municipal_registration LIKE mgcad.cidade.cdn-munpio-ibge
    FIELD erp_code               AS CHAR.

DEF TEMP-TABLE tt-mail-emitente NO-UNDO
    FIELD erp_code               AS CHAR
    FIELD email                  AS CHAR.


PROCEDURE pi-consulta-fornec:
    /*
    IF  OPSYS = 'UNIX' THEN DO:                                
        OUTPUT TO "/mnt/spool/an052677/fornec.txt" APPEND.
        PUT UNFORMATTED "1" SKIP.
        OUTPUT CLOSE.                                
    END.
    */

    DEF INPUT  PARAM jsonInput  AS JsonObject NO-UNDO.
    DEF OUTPUT PARAM jsonOutput AS JsonObject NO-UNDO.

    DEF VAR oResponse         AS JsonAPIResponse          NO-UNDO.
    DEF VAR oRequestParser    AS JsonAPIRequestParser     NO-UNDO.
    DEF VAR oJsonObject       AS JsonObject               NO-UNDO.
    DEF VAR jPrincipal        AS JsonObject               NO-UNDO.
    DEF VAR jArrayPrincipal   AS JsonArray                NO-UNDO.
    DEF VAR jsonObjectPayload AS jsonObject               NO-UNDO.
                                                          
    DEF VAR v_dia             AS INT                      NO-UNDO.
    DEF VAR v_mes             AS INT                      NO-UNDO.
    DEF VAR v_ano             AS INT                      NO-UNDO.
    DEF VAR v_dt_criacao      AS DATE FORMAT "99/99/9999" NO-UNDO.
    DEF VAR v_dt_aux          AS CHAR                     NO-UNDO.
    DEF VAR v_page            AS INT                      NO-UNDO.
    DEF VAR v_size_page       AS INT                      NO-UNDO.
    DEF VAR v_ult_reg         AS INT                      NO-UNDO.
    DEF VAR v_tot_pag         AS INT                      NO-UNDO.
    DEF VAR v_aux             AS INT                      NO-UNDO.

    DELETE OBJECT jEmit         NO-ERROR.
    DELETE OBJECT jContatos     NO-ERROR.
    DELETE OBJECT jEmail        NO-ERROR.
    DELETE OBJECT jArrayContato NO-ERROR.
    DELETE OBJECT jArrayEmit    NO-ERROR.

    IF jsonInput:has("queryParams") THEN DO:
        ASSIGN jsonObjectPayload = jsonInput:GetJsonObject("queryParams").
    
        ASSIGN v_page      = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "page"))
               v_size_page = INT(JsonAPIUtils:getPropertyJsonObject(jsonObjectPayload, "page_size")).
    END.

    IF  v_page       = ?
    OR  v_size_page  = ? THEN 
        NEXT.

    ASSIGN v_aux     = 0
           v_ult_reg = (v_page - 1) * v_size_page.

    RUN esp/es0018p.p (INPUT "v360",
                       INPUT 1, /* Dt implantacao dos fornecedores considerados na integracao */
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto NO-LOCK NO-ERROR.

    IF  AVAIL tt-prog-ponto THEN
        ASSIGN v_dt_criacao = date(tt-prog-ponto.conteudo).
    ELSE
        NEXT.

    EMPTY TEMP-TABLE tt-emitente.
    EMPTY TEMP-TABLE tt-mail-emitente.
    
    FOR EACH emitente
        WHERE emitente.identific   <> 1
        AND   emitente.data-implant >= v_dt_criacao NO-LOCK:

        FIND FIRST mgcad.cidade NO-LOCK
            WHERE mgcad.cidade.pais   = emitente.pais
            AND   mgcad.cidade.estado = emitente.estado
            AND   mgcad.cidade.cidade = emitente.cidade NO-ERROR.

        FIND FIRST tt-emitente
            WHERE tt-emitente.erp_code = STRING(emitente.cod-emit) NO-LOCK NO-ERROR.

        IF  NOT AVAIL tt-emitente THEN DO:
            ASSIGN v_aux = v_aux + 1.

            IF  v_page = 1 THEN DO:
                IF  v_aux > INT(v_size_page) THEN
                    NEXT.
            END.
            ELSE DO:
                IF  v_aux <= v_ult_reg THEN
                    NEXT.

                IF  (v_aux - v_ult_reg) > v_size_page THEN
                    NEXT.
            END.

            CREATE tt-emitente.
            ASSIGN tt-emitente.identification_number  = emitente.cgc                
                   tt-emitente.legal_name             = emitente.nome-emit          
                   tt-emitente.municipal_registration = mgcad.cidade.cdn-munpio-ibge WHEN AVAIL mgcad.cidade
                   tt-emitente.erp_code               = STRING(emitente.cod-emit).
                                                                                       
            IF  emitente.e-mail <> "" THEN DO:
                CREATE tt-mail-emitente.
                ASSIGN tt-mail-emitente.erp_code = STRING(emitente.cod-emit)
                       tt-mail-emitente.email    = emitente.e-mail.
            END.

            FOR EACH cont-emit
                WHERE cont-emit.cod-emit = emitente.cod-emit NO-LOCK:

                IF  cont-emit.e-mail <> "" THEN DO:
                    FIND FIRST tt-mail-emitente
                        WHERE tt-mail-emitente.erp_code = STRING(emitente.cod-emit)
                        AND   tt-mail-emitente.email    = cont-emit.e-mail NO-LOCK NO-ERROR.

                    IF  NOT AVAIL tt-mail-emitente THEN DO:
                        CREATE tt-mail-emitente.
                        ASSIGN tt-mail-emitente.erp_code = STRING(emitente.cod-emit)
                               tt-mail-emitente.email    = cont-emit.e-mail.
                    END.
                END.

            END.
        END.
    END.

    ASSIGN v_tot_pag = (v_aux / int(v_size_page)) + 1.

    IF  (v_aux / (v_tot_pag - 1)) <= int(v_size_page) THEN
        ASSIGN v_tot_pag = v_tot_pag - 1.

    ASSIGN jPrincipal = new JsonObject().

    jPrincipal:ADD("currentPage",INT(v_page)).
    jPrincipal:ADD("totalPages",v_tot_pag).
    jPrincipal:ADD("pageSize",INT(v_size_page)).
    jPrincipal:ADD("totalResults",v_aux).

    ASSIGN jArrayEmit = NEW JsonArray().

    FOR EACH tt-emitente:
        ASSIGN jEmit = NEW JsonObject().
    
        jEmit:ADD("identificationNumber",tt-emitente.identification_number).
        jEmit:ADD("legalName",tt-emitente.legal_name).
        jEmit:ADD("municipalRegistration",tt-emitente.municipal_registration).
        jEmit:ADD("erpCode",tt-emitente.erp_code).
    
        ASSIGN jContatos     = NEW JsonObject().
        ASSIGN jArrayContato = NEW JsonArray().

        FOR EACH tt-mail-emitente
            WHERE tt-mail-emitente.erp_code = tt-emitente.erp_code:

            assign jEmail = new JsonObject().
            
            jEmail:add("email",tt-mail-emitente.email).

            jArrayContato:add(jEmail).
        END.

        jEmit:ADD("emails",jArrayContato).
        jArrayEmit:ADD(jEmit).

        jPrincipal:ADD("payload",jArrayEmit).
    END.
    /*
    ELSE DO:
        /* nao encontrou o pedido */
        jsonOutput = JsonAPIResponseBuilder:OK(jsonInput, 404).
    END.
    */

    IF  v_aux = 0 THEN 
        RETURN.

    RUN createJsonResponse(INPUT  jPrincipal, 
                           INPUT  TABLE RowErrors, 
                           INPUT  FALSE,
                           OUTPUT jsonOutput).   
    
    ASSIGN c-jason = string(jPrincipal:getjsontext()).

    IF  OPSYS = 'UNIX' THEN DO:                                
        OUTPUT TO "/mnt/spool/an052677/tst.json" APPEND.
        PUT UNFORMATTED c-jason.
        OUTPUT CLOSE.
    END.

END PROCEDURE. /* procedure pi-consulta-fornec */
