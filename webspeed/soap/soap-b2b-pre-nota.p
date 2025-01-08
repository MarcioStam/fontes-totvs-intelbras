/*****************************************************************************
*
* This file contains sample code which may assist you in creating applications.
* You may use the code as you see fit. If you modify the code or include it in
* another software program, you will refrain from identifying Progress Software
* as the supplier of the code, or using any Progress Software trademarks in 
* connection with your use of the code. THE CODE IS NOT SUPPORTED BY PROGRESS
* SOFTWARE AND IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, INCLUDING,
* WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
* PURPOSE OR NONINFRINGEMENT.
*
*******************************************************************************/

/*------------------------------------------------------------------------
  File: soaptest.p

  Description: This procedure does the translation from XML to an AppServer
  call. This has to be handcoded for each AppServer call exported as SOAP.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: David Cleary

  Version: 0.1
------------------------------------------------------------------------*/
{soap/xmlutil.i}
{soap/soap-xml.i}

DEF VAR hutil AS HANDLE NO-UNDO.
RUN soap/xmlutil.p PERSISTENT SET hutil.

PROCEDURE process-soap-request:

    DEF INPUT PARAM soap-application-name AS CHAR NO-UNDO.
    DEF INPUT PARAM soap-element AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM soap-response AS HANDLE NO-UNDO.

    DEF VAR soap-procedure AS HANDLE NO-UNDO.
    DEF VAR soap-response-text AS CHAR NO-UNDO.
    DEF VAR soap-memptr AS MEMPTR NO-UNDO.
    DEF VAR i AS INT NO-UNDO.
    DEF VAR j AS INT NO-UNDO.
    DEF VAR found AS INT NO-UNDO.
    DEF VAR ret AS LOGICAL NO-UNDO.
    DEF VAR aname AS CHAR NO-UNDO.
    DEF VAR anames AS CHAR NO-UNDO.
    DEF VAR ns-prefix AS CHAR NO-UNDO.
    DEF VAR ns-uri AS CHAR NO-UNDO.

    CREATE X-DOCUMENT soap-response.
    CREATE X-NODEREF soap-procedure.

    /* This is the template we use to wrap our response. */
    soap-response-text = 
    "<?xml version='1.0' ?>
     <SOAP-ENV:Envelope xmlns:SOAP-ENV=~"http://schemas.xmlsoap.org/soap/envelope/~"
     SOAP-ENV:encodingStyle=~"http://schemas.xmlsoap.org/soap/encoding/~">~n
     <SOAP-ENV:Body>~n
     </SOAP-ENV:Body>~n
     </SOAP-ENV:Envelope>".
    SET-SIZE(soap-memptr) = LENGTH(soap-response-text) + 1.
    PUT-STRING(soap-memptr, 1) = soap-response-text.
    soap-response:LOAD("memptr", soap-memptr, FALSE).

    /* Get the procedure we want to call */
    REPEAT i = 1 TO soap-element:NUM-CHILDREN:
        ret = soap-element:GET-CHILD(soap-procedure, i).
        IF (ret = TRUE) AND (soap-procedure:SUBTYPE = "element") THEN DO:
            /* Loop through our attributes looking for xmlns */
            anames = soap-procedure:ATTRIBUTE-NAMES.
            REPEAT j = 1 TO NUM-ENTRIES(anames):
                aname = ENTRY(j,anames).
                /* This is looking for our namespace URI and prefix */
                IF INDEX(aname, "xmlns") = 1 THEN DO:
                    found = INDEX(aname, ":").
                    IF found > 0 THEN
                        ns-prefix = SUBSTRING(aname, found + 1) + ":".
                    ELSE
                        ns-prefix = "".
                    ns-uri = soap-procedure:GET-ATTRIBUTE(aname).
                END.
            END.

            /* Here we statically look at our element name to determine what
             * AppServer procedure to call.
             */
            IF soap-procedure:NAME = ns-prefix + "create-pre-nota" THEN
                RUN process-create-pre-nota(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
        END.
    END.

    /* Clean up */
    DELETE OBJECT soap-procedure.
    DELETE PROCEDURE hutil.

    RETURN.
END PROCEDURE.

PROCEDURE process-create-pre-nota:
   DEF INPUT PARAM appservice AS CHAR NO-UNDO.
   DEF INPUT PARAM soap-procedure AS HANDLE NO-UNDO.
   DEF INPUT PARAM ns-prefix AS CHAR NO-UNDO.
   DEF INPUT-OUTPUT PARAM soap-response AS HANDLE NO-UNDO.

   DEF VAR happ AS HANDLE NO-UNDO.
   DEF VAR rspNode AS HANDLE NO-UNDO.
   DEF VAR xmlParam AS HANDLE NO-UNDO.
   DEF VAR xmlText AS HANDLE NO-UNDO.

   DEFINE VARIABLE hDoc      AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hCustRoot AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hCustNode AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hOrdRoot  AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hOrdNode  AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hField    AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hText     AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hBuf      AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hDBFld    AS HANDLE  NO-UNDO.
   DEFINE VARIABLE i         AS INTEGER NO-UNDO.
   DEFINE VARIABLE j         AS INTEGER NO-UNDO.

   DEFINE VARIABLE c-cod-emitente AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-nro-docto    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-serie        AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-dt-emissao   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-cod-emitente AS INTEGER   NO-UNDO.
   DEFINE VARIABLE i-nro-docto    AS INTEGER   NO-UNDO.
   DEFINE VARIABLE dt-emissao     AS DATE      NO-UNDO.

   DEFINE VARIABLE l-response     AS LOGICAL NO-UNDO.
   DEFINE VARIABLE hOCNode        AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hOrdem         AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hItem          AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hChildItem     AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hChildText     AS HANDLE  NO-UNDO.
   
   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
   CREATE X-NODEREF hOCNode.
   CREATE X-NODEREF hOrdem.
   CREATE X-NODEREF hItem.
   CREATE X-NODEREF hChildItem.
   CREATE X-NODEREF hChildText.

   /** Variaveis para o SAX **/
   DEFINE VARIABLE hParser  AS HANDLE.
   DEFINE VARIABLE hHandler AS HANDLE.

   CREATE SAX-READER hParser.

   /** Procedures de callback para o SAX **/
   RUN soap/soap-xml.p PERSISTENT SET hHandler.

   hParser:HANDLER = hHandler.
   hParser:SET-INPUT-SOURCE("HANDLE", WEB-CONTEXT).
   hParser:SAX-PARSE() NO-ERROR.

   RUN retorna-tt IN hHandler (OUTPUT TABLE tt-xml).
   RUN Cleanup    IN hHandler.

   /** Apaga da memoria o objeto e procedure do SAX **/
   DELETE OBJECT hParser.
   DELETE PROCEDURE hHandler.

   FOR EACH tt-xml NO-LOCK:
      CASE tt-xml.elementName:
         WHEN "cod-emitente" THEN
            c-cod-emitente = tt-xml.elementValue.
         WHEN "nro-docto" THEN
            c-nro-docto = tt-xml.elementValue.
         WHEN "serie" THEN
            c-serie = tt-xml.elementValue.
         WHEN "dt-emissao" THEN
            c-dt-emissao = tt-xml.elementValue.
      END CASE.
   END.

   IF (c-cod-emitente <> ? AND c-cod-emitente > "") THEN
      ASSIGN i-cod-emitente = INT(c-cod-emitente).

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   /** Para a data estar no formato de acordo com o XML Schema **/
   SESSION:DATE-FORMAT = "ymd".

   IF (c-dt-emissao <> ?) AND (c-dt-emissao > "") THEN
      ASSIGN dt-emissao = DATE(c-dt-emissao).

   IF NOT CAN-FIND (FIRST pre-nota NO-LOCK
                      WHERE pre-nota.cod-emitente = i-cod-emitente
                        AND pre-nota.nro-docto    = c-nro-docto
                        AND pre-nota.serie        = c-serie) THEN DO:

      RUN getElementsByTagName IN hutil(INPUT soap-procedure, "ordem-parcela", OUTPUT TABLE ttElements).
      FIND FIRST ttElements NO-LOCK NO-ERROR.
      IF AVAILABLE ttElements THEN
         hOrdem = ttElements.nhandle.

      IF VALID-HANDLE (hOrdem) THEN DO:
         /** Percorre as tags de itens dentro da ordem-parcela **/
         REPEAT i = 1 TO hOrdem:NUM-CHILDREN:
            /** Pega o item **/
            IF (hOrdem:GET-CHILD(hItem, i)) THEN DO:
               /** Com o item, pega os dois filhos e joga na tt **/
               CREATE pre-nota.
               ASSIGN pre-nota.cod-emitente = i-cod-emitente
                      pre-nota.nro-docto    = c-nro-docto
                      pre-nota.serie        = c-serie
                      pre-nota.dt-emissao   = dt-emissao
                      pre-nota.importado    = NO.

               REPEAT j = 1 TO 3:
                  IF (hItem:GET-CHILD(hChildItem, j)) THEN DO:
                     /** Ve quem e' e joga no campo correto **/
                     IF (hChildItem:GET-CHILD(hChildText, 1)) THEN
                        IF (hChildItem:NAME = "numero-ordem") THEN
                           ASSIGN pre-nota.numero-ordem = INT(hChildText:NODE-VALUE).
                        ELSE IF (hChildItem:NAME = "parcela") THEN
                           ASSIGN pre-nota.parcela = INT(hChildText:NODE-VALUE).
                        ELSE IF (hChildItem:NAME = "quantidade") THEN
                           ASSIGN pre-nota.quantidade = DECIMAL(hChildText:NODE-VALUE).
                  END. /** IF **/
               END. /** REPEAT **/
            END. /** IF **/
         END. /** REPEAT **/
      END. /** IF VALID-HANDLE **/

      /** Movido para ca pra evitar erros **/
      soap-response:GET-DOCUMENT-ELEMENT(rspNode).
      RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
      FIND FIRST ttElements.

      IF CAN-FIND (FIRST pre-nota NO-LOCK
                      WHERE pre-nota.cod-emitente = i-cod-emitente
                        AND pre-nota.nro-docto    = c-nro-docto
                        AND pre-nota.serie        = c-serie) THEN DO:
         soap-response:CREATE-NODE(rspNode, "m:create-pre-nota-response", "ELEMENT").
         rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:create-pre-nota-response").
         rspNode:SET-ATTRIBUTE("xmlns:rpc", "http://www.w3.org/2001/09/soap-rpc").
         ttElements.nhandle:APPEND-CHILD(rspNode).

         soap-response:CREATE-NODE(hOrdNode,"rpc:result","ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = "ok".
         hOrdNode:APPEND-CHILD(xmlText).
         rspNode:APPEND-CHILD(hOrdNode).
      END.
      ELSE DO:
         soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
         ttElements.nhandle:APPEND-CHILD(rspNode).

         soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = "39".
         xmlParam:APPEND-CHILD(xmlText).
         rspNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = "Nao gravado no banco".
         xmlParam:APPEND-CHILD(xmlText).
         rspNode:APPEND-CHILD(xmlParam).
      END.
   END. /** IF NOT CAN-FIND **/
   ELSE DO:
      /** Caso a nota ja exista na tabela **/
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "40".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Nota ja existente no sistema".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.
END PROCEDURE.

