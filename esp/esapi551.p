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
{esp/es0018.i}
{include/i-freeac.i}

DEF INPUT PARAM h-acomp     AS HANDLE NO-UNDO.    
DEF INPUT PARAM i-acao      AS i      NO-UNDO.
DEF INPUT PARAM rw-registro AS ROWID  NO-UNDO.


DEF TEMP-TABLE tt-item
    FIELD codigo                          LIKE item-uni-estab.it-codigo         SERIALIZE-NAME "codigo"                     
    FIELD nomeExportador                  LIKE item-fornec-estab.cod-emitente   SERIALIZE-NAME "nomeExportador"
    FIELD Fabricante                      LIKE item-fornec-estab.item-do-forn   SERIALIZE-NAME "Fabricante"
    FIELD narrativa                       LIKE ITEM.desc-item                   SERIALIZE-NAME "narrativa"
    FIELD narrativa-manaus                LIKE ITEM.desc-item                   SERIALIZE-NAME "narrativa"
    FIELD ncm                             LIKE item.class-fiscal                SERIALIZE-NAME "ncm"
    FIELD partNumber                      LIKE item-uni-estab.it-codigo         SERIALIZE-NAME "partNumber"
    FIELD aplicacaoProduto                AS c                                  SERIALIZE-NAME "aplicacaoProduto"
    FIELD codicaoMercadoria               AS c                                  SERIALIZE-NAME "codicaoMercadoria"
    FIELD icms                            LIKE item-tab.aliquota-icm            SERIALIZE-NAME "icms"
    FIELD modalidadeDespacho              AS c                                  SERIALIZE-NAME "modalidadeDespacho"
    FIELD metaValorizacao                 AS c                                  SERIALIZE-NAME "metaValorizacao"
    FIELD codicaoPagamento                AS C                                  SERIALIZE-NAME "codicaoPagamento"
    FIELD destaqueNCM                     LIKE int-item.destaque                SERIALIZE-NAME "destaqueNCM"
    FIELD moeda                           AS CHAR                               SERIALIZE-NAME "moeda"
    FIELD tipoLicencaImportacao           AS c                                  SERIALIZE-NAME "tipoLicencaImportacao"
    FIELD necessitaLicencaImportacao      AS LOG FORM "true/false"              SERIALIZE-NAME "necessitaLicencaImportacao"
    FIELD regimetTributacaoII             AS c                                  SERIALIZE-NAME "regimetTributacaoII"
    FIELD regimentotributacaoIPI          AS c                                  SERIALIZE-NAME "regimentotributacaoIPI"
    FIELD regimeTributacaoPisCofins       AS c                                  SERIALIZE-NAME "regimeTributacaoPisCofins"
    FIELD regimeTributacaoICMS            AS c                                  SERIALIZE-NAME "regimeTributacaoICMS"
    FIELD relacaoExportadorFabricante     AS c                                  SERIALIZE-NAME "relacaoExportadorFabricante"
    FIELD modalidadeCambio                AS c                                  SERIALIZE-NAME "modalidadeCambio"
    FIELD descricaoIngles                 LIKE item.desc-inter                  SERIALIZE-NAME "descricaoIngles"
    FIELD isentoAfrmm                     AS i                                  SERIALIZE-NAME "isentoAfrmm"
    FIELD unidadeMedida                   AS c
    FIELD pesoLiquido                     AS i
    FIELD pesoBruto                       AS i
    FIELD seq-suframa                     LIKE int-item.seq-suframa 
    FIELD ex-tarifario                    LIKE int-item.ex-tarifario
    FIELD projeto                         AS c
    FIELD nve                             AS c
    FIELD exIPI                           LIKE int-item.exIPI
    INDEX i codigo        
            nomeExportador
            Fabricante    
    .

DEF VAR i-pag        AS i        NO-UNDO.
DEF VAR httCust      AS HANDLE   NO-UNDO.
DEF VAR lReturnValue AS LOGICAL  NO-UNDO.

DEF NEW GLOBAL SHARED VAR l-esapi551 AS l NO-UNDO.

DEF VAR cJson        AS c        NO-UNDO.
DEF VAR c-cod-item   AS c        NO-UNDO.
DEF VAR c-nve        AS c        NO-UNDO.

DEF VAR n            AS i        NO-UNDO.
DEF VAR j            AS i        NO-UNDO.
DEF VAR t            AS i        NO-UNDO.

