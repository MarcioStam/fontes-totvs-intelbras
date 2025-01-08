/****************************************************************************
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
            IF soap-procedure:NAME = ns-prefix + "find-pedido-compr" THEN
                RUN process-find-pedido-compr(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            IF soap-procedure:NAME = ns-prefix + "find-pedido-compr-externo" THEN
                RUN process-find-pedido-compr-externo(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "zoom-pedido-compr-pendente-emitente" THEN
                RUN process-zoom-pedido-compr-pendente-emitente(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "update-pedido-compr" THEN
                RUN process-update-pedido-compr(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
        END.
    END.

    /* Clean up */
    DELETE OBJECT soap-procedure.
    DELETE PROCEDURE hutil.

    RETURN.
END PROCEDURE.

/** tt auxiliar **/
DEFINE TEMP-TABLE tt-ordens NO-UNDO
   FIELD numero-ordem      LIKE ordem-compra.numero-ordem
   FIELD parcela           LIKE prazo-compra.parcela
   FIELD it-codigo         LIKE item.it-codigo
   FIELD un                LIKE item.un
   FIELD class-fiscal      LIKE item.class-fiscal
   FIELD it-fabric         LIKE item-fabric.it-fabric
   FIELD nome-abrev        LIKE emitente.nome-abrev
   FIELD descricao         LIKE item.descricao-1
   FIELD situacao          LIKE prazo-compra.situacao
   FIELD data-coleta       AS DATE FORMAT "99/99/9999"
   FIELD data-entrega      LIKE prazo-compra.data-entrega
   FIELD data-embarque     LIKE historico-embarque.dt-efetiva
   FIELD nr-conhecimento   LIKE embarque-imp.cod-conhecto-master
   FIELD cod-incoterm      LIKE embarque-imp.cod-incoterm
   FIELD cod-via-transp    LIKE embarque-imp.cod-via-transp
   FIELD aliquota-ipi      LIKE ordem-compra.aliquota-ipi
   FIELD qtd-sal-forn      LIKE prazo-compra.qtd-sal-forn
   FIELD vl-pre-uni        AS DECIMAL
   FIELD vl-pre-tot        AS DECIMAL
   FIELD existe-embarque   AS LOGICAL
   FIELD embarcado         AS LOGICAL
   INDEX ch-pri            AS PRIMARY numero-ordem it-codigo.

PROCEDURE process-find-pedido-compr:
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
   DEFINE VARIABLE c-num-pedido   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-num-pedido   AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-tipo-usuario AS CHARACTER NO-UNDO.

   DEFINE VARIABLE c-liberado       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-recebido       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE d-preco-conv     AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-preco-tot-aux  AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-desc-total     AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-enc            AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-ipi            AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-enc-total      AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-preco-sipi     AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-preco-total    AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-total-sipi     AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-total-geral    AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE c-desembarque    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-nr-data        AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-nr-pedido      AS CHARACTER NO-UNDO.

   DEFINE VARIABLE l-response AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE hPedNode   AS HANDLE   NO-UNDO.
   DEFINE VARIABLE hIteNode   AS HANDLE   NO-UNDO.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
   CREATE X-NODEREF hPedNode.
   CREATE X-NODEREF hIteNode.

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
         WHEN "num-pedido" THEN
            c-num-pedido = tt-xml.elementValue.
         WHEN "tipo-usuario" THEN
            c-tipo-usuario = tt-xml.elementValue.
      END CASE.
   END.

   IF (c-cod-emitente <> ? AND c-cod-emitente > "") THEN
      ASSIGN i-cod-emitente = INT(c-cod-emitente).
   IF (c-num-pedido <> ? AND c-num-pedido > "") THEN
      ASSIGN i-num-pedido = INT(c-num-pedido).

   SESSION:NUMERIC-FORMAT = "AMERICAN".

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   FIND FIRST pedido-compr NO-LOCK
      WHERE pedido-compr.num-pedido = i-num-pedido NO-ERROR.

   IF NOT AVAILABLE (pedido-compr) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "13".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Pedido nao existente".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      /* Clean up */
      DELETE OBJECT xmlText.
      DELETE OBJECT xmlParam.
      DELETE OBJECT rspNode.
      DELETE OBJECT happ.

      LEAVE.
   END.

   FIND FIRST int-pedido-compr NO-LOCK
        WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-ERROR.

   IF (c-tipo-usuario <> ? AND c-tipo-usuario = "F" AND NOT int-pedido-compr.liberado) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "33".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Pedido nao liberado para emitente".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      /* Clean up */
      DELETE OBJECT xmlText.
      DELETE OBJECT xmlParam.
      DELETE OBJECT rspNode.
      DELETE OBJECT happ.

      LEAVE.
   END.

   IF (int-pedido-compr.liberado) THEN
      ASSIGN c-liberado = "true".
   ELSE
      ASSIGN c-liberado = "false".

   IF (int-pedido-compr.recebido) THEN
      ASSIGN c-recebido = "true".
   ELSE
      ASSIGN c-recebido = "false".

   FIND FIRST emitente NO-LOCK
      WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-ERROR.

   IF (emitente.cod-emitente <> i-cod-emitente) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "32".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Pedido nao pertence ao emitente".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      /* Clean up */
      DELETE OBJECT xmlText.
      DELETE OBJECT xmlParam.
      DELETE OBJECT rspNode.
      DELETE OBJECT happ.

      LEAVE.
   END.

   FIND FIRST transporte NO-LOCK
      WHERE transporte.cod-transp = pedido-compr.cod-transp NO-ERROR.
   FIND FIRST ordem-compra NO-LOCK
      WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-ERROR.
   FIND FIRST cotacao-item NO-LOCK
      WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
        AND cotacao-item.cot-aprovada NO-ERROR.

   EMPTY TEMP-TABLE tt-ordens.

   FIND FIRST cond-pagto NO-LOCK
      WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-ERROR.
   FIND FIRST comprador NO-LOCK
      WHERE comprador.cod-comprado = pedido-compr.responsavel NO-ERROR.
   FIND FIRST usuar-mater NO-LOCK
      WHERE usuar-mater.cod-usuario = pedido-compr.responsavel
        AND usuar-mater.usuar-comprador NO-ERROR.

   FOR EACH ordem-compra NO-LOCK
      WHERE ordem-compra.num-pedido = pedido-compr.num-pedido,
      first estabelec no-lock
      where estabelec.cod-estabel = pedido-compr.cod-estabel,
      EACH prazo-compra NO-LOCK
     WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:

      FIND FIRST moeda NO-LOCK
         WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-ERROR.
      FIND FIRST item NO-LOCK
         WHERE item.it-codigo = ordem-compra.it-codigo NO-ERROR.
      FIND FIRST item-fornec NO-LOCK
         WHERE item-fornec.it-codigo    = ordem-compra.it-codigo
           AND item-fornec.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
      FIND FIRST narrativa NO-LOCK
         WHERE narrativa.it-codigo = ordem-compra.it-codigo NO-ERROR.

