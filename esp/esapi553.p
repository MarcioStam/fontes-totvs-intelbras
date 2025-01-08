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

DEF VAR cJson               AS LONGCHAR                             NO-UNDO.
    
DEF VAR i-pag               AS i                                    NO-UNDO.
DEF VAR dataPontoEmbarque1  LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataPontoEmbarque2  LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataPontoChegada1   LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataPontoChegada2   LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataRegistroDI      LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataLiberacao       LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataProntidao       LIKE historico-embarque.dt-efetiva      NO-UNDO.
DEF VAR dataEntrada         LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR dataEmissaoNF       LIKE historico-embarque.dt-ult-previsao NO-UNDO.
DEF VAR l-prazo             AS l                                    NO-UNDO.
DEF VAR l-pedido            AS l                                    NO-UNDO.
DEF VAR l-proc              AS l                                    NO-UNDO.
DEF VAR l-inv               AS l                                    NO-UNDO.
DEF VAR cIDItem             AS c                                    NO-UNDO.

DEF VAR de-val-cub-tot      LIKE ordens-embarque.val-cub-tot        NO-UNDO.

define variable oJsonEmbarque    as JsonObject no-undo.
define variable oJsonPedido      as JsonObject no-undo.
define variable oJsonPedidos     as JsonArray  no-undo.
define variable oJsonInvoice     as JsonObject no-undo.
define variable oJsonInvoices    as JsonArray  no-undo.
define variable oJsonItem        as JsonObject no-undo.
define variable oJsonItems       as JsonArray  no-undo.


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

//       MESSAGE " *** 1 ".

       FIND FIRST historico-embarque //NO-LOCK
            WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
              AND historico-embarque.embarque    = embarque-imp.embarque   
            NO-ERROR.
       IF NOT AVAIL historico-embarque
       THEN NEXT.

//       MESSAGE " *** 2 ".

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

//       MESSAGE " *** 3 ".

       ASSIGN
          dataPontoEmbarque1 = ?
          dataPontoEmbarque2 = ?
          dataPontoChegada1  = ?
          dataPontoChegada2  = ?
          dataRegistroDI     = ?
          dataLiberacao      = ?
          dataProntidao      = ?
          dataEntrada        = ?
          dataEmissaoNF      = ?.

       FIND FIRST bf-int-pto-contr-1 NO-LOCK
            WHERE bf-int-pto-contr-1.cod-pto-contr = embarque-imp.cdn-pto-embarq
            NO-ERROR.

       FIND FIRST bf-int-pto-contr-2 NO-LOCK
            WHERE bf-int-pto-contr-2.cod-pto-contr = ext-embarque-imp.cdn-pto-chegada2 
            NO-ERROR.
       IF NOT AVAIL bf-int-pto-contr-2
       THEN FIND FIRST bf-int-pto-contr-2 NO-LOCK
            WHERE bf-int-pto-contr-2.cod-pto-contr = ext-embarque-imp.cdn-pto-chegada1
            NO-ERROR.

       FIND FIRST historico-embarque NO-LOCK
               OF embarque-imp
            WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq
            NO-ERROR.
       IF AVAIL historico-embarque
       THEN ASSIGN
          dataPontoEmbarque1 = historico-embarque.dt-ult-previsao.

//       MESSAGE " *** 4 ".

       FIND FIRST historico-embarque NO-LOCK
               OF embarque-imp
            WHERE historico-embarque.cod-pto-contr = ext-embarque-imp.cdn-pto-embarque2
            NO-ERROR.
       IF AVAIL historico-embarque
       THEN ASSIGN
          dataPontoEmbarque2 = historico-embarque.dt-ult-previsao.
       
       FIND FIRST historico-embarque NO-LOCK
               OF embarque-imp
            WHERE historico-embarque.cod-pto-contr = ext-embarque-imp.cdn-pto-chegada1
            NO-ERROR.
       IF AVAIL historico-embarque
       THEN ASSIGN
          dataPontoChegada1 = historico-embarque.dt-ult-previsao.

       FIND FIRST historico-embarque NO-LOCK
               OF embarque-imp
            WHERE historico-embarque.cod-pto-contr = ext-embarque-imp.cdn-pto-chegada2
            NO-ERROR.
       IF AVAIL historico-embarque
       THEN ASSIGN
          dataPontoChegada2 = historico-embarque.dt-ult-previsao.

       FIND FIRST historico-embarque NO-LOCK
               OF embarque-imp
            WHERE historico-embarque.cod-pto-contr = ext-embarque-imp.cdn-pto-liberacao
            NO-ERROR.
       IF AVAIL historico-embarque
       THEN ASSIGN
          dataLiberacao  = historico-embarque.dt-ult-previsao.

       FIND FIRST historico-embarque NO-LOCK
               OF embarque-imp
            WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar
            NO-ERROR.
       IF AVAIL historico-embarque
       THEN ASSIGN
          dataRegistroDI = historico-embarque.dt-ult-previsao.