DEF VAR i-tot        AS i        NO-UNDO.

DEF VAR c-faixa-ge   AS c        NO-UNDO.
DEF VAR c-faixa-est  AS c        NO-UNDO.

ASSIGN
   t = TIME.

{esp/esapi505x.i &OPC="OPEN"}

IF i-acao = 0
THEN DO:
   l-esapi551 = NO.
   {esp/esapi505x.i &OPC="CLOSE"}
   RETURN "OK".
END.


/* ************************  Function Prototypes ********************** */


FUNCTION fc-campo RETURNS CHARACTER
  ( c AS CHARACTER )  FORWARD.

FUNCTION fc-data RETURNS DATE
  ( c AS CHARACTER )  FORWARD.


/* ***************************  Main Block  *************************** */

blk: FOR FIRST es-api-log
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

    IF  l-esapi551        = NO
    AND es-api-log.id-URI = "ItemEX"
    AND length(es-api-log.cJson)  = ?
    THEN DO:
       // itemCEX 2
       RUN esp/es0018p.p (INPUT "itemCEX":U,
                          INPUT 2,
                          INPUT 0,
                          INPUT "":U,
                          OUTPUT TABLE tt-prog-ponto).

       FOR EACH tt-prog-ponto:
           IF c-faixa-est = ""
           THEN ASSIGN
              c-faixa-est = tt-prog-ponto.conteudo.
           ELSE ASSIGN
              c-faixa-est = c-faixa-est
                          + ","
                          + tt-prog-ponto.conteudo.
       END.


       RUN esp/es0018p.p (INPUT "itemCEX":U,
                          INPUT 1,
                          INPUT 0,
                          INPUT "":U,
                          OUTPUT TABLE tt-prog-ponto).


       FOR EACH tt-prog-ponto:
           IF c-faixa-ge = ""
           THEN ASSIGN
              c-faixa-ge = tt-prog-ponto.conteudo.
           ELSE ASSIGN
              c-faixa-ge = c-faixa-ge
                         + ","
                         + tt-prog-ponto.conteudo.
       END.

       blk: DO i = 1 TO NUM-ENTRIES(c-faixa-ge):
          FOR EACH ITEM NO-LOCK 
             WHERE ITEM.ge-codigo = INT(ENTRY(i,c-faixa-ge)):
             ASSIGN
                i-tot = i-tot + 1.

             IF i-tot / 100 = INT(i-tot / 100) 
             THEN RUN pi-acompanhar IN h-acomp (STRING(TIME - t,"hh:mm:ss") 
                                                + " - "
                                                + STRING(i-tot)
                                                + " - Item - " 
                                                + ITEM.it-codigo).

             FIND FIRST int-item NO-LOCK
                  WHERE int-item.it-codigo = ITEM.it-codigo
                  NO-ERROR.
             IF NOT AVAIL int-item
             THEN NEXT.

             FOR EACH item-fornec-estab NO-LOCK
                WHERE item-fornec-estab.it-codigo = ITEM.it-codigo
                  AND item-fornec-estab.ativo       = YES:

                 IF LOOKUP(item-fornec-estab.cod-estabel,c-faixa-est) = 0
                 THEN NEXT.

                 IF item.class-fiscal = "00000000"
                 OR item.class-fiscal = ""
                 THEN NEXT.

                 RELEASE tb-pr-cc.
                 RELEASE moeda.
                 RELEASE item-tab.
                 
                 FOR FIRST tb-pr-cc NO-LOCK 
                     WHERE tb-pr-cc.cod-emitente = item-fornec-estab.cod-emitente
                       AND tb-pr-cc.cod-cond-pag = item-fornec-estab.cod-cond-pag
                       AND tb-pr-cc.situacao     = 1
                       AND tb-pr-cc.dt-inicio   <= TODAY
                       AND tb-pr-cc.dt-termino  >= TODAY:
       
                     FIND FIRST moeda NO-LOCK
                          WHERE moeda.mo-codigo = tb-pr-cc.mo-codigo
                          NO-ERROR.
       
                     FIND FIRST item-tab NO-LOCK USE-INDEX tab-item
                          WHERE item-tab.cod-emitente = tb-pr-cc.cod-emitente 
                            AND item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
                            AND item-tab.nr-tab       = tb-pr-cc.nr-tab 
                            AND item-tab.dt-inicio    = tb-pr-cc.dt-inicio 
                            AND item-tab.it-codigo    = item-fornec-estab.it-codigo 
                         NO-ERROR.
                 END.
                 
                 ASSIGN
                    i-pag = 4.
                 FIND FIRST cond-pagto NO-LOCK 
                      WHERE cond-pagto.cod-cond-pag = item-fornec-estab.cod-cond-pag
                      NO-ERROR.
                 IF AVAIL cond-pagto THEN DO:
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
                 END. 
                 
                 // itemCEX 1

                 RUN esp/es0018p.p (INPUT "itemCEX":U,
                                    INPUT 3,
                                    INPUT 0,
                                    INPUT "":U,
                                    OUTPUT TABLE tt-prog-ponto).

                 FIND FIRST tt-prog-ponto
                      WHERE entry(1,tt-prog-ponto.conteudo,";") = ITEM.un NO-ERROR.

                 FIND FIRST tt-item
                      WHERE tt-item.codigo              = ITEM.it-codigo
                        AND tt-item.nomeExportador      = item-fornec-estab.cod-emitente
                      /*
                        AND tt-item.Fabricante          = (IF item-fornec-estab.item-do-forn <> "" 
                                                           THEN item-fornec-estab.item-do-forn 
                                                           ELSE STRING(item-fornec-estab.cod-emitente)
                                                          )
                      */
                      NO-ERROR.

                 IF NOT AVAIL tt-item
                 THEN CREATE tt-item.

                 ASSIGN
                    tt-item.codigo                      = ITEM.it-codigo                             
                    tt-item.nomeExportador              = item-fornec-estab.cod-emitente             
                    /*
                    tt-item.Fabricante                  = (IF item-fornec-estab.item-do-forn <> "" 
                                                           THEN item-fornec-estab.item-do-forn 
                                                           ELSE string(item-fornec-estab.cod-emitente)
                                                          ) 
                    */
                    tt-item.ncm                         = item.class-fiscal                          
                    tt-item.unidadeMedida               = IF AVAIL tt-prog-ponto THEN trim(entry(2,tt-prog-ponto.conteudo,";")) ELSE "PC"
                    tt-item.pesoLiquido                 = ITEM.peso-liquido
                    tt-item.pesoBruto                   = ITEM.peso-bruto
          
                    tt-item.partNumber                  = ITEM.it-codigo                             
                    tt-item.codicaoMercadoria           = "not_used"                                 
                    tt-item.icms                        = IF AVAIL item-tab THEN item-tab.aliquota-icm ELSE 0
                    tt-item.modalidadeDespacho          = "NORMAL"                                   
                    tt-item.metaValorizacao             = "01 - ART. 1 DO ACORDO (DECRETO 92930/86)" 
                    tt-item.codicaoPagamento            = ENTRY(i-pag,"Ate 180 dias,De 181 ate 360 dias,Acima de 360 dias,Nenhum")
                    tt-item.destaqueNCM                 = (IF int-item.destaque <> ? THEN int-item.destaque ELSE 0)
                    tt-item.moeda                       = IF AVAIL mgcad.moeda THEN string(mgcad.moeda.cod-decex) ELSE "" 

                    tt-item.regimetTributacaoII         = "Regime Integral"                                        
                    tt-item.regimentotributacaoIPI      = "Regime IPI Integral"                                        
                    tt-item.regimeTributacaoPisCofins   = "Regime Integral"                                        
                    tt-item.regimeTributacaoICMS        = "EXONERADO"                                        
                                                                                                     
                    tt-item.modalidadeCambio            = "Financiamento do Fornecedor (Supplier's Credit) - Outros"                                       
                    tt-item.descricaoIngles             = fc-campo(item.desc-inter)
                    tt-item.isentoAfrmm                 = 0                                          
                    
                    tt-item.seq-suframa                 = int-item.seq-suframa      
                    tt-item.ex-tarifario                = int-item.ex-tarifario     
                    tt-item.exIPI                       = int-item.exIPI 
                    tt-item.projeto                     = ""                      
                    .

                 RUN esp/es0018p.p (INPUT "itemCEX":U,
                                    INPUT 4,
                                    INPUT 0,
                                    INPUT "":U,
                                    OUTPUT TABLE tt-prog-ponto).

                 FIND FIRST tt-prog-ponto 
                      WHERE tt-prog-ponto.conteudo = string(ITEM.ge-codigo) NO-ERROR.
                 IF AVAIL tt-prog-ponto THEN
                    ASSIGN tt-item.aplicacaoProduto = "Revenda".
                 ELSE 
                    ASSIGN tt-item.aplicacaoProduto = "Consumo".


                 IF item.log-necessita-li = YES THEN
                    ASSIGN tt-item.tipoLicencaImportacao       = "Previa"    
                           tt-item.necessitaLicencaImportacao  = TRUE.
                 ELSE
                    ASSIGN tt-item.tipoLicencaImportacao       = ""    
                           tt-item.necessitaLicencaImportacao  = FALSE.
                           

                 IF INDEX(ITEM.narrativa,"#MANAUS#")    > 0
                 THEN ASSIGN 
                    tt-item.narrativa                   = fc-campo(TRIM(SUBSTRING(ITEM.narrativa,1,INDEX(ITEM.narrativa,"#MANAUS#") - 1)))
                    tt-item.narrativa-manaus            = fc-campo(TRIM(SUBSTRING(ITEM.narrativa,INDEX(ITEM.narrativa,"#MANAUS#") + 8))).
                 ELSE ASSIGN
                    tt-item.narrativa                   =  fn-free-accent(fc-campo(ITEM.narrativa)).
                 
                 /*
                 IF string(item-fornec-estab.cod-emitente) = trim(item-fornec-estab.item-do-forn)
                 THEN ASSIGN
                    tt-item.relacaoExportadorFabricante = "Exportador e fabricante".
                 ELSE ASSIGN
                    tt-item.relacaoExportadorFabricante = "Exportador nao e fabricante".
                 */

                 /**/
                 ASSIGN
                    tt-item.relacaoExportadorFabricante = "Exportador e fabricante".
                 /**/

                 IF (NOT int-item.nve MATCHES "*N/A*" 
                 AND NOT int-item.nve MATCHES "*NA*")
                 AND int-item.nve <> "" 
                 THEN DO:
                    ASSIGN
                       tt-item.nve = "".
                    DO n = 1 TO NUM-ENTRIES(int-item.nve,"/"):
                       IF n > 1
                       THEN ASSIGN
                          tt-item.nve = tt-item.nve 
                                    + ' ~{ ' 
                                    + '"nivel":"'
                                    + ENTRY(1,int-item.nve,"/")
                                    + '", '
                                    + '"atributo":"'
                                    + SUBSTR(ENTRY(n,int-item.nve,"/"),1,2)
                                    + '", '
                                    + '"especificacao":"'
                                    + SUBSTR(ENTRY(n,int-item.nve,"/"),3)
                                    + '" } '
                              .
                       IF  n > 1
                       AND n < NUM-ENTRIES(int-item.nve,"/")
                       THEN  ASSIGN
                          tt-item.nve = tt-item.nve 
                                      + ",".
                    END.
                    IF tt-item.nve <> ""
                    THEN ASSIGN
                       tt-item.nve = '"NVE": [ '
                             + tt-item.nve
                             + " ], ".
                 END.

             END.
