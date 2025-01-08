&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{esp/esapi505.i}
{include/i-freeac.i}

DEF INPUT PARAM h-acomp     AS HANDLE NO-UNDO.    
DEF INPUT PARAM i-acao      AS i      NO-UNDO.
DEF INPUT PARAM rw-registro AS ROWID  NO-UNDO.


DEF VAR httCust      AS HANDLE   NO-UNDO.
DEF VAR lReturnValue AS LOGICAL  NO-UNDO.

DEF NEW GLOBAL SHARED VAR l-esapi553 AS l NO-UNDO.

DEF TEMP-TABLE tt-historico-embarque NO-UNDO
          LIKE historico-embarque.
                               
DEF BUFFER bf-int-pto-contr-1      FOR int-pto-contr.
DEF BUFFER bf-int-pto-contr-2      FOR int-pto-contr.
DEF BUFFER bf-ordens-embarque      FOR ordens-embarque.
DEF BUFFER bf-tot-ordens-embarque  FOR ordens-embarque.
DEF BUFFER bf-tot-ordem-compra     FOR ordem-compra.

DEF BUFFER bf-ext-embarque-imp     FOR ext-embarque-imp.

DEF VAR cJson                AS LONGCHAR NO-UNDO.
    
DEF VAR i-pag                AS i        NO-UNDO.
DEF VAR codigoTransportadora AS c        NO-UNDO.
DEF VAR aliquotaICMS         AS c        NO-UNDO.
DEF VAR l-prazo              AS l        NO-UNDO.
DEF VAR l-pedido             AS l        NO-UNDO.
DEF VAR l-proc               AS l        NO-UNDO.
DEF VAR l-invoice            AS l        NO-UNDO.

{esp/esapi505x.i &OPC="OPEN"}

IF i-acao = 0
THEN DO:
   l-esapi553 = NO.
   {esp/esapi505x.i &OPC="CLOSE"}
   RETURN "OK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fc-campo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fc-campo Procedure 
FUNCTION fc-campo RETURNS CHARACTER
  ( c AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fc-data) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fc-data Procedure 