//       MESSAGE " *** 5 ".

       FIND FIRST historico-embarque NO-LOCK
               OF embarque-imp
            WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch
            NO-ERROR.
       IF AVAIL historico-embarque
       THEN ASSIGN
          dataProntidao = historico-embarque.dt-efetiva.


       FIND FIRST historico-embarque NO-LOCK
               OF embarque-imp
            WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar
            NO-ERROR.
       IF AVAIL historico-embarque
       THEN ASSIGN
          dataRegistroDI = historico-embarque.dt-ult-previsao.

       FIND FIRST historico-embarque NO-LOCK
               OF embarque-imp
            WHERE historico-embarque.cod-pto-contr = ext-embarque-imp.cdn-pto-emissao-nf
            NO-ERROR.
       IF AVAIL historico-embarque
       THEN ASSIGN
          dataEmissaoNF = historico-embarque.dt-ult-previsao.

       FIND FIRST historico-embarque NO-LOCK
               OF embarque-imp
            WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad 
            NO-ERROR.
       IF AVAIL historico-embarque
       THEN ASSIGN
          dataEntrada = historico-embarque.dt-ult-previsao.

       FIND FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = embarque-imp.cod-despachante NO-ERROR.

       assign oJsonEmbarque = new JsonObject().

       oJsonEmbarque:ADD("numeroEmbarque",embarque-imp.embarque).
       oJsonEmbarque:ADD("codigoTransportadora","").
       oJsonEmbarque:ADD("cnpjEstabelecimento",estabelec.cgc).
       oJsonEmbarque:ADD("codigoAgenteCargas",STRING(embarque-imp.cod-transportador)).
       oJsonEmbarque:ADD("codigoDespachante",STRING(emitente.cgc)).
       oJsonEmbarque:ADD("nomeLocalOrigem",(IF AVAIL bf-int-pto-contr-1 THEN bf-int-pto-contr-1.local-origem-destino-comex ELSE "")).
       oJsonEmbarque:ADD("nomeLocalDestino",(IF AVAIL bf-int-pto-contr-2 THEN bf-int-pto-contr-2.local-origem-destino-comex ELSE "")).
       oJsonEmbarque:ADD("tipoTransporte",ENTRY(embarque-imp.cod-via-transp,"Rodoviario,Aeroviario,Maritimo,Ferroviario,Rodoferroviario,Rodofluvial,Rodoaeroviario,Outros")).
       oJsonEmbarque:ADD("codigoReferenciaEmbarque",embarque-imp.embarque).
       oJsonEmbarque:ADD("tipoContainer",(IF  ext-embarque-imp.conteiner >  0
                                          AND ext-embarque-imp.conteiner <= 6
                                         THEN ENTRY(ext-embarque-imp.conteiner,"Container de 20 pes,Container de 40 pes,Container de 40 e 20 pes,Container NOR 20 pes,Container NOR 40 pes,Container do tipo LCL") 
                                         ELSE "")).

       IF dataPontoEmbarque1 <> ?
            THEN oJsonEmbarque:ADD("dataPontoEmbarque1",fc-data(dataPontoEmbarque1)).

       IF dataPontoEmbarque2 <> ?
            THEN oJsonEmbarque:ADD("dataPontoEmbarque2",fc-data(dataPontoEmbarque2)).
            ELSE oJsonEmbarque:ADD("dataPontoEmbarque2","").

       IF dataPontoChegada1 <> ?
            THEN oJsonEmbarque:ADD("dataPontoChegada1",fc-data(dataPontoChegada1)).

       IF dataPontoChegada2 <> ?
            THEN oJsonEmbarque:ADD("dataPontoChegada2",fc-data(dataPontoChegada2)).
            ELSE oJsonEmbarque:ADD("dataPontoChegada2","").

       IF dataRegistroDI <> ?
            THEN oJsonEmbarque:ADD("dataRegistroDI",fc-data(dataRegistroDI)).

       IF dataLiberacao <> ?
            THEN oJsonEmbarque:ADD("dataLiberacao",fc-data(dataLiberacao)).

       IF dataEntrada <> ?
            THEN oJsonEmbarque:ADD("dataEntrada",fc-data(dataEntrada)).

       IF dataEmissaoNF <> ?
            THEN oJsonEmbarque:ADD("dataEmissaoNF",fc-data(dataEmissaoNF)).

       oJsonPedidos = NEW JsonArray().

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
          IF  cond-pagto.prazos[cond-pagto.num-parcelas] <= 180
          THEN ASSIGN
             i-pag = 1.
          IF  cond-pagto.prazos[cond-pagto.num-parcelas] >  180
          AND cond-pagto.prazos[cond-pagto.num-parcelas] <= 360
          THEN ASSIGN
             i-pag = 2.
          IF  cond-pagto.prazos[cond-pagto.num-parcelas] >  360
          THEN ASSIGN
             i-pag = 3.
          IF  cond-pagto.prazos[cond-pagto.num-parcelas] =  0
          THEN ASSIGN
             i-pag = 4.

          IF  cond-pagto.cod-cond-pag = 63 /* Free of Charge*/
          THEN ASSIGN
             i-pag = 4.


          FIND FIRST mgcad.moeda NO-LOCK
               WHERE mgcad.moeda.mo-codigo = cotacao-item.mo-codigo
               NO-ERROR.
   
          
          IF FIRST-OF(ordem-compra.num-pedido) 
          THEN DO:

             oJsonPedido = NEW JsonObject().
             oJsonPedido:ADD("numeroPedido",REPLACE(REPLACE(STRING(ordem-compra.num-pedido)," ",""),".","")).
             oJsonPedido:ADD("codigoExportador",STRING(pedido-compr.cod-emitente)).
             oJsonPedido:ADD("moeda",STRING(IF AVAIL mgcad.moeda THEN mgcad.moeda.cod-decex ELSE 999)).

             IF dataProntidao <> ?
                THEN oJsonPedido:ADD("dataProntidao",fc-data(dataProntidao)).

             oJsonPedido:ADD("incoterm",CAPS(embarque-imp.cod-incoterm)).

             ASSIGN 
                de-val-cub-tot = 0.
             FOR EACH bf-tot-ordens-embarque NO-LOCK
                WHERE bf-tot-ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                  AND bf-tot-ordens-embarque.embarque    = embarque-imp.embarque,
                FIRST bf-tot-ordem-compra NO-LOCK
                WHERE bf-tot-ordem-compra.numero-ordem   = bf-tot-ordens-embarque.numero-ordem
                  AND bf-tot-ordem-compra.num-pedido     = ordem-compra.num-pedido:
                ASSIGN 
                   de-val-cub-tot = de-val-cub-tot
                                  + bf-tot-ordens-embarque.val-cub-tot.
             END. //for each bf-tot

             oJsonPedido:ADD("cubagem",REPLACE(STRING(bf-ordens-embarque.val-cub-tot),",",".")).

             oJsonInvoices = NEW JsonArray().

             FOR EACH invoice-emb-imp NO-LOCK
                WHERE invoice-emb-imp.cod-estabel  = bf-ordens-embarque.cod-estabel
                  AND invoice-emb-imp.embarque     = bf-ordens-embarque.embarque,
                 EACH pagamento-invoice NO-LOCK
                WHERE pagamento-invoice.embarque   = bf-ordens-embarque.embarque
                  AND pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice:

                 oJsonInvoice = NEW JsonObject().
                 oJsonInvoice:ADD("numero",invoice-emb-imp.nr-invoice).
                 //oJsonInvoice:ADD("valor",REPLACE(STRING(invoice-emb-imp.vl-invoice),",",".")).
                 oJsonInvoice:ADD("valor",invoice-emb-imp.vl-invoice).
                 oJsonInvoice:ADD("acrescimo",0).
                 oJsonInvoices:ADD(oJsonInvoice).


             END. //for each invoice-emb-imp

             oJsonPedido:ADD("Invoices",oJsonInvoices).
             oJsonItems = NEW JsonArray().
                  
          END. //if first-of

          FOR EACH prazo-compra NO-LOCK
                OF ordem-compra
             WHERE prazo-compra.parcela = bf-ordens-embarque.parcela,
             FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = prazo-compra.it-codigo:
              ASSIGN 
                 cIDITem = STRING(embarque-imp.embarque    ) 
                         + "-"
                         + STRING(ordem-compra.num-pedido  )
                         + "-"
                         + STRING(prazo-compra.numero-ordem)
                         + "-"
                         + STRING(prazo-compra.parcela     )
                         + "-"
                         + STRING(prazo-compra.it-codigo   )
                         + "-"
                         + STRING(ordem-compra.cod-emitente).

              oJsonItem = NEW JsonObject().
              oJsonItem:ADD("codigo",prazo-compra.it-codigo).
              oJsonItem:ADD("id",cIDItem).
              /*oJsonItem:ADD("quantidade",REPLACE(STRING(prazo-compra.quantidade),",",".")).
              oJsonItem:ADD("valorUnitario",REPLACE(STRING(ordem-compra.pre-unit-for,">>>>>>>>>9.99999"),",",".")).
              oJsonItem:ADD("pesoLiquido",REPLACE(STRING(prazo-compra.quantidade * ITEM.peso-liquido,">>>>>>>>>9.99999"),",",".")).*/