//             LEAVE.
          END.
       END.

/*-*-*-*-*/

       FOR EACH tt-item:

          ASSIGN
             cJson =  '~{'
                   +     '"Importacao": ~{'
                   +     '"codigoExportador": "' + string(tt-item.nomeExportador) + '",'
                   +     '"codigoFabricante": "' + string(tt-item.Fabricante) + '",'
                   +     '"condicaoMercadoria": "Novo",'
                   +     '"modalidadeDespacho": "Normal",'
                   +     '"metodoValoracao": "' + tt-item.metaValorizacao + '",'
                   +     '"condicaoPagamento": "' + ENTRY(i-pag,"Ate 180 dias,De 181 at‚ 360 dias,Acima de 360 dias") + '",'
                   +     '"tipoLicencaImportacao": "' + tt-item.tipoLicencaImportacao + '",'
                   +     '"regimeTributacaoII": "Regime Integral",'
                   +     '"regimentotributacaoIPI": "Regime IPI Integral",'
                   +     '"regimeTributacaoPisCofins": "Regime Integral",'
                   +     '"regimeTributacaoICMS": "EXONERADO",'
                   +     '"relacaoExportadorFabricante":" ' + tt-item.relacaoExportadorFabricante + '",'
                   +     '"modalidadeCambio": "' + tt-item.modalidadeCambio + '",'
                   +     '"necessitaLicencaImportacao": ' + string(tt-item.necessitaLicencaImportacao,"true/false") + ','
                   +     '"destaqueNCM": "' + STRING(tt-item.destaqueNCM) + '",'
                   +     '"moeda": "' + tt-item.moeda + '",'
                   +     '"isentoAFRMM": 0,'
                   +     '"icms": '    + REPLACE(STRING(tt-item.ICMS),",",".") + ','.

          IF  tt-item.ex-tarifario     <> "" 
          AND NOT tt-item.ex-tarifario MATCHES "*NA*" 
          AND NOT tt-item.ex-tarifario MATCHES "*N/A*" 
          THEN ASSIGN
             cJson = cJson
                   +     '"exTarifario":"' + tt-item.ex-tarifario + '",'.

          IF  tt-item.exIPI     <> "" 
          AND tt-item.exIPI     <> "1"
          AND NOT tt-item.exIPI MATCHES "*NA*" 
          AND NOT tt-item.exIPI MATCHES "*N/A*" 
          THEN ASSIGN
             cJson = cJson
                   +     '"exIPI":"' + tt-item.exIPI + '",'.

