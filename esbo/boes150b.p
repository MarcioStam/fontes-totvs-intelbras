DEFINE TEMP-TABLE tt-xml NO-UNDO
   FIELD elementName  AS CHARACTER
   FIELD elementValue AS CHARACTER
   FIELD elementNS    AS CHARACTER.

PROCEDURE ValidaCartaoIntelbras:
DEF INPUT PARAMETER i-seq-wt-docto     AS INTEGER.
DEF INPUT PARAMETER de-valor-transacao AS DECIMAL.
DEF INPUT PARAMETER c-tipo-transacao   AS CHAR.
DEF INPUT PARAMETER c-parcelas         AS INTEGER.
DEF INPUT PARAMETER c-filiacao         AS CHAR.
DEF INPUT PARAMETER c-pedido           AS CHAR.
DEF INPUT PARAMETER c-cartao           AS CHAR.
DEF INPUT PARAMETER c-codigo-seguranca AS CHAR.
DEF INPUT PARAMETER c-mes-validade     AS INTEGER FORMAT "99".
DEF INPUT PARAMETER c-ano-validade     AS INTEGER FORMAT "99".
DEF INPUT PARAMETER c-nome-portador    AS CHAR.
DEF INPUT PARAMETER c-iata             AS CHAR INITIAL "".
DEF INPUT PARAMETER c-distribuidor     AS CHAR.
DEF INPUT PARAMETER c-concentrador     AS CHAR INITIAL "".
DEF INPUT PARAMETER c-taxa-embarque    AS CHAR INITIAL "".
DEF INPUT PARAMETER c-entrada          AS CHAR INITIAL "".
DEF INPUT PARAMETER c-num-doc-1        AS CHAR INITIAL "".
DEF INPUT PARAMETER c-num-doc-2        AS CHAR INITIAL "".
DEF INPUT PARAMETER c-num-doc-3        AS CHAR INITIAL "".
DEF INPUT PARAMETER c-num-doc-4        AS CHAR INITIAL "".
DEF INPUT PARAMETER c-pax-1            AS CHAR INITIAL "".
DEF INPUT PARAMETER c-pax-2            AS CHAR INITIAL "".
DEF INPUT PARAMETER c-pax-3            AS CHAR INITIAL "".
DEF INPUT PARAMETER c-pax-4            AS CHAR INITIAL "".
DEF INPUT PARAMETER c-conftxn          AS CHAR INITIAL "S".

DEF OUTPUT PARAMETER c-retorno    AS CHARACTER.
DEF OUTPUT PARAMETER c-mensagem   AS CHARACTER.



DEFINE VARIABLE hWebService AS HANDLE.
DEFINE VARIABLE hPortType   AS HANDLE.
DEFINE VARIABLE de-origem      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE de-destino   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE i AS INTEGER     NO-UNDO.
DEFINE VARIABLE j AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-flag       AS LOGICAL     NO-UNDO FORMAT "Celsius/Fahrenheit".

/**********************/
CREATE SERVER hWebService.
hWebService:CONNECT("-WSDL 'http://ecenter.intelbras.com.br/outcommerce/redecard.wsdl' "
                    + " -Service 'komerci_capture' -Port 'komerci_captureSoap' ").

IF  NOT hWebService:CONNECTED() THEN DO:
    ASSIGN c-retorno  = ""
           c-mensagem = "SERVER NOT CONNECTED".
    
    RETURN.
END.

RUN komerci_captureSoap SET hPortType ON SERVER hWebService NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    ASSIGN c-retorno  = ""
           c-mensagem = "Failed to create hPortType".
    
    RETURN.
END.

/**********************/
    
DEFINE VARIABLE out_saida AS LONGCHAR NO-UNDO.


RUN getAuthorized IN hPortType(INPUT REPLACE(STRING(de-valor-transacao,">>>>>>>>>>9.99"),",","."),
                               INPUT c-tipo-transacao,  
                               INPUT string(c-parcelas,"99"),        
                               INPUT c-filiacao,        
                               INPUT c-pedido,          
                               INPUT c-cartao,          
                               INPUT c-codigo-seguranca,
                               INPUT string(c-mes-validade,"99"),    
                               INPUT string(c-ano-validade - 2000,"99"),    
                               INPUT c-nome-portador,   
                               INPUT c-iata,            
                               INPUT c-distribuidor,    
                               INPUT c-concentrador,    
                               INPUT c-taxa-embarque,   
                               INPUT c-entrada,         
                               INPUT c-pax-1,           
                               INPUT c-pax-2,           
                               INPUT c-pax-3,           
                               INPUT c-pax-4,           
                               INPUT c-num-doc-1,       
                               INPUT c-num-doc-2,       
                               INPUT c-num-doc-3,       
                               INPUT c-num-doc-4,       
                               INPUT c-conftxn,
                               INPUT "", 
                               OUTPUT out_saida) NO-ERROR.

