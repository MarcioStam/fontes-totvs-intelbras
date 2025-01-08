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
            IF soap-procedure:NAME = ns-prefix + "zoom-emitente" THEN
                RUN process-zoom-emitente(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "find-emitente" THEN
                RUN process-find-emitente(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
        END.
    END.

    /* Clean up */
    DELETE OBJECT soap-procedure.
    DELETE PROCEDURE hutil.

    RETURN.
END PROCEDURE.

/** tt auxiliar **/
DEFINE TEMP-TABLE tt-emitente
   FIELD cod-emitente LIKE emitente.cod-emitente
   INDEX ch-emitente  AS PRIMARY UNIQUE cod-emitente.

PROCEDURE process-zoom-emitente:
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

   DEFINE VARIABLE c-usuario  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-atrasado AS CHARACTER NO-UNDO.
   DEFINE VARIABLE dt-proxima AS DATE      NO-UNDO.

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
         WHEN "usuario" THEN
            c-usuario = tt-xml.elementValue.
      END CASE.
   END.

   /** Para a data estar no formato de acordo com o XML Schema **/
   SESSION:DATE-FORMAT = "ymd".

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.
/*
   FOR EACH int-pedido-compr FIELDS (liberado) NO-LOCK
      WHERE NOT int-pedido-compr.liberado
         OR NOT int-pedido-compr.recebido,
      FIRST pedido-compr FIELDS (cod-emitente) NO-LOCK
         WHERE pedido-compr.num-pedido  = int-pedido-compr.num-pedido
           AND pedido-compr.situacao    < 3
           AND pedido-compr.responsavel = c-usuario:

      IF NOT CAN-FIND (FIRST tt-emitente NO-LOCK
                          WHERE tt-emitente.cod-emitente = pedido-compr.cod-emitente) THEN DO:
         CREATE tt-emitente.
         ASSIGN tt-emitente.cod-emitente = pedido-compr.cod-emitente.
      END.
   END.
   */
    FOR EACH ordem-compra
       WHERE ordem-compra.cod-comprado = c-usuario
         AND ordem-compra.situacao = 2 NO-LOCK:
        FIND pedido-compr WHERE
             pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.
        IF NOT AVAIL pedido-compr THEN NEXT.
        FIND FIRST int-pedido-compr
             WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-LOCK NO-ERROR.
        IF NOT AVAIL int-pedido-compr THEN NEXT.
    
        IF int-pedido-compr.liberado = NO OR
           int-pedido-compr.recebido = NO THEN DO:
            IF NOT CAN-FIND (FIRST tt-emitente NO-LOCK
                                WHERE tt-emitente.cod-emitente = pedido-compr.cod-emitente) THEN DO:
               CREATE tt-emitente.
               ASSIGN tt-emitente.cod-emitente = pedido-compr.cod-emitente.
               DISP pedido-compr.cod-emitente.
            END.
        END.
    END.

   FOR EACH item-uni-estab NO-LOCK 
      WHERE item-uni-estab.cod-comprado = c-usuario,
      FIRST ITEM NO-LOCK 
      WHERE ITEM.it-codigo = item-uni-estab.it-codigo AND ITEM.cod-obsoleto = 1,
       EACH item-fornec NO-LOCK
      WHERE item-fornec.it-codigo = item.it-codigo
        AND item-fornec.ativo,
      FIRST emitente  NO-LOCK
      WHERE emitente.cod-emitente = item-fornec.cod-emitente
      BREAK BY emitente.nome-emit
            BY emitente.cod-emitente:
       
       IF NOT (l-response) THEN DO:
           ASSIGN l-response = YES.
           
           /** Cria o cabecalho de resposta **/
           soap-response:CREATE-NODE(rspNode, "m:zoom-emitente-response", "ELEMENT").
           rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-emitente-response").
           ttElements.nhandle:APPEND-CHILD(rspNode).
       END.

       IF FIRST-OF (emitente.cod-emitente) THEN DO:
           FIND FIRST ordem-compra NO-LOCK
                WHERE ordem-compra.cod-emitente = emitente.cod-emitente
                  AND ordem-compra.situacao     = 2
/*                  AND ordem-compra.it-codigo    = item-uni-estab.it-codigo*/
                  AND ordem-compra.num-pedido   > 0
                  AND ordem-compra.cod-comprado = c-usuario NO-ERROR.

          FIND FIRST int-emitente OF emitente NO-LOCK NO-ERROR.

          soap-response:CREATE-NODE(hOrdNode, "emitente", "ELEMENT").
          rspNode:APPEND-CHILD(hOrdNode).

          IF AVAILABLE (ordem-compra) THEN
              hOrdNode:SET-ATTRIBUTE("tem-pedido", "true") NO-ERROR.
          ELSE
              hOrdNode:SET-ATTRIBUTE("tem-pedido", "false") NO-ERROR.

          /** SOS 30017 **/
          ASSIGN c-atrasado = "false"
                 dt-proxima = ?.

          IF (emitente.natureza = 3) THEN DO:
              FOR EACH ordem-compra FIELDS (situacao) NO-LOCK
                 WHERE ordem-compra.cod-emitente = emitente.cod-emitente
                   AND ordem-compra.situacao     = 2
                   AND ordem-compra.num-pedido   > 0,
                 FIRST pedido-compr FIELDS (situacao) NO-LOCK
                 WHERE pedido-compr.num-pedido  = ordem-compra.num-pedido
                   AND pedido-compr.situacao    < 3
                   AND pedido-compr.responsavel = c-usuario,
                 FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = pedido-compr.cod-estabel,
                 FIRST int-pedido-compr NO-LOCK
                 WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido
                   AND int-pedido-compr.liberado
                   AND int-pedido-compr.recebido,
                  EACH prazo-compra FIELDS (parcela) NO-LOCK
                 WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                   AND prazo-compra.situacao     = 2
                   AND prazo-compra.quant-saldo  > 0,
                  EACH ordens-embarque FIELDS (parcela) NO-LOCK
                 WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                   AND ordens-embarque.parcela      = prazo-compra.parcela,
                 FIRST cotacao-item FIELDS (cot-aprovada) NO-LOCK
                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                   AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                   AND cotacao-item.cot-aprovada,
                 FIRST itinerario FIELDS (cod-itiner) NO-LOCK
                 WHERE itinerario.cod-itiner = cotacao-item.int-1,
                 FIRST historico-embarque FIELDS (dt-ult-previsao) NO-LOCK
                 WHERE historico-embarque.cod-estabel   = estabelec.cod-estabel
                   AND historico-embarque.embarque      = ordens-embarque.embarque
                   AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                   AND historico-embarque.cod-pto-contr = itinerario.pto-despacho
                   AND historico-embarque.dt-efetiva    = ?
                 BREAK BY historico-embarque.dt-ult-previsao:
                  
                  IF FIRST-OF (historico-embarque.dt-ult-previsao) THEN DO:
                      ASSIGN dt-proxima = historico-embarque.dt-ult-previsao.
                     
                      IF (historico-embarque.dt-ult-previsao < TODAY) THEN
                          ASSIGN c-atrasado = "true".
                      /** Sai do FOR EACH ja que pegou a data **/
                      LEAVE.
                  END. /** IF FIRST-OF **/
              END. /** FOR EACH **/
          END. /** IF **/
          ELSE DO:
              FOR EACH ordem-compra FIELDS (situacao) NO-LOCK
                 WHERE ordem-compra.cod-emitente = emitente.cod-emitente
                   AND ordem-compra.situacao     = 2
                   AND ordem-compra.num-pedido   > 0,
                 FIRST pedido-compr FIELDS (situacao) NO-LOCK
                 WHERE pedido-compr.num-pedido  = ordem-compra.num-pedido
                   AND pedido-compr.situacao    < 3
                   AND pedido-compr.responsavel = c-usuario,
                 FIRST int-pedido-compr NO-LOCK
                 WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido
                   AND int-pedido-compr.liberado
                   AND int-pedido-compr.recebido,
                  EACH prazo-compra FIELDS (data-entrega) NO-LOCK
                 WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                   AND prazo-compra.situacao     = 2
                   AND prazo-compra.quant-saldo  > 0
                 BREAK BY prazo-compra.data-entrega:
                  
                  IF FIRST-OF (prazo-compra.data-entrega) THEN DO:
                      ASSIGN dt-proxima = prazo-compra.data-entrega.
                      
                      IF (dt-proxima < TODAY) THEN
                          ASSIGN c-atrasado = "true".
                          
                      LEAVE.
                  END.

                  /*
                  IF AVAILABLE (ordem-compra) THEN DO:
                     FIND FIRST prazo-compra NO-LOCK
                        WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                          AND prazo-compra.situacao     = 2
                          AND prazo-compra.quant-saldo  > 0 NO-ERROR.
                     IF AVAILABLE (prazo-compra) THEN
                        ASSIGN dt-proxima = prazo-compra.data-entrega.
         
                     IF CAN-FIND (FIRST prazo-compra NO-LOCK
                                     WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                                       AND prazo-compra.situacao     = 2
                                       AND prazo-compra.quant-saldo  > 0
                                       AND prazo-compra.data-entrega < TODAY) THEN
                        ASSIGN c-atrasado = "true".
                  END.
                  */
              END.
          END.

          IF (dt-proxima <> ?) THEN
              hOrdNode:SET-ATTRIBUTE("proxima-entrega", STRING(dt-proxima, "9999-99-99")) NO-ERROR.

          hOrdNode:SET-ATTRIBUTE("pedido-atrasado", c-atrasado) NO-ERROR.

          IF CAN-FIND (FIRST tt-emitente NO-LOCK
                       WHERE tt-emitente.cod-emitente = emitente.cod-emitente) THEN
              hOrdNode:SET-ATTRIBUTE("pedido-pendente", "true") NO-ERROR.
          ELSE
              hOrdNode:SET-ATTRIBUTE("pedido-pendente", "false") NO-ERROR.

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
       END.
   END.


   IF NOT (l-response) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "14".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Nenhum fornecedor associado ao comprador".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

PROCEDURE process-find-emitente:
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

   DEFINE VARIABLE c-usuario      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-cod-emitente AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-cod-emitente AS INTEGER   NO-UNDO.

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
         WHEN "usuario" THEN
            c-usuario = tt-xml.elementValue.
         WHEN "emitente" THEN
            c-cod-emitente = tt-xml.elementValue.
      END CASE.
   END.

   ASSIGN i-cod-emitente = INT(c-cod-emitente).

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   FIND FIRST emitente NO-LOCK
      WHERE emitente.cod-emitente = i-cod-emitente NO-ERROR.
   FIND FIRST int-emitente NO-LOCK
      WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

   IF AVAILABLE (emitente) THEN DO:
      /** Cria o cabecalho de resposta **/
      soap-response:CREATE-NODE(rspNode, "m:find-emitente-response", "ELEMENT").
      rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-emitente-response").
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
   ELSE DO:
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

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.
