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
DEFINE VARIABLE c-cod-estabel       AS CHARACTER   NO-UNDO.
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
            IF soap-procedure:NAME = ns-prefix + "find-emitente" THEN
                RUN process-find-emitente(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "zoom-emitente" THEN
                RUN process-zoom-emitente(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "zoom-descontos" THEN
                RUN process-zoom-descontos(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
            ELSE IF soap-procedure:NAME = ns-prefix + "create-emitente-cartao" THEN
                RUN process-create-emitente-cartao(INPUT soap-application-name, INPUT soap-procedure, INPUT ns-prefix, INPUT-OUTPUT soap-response).
        END.
    END.

    /* Clean up */
    DELETE OBJECT soap-procedure.
    DELETE PROCEDURE hutil.

    RETURN.
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

   DEFINE VARIABLE c-cod-emitente AS CHAR NO-UNDO.
   DEFINE VARIABLE i-cod-emitente AS INT  NO-UNDO.

   DEFINE VARIABLE de-perc-desc     AS DECIMAL NO-UNDO.
   DEFINE VARIABLE l-permite-vendor AS LOGICAL NO-UNDO.

   DEFINE VARIABLE l-response     AS LOGICAL NO-UNDO.
   DEFINE VARIABLE l-historico    AS LOGICAL NO-UNDO.
   DEFINE VARIABLE hCtoNode       AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hHisNode       AS HANDLE  NO-UNDO.

   /* Create our handles */
   CREATE SERVER happ.
   CREATE X-NODEREF rspNode.
   CREATE X-NODEREF xmlParam.
   CREATE X-NODEREF xmlText.
   CREATE X-NODEREF hOrdRoot.
   CREATE X-NODEREF hOrdNode.
   CREATE X-NODEREF hCtoNode.
   CREATE X-NODEREF hHisNode.

   RUN getElementsByTagName IN hutil(INPUT soap-procedure, "cod-emitente", OUTPUT TABLE ttElements).
   FIND FIRST ttElements NO-LOCK NO-ERROR.
   IF AVAILABLE ttElements THEN
      c-cod-emitente = ttElements.nodeValue.

   IF (c-cod-emitente <> ? AND c-cod-emitente > "") THEN
      ASSIGN i-cod-emitente = INT(c-cod-emitente).

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   IF c-cod-estabel = "" THEN ASSIGN c-cod-estabel = "101".
   

   FOR FIRST emitente FIELDS (cod-emitente nome-emit cgc ins-estadual cod-suframa bonificacao
                              ind-cre-cli observacoes lim-credito dt-lim-cred endereco bairro
                              cidade estado cep endereco-cob bairro-cob cidade-cob estado-cob
                              cep-cob telefone categoria) NO-LOCK
      WHERE emitente.cod-emitente = i-cod-emitente:

      SESSION:NUMERIC-FORMAT = "AMERICAN".

      ASSIGN l-response = YES.

      /** Tratamento do desconto de pontualidade **/
      ASSIGN de-perc-desc = 2.
      
      FIND FIRST estabelec    NO-LOCK WHERE estabelec.cod-estabel = c-cod-estabel.

      IF CAN-FIND (FIRST tit_acr NO-LOCK
         WHERE (tit_acr.cod_estab            = estabelec.cod-estabel
           AND  tit_acr.cdn_cliente          = emitente.cod-emitente
           AND  tit_acr.log_sdo_tit_acr      = YES
           AND  tit_acr.log_tit_acr_estordo  = NO
           AND  tit_acr.dat_vencto_tit_acr  <= TODAY - 6
           AND (tit_acr.cod_cart_bci        <> "90"
           AND (tit_acr.cod_portador        <> "9996"
           AND  tit_acr.cod_portad          <> "9905"
           AND  tit_acr.cod_portad          <> "9977"))
           AND (tit_acr.ind_tip_espec_docto  = "normal"
            OR  tit_acr.ind_tip_espec_docto  = "vendor"))) THEN
         ASSIGN de-perc-desc = 0.

      IF CAN-FIND (FIRST tit_acr NO-LOCK
         WHERE (tit_acr.cod_estab           = estabelec.cod-estabel
           AND  tit_acr.cdn_cliente         = emitente.cod-emitente
           AND  tit_acr.log_sdo_tit_acr     = YES
           AND  tit_acr.log_tit_acr_estordo = NO
           AND  tit_acr.cod_espec_docto     = "vd")) THEN
         ASSIGN de-perc-desc = 0.

      /** Tratamento do vendor **/
      IF CAN-FIND (FIRST contrat_vendor NO-LOCK
         WHERE contrat_vendor.cdn_cliente    = emitente.cod-emitente
           AND contrat_vendor.dat_fim_valid >= TODAY) THEN
         ASSIGN l-permite-vendor = YES.
      ELSE
         ASSIGN l-permite-vendor = NO.

      FIND FIRST gr-cli OF emitente NO-LOCK NO-ERROR.

      soap-response:CREATE-NODE(rspNode, "m:find-emitente-response", "ELEMENT").
      rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:find-emitente-response").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(hOrdNode, "emitente", "ELEMENT").
      rspNode:APPEND-CHILD(hOrdNode).

      hOrdNode:SET-ATTRIBUTE("emitente.cod-emitente", STRING(emitente.cod-emitente)) NO-ERROR.
      IF (emitente.ins-estadual BEGINS "Isen" OR emitente.ins-estadual = "") THEN
         hOrdNode:SET-ATTRIBUTE("consumidor-final", "true") NO-ERROR.
      ELSE
         hOrdNode:SET-ATTRIBUTE("consumidor-final", "false") NO-ERROR.

      soap-response:CREATE-NODE(xmlParam, "emitente.nome-emit", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.nome-emit NO-ERROR.
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

      soap-response:CREATE-NODE(xmlParam, "estabelec.cod-estabel", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = estabelec.cod-estabel NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).


      FOR EACH cont-emit FIELDS (nome e-mail telefone ramal) OF emitente NO-LOCK:
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

         soap-response:CREATE-NODE(xmlParam, "cont-emit.telefone", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = cont-emit.telefone NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hCtoNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "cont-emit.ramal", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = cont-emit.ramal NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hCtoNode:APPEND-CHILD(xmlParam).
      END.

      soap-response:CREATE-NODE(xmlParam, "emitente.telefone", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.telefone[1] NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "gr-cli.descricao", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = gr-cli.descricao NO-ERROR.
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

      soap-response:CREATE-NODE(xmlParam, "emitente.cep", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.cep NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.endereco-cob", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.endereco-cob NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.bairro-cob", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.bairro-cob NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.cidade-cob", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.cidade-cob NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.estado-cob", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.estado-cob NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.cep-cob", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.cep-cob NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      FIND FIRST indice-cgc NO-LOCK
         WHERE indice-cgc.cgc = SUBSTRING(emitente.cgc, 1, 8) NO-ERROR.
      IF AVAILABLE (indice-cgc) THEN DO:
         soap-response:CREATE-NODE(xmlParam, "indice-cgc.indice", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(indice-cgc.indice) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).
      END.

      soap-response:CREATE-NODE(xmlParam, "emitente.lim-credito", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(emitente.lim-credito) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.dt-lim-cred", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(emitente.dt-lim-cred, "99/99/9999") NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.cod-suframa", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(emitente.cod-suframa) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.bonificacao", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(emitente.bonificacao) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "desconto-pontualidade", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(de-perc-desc) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.ind-cre-cli", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(emitente.ind-cre-cli) NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "contrat_vendor", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      IF (l-permite-vendor) THEN
         xmlText:NODE-VALUE = "true" NO-ERROR.
      ELSE
         xmlText:NODE-VALUE = "false" NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      soap-response:CREATE-NODE(xmlParam, "emitente.observacoes", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.observacoes NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).
	  
	  soap-response:CREATE-NODE(xmlParam, "emitente.categoria", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = emitente.categoria NO-ERROR.
      xmlParam:APPEND-CHILD(xmlText).
      hOrdNode:APPEND-CHILD(xmlParam).

      /*
      FOR EACH histor_clien NO-LOCK
         WHERE histor_clien.cdn_cliente = emitente.cod-emitente
           AND histor_clien.cod_empresa = estabelec.cod-estabel
         BY histor_clien.dat_livre_1:

         IF NOT (l-historico) THEN DO:
            soap-response:CREATE-NODE(hHisNode, "histor_clien", "ELEMENT").
            hOrdNode:APPEND-CHILD(hHisNode).

            ASSIGN l-historico = YES.
         END.

         soap-response:CREATE-NODE(xmlParam, "emitente.observacoes", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = emitente.observacoes NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hHisNode:APPEND-CHILD(xmlParam).
      END.*/ /** FOR EACH **/
   END. /** FOR EACH **/

   IF NOT (l-response) THEN DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "12".
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

/** tt auxiliar **/
DEFINE TEMP-TABLE tt-repres
   FIELD cod-rep        LIKE repres.cod-rep
   FIELD no-ab-reppri   LIKE repres.nome-abrev
   INDEX ch-pri         AS PRIMARY UNIQUE cod-rep.

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
   DEFINE VARIABLE j         AS INTEGER NO-UNDO.

   DEFINE VARIABLE c-emitente          AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-busca-por-cliente AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-estado            AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-cidade            AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-categoria         AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-cod-rep           AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-compraram         AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-data-ini          AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-data-fim          AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-count             AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE l-emitente          AS LOGICAL     NO-UNDO.
   DEFINE VARIABLE l-estado            AS LOGICAL     NO-UNDO.
   
   
   DEFINE VARIABLE dt-data-ini   AS DATE     NO-UNDO.
   DEFINE VARIABLE dt-data-fim   AS DATE     NO-UNDO.
   DEFINE VARIABLE l-compraram   AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE i-count       AS INTEGER  NO-UNDO  INIT 0.

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
         WHEN "emitente" THEN
            c-emitente = tt-xml.elementValue.
         WHEN "busca-por-cliente" THEN
            c-busca-por-cliente = tt-xml.elementValue.
         WHEN "estado" THEN
            c-estado = tt-xml.elementValue.
         WHEN "cidade" THEN
            c-cidade = tt-xml.elementValue.
         WHEN "categoria" THEN
            c-categoria = tt-xml.elementValue.
         WHEN "cod-rep" THEN
            c-cod-rep = tt-xml.elementValue.
         WHEN "compraram" THEN
            c-compraram = tt-xml.elementValue.
         WHEN "data-ini" THEN
            c-data-ini = tt-xml.elementValue.
         WHEN "data-fim" THEN
            c-data-fim = tt-xml.elementValue.
         WHEN "count" THEN
            c-count = tt-xml.elementValue.
         WHEN "cod-estabel" THEN
            c-cod-estabel = tt-xml.elementValue.
      END CASE.
   END.

   /** Ver quais os representantes que devem ser pesquisados **/
   ASSIGN i = NUM-ENTRIES(c-cod-rep, ";").

   IF (i > 0) THEN DO:
      DO j = 1 TO i:
         FIND FIRST repres NO-LOCK
            WHERE repres.cod-rep = INT(ENTRY(j, c-cod-rep, ";")) NO-ERROR.
         IF AVAILABLE (repres) THEN DO:
            CREATE tt-repres.
            ASSIGN tt-repres.cod-rep      = repres.cod-rep
                   tt-repres.no-ab-reppri = repres.nome-abrev.
         END.
      END.
   END.
   ELSE DO:
      /** Se o cara nao tem nenhum representante associado, vai todo mundo **/
      FOR EACH repres FIELDS (cod-rep nome-abrev) NO-LOCK:
         CREATE tt-repres.
         ASSIGN tt-repres.cod-rep      = repres.cod-rep
                tt-repres.no-ab-reppri = repres.nome-abrev.
      END.
   END.

   CREATE QUERY hQuery.

   ASSIGN c-where = "EACH emitente FIELDS (cod-emitente nome-emit endereco bairro cidade estado cep telefone) NO-LOCK ".

   IF (c-emitente <> ? AND c-emitente > "") THEN DO:
      ASSIGN l-emitente = YES.
      IF (c-busca-por-cliente = "cod") THEN
         ASSIGN c-where = c-where + " WHERE emitente.cod-emitente = " + c-emitente.
      ELSE
         ASSIGN c-where = c-where + " WHERE emitente.nome-emit MATCHES '*" + c-emitente + "*' ".
   END.

   IF (c-estado <> ? AND c-estado > "") THEN DO:
      ASSIGN l-estado = YES.
      IF (l-emitente) THEN
         ASSIGN c-where = c-where + " AND ".
      ELSE
         ASSIGN c-where = c-where + " WHERE ".
      ASSIGN c-where = c-where + " emitente.estado = '" + c-estado + "' ".
   END.

   IF (c-cidade <> ? AND c-cidade > "") THEN DO:
      IF (l-emitente) OR (l-estado) THEN
         ASSIGN c-where = c-where + " AND ".
      ELSE
         ASSIGN c-where = c-where + " WHERE ".
      ASSIGN c-where = c-where + " emitente.cidade MATCHES '*" + c-cidade + "*' ".
   END.

   ASSIGN c-where = c-where + ", FIRST tt-repres NO-LOCK
                           WHERE tt-repres.cod-rep = emitente.cod-rep ".

   IF (c-cod-rep <> ? AND c-cod-rep > "") THEN DO:
      ASSIGN c-where = c-where + " AND tt-repres.cod-rep = " + c-cod-rep.
   END.

   ASSIGN c-where = c-where + ", FIRST gr-cli FIELDS (cod-gr-cli) NO-LOCK
                           WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli ".

   IF (c-categoria <> ? AND c-categoria > "0") THEN DO:
      ASSIGN c-where = c-where + " AND gr-cli.cod-gr-cli = " + c-categoria.
   END.

   IF (c-compraram <> ? AND c-compraram = "true") THEN DO:
      ASSIGN c-where = c-where + ", FIRST ped-venda FIELDS (dt-emissao) NO-LOCK
                           WHERE ped-venda.nome-abrev  = emitente.nome-abrev ".

      ASSIGN l-compraram = YES
             c-where = c-where + " AND ped-venda.dt-emissao >= " + c-data-ini + "
                                   AND ped-venda.dt-emissao <= " + c-data-fim.

      hQuery:SET-BUFFERS(BUFFER emitente:Handle, BUFFER tt-repres:Handle, BUFFER gr-cli:Handle, BUFFER ped-venda:Handle).
   END.
   ELSE
      hQuery:SET-BUFFERS(BUFFER emitente:Handle, BUFFER tt-repres:Handle, BUFFER gr-cli:Handle).

   ASSIGN c-sort = " BY emitente.estado BY emitente.cidade BY emitente.bairro BY emitente.endereco BY emitente.nome-emit ".

   MESSAGE c-where.

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

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
      soap-response:CREATE-NODE(rspNode, "m:zoom-pedidos-response", "ELEMENT").
      rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-emitente-response").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      REPEAT:
         hQuery:GET-NEXT.
         IF (hQuery:QUERY-OFF-END) OR (hQuery:CURRENT-RESULT-ROW - i-count > 100) THEN DO:
            soap-response:CREATE-NODE(hOrdNode, "last-emitente", "ELEMENT").
            rspNode:APPEND-CHILD(hOrdNode).

            hOrdNode:SET-ATTRIBUTE("count",   STRING(i-count)) NO-ERROR.
            hOrdNode:SET-ATTRIBUTE("current", STRING(hQuery:CURRENT-RESULT-ROW - 1)) NO-ERROR.
            LEAVE.
         END.

         soap-response:CREATE-NODE(hOrdNode, "emitente", "ELEMENT").
         rspNode:APPEND-CHILD(hOrdNode).

         hOrdNode:SET-ATTRIBUTE("emitente.cod-emitente", STRING(emitente.cod-emitente)) NO-ERROR.

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

         soap-response:CREATE-NODE(xmlParam, "emitente.cep", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = emitente.cep NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).

         FOR FIRST cont-emit FIELDS (e-mail) OF emitente NO-LOCK:
            soap-response:CREATE-NODE(xmlParam, "cont-emit.e-mail", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = cont-emit.e-mail NO-ERROR.
            xmlParam:APPEND-CHILD(xmlText).
            hOrdNode:APPEND-CHILD(xmlParam).
         END.

         soap-response:CREATE-NODE(xmlParam, "emitente.telefone", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = emitente.telefone[1] NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hOrdNode:APPEND-CHILD(xmlParam).
      END. /** REPEAT **/
   END. /** ELSE DO **/

   DELETE OBJECT hQuery.
   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

PROCEDURE process-zoom-descontos:
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

   DEFINE VARIABLE c-emitente          AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-busca-por-cliente AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-estado            AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-cidade            AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-categoria         AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-cod-rep           AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE c-count             AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE l-emitente          AS LOGICAL     NO-UNDO.
   DEFINE VARIABLE l-estado            AS LOGICAL     NO-UNDO.
   DEFINE VARIABLE i-cod-gr-cli        AS INTEGER     NO-UNDO.
   DEFINE VARIABLE d-perc-desc         AS DECIMAL     NO-UNDO.
   
   DEFINE VARIABLE hEmitNode           AS HANDLE      NO-UNDO.

   DEFINE VARIABLE i-count       AS INTEGER  NO-UNDO  INIT 0.

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
   CREATE X-NODEREF hEmitNode.

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
         WHEN "emitente" THEN
            c-emitente = tt-xml.elementValue.
         WHEN "busca-por-cliente" THEN
            c-busca-por-cliente = tt-xml.elementValue.
         WHEN "estado" THEN
            c-estado = tt-xml.elementValue.
         WHEN "cidade" THEN
            c-cidade = tt-xml.elementValue.
         WHEN "categoria" THEN
            c-categoria = tt-xml.elementValue.
         WHEN "cod-rep" THEN
            c-cod-rep = tt-xml.elementValue.
         WHEN "count" THEN
            c-count = tt-xml.elementValue.
          WHEN "count" THEN
             c-cod-estabel = tt-xml.elementValue.
      END CASE.
   END.

   /** Ver quais os representantes que devem ser pesquisados **/
   ASSIGN i = NUM-ENTRIES(c-cod-rep, ";").

   IF (i > 0) THEN DO:
      DO j = 1 TO i:
         FIND FIRST repres NO-LOCK
            WHERE repres.cod-rep = INT(ENTRY(j, c-cod-rep, ";")) NO-ERROR.
         IF AVAILABLE (repres) THEN DO:
            CREATE tt-repres.
            ASSIGN tt-repres.cod-rep      = repres.cod-rep
                   tt-repres.no-ab-reppri = repres.nome-abrev.
         END.
      END.
   END.
   ELSE DO:
      /** Se o cara nao tem nenhum representante associado, vai todo mundo **/
      FOR EACH repres FIELDS (cod-rep nome-abrev) NO-LOCK:
         CREATE tt-repres.
         ASSIGN tt-repres.cod-rep      = repres.cod-rep
                tt-repres.no-ab-reppri = repres.nome-abrev.
      END.
   END.

   CREATE QUERY hQuery.

   ASSIGN c-where = "EACH emitente FIELDS (cod-emitente nome-emit cgc bonificacao) NO-LOCK ".

   IF (c-emitente <> ? AND c-emitente > "") THEN DO:
      ASSIGN l-emitente = YES.
      IF (c-busca-por-cliente = "cod") THEN
         ASSIGN c-where = c-where + " WHERE emitente.cod-emitente = " + c-emitente.
      ELSE
         ASSIGN c-where = c-where + " WHERE emitente.nome-emit MATCHES '*" + c-emitente + "*' ".
   END.

   IF (c-estado <> ? AND c-estado > "") THEN DO:
      ASSIGN l-estado = YES.
      IF (l-emitente) THEN
         ASSIGN c-where = c-where + " AND ".
      ELSE
         ASSIGN c-where = c-where + " WHERE ".
      ASSIGN c-where = c-where + " emitente.estado = '" + c-estado + "' ".
   END.

   IF (c-cidade <> ? AND c-cidade > "") THEN DO:
      IF (l-emitente) OR (l-estado) THEN
         ASSIGN c-where = c-where + " AND ".
      ELSE
         ASSIGN c-where = c-where + " WHERE ".
      ASSIGN c-where = c-where + " emitente.cidade MATCHES '*" + c-cidade + "*' ".
   END.

   ASSIGN c-where = c-where + ", FIRST tt-repres NO-LOCK
                           WHERE tt-repres.cod-rep = emitente.cod-rep ".

   IF (c-cod-rep <> ? AND c-cod-rep > "") THEN DO:
      ASSIGN c-where = c-where + " AND tt-repres.cod-rep = " + c-cod-rep.
   END.

   ASSIGN c-where = c-where + ", FIRST gr-cli FIELDS (cod-gr-cli descricao) NO-LOCK
                           WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli ".

   IF (c-categoria <> ? AND c-categoria > "0") THEN DO:
      ASSIGN c-where = c-where + " AND gr-cli.cod-gr-cli = " + c-categoria.
   END.

   ASSIGN c-sort = " BY gr-cli.cod-gr-cli BY emitente.nome-emit ".

   MESSAGE c-where.

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   hQuery:SET-BUFFERS(BUFFER emitente:Handle, BUFFER tt-repres:Handle, BUFFER gr-cli:Handle).

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
      soap-response:CREATE-NODE(rspNode, "m:zoom-pedidos-response", "ELEMENT").
      rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:zoom-emitente-response").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      REPEAT:
         hQuery:GET-NEXT.
         IF (hQuery:QUERY-OFF-END) OR (hQuery:CURRENT-RESULT-ROW - i-count > 100) THEN DO:
            soap-response:CREATE-NODE(hOrdNode, "last-emitente", "ELEMENT").
            rspNode:APPEND-CHILD(hOrdNode).

            hOrdNode:SET-ATTRIBUTE("count",   STRING(i-count)) NO-ERROR.
            hOrdNode:SET-ATTRIBUTE("current", STRING(hQuery:CURRENT-RESULT-ROW - 1)) NO-ERROR.
            LEAVE.
         END.

         /** Desconto de pontualidade **/
         ASSIGN d-perc-desc = 2.

         /********* DOCUMENTOS EM ABERTO MAIS DE 5 DIAS OU ALGUM DOCUMENTO DE VENDOR DEBITADO,
                    O CLIENTE PERDE O DIREITO DE 2% DE DESCONTO DE PONTUALIDADE. ************/
         IF CAN-FIND (FIRST tit_acr NO-LOCK
            WHERE (tit_acr.cod_estab = estabelec.cod-estabel
              AND  tit_acr.cdn_cliente = emitente.cod-emitente
              AND  tit_acr.log_sdo_tit_acr
              AND  tit_acr.log_tit_acr_estordo = NO
              AND  tit_acr.dat_vencto_tit_acr <= TODAY - 6
              AND (tit_acr.cod_cart_bci <> "90"
              AND (tit_acr.cod_portador <> "9996"
              AND  tit_acr.cod_portad <> "9905"
              AND  tit_acr.cod_portad <> "9977"))
              AND (tit_acr.ind_tip_espec_docto = "normal"
               OR  tit_acr.ind_tip_espec_docto = "vendor"))) THEN
            ASSIGN d-perc-desc = 0.

         IF CAN-FIND (FIRST tit_acr NO-LOCK
            WHERE (tit_acr.cod_estab = estabelec.cod-estabel
              AND  tit_acr.cdn_cliente = emitente.cod-emitente
              AND  tit_acr.log_sdo_tit_acr
              AND  tit_acr.log_tit_acr_estordo = NO
              AND  tit_acr.cod_espec_docto = "vd")) THEN
            ASSIGN d-perc-desc = 0.

         /** Desconto de volume **/
         FIND FIRST indice-cgc NO-LOCK
            WHERE indice-cgc.cgc = SUBSTRING(emitente.cgc, 1, 8) NO-ERROR.

         /** Ja que Query nao tem BREAK BY, fazemos do jeito antigo **/
         IF (i-cod-gr-cli <> gr-cli.cod-gr-cli) THEN DO:
            ASSIGN i-cod-gr-cli = gr-cli.cod-gr-cli.

            soap-response:CREATE-NODE(hOrdNode, "gr-cli", "ELEMENT").
            rspNode:APPEND-CHILD(hOrdNode).

            hOrdNode:SET-ATTRIBUTE("gr-cli.cod-gr-cli", STRING(gr-cli.cod-gr-cli)) NO-ERROR.
            hOrdNode:SET-ATTRIBUTE("gr-cli.descricao", gr-cli.descricao) NO-ERROR.
         END.

         soap-response:CREATE-NODE(hEmitNode, "emitente", "ELEMENT").
         hOrdNode:APPEND-CHILD(hEmitNode).

         hEmitNode:SET-ATTRIBUTE("emitente.cod-emitente", STRING(emitente.cod-emitente)) NO-ERROR.

         soap-response:CREATE-NODE(xmlParam, "emitente.nome-emit", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = emitente.nome-emit NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hEmitNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "estabelec.cod-estabel", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = estabelec.cod-estabel NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hEmitNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "emitente.bonificacao", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(emitente.bonificacao) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hEmitNode:APPEND-CHILD(xmlParam).

         soap-response:CREATE-NODE(xmlParam, "desconto-pontualidade", "ELEMENT").
         soap-response:CREATE-NODE(xmlText, ?, "TEXT").
         xmlText:NODE-VALUE = STRING(d-perc-desc) NO-ERROR.
         xmlParam:APPEND-CHILD(xmlText).
         hEmitNode:APPEND-CHILD(xmlParam).

         IF AVAILABLE (indice-cgc) THEN DO:
            soap-response:CREATE-NODE(xmlParam, "indice-cgc.indice", "ELEMENT").
            soap-response:CREATE-NODE(xmlText, ?, "TEXT").
            xmlText:NODE-VALUE = STRING((1 - indice-cgc.indice) * 100) NO-ERROR.
            xmlParam:APPEND-CHILD(xmlText).
            hEmitNode:APPEND-CHILD(xmlParam).
         END. /** IF AVAILABLE **/
      END. /** REPEAT **/
   END. /** ELSE DO **/

   DELETE OBJECT hQuery.
   /* Clean up */
   DELETE OBJECT xmlText.
   DELETE OBJECT xmlParam.
   DELETE OBJECT rspNode.
   DELETE OBJECT happ.

END PROCEDURE.

PROCEDURE process-create-emitente-cartao:
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

   DEFINE VARIABLE c-cod-emitente  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-cod-emitente  AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-nro-cartao    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-nome-pessoa   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-bandeira      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-bandeira      AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-mes-validade  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-mes-validade  AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-ano-validade  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-ano-validade  AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-cod-seguranca AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-cod-seguranca AS INTEGER   NO-UNDO.
   
   DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.
   DEFINE VARIABLE h-esapi014  AS HANDLE NO-UNDO.

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
         WHEN "nro-cartao" THEN
            c-nro-cartao = tt-xml.elementValue.
         WHEN "cod-seguranca" THEN
            c-cod-seguranca = tt-xml.elementValue.
         WHEN "bandeira" THEN
            c-bandeira = tt-xml.elementValue.
         WHEN "nome-pessoa" THEN
            c-nome-pessoa = tt-xml.elementValue.
         WHEN "mes-validade" THEN
            c-mes-validade = tt-xml.elementValue.
         WHEN "ano-validade" THEN
            c-ano-validade = tt-xml.elementValue.
      END CASE.
   END.
   
   IF c-cod-emitente <> '' THEN
      ASSIGN i-cod-emitente = INT(c-cod-emitente).
   IF c-cod-seguranca <> '' THEN
      ASSIGN i-cod-seguranca = INT(c-cod-seguranca).
   IF c-bandeira <> '' THEN
      ASSIGN i-bandeira = INT(c-bandeira).
   IF c-mes-validade <> '' THEN
      ASSIGN i-mes-validade = INT(c-mes-validade).
   IF c-ano-validade <> '' THEN
      ASSIGN i-ano-validade = INT(c-ano-validade).

   soap-response:GET-DOCUMENT-ELEMENT(rspNode).
   RUN getElementsByTagName IN hutil(INPUT rspNode, 'SOAP-ENV:Body', OUTPUT TABLE ttElements).
   FIND FIRST ttElements.

   RUN esapi/esapi014.p PERSISTENT SET h-esapi014.
   
   RUN incluiCartao IN h-esapi014 (INPUT i-cod-emitente, INPUT c-nro-cartao, INPUT i-cod-seguranca,
                                   INPUT i-bandeira, INPUT c-nome-pessoa, INPUT i-mes-validade,
                                   INPUT i-ano-validade, INPUT 1, OUTPUT i-sequencia).

   DELETE OBJECT h-esapi014.
   
   IF (i-sequencia > 0) THEN DO:
      /** Cria o cabecalho de resposta **/
      soap-response:CREATE-NODE(rspNode, "m:create-emitente-cartao-response", "ELEMENT").
      rspNode:SET-ATTRIBUTE("xmlns:m", "urn:x-progress-1.0:create-emitente-cartao-response").
      rspNode:SET-ATTRIBUTE("xmlns:rpc", "http://www.w3.org/2001/09/soap-rpc").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(hOrdNode,"rpc:result","ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = STRING(i-sequencia).
      hOrdNode:APPEND-CHILD(xmlText).
      rspNode:APPEND-CHILD(hOrdNode).
   END.
   ELSE DO:
      soap-response:CREATE-NODE(rspNode, "SOAP-ENV:Fault", "ELEMENT").
      ttElements.nhandle:APPEND-CHILD(rspNode).

      soap-response:CREATE-NODE(xmlParam, "faultcode", "ELEMENT").
      soap-response:CREATE-NODE(xmlText, ?, "TEXT").
      xmlText:NODE-VALUE = "12".
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
