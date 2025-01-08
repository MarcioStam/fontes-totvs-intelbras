block-level on error undo, throw.

/** Carrega bibliotecas necessarias **/
USING OpenEdge.Core.*. 
USING OpenEdge.Net.HTTP.*. 
USING OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder. 

DEFINE INPUT PARAMETER c-tid AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER c-plp AS CHAR NO-UNDO.

DEFINE VARIABLE oRequest AS IHttpRequest NO-UNDO.
DEFINE VARIABLE oResponse AS IHttpResponse NO-UNDO.

DEFINE VARIABLE oResponseMemptrEntity AS OpenEdge.Core.Memptr NO-UNDO. 
DEFINE VARIABLE oByteBucket AS OpenEdge.Core.ByteBucket NO-UNDO. 

DEFINE VARIABLE c-endereco AS CHAR NO-UNDO.
DEFINE VARIABLE c-file     AS CHAR NO-UNDO.

{esp/es0018.i}

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT  "WSO0003":U,
                   INPUT  8,
                   INPUT  0,
                   INPUT  "":U,
                   OUTPUT TABLE tt-prog-ponto).

IF OPSYS = "UNIX":U THEN
    FOR FIRST tt-prog-ponto
        WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = "UNIX":
        ASSIGN c-file = REPLACE(ENTRY(2,tt-prog-ponto.conteudo,";"), "~\":U, "/":U).
    END.
ELSE
    FOR FIRST tt-prog-ponto
        WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = "WIN":
        ASSIGN c-file = REPLACE(ENTRY(2,tt-prog-ponto.conteudo,";"), "~\":U, "/":U).
    END.
    
ASSIGN c-endereco = "https://api.skyhub.com.br/shipments/b2w/view?plp_id=" + c-plp.

oRequest = RequestBuilder:GET(c-endereco)
                         :AddHeader("x-api-key","KQTK8iqSZzny_JqvJYpL")
                         :AddHeader("x-user-email","leandro.jonk@intelbras.com.br")
                         :AddHeader("accept","application/pdf")
                         :Request.

oResponse = ClientBuilder:Build():Client:Execute(oRequest).

oByteBucket = CAST(oResponse:Entity,OpenEdge.Core.ByteBucket). 
oResponseMemptrEntity = oByteBucket:GetBytes().

ASSIGN c-file = c-file + c-tid + ".pdf".


IF SEARCH(c-file) <> ? THEN
    OS-DELETE VALUE(c-file) NO-ERROR.

COPY-LOB FROM oResponseMemptrEntity:Value TO FILE c-file.

RETURN "OK".