/* -----------------------  CALCULO PRECO UNITARIO  ------------------------- */

      ASSIGN d-preco-conv = ordem-compra.preco-fornec.

      /* /*retirado isso pois existe fornecedor nacional que tem moeda dolar e o pre‡o estava aparecendo em reais no b2b */
      
      IF (ordem-compra.mo-codigo > 0) THEN DO:
         RUN cdp/cd0812.p (INPUT  ordem-compra.mo-codigo,
                           INPUT  0,
                           INPUT  ordem-compra.preco-fornec,
                           INPUT  pedido-compr.data-pedido,
                           OUTPUT d-preco-conv).
         IF (d-preco-conv = ?) THEN
            ASSIGN d-preco-conv = ordem-compra.preco-fornec.
      END.
      ELSE
         ASSIGN d-preco-conv = ordem-compra.preco-fornec.*/

/* -----------------------  CALCULO DE VALORES  ----------------------------- */

      ASSIGN d-preco-tot-aux = d-preco-conv * prazo-compra.qtd-sal-forn
             d-desc-total    = 0
             d-enc           = 0
             d-ipi           = 0.

      FIND FIRST param-compra NO-LOCK NO-ERROR.

      IF NOT (param-compra.log-1) THEN DO:
         /* ------ CALCULO I.P.I. SOBRE PRECO LIQUIDO ------ */

         IF (ordem-compra.perc-descto > 0) THEN
            ASSIGN d-desc-total = d-preco-tot-aux * ordem-compra.perc-descto / 100.

         IF NOT (ordem-compra.taxa-financ) THEN DO:
            ASSIGN d-enc = d-preco-tot-aux - d-desc-total.

            RUN ccp/cc9020.p (INPUT  YES,
                              INPUT  ordem-compra.cod-cond-pag,
                              INPUT  ordem-compra.valor-taxa,
                              INPUT  ordem-compra.nr-dias-taxa,
                              INPUT  d-enc,
                              OUTPUT d-enc-total).
            ASSIGN d-enc = ROUND(d-enc-total - d-enc, 1).
         END.
         ELSE
            ASSIGN d-enc-total = d-preco-tot-aux - d-desc-total.

         IF (ordem-compra.aliquota-ipi > 0) THEN
            ASSIGN d-ipi = d-enc-total * ordem-compra.aliquota-ipi / 100.
      END.
      ELSE DO:
         /* ------ CALCULO I.P.I. SOBRE PRECO BRUTO ------ */

         IF NOT (ordem-compra.taxa-financ) THEN DO:
            RUN ccp/cc9020.p (INPUT  YES,
                              INPUT  ordem-compra.cod-cond-pag,
                              INPUT  ordem-compra.valor-taxa,
                              INPUT  ordem-compra.nr-dias-taxa,
                              INPUT  d-preco-tot-aux,
                              OUTPUT d-enc-total).
            ASSIGN d-enc = ROUND(d-enc-total - d-preco-tot-aux, 1).
         END.
         ELSE
            ASSIGN d-enc-total = d-preco-tot-aux.

         IF (ordem-compra.aliquota-ipi > 0) THEN
            ASSIGN d-ipi = d-enc-total * ordem-compra.aliquota-ipi / 100.

         IF (ordem-compra.perc-desct > 0) THEN
            ASSIGN d-desc-total = (d-enc-total + d-ipi) * ordem-compra.perc-descto / 100.
      END.

      ASSIGN d-preco-sipi  = d-preco-tot-aux + d-enc - d-desc-total
             d-preco-total = d-preco-sipi + (IF NOT (ordem-compra.codigo-ipi) THEN d-ipi ELSE 0)
             d-total-sipi  = d-total-sipi + d-preco-sipi
             d-total-geral = d-total-geral + d-preco-total.

      /** Altera‡Æo para tratar Manaus **/
      case pedido-compr.cod-estabel:
         when '102' then
            assign c-desembarque = "SAO JOSE DOS PINHAIS/PARANA/BRAZIL".
         when '105' then
            assign c-desembarque = 'MANAUS/AMAZONAS/BRAZIL'.
         otherwise
            assign c-desembarque = "SAO JOSE/SANTA CATARINA/BRAZIL".
      end case.

      IF (ordem-compra.natureza = 2) THEN DO:
         RUN procedure-cria-tt-ordens (INPUT d-preco-conv, INPUT d-preco-total).
         NEXT.
      END.

      FIND FIRST cotacao-item NO-LOCK
         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
           AND cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
      IF NOT AVAILABLE (cotacao-item) THEN
         NEXT.

      RUN procedure-cria-tt-ordens (INPUT d-preco-conv, INPUT d-preco-total).
   END.

   /** Para a data estar no formato de acordo com o XML Schema **/
   SESSION:DATE-FORMAT = "ymd".

   IF CAN-FIND (FIRST tt-ordens) THEN DO:
      /** Cria o cabecalho de resposta **/
      soap-response:CREATE-NODE(rspNode, "m:find-pedido-compr-response", "ELEMENT").
      rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:find-pedido-compr-response").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(hOrdNode, "pedido-compr", "ELEMENT").
      rspNode:APPEND-CHILD(hOrdNode).

      hOrdNode:SET-ATTRIBUTE("pedido-compr.cod-estabel", pedido-compr.cod-estabel) NO-ERROR.
      hOrdNode:SET-ATTRIBUTE("pedido-compr.data-pedido", STRING(pedido-compr.data-pedido, "9999-99-99")) NO-ERROR.
      hOrdNode:SET-ATTRIBUTE("pedido-compr.num-pedido", STRING(pedido-compr.num-pedido)) NO-ERROR.
      hOrdNode:SET-ATTRIBUTE("int-pedido-compr.liberado", c-liberado) NO-ERROR.
      hOrdNode:SET-ATTRIBUTE("int-pedido-compr.recebido", c-recebido) NO-ERROR.

      soap-response:CREATE-NODE(xmlParam, "moeda.mo-codigo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(moeda.mo-codigo) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

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

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.nome", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = usuar-mater.nome NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.e-mail", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = usuar-mater.e-mail NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.telefone", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = usuar-mater.telefone[1] NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

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

      soap-response:CREATE-NODE(xmlParam, "emitente.endereco", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.endereco NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.bairro", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.bairro NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.cidade", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.cidade NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.estado", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.estado NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.telefone", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.telefone[1] NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.telefax", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.telefax NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.cgc", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.cgc NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.ins-estadual", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.ins-estadual NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "cond-pagto.descricao", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = cond-pagto.descricao NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "pedido-compr.via-transp", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(pedido-compr.via-transp) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "transporte.nome", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = transporte.nome NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      FIND FIRST mensagem NO-LOCK
         WHERE mensagem.cod-mensagem = pedido-compr.cod-mensagem NO-ERROR.

      IF AVAILABLE (mensagem) THEN DO:
         soap-response:CREATE-NODE(xmlParam, "mensagem.texto-mensag", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = mensagem.texto-mensag NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).
      END.

      soap-response:CREATE-NODE(xmlParam, "pedido-compr.comentarios", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = pedido-compr.comentarios NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(hPedNode, "ordem-compra", "ELEMENT").
      hOrdNode:APPEND-CHILD(hPedNode).

      FOR EACH tt-ordens NO-LOCK
         BY tt-ordens.it-codigo
         BY tt-ordens.numero-ordem:

         /** situacao 4 => cancelado **/
         /* Notado pela Luciana, autorizado para alterar pelo Flavio
            Cancelado em 07.12, pois o pessoal nao estava percebendo a bolinha vermelha... */
         IF (tt-ordens.situacao = 4) AND (pedido-compr.situacao = 1) THEN
            NEXT.

         soap-response:CREATE-NODE(hIteNode, "tt-ordens", "ELEMENT").
         hPedNode:APPEND-CHILD(hIteNode).

         hIteNode:SET-ATTRIBUTE("tt-ordens.situacao", STRING(tt-ordens.situacao)) NO-ERROR.

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.numero-ordem", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.numero-ordem) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.data-coleta", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.data-coleta, "9999-99-99") NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.data-entrega", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.data-entrega, "9999-99-99") NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.parcela", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.parcela) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.class-fiscal", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordens.class-fiscal NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.it-codigo", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordens.it-codigo NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.descricao", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordens.descricao NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.it-fabric", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordens.it-fabric NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.nome-abrev", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordens.nome-abrev NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.un", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordens.un NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.qtd-sal-forn", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.qtd-sal-forn) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.vl-pre-uni", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.vl-pre-uni) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.vl-pre-tot", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.vl-pre-tot) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.aliquota-ipi", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.aliquota-ipi) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).
      END. /** FOR EACH **/
   END. /** IF CAN-FIND **/
   ELSE DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "31".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Pedido sem ordens".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

