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
            IF soap-procedure:NAME = ns-prefix + "login-b2b-suprimentos" THEN
                RUN process-login-b2b-suprimentos(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "esqueci-senha-b2b-suprimentos" THEN
                RUN process-esqueci-senha-b2b-suprimentos(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "altera-senha-b2b-suprimentos" THEN
                RUN process-altera-senha-b2b-suprimentos(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
        END.
    END.

    /* Clean up */
    DELETE OBJECT soap-procedure.
    DELETE PROCEDURE hutil.

    RETURN.
END PROCEDURE.

PROCEDURE process-login-b2b-suprimentos:
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

   DEFINE VARIABLE c-login        AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-cod-emitente AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-senha        AS CHARACTER NO-UNDO.

   DEFINE VARIABLE i-teste        AS INTEGER   NO-UNDO.

   DEFINE VARIABLE l-response     AS LOGICAL NO-UNDO.

   DEFINE BUFFER b-usuar_mestre FOR usuar_mestre.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.

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
         WHEN "login" THEN
            c-login = tt-xml.elementValue.
         WHEN "senha" THEN
            c-senha = LC(tt-xml.elementValue).
      END CASE.
   END.

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   IF (c-login <> ? AND c-login > "" AND c-senha <> ? AND c-senha > "") THEN DO:
      /** Tentativa de corrigir o problema do login de fornecedor conseguir ver todo mundo
      ASSIGN i-teste = INT(SUBSTRING(c-login, 1, 1)) NO-ERROR.

      IF (ERROR-STATUS:ERROR) THEN DO:
      **/

      /** Login do comprador **/
      FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = c-login NO-ERROR.

     IF AVAILABLE (usuar_mestre) THEN DO:
         FIND FIRST b-usuar_mestre NO-LOCK
            WHERE b-usuar_mestre.cod_usuario = 'adm' NO-ERROR.

         IF AVAILABLE (usuar_mestre) AND (usuar_mestre.dat_fim_valid >= TODAY) THEN DO:
            FIND FIRST usuar-mater NO-LOCK
               WHERE usuar-mater.cod-usuario = usuar_mestre.cod_usuario NO-ERROR.

            IF NOT AVAILABLE (usuar-mater) OR NOT (usuar-mater.usuar-comprador) THEN DO:
               ASSIGN l-response = YES.

               soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
               ttElements.nhandle:APPEND-CHILD(rspNode).

               soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = "19".
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).

               soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = "Acesso nao liberado".
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).
            END.
            ELSE IF (usuar_mestre.cod_senha = base64-encode(sha1-digest(lc(c-senha)))) THEN DO:
               ASSIGN l-response = YES.

               /** Cria o cabecalho de resposta **/
               soap-response:CREATE-NODE(rspNode, "m:login-b2b-suprimentos-response", "ELEMENT").
               rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:login-b2b-suprimentos-response").
               ttElements.nhandle:APPEND-CHILD(rspNode).

               soap-response:CREATE-NODE(hOrdNode, "usuar_mestre", "ELEMENT").
               rspNode:APPEND-CHILD(hOrdNode).

               soap-response:CREATE-NODE(xmlParam, "usuar_mestre.cod_usuario", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = usuar_mestre.cod_usuario NO-ERROR.
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).

               soap-response:CREATE-NODE(xmlParam, "usuar_mestre.nom_usuario", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = usuar_mestre.nom_usuario NO-ERROR.
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).
            END.
            ELSE IF (b-usuar_mestre.cod_senha = base64-encode(sha1-digest(lc(c-senha)))) THEN DO:
               /** Usando a senha do adm **/
               ASSIGN l-response = YES.

               /** Cria o cabecalho de resposta **/
               soap-response:CREATE-NODE(rspNode, "m:login-b2b-suprimentos-response", "ELEMENT").
               rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:login-b2b-suprimentos-response").
               ttElements.nhandle:APPEND-CHILD(rspNode).

               soap-response:CREATE-NODE(hOrdNode, "usuar_mestre", "ELEMENT").
               rspNode:APPEND-CHILD(hOrdNode).

               soap-response:CREATE-NODE(xmlParam, "usuar_mestre.cod_usuario", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = usuar_mestre.cod_usuario NO-ERROR.
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).

               soap-response:CREATE-NODE(xmlParam, "usuar_mestre.nom_usuario", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = usuar_mestre.nom_usuario NO-ERROR.
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).
            END.
            ELSE DO:
               ASSIGN l-response = YES.

               soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
               ttElements.nhandle:APPEND-CHILD(rspNode).

               soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = "21".
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).

               soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = "Senha incorreta".
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).
            END.
         END.
         ELSE DO:
            ASSIGN l-response = YES.

            soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
            ttElements.nhandle:APPEND-CHILD(rspNode).

            soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = "25".
            xmlParam:APPEND-CHILD(xmlText).
            rspNode:APPEND-CHILD(xmlParam).

            soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = "Usuario inexistente".
            xmlParam:APPEND-CHILD(xmlText).
            rspNode:APPEND-CHILD(xmlParam).
         END.
      END.
      ELSE DO:
         /** Login do fornecedor **/
         ASSIGN i-cod-emitente = INT(c-login) NO-ERROR.

         FOR FIRST emitente FIELDS (cod-emitente nome-emit natureza) NO-LOCK
            WHERE emitente.cod-emitente = i-cod-emitente:

            FIND FIRST int-emitente NO-LOCK
               WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

            IF AVAILABLE (int-emitente) THEN DO:
               /** Comentado, conforme solicitado pelo Flavio em 01.11.2006 **/
               /** O flag b2s sera utilizado em outro programa. Acesso livre para todos aqui **/
               /*
               IF (NOT int-emitente.b2s) THEN DO:
                  ASSIGN l-response = YES.

                  soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
                  ttElements.nhandle:APPEND-CHILD(rspNode).

                  soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = "19".
                  xmlParam:APPEND-CHILD(xmlText).
                  rspNode:APPEND-CHILD(xmlParam).

                  soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = "Acesso nao liberado".
                  xmlParam:APPEND-CHILD(xmlText).
                  rspNode:APPEND-CHILD(xmlParam).
               END.
               */
               IF (NOT l-response AND int-emitente.senha <> c-senha) THEN DO:
                  ASSIGN l-response = YES.

                  soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
                  ttElements.nhandle:APPEND-CHILD(rspNode).

                  soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = "21".
                  xmlParam:APPEND-CHILD(xmlText).
                  rspNode:APPEND-CHILD(xmlParam).

                  soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = "Senha incorreta".
                  xmlParam:APPEND-CHILD(xmlText).
                  rspNode:APPEND-CHILD(xmlParam).
               END.
               IF (NOT l-response) THEN DO:
                  ASSIGN l-response = YES.

                  /** Cria o cabecalho de resposta **/
                  soap-response:CREATE-NODE(rspNode, "m:login-b2b-suprimentos-response", "ELEMENT").
                  rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:login-b2b-suprimentos-response").
                  ttElements.nhandle:APPEND-CHILD(rspNode).

                  soap-response:CREATE-NODE(hOrdNode, "emitente", "ELEMENT").
                  rspNode:APPEND-CHILD(hOrdNode).

                  hOrdNode:SET-ATTRIBUTE("emitente.natureza", STRING(emitente.natureza)) NO-ERROR.

                  IF (int-emitente.b2s) THEN
                     hOrdNode:SET-ATTRIBUTE("int-emitente.b2s", "true") NO-ERROR.
                  ELSE
                     hOrdNode:SET-ATTRIBUTE("int-emitente.b2s", "false") NO-ERROR.

                  soap-response:CREATE-NODE(xmlParam, "emitente.cod-emitente", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = STRING(emitente.cod-emitente) NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hOrdNode:APPEND-CHILD(xmlParam).

                  soap-response:CREATE-NODE(xmlParam, "emitente.nome-emit", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = emitente.nome-emit NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hOrdNode:APPEND-CHILD(xmlParam).
               END.
            END.
            ELSE DO:
               ASSIGN l-response = YES.

               soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
               ttElements.nhandle:APPEND-CHILD(rspNode).

               soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = "19".
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).

               soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = "Acesso nao liberado".
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).
            END.
         END. /** FOR FIRST **/
         IF (NOT l-response) THEN DO:
            soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
            ttElements.nhandle:APPEND-CHILD(rspNode).

            soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = "23".
            xmlParam:APPEND-CHILD(xmlText).
            rspNode:APPEND-CHILD(xmlParam).

            soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = "Emitente inexistente".
            xmlParam:APPEND-CHILD(xmlText).
            rspNode:APPEND-CHILD(xmlParam).
         END.
      END. /** ELSE **/
   END. /** IF **/
   ELSE DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "13".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Requisicao sem emitente/senha".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