FUNCTION fc-data RETURNS CHARACTER
  ( d AS DATE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 11
         WIDTH              = 41.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    
FOR FIRST es-api-log
    WHERE ROWID(es-api-log) = rw-registro,
    FIRST es-api-URI       NO-LOCK
       OF es-api-log,
    FIRST es-api-empresa   NO-LOCK
       OF es-api-log,
    FIRST es-api-aplicacao NO-LOCK
       OF es-api-log
       BY es-api-log.flg-processado
       BY es-api-log.dh-request:
    ASSIGN
       es-api-log.dh-envio       = NOW
       es-api-log.flg-processado = YES.
    //MESSAGE 2 l-esapi505a VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l1 . IF l1 = NO THEN STOP.
    FOR FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = ENTRY(1,es-api-log.aux)
          AND embarque-imp.embarque    = ENTRY(2,es-api-log.aux),
        FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = embarque-imp.cod-estabel,
        FIRST ordens-embarque NO-LOCK
           OF embarque-imp,
        FIRST processo-imp NO-LOCK
           OF ordens-embarque, 
        FIRST ext-embarque-imp NO-LOCK
        WHERE ext-embarque-imp.cod-estabel       = embarque-imp.cod-estabel
          AND ext-embarque-imp.embarque          = embarque-imp.embarque
//          AND ext-embarque-imp.log-envio-comex   = NO
        :

       FIND FIRST historico-embarque //NO-LOCK
            WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
              AND historico-embarque.embarque    = embarque-imp.embarque   
            NO-ERROR.
       IF NOT AVAIL historico-embarque
       THEN NEXT.

       FIND FIRST itinerario NO-LOCK
            WHERE itinerario.cod-itiner     = historico-embarque.cod-itiner
            NO-ERROR.
       FIND FIRST int-itinerario NO-LOCK
            WHERE int-itinerario.cod-itiner = historico-embarque.cod-itiner
            NO-ERROR.
       IF NOT AVAIL int-itinerario
       THEN NEXT.
       IF int-itinerario.log-integra-comex = NO
       THEN NEXT.

/*
       ASSIGN
          codigoTransportadora = "".

       IF embarque-imp.cod-transportador = 5145
       THEN ASSIGN
          codigoTransportadora = "DHL WORLD".
       IF embarque-imp.cod-transportador = 73884
       THEN ASSIGN
          codigoTransportadora = "DHL".
       IF embarque-imp.cod-transportador = 5055
       THEN ASSIGN
          codigoTransportadora = "FEDEX".
*/          

       ASSIGN
          codigoTransportadora = STRING(embarque-imp.cod-transportador).


       FOR EACH bf-ordens-embarque NO-LOCK
          WHERE bf-ordens-embarque.cod-estabel = embarque-imp.cod-estabel
            AND bf-ordens-embarque.embarque    = embarque-imp.embarque,
          FIRST ordem-compra NO-LOCK
          WHERE ordem-compra.numero-ordem = bf-ordens-embarque.numero-ordem,
          FIRST pedido-compr NO-LOCK
             OF ordem-compra,
          FIRST cotacao-item NO-LOCK
          WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
            AND cotacao-item.cod-emitente = pedido-compr.cod-emitente,
          FIRST cond-pagto NO-LOCK
          WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag
          BREAK BY bf-ordens-embarque.cod-estabel
                BY bf-ordens-embarque.embarque
                BY ordem-compra.num-pedido
                BY ordem-compra.numero-ordem:
          FIND FIRST mgcad.moeda NO-LOCK
               WHERE mgcad.moeda.mo-codigo = cotacao-item.mo-codigo
               NO-ERROR.

          FIND FIRST invoice-emb-imp NO-LOCK
               WHERE invoice-emb-imp.cod-estabel = bf-ordens-embarque.cod-estabel
                 AND invoice-emb-imp.embarque    = bf-ordens-embarque.embarque   
              NO-ERROR.
          
          IF FIRST(ordem-compra.num-pedido) 
          THEN DO:
             ASSIGN
                aliquotaICMS = "".
             IF embarque-imp.cod-estabel = "101"
             THEN aliquotaICMS = "17.00".
             IF embarque-imp.cod-estabel = "103"
             THEN aliquotaICMS = "18.00".
             IF embarque-imp.cod-estabel = "104"
             THEN aliquotaICMS = "17.00".
             IF embarque-imp.cod-estabel = "105"
             THEN aliquotaICMS = "18.00".
             IF embarque-imp.cod-estabel = "110"
             THEN aliquotaICMS = "18.00".

             ASSIGN
                cJson = '~{'
                      +     '"numeroEmbarque":"'           + embarque-imp.embarque + '",'
                      +     '"codigoTransportadora":"'     + codigoTransportadora + '",'
                      +     '"codigoExportador":"'         + STRING(pedido-compr.cod-emitente) + '",'
                      +     '"cnpjEstabelecimento":"'      + estabelec.cgc +  '",'
                      +     '"tipoTransporte":"'           + 'Aeroviario",'
                      +     '"finalidade":"'               + ENTRY(ext-embarque-imp.finalidade-currier + 1 ,",amostra,industrializacao,documento") + '",'
                      +     '"tipoFrete":"'                + '",'
                      +     '"tracking":"'                 + embarque-imp.cod-conhecto-master + '",'
                      +     '"moeda":"'                    + STRING(IF AVAIL mgcad.moeda THEN mgcad.moeda.cod-decex ELSE 999) + '",'
                      +     '"aliquotaICMS":'              + aliquotaICMS + ','    
                      .
             ASSIGN
                cJson = cJson
                      + '"ItensPedido":['
                      .
             ASSIGN
                l-prazo =  NO.
          END.

          

          FOR EACH prazo-compra NO-LOCK
                OF ordem-compra
             WHERE prazo-compra.parcela = bf-ordens-embarque.parcela,
             FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = prazo-compra.it-codigo:
             IF l-prazo = YES
             THEN ASSIGN
                cJson = cJson + ", ".
             ASSIGN
                cJson = cJson
                      + '~{'
                      + '"codigo":"'             + prazo-compra.it-codigo + '",'
                      + '"descricao":"'          + fc-campo(ITEM.desc-item) + '",'
/*                 + '"quantidade":'          + REPLACE(STRING(prazo-compra.quantidade),",",".") + ','                      */
/*                 + '"valorUnitario":'       + REPLACE(STRING(ordem-compra.pre-unit-for,">>>>>>>>>9.99999"),",",".") + ',' */
                   + '"quantidade":'          + REPLACE(STRING(prazo-compra.qtd-do-forn,">>>>>>9.99999"),",",".") + ','
                   + '"valorUnitario":'       + REPLACE(STRING(ordem-compra.preco-fornec,">>>>>>>>>9.99999"),",",".") + ','
                      + '}'
                      .
             ASSIGN
                l-prazo = YES.
          END.
          
       END.

       ASSIGN
          cJson = cJson
                +  '] '.

       ASSIGN
          l-invoice = NO.
       FOR  EACH invoice-emb-imp NO-LOCK
           WHERE invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel
             AND invoice-emb-imp.embarque    = embarque-imp.embarque:
          IF l-invoice = NO
          THEN ASSIGN
             cJson = cJson
                   + ', "Invoices":['
                   .
          ELSE ASSIGN
             cJson = cJson
                   + ', '
                   .
          ASSIGN
              cJson = cJson
                    + '~{'
                    + '"numero":"'    + invoice-emb-imp.nr-invoice + '",'
                    + '"acrescimo":"' + '0' + '",'
                    + '"valor":'      + REPLACE(STRING(invoice-emb-imp.vl-invoice,">>>>>>>>>9.99"),",",".") 
                    + '}'
                    .
          ASSIGN
             l-invoice = YES.
       END.

       IF l-invoice = YES
       THEN ASSIGN
          cJson = cJson
                +     ']'.
       ELSE ASSIGN
          cJson = cJson
                + ', "Invoices": [] '.

       ASSIGN
          cJson = cJson
//                +     ']'
                +  '}'.

       ASSIGN
          l-proc = YES.
    END.

    IF VALID-HANDLE(h-acomp)
    THEN RUN pi-acompanhar IN h-acomp ("Abertura de Processo").

    IF l-proc = NO
    THEN DO:
       IF es-api-log.aux > ""
       THEN DO:
          RUN piErro ("Nao foi encontrado embarque " + es-api-log.aux,"").
       END.

    END.

    IF l-proc
    THEN DO:

       IF es-api-aplicacao.Testes  = NO
       THEN ASSIGN
          c-endereco          = es-api-URI.ent-PRD.
       ELSE ASSIGN            
          c-endereco          = es-api-URI.end-TST.
   
       ASSIGN 
          cJson = CODEPAGE-CONVERT(cJson, "UTF-8":U).
   
       CLIPBOARD:VALUE = STRING(cJson).
   
       ASSIGN 
          es-api-log.cJSON = cJson.
   
       fc-chamada-1().

       IF es-api-log.cod-retorno BEGINS "2" 
       THEN DO:

          FIND FIRST bf-ext-embarque-imp
               WHERE ROWID(bf-ext-embarque-imp) = ROWID(ext-embarque-imp)
               NO-ERROR.
          ASSIGN
             bf-ext-embarque-imp.log-enviado-comex = YES.
          RELEASE bf-ext-embarque-imp.
       END.

    END.

    RELEASE es-api-log.
END.

{esp/esapi505x.i &OPC="CLOSE"}

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fc-campo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fc-campo Procedure 
FUNCTION fc-campo RETURNS CHARACTER
  ( c AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEF VAR i AS i NO-UNDO.
   ASSIGN
      c = REPLACE(c,'"','')
      c = REPLACE(c,':','')
      c = REPLACE(c,',','')
      c = REPLACE(c,'\','')
      c = TRIM(c)
      c = REPLACE(c,CHR(13),' ')
      c = REPLACE(c,CHR(10),' ')
      c = fn-free-accent(c)
      .

   DO i = 1 TO LENGTH(c):
      IF ASC(SUBSTR(c,i,1)) < 32
      OR ASC(SUBSTR(c,i,1)) > 127 
      THEN SUBSTR(c,i,1) = "".
   END.

   RETURN c.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fc-data) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fc-data Procedure 
FUNCTION fc-data RETURNS CHARACTER
  ( d AS DATE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR c AS c NO-UNDO.

  IF d <> ?
  THEN ASSIGN
     c = STRING( YEAR(d),"9999")
       + "-"
       + STRING(MONTH(d),"99")
       + "-"
       + STRING(  DAY(d),"99")
       .

  RETURN c.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

