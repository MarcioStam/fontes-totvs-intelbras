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
            IF soap-procedure:NAME = ns-prefix + "zoom-pagamento-emitente-exportacao" THEN
                RUN process-zoom-pagamento-emitente-exportacao(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "zoom-pagamento-emitente-nacional" THEN
                RUN process-zoom-pagamento-emitente-nacional(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
        END.
    END.

    /* Clean up */
    DELETE OBJECT soap-procedure.
    DELETE PROCEDURE hutil.

    RETURN.
END PROCEDURE.

PROCEDURE process-zoom-pagamento-emitente-exportacao:
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

   DEFINE VARIABLE c-cod-emitente AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-cod-emitente AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-invoice      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-nr-pagamento AS INTEGER   NO-UNDO.

   DEFINE VARIABLE l-response   AS LOGICAL NO-UNDO.
   DEFINE VARIABLE hMoeNode     AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hInvNode     AS HANDLE  NO-UNDO.

   DEFINE VARIABLE hQuery  AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hBuffer AS HANDLE    NO-UNDO.
   DEFINE VARIABLE c-where AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-sort  AS CHARACTER NO-UNDO.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
   CREATE X-NODEREF hMoeNode.
   CREATE X-NODEREF hInvNode.

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
         WHEN "invoice" THEN
            c-invoice = tt-xml.elementValue.
      END CASE.
   END.

   IF (c-cod-emitente <> ? AND c-cod-emitente > "") THEN
      ASSIGN i-cod-emitente = INT(c-cod-emitente).

   SESSION:NUMERIC-FORMAT = "AMERICAN".

   /** Para a data estar no formato de acordo com o XML Schema **/
   SESSION:DATE-FORMAT = "ymd".

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   FOR FIRST emitente FIELDS (cod-emitente natureza) NO-LOCK
      WHERE emitente.cod-emitente = i-cod-emitente:

      IF (emitente.natureza = 3) THEN DO:
         /** Estrangeiro, informacoes estao na tabela pagamento **/
         CREATE QUERY hQuery.

         IF (c-invoice = ? OR c-invoice = "") THEN DO:
            ASSIGN c-where = "EACH pagamento FIELDS (nr-pagamento cod-moeda dt-prev-fecha-cam dt-fecha-cam nr-cont-cambio data-swift swift txt-observacao modalidade) NO-LOCK
                                 WHERE pagamento.cod-emitente       = " + STRING(emitente.cod-emitente) + "
                                   AND pagamento.dt-prev-fecha-cam >= TODAY - 60,
                                 EACH pagamento-invoice NO-LOCK
                                    WHERE pagamento-invoice.nr-pagamento = pagamento.nr-pagamento ".
            ASSIGN c-sort = " BY pagamento.nr-pagamento BY pagamento-invoice.parcela".

            hQuery:SET-BUFFERS(BUFFER pagamento:Handle, BUFFER pagamento-invoice:Handle).
         END.
         ELSE DO:
            ASSIGN c-where = "EACH pagamento-invoice NO-LOCK
                                 WHERE pagamento-invoice.nr-invoice MATCHES '*" + c-invoice + "*',
                                 EACH pagamento FIELDS (nr-pagamento cod-moeda dt-prev-fecha-cam dt-fecha-cam nr-cont-cambio data-swift swift txt-observacao modalidade) NO-LOCK
                                    WHERE pagamento.cod-emitente = " + STRING(emitente.cod-emitente) + "
                                      AND pagamento.nr-pagamento = pagamento-invoice.nr-pagamento ".
            ASSIGN c-sort = " BY pagamento.nr-pagamento BY pagamento-invoice.parcela".

            hQuery:SET-BUFFERS(BUFFER pagamento-invoice:Handle, BUFFER pagamento:Handle).
         END.

         MESSAGE c-where.

         IF (hQuery:QUERY-PREPARE("PRESELECT " + c-where + c-sort) = FALSE) THEN DO:
            soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
            ttElements.nhandle:APPEND-CHILD(rspNode).

            soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = "99".
            xmlParam:APPEND-CHILD(xmlText).
            rspNode:APPEND-CHILD(xmlParam).

            soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = "Erro na query - entre em contato com o Dep. de Informatica".
            xmlParam:APPEND-CHILD(xmlText).
            rspNode:APPEND-CHILD(xmlParam).
            LEAVE.
         END.

         hQuery:QUERY-OPEN.

         IF (hQuery:NUM-RESULTS = 0) THEN DO:
            soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
            ttElements.nhandle:APPEND-CHILD(rspNode).

            soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = "27".
            xmlParam:APPEND-CHILD(xmlText).
            rspNode:APPEND-CHILD(xmlParam).

            soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = "Nenhum pagamento a ser exibido".
            xmlParam:APPEND-CHILD(xmlText).
            rspNode:APPEND-CHILD(xmlParam).
         END.
         ELSE DO:
            soap-response:CREATE-NODE(rspNode, "m:zoom-pagamento-emitente-response", "ELEMENT").
            rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-pagamento-emitente-response").
            ttElements.nhandle:APPEND-CHILD(rspNode).

            REPEAT:
               hQuery:GET-NEXT.
               IF (hQuery:QUERY-OFF-END) THEN
                  LEAVE.

               /** Ja que Query nao tem BREAK BY, fazemos do jeito antigo **/
               IF (i-nr-pagamento <> pagamento.nr-pagamento) THEN DO:
                  ASSIGN i-nr-pagamento = pagamento.nr-pagamento.

                  soap-response:CREATE-NODE(hOrdNode, "pagamento", "ELEMENT").
                  rspNode:APPEND-CHILD(hOrdNode).

                  hOrdNode:SET-ATTRIBUTE("pagamento.nr-pagamento", STRING(pagamento.nr-pagamento)) NO-ERROR.
                  hOrdNode:SET-ATTRIBUTE("pagamento.cod-moeda", STRING(pagamento.cod-moeda)) NO-ERROR.

                  soap-response:CREATE-NODE(xmlParam, "pagamento.dt-prev-fecha-cam", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = STRING(pagamento.dt-prev-fecha-cam, "9999-99-99") NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hOrdNode:APPEND-CHILD(xmlParam).

                  soap-response:CREATE-NODE(xmlParam, "pagamento.dt-fecha-cam", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = STRING(pagamento.dt-fecha-cam, "9999-99-99") NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hOrdNode:APPEND-CHILD(xmlParam).

                  soap-response:CREATE-NODE(xmlParam, "pagamento.nr-cont-cambio", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = STRING(pagamento.nr-cont-cambio) NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hOrdNode:APPEND-CHILD(xmlParam).

                  soap-response:CREATE-NODE(xmlParam, "pagamento.data-swift", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = STRING(pagamento.data-swift, "9999-99-99") NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hOrdNode:APPEND-CHILD(xmlParam).

                  soap-response:CREATE-NODE(xmlParam, "pagamento.swift", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = pagamento.swift NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hOrdNode:APPEND-CHILD(xmlParam).

                  soap-response:CREATE-NODE(xmlParam, "pagamento.historico", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = (pagamento.txt-observacao) NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hOrdNode:APPEND-CHILD(xmlParam).

                  soap-response:CREATE-NODE(xmlParam, "pagamento.modalidade", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = pagamento.modalidade NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hOrdNode:APPEND-CHILD(xmlParam).

                  FIND FIRST moeda NO-LOCK
                     WHERE moeda.mo-codigo = pagamento.cod-moeda NO-ERROR.

                  IF AVAILABLE (moeda) THEN DO:
                     soap-response:CREATE-NODE(xmlParam, "moeda.descricao", "ELEMENT").
                     soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                     xmlText:NODE-VALUE = moeda.descricao NO-ERROR.
                     xmlParam:APPEND-CHILD(xmlText).
                     hOrdNode:APPEND-CHILD(xmlParam).

                     soap-response:CREATE-NODE(xmlParam, "moeda.sigla", "ELEMENT").
                     soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                     xmlText:NODE-VALUE = moeda.sigla NO-ERROR.
                     xmlParam:APPEND-CHILD(xmlText).
                     hOrdNode:APPEND-CHILD(xmlParam).
                  END.
               END. /** IF FIRST-OF **/

               soap-response:CREATE-NODE(hInvNode, "pagamento-invoice", "ELEMENT").
               hOrdNode:APPEND-CHILD(hInvNode).

               hInvNode:SET-ATTRIBUTE("pagamento-invoice.parcela", STRING(pagamento-invoice.parcela)) NO-ERROR.

               soap-response:CREATE-NODE(xmlParam, "pagamento-invoice.embarque", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = pagamento-invoice.embarque NO-ERROR.
               xmlParam:APPEND-CHILD(xmlText).
               hInvNode:APPEND-CHILD(xmlParam).

               soap-response:CREATE-NODE(xmlParam, "pagamento-invoice.nr-invoice", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = pagamento-invoice.nr-invoice NO-ERROR.
               xmlParam:APPEND-CHILD(xmlText).
               hInvNode:APPEND-CHILD(xmlParam).

               soap-response:CREATE-NODE(xmlParam, "pagamento-invoice.valor", "ELEMENT").
               soap-response:CREATE-NODE(xmlText, ?, "TEXT").
               xmlText:NODE-VALUE = STRING(pagamento-invoice.valor) NO-ERROR.
               xmlParam:APPEND-CHILD(xmlText).
               hInvNode:APPEND-CHILD(xmlParam).
            END. /** REPEAT **/
         END. /** ELSE DO **/
      END. /** IF **/
   END. /** FOR EACH **/
   IF NOT (l-response) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "1".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Emitente invalido".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   DELETE OBJECT hQuery.
   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

DEFINE TEMP-TABLE tt-tit_ap
   FIELD cod_estab            LIKE tit_ap.cod_estab
   FIELD dat_vencto_tit_ap    LIKE tit_ap.dat_vencto_tit_ap
   FIELD cod_tit_ap           LIKE tit_ap.cod_tit_ap
   FIELD dat_ult_pagto        LIKE tit_ap.dat_ult_pagto
   FIELD val_sdo_tit_ap       LIKE tit_ap.val_sdo_tit_ap
   FIELD val_pagto_tit_ap     LIKE tit_ap.val_pagto_tit_ap
   FIELD val_origin_tit_ap    LIKE tit_ap.val_origin_tit_ap
   FIELD val_multa_tit_ap     LIKE tit_ap.val_multa_tit_ap
   FIELD val_juros_dia_atraso LIKE tit_ap.val_juros_dia_atraso
   INDEX ch-pri AS PRIMARY dat_vencto_tit_ap cod_tit_ap cod_estab
   INDEX ch-tit AS UNIQUE cod_estab cod_tit_ap.

PROCEDURE process-zoom-pagamento-emitente-nacional:
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

   DEFINE VARIABLE c-cod-emitente AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-cod-emitente AS INTEGER   NO-UNDO.
   DEFINE VARIABLE i-nr-pagamento AS INTEGER   NO-UNDO.

   DEFINE VARIABLE l-response   AS LOGICAL NO-UNDO.
   DEFINE VARIABLE hMoeNode     AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hInvNode     AS HANDLE  NO-UNDO.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
   CREATE X-NODEREF hMoeNode.
   CREATE X-NODEREF hInvNode.

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
      END CASE.
   END.

   IF (c-cod-emitente <> ? AND c-cod-emitente > "") THEN
      ASSIGN i-cod-emitente = INT(c-cod-emitente).

   SESSION:NUMERIC-FORMAT = "AMERICAN".

   /** Para a data estar no formato de acordo com o XML Schema **/
   SESSION:DATE-FORMAT = "ymd".

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   FIND FIRST param-global NO-LOCK.
   FIND FIRST mgcad.empresa NO-LOCK
      WHERE empresa.ep-codigo = param-global.empresa-pri.

   FOR FIRST emitente FIELDS (cod-emitente natureza) NO-LOCK
      WHERE emitente.cod-emitente = i-cod-emitente:

      IF (emitente.natureza <> 3) THEN DO:
         FOR EACH estabelec NO-LOCK
            WHERE estabelec.ep-codigo = empresa.ep-codigo, 
            EACH tit_ap FIELDS (cod_estab cod_tit_ap dat_vencto_tit_ap dat_ult_pagto val_sdo_tit_ap val_pagto_tit_ap val_origin_tit_ap val_multa_tit_ap val_juros_dia_atraso) NO-LOCK
            WHERE tit_ap.cod_estab          = estabelec.cod-estabel
              AND tit_ap.cdn_fornecedor     = emitente.cod-emitente
              AND tit_ap.dat_vencto_tit_ap >= TODAY - 60:

            CREATE tt-tit_ap.
            ASSIGN tt-tit_ap.cod_estab            = tit_ap.cod_estab
                   tt-tit_ap.dat_vencto_tit_ap    = tit_ap.dat_vencto_tit_ap
                   tt-tit_ap.cod_tit_ap           = tit_ap.cod_tit_ap
                   tt-tit_ap.dat_ult_pagto        = tit_ap.dat_ult_pagto
                   tt-tit_ap.val_sdo_tit_ap       = tit_ap.val_sdo_tit_ap
                   tt-tit_ap.val_pagto_tit_ap     = tit_ap.val_pagto_tit_ap
                   tt-tit_ap.val_origin_tit_ap    = tit_ap.val_origin_tit_ap
                   tt-tit_ap.val_multa_tit_ap     = tit_ap.val_multa_tit_ap
                   tt-tit_ap.val_juros_dia_atraso = tit_ap.val_juros_dia_atraso.
         END.

         FOR EACH tt-tit_ap
            BY tt-tit_ap.dat_vencto_tit_ap:

            IF NOT (l-response) THEN DO:
               ASSIGN l-response = YES.

               soap-response:CREATE-NODE(rspNode, "m:zoom-pagamento-emitente-nacional-response", "ELEMENT").
               rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-pagamento-emitente-nacional-response").
               ttElements.nhandle:APPEND-CHILD(rspNode).
            END.

            soap-response:CREATE-NODE(hOrdNode, "tit_ap", "ELEMENT").
            rspNode:APPEND-CHILD(hOrdNode).

            hOrdNode:SET-ATTRIBUTE("tit_ap.cod_tit_ap", STRING(tt-tit_ap.cod_tit_ap)) NO-ERROR.

            soap-response:CREATE-NODE(xmlParam, "tit_ap.dat_vencto_tit_ap", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = STRING(tt-tit_ap.dat_vencto_tit_ap, "9999-99-99") NO-ERROR.
            xmlParam:APPEND-CHILD(xmlText).
            hOrdNode:APPEND-CHILD(xmlParam).

            soap-response:CREATE-NODE(xmlParam, "tit_ap.dat_ult_pagto", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = STRING(tt-tit_ap.dat_ult_pagto, "9999-99-99") NO-ERROR.
            xmlParam:APPEND-CHILD(xmlText).
            hOrdNode:APPEND-CHILD(xmlParam).

            soap-response:CREATE-NODE(xmlParam, "tit_ap.val_sdo_tit_ap", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = STRING(tt-tit_ap.val_sdo_tit_ap) NO-ERROR.
            xmlParam:APPEND-CHILD(xmlText).
            hOrdNode:APPEND-CHILD(xmlParam).

            soap-response:CREATE-NODE(xmlParam, "tit_ap.val_pagto_tit_ap", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = STRING(tt-tit_ap.val_pagto_tit_ap) NO-ERROR.
            xmlParam:APPEND-CHILD(xmlText).
            hOrdNode:APPEND-CHILD(xmlParam).

            soap-response:CREATE-NODE(xmlParam, "tit_ap.val_origin_tit_ap", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = STRING(tt-tit_ap.val_origin_tit_ap) NO-ERROR.
            xmlParam:APPEND-CHILD(xmlText).
            hOrdNode:APPEND-CHILD(xmlParam).

            soap-response:CREATE-NODE(xmlParam, "tit_ap.val_multa_tit_ap", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = STRING(tt-tit_ap.val_multa_tit_ap) NO-ERROR.
            xmlParam:APPEND-CHILD(xmlText).
            hOrdNode:APPEND-CHILD(xmlParam).

            soap-response:CREATE-NODE(xmlParam, "tit_ap.val_juros_dia_atraso", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = STRING(tt-tit_ap.val_juros_dia_atraso) NO-ERROR.
            xmlParam:APPEND-CHILD(xmlText).
            hOrdNode:APPEND-CHILD(xmlParam).
         END. /** FOR EACH **/
      END. /** IF **/
      ELSE DO:
         soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
         ttElements.nhandle:APPEND-CHILD(rspNode).

         soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = "1".
         xmlParam:APPEND-CHILD(xmlText).
         rspNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = "Emitente invalido".
         xmlParam:APPEND-CHILD(xmlText).
         rspNode:APPEND-CHILD(xmlParam).
      END.
   END. /** FOR EACH **/
   IF NOT (l-response) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "1".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Emitente invalido".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