/*               oJsonItem:ADD("quantidade",prazo-compra.quantidade).      */
/*               oJsonItem:ADD("valorUnitario",ordem-compra.pre-unit-for). */
              oJsonItem:ADD("quantidade",prazo-compra.qtd-do-forn).
              oJsonItem:ADD("valorUnitario",ordem-compra.preco-fornec).
              oJsonItem:ADD("pesoLiquido",prazo-compra.quantidade * ITEM.peso-liquido).
              oJsonItem:ADD("condicaoPagamento",ENTRY(i-pag,"Ate 180 dias,De 181 a 360 dias,Acima de 360 dias,Sem Cobertura")).

              oJsonItems:ADD(oJsonItem).

          END. //for each prazo-compra

          IF LAST-OF(ordem-compra.num-pedido) THEN DO:

              oJsonPedido:ADD("ItensPedido",oJsonItems).
              oJsonPedidos:ADD(oJsonPedido).
          END.
              
       END. //for each bf-ordens-embarque

       oJsonEmbarque:ADD("Pedidos",oJsonPedidos).

       ASSIGN
          l-proc = YES.

    END. //for first embarque-imp

    IF VALID-HANDLE(h-acomp)
    THEN RUN pi-acompanhar IN h-acomp ("Abertura de Processo").

    IF l-proc = NO
    THEN DO:
       IF es-api-log.aux > ""
       THEN DO:
          RUN piErro ("Nao foi encontrado embarque " + es-api-log.aux,"").

          MESSAGE ">> Nao foi encontrado embarque " + es-api-log.aux.
       END.

    END.

    IF l-proc
    THEN DO:

       IF es-api-aplicacao.Testes  = NO
       THEN ASSIGN
          c-endereco          = es-api-URI.ent-PRD.
       ELSE ASSIGN            
          c-endereco          = es-api-URI.end-TST.

       oJsonEmbarque:WRITE(cJson).
   
       ASSIGN 
          cJson = CODEPAGE-CONVERT(cJson, "UTF-8":U).
   
       //Corre‡Æo para erro do tamanho da mensagem
       /*IF LENGTH(cJson) < 32000 THEN
        ASSIGN CLIPBOARD:VALUE = STRING(cJson) NO-ERROR.*/
   
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