/** procedure interna **/
PROCEDURE procedure-cria-tt-ordens:
   DEFINE INPUT PARAMETER d-preco-conv    AS DECIMAL NO-UNDO.
   DEFINE INPUT PARAMETER d-preco-total   AS DECIMAL NO-UNDO.

   CREATE tt-ordens.
   ASSIGN tt-ordens.numero-ordem = ordem-compra.numero-ordem
          tt-ordens.parcela      = prazo-compra.parcela
          tt-ordens.it-codigo    = prazo-compra.it-codigo
          tt-ordens.un           = (IF AVAILABLE (item-fornec) THEN item-fornec.un ELSE item.un)
          tt-ordens.class-fiscal = item.class-fiscal
          tt-ordens.aliquota-ipi = ordem-compra.aliquota-ipi
          tt-ordens.qtd-sal-forn = prazo-compra.qtd-sal-forn
          tt-ordens.vl-pre-uni   = d-preco-conv
          tt-ordens.vl-pre-tot   = d-preco-total
          tt-ordens.data-entrega = prazo-compra.data-entrega
          tt-ordens.situacao     = prazo-compra.situacao.

   /*regra para data coleta*/
   IF emitente.estado = "AM" /*fornecedor amazonas*/ THEN DO:
       IF estabelec.estado = "AM" THEN
           ASSIGN tt-ordens.data-coleta = prazo-compra.data-entrega - 2.
       ELSE
           ASSIGN tt-ordens.data-coleta = prazo-compra.data-entrega - 23.
   END.
   ELSE DO:
       IF estabelec.estado = "PR" AND emitente.estado = "PR" THEN DO: /* Fornecedor do Parana e Estabelecimento do Parana (102) */
           ASSIGN tt-ordens.data-coleta = prazo-compra.data-entrega.
       END.
       ELSE DO:
           IF estabelec.estado = "AM" THEN
               ASSIGN tt-ordens.data-coleta = prazo-compra.data-entrega - 15.
           ELSE
               ASSIGN tt-ordens.data-coleta = prazo-compra.data-entrega - 2.
       END.
   END.
   
   /** part-number **/
   FIND FIRST int-item-for-PN NO-LOCK
    WHERE int-item-for-PN.cod-emitente = ordem-compra.cod-emitente
      AND int-item-for-PN.it-codigo    = prazo-compra.it-codigo    NO-ERROR.

   IF AVAILABLE (int-item-for-PN) THEN DO:
      IF (int-item-for-PN.item-do-forn <> "") THEN DO:
         FIND FIRST item-fabric NO-LOCK
              WHERE STRING(item-fabric.cod-fabric) = int-item-for-PN.item-do-forn
                AND item-fabric.it-codigo          = int-item-for-PN.it-codigo NO-ERROR.
         IF AVAILABLE (item-fabric) THEN DO:
            FIND FIRST fabricante NO-LOCK
                 WHERE fabricante.cod-fabric = item-fabric.cod-fabric NO-ERROR.
            ASSIGN tt-ordens.it-fabric  = item-fabric.it-fabric
                   tt-ordens.nome-abrev = fabricante.nome-abrev.
         END.
      END.
   END.

   IF (ordem-compra.narrativa <> "") THEN
      ASSIGN tt-ordens.descricao = tt-ordens.descricao + TRIM(ordem-compra.narrativa).
   ELSE
      IF AVAILABLE (item-fornec) AND (item-fornec.narrativa <> "") AND (item.it-codigo <> "") THEN
         ASSIGN tt-ordens.descricao = tt-ordens.descricao + TRIM(item-fornec.narrativa).
      ELSE
         ASSIGN tt-ordens.descricao = item.descricao-1 + item.descricao-2.

