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

DEF BUFFER bf-ordens-embarque     FOR ordens-embarque.

DEF VAR cJson               AS LONGCHAR                             NO-UNDO.
    
DEF VAR i-pag               AS i                                    NO-UNDO.
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

    MESSAGE ">> " es-api-log.aux.
        

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

       if  embarque-imp.cod-via-transp > 1
       and embarque-imp.cod-via-transp < 4
       then.
       else do:
            assign l-er-via-trans = yes.
            next.
       end.

       MESSAGE " *** 1 ".

       FOR EACH bf-ordens-embarque NO-LOCK
          WHERE bf-ordens-embarque.cod-estabel  = embarque-imp.cod-estabel
            AND bf-ordens-embarque.embarque     = embarque-imp.embarque
            AND bf-ordens-embarque.numero-ordem = INT(ENTRY(3,es-api-log.aux))
            AND bf-ordens-embarque.parcela      = INT(ENTRY(4,es-api-log.aux)),
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
               WHERE mgcad.moeda.mo-codigo = pedido-compr.i-moeda
               NO-ERROR.

          FOR EACH prazo-compra NO-LOCK
                OF ordem-compra
             WHERE prazo-compra.parcela = bf-ordens-embarque.parcela:
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

             ASSIGN
                cJson = cJson
                      + '~{'
                      + '"id":"'                 + cIDItem + '",'
/*                    + '"quantidade":'          + REPLACE(STRING(prazo-compra.quantidade),",",".") + ','                      */
/*                    + '"valorUnitario":'       + REPLACE(STRING(ordem-compra.pre-unit-for,">>>>>>>>>9.99999"),",",".") + ',' */
                      + '"quantidade":'          + REPLACE(STRING(prazo-compra.qtd-do-forn,">>>>>>9.99999"),",",".") + ','
                      + '"valorUnitario":'       + REPLACE(STRING(ordem-compra.preco-fornec,">>>>>>>>>9.99999"),",",".") + ','
                     /*+ '"pesoLiquido":'         + REPLACE(STRING(ordens-embarque.peso-liquido,">>>>>>>>>9.99999"),",",".") + ','*/
                      + '"condicaoPagamento":"'  + ENTRY(i-pag,"Ate 180 dias,De 181 ate 360 dias,Acima de 360 dias, Nenhum") + '"'
                      + '}'
                      .
          END.

       END.

       ASSIGN
          l-proc = YES.

    END.

    IF VALID-HANDLE(h-acomp)
    THEN RUN pi-acompanhar IN h-acomp ("Altera‡Æo de Item do Pedido").

    IF l-proc = NO
    THEN DO:
       IF es-api-log.aux > ""
       and not l-er-via-trans
       then do:
            RUN piErro ("Nao foi encontrado item do pedido " + es-api-log.aux,"").
            MESSAGE ">> Nao foi encontrado item do pedido " + es-api-log.aux.
       end.
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
       //CLIPBOARD:VALUE = STRING(cJson).
       MESSAGE ">> " c-endereco.
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
  "id": "666666-654987-456-1-1888475-14566",
  "quantidade": 100,
  "valorUnitario": 100.5,
  "pesoLiquido": 50,
  "condicaoPagamento": "At‚ 180 dias"
}
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

