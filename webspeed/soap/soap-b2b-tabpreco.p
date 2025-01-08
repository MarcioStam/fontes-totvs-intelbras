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

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

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
            IF soap-procedure:NAME = ns-prefix + "zoom-tabpreco-consumidor" THEN
                RUN process-zoom-tabpreco-consumidor(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "zoom-tabpreco-pecas" THEN
                RUN process-zoom-tabpreco-pecas(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "zoom-tb-pr-cc-emitente" THEN
                RUN process-zoom-tb-pr-cc-emitente(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "zoom-tabpreco-grupo" THEN
                RUN process-zoom-tabpreco-grupo(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "zoom-tabpreco-cliente" THEN
                RUN process-zoom-tabpreco-cliente(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
        END.
    END.

    /* Clean up */
    DELETE OBJECT soap-procedure.
    DELETE PROCEDURE hutil.

    RETURN.
END PROCEDURE.

PROCEDURE process-zoom-tabpreco-consumidor:
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

   DEFINE VARIABLE c-lay-codigo AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-lay-ini    AS INTEGER   NO-UNDO.
   DEFINE VARIABLE i-lay-fim    AS INTEGER   NO-UNDO.

   DEFINE VARIABLE l-response   AS LOGICAL NO-UNDO.
   DEFINE VARIABLE hIteNode     AS HANDLE  NO-UNDO.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
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
         WHEN "lay-codigo" THEN
            c-lay-codigo = tt-xml.elementValue.
      END CASE.
   END.

   IF (c-lay-codigo <> ? AND c-lay-codigo > "0") THEN
      ASSIGN i-lay-ini = INT(c-lay-codigo)
             i-lay-fim = INT(c-lay-codigo).
   ELSE
      ASSIGN i-lay-ini = 0
             i-lay-fim = 999.

   SESSION:NUMERIC-FORMAT = "AMERICAN".

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   FOR EACH layout-tabpreco NO-LOCK
      WHERE layout-tabpreco.lay-codigo >= i-lay-ini
        AND layout-tabpreco.lay-codigo <= i-lay-fim,
      EACH item-layout-tabpreco OF layout-tabpreco NO-LOCK,
      FIRST item FIELDS (it-codigo desc-item aliquota-ipi) OF item-layout-tabpreco NO-LOCK,
      FIRST preco-item FIELDS (situacao) NO-LOCK
         WHERE preco-item.it-codigo  = item-layout-tabpreco.it-codigo
           AND preco-item.situacao   = 1
           AND preco-item.cod-refer  = ''
           AND preco-item.nr-tabpre  = '00101'
           AND preco-item.dt-inival <= TODAY,
      FIRST int-preco-item FIELDS (pma pmd preco-unico) OF preco-item NO-LOCK
      BREAK BY layout-tabpreco.lay-nome
            BY item.desc-item:

      IF NOT (l-response) THEN DO:
         ASSIGN l-response = YES.

         soap-response:CREATE-NODE(rspNode, "m:zoom-tabpreco-consumidor-response", "ELEMENT").
         rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-tabpreco-consumidor-response").
         ttElements.nhandle:APPEND-CHILD(rspNode).
      END.

      IF FIRST-OF (layout-tabpreco.lay-nome) THEN DO:
         soap-response:CREATE-NODE(hOrdNode, "layout-tabpreco", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         hOrdNode:SET-ATTRIBUTE("layout-tabpreco.lay-codigo", STRING(layout-tabpreco.lay-codigo)) NO-ERROR.

         soap-response:CREATE-NODE(xmlParam, "layout-tabpreco.lay-nome", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = layout-tabpreco.lay-nome NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).
      END.

      soap-response:CREATE-NODE(hIteNode, "preco-item", "ELEMENT").
      hOrdNode:APPEND-CHILD(hIteNode).

      soap-response:CREATE-NODE(xmlParam, "item.it-codigo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = item.it-codigo NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item.desc-item", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = item.desc-item NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item.aliquota-ipi", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(item.aliquota-ipi) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "int-preco-item.pma", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(int-preco-item.pma) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "preco-com-ipi", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING((((item.aliquota-ipi / 100) + 1) * int-preco-item.pma)) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).
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

PROCEDURE process-zoom-tabpreco-pecas:
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

   DEFINE VARIABLE c-pais        AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-estado      AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE d-ipi         AS DECIMAL     NO-UNDO.
   DEFINE VARIABLE d-icms        AS DECIMAL     NO-UNDO.
   DEFINE VARIABLE c-count       AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE i-count       AS INTEGER     NO-UNDO.
   DEFINE VARIABLE c-busca       AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-tipo-busca  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE l-ok          AS LOGICAL     NO-UNDO.

   define variable de-preco-lai  as decimal     no-undo.
   define variable de-preco-rev  as decimal     no-undo.
   define variable de-preco-cf   as decimal     no-undo.
   define variable d-intelbras   as decimal     no-undo.
   define variable d-lai         as decimal     no-undo.
   define variable c-cod-emitente as character no-undo.
   define variable i-cod-emitente as integer   no-undo.

   DEFINE VARIABLE l-response AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE hIteNode   AS HANDLE   NO-UNDO.

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
         WHEN "estado" THEN
            c-estado = tt-xml.elementValue.
         WHEN "pais" THEN
            c-pais = tt-xml.elementValue.
         WHEN "count" THEN
            c-count = tt-xml.elementValue.
         WHEN "busca" THEN
            c-busca = tt-xml.elementValue.
         WHEN "tipo-busca" THEN
            c-tipo-busca = tt-xml.elementValue.
         when "cod-emitente" then
            c-cod-emitente = tt-xml.elementValue.
      END CASE.
   END.

   CREATE QUERY hQuery.

   ASSIGN c-where = "EACH item FIELDS (it-codigo desc-item aliquota-ipi ge-codigo) NO-LOCK ".

   CASE c-tipo-busca:
      WHEN "codigo" THEN
         ASSIGN c-where = c-where + " WHERE item.it-codigo MATCHES '*" + c-busca + "*' ".
      WHEN "descricao" THEN
         ASSIGN c-where = c-where + " WHERE item.desc-item MATCHES '*" + c-busca + "*' ".
   END CASE.

   ASSIGN c-where = c-where + ", FIRST preco-item FIELDS (preco-venda) NO-LOCK
                                    WHERE preco-item.it-codigo  = item.it-codigo
                                      AND preco-item.situacao   = 1
                                      AND preco-item.cod-refer  = ''
                                      AND preco-item.nr-tabpre  = 'LAI02'
                                      AND preco-item.dt-inival <= TODAY ".

   ASSIGN c-sort = " BY item.it-codigo".

   hQuery:SET-BUFFERS(BUFFER item:Handle, BUFFER preco-item:Handle).

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   /** Regra para utilizar o ICMS correto
    *  Alterada devido ao uso das exce‡äes
    */
   FIND FIRST estabelec NO-LOCK
      WHERE estabelec.cod-estabel = '101' NO-ERROR.
   FIND FIRST unid-feder NO-LOCK
      WHERE unid-feder.pais   = estabelec.pais
        AND unid-feder.estado = estabelec.estado NO-ERROR.

   if (c-cod-emitente <> "") then do:
      assign i-cod-emitente = int(c-cod-emitente).
      find emitente no-lock
         where emitente.cod-emitente = i-cod-emitente no-error.

      if available emitente then
         assign c-estado = emitente.estado.
   end.

   ASSIGN d-icms = 1
          l-ok   = NO.

   IF (unid-feder.estado = c-estado) THEN
      ASSIGN d-icms = unid-feder.per-icms-int / 100.
   ELSE DO:
      DO i = 1 TO 25:
         IF (unid-feder.est-exc[i] = c-estado) AND NOT (l-ok) THEN
            ASSIGN d-icms = unid-feder.perc-exc[i] / 100
                   l-ok   = YES.
      END.
      IF NOT (l-ok) THEN
         ASSIGN d-icms = unid-feder.per-icms-ext / 100.
   END.

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

   IF (c-count <> ?) AND (c-count > "") THEN
      i-count = INT(c-count).

   /** Reposiciona para a proxima pagina **/
   IF (i-count > 1) THEN
      hQuery:REPOSITION-TO-ROW(i-count + 1).

   IF (hQuery:NUM-RESULTS = 0) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "1".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Nenhum cliente a ser exibido".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
   END.
   ELSE DO:
      SESSION:NUMERIC-FORMAT = "AMERICAN".

      /** Cria o cabecalho de resposta **/
      soap-response:CREATE-NODE(rspNode, "m:zoom-tabpreco-pecas-response", "ELEMENT").
      rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-pecas-consumidor-response").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(hOrdNode, "unid-feder", "ELEMENT").
      rspNode:APPEND-CHILD(hOrdNode).

      hOrdNode:SET-ATTRIBUTE("unid-feder.per-icms", STRING(1 - d-icms)) NO-ERROR.

      soap-response:CREATE-NODE(xmlParam, "unid-feder.no-estado", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = unid-feder.no-estado NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(hOrdNode, "tabpreco", "ELEMENT").
      rspNode:APPEND-CHILD(hOrdNode).

      run esp/es0018p.p (input "es0778", /* Nome do programa */
                         input 3,        /* Ponto do programa */
                         input 0,
                         input "",
                         output table tt-prog-ponto).

      REPEAT:
         hQuery:GET-NEXT.
         IF (hQuery:QUERY-OFF-END) OR (hQuery:CURRENT-RESULT-ROW - i-count > 250) THEN DO:
            soap-response:CREATE-NODE(hOrdNode, "last-tabpreco", "ELEMENT").
            rspNode:APPEND-CHILD(hOrdNode).

            hOrdNode:SET-ATTRIBUTE("count",   STRING(i-count)) NO-ERROR.
            hOrdNode:SET-ATTRIBUTE("current", STRING(hQuery:CURRENT-RESULT-ROW - 1)) NO-ERROR.
            LEAVE.
         END.

         /** Seta a variavel referente ao IPI **/
         ASSIGN d-ipi = item.aliquota-ipi / 100.

         soap-response:CREATE-NODE(hIteNode, "preco-item", "ELEMENT").
         hOrdNode:APPEND-CHILD(hIteNode).

         soap-response:CREATE-NODE(xmlParam, "item.it-codigo", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = item.it-codigo NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "item.desc-item", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = item.desc-item NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "item.aliquota-ipi", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(item.aliquota-ipi) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "item.ge-codigo", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(item.ge-codigo) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         /**
          * Explica‡Æo do 0.495:
          * - LAI tem 25% de desconto em cima do pre‡o de revenda, mais uma
          *   bonifica‡Æo de 12% -- conforme explicado por Lazare em 27.04,
          *   para Felipe e Claudiney.
          * - 0.495 = 0.75 * 0.75 * 0.88
          */
         /**
          * Altera‡Æo de desconto de 25% + 25% + 12% para 20% + 20% + 12%,
          * conforme combinado com Cida e M rcio
          */ 
         /**
          * Removido os 12% conforme solicitado pela Cida
          */
         /**
          * Alterada a forma de c lculo conforme solicitado pelo Lazare. Agora tem um valor
          * para mat‚ria prima, outro pro restante.
          */
         /**
          * Incidente 18513: alterando percentuais para alguns itens
          */

         if can-find(first tt-prog-ponto
                     where tt-prog-ponto.conteudo = item.it-codigo) then
            assign d-intelbras = 1.25
                   d-lai       = 1.12.
         else
            assign d-intelbras = 1.25
                   d-lai       = (if item.desc-item begins 'PLACA' then 1.3 else 1.51).

         soap-response:CREATE-NODE(xmlParam, "preco-lai", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(preco-item.preco-venda / (1 - d-icms) * (1 + d-ipi) / d-intelbras / d-lai) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "preco-lai-sem-ipi", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(preco-item.preco-venda / (1 - d-icms) / d-intelbras / d-lai) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         /**
          * Pre‡o de revenda: 25% de desconto no pre‡o de tabela
          *
          * Alterado para 20% em 13/07/2009
          */
         soap-response:CREATE-NODE(xmlParam, "preco-revenda", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(preco-item.preco-venda / (1 - d-icms) * (1 + d-ipi) / 1.25) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "preco-revenda-sem-ipi", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(preco-item.preco-venda / (1 - d-icms) / 1.25) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).

         /**
          * Pre‡o do consumidor final: 17% de acr‚scimo no pre‡o de tabela
          */
         soap-response:CREATE-NODE(xmlParam, "preco-consumidor", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(preco-item.preco-venda / (1 - d-icms) * (1 + d-ipi)) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).
      END. /** REPEAT **/
   END. /** ELSE DO **/

   DELETE OBJECT hQuery.
   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

PROCEDURE process-zoom-tb-pr-cc-emitente:
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

   DEFINE VARIABLE l-response   AS LOGICAL NO-UNDO.
   DEFINE VARIABLE hIteNode     AS HANDLE  NO-UNDO.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
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

   FOR EACH tb-pr-cc FIELDS (nr-tab codigo-ipi taxa-financ dt-inicio dt-termino) NO-LOCK
      WHERE tb-pr-cc.cod-emitente = i-cod-emitente
        AND tb-pr-cc.situacao     = 1
        AND tb-pr-cc.dt-inicio   <= TODAY
        AND tb-pr-cc.dt-termino  >= TODAY,
      FIRST cond-pagto FIELDS (cod-cond-pag descricao) NO-LOCK
         WHERE cond-pagto.cod-cond-pag = tb-pr-cc.cod-cond-pag,
      FIRST moeda FIELDS (mo-codigo descricao) NO-LOCK
         WHERE moeda.mo-codigo = tb-pr-cc.mo-codigo,
      EACH item-tab FIELDS (aliquota-icm aliquota-ipi pr-item) NO-LOCK
         WHERE item-tab.cod-emitente = tb-pr-cc.cod-emitente
           AND item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
           AND item-tab.nr-tab       = tb-pr-cc.nr-tab,
      EACH item-fornec-estab FIELDS (unid-med-for lote-minimo lote-mul-for it-codigo) NO-LOCK
         WHERE item-fornec-estab.cod-emitente = tb-pr-cc.cod-emitente
           AND item-fornec-estab.it-codigo    = item-tab.it-codigo
           AND item-fornec-estab.ativo,
      FIRST item-uni-estab FIELDS (cod-comprado)
      WHERE item-uni-estab.it-codigo   = item-fornec-estab.it-codigo
        AND item-uni-estab.cod-estabel = item-fornec-estab.cod-estabel,
      FIRST usuar-mater FIELDS (nome) NO-LOCK
         WHERE usuar-mater.cod-usuario = item-uni-estab.cod-comprado,
      FIRST ITEM FIELDS (it-codigo desc-item) NO-LOCK
         WHERE item.it-codigo = item-tab.it-codigo
      
      BREAK BY tb-pr-cc.nr-tab
            BY item.it-codigo:

      FIND FIRST int-item-for-PN NO-LOCK
          WHERE int-item-for-PN.cod-emitente = item-fornec-estab.cod-emitente
            AND int-item-for-PN.it-codigo    = item-fornec-estab.it-codigo NO-ERROR.

      IF  AVAIL int-item-for-PN THEN
          FIND FIRST item-fabric NO-LOCK
             WHERE item-fabric.it-codigo          = int-item-for-PN.it-codigo
               AND STRING(item-fabric.cod-fabric) = int-item-for-PN.item-do-forn NO-ERROR.

      IF NOT (l-response) THEN DO:
         ASSIGN l-response = YES.

         soap-response:CREATE-NODE(rspNode, "m:zoom-tb-pr-cc-emitente-response", "ELEMENT").
         rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-tb-pr-cc-emitente-response").
         ttElements.nhandle:APPEND-CHILD(rspNode).
      END.

      IF FIRST-OF (tb-pr-cc.nr-tab) THEN DO:
         soap-response:CREATE-NODE(hOrdNode, "tb-pr-cc", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         hOrdNode:SET-ATTRIBUTE("tb-pr-cc.nr-tab", STRING(tb-pr-cc.nr-tab)) NO-ERROR.

         soap-response:CREATE-NODE(xmlParam, "cond-pagto.cod-cond-pag", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(cond-pagto.cod-cond-pag) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "cond-pagto.descricao", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = cond-pagto.descricao NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tb-pr-cc.codigo-ipi", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         IF (tb-pr-cc.codigo-ipi) THEN
            xmlText:NODE-VALUE = "true" NO-ERROR.
         ELSE
            xmlText:NODE-VALUE = "false" NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tb-pr-cc.taxa-financ", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         IF (tb-pr-cc.taxa-financ) THEN
            xmlText:NODE-VALUE = "true" NO-ERROR.
         ELSE
            xmlText:NODE-VALUE = "false" NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tb-pr-cc.dt-inicio", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tb-pr-cc.dt-inicio, "9999-99-99") NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "tb-pr-cc.dt-termino", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(tb-pr-cc.dt-termino, "9999-99-99") NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).

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
      END.

      soap-response:CREATE-NODE(hIteNode, "item-tab", "ELEMENT").
      hOrdNode:APPEND-CHILD(hIteNode).

      hIteNode:SET-ATTRIBUTE("item-fornec.unid-med-for", item-fornec-estab.unid-med-for) NO-ERROR.

      soap-response:CREATE-NODE(xmlParam, "item.it-codigo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = item.it-codigo NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "usuar-mater.nome", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = usuar-mater.nome NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item-descricao", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = item.desc-item NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      IF AVAILABLE (item-fabric) THEN DO:
         soap-response:CREATE-NODE(xmlParam, "item-fabric.it-fabric", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = item-fabric.it-fabric NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).
      END.

      soap-response:CREATE-NODE(xmlParam, "item-fornec.lote-minimo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(item-fornec-estab.lote-minimo) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item-fornec.lote-mul-for", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(item-fornec-estab.lote-mul-for) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item-tab.aliquota-icm", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(item-tab.aliquota-icm) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item-tab.aliquota-ipi", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(item-tab.aliquota-ipi) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item-tab.pr-item", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(item-tab.pr-item) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).
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

PROCEDURE process-zoom-tabpreco-grupo:
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

   DEFINE VARIABLE c-lay-codigo  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-estado      AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-cod-gr-cli  AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE i-lay-ini     AS INTEGER     NO-UNDO.
   DEFINE VARIABLE i-lay-fim     AS INTEGER     NO-UNDO.
   DEFINE VARIABLE i-cod-gr-cli  AS INTEGER     NO-UNDO.
   DEFINE VARIABLE d-icms        AS DECIMAL     NO-UNDO.
   DEFINE VARIABLE d-ipi         AS DECIMAL     NO-UNDO.
   DEFINE VARIABLE d-valor       AS DECIMAL     NO-UNDO.

   DEFINE VARIABLE l-response   AS LOGICAL NO-UNDO.
   DEFINE VARIABLE hIteNode     AS HANDLE  NO-UNDO.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
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
         WHEN "lay-codigo" THEN
            c-lay-codigo = tt-xml.elementValue.
         WHEN "estado" THEN
            c-estado = tt-xml.elementValue.
         WHEN "cod-gr-cli" THEN
            c-cod-gr-cli = tt-xml.elementValue.
      END CASE.
   END.

   IF (c-lay-codigo <> ? AND c-lay-codigo > "0") THEN
      ASSIGN i-lay-ini = INT(c-lay-codigo)
             i-lay-fim = INT(c-lay-codigo).
   ELSE
      ASSIGN i-lay-ini = 0
             i-lay-fim = 999.

   IF (c-cod-gr-cli <> ?) AND (c-cod-gr-cli > "") THEN
      ASSIGN i-cod-gr-cli = INT(c-cod-gr-cli).

   SESSION:NUMERIC-FORMAT = "AMERICAN".

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   FIND FIRST gr-cli NO-LOCK
      WHERE gr-cli.cod-gr-cli = i-cod-gr-cli NO-ERROR.

   FIND FIRST unid-feder NO-LOCK
      WHERE unid-feder.pais   = "Brasil"
        AND unid-feder.estado = c-estado NO-ERROR.

   IF (unid-feder.estado = 'SC') THEN
      ASSIGN d-icms = ((100 - unid-feder.per-icms-int) / 100).
   ELSE
      ASSIGN d-icms = ((100 - unid-feder.per-icms-ext) / 100).

   FOR EACH layout-tabpreco NO-LOCK
      WHERE layout-tabpreco.lay-codigo >= i-lay-ini
        AND layout-tabpreco.lay-codigo <= i-lay-fim,
      EACH item-layout-tabpreco OF layout-tabpreco NO-LOCK,
      FIRST item FIELDS (it-codigo desc-item aliquota-ipi) OF item-layout-tabpreco NO-LOCK,
      FIRST preco-item FIELDS (preco-venda) NO-LOCK
         WHERE preco-item.it-codigo  = item-layout-tabpreco.it-codigo
           AND preco-item.situacao   = 1
           AND preco-item.cod-refer  = ''
           AND preco-item.nr-tabpre  = '00101'
           AND preco-item.dt-inival <= TODAY,
      FIRST int-preco-item FIELDS (pma pmd preco-unico) OF preco-item NO-LOCK
      BREAK BY layout-tabpreco.lay-nome
            BY item.desc-item:

      IF NOT (l-response) THEN DO:
         ASSIGN l-response = YES.

         soap-response:CREATE-NODE(rspNode, "m:zoom-tabpreco-grupo-response", "ELEMENT").
         rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-tabpreco-grupo-response").
         ttElements.nhandle:APPEND-CHILD(rspNode).

         soap-response:CREATE-NODE(hOrdNode, "gr-cli", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         hOrdNode:SET-ATTRIBUTE("gr-cli.cod-gr-cli", STRING(gr-cli.cod-gr-cli)) NO-ERROR.

         soap-response:CREATE-NODE(xmlParam, "gr-cli.descricao", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = gr-cli.descricao NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(hOrdNode, "unid-feder", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         hOrdNode:SET-ATTRIBUTE("unid-feder.per-icms", STRING(d-icms)) NO-ERROR.

         soap-response:CREATE-NODE(xmlParam, "unid-feder.no-estado", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = unid-feder.no-estado NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).
      END.

      IF FIRST-OF (layout-tabpreco.lay-nome) THEN DO:
         soap-response:CREATE-NODE(hOrdNode, "layout-tabpreco", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         hOrdNode:SET-ATTRIBUTE("layout-tabpreco.lay-codigo", STRING(layout-tabpreco.lay-codigo)) NO-ERROR.

         soap-response:CREATE-NODE(xmlParam, "layout-tabpreco.lay-nome", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = layout-tabpreco.lay-nome NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).
      END.

      soap-response:CREATE-NODE(hIteNode, "preco-item", "ELEMENT").
      hOrdNode:APPEND-CHILD(hIteNode).

      soap-response:CREATE-NODE(xmlParam, "item.it-codigo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = item.it-codigo NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item.desc-item", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = item.desc-item NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item.aliquota-ipi", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(item.aliquota-ipi) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      IF (int-preco-item.preco-unico > 0) THEN
         ASSIGN d-valor = int-preco-item.preco-unico / d-icms.
      ELSE
         /** TODO **/
         /** FALTA VER SOBRE O DESCONTO DA CATEGORIA DO CLIENTE **/
         ASSIGN d-valor = preco-item.preco-venda / d-icms.

      soap-response:CREATE-NODE(xmlParam, "preco-sem-ipi", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(d-valor) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      ASSIGN d-ipi = item.aliquota-ipi / 100 + 1.

      soap-response:CREATE-NODE(xmlParam, "preco-com-ipi", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(d-valor * d-ipi) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      /** hardcoded mesmo... **/
      IF (gr-cli.cod-gr-cli = 24) THEN DO:
         soap-response:CREATE-NODE(xmlParam, "pmd-com-ipi", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(int-preco-item.pmd * d-ipi) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).
      END.
      ELSE DO:
         soap-response:CREATE-NODE(xmlParam, "pma-com-ipi", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(int-preco-item.pma * d-ipi) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).
      END.
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

PROCEDURE process-zoom-tabpreco-cliente:
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

   DEFINE VARIABLE c-cgc         AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE d-icms        AS DECIMAL     NO-UNDO.
   DEFINE VARIABLE d-ipi         AS DECIMAL     NO-UNDO.
   DEFINE VARIABLE d-valor       AS DECIMAL     NO-UNDO.

   DEFINE VARIABLE l-response   AS LOGICAL NO-UNDO.
   DEFINE VARIABLE hIteNode     AS HANDLE  NO-UNDO.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
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
         WHEN "cgc" THEN
            c-cgc = tt-xml.elementValue.
      END CASE.
   END.

   SESSION:NUMERIC-FORMAT = "AMERICAN".

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   FIND FIRST emitente NO-LOCK
      WHERE emitente.cgc = c-cgc NO-ERROR.

   IF NOT AVAILABLE (emitente) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "13".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "faultstring", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "Emitente inexistente".
      xmlParam:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(xmlParam).
      LEAVE.
   END.

   FIND FIRST gr-cli NO-LOCK
      WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-ERROR.

   FIND FIRST unid-feder NO-LOCK
      WHERE unid-feder.pais   = emitente.pais
        AND unid-feder.estado = emitente.estado NO-ERROR.

   IF (unid-feder.estado = 'SC') THEN
      ASSIGN d-icms = ((100 - unid-feder.per-icms-int) / 100).
   ELSE
      ASSIGN d-icms = ((100 - unid-feder.per-icms-ext) / 100).

   FOR EACH layout-tabpreco NO-LOCK,
      EACH item-layout-tabpreco OF layout-tabpreco NO-LOCK,
      FIRST item FIELDS (it-codigo desc-item aliquota-ipi) OF item-layout-tabpreco NO-LOCK,
      FIRST preco-item FIELDS (preco-venda) NO-LOCK
         WHERE preco-item.it-codigo  = item-layout-tabpreco.it-codigo
           AND preco-item.situacao   = 1
           AND preco-item.cod-refer  = ''
           AND preco-item.nr-tabpre  = '00101'
           AND preco-item.dt-inival <= TODAY,
      FIRST int-preco-item FIELDS (pma pmd preco-unico) OF preco-item NO-LOCK
      BREAK BY layout-tabpreco.lay-nome
            BY item.desc-item:

      IF NOT (l-response) THEN DO:
         ASSIGN l-response = YES.

         soap-response:CREATE-NODE(rspNode, "m:zoom-tabpreco-cliente-response", "ELEMENT").
         rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-tabpreco-cliente-response").
         ttElements.nhandle:APPEND-CHILD(rspNode).

         soap-response:CREATE-NODE(hOrdNode, "emitente", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         hOrdNode:SET-ATTRIBUTE("emitente.cod-emitente", STRING(emitente.cod-emitente)) NO-ERROR.

         soap-response:CREATE-NODE(xmlParam, "emitente.nome-emit", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = emitente.nome-emit NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(hOrdNode, "unid-feder", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         hOrdNode:SET-ATTRIBUTE("unid-feder.per-icms", STRING(d-icms)) NO-ERROR.

         soap-response:CREATE-NODE(xmlParam, "unid-feder.no-estado", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = unid-feder.no-estado NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).
      END.

      IF FIRST-OF (layout-tabpreco.lay-nome) THEN DO:
         soap-response:CREATE-NODE(hOrdNode, "layout-tabpreco", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         hOrdNode:SET-ATTRIBUTE("layout-tabpreco.lay-codigo", STRING(layout-tabpreco.lay-codigo)) NO-ERROR.

         soap-response:CREATE-NODE(xmlParam, "layout-tabpreco.lay-nome", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = layout-tabpreco.lay-nome NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).
      END.

      soap-response:CREATE-NODE(hIteNode, "preco-item", "ELEMENT").
      hOrdNode:APPEND-CHILD(hIteNode).

      soap-response:CREATE-NODE(xmlParam, "item.it-codigo", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = item.it-codigo NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item.desc-item", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = item.desc-item NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "item.aliquota-ipi", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(item.aliquota-ipi) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      IF (int-preco-item.preco-unico > 0) THEN
         ASSIGN d-valor = int-preco-item.preco-unico / d-icms.
      ELSE
         /** TODO **/
         /** FALTA VER SOBRE O DESCONTO DA CATEGORIA DO CLIENTE **/
         ASSIGN d-valor = preco-item.preco-venda / d-icms.

      soap-response:CREATE-NODE(xmlParam, "preco-sem-ipi", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(d-valor) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      ASSIGN d-ipi = item.aliquota-ipi / 100 + 1.

      soap-response:CREATE-NODE(xmlParam, "preco-com-ipi", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(d-valor * d-ipi) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hIteNode:APPEND-CHILD(xmlParam).

      /** hardcoded mesmo... **/
      IF (gr-cli.cod-gr-cli = 24) THEN DO:
         soap-response:CREATE-NODE(xmlParam, "pmd-com-ipi", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(int-preco-item.pmd * d-ipi) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).
      END.
      ELSE DO:
         soap-response:CREATE-NODE(xmlParam, "pma-com-ipi", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(int-preco-item.pma * d-ipi) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hIteNode:APPEND-CHILD(xmlParam).
      END.
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