/* MESSAGE "de-valor-transacao "      REPLACE(STRING(de-valor-transacao,">>>>>>>>>>9.99"),",",".") skip */
/*         "c-tipo-transacao"        c-tipo-transacao skip                                              */
/*         "c-parcelas"              string(c-parcelas,"99") skip                                       */
/*         "c-filiacao"              c-filiacao skip                                                    */
/*         "c-pedido"                c-pedido skip                                                      */
/*         "c-cartao"                c-cartao skip                                                      */
/*         "c-codigo-seguranca"      c-codigo-seguranca skip                                            */
/*         "c-mes-validade"          string(c-mes-validade,"99") skip                                   */
/*         "c-ano-validade"          string(c-ano-validade,"99") skip                                   */
/*         "c-nome-portador"         c-nome-portador skip                                               */
/*         "c-iata"                  c-iata skip                                                        */
/*         "c-distribuidor"          c-distribuidor skip                                                */
/*         "c-concentrador"          c-concentrador skip                                                */
/*         "c-taxa-embarque"         c-taxa-embarque skip                                               */
/*         "c-entrada"               c-entrada skip                                                     */
/*         "c-num-doc-1"             c-num-doc-1 skip                                                   */
/*         "c-num-doc-2"             c-num-doc-2 skip                                                   */
/*         "c-num-doc-3"             c-num-doc-3 skip                                                   */
/*         "c-num-doc-4"             c-num-doc-4 skip                                                   */
/*         "c-pax-1"                 c-pax-1 skip                                                       */
/*         "c-pax-2"                 c-pax-2 skip                                                       */
/*         "c-pax-3"                 c-pax-3 skip                                                       */
/*         "c-pax-4"                 c-pax-4 skip                                                       */
/*         "c-conftxn"               c-conftxn   SKIP                                                   */
/*         "c-adddata"              VIEW-AS ALERT-BOX INFO BUTTONS OK.                                  */

IF ERROR-STATUS:ERROR THEN DO:
    ASSIGN c-retorno  = ""
           c-mensagem = ERROR-STATUS:GET-MESSAGE(1).
        
    RETURN.
END.

/** Variaveis para o SAX **/
DEFINE VARIABLE hParser  AS HANDLE.
DEFINE VARIABLE hHandler AS HANDLE.

CREATE SAX-READER hParser.

/** Procedures de callback para o SAX **/
RUN esinc/soap-xml.p PERSISTENT SET hHandler.

hParser:HANDLER = hHandler.
hParser:SET-INPUT-SOURCE("LONGCHAR", out_saida).
hParser:SAX-PARSE() NO-ERROR.

RUN retorna-tt IN hHandler (OUTPUT TABLE tt-xml).
RUN Cleanup    IN hHandler.

/** Apaga da memoria o objeto e procedure do SAX **/
DELETE OBJECT hParser.
DELETE PROCEDURE hHandler.
FOR first tt-xml NO-LOCK
    where  tt-xml.elementName = "CODRET"
      AND  int(tt-xml.elementValue) = 00 : 
END.


IF AVAIL tt-xml THEN DO:
    CREATE retorno-cartao-cred.
    ASSIGN retorno-cartao-cred.seq-wt-docto = i-seq-wt-docto.
    
    FOR EACH tt-xml NO-LOCK:
        CASE  tt-xml.elementName: 
           WHEN "CODRET"     THEN ASSIGN retorno-cartao-cred.cod-retorno         = tt-xml.elementValue
                                         c-retorno                               = "00".
           WHEN "MSGRET"     THEN ASSIGN retorno-cartao-cred.msg-retorno         = tt-xml.elementValue
                                         c-mensagem                              = tt-xml.elementValue.
           WHEN "NUMPEDIDO"  THEN ASSIGN retorno-cartao-cred.num-pedido          = tt-xml.elementValue.
           WHEN "DATA"       THEN ASSIGN retorno-cartao-cred.dt-transacao        = TODAY.
           WHEN "NUMAUTOR"   THEN ASSIGN retorno-cartao-cred.num-autorizacao     = tt-xml.elementValue.
           WHEN "NUMCV"      THEN ASSIGN retorno-cartao-cred.num-comprovante     = tt-xml.elementValue.
           WHEN "NUMAUTENT"  THEN ASSIGN retorno-cartao-cred.num-autentic        = tt-xml.elementValue.
           WHEN "NUMSQN"     THEN ASSIGN retorno-cartao-cred.num-sqn             = tt-xml.elementValue.
           WHEN "CONFCODRET" THEN ASSIGN retorno-cartao-cred.cod-retorn-conf-aut = tt-xml.elementValue.
           WHEN "CONFMSGRET" THEN ASSIGN retorno-cartao-cred.desc-cod-ret        = tt-xml.elementValue.
    
        END CASE.
    
    END.
END.
ELSE DO:
    FOR first tt-xml NO-LOCK
        where  tt-xml.elementName = "CODRET"
          AND  int(tt-xml.elementValue) > 0 : 
        ASSIGN c-retorno  = tt-xml.elementValue.
    END.
    FOR first tt-xml NO-LOCK
        where  tt-xml.elementName = "MSGRET": 
        ASSIGN c-mensagem  = tt-xml.elementValue.
    END.

END.

DELETE PROCEDURE hPortType.
hWebService:DISCONNECT(). 
DELETE OBJECT hWebService.
END PROCEDURE.
