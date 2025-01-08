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

DEFINE VARIABLE de-qtd-devol   LIKE recebimento.quant-rejeit NO-UNDO.

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
            IF soap-procedure:NAME = ns-prefix + "zoom-ordem-compra-emitente" THEN
                RUN process-zoom-ordem-compra-emitente(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "zoom-ordem-compra-emitente-externo" THEN
                RUN process-zoom-ordem-compra-emitente-externo(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "zoom-embarques-emitente-externo" THEN
                RUN process-zoom-embarques-emitente-externo(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "zoom-ordem-parcela-emitente" THEN
                RUN process-zoom-ordem-parcela-emitente(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "find-ordem-compra" THEN
                RUN process-find-ordem-compra(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
        END.
    END.

    /* Clean up */
    DELETE OBJECT soap-procedure.
    DELETE PROCEDURE hutil.

    RETURN.
END PROCEDURE.

DEFINE TEMP-TABLE tt-ordem-compra-emitente
    FIELD data-coleta    LIKE prazo-compra.data-entrega
    FIELD data-entrega   LIKE prazo-compra.data-entrega
    FIELD cod-estabel    LIKE pedido-compr.cod-estabel
    FIELD numero-ordem   LIKE prazo-compra.numero-ordem 
    FIELD parcela        LIKE prazo-compra.parcela      
    FIELD d-quantidade   LIKE pre-nota.quantidade
    FIELD it-codigo      LIKE ordem-compra.it-codigo
    FIELD nome           LIKE usuar-mater.nome
    FIELD item-descricao LIKE item.desc-item
    FIELD num-pedido     LIKE ordem-compra.num-pedido
    FIELD it-fabric      LIKE item-fabric.it-fabric
    FIELD unid-med-for   LIKE item-fornec.unid-med-for          
    FIELD qtd-do-forn    LIKE prazo-compra.qtd-do-forn 
    FIELD qtd-sal-forn   LIKE prazo-compra.qtd-rec-forn
    FIELD qtd-rec-forn   LIKE prazo-compra.qtd-sal-forn
    FIELD cod-emitente   LIKE ordem-compra.cod-emitente
    INDEX ch-pri AS PRIMARY data-coleta num-pedido it-codigo.

PROCEDURE process-zoom-ordem-compra-emitente:
   DEF INPUT PARAM appservice           AS CHAR   NO-UNDO.
   DEF INPUT PARAM soap-procedure       AS HANDLE NO-UNDO.
   DEF INPUT PARAM ns-prefix            AS CHAR   NO-UNDO.
   DEF INPUT-OUTPUT PARAM soap-response AS HANDLE NO-UNDO.

   DEF VAR happ     AS HANDLE NO-UNDO.
   DEF VAR rspNode  AS HANDLE NO-UNDO.
   DEF VAR xmlParam AS HANDLE NO-UNDO.
   DEF VAR xmlText  AS HANDLE NO-UNDO.

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
   DEFINE VARIABLE c-descricao    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE d-quantidade   AS DECIMAL   NO-UNDO.
   DEFINE VARIABLE dt-data-coleta AS DATE      NO-UNDO.

   DEFINE VARIABLE l-response     AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE hOCNode        AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hPreNode       AS HANDLE    NO-UNDO.
   
   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
   CREATE X-NODEREF hOCNode.
   CREATE X-NODEREF hPreNode.

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

   /** Para a data estar no formato de acordo com o XML Schema **/
   SESSION:DATE-FORMAT = "ymd".

   SESSION:NUMERIC-FORMAT = 'american'.

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   FIND FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = i-cod-emitente NO-ERROR.

   FOR EACH ordem-compra NO-LOCK
      WHERE ordem-compra.cod-emitente = i-cod-emitente
        AND ordem-compra.situacao     = 2
        AND ordem-compra.num-pedido   > 0,
      FIRST pedido-compr FIELDS (situacao cod-estabel) NO-LOCK
         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido
           AND pedido-compr.situacao   < 3,
      FIRST int-pedido-compr NO-LOCK
         WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido
           AND int-pedido-compr.liberado
           AND int-pedido-compr.recebido,
      EACH prazo-compra FIELDS (data-entrega qtd-do-forn qtd-rec-forn qtd-sal-forn numero-ordem parcela) NO-LOCK
         WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
           AND prazo-compra.situacao     = 2
           AND prazo-compra.quant-saldo  > 0
      BREAK BY prazo-compra.data-entrega
            BY ordem-compra.num-pedido
            BY ordem-compra.it-codigo:

      FIND FIRST item-fornec-estab NO-LOCK
           WHERE item-fornec-estab.it-codigo    = ordem-compra.it-codigo
             AND item-fornec-estab.cod-emitente = ordem-compra.cod-emitente 
             AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-ERROR.

      FIND FIRST item NO-LOCK
         WHERE item.it-codigo = ordem-compra.it-codigo NO-ERROR.

      IF AVAILABLE (item-fornec-estab) THEN DO:
         FIND FIRST int-item-for-PN NO-LOCK
             WHERE int-item-for-PN.cod-emitente = ordem-compra.cod-emitente
               AND int-item-for-PN.it-codigo    = ordem-compra.it-codigo    NO-ERROR.

         IF  AVAIL int-item-for-PN THEN
             FIND FIRST item-fabric NO-LOCK
                WHERE item-fabric.it-codigo          = int-item-for-PN.it-codigo
                  AND STRING(item-fabric.cod-fabric) = int-item-for-PN.item-do-forn NO-ERROR.
      END.

      IF (ordem-compra.it-codigo = "") THEN 
         ASSIGN c-descricao = ordem-compra.narrativa.
      ELSE
         IF AVAILABLE (item) THEN
            ASSIGN c-descricao = item.desc-item.
         ELSE
            ASSIGN c-descricao = "".

      FIND item-uni-estab WHERE
           item-uni-estab.cod-estabel = ordem-compra.cod-estabel AND
           item-uni-estab.it-codigo   = ordem-compra.it-codigo NO-LOCK NO-ERROR.

      IF NOT AVAIL item-uni-estab THEN NEXT.

      FIND FIRST usuar-mater NO-LOCK
           WHERE usuar-mater.cod-usuario = item-uni-estab.cod-comprado NO-ERROR.

      /** Calcula a quantidade que foi dada como enviada mas nao entrou na empresa ainda **/
      ASSIGN d-quantidade = 0.

      FOR EACH pre-nota NO-LOCK
         WHERE pre-nota.cod-emitente = ordem-compra.cod-emitente
           AND pre-nota.numero-ordem = prazo-compra.numero-ordem
           AND pre-nota.parcela      = prazo-compra.parcela
           AND NOT pre-nota.importado:
         ASSIGN d-quantidade = d-quantidade + pre-nota.quantidade.
      END.

      FIND FIRST estabelec WHERE 
                 estabelec.cod-estabel = pedido-compr.cod-estabel NO-LOCK NO-ERROR.

      ASSIGN dt-data-coleta = ?.
      /* Regra para data coleta */
      IF emitente.estado = "AM" /*fornecedor amazonas*/ THEN DO:
          IF estabelec.estado = "AM" THEN
              ASSIGN dt-data-coleta = prazo-compra.data-entrega - 2.
          ELSE
              ASSIGN dt-data-coleta = prazo-compra.data-entrega - 7.
      END.
      ELSE DO:
          IF estabelec.estado = "AM" THEN
              ASSIGN dt-data-coleta = prazo-compra.data-entrega - 15.
          ELSE
              ASSIGN dt-data-coleta = prazo-compra.data-entrega - 2.
      END.

      ASSIGN de-qtd-devol = 0.

      FOR EACH recebimento
         WHERE recebimento.num-pedido   = ordem-compra.num-pedido
           AND recebimento.numero-ordem = ordem-compra.numero-ordem
           AND recebimento.parcela      = prazo-compra.parcela NO-LOCK:
          IF recebimento.cod-movto = 2 THEN
              ASSIGN de-qtd-devol = de-qtd-devol + recebimento.quant-rejeit.
      END.

      CREATE tt-ordem-compra-emitente.
      ASSIGN tt-ordem-compra-emitente.data-coleta    = dt-data-coleta
             tt-ordem-compra-emitente.data-entrega   = prazo-compra.data-entrega
             tt-ordem-compra-emitente.cod-estabel    = pedido-compr.cod-estabel
             tt-ordem-compra-emitente.numero-ordem   = prazo-compra.numero-ordem 
             tt-ordem-compra-emitente.parcela        = prazo-compra.parcela      
             tt-ordem-compra-emitente.d-quantidade   = d-quantidade
             tt-ordem-compra-emitente.it-codigo      = ordem-compra.it-codigo
             tt-ordem-compra-emitente.nome           = (IF AVAILABLE (usuar-mater) THEN usuar-mater.nome ELSE "")
             tt-ordem-compra-emitente.item-descricao = c-descricao
             tt-ordem-compra-emitente.num-pedido     = ordem-compra.num-pedido
             tt-ordem-compra-emitente.it-fabric      = (IF AVAILABLE (item-fabric) THEN item-fabric.it-fabric ELSE "")
             tt-ordem-compra-emitente.unid-med-for   = (IF AVAILABLE (item-fornec-estab) THEN item-fornec-estab.unid-med-for ELSE "")          
             tt-ordem-compra-emitente.qtd-do-forn    =  prazo-compra.qtd-do-forn 
             tt-ordem-compra-emitente.qtd-sal-forn   =  prazo-compra.qtd-sal-forn
             tt-ordem-compra-emitente.qtd-rec-forn   =  prazo-compra.qtd-rec-forn - de-qtd-devol
             tt-ordem-compra-emitente.cod-emitente   =  ordem-compra.cod-emitente.
   END.

   FOR EACH tt-ordem-compra-emitente
       BREAK BY tt-ordem-compra-emitente.data-coleta:

      IF NOT (l-response) THEN DO:
         ASSIGN l-response = YES.

         soap-response:CREATE-NODE(rspNode, "m:zoom-ordem-compra-emitente-response", "ELEMENT").
         rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-ordem-compra-emitente-response").
         ttElements.nhandle:APPEND-CHILD(rspNode).
      END.

      IF FIRST-OF (tt-ordem-compra-emitente.data-coleta) THEN DO:
         soap-response:CREATE-NODE(hOrdNode, "ordem-compra", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         IF (TODAY - tt-ordem-compra-emitente.data-coleta > 0) THEN
            hOrdNode:SET-ATTRIBUTE("prazo-compra-atraso", STRING(TODAY - tt-ordem-compra-emitente.data-coleta)) NO-ERROR.

         hOrdNode:SET-ATTRIBUTE("prazo-compra.data-coleta", STRING(tt-ordem-compra-emitente.data-coleta, "9999-99-99")) NO-ERROR.
      END.

      soap-response:CREATE-NODE(hOCNode, "ordem-compra", "ELEMENT").
      hOrdNode:APPEND-CHILD(hOCNode).

      FIND FIRST estabelec NO-LOCK
           WHERE estabelec.cod-estabel = tt-ordem-compra-emitente.cod-estabel NO-ERROR.

      hOCNode:SET-ATTRIBUTE("estabelec.cod-estabel", estabelec.cod-estabel) NO-ERROR.
      hOCNode:SET-ATTRIBUTE("estabelec.cidade", estabelec.cidade)           NO-ERROR.
      hOCNode:SET-ATTRIBUTE("estabelec.estado", estabelec.estado)           NO-ERROR.

      hOCNode:SET-ATTRIBUTE("ordem-compra.numero-ordem", STRING(tt-ordem-compra-emitente.numero-ordem)) NO-ERROR.
      hOCNode:SET-ATTRIBUTE("prazo-compra.parcela", STRING(tt-ordem-compra-emitente.parcela)) NO-ERROR.

      IF (tt-ordem-compra-emitente.qtd-sal-forn - tt-ordem-compra-emitente.d-quantidade > 0) THEN
         hOCNode:SET-ATTRIBUTE("pode-preencher-nota", "true") NO-ERROR.
      ELSE
         hOCNode:SET-ATTRIBUTE("pode-preencher-nota", "false") NO-ERROR.

      soap-response:CREATE-NODE(xmlParam, "ordem-compra.it-codigo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordem-compra-emitente.it-codigo NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.nome", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordem-compra-emitente.nome NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item-descricao", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordem-compra-emitente.item-descricao NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "ordem-compra.num-pedido", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra-emitente.num-pedido) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      IF tt-ordem-compra-emitente.it-fabric <> "":U THEN DO:
         soap-response:CREATE-NODE(xmlParam, "item-fabric.it-fabric", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordem-compra-emitente.it-fabric NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOCNode:APPEND-CHILD(xmlParam).
      END.

      soap-response:CREATE-NODE(xmlParam, "item-fornec-estab.unid-med-for", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordem-compra-emitente.unid-med-for NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "prazo-compra.qtd-do-forn", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra-emitente.qtd-do-forn) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "prazo-compra.data-entrega", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra-emitente.data-entrega,"9999-99-99") NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "prazo-compra-enviado", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra-emitente.d-quantidade) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "prazo-compra.qtd-rec-forn", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra-emitente.qtd-rec-forn) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "prazo-compra-saldo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra-emitente.qtd-sal-forn - tt-ordem-compra-emitente.d-quantidade) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      FOR EACH pre-nota NO-LOCK
         WHERE pre-nota.cod-emitente = tt-ordem-compra-emitente.cod-emitente
           AND pre-nota.numero-ordem = tt-ordem-compra-emitente.numero-ordem
           AND pre-nota.parcela      = tt-ordem-compra-emitente.parcela
           AND NOT pre-nota.importado:

         soap-response:CREATE-NODE(hPreNode, "pre-nota", "ELEMENT").
         hOCNode:APPEND-CHILD(hPreNode).

         hPreNode:SET-ATTRIBUTE("pre-nota.nro-docto", pre-nota.nro-docto) NO-ERROR.
         hPreNode:SET-ATTRIBUTE("pre-nota.serie", pre-nota.serie) NO-ERROR.

         soap-response:CREATE-NODE(xmlParam, "pre-nota.dt-emissao", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(pre-nota.dt-emissao, "9999-99-99") NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hPreNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "pre-nota.quantidade", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(pre-nota.quantidade) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hPreNode:APPEND-CHILD(xmlParam).
      END.
   END. /** FOR EACH tt-ordem-compra-emitente **/

   IF NOT (l-response) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "8".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Nao ha dados a serem exibidos".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.
END PROCEDURE.

DEFINE TEMP-TABLE tt-ordem-compra
   FIELD data            LIKE historico-embarque.dt-efetiva
   FIELD data-embarque   LIKE historico-embarque.dt-efetiva
   FIELD num-pedido      LIKE ordem-compra.num-pedido
   FIELD nome            LIKE usuar-mater.nome
   FIELD numero-ordem    LIKE ordem-compra.numero-ordem
   FIELD parcela         LIKE prazo-compra.parcela
   FIELD it-codigo       LIKE ordem-compra.it-codigo
   FIELD cod-via-transp  LIKE embarque-imp.cod-via-transp
   FIELD descricao       LIKE item.desc-item
   FIELD it-fabric       LIKE item-fabric.it-fabric
   FIELD unid-med-for    LIKE item-fornec-estab.unid-med-for
   FIELD qtd-do-forn     LIKE prazo-compra.qtd-do-forn
   FIELD qtd-rec-forn    LIKE prazo-compra.qtd-rec-forn
   FIELD qtd-sal-forn    LIKE prazo-compra.qtd-sal-forn
   FIELD embarque        LIKE embarque-imp.embarque
   FIELD nr-conhecimento LIKE embarque-imp.cod-conhecto-master
   field cod-estabel     like pedido-compr.cod-estabel
   INDEX ch-pri AS PRIMARY data num-pedido it-codigo.

PROCEDURE process-zoom-ordem-compra-emitente-externo:
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
   DEFINE VARIABLE c-descricao    AS CHARACTER NO-UNDO.

   DEFINE VARIABLE l-response     AS LOGICAL NO-UNDO.
   DEFINE VARIABLE hOCNode        AS HANDLE  NO-UNDO.
   
   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
   CREATE X-NODEREF hOCNode.

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

   /** Para a data estar no formato de acordo com o XML Schema **/
   SESSION:DATE-FORMAT = "ymd".

   session:numeric-format = 'american'.

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.
   
   FOR EACH ordem-compra NO-LOCK
      WHERE ordem-compra.cod-emitente = i-cod-emitente
        AND ordem-compra.situacao     = 2
        AND ordem-compra.num-pedido   > 0,
      FIRST pedido-compr FIELDS (situacao) NO-LOCK
         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido
           AND pedido-compr.situacao   < 3,
      FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = pedido-compr.cod-estabel,
      FIRST int-pedido-compr NO-LOCK
         WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido
           AND int-pedido-compr.liberado
           AND int-pedido-compr.recebido,
      EACH prazo-compra FIELDS (data-entrega qtd-do-forn qtd-rec-forn qtd-sal-forn numero-ordem parcela) NO-LOCK
         WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
           AND prazo-compra.situacao     = 2
           AND prazo-compra.quant-saldo  > 0,
      EACH ordens-embarque FIELDS (embarque) NO-LOCK
         WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem
           AND ordens-embarque.parcela      = prazo-compra.parcela,
      FIRST embarque-imp NO-LOCK
      WHERE embarque-imp.cod-estabel = ordem-compra.cod-estabel
        AND embarque-imp.embarque    = ordens-embarque.embarque,
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
           AND historico-embarque.dt-efetiva    = ?:

      FIND FIRST item-fornec-estab NO-LOCK
           WHERE item-fornec-estab.it-codigo    = ordem-compra.it-codigo
             AND item-fornec-estab.cod-emitente = ordem-compra.cod-emitente
             AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-ERROR.

      FIND FIRST item NO-LOCK
          WHERE item.it-codigo = ordem-compra.it-codigo NO-ERROR.

      IF AVAILABLE (item-fornec-estab) THEN DO:
         FIND FIRST item-fabric NO-LOCK
              WHERE item-fabric.it-codigo          = item-fornec-estab.it-codigo
                AND STRING(item-fabric.cod-fabric) = item-fornec-estab.item-do-forn NO-ERROR.
      END.

      IF (ordem-compra.it-codigo = "") THEN 
         ASSIGN c-descricao = ordem-compra.narrativa.
      ELSE
         IF AVAILABLE (item) THEN
            ASSIGN c-descricao = item.desc-item.
         ELSE
            ASSIGN c-descricao = "".

      FIND item-uni-estab WHERE
           item-uni-estab.cod-estabel = ordem-compra.cod-estabel AND
           item-uni-estab.it-codigo   = ordem-compra.it-codigo NO-LOCK NO-ERROR.
        
      IF NOT AVAIL item-uni-estab THEN NEXT.
        
      FIND FIRST usuar-mater NO-LOCK
           WHERE usuar-mater.cod-usuario = item-uni-estab.cod-comprado NO-ERROR.

      ASSIGN de-qtd-devol = 0.

      FOR EACH recebimento
         WHERE recebimento.num-pedido   = ordem-compra.num-pedido
           AND recebimento.numero-ordem = ordem-compra.numero-ordem
           AND recebimento.parcela      = prazo-compra.parcela NO-LOCK:
          IF recebimento.cod-movto = 2 THEN
              ASSIGN de-qtd-devol = de-qtd-devol + recebimento.quant-rejeit.
      END.
      CREATE tt-ordem-compra.
      ASSIGN tt-ordem-compra.data         = historico-embarque.dt-ult-previsao
             tt-ordem-compra.num-pedido   = ordem-compra.num-pedido
             tt-ordem-compra.nome         = (IF AVAILABLE (usuar-mater) THEN usuar-mater.nome ELSE "")
             tt-ordem-compra.numero-ordem = prazo-compra.numero-ordem
             tt-ordem-compra.parcela      = prazo-compra.parcela
             tt-ordem-compra.it-codigo    = ordem-compra.it-codigo
             tt-ordem-compra.cod-via-transp = embarque-imp.cod-via-transp
             tt-ordem-compra.descricao    = c-descricao
             tt-ordem-compra.it-fabric    = (IF AVAILABLE (item-fabric) THEN item-fabric.it-fabric ELSE "")
             tt-ordem-compra.unid-med-for = (IF AVAILABLE (item-fornec-estab) THEN item-fornec-estab.unid-med-for ELSE "":U)
             tt-ordem-compra.qtd-do-forn  = prazo-compra.qtd-do-forn
             tt-ordem-compra.qtd-rec-forn = prazo-compra.qtd-rec-forn - de-qtd-devol
             tt-ordem-compra.qtd-sal-forn = prazo-compra.qtd-sal-forn
             tt-ordem-compra.cod-estabel  = ordem-compra.cod-estabel.

      RELEASE item.
      RELEASE item-fornec-estab.
      RELEASE item-fabric.
      RELEASE usuar-mater.
   END.

   FOR EACH tt-ordem-compra NO-LOCK
      BREAK BY tt-ordem-compra.data:

      IF NOT (l-response) THEN DO:
         ASSIGN l-response = YES.

         soap-response:CREATE-NODE(rspNode, "m:zoom-ordem-compra-emitente-externo-response", "ELEMENT").
         rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-ordem-compra-emitente-externo-response").
         ttElements.nhandle:APPEND-CHILD(rspNode).
      END.

      IF FIRST-OF (tt-ordem-compra.data) THEN DO:
         soap-response:CREATE-NODE(hOrdNode, "tt-ordem-compra", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         IF (TODAY - tt-ordem-compra.data > 0) THEN
            hOrdNode:SET-ATTRIBUTE("tt-ordem-compra-atraso", STRING(TODAY - tt-ordem-compra.data)) NO-ERROR.

         hOrdNode:SET-ATTRIBUTE("tt-ordem-compra.data", STRING(tt-ordem-compra.data, "9999-99-99")) NO-ERROR.
      END.

      soap-response:CREATE-NODE(hOCNode, "ordem-compra", "ELEMENT").
      hOrdNode:APPEND-CHILD(hOCNode).

      find first estabelec no-lock
         where estabelec.cod-estabel = tt-ordem-compra.cod-estabel no-error.

      hOCNode:set-attribute("estabelec.cod-estabel", estabelec.cod-estabel) no-error.
      hOCNode:set-attribute("estabelec.cidade", estabelec.cidade) no-error.
      hOCNode:set-attribute("estabelec.estado", estabelec.estado) no-error.

      hOCNode:SET-ATTRIBUTE("tt-ordem-compra.numero-ordem", STRING(tt-ordem-compra.numero-ordem)) NO-ERROR.
      hOCNode:SET-ATTRIBUTE("tt-ordem-compra.parcela", STRING(tt-ordem-compra.parcela)) NO-ERROR.

      soap-response:CREATE-NODE(xmlParam, "ordem-compra.it-codigo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordem-compra.it-codigo NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.nome", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordem-compra.nome NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item-descricao", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordem-compra.descricao NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "embarque-imp.cod-via-transp", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra.cod-via-transp) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "ordem-compra.num-pedido", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra.num-pedido) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      IF (tt-ordem-compra.it-fabric <> ?) THEN DO:
         soap-response:CREATE-NODE(xmlParam, "item-fabric.it-fabric", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordem-compra.it-fabric NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOCNode:APPEND-CHILD(xmlParam).
      END.

      soap-response:CREATE-NODE(xmlParam, "item-fornec-estab.unid-med-for", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordem-compra.unid-med-for NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "prazo-compra.qtd-do-forn", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra.qtd-do-forn) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "prazo-compra.qtd-rec-forn", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra.qtd-rec-forn) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "prazo-compra.qtd-sal-forn", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra.qtd-sal-forn) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).
   END. /** FOR EACH **/

   IF NOT (l-response) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "8".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Nao ha dados a serem exibidos".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

PROCEDURE process-zoom-embarques-emitente-externo:
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
   DEFINE VARIABLE c-descricao    AS CHARACTER NO-UNDO.

   DEFINE VARIABLE l-response     AS LOGICAL NO-UNDO.
   DEFINE VARIABLE hOCNode        AS HANDLE  NO-UNDO.

   DEFINE BUFFER b-historico-embarque FOR historico-embarque.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
   CREATE X-NODEREF hOCNode.

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

   /** Para a data estar no formato de acordo com o XML Schema **/
   SESSION:DATE-FORMAT = "ymd".

   session:numeric-format = 'american'.

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.
   
   FOR EACH ordem-compra NO-LOCK
      WHERE ordem-compra.cod-emitente = i-cod-emitente
        AND ordem-compra.situacao     = 2
        AND ordem-compra.num-pedido   > 0,
      FIRST pedido-compr FIELDS (situacao) NO-LOCK
         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido
           AND pedido-compr.situacao   < 3,
      FIRST int-pedido-compr NO-LOCK
         WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido
           AND int-pedido-compr.liberado
           AND int-pedido-compr.recebido,
      EACH prazo-compra FIELDS (data-entrega qtd-do-forn qtd-rec-forn qtd-sal-forn numero-ordem parcela) NO-LOCK
         WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
           AND prazo-compra.situacao     = 2
           AND prazo-compra.quant-saldo  > 0,
      EACH ordens-embarque FIELDS (qt-do-forn embarque) NO-LOCK
         WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem
           AND ordens-embarque.parcela      = prazo-compra.parcela,
      FIRST embarque-imp FIELDS (cod-conhecto-master) NO-LOCK
         WHERE embarque-imp.cod-estabel = ordem-compra.cod-estabel
           AND embarque-imp.embarque    = ordens-embarque.embarque
           AND embarque-imp.situacao    = 1,
      FIRST cotacao-item FIELDS (cot-aprovada) NO-LOCK
         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
           AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
           AND cotacao-item.cot-aprovada,
      FIRST itinerario FIELDS (cod-itiner) NO-LOCK
         WHERE itinerario.cod-itiner = cotacao-item.int-1,
      FIRST historico-embarque FIELDS (dt-efetiva) NO-LOCK
         WHERE historico-embarque.cod-estabel   = ordem-compra.cod-estabel
           AND historico-embarque.embarque      = ordens-embarque.embarque
           AND historico-embarque.cod-itiner    = itinerario.cod-itiner
           AND historico-embarque.cod-pto-contr = itinerario.pto-despacho
           AND historico-embarque.dt-efetiva   <> ?,
      FIRST b-historico-embarque FIELDS (dt-efetiva dt-ult-previsao) NO-LOCK
         WHERE b-historico-embarque.cod-estabel   = ordem-compra.cod-estabel
           AND b-historico-embarque.embarque      = ordens-embarque.embarque
           AND b-historico-embarque.cod-itiner    = itinerario.cod-itiner
           AND b-historico-embarque.cod-pto-contr = itinerario.pto-embarque:

      FIND FIRST item-fornec-estab NO-LOCK
           WHERE item-fornec-estab.it-codigo    = ordem-compra.it-codigo
             AND item-fornec-estab.cod-emitente = ordem-compra.cod-emitente
             AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-ERROR.

      FIND FIRST item NO-LOCK
         WHERE item.it-codigo = ordem-compra.it-codigo NO-ERROR.

      IF AVAILABLE (item-fornec-estab) THEN DO:
         FIND FIRST item-fabric NO-LOCK
              WHERE item-fabric.it-codigo          = item-fornec-estab.it-codigo
                AND STRING(item-fabric.cod-fabric) = item-fornec-estab.item-do-forn NO-ERROR.
      END.

      IF (ordem-compra.it-codigo = "") THEN 
         ASSIGN c-descricao = ordem-compra.narrativa.
      ELSE
         IF AVAILABLE (item) THEN
            ASSIGN c-descricao = item.desc-item.
         ELSE
            ASSIGN c-descricao = "".

      FIND item-uni-estab WHERE
           item-uni-estab.cod-estabel = ordem-compra.cod-estabel AND
           item-uni-estab.it-codigo   = ordem-compra.it-codigo NO-LOCK NO-ERROR.

      IF NOT AVAIL item-uni-estab THEN NEXT.

      FIND FIRST usuar-mater NO-LOCK
           WHERE usuar-mater.cod-usuario = item-uni-estab.cod-comprado NO-ERROR.

      CREATE tt-ordem-compra.
      ASSIGN tt-ordem-compra.data            = historico-embarque.dt-efetiva
             tt-ordem-compra.data-embarque   = (IF b-historico-embarque.dt-efetiva = ? THEN b-historico-embarque.dt-ult-previsao ELSE b-historico-embarque.dt-efetiva)
             tt-ordem-compra.num-pedido      = ordem-compra.num-pedido
             tt-ordem-compra.nome            = (IF AVAILABLE (usuar-mater) THEN usuar-mater.nome ELSE "")
             tt-ordem-compra.numero-ordem    = prazo-compra.numero-ordem
             tt-ordem-compra.parcela         = prazo-compra.parcela
             tt-ordem-compra.it-codigo       = ordem-compra.it-codigo
             tt-ordem-compra.descricao       = c-descricao
             tt-ordem-compra.it-fabric       = (IF AVAILABLE (item-fabric) THEN item-fabric.it-fabric ELSE "")
             tt-ordem-compra.unid-med-for    = (if available (item-fornec-estab) then item-fornec-estab.unid-med-for else "")
             tt-ordem-compra.qtd-do-forn     = ordens-embarque.qt-do-forn
             tt-ordem-compra.embarque        = ordens-embarque.embarque
             tt-ordem-compra.nr-conhecimento = embarque-imp.cod-conhecto-master
             tt-ordem-compra.cod-estabel     = ordem-compra.cod-estabel.

      RELEASE item.
      RELEASE item-fabric.
      RELEASE usuar-mater.
   END.

   FOR EACH tt-ordem-compra NO-LOCK
      BREAK BY tt-ordem-compra.data
            BY tt-ordem-compra.embarque:

      IF NOT (l-response) THEN DO:
         ASSIGN l-response = YES.

         soap-response:CREATE-NODE(rspNode, "m:zoom-ordem-compra-emitente-externo-response", "ELEMENT").
         rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-ordem-compra-emitente-externo-response").
         ttElements.nhandle:APPEND-CHILD(rspNode).
      END.

      IF FIRST-OF (tt-ordem-compra.embarque) THEN DO:
         soap-response:CREATE-NODE(hOrdNode, "tt-ordem-compra", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         hOrdNode:SET-ATTRIBUTE("tt-ordem-compra.embarque", tt-ordem-compra.embarque) NO-ERROR.
         hOrdNode:SET-ATTRIBUTE("tt-ordem-compra.nr-conhecimento", tt-ordem-compra.nr-conhecimento) NO-ERROR.
         hOrdNode:SET-ATTRIBUTE("tt-ordem-compra.data", STRING(tt-ordem-compra.data, "9999-99-99")) NO-ERROR.
         hOrdNode:SET-ATTRIBUTE("tt-ordem-compra.data-embarque", STRING(tt-ordem-compra.data-embarque, "9999-99-99")) NO-ERROR.
      END.

      soap-response:CREATE-NODE(hOCNode, "ordem-compra", "ELEMENT").
      hOrdNode:APPEND-CHILD(hOCNode).

      find first estabelec no-lock
           where estabelec.cod-estabel = tt-ordem-compra.cod-estabel no-error.

      hOCNode:set-attribute("estabelec.cod-estabel", estabelec.cod-estabel) no-error.
      hOCNode:set-attribute("estabelec.cidade", estabelec.cidade) no-error.
      hOCNode:set-attribute("estabelec.estado", estabelec.estado) no-error.
      
      hOCNode:SET-ATTRIBUTE("tt-ordem-compra.numero-ordem", STRING(tt-ordem-compra.numero-ordem)) NO-ERROR.
      hOCNode:SET-ATTRIBUTE("tt-ordem-compra.parcela", STRING(tt-ordem-compra.parcela)) NO-ERROR.

      soap-response:CREATE-NODE(xmlParam, "ordem-compra.it-codigo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordem-compra.it-codigo NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.nome", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordem-compra.nome NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item-descricao", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordem-compra.descricao NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "ordem-compra.num-pedido", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra.num-pedido) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      IF (tt-ordem-compra.it-fabric <> ?) THEN DO:
         soap-response:CREATE-NODE(xmlParam, "item-fabric.it-fabric", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = tt-ordem-compra.it-fabric NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOCNode:APPEND-CHILD(xmlParam).
      END.

      soap-response:CREATE-NODE(xmlParam, "item-fornec-estab.unid-med-for", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = tt-ordem-compra.unid-med-for NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "ordens-embarque.qt-do-forn", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(tt-ordem-compra.qtd-do-forn) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).
   END. /** FOR EACH **/

   IF NOT (l-response) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "8".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Nao ha dados a serem exibidos".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

DEFINE TEMP-TABLE tt-ordem-parcela
   FIELD numero-ordem   LIKE ordem-compra.numero-ordem
   FIELD parcela        LIKE prazo-compra.parcela
   INDEX ch-pri         AS PRIMARY UNIQUE numero-ordem parcela.

PROCEDURE process-zoom-ordem-parcela-emitente:
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

   DEFINE VARIABLE c-cod-emitente   AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE i-cod-emitente   AS INTEGER     NO-UNDO.
   DEFINE VARIABLE c-descricao      AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE d-quantidade     AS DECIMAL     NO-UNDO.

   DEFINE VARIABLE l-response AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE hOCNode    AS HANDLE   NO-UNDO.
   DEFINE VARIABLE hOrdem     AS HANDLE   NO-UNDO.
   DEFINE VARIABLE hItem      AS HANDLE   NO-UNDO.
   DEFINE VARIABLE hChildItem AS HANDLE   NO-UNDO.
   DEFINE VARIABLE hChildText AS HANDLE   NO-UNDO.
   
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
      END CASE.
   END.

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
            CREATE tt-ordem-parcela.

            REPEAT j = 1 TO 2:
               IF (hItem:GET-CHILD(hChildItem, j)) THEN DO:
                  /** Ve quem e' e joga no campo correto **/
                  IF (hChildItem:GET-CHILD(hChildText, 1)) THEN
                     IF (hChildItem:NAME = "numero-ordem") THEN
                        ASSIGN tt-ordem-parcela.numero-ordem = INT(hChildText:NODE-VALUE).
                     ELSE IF (hChildItem:NAME = "parcela") THEN
                        ASSIGN tt-ordem-parcela.parcela = INT(hChildText:NODE-VALUE).
               END. /** IF **/
            END. /** REPEAT **/
         END. /** IF **/
      END. /** REPEAT **/
   END. /** IF VALID-HANDLE **/

   IF (c-cod-emitente <> ? AND c-cod-emitente > "") THEN
      ASSIGN i-cod-emitente = INT(c-cod-emitente).

   /** Para a data estar no formato de acordo com o XML Schema **/
   SESSION:DATE-FORMAT = "ymd".

   session:numeric-format = 'american'.

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   FOR EACH ordem-compra NO-LOCK
      WHERE ordem-compra.cod-emitente = i-cod-emitente
        AND ordem-compra.situacao     = 2
        AND ordem-compra.num-pedido   > 0,
      FIRST pedido-compr FIELDS (situacao) NO-LOCK
         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido
           AND pedido-compr.situacao   < 3,
      FIRST int-pedido-compr NO-LOCK
         WHERE int-pedido-compr.num-pedido = pedido-compr.num-pedido
           AND int-pedido-compr.liberado
           AND int-pedido-compr.recebido,
      EACH prazo-compra FIELDS (data-entrega qtd-do-forn qtd-rec-forn qtd-sal-forn numero-ordem parcela) NO-LOCK
         WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
           AND prazo-compra.situacao     = 2
           AND prazo-compra.quant-saldo  > 0,
      EACH tt-ordem-parcela NO-LOCK
         WHERE tt-ordem-parcela.numero-ordem = ordem-compra.numero-ordem
           AND tt-ordem-parcela.parcela      = prazo-compra.parcela
      BY ordem-compra.it-codigo
      BY ordem-compra.num-pedido
      BY prazo-compra.data-entrega:

      FIND FIRST item-fornec-estab NO-LOCK
           WHERE item-fornec-estab.it-codigo    = ordem-compra.it-codigo
             AND item-fornec-estab.cod-emitente = ordem-compra.cod-emitente
             AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-ERROR.

      FIND FIRST item NO-LOCK
         WHERE item.it-codigo = ordem-compra.it-codigo NO-ERROR.

      IF AVAILABLE (item-fornec-estab) THEN DO:
         FIND FIRST item-fabric NO-LOCK
              WHERE item-fabric.it-codigo          = item-fornec-estab.it-codigo
                AND STRING(item-fabric.cod-fabric) = item-fornec-estab.item-do-forn NO-ERROR.
      END.

      IF (ordem-compra.it-codigo = "") THEN 
         ASSIGN c-descricao = ordem-compra.narrativa.
      ELSE
         IF AVAILABLE (item) THEN
            ASSIGN c-descricao = item.desc-item.
         ELSE
            ASSIGN c-descricao = "".

      FIND item-uni-estab WHERE
           item-uni-estab.cod-estabel = ordem-compra.cod-estabel AND
           item-uni-estab.it-codigo   = ordem-compra.it-codigo NO-LOCK NO-ERROR.

      IF NOT AVAIL item-uni-estab THEN NEXT.

      FIND FIRST usuar-mater NO-LOCK
           WHERE usuar-mater.cod-usuario = item-uni-estab.cod-comprado NO-ERROR.

      /** Calcula a quantidade que foi dada como enviada mas nao entrou na empresa ainda **/
      ASSIGN d-quantidade = 0.

      FOR EACH pre-nota NO-LOCK
         WHERE pre-nota.cod-emitente = ordem-compra.cod-emitente
           AND pre-nota.numero-ordem = prazo-compra.numero-ordem
           AND pre-nota.parcela      = prazo-compra.parcela
           AND NOT pre-nota.importado:
         ASSIGN d-quantidade = d-quantidade + pre-nota.quantidade.
      END.

      IF NOT (l-response) THEN DO:
         ASSIGN l-response = YES.

         soap-response:CREATE-NODE(rspNode, "m:zoom-ordem-parcela-emitente-response", "ELEMENT").
         rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-ordem-parcela-emitente-response").
         ttElements.nhandle:APPEND-CHILD(rspNode).

         soap-response:CREATE-NODE(hOrdNode, "ordem-compra", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         IF (TODAY - prazo-compra.data-entrega > 0) THEN
            hOrdNode:SET-ATTRIBUTE("prazo-compra-atraso", STRING(TODAY - prazo-compra.data-entrega)) NO-ERROR.

         hOrdNode:SET-ATTRIBUTE("prazo-compra.data-entrega", STRING(prazo-compra.data-entrega, "9999-99-99")) NO-ERROR.
      END.

      soap-response:CREATE-NODE(hOCNode, "ordem-compra", "ELEMENT").
      hOrdNode:APPEND-CHILD(hOCNode).

      hOCNode:SET-ATTRIBUTE("ordem-compra.numero-ordem", STRING(prazo-compra.numero-ordem)) NO-ERROR.
      hOCNode:SET-ATTRIBUTE("prazo-compra.parcela", STRING(prazo-compra.parcela)) NO-ERROR.

      soap-response:CREATE-NODE(xmlParam, "ordem-compra.it-codigo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = ordem-compra.it-codigo NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.nome", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = usuar-mater.nome NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item-descricao", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = c-descricao NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "ordem-compra.num-pedido", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(ordem-compra.num-pedido) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      IF AVAILABLE (item-fabric) THEN DO:
         soap-response:CREATE-NODE(xmlParam, "item-fabric.it-fabric", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = item-fabric.it-fabric NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOCNode:APPEND-CHILD(xmlParam).
      END.

      soap-response:CREATE-NODE(xmlParam, "item-fornec-estab.unid-med-for", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = item-fornec-estab.unid-med-for NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "prazo-compra.qtd-do-forn", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(prazo-compra.qtd-do-forn) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "prazo-compra.qtd-rec-forn", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(prazo-compra.qtd-rec-forn) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "prazo-compra-saldo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(prazo-compra.qtd-sal-forn - d-quantidade) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOCNode:APPEND-CHILD(xmlParam).

      RELEASE item.
      RELEASE item-fornec-estab.
      RELEASE item-fabric.
      RELEASE usuar-mater.
   END. /** FOR EACH **/

   IF NOT (l-response) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "8".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Nao ha dados a serem exibidos".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.
END PROCEDURE.

PROCEDURE process-find-ordem-compra:
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

   DEFINE VARIABLE c-num-pedido   AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE i-num-pedido   AS INTEGER     NO-UNDO.
   DEFINE VARIABLE c-numero-ordem AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE i-numero-ordem AS INTEGER     NO-UNDO.

   DEFINE VARIABLE l-response AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE hOCNode    AS HANDLE   NO-UNDO.
   DEFINE VARIABLE hOrdem     AS HANDLE   NO-UNDO.
   DEFINE VARIABLE hItem      AS HANDLE   NO-UNDO.
   DEFINE VARIABLE hChildItem AS HANDLE   NO-UNDO.
   DEFINE VARIABLE hChildText AS HANDLE   NO-UNDO.
   
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
         WHEN "num-pedido" THEN
            c-num-pedido = tt-xml.elementValue.
         WHEN "numero-ordem" THEN
            c-numero-ordem = tt-xml.elementValue.
      END CASE.
   END.

   IF (c-num-pedido <> ?) AND (c-num-pedido > "") THEN DO:
      ASSIGN i-num-pedido = INT(c-num-pedido).
      FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.num-pedido = i-num-pedido NO-ERROR.
   END.
   ELSE IF (c-numero-ordem <> ?) AND (c-numero-ordem > "") THEN DO:
      ASSIGN i-numero-ordem = INT(c-numero-ordem).
      FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = i-numero-ordem NO-ERROR.
   END.

   /** Para a data estar no formato de acordo com o XML Schema **/
   SESSION:DATE-FORMAT = "ymd".

   session:numeric-format = 'american'.

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   IF NOT AVAILABLE (ordem-compra) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "8".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Nao ha dados a serem exibidos".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.
   ELSE DO:
      soap-response:CREATE-NODE(rspNode, "m:find-ordem-compra-response", "ELEMENT").
      rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:find-ordem-compra-response").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(hOrdNode, "ordem-compra", "ELEMENT").
      rspNode:APPEND-CHILD(hOrdNode).

      hOrdNode:SET-ATTRIBUTE("ordem-compra.numero-ordem", STRING(ordem-compra.numero-ordem)) NO-ERROR.

      soap-response:CREATE-NODE(xmlParam, "ordem-compra.narrativa", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = ordem-compra.narrativa NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "ordem-compra.num-pedido", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(ordem-compra.num-pedido) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).
   END.

   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.
END PROCEDURE.