/*           IF tt-item.seq-suframa <> "" THEN                                      */
/*              ASSIGN                                                              */
/*              cJson = cJson                                                       */
/*                    +     '"Suframa":['                                           */
/*                    +        '~{'                                                 */
/*                    +           '"projeto":"",'                                   */
/*                    +           '"sequencia":"' + tt-item.seq-suframa      + '",' */
/*                    +           '"narrativa":"' + tt-item.narrativa-manaus + '"'  */
/*                    +        '}'                                                  */
/*                    +     '],'.                                                   */
/*           ELSE                                                                   */
             ASSIGN
             cJson = cJson
                   +     '"Suframa":[],'.

          IF tt-item.nve <> ""
          THEN ASSIGN
             cJson = cJson
                   + tt-item.nve.
          ASSIGN
             cJson = cJson
                   +     '"Produto": ~{'
                   +          '"codigo": "' + tt-item.codigo + '",'
                   +          '"ncm": ' + tt-item.ncm + ','
                   +          '"unidadeMedida": "' + tt-item.unidadeMedida + '",'
                   +          '"aplicacaoProduto": "' + tt-item.aplicacaoProduto + '",'
                   +          '"Descricoes": ['
                   +            '~{'
                   +              '"nome": "Descricao Importacao",'
                   +              '"valor": "' + tt-item.narrativa + '"'
                   +            '~},'
                   +            '~{'
                   +              '"nome": "Descricao em Ingles",'
                   +              '"valor": "' + tt-item.descricaoIngles + '"'
                   +            '~}'
                   +          '],'
                   +          '"pesoLiquido": ' + replace(string(tt-item.pesoLiquido),",",".") + ','
                   +          '"pesoBruto": '   + replace(string(tt-item.pesoBruto  ),",",".") + ''
                   +       '~}'
                   +     '~}'
                   + '~}'.