PROCEDURE process-esqueci-senha-b2b-suprimentos:
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

   DEFINE VARIABLE c-login        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE i-cod-emitente AS INTEGER    NO-UNDO.
   DEFINE VARIABLE c-array        AS CHARACTER  NO-UNDO EXTENT 36
            INIT [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
                   "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1",
                   "2", "3", "4", "5", "6", "7", "8", "9" ].

   DEFINE VARIABLE i-teste        AS INTEGER   NO-UNDO.

   DEFINE VARIABLE l-response     AS LOGICAL NO-UNDO.
   DEFINE VARIABLE hCtoNode       AS HANDLE  NO-UNDO.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
   CREATE X-NODEREF hCtoNode.

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
         WHEN "login" THEN
            c-login = tt-xml.elementValue.
      END CASE.
   END.

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   IF (c-login <> ?) AND (c-login > "") THEN DO:
      ASSIGN i-teste = INT(SUBSTRING(c-login, 1, 1)) NO-ERROR.

      IF NOT (ERROR-STATUS:ERROR) THEN DO:
         /** Login do fornecedor **/
         ASSIGN i-cod-emitente = INT(c-login).

         FOR FIRST emitente FIELDS (cod-emitente nome-emit natureza) NO-LOCK
            WHERE emitente.cod-emitente = i-cod-emitente:

            FIND FIRST emitente-cex OF emitente NO-LOCK NO-ERROR.

            DO TRANSACTION:
               FIND FIRST int-emitente OF emitente EXCLUSIVE-LOCK NO-ERROR.
               ASSIGN int-emitente.senha = c-array[RANDOM(1,36)] + c-array[RANDOM(1,36)] + c-array[RANDOM(1,36)] + c-array[RANDOM(1,36)] + c-array[RANDOM(1,36)] + c-array[RANDOM(1,36)].
            END.

            IF AVAILABLE (int-emitente) AND (int-emitente.senha <> ?) AND (int-emitente.senha <> "") THEN DO:
               ASSIGN l-response = YES.

               /** Cria o cabecalho de resposta **/
               soap-response:CREATE-NODE(rspNode, "m:esqueci-senha-b2b-suprimentos-response", "ELEMENT").
               rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:esqueci-senha-b2b-suprimentos-response").
               ttElements.nhandle:APPEND-CHILD(rspNode).

               soap-response:CREATE-NODE(hOrdNode, "emitente", "ELEMENT").
               rspNode:APPEND-CHILD(hOrdNode).

               hOrdNode:SET-ATTRIBUTE("emitente.natureza", STRING(emitente.natureza)) NO-ERROR.
               IF AVAILABLE (emitente-cex) THEN
                  hOrdNode:SET-ATTRIBUTE("emitente-cex.cod-idioma", emitente-cex.cod-idioma) NO-ERROR.

               soap-response:CREATE-NODE(xmlParam, "emitente.cod-emitente", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = STRING(emitente.cod-emitente) NO-ERROR.
               xmlParam:APPEND-CHILD(xmlText).
               hOrdNode:APPEND-CHILD(xmlParam).

               soap-response:CREATE-NODE(xmlParam, "emitente.nome-emit", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = emitente.nome-emit NO-ERROR.
               xmlParam:APPEND-CHILD(xmlText).
               hOrdNode:APPEND-CHILD(xmlParam).

               soap-response:CREATE-NODE(xmlParam, "int-emitente.senha", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = int-emitente.senha NO-ERROR.
               xmlParam:APPEND-CHILD(xmlText).
               hOrdNode:APPEND-CHILD(xmlParam).

               FOR EACH cont-emit FIELDS (nome e-mail) OF emitente NO-LOCK
                  WHERE cont-emit.e-mail <> ?
                    AND cont-emit.e-mail <> "":
                  soap-response:CREATE-NODE(hCtoNode, "cont-emit", "ELEMENT").
                  hOrdNode:APPEND-CHILD(hCtoNode).

                  soap-response:CREATE-NODE(xmlParam, "cont-emit.nome", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = cont-emit.nome NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hCtoNode:APPEND-CHILD(xmlParam).

                  soap-response:CREATE-NODE(xmlParam, "cont-emit.e-mail", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = cont-emit.e-mail NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hCtoNode:APPEND-CHILD(xmlParam).
               END.
            END.
            ELSE DO:
               ASSIGN l-response = YES.

               soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
               ttElements.nhandle:APPEND-CHILD(rspNode).

               soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = "19".
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).

               soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = "Acesso nao liberado".
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).
            END.
         END. /** FOR FIRST **/
         IF (NOT l-response) THEN DO:
            soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
            ttElements.nhandle:APPEND-CHILD(rspNode).

            soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = "23".
            xmlParam:APPEND-CHILD(xmlText).
            rspNode:APPEND-CHILD(xmlParam).

            soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = "Emitente inexistente".
            xmlParam:APPEND-CHILD(xmlText).
            rspNode:APPEND-CHILD(xmlParam).
         END.
      END. /** ELSE **/
   END. /** IF **/
   ELSE DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "13".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Requisicao sem emitente".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

PROCEDURE process-altera-senha-b2b-suprimentos:
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

   DEFINE VARIABLE c-cod-emitente AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE c-senha-antiga AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE c-senha-nova   AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE i-cod-emitente AS INTEGER    NO-UNDO.

   DEFINE VARIABLE i-teste        AS INTEGER   NO-UNDO.

   DEFINE VARIABLE l-response     AS LOGICAL NO-UNDO.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.

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
         WHEN "senha-antiga" THEN
            c-senha-antiga = tt-xml.elementValue.
         WHEN "senha-nova" THEN
            c-senha-nova = tt-xml.elementValue.
      END CASE.
   END.

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   IF (c-cod-emitente <> ?) AND (c-cod-emitente > "") THEN DO:
      ASSIGN i-teste = INT(SUBSTRING(c-cod-emitente, 1, 1)) NO-ERROR.

      IF NOT (ERROR-STATUS:ERROR) THEN DO:
         /** Login do fornecedor **/
         ASSIGN i-cod-emitente = INT(c-cod-emitente).

         FOR FIRST emitente FIELDS (cod-emitente nome-emit natureza) NO-LOCK
            WHERE emitente.cod-emitente = i-cod-emitente:

            DO TRANSACTION:
               FIND FIRST int-emitente OF emitente EXCLUSIVE-LOCK NO-ERROR.
               IF (int-emitente.senha = c-senha-antiga) THEN
                  ASSIGN int-emitente.senha = c-senha-nova.
            END.

            IF (int-emitente.senha = c-senha-nova) THEN DO:
               ASSIGN l-response = YES.

               /** Cria o cabecalho de resposta **/
               soap-response:CREATE-NODE(rspNode, "m:altera-senha-b2b-suprimentos-response", "ELEMENT").
               rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:altera-senha-b2b-suprimentos-response").
               rspNode:SET-ATTRIBUTE("xmlns:rpc", "http://www.w3.org/2001/09/soap-rpc").
               ttElements.nhandle:APPEND-CHILD(rspNode).

               soap-response:CREATE-NODE(hOrdNode,"rpc:result","ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = "true".
               hOrdNode:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(hOrdNode).
            END.
            ELSE DO:
               ASSIGN l-response = YES.

               soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
               ttElements.nhandle:APPEND-CHILD(rspNode).

               soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = "37".
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).

               soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = "Senha atual incorreta".
               xmlParam:APPEND-CHILD(xmlText).
               rspNode:APPEND-CHILD(xmlParam).
            END.
         END. /** FOR FIRST **/
         IF (NOT l-response) THEN DO:
            soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
            ttElements.nhandle:APPEND-CHILD(rspNode).

            soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = "23".
            xmlParam:APPEND-CHILD(xmlText).
            rspNode:APPEND-CHILD(xmlParam).

            soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = "Emitente inexistente".
            xmlParam:APPEND-CHILD(xmlText).
            rspNode:APPEND-CHILD(xmlParam).
         END.
      END. /** ELSE **/
   END. /** IF **/
   ELSE DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "13".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Requisicao sem emitente".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.