END PROCEDURE.

PROCEDURE process-zoom-pedido-compr-pendente-emitente:
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

   DEFINE VARIABLE c-cod-emitente   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-cod-emitente   AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-tipo-usuario   AS CHARACTER NO-UNDO.

   DEFINE VARIABLE c-liberado       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-recebido       AS CHARACTER NO-UNDO.

   DEFINE VARIABLE l-response AS LOGICAL  NO-UNDO.

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
         WHEN "tipo-usuario" THEN
            c-tipo-usuario = tt-xml.elementValue.
      END CASE.
   END.

   IF (c-cod-emitente <> ? AND c-cod-emitente > "") THEN
      ASSIGN i-cod-emitente = INT(c-cod-emitente).

   SESSION:NUMERIC-FORMAT = "AMERICAN".

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   /** Para a data estar no formato de acordo com o XML Schema **/
   SESSION:DATE-FORMAT = "ymd".

   FOR EACH pedido-compr FIELDS (responsavel data-pedido num-pedido cod-estabel) NO-LOCK
      WHERE pedido-compr.cod-emitente = i-cod-emitente
        AND pedido-compr.situacao     < 3,
      first estabelec no-lock
         where estabelec.cod-estabel = pedido-compr.cod-estabel,
      FIRST int-pedido-compr NO-LOCK
         WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido
      BY pedido-compr.num-pedido:

      IF (int-pedido-compr.liberado) THEN
         ASSIGN c-liberado = "true".
      ELSE
         ASSIGN c-liberado = "false".

      IF (int-pedido-compr.recebido) THEN
         ASSIGN c-recebido = "true".
      ELSE
         ASSIGN c-recebido = "false".

      /** Se for o fornecedor, exibe apenas pedidos liberados pelo comprador **/
      IF (c-tipo-usuario <> ? AND c-tipo-usuario = "F" AND NOT int-pedido-compr.liberado) THEN
         NEXT.

      /** Ignorar os pedidos ja liberados e recebidos **/
      IF (int-pedido-compr.liberado) AND (int-pedido-compr.recebido) THEN
         NEXT.

      FIND FIRST usuar-mater NO-LOCK
         WHERE usuar-mater.cod-usuario = pedido-compr.responsavel NO-ERROR.

      IF NOT (l-response) THEN DO:
         ASSIGN l-response = YES.

         /** Cria o cabecalho de resposta **/
         soap-response:CREATE-NODE(rspNode, "m:zoom-pedido-compr-pendente-emitente-response", "ELEMENT").
         rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-pedido-compr-pendente-emitente-response").
         ttElements.nhandle:APPEND-CHILD(rspNode).
      END.

      soap-response:CREATE-NODE(hOrdNode, "pedido-compr", "ELEMENT").
      rspNode:APPEND-CHILD(hOrdNode).

      hOrdNode:set-attribute("estabelec.cod-estabel", estabelec.cod-estabel) no-error.
      hOrdNode:set-attribute("estabelec.cidade", estabelec.cidade) no-error.
      hOrdNode:set-attribute("estabelec.estado", estabelec.estado) no-error.

      hOrdNode:SET-ATTRIBUTE("int-pedido-compr.liberado", c-liberado) NO-ERROR.
      hOrdNode:SET-ATTRIBUTE("int-pedido-compr.recebido", c-recebido) NO-ERROR.

      soap-response:CREATE-NODE(xmlParam, "pedido-compr.data-pedido", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(pedido-compr.data-pedido, "9999-99-99") NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "pedido-compr.num-pedido", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(pedido-compr.num-pedido) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.nome", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = usuar-mater.nome NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).
   END.

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
      xmlText:NODE-VALUE = "Nenhum resultado encontrado".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

PROCEDURE process-update-pedido-compr:
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

   DEFINE VARIABLE c-cod-emitente   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-cod-emitente   AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-num-pedido     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-num-pedido     AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-acao           AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-tipo-usuario   AS CHARACTER NO-UNDO.

   DEFINE VARIABLE c-liberado       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-recebido       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE l-envia-emitente AS LOGICAL   NO-UNDO.

   DEFINE VARIABLE l-response AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE hPedNode   AS HANDLE   NO-UNDO.
   DEFINE VARIABLE hIteNode   AS HANDLE   NO-UNDO.
   DEFINE VARIABLE hCtoNode   AS HANDLE   NO-UNDO.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
   CREATE X-NODEREF hPedNode.
   CREATE X-NODEREF hIteNode.
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
         WHEN "cod-emitente" THEN
            c-cod-emitente = tt-xml.elementValue.
         WHEN "num-pedido" THEN
            c-num-pedido = tt-xml.elementValue.
         WHEN "acao" THEN
            c-acao = tt-xml.elementValue.
         WHEN "tipo-usuario" THEN
            c-tipo-usuario = tt-xml.elementValue.
      END CASE.
   END.

   IF (c-cod-emitente <> ? AND c-cod-emitente > "") THEN
      ASSIGN i-cod-emitente = INT(c-cod-emitente).
   IF (c-num-pedido <> ? AND c-num-pedido > "") THEN
      ASSIGN i-num-pedido = INT(c-num-pedido).

   SESSION:NUMERIC-FORMAT = "AMERICAN".

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   DO TRANSACTION:
      FIND FIRST pedido-compr EXCLUSIVE-LOCK
         WHERE pedido-compr.cod-emitente = i-cod-emitente
           AND pedido-compr.num-pedido   = i-num-pedido NO-ERROR.
      FIND FIRST int-pedido-compr EXCLUSIVE-LOCK
         WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-ERROR.

      /** Se for o fornecedor, exibe apenas pedidos liberados pelo comprador **/
      IF (c-tipo-usuario = "U") AND (c-acao = "liberatudo") THEN DO:
         ASSIGN int-pedido-compr.liberado = YES
                int-pedido-compr.recebido = YES
                l-response                = YES.
      END.
      ELSE IF (c-tipo-usuario = "F") THEN DO:
         IF (int-pedido-compr.liberado) THEN DO:
            IF (c-acao <> ?) AND (c-acao = "recebe") THEN DO:
               ASSIGN int-pedido-compr.recebido = YES
                      l-response                = YES
                      l-envia-emitente          = NO.
            END.
         END.
      END.
      ELSE DO:
         IF (c-acao <> ?) AND (c-acao = "libera") THEN DO:
            ASSIGN int-pedido-compr.liberado = YES
                   pedido-compr.situacao     = 1
                   l-response                = YES
                   l-envia-emitente          = YES.
         END.
      END.
   END. /** DO TRANSACTION **/

   FIND FIRST emitente NO-LOCK
      WHERE emitente.cod-emitente = i-cod-emitente NO-ERROR.
   FIND FIRST emitente-cex OF emitente NO-LOCK NO-ERROR.
   FIND FIRST usuar-mater NO-LOCK
      WHERE usuar-mater.cod-usuario = pedido-compr.responsavel NO-ERROR.

   IF (l-response) THEN DO:
      /** Cria o cabecalho de resposta **/
      soap-response:CREATE-NODE(rspNode, "m:update-pedido-compr-response", "ELEMENT").
      rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:update-pedido-compr-response").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(hOrdNode, "emitente", "ELEMENT").
      rspNode:APPEND-CHILD(hOrdNode).

      IF AVAILABLE (emitente-cex) THEN
         hOrdNode:SET-ATTRIBUTE("emitente-cex.cod-idioma", emitente-cex.cod-idioma) NO-ERROR.

      IF (l-envia-emitente) THEN
         hOrdNode:SET-ATTRIBUTE("envia-emitente", "true") NO-ERROR.
      ELSE
         hOrdNode:SET-ATTRIBUTE("envia-emitente", "false") NO-ERROR.

      soap-response:CREATE-NODE(xmlParam, "emitente.nome-emit", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.nome-emit NO-ERROR.
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

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.nome", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = usuar-mater.nome NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.e-mail", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = usuar-mater.e-mail NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).
   END.

   IF NOT (l-response) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "35".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Erro atualizando. Pedido nao liberado, ou nao e' fornecedor recebendo".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

PROCEDURE process-find-pedido-compr-externo:
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

   DEFINE VARIABLE c-cod-emitente   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-cod-emitente   AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-num-pedido     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-num-pedido     AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-tipo-usuario   AS CHARACTER NO-UNDO.

   DEFINE VARIABLE c-liberado       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-recebido       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE d-preco-conv     AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-preco-tot-aux  AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-desc-total     AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-enc            AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-ipi            AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-enc-total      AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-preco-sipi     AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-preco-total    AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-total-sipi     AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE d-total-geral    AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE c-desembarque    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-mensagem       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-via-transp     AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-embarque       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-incoterm       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-agente         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE dt-novo-emb      AS DATE      NO-UNDO.
   DEFINE VARIABLE c-nr-data        AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-nr-pedido      AS CHARACTER NO-UNDO.

   DEFINE VARIABLE l-response AS LOGICAL NO-UNDO.
   DEFINE VARIABLE hPedNode   AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hIteNode   AS HANDLE  NO-UNDO.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
   CREATE X-NODEREF hPedNode.
   CREATE X-NODEREF hIteNode.

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
         WHEN "num-pedido" THEN
            c-num-pedido = tt-xml.elementValue.
         WHEN "tipo-usuario" THEN
            c-tipo-usuario = tt-xml.elementValue.
      END CASE.
   END.

   IF (c-cod-emitente <> ? AND c-cod-emitente > "") THEN
      ASSIGN i-cod-emitente = INT(c-cod-emitente).
   IF (c-num-pedido <> ? AND c-num-pedido > "") THEN
      ASSIGN i-num-pedido = INT(c-num-pedido).

   SESSION:NUMERIC-FORMAT = "AMERICAN".

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   FIND FIRST pedido-compr NO-LOCK
      WHERE pedido-compr.num-pedido = i-num-pedido NO-ERROR.

   IF NOT AVAILABLE (pedido-compr) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "13".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Pedido nao existente".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      /* Clean up */
      DELETE OBJECT xmlText.
      DELETE OBJECT xmlParam.
      DELETE OBJECT rspNode.
      DELETE OBJECT happ.

      LEAVE.
   END.

   FIND FIRST int-pedido-compr NO-LOCK
      WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido NO-ERROR.

   IF (c-tipo-usuario <> ? AND c-tipo-usuario = "F" AND NOT int-pedido-compr.liberado) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "33".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Pedido nao liberado para emitente".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      /* Clean up */
      DELETE OBJECT xmlText.
      DELETE OBJECT xmlParam.
      DELETE OBJECT rspNode.
      DELETE OBJECT happ.

      LEAVE.
   END.

   IF (int-pedido-compr.liberado) THEN
      ASSIGN c-liberado = "true".
   ELSE
      ASSIGN c-liberado = "false".

   IF (int-pedido-compr.recebido) THEN
      ASSIGN c-recebido = "true".
   ELSE
      ASSIGN c-recebido = "false".

   FIND FIRST emitente NO-LOCK
      WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-ERROR.

   IF (emitente.cod-emitente <> i-cod-emitente) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "32".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Pedido nao pertence ao emitente".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      /* Clean up */
      DELETE OBJECT xmlText.
      DELETE OBJECT xmlParam.
      DELETE OBJECT rspNode.
      DELETE OBJECT happ.

      LEAVE.
   END.

   EMPTY TEMP-TABLE tt-ordens.

   FIND FIRST emitente NO-LOCK
      WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-ERROR.
   FIND FIRST cond-pagto NO-LOCK
      WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-ERROR.

   /*
   FIND FIRST ext-pedido NO-LOCK
      WHERE ext-pedido.num-pedido = pedido-compr.num-pedido NO-ERROR.
   IF AVAILABLE (ext-pedido) THEN DO:
      IF (ext-pedido.final-destination <> "") THEN
         ASSIGN c-desembarque = ext-pedido.final-destination.
      ASSIGN c-via-trans = ext-pedido.shipping-method
             c-embarque  = ext-pedido.place-of-ship
             c-incoterm  = ext-pedido.invoice-validity
             dt-novo-emb = ext-pedido.data-emissao.
   END.*/

   FIND FIRST usuar-mater NO-LOCK
      WHERE usuar-mater.cod-usuario = pedido-compr.responsavel
        AND usuar-mater.usuar-comprador NO-ERROR.

   FOR EACH ordem-compra NO-LOCK
      WHERE ordem-compra.num-pedido = pedido-compr.num-pedido,
      EACH prazo-compra NO-LOCK
         WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem,
      FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = pedido-compr.cod-estabel:

      FIND FIRST moeda NO-LOCK
         WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-ERROR.
      FIND FIRST item NO-LOCK
         WHERE item.it-codigo = prazo-compra.it-codigo NO-ERROR.
      FIND FIRST item-fornec NO-LOCK
         WHERE item-fornec.it-codigo    = ordem-compra.it-codigo
           AND item-fornec.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
/*
      IF AVAILABLE (item-fornec) THEN
         FIND FIRST int-item-fornec OF item-fornec NO-LOCK NO-ERROR. */
      FIND FIRST narrativa NO-LOCK
         WHERE narrativa.it-codigo = ordem-compra.it-codigo NO-ERROR.

      ASSIGN d-preco-conv  = ordem-compra.preco-fornec.

      /** Altera‡Æo para tratar Manaus **/
      case pedido-compr.cod-estabel:
         when '102' then
            assign c-desembarque = "SAO JOSE DOS PINHAIS/PARANA/BRAZIL".
         when '105' then
            assign c-desembarque = 'MANAUS/AMAZONAS/BRAZIL'.
         otherwise
            assign c-desembarque = "SAO JOSE/SANTA CATARINA/BRAZIL".
      end case.

      IF (ordem-compra.natureza = 2) THEN DO:
         RUN procedure-cria-tt-ordens-externo(NO,
                                              INPUT  d-preco-conv,
                                              INPUT  dt-novo-emb,
                                              OUTPUT c-incoterm,
                                              OUTPUT i-via-transp).
         NEXT.
      END.

      FIND FIRST cotacao-item NO-LOCK
         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
           AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
           AND cotacao-item.cot-aprovada NO-ERROR.
      IF NOT AVAILABLE (cotacao-item) THEN
         NEXT.

      FIND FIRST itinerario NO-LOCK
         WHERE itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.
      IF AVAILABLE (itinerario) THEN DO:
         FIND FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = itinerario.pto-embarque NO-ERROR.
         IF AVAILABLE (pto-contr) THEN
            ASSIGN c-embarque = pto-contr.descricao.
         ELSE
            ASSIGN c-embarque = ""
                   c-mensagem = "Ponto de despacho no intinerario inexistente".
      END.
      ELSE
         ASSIGN c-embarque = ""
                c-mensagem = "Itinerario inexistente! Verifique es0846".

      IF NOT CAN-FIND (FIRST ordens-embarque NO-LOCK
                          WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem
                            AND ordens-embarque.parcela      = prazo-compra.parcela) THEN DO:
         RUN procedure-cria-tt-ordens-externo(NO,
                                              INPUT  d-preco-conv,
                                              INPUT  dt-novo-emb,
                                              OUTPUT c-incoterm,
                                              OUTPUT i-via-transp).
         NEXT.
      END.

      FOR EACH ordens-embarque NO-LOCK
         WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem
           AND ordens-embarque.parcela      = prazo-compra.parcela:
         RUN procedure-cria-tt-ordens-externo(YES,
                                              INPUT  d-preco-conv,
                                              INPUT  dt-novo-emb,
                                              OUTPUT c-incoterm,
                                              OUTPUT i-via-transp).
      END.
   END. /** FOR EACH **/

   FIND FIRST transporte NO-LOCK
      WHERE transporte.cod-transp = pedido-compr.cod-transp NO-ERROR.
   IF AVAILABLE (transporte) THEN
      ASSIGN c-agente = transporte.nome-abrev.

   /** Para a data estar no formato de acordo com o XML Schema **/
   SESSION:DATE-FORMAT = "ymd".

   IF CAN-FIND (FIRST tt-ordens) THEN DO:
      /** Cria o cabecalho de resposta **/
      soap-response:CREATE-NODE(rspNode, "m:find-pedido-compr-externo-response", "ELEMENT").
      rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:find-pedido-compr-externo-response").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(hOrdNode, "pedido-compr", "ELEMENT").
      rspNode:APPEND-CHILD(hOrdNode).

      hOrdNode:SET-ATTRIBUTE("pedido-compr.cod-estabel", pedido-compr.cod-estabel) NO-ERROR.
      hOrdNode:SET-ATTRIBUTE("pedido-compr.data-pedido", STRING(pedido-compr.data-pedido, "9999-99-99")) NO-ERROR.
      hOrdNode:SET-ATTRIBUTE("pedido-compr.num-pedido", STRING(pedido-compr.num-pedido)) NO-ERROR.
      hOrdNode:SET-ATTRIBUTE("int-pedido-compr.liberado", c-liberado) NO-ERROR.
      hOrdNode:SET-ATTRIBUTE("int-pedido-compr.recebido", c-recebido) NO-ERROR.

      soap-response:CREATE-NODE(xmlParam, "moeda.mo-codigo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(moeda.mo-codigo) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

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

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.nome", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = usuar-mater.nome NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.e-mail", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = usuar-mater.e-mail NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.telefone", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = usuar-mater.telefone[1] NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

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

      soap-response:CREATE-NODE(xmlParam, "emitente.endereco", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.endereco NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.bairro", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.bairro NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.cidade", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.cidade NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.estado", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.estado NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.pais", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.pais NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.telefone", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.telefone[1] NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.telefax", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.telefax NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.cgc", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.cgc NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      IF (pedido-compr.cod-cond-pag <> 0) THEN DO:
         soap-response:CREATE-NODE(xmlParam, "cond-pagto.descricao", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = cond-pagto.descricao NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).
      END.
      ELSE DO:
         FIND FIRST cond-especif NO-LOCK
            WHERE cond-especif.num-pedido = pedido-compr.num-pedido NO-ERROR.
         IF AVAILABLE (cond-especif) THEN DO:
            soap-response:CREATE-NODE(hPedNode, "cond-especif", "ELEMENT").
            hOrdNode:APPEND-CHILD(hPedNode).

            REPEAT i = 1 TO EXTENT(cond-especif.data-pagto):
               IF (cond-especif.data-pagto[i] <> ?) THEN DO:
                  soap-response:CREATE-NODE(hIteNode, "cond-especif-iter", "ELEMENT").
                  hPedNode:APPEND-CHILD(hIteNode).

                  hIteNode:SET-ATTRIBUTE("iter", STRING(i)) NO-ERROR.

                  soap-response:CREATE-NODE(xmlParam, "cond-especif.data-pagto", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = STRING(cond-especif.data-pagto[i], "9999-99-99") NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hIteNode:APPEND-CHILD(xmlParam).

                  soap-response:CREATE-NODE(xmlParam, "cond-especif.perc-pagto", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = STRING(cond-especif.perc-pagto[i]) NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hIteNode:APPEND-CHILD(xmlParam).

                  soap-response:CREATE-NODE(xmlParam, "cond-especif.comentarios", "ELEMENT").
                  soap-response:CREATE-NODE(xmlText, ?, "TEXT").
                  xmlText:NODE-VALUE = cond-especif.comentarios[i] NO-ERROR.
                  xmlParam:APPEND-CHILD(xmlText).
                  hIteNode:APPEND-CHILD(xmlParam).
               END.
            END. /** REPEAT **/
         END. /** IF AVAILABLE **/
      END. /** ELSE DO **/

      FIND FIRST tt-ordens NO-LOCK.

      soap-response:CREATE-NODE(xmlParam, "tt-ordens.cod-via-transp", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordens.cod-via-transp) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "tt-ordens.cod-incoterm", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordens.cod-incoterm NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "transporte.nome", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = transporte.nome NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "desembarque", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = c-desembarque NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "pto-contr.descricao", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = pto-contr.descricao NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      FIND FIRST mensagem NO-LOCK
         WHERE mensagem.cod-mensagem = pedido-compr.cod-mensagem NO-ERROR.

      IF AVAILABLE (mensagem) THEN DO:
         soap-response:CREATE-NODE(xmlParam, "mensagem.texto-mensag", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = mensagem.texto-mensag NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).
      END.

      soap-response:CREATE-NODE(xmlParam, "pedido-compr.comentarios", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = pedido-compr.comentarios NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(hPedNode, "ordem-compra", "ELEMENT").
      hOrdNode:APPEND-CHILD(hPedNode).

      FOR EACH tt-ordens NO-LOCK
         BY tt-ordens.it-codigo
         BY tt-ordens.numero-ordem:

         /** situacao 4 => cancelado **/
         IF (tt-ordens.situacao = 4) AND (pedido-compr.situacao = 1) THEN
            NEXT.

         soap-response:CREATE-NODE(hIteNode, "tt-ordens", "ELEMENT").
         hPedNode:APPEND-CHILD(hIteNode).

         hIteNode:SET-ATTRIBUTE("tt-ordens.situacao", STRING(tt-ordens.situacao)) NO-ERROR.

         IF (tt-ordens.existe-embarque) THEN
            hIteNode:SET-ATTRIBUTE("tt-ordens.existe-embarque", "true") NO-ERROR.
         ELSE
            hIteNode:SET-ATTRIBUTE("tt-ordens.existe-embarque", "false") NO-ERROR.

         IF (tt-ordens.embarcado) THEN
            hIteNode:SET-ATTRIBUTE("tt-ordens.embarcado", "true") NO-ERROR.
         ELSE
            hIteNode:SET-ATTRIBUTE("tt-ordens.embarcado", "false") NO-ERROR.

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.numero-ordem", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.numero-ordem) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.data-embarque", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         IF (tt-ordens.data-embarque <> ?) THEN
            xmlText:NODE-VALUE = STRING(tt-ordens.data-embarque, "9999-99-99") NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.parcela", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.parcela) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.class-fiscal", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordens.class-fiscal NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.it-codigo", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordens.it-codigo NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.descricao", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordens.descricao NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.it-fabric", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordens.it-fabric NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.nome-abrev", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordens.nome-abrev NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.un", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordens.un NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.qtd-sal-forn", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.qtd-sal-forn) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.vl-pre-uni", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.vl-pre-uni) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tt-ordens.vl-pre-tot", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tt-ordens.vl-pre-tot) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).
      END. /** FOR EACH **/
   END. /** IF CAN-FIND **/
   ELSE DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "31".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Pedido sem ordens".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

PROCEDURE procedure-cria-tt-ordens-externo:
   DEFINE INPUT  PARAMETER l-existe-embarque AS LOGICAL     NO-UNDO.
   DEFINE INPUT  PARAMETER d-preco-conv      AS DECIMAL     NO-UNDO.
   DEFINE INPUT  PARAMETER dt-novo-emb       AS DATE        NO-UNDO.
   DEFINE OUTPUT PARAMETER c-incoterm        AS CHARACTER   NO-UNDO.
   DEFINE OUTPUT PARAMETER i-via-transp      AS INTEGER     NO-UNDO.

   IF (l-existe-embarque) THEN DO:
      FIND LAST pto-itiner NO-LOCK
         WHERE pto-itiner.cod-itiner = cotacao-item.int-1 NO-ERROR.
      IF NOT AVAILABLE (pto-itiner) THEN
         RETURN.
      FIND FIRST historico-embarque NO-LOCK
         WHERE historico-embarque.cod-estabel   = estabelec.cod-estabel
           AND historico-embarque.embarque      = ordens-embarque.embarque
           AND historico-embarque.cod-itiner    = pto-itiner.cod-itiner
           AND historico-embarque.cod-pto-contr = itinerario.pto-despacho NO-ERROR.
   END.

   CREATE tt-ordens.
   ASSIGN tt-ordens.numero-ordem = ordem-compra.numero-ordem
          tt-ordens.parcela      = prazo-compra.parcela
          tt-ordens.it-codigo    = prazo-compra.it-codigo
          tt-ordens.un           = (IF AVAILABLE (item-fornec)  THEN item-fornec.un ELSE item.un)
          tt-ordens.class-fiscal = (IF AVAILABLE (cotacao-item) THEN SUBSTRING(cotacao-item.char-1, 81, 20) ELSE item.class-fiscal)
          tt-ordens.qtd-sal-forn = prazo-compra.qtd-sal-forn
          tt-ordens.vl-pre-uni   = d-preco-conv
          tt-ordens.vl-pre-tot   = d-preco-conv * prazo-compra.qtd-sal-forn.

   IF (l-existe-embarque) THEN DO:
      IF AVAILABLE (historico-embarque) THEN
         IF (historico-embarque.dt-efetiva = ?) THEN
            ASSIGN tt-ordens.data-embarque = historico-embarque.dt-ult-previsao.
         ELSE
            ASSIGN tt-ordens.data-embarque = historico-embarque.dt-efetiva.
   END.
   ELSE
      ASSIGN tt-ordens.data-embarque = ?.

   /** part-number **/

   FIND FIRST int-item-for-PN NO-LOCK
       WHERE int-item-for-PN.cod-emitente = ordem-compra.cod-emitente
         AND int-item-for-PN.it-codigo    = prazo-compra.it-codigo    NO-ERROR.

   IF AVAILABLE (int-item-for-PN) THEN DO:
      IF (int-item-for-PN.item-do-forn <> "") THEN DO:
         FIND FIRST item-fabric NO-LOCK
            WHERE STRING(item-fabric.cod-fabric) = int-item-for-PN.item-do-forn
              AND item-fabric.it-codigo          = item-fornec.it-codigo NO-ERROR.
         IF AVAILABLE (item-fabric) THEN DO:
            FIND FIRST fabricante NO-LOCK
               WHERE fabricante.cod-fabric = item-fabric.cod-fabric NO-ERROR.
            ASSIGN tt-ordens.it-fabric  = item-fabric.it-fabric
                   tt-ordens.nome-abrev = fabricante.nome-abrev.
         END.
      END.
   END.

   IF (ordem-compra.narrativa <> "") THEN
      ASSIGN tt-ordens.descricao = tt-ordens.descricao + TRIM(ordem-compra.narrativa).
   ELSE
      IF AVAILABLE (item-fornec) AND (item-fornec.narrativa <> "") AND (item.it-codigo <> "") THEN
         ASSIGN tt-ordens.descricao = tt-ordens.descricao + TRIM(item-fornec.narrativa).
      ELSE
         ASSIGN tt-ordens.descricao = item.descricao-1 + item.descricao-2.

   IF (l-existe-embarque) THEN DO:
      FOR EACH embarque-imp NO-LOCK
         WHERE embarque-imp.cod-estabel = estabelec.cod-estabel
           AND embarque-imp.embarque    = ordens-embarque.embarque:
         ASSIGN tt-ordens.situacao        = prazo-compra.situacao
                tt-ordens.nr-conhecimento = TRIM(embarque-imp.cod-conhecto-master)
                tt-ordens.cod-incoterm    = embarque-imp.cod-incoterm
                tt-ordens.cod-via-transp  = embarque-imp.cod-via-transp
                tt-ordens.existe-embarque = YES
                tt-ordens.embarcado       = (IF (tt-ordens.nr-conhecimento <> "") THEN YES ELSE NO).
      END.
   END.
   ELSE
      ASSIGN tt-ordens.situacao        = prazo-compra.situacao
             tt-ordens.nr-conhecimento = ""
             tt-ordens.cod-incoterm    = c-incoterm
             tt-ordens.cod-via-transp  = i-via-transp.

END PROCEDURE.
