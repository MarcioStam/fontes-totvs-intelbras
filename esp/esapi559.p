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

DEF INPUT PARAM h-acomp     AS HANDLE NO-UNDO.    
DEF INPUT PARAM i-acao      AS i      NO-UNDO.
DEF INPUT PARAM rw-registro AS ROWID  NO-UNDO.


DEF VAR httCust      AS HANDLE   NO-UNDO.
DEF VAR lReturnValue AS LOGICAL  NO-UNDO.

DEF NEW GLOBAL SHARED VAR l-esapi553 AS l NO-UNDO.

DEF TEMP-TABLE tt-historico-embarque NO-UNDO
          LIKE historico-embarque.
                               
DEF BUFFER bf-ordens-embarque     FOR ordens-embarque.
DEF BUFFER bf-ext-embarque-imp    FOR ext-embarque-imp.
DEF BUFFER bf-tot-ordens-embarque FOR ordens-embarque.
DEF BUFFER bf-tot-ordem-compra    FOR ordem-compra.

DEF VAR cJson               AS LONGCHAR                             NO-UNDO.
    
DEF VAR i-pag               AS i                                    NO-UNDO.
DEF VAR dataProntidao       LIKE historico-embarque.dt-efetiva      NO-UNDO.
DEF VAR l-prazo             AS l                                    NO-UNDO.
DEF VAR l-pedido            AS l                                    NO-UNDO.
DEF VAR l-proc              AS l                                    NO-UNDO.
def var l-er-via-trans      as logi                                 no-undo.
DEF VAR cIDItem             AS c                                    NO-UNDO.

DEF VAR de-val-cub-tot      LIKE ordens-embarque.val-cub-tot        NO-UNDO.

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

    MESSAGE ">>> " es-api-log.aux.

    /*
    FOR FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = ENTRY(1,es-api-log.aux)
          AND embarque-imp.embarque    = ENTRY(2,es-api-log.aux),
        FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = embarque-imp.cod-estabel,
        FIRST ordens-embarque NO-LOCK
           OF embarque-imp
        WHERE ordens-embarque.numero-ordem = INT(ENTRY(3,es-api-log.aux))
          AND ordens-embarque.parcela      = INT(ENTRY(4,es-api-log.aux)),
        FIRST ext-embarque-imp NO-LOCK
        WHERE ext-embarque-imp.cod-estabel       = embarque-imp.cod-estabel
          AND ext-embarque-imp.embarque          = embarque-imp.embarque
          AND ext-embarque-imp.log-envio-comex   = YES
        :
    */
    FOR FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = ENTRY(1,es-api-log.aux)
          AND embarque-imp.embarque    = ENTRY(2,es-api-log.aux),
        FIRST ordens-embarque NO-LOCK
           OF embarque-imp
        WHERE ordens-embarque.numero-ordem = INT(ENTRY(3,es-api-log.aux))
          AND ordens-embarque.parcela      = INT(ENTRY(4,es-api-log.aux)),
        FIRST ordem-compra NO-LOCK
        WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem,
        FIRST pedido-compr NO-LOCK
           OF ordem-compra,
        FIRST cond-pagto NO-LOCK
        WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag,
        FIRST ext-embarque-imp NO-LOCK
        WHERE ext-embarque-imp.cod-estabel       = embarque-imp.cod-estabel
          AND ext-embarque-imp.embarque          = embarque-imp.embarque
          AND ext-embarque-imp.log-envio-comex   = YES
        :

       if  embarque-imp.cod-via-transp > 1
       and embarque-imp.cod-via-transp < 4
       then.
       else do:
            assign l-er-via-trans = yes.
            next.
       end.

       MESSAGE " *** 1 ".

       FIND FIRST historico-embarque //NO-LOCK
            WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
              AND historico-embarque.embarque    = embarque-imp.embarque   
            NO-ERROR.
       IF NOT AVAIL historico-embarque
       THEN NEXT.

       MESSAGE " *** 2 ".

       FIND FIRST itinerario NO-LOCK
            WHERE itinerario.cod-itiner     = historico-embarque.cod-itiner
            NO-ERROR.
       FIND FIRST int-itinerario NO-LOCK
            WHERE int-itinerario.cod-itiner = historico-embarque.cod-itiner
            NO-ERROR.
       IF NOT AVAIL int-itinerario
       THEN NEXT.

       MESSAGE " *** 3 ".

       ASSIGN
          dataProntidao      = ?
          .

       MESSAGE " *** 5 ".

       FIND FIRST historico-embarque NO-LOCK
               OF embarque-imp
            WHERE historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch
            NO-ERROR.
       IF AVAIL historico-embarque
       THEN ASSIGN
          dataProntidao = historico-embarque.dt-ult-previsao.


       /*
       FOR EACH bf-ordens-embarque NO-LOCK
          WHERE bf-ordens-embarque.cod-estabel = embarque-imp.cod-estabel
            AND bf-ordens-embarque.embarque    = embarque-imp.embarque
            AND bf-ordens-embarque.parcela     = ordens-embarque.parcela,
          FIRST ordem-compra NO-LOCK
          WHERE ordem-compra.numero-ordem = bf-ordens-embarque.numero-ordem,
          FIRST pedido-compr NO-LOCK
             OF ordem-compra,
          FIRST cond-pagto NO-LOCK
          WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag
          BREAK BY bf-ordens-embarque.cod-estabel
                BY bf-ordens-embarque.embarque
                BY ordem-compra.num-pedido
                BY ordem-compra.numero-ordem:
                */
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

          FIND FIRST mgcad.moeda NO-LOCK
               WHERE mgcad.moeda.mo-codigo = ordem-compra.mo-codigo //pedido-compr.i-moeda
               NO-ERROR.

          FIND FIRST invoice-emb-imp NO-LOCK
               WHERE invoice-emb-imp.cod-estabel = ordens-embarque.cod-estabel
                 AND invoice-emb-imp.embarque    = ordens-embarque.embarque   
              NO-ERROR.
