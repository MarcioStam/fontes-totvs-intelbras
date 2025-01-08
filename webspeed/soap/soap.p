&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
  File: soap.p

  Description: This procedure processes SOAP requests for running procedures
  on an AppServer. A SOAP request is an XML payload that is posted via HTTP.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: David Cleary

  Version: 0.1

------------------------------------------------------------------------*/
/*           This .W file was created with the Progress AppBuilder.     */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR hutil AS HANDLE NO-UNDO.
{soap/xmlutil.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.14
         WIDTH              = 48.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* This propcedure contains XML utility routines that we widely use */
RUN soap/xmlutil.p PERSISTENT SET hutil.

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-outputHeader) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputHeader Procedure 
PROCEDURE outputHeader :
/*------------------------------------------------------------------------------
  Purpose:     Output the MIME header, and any "cookie" information needed 
               by this procedure.  
  Parameters:  content-type:CHAR
  Notes:       In the event that this Web object is state-aware, this is
               a good place to set the webState and webTimeout attributes.
------------------------------------------------------------------------------*/
  DEF INPUT PARAM content-type AS CHAR NO-UNDO.
  output-content-type (content-type).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request Procedure 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    DEF VAR soap-request            AS HANDLE NO-UNDO.
    DEF VAR soap-response           AS HANDLE NO-UNDO.
    DEF VAR soap-response-text      AS CHAR NO-UNDO.
    DEF VAR soap-proc-name          AS CHAR NO-UNDO.
    DEF VAR soap-action-header      AS CHAR NO-UNDO.
    DEF VAR soap-application-name   AS CHAR NO-UNDO.
    DEF VAR soap-prefix             AS CHAR NO-UNDO.

    DEF VAR root                    AS HANDLE NO-UNDO.
    DEF VAR aname                   AS CHAR NO-UNDO.
    DEF VAR anames                  AS CHAR NO-UNDO.
    DEF VAR ns-prefix               AS CHAR NO-UNDO.
    DEF VAR ns-uri                  AS CHAR NO-UNDO.
    
    DEF VAR happ                    AS HANDLE NO-UNDO.
    DEF VAR ret                     AS LOGICAL NO-UNDO.
    DEF VAR i                       AS INT NO-UNDO.
    DEF VAR j                       AS INT NO-UNDO.

    DEF VAR found                   AS INTEGER NO-UNDO.

    DEF VAR soap-element            AS HANDLE NO-UNDO.
    DEF VAR soap-header             AS HANDLE NO-UNDO.
    
    /* 
    * First thing we need to check is to confirm we have an XML document
    * posted to this page. This is done by looking at the IS-XML attribute
    * on the WEB-CONTEXT handle. If it is FALSE, we didn't get an XML
    * document, so we want to redirect to an info page.
    */
    
    IF WEB-CONTEXT:IS-XML = FALSE THEN DO:
      /* Placeholder for real input page */
      RUN outputHeader("text/html":U).
    
      {&OUT}
        "<html>":U SKIP
        "<head>":U SKIP
        "<title> WebSpeed SOAP Information Page </title>":U SKIP
        "</head>":U SKIP
        "<body>":U SKIP
        .
      
      {&OUT}
        "<h1>WebSpeed SOAP Server</h1>":U SKIP
        .
    
      {&OUT}
        "</body>":U SKIP
        "</html>":U SKIP
        .
      RETURN.
    END.
    
    /* 
    * Now we need to confirm that this is indeed a SOAP request.
    * We do that by looking for the SOAPMethodName HTTP header. It
    * is called HTTP_SOAPMethodName when using the CGI Messenger.
    * The ISAPI (NSAPI?) Messenger does not report this header.
    */
    soap-action-header = get-cgi("HTTP_SOAPAction").
    IF soap-action-header = ? THEN DO:
    
      /* Placeholder for real input page */
      RUN outputHeader("text/html":U).
    
      {&OUT}
        "<html>":U SKIP
        "<head>":U SKIP
        "<title> WebSpeed SOAP Information Page </title>":U SKIP
        "</head>":U SKIP
        "<body>":U SKIP
        .
      
      {&OUT}
        "<h1>SOAPAction not found!</h1>":U SKIP
        .
    
      {&OUT}
        "</body>":U SKIP
        "</html>":U SKIP
        .
      RETURN.
    END.
    
    /* Evitar que libs malucas enviem aspas no SOAPAction */
    soap-action-header = REPLACE(soap-action-header, '"', '').
    
    /* Now we need to parse the Method Name variable.
     * The method name consists of two parts. The first
     * is the namespace URI of our SOAP application
     * followed by the method name we want to run, separated
     * by a # sign. An example is
     *
     * urn:x-progress-soap-1.0:appservice#procname
     *
     * We use URN syntax for our namespace. The part 
     * x-progress-soap-1.0 signifies it is a Progress SOAP 1.0
     * request. The part appservice specifies an AppServer
     * Application Service name. Finally, procname specifies a
     * Progress Persistent Procedure that is run that does
     * the actual transformation from XML to an actual AppServer
     * call. 
     */
    
    /* Extract our procedure name */
    found = INDEX(soap-action-header, "#").
    IF found = 0 THEN DO:
      RUN return-soap-error.
      RETURN.
    END.
    soap-proc-name = SUBSTRING(soap-action-header, found + 1).
    soap-action-header = SUBSTRING(soap-action-header, 1, found - 1).
    
    /* Extract our wrapper function name */
    found = R-INDEX(soap-action-header, ":").
    IF found = 0 THEN DO:
        RUN return-soap-error.
        RETURN.
    END.
    soap-application-name = SUBSTRING(soap-action-header, found + 1).
    soap-action-header = SUBSTRING(soap-action-header, 1, found - 1).
    
    /* Finally, confirm our SOAP URN prefix */
    IF soap-action-header <> "urn:x-progress-soap-1.0" THEN DO:
        RUN return-soap-error.
        RETURN.
    END.
    
    /* Now we need to hack around the lack of namespace
     * support in this version of the parser. We do this
     * by getting the root element and parsing its attributes.
     */
    soap-request = WEB-CONTEXT:X-DOCUMENT.
    CREATE X-NODEREF root.
    ret = soap-request:GET-DOCUMENT-ELEMENT(root).
    IF ret = FALSE THEN DO:
        RUN return-soap-error.
        DELETE OBJECT root.
        RETURN.
    END.

    /* Loop through our attributes looking for xmlns */
    anames = root:ATTRIBUTE-NAMES.
    REPEAT j = 1 TO NUM-ENTRIES(anames):
        aname = ENTRY(j,anames).
        IF INDEX(aname, "xmlns") = 1 THEN DO:
            found = INDEX(aname, ":").
            IF found > 0 THEN
                ns-prefix = SUBSTRING(aname, found + 1).
            ELSE
                ns-prefix = "".
            ns-uri = root:GET-ATTRIBUTE(aname).
            /* Look for our soap 1.1 URI */
            IF ns-uri = "http://schemas.xmlsoap.org/soap/envelope/" THEN
                soap-prefix = ns-prefix.
        END.
    END.

    /* Make sure this is a valid soap request. soap-prefix will
     * be ? if we didn't find our soap uri.
     */
    IF soap-prefix = ? THEN DO:
        RUN return-soap-error.
        DELETE OBJECT root.
        RETURN.
    END.

    /* Now we need to process any soap headers. We
     * do not support any headers at this time, but
     * we must process any and return an error if they
     * have a mustUnderstand attribute.
     */
    CREATE X-NODEREF soap-element.
    CREATE X-NODEREF soap-header.
    REPEAT i = 1 TO root:NUM-CHILDREN:
        ret = root:GET-CHILD(soap-element, i).
        IF (ret = TRUE) AND (soap-element:SUBTYPE = "element") THEN DO:
            IF soap-element:NAME = soap-prefix + ":Header" THEN DO:
                REPEAT j = 1 TO soap-element:NUM-CHILDREN:
                    ret = soap-element:GET-CHILD(soap-header, j).
                    IF (ret = TRUE) AND (soap-header:SUBTYPE = "element") THEN DO:
                        anames = soap-header:ATTRIBUTE-NAMES.
                        IF LOOKUP(soap-prefix + ":mustUnderstand", anames) > 0 THEN DO:
                            RUN return-soap-error.
                            DELETE OBJECT root.
                            DELETE OBJECT soap-element.
                            DELETE OBJECT soap-header.
                        END.
                    END.
                END.
            END.
            ELSE IF soap-element:NAME = soap-prefix + ":Body" THEN 
                LEAVE.
            ELSE DO:
                /* Soap requires only an optional Header and
                 * the Body element. If anything else is there,
                 * it is an error.
                 */
                RUN return-soap-error.
                DELETE OBJECT root.
                DELETE OBJECT soap-element.
                DELETE OBJECT soap-header.
                RETURN.
            END.
        END.
    END.

    /* If we made it this far, soap-element should have our
     * Body element. If not, something was wrong.
     */
    IF soap-element:NAME <> soap-prefix + ":Body" THEN DO:
        RUN return-soap-error.
        DELETE OBJECT root.
        DELETE OBJECT soap-element.
        DELETE OBJECT soap-header.
        RETURN.
    END.

    session:date-format    = "dmy".
    session:numeric-format = "european".

    /* Fire up our persistent procedure. This needs to be optimized
     * to search for an already running procedure. Also, coming up
     * with a way to run it dynamicxcally would be cool.
     */
    IF soap-proc-name = "soap-b2b-ped-venda.p" THEN DO:
        RUN soap/soap-b2b-ped-venda.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-tit-acr.p" THEN DO:
        RUN soap/soap-b2b-tit-acr.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-devol-cli.p" THEN DO:
        RUN soap/soap-b2b-devol-cli.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-usu-inf.p" THEN DO:
        RUN soap/soap-usu-inf.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-pend-mi.p" THEN DO:
        RUN soap/soap-pend-mi.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-pesquisa.p" THEN DO:
        RUN soap/soap-pesquisa.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-faturamento.p" THEN DO:
        RUN soap/soap-b2b-faturamento.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-nota-fiscal.p" THEN DO:
        RUN soap/soap-b2b-nota-fiscal.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-tabpreco.p" THEN DO:
        RUN soap/soap-b2b-tabpreco.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-emitente.p" THEN DO:
        RUN soap/soap-b2b-emitente.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-cota-rep.p" THEN DO:
        RUN soap/soap-b2b-cota-rep.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-ranking.p" THEN DO:
        RUN soap/soap-b2b-ranking.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-login.p" THEN DO:
        RUN soap/soap-b2b-login.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-lista.p" THEN DO:
        RUN soap/soap-b2b-lista.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-ordem-compra.p" THEN DO:
        RUN soap/soap-b2b-ordem-compra.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-pagamento.p" THEN DO:
        RUN soap/soap-b2b-pagamento.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-pedido-compr.p" THEN DO:
        RUN soap/soap-b2b-pedido-compr.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-pre-nota.p" THEN DO:
        RUN soap/soap-b2b-pre-nota.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-curva-abc.p" THEN DO:
        RUN soap/soap-b2b-curva-abc.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-conta-contab.p" THEN DO:
        RUN soap/soap-b2b-conta-contab.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-item-fabric.p" THEN DO:
        RUN soap/soap-b2b-item-fabric.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-cond-pagto.p" THEN DO:
        RUN soap/soap-b2b-cond-pagto.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-item.p" THEN DO:
        RUN soap/soap-b2b-item.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-form-util.p" THEN DO:
        RUN soap/soap-b2b-form-util.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-os.p" THEN DO:
        RUN soap/soap-b2b-os.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-empresa.p" THEN DO:
        RUN soap/soap-b2b-empresa.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-edi.p" THEN DO:
        RUN soap/soap-edi.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-b2b-cap-giro.p" THEN DO:
        RUN soap/soap-b2b-cap-giro.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    ELSE IF soap-proc-name = "soap-fidelidade.p" THEN DO:
        RUN soap/soap-fidelidade.p PERSISTENT SET happ.
        RUN process-soap-request IN happ (INPUT soap-application-name, INPUT soap-element, OUTPUT soap-response).
    END.
    else if soap-proc-name = "soap-b2b-desconto.p" then do:
        run soap/soap-b2b-desconto.p persistent set happ.
        run process-soap-request in happ (input soap-application-name, input soap-element, output soap-response).
    end.
    else if soap-proc-name = "soap-viagem.p" then do:
        run soap/soap-viagem.p persistent set happ.
        run process-soap-request in happ (input soap-application-name, input soap-element, output soap-response).
    end.


    session:date-format    = "dmy".
    session:numeric-format = "european".
    
    /* The soap-response handle contains our XML output. We write this
     * to the WEBSTREAM.
     */
    RUN outputHeader("text/xml":U).
    soap-response:SAVE("stream", "WEBSTREAM").
    /*soap-response:SAVE("file", "/usr8/progems/fontes/webspeed/response.xml").
    soap-request:SAVE("file", "/usr8/progems/fontes/webspeed/request.xml").*/
    
    /* LOG !! */
    /*OUTPUT TO /usr8/progems/fontes/webspeed/soap.txt.
    PUT UNFORMATTED
       soap-proc-name        SKIP
       soap-response-text    SKIP
       soap-proc-name        SKIP
       soap-action-header    SKIP
       soap-application-name SKIP
       soap-prefix           SKIP.
    OUTPUT CLOSE.*/
    /* END LOG */
    
    /* Clean up now */
    DELETE OBJECT root.
    DELETE OBJECT soap-header.
    DELETE OBJECT soap-element.
    DELETE OBJECT soap-response.
    DELETE PROCEDURE hutil.
    DELETE PROCEDURE happ.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-return-soap-error) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE return-soap-error Procedure 
PROCEDURE return-soap-error :
/*------------------------------------------------------------------------------
  Purpose: Outputs a SOAP Fault    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

      /* Placeholder for real fault processing */
      RUN outputHeader("text/html").

      {&OUT}
        "<html>":U SKIP
        "<head>":U SKIP
        "<title> WebSpeed SOAP Information Page </title>":U SKIP
        "</head>":U SKIP
        "<body>":U SKIP
        .
      
      {&OUT}
        "<h1>SOAPMethodName not found!</h1>":U SKIP
        .

      {&OUT}
        "</body>":U SKIP
        "</html>":U SKIP
        .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