/*           MESSAGE cJson. */
/*           CLIPBOARD:VALUE = cJson. */
          PUT SKIP(3).
/*           DISP                          */
/*              tt-item                    */
/*              WITH STREAM-IO SCROLLABLE. */

          FIND FIRST es-api-cex-item 
               WHERE es-api-cex-item.it-codigo    = tt-item.codigo
                 AND es-api-cex-item.cod-emitente = tt-item.nomeExportador
                 //AND es-api-cex-item.item-do-forn = tt-item.Fabricante
               NO-ERROR.

/*           MESSAGE ">> Item " tt-item.codigo " - " tt-item.nomeExportador " - " tt-item.Fabricante. */
          
          IF AVAIL es-api-cex-item 
          THEN DO:
             IF cJson <> es-api-cex-item.cJson
             THEN DO:
/*                 MESSAGE ">> Alterar ". */
                ASSIGN
                   es-api-cex-item.cJson = cJson.
                RUN pi-criar-log ("ItemEX",
                                  tt-item.codigo         
                                + ","
                                + STRING(tt-item.nomeExportador)
                                + ","
                                + tt-item.Fabricante     
                                  ,cJson
                                  ).
             END.
          END.
          ELSE DO:
/*              MESSAGE ">> Criar ". */
             CREATE es-api-cex-item.
             ASSIGN
                es-api-cex-item.it-codigo    = tt-item.codigo        
                es-api-cex-item.cod-emitente = tt-item.nomeExportador
                //es-api-cex-item.item-do-forn = tt-item.Fabricante    
                es-api-cex-item.cJson        = cJson.
             RUN pi-criar-log ("ItemEX-NEW",
                                  tt-item.codigo         
                                + ","
                                + STRING(tt-item.nomeExportador)
                                + ","
                                + tt-item.Fabricante     
                                  ,cJson
                               ).
          END.
          //LEAVE. /*-*-*-*/
       END.
       ASSIGN 
          l-esapi551 = YES.
       ASSIGN
          es-api-log.dh-retorno = NOW.

       RELEASE es-api-log.
       LEAVE blk.
    END.

