USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.ObjectModelParser.
USING Progress.Lang.Object.
USING OpenEdge.Core.WidgetHandle.
USING OpenEdge.Core.String.
USING OpenEdge.Net.HTTP.IHttpRequest.
USING OpenEdge.Net.HTTP.IHttpResponse.
USING OpenEdge.Net.HTTP.ClientBuilder.
USING OpenEdge.Net.HTTP.RequestBuilder. 

{esp/es0018.i}

DEFINE INPUT  PARAMETER p-transacao AS CHAR     NO-UNDO.
DEFINE INPUT  PARAMETER requisicao  AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pResposta   AS CHAR     NO-UNDO.
 
DEFINE VARIABLE oEntity   AS Object        NO-UNDO.
DEFINE VARIABLE httpUrl   AS CHARACTER     NO-UNDO.
DEFINE VARIABLE oRequest  AS IHttpRequest  NO-UNDO.
DEFINE VARIABLE oResponse AS IHttpResponse NO-UNDO.
DEFINE VARIABLE iXml      AS STRING        NO-UNDO.

/* MESSAGE STRING(requisicao)             */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK. */
/*Transforma o xml de requisi»’o no objeto itpo String para realizar a requisi»’o*/
ASSIGN iXml = new String(requisicao).

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "wso2":U, INPUT 1, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
 
FOR FIRST tt-prog-ponto
    WHERE entry(1,tt-prog-ponto.conteudo, ";") = p-transacao: END.

IF NOT AVAIL tt-prog-ponto THEN
    RETURN "NOK".

httpUrl = entry(2,tt-prog-ponto.conteudo, ";") + p-transacao.

/*-----------------------------------------*/
/*            Monta a requisi‡Æo           */
/*-----------------------------------------*/
IF p-transacao = "v1/pedido/notafiscal" THEN DO:
    oRequest = RequestBuilder:POST(httpUrl, iXml)
               :ContentType("application/xml")
               :AcceptAll()
               :Request.
END.
ELSE DO:
    oRequest = RequestBuilder:PUT(httpUrl, iXml)
               :ContentType("application/xml")
               :AcceptAll()
               :Request.
END.

DEFINE VARIABLE lcHTML AS LONGCHAR NO-UNDO.
DEFINE VARIABLE hXmlDoc AS HANDLE NO-UNDO. 

oResponse = ClientBuilder:Build():Client:Execute(oRequest).
oEntity = oResponse:Entity.

/*-------------------------------------------------------*/
/*            Recebe e devolve a resposta                */
/*-------------------------------------------------------*/
IF TYPE-OF(oEntity, WidgetHandle) THEN DO:
    hXmlDoc = CAST(oEntity, WidgetHandle):Value. 
    /*resposta = oEntity:toString().*/

    DEF VAR I AS INTEGER NO-UNDO.
    DEF VAR j AS INTEGER NO-UNDO.
    DEF VAR c-cod-status AS CHAR.
    DEF VAR c-msg-status AS CHAR.

    define variable hRoot   as handle   no-undo.
    define variable hAux1   as handle   no-undo.
    define variable hAux2   as handle   no-undo.
    define variable hValue  as handle   no-undo.
    create x-noderef hRoot.
    create x-noderef hAux1.
    create x-noderef hAux2.
    create x-noderef hValue.

    DEF VAR c-resultado AS CHAR FORMAT "x(10)" NO-UNDO.
    DEF VAR c-mensagem  AS CHAR FORMAT "x(200)" NO-UNDO.
    
    hXmlDoc:GET-DOCUMENT-ELEMENT(hRoot).
    
    do i = 1 to hRoot:num-children:
       hRoot:get-child(hAux1, i).
       IF (hAux1:NAME = 'status') THEN DO:
          DO  j = 1 TO hAux1:NUM-CHILDREN:
             hAux1:get-child(hAux2, j).
             ASSIGN c-resultado = hAux2:NODE-VALUE.
             LEAVE.
          END.
       END.
       IF  (hAux1:NAME = 'message') THEN DO:
           DO j = 1 TO hAux1:NUM-CHILDREN:
              hAux1:GET-CHILD(hAux2, j).
              ASSIGN c-mensagem = hAux2:NODE-VALUE.
              LEAVE.
            END.
       END.
    END.

    ASSIGN pResposta = c-resultado + ";" + c-mensagem.

    IF  VALID-HANDLE(hValue)  THEN DELETE OBJECT hValue.
    IF  VALID-HANDLE(hAux2)   THEN DELETE OBJECT hAux2.
    IF  VALID-HANDLE(hAux1)   THEN DELETE OBJECT hAux1.
    IF  VALID-HANDLE(hRoot)   THEN DELETE OBJECT hRoot.
    IF  VALID-HANDLE(hXmlDoc) THEN DELETE OBJECT hXmlDoc.
END.


/* /*Transforma o retorno em longchar*/         */
/* IF oResponse:Entity <> ? THEN DO:            */
/*     oEntity  = oResponse:Entity.             */
/*     resposta = oEntity:toString().           */
/* END.                                         */
/*                                              */
/*  MESSAGE oResponse:StatusCode SKIP           */
/*          oResponse:StatusReason SKIP         */
/*          oResponse:Entity SKIP               */
/*          string(resposta) VIEW-AS ALERT-BOX. */

/*
MESSAGE pResposta
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
*/