/*
          IF l-pedido = YES
          THEN ASSIGN
             cJson = cJson
                + ",".

          ASSIGN
             l-pedido = YES.
*/
          
          
          /*IF FIRST-OF(ordem-compra.num-pedido) 
          THEN*/ DO:

              ASSIGN
                 cJson = '~{'
                   +     '"numeroEmbarque":"'           + embarque-imp.embarque + '",'
                   +     '"numeroPedido":"'     + REPLACE(REPLACE(STRING(ordem-compra.num-pedido),".","")," ","") + '",'
                   +     '"codigoExportador":"' + STRING(pedido-compr.cod-emitente) + '",'
                   +     '"moeda":"'             + STRING(IF AVAIL mgcad.moeda THEN mgcad.moeda.cod-decex ELSE 999) + '",'.
             IF dataProntidao <> ?
             THEN ASSIGN
                cJson = cJson
                   +     '"dataProntidao":"'            + fc-data(dataProntidao     ) + '",'.

             FOR EACH bf-tot-ordens-embarque NO-LOCK
                WHERE bf-tot-ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                  AND bf-tot-ordens-embarque.embarque    = embarque-imp.embarque,
                FIRST bf-tot-ordem-compra NO-LOCK
                WHERE bf-tot-ordem-compra.numero-ordem   = bf-tot-ordens-embarque.numero-ordem
                  AND bf-tot-ordem-compra.num-pedido     = ordem-compra.num-pedido:
                ASSIGN 
                   de-val-cub-tot = de-val-cub-tot
                                  + bf-tot-ordens-embarque.val-cub-tot.
             END.
   
             ASSIGN
                cJson = cJson
                   +           '"incoterm":"'         + CAPS(embarque-imp.cod-incoterm) + '",'
                   +           '"numeroInvoice":"'    + (IF AVAIL invoice-emb-imp 
                                                         THEN invoice-emb-imp.nr-invoice
                                                         ELSE "") + '",'
                   +           '"cubagem":"'           + REPLACE(STRING(ordens-embarque.val-cub-tot),",",".") + '",'
                   +           '"Itens":['
                  .

          END.

          ASSIGN
             l-prazo =  NO.

          FOR EACH prazo-compra NO-LOCK
                OF ordem-compra
             WHERE prazo-compra.parcela = ordens-embarque.parcela:
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
                         + STRING(ordem-compra.cod-emitente)
                         .

             IF l-prazo = YES
             THEN ASSIGN
                cJson = cJson + ", ".
             ASSIGN
                cJson = cJson
                      + '~{'
                      + '"codigoProduto":"'      + prazo-compra.it-codigo + '",'
                      + '"id":"'                 + cIDItem + '",'
/*                       + '"quantidade":'          + REPLACE(STRING(prazo-compra.quantidade),",",".") + ','                      */
/*                       + '"valorUnitario":'       + REPLACE(STRING(ordem-compra.pre-unit-for,">>>>>>>>>9.99999"),",",".") + ',' */
                      + '"quantidade":'          + REPLACE(STRING(prazo-compra.qtd-do-forn,">>>>>>9.99999"),",",".") + ','
                      + '"valorUnitario":'       + REPLACE(STRING(ordem-compra.preco-fornec,">>>>>>>>>9.99999"),",",".") + ','
                      + '"pesoLiquido":'         + REPLACE(STRING(ordens-embarque.peso-liquido,">>>>>>>>>9.99999"),",",".") + ','
                      + '"condicaoPagamento":"'  + ENTRY(i-pag,"Ate 180 dias,De 181 ate 360 dias,Acima de 360 dias, Nenhum") + '"'
                      + '}'
                      .
                      //+ '"mercadoriaParcelada":' + STRING(cond-pagto.num-parcelas > 1,"true/false") + ','
                      //+ '"quantidadeParcelas":'  + STRING(cond-pagto.num-parcelas)

             ASSIGN
                l-prazo = YES.
          END.

          /*IF LAST-OF(ordem-compra.num-pedido) 
          THEN*/ ASSIGN
             cJson = cJson
                   +    ']'
                   + '}'.
          /*ELSE ASSIGN
             cJson = cJson 
                   + ",".*/
//       END.

       ASSIGN
          l-proc = YES.

    END.

    IF VALID-HANDLE(h-acomp)
    THEN RUN pi-acompanhar IN h-acomp ("Cadastro de pedido").

    IF l-proc = NO
    THEN DO:
       IF es-api-log.aux > ""
       and not l-er-via-trans
       then RUN piErro ("Nao foi encontrado embarque " + es-api-log.aux,"").
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

       MESSAGE ">> " STRING(cJson).
   
       ASSIGN 
          es-api-log.cJSON = cJson.
   
       fc-chamada-1().
    END.

    RELEASE es-api-log.
END.

{esp/esapi505x.i &OPC="CLOSE"}

RETURN "OK".

/*
{
  "numeroEmbarque": "666666",
  "numeroPedido": "654987",
  "codigoExportador": "14566",
  "moeda": 220,
  "incoterm": "FOB",
  "numeroInvoice": "WTII20061702",
  "cubagem": "58415",
  "dataProntidao": "2020-10-26",
  "Itens": [
    {
      "id": "666666-654987-456-6-1888472-14566",
      "codigoProduto": "1888472",
      "quantidade": 20,
      "valorUnitario": 100.5,
      "pesoLiquido": 50,
      "condicaoPagamento": "At‚ 180 dias"
    }
  ]
}
*/

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