//    MESSAGE 4 l-esapi551 VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l1 . IF l1 = NO THEN STOP.

    RUN pi-acompanhar IN h-acomp (STRING(es-api-log.id-api-log) +  "- Item - " + es-api-log.aux).

/*     MESSAGE es-api-log.aux. */
/*     MESSAGE cJson.          */

    ASSIGN 
       lcEnvio = es-api-log.cJSON
       lcEnvio = CODEPAGE-CONVERT(lcEnvio, "UTF-8":U).

    IF es-api-aplicacao.Testes  = NO
    THEN ASSIGN
       c-endereco          = es-api-URI.ent-PRD.
    ELSE ASSIGN            
       c-endereco          = es-api-URI.end-TST.

    IF es-api-log.id-URI = "ItemEX"
    THEN ASSIGN
       c-endereco          = c-endereco + ENTRY(1,es-api-log.aux).

    COPY-LOB lcEnvio TO es-api-log.cl-envio.

    IF es-api-log.aux > ""
    THEN fc-chamada-1(). //fc-chamada-2().

/*
    IF es-api-log.cod-retorno >= "300"
    THEN DO:
       FIND FIRST es-api-cex-item 
            WHERE es-api-cex-item.it-codigo    =     ENTRY(1,es-api-log.aux)
              AND es-api-cex-item.cod-emitente = INT(ENTRY(2,es-api-log.aux))
              //AND es-api-cex-item.item-do-forn =     ENTRY(3,es-api-log.aux)
            NO-ERROR.
       IF AVAIL  es-api-cex-item
       THEN DO:
          IF es-api-log.id-URI = "ItemEX-NEW"
          THEN DELETE es-api-cex-item.
          ELSE ASSIGN
             es-api-cex-item.cJson = "".
       END.
    END.
*/    

    RELEASE es-api-log.
END.

//MESSAGE 7 l-esapi551 VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l1 . IF l1 = NO THEN STOP.

{esp/esapi505x.i &OPC="CLOSE"}

//MESSAGE 8 l-esapi551 VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l1 . IF l1 = NO THEN STOP.

RETURN "OK".

PROCEDURE pi-criar-log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF BUFFER bf-las-api-log FOR es-api-log.
   DEF BUFFER bf-new-api-log FOR es-api-log.
   DEF INPUT PARAM cURI      AS  c NO-UNDO.
   DEF INPUT PARAM cCod      AS  c NO-UNDO.
   DEF INPUT PARAM cJson     AS  c NO-UNDO.

   IF cJSON = ""
   THEN RETURN.

   FIND LAST bf-las-api-log NO-LOCK
       WHERE bf-las-api-log.id-api-log > 0
       NO-ERROR.
   CREATE bf-new-api-log.
   ASSIGN
      bf-new-api-log.seqexec        = es-api-log.seqexec     
      bf-new-api-log.id-aplicacao   = es-api-log.id-aplicacao
      bf-new-api-log.id-codigo      = es-api-log.id-codigo   
      bf-new-api-log.id-URI         = cURI
      bf-new-api-log.dh-request     = NOW
      bf-new-api-log.end-envio      = es-api-log.end-envio
      bf-new-api-log.flg-processado = NO
      bf-new-api-log.Origem         = es-api-log.Origem
      bf-new-api-log.aux            = cCod
      bf-new-api-log.cJSON          = cJson
      bf-new-api-log.id-api-log     = NEXT-VALUE(seq_api_log).

   RELEASE bf-new-api-log.

END PROCEDURE.


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
/*       c = REPLACE(c,',','') */
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

FUNCTION fc-data RETURNS DATE
  ( c AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR d AS da NO-UNDO.

  IF c > ""
  THEN ASSIGN
     d = DATE(INT(SUBSTR(c,5,2)),
              INT(SUBSTR(c,7,2)),
              INT(SUBSTR(c,1,4))
              ).

  RETURN d.   /* Function return value. */

END FUNCTION.
