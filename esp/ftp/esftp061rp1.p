/*****************************************************************************
**     Programa.........: esp/acr/ESFTP061rp1.p
**     Descricao .......: RelatΩrio Objetivo x Realizado
**     Versao...........: 1.00.000
**     Autor............: Chaves - Gestech
**     Criado...........: 29/01/2005
**     Desc. Atualizaªío: 
**     Autor............: 
          /*CΩdigo de tributaªío PIS*/
          case string(substring(it-nota-fisc.char-2,96,1)): 
            when "1" then "Tributado".
            when "2" then "Isento".
            when "3" then "Outros".
            when "4" then "Reduzido".
          end.
          /*CΩdigo de Tributaªío COFINS*/
          case substring(it-nota-fisc.char-2,97,1):
            when "1" then "Tributado".
            when "2" then "Isento".
            when "3" then "Outros".
            when "4" then "Reduzido".
          end.

*******************************************************************************/
{esp/ftp/esftp061tt.i}
{cdp/cd0666.i}

DEFINE INPUT  PARAM TABLE FOR tt-param.
DEFINE INPUT  PARAM TABLE FOR tt-raw-digita.
DEFINE OUTPUT PARAM TABLE FOR tt-calcula.
DEFINE OUTPUT PARAM TABLE FOR tt-erro.

FIND FIRST tt-param NO-ERROR.

DEF BUFFER b-fm-cod-com-aux FOR fam-com-item.
def buffer b-nota-fiscal    for nota-fiscal.
def buffer b-it-nota-fis    for it-nota-fisc.
DEF BUFFER b-tt-calcula     FOR tt-calcula.
DEF BUFFER b-emitente       FOR emitente.
def var i-nr-nota-dev        like nota-fiscal.nr-nota-fis no-undo.
def var de-perc-comissao   as decimal                 no-undo.

DEF VAR vcod-msg-devolucao AS INTEGER FORMAT ">>9" NO-UNDO.
def var de-vl-acordo        as DECIMAL NO-UNDO.
def var de-CPRB             as DECIMAL NO-UNDO.
def var de-vl-mkt           as DECIMAL NO-UNDO.
def var de-indice-fis       as decimal no-undo.
DEF VAR de-indice-pres      AS DECIMAL NO-UNDO.
def var de-mob              as decimal no-undo.
def var de-mat              as decimal no-undo.
def var de-ipi              as decimal no-undo.
def var de-icms             as decimal no-undo.
def var de-icms-cp          as decimal no-undo.
def var de-icms-cpi         as decimal no-undo.
DEF VAR de-icms-cpre        AS DECIMAL NO-UNDO.
def var de-icms-subs        as decimal no-undo.
def var de-vl-frete         as decimal no-undo.
def var de-vl-frete-rateio  as decimal no-undo.
DEF VAR vCodUnidNegocio     LIKE unid-neg-fam-com.cod_unid_negoc.
DEF VAR vDesUnidNegocio     AS char.
DEF VAR c-desc-prod         AS CHAR FORMAT "X(60)".
def var de-vl-comissao      as decimal                 no-undo.
DEF VAR de-base-acordo      LIKE it-nota-fisc.vl-merc-liq NO-UNDO.
def VAR de-vl-icms-fcp       AS DECIMAL NO-UNDO.
def VAR de-vl-icms-uf-dest   AS DECIMAL NO-UNDO.
def VAR de-vl-icms-uf-remet  AS DECIMAL NO-UNDO.
DEF VAR vlr-fcp              AS DECIMAL NO-UNDO.


DEFINE VARIABLE de-perc-acordo          AS DECIMAL NO-UNDO.
DEFINE VARIABLE i-id-faturamento-acordo AS INTEGER NO-UNDO.
DEFINE VARIABLE i-id-base-calc-acordo   AS INTEGER NO-UNDO.
DEFINE VARIABLE i-id-devolucoes         AS INTEGER NO-UNDO.
 
DEFINE VARIABLE c-nr-nota-fis AS CHARACTER   NO-UNDO.
DEF VAR da-data             AS DATE       NO-UNDO.
DEF VAR vlogImportado       AS LOGICAL    NO-UNDO.
DEF VAR vlogimportadore     AS LOGICAL    NO-UNDO. 
DEF VAR vlogBeneficiado     AS LOGICAL    NO-UNDO.
DEF VAR vlogBenefConvenc    AS LOGICAL    NO-UNDO.
DEF VAR h-acomp             AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boes464 AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-periodo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-medio-devol AS DATE        NO-UNDO.

DEFINE VARIABLE c-unid-neg  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-unid-neg-subst  AS CHARACTER   FORMAT "x(15)" NO-UNDO.
DEFINE VARIABLE c-desc-unid AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-unid-neg-nota       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-unid-nota      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-vertical            AS CHARACTER   NO-UNDO.

def temp-table tt-rat-notas-precon no-undo
    field rw-nf          as rowid
    field rw-precon      as rowid
    field de-frete-total as dec.

DEFINE VARIABLE v_num_seq AS INTEGER     NO-UNDO.
DEFINE VARIABLE dt-saldo AS DATE        NO-UNDO.

function fn-retorna-descricao-segmento returns character
  ( p-fm-cod-com as character )  forward.

function fn-retorna-cod-segmento returns character
  ( p-fm-descricao as character ) forward.

function fn-retorna-desc-unidade returns character
  ( p-cod-unidade as character ) forward.

DEF TEMP-TABLE tt-unidade LIKE unid-negoc.
FOR EACH unid-negoc:
    CREATE tt-unidade.
    BUFFER-COPY unid-negoc TO tt-unidade.
END.

RUN esbo/boes464.p    PERSISTENT SET h-boes464.

run utp/ut-acomp.p persistent set h-acomp.  

run pi-inicializar in h-acomp (input "Calculando..."). 

FOR FIRST param-global NO-LOCK. END.


FOR EACH tt-tot-unid:
    DELETE tt-tot-unid.
END.

FOR EACH tt-vpc:
    DELETE tt-vpc.
END.

FOR EACH tt-total-vpc:
    DELETE tt-total-vpc.
END.

do da-data = tt-param.da-data-ini to tt-param.da-data-fim:
   run pi-cria-tt-calcula.   
   run pi-acompanhar in h-acomp (INPUT "Devoluªío -  Data: " + STRING(da-data)).
   run pi-cria-tt-calcula-devol. /*CHAVES */  
END.
   
IF MONTH(tt-param.da-data-fim) = 12 THEN
    ASSIGN dt-saldo = DATE(12,31,YEAR(tt-param.da-data-fim)).
ELSE
    ASSIGN dt-saldo = DATE(MONTH(tt-param.da-data-fim) + 1,01,YEAR(tt-param.da-data-fim)) - 1.

/* Retirado conforme chamado 90799
IF tt-param.cod-estab-ini < "301" THEN DO:
    RUN pi-gera-totais.
    RUN pi-calcula-vpc.
    RUN pi-ajustes.
END.
*/

IF VALID-HANDLE(h-boes464) THEN
    DELETE PROCEDURE h-boes464.

run pi-finalizar in h-acomp.

procedure pi-cria-tt-calcula:

   for each nota-fiscal no-lock USE-INDEX ch-distancia
       where nota-fiscal.cod-estabel >= tt-param.cod-estab-ini
         and nota-fiscal.cod-estabel <= tt-param.cod-estab-fim
         and nota-fiscal.dt-emis-nota  = da-data 
         and nota-fiscal.dt-cancela = ?
       BY nota-fiscal.dt-emis-nota
       BY nota-fiscal.nr-nota-fis:

       run pi-acompanhar in h-acomp (INPUT "Faturamento. Data: " + STRING(da-data) + "   NF: " + nota-fiscal.nr-nota-fis). 
       
       find FIRST emitente 
            where emitente.cod-emitente = nota-fiscal.cod-emitente
            no-lock no-error.
       IF NOT AVAIL emitente THEN DO:
           RUN piCriaErro(INPUT 17006,
                          INPUT "Nío Encontrado Cliente para a Nota.: " + nota-fiscal.nr-nota-fis + ".Favor Verificar").
            NEXT. 
       END.

       /* adicionando pesquisa de transportadora chamado C2202-0330 */

       FIND transporte
       WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-LOCK NO-ERROR.

       /*validando parametros selecao*/
       IF nota-fiscal.cod-emitente < tt-param.cod-emitente-ini OR nota-fiscal.cod-emitente > tt-param.cod-emitente-fim THEN NEXT.
       IF nota-fiscal.cod-rep < tt-param.cod-rep-ini OR nota-fiscal.cod-rep > tt-param.cod-rep-fim THEN NEXT.
       IF emitente.cod-gr-cli < tt-param.cod-gr-cli-ini OR emitente.cod-gr-cli > tt-param.cod-gr-cli-fim THEN NEXT.

       IF tt-param.l-vl-presente <> 0 THEN
          ASSIGN de-indice-pres = exp(tt-param.l-vl-presente,nota-fiscal.nr-praz-med / 30).
       ELSE 
          ASSIGN de-indice-pres = 1.
       
       find first ped-venda no-lock 
            WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli 
            AND   ped-venda.nome-abrev = nota-fiscal.nome-ab-cli no-error.

        IF AVAIL ped-venda THEN
        FIND FIRST int-ped-venda NO-LOCK
             WHERE int-ped-venda.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
       
       for each it-nota-fisc of nota-fiscal no-lock,
           FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = it-nota-fisc.it-codigo
                  AND ITEM.fm-cod-com >= tt-param.fm-cod-com-ini
                  AND ITEM.fm-cod-com <= tt-param.fm-cod-com-fim,
           FIRST natur-oper no-lock
           WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao
             AND natur-oper.atual-estat /*,
          /* FIRST natur-oper 
                where natur-oper.nat-operacao = it-nota-fisc.nat-oper
                  and not natur-oper.nat-operacao begins "5551" /*"691"*/
                  and not natur-oper.nat-operacao begins "6551" /*"591"*/
                  and not natur-oper.nat-operacao begins "7551" /*"791"*/
                  and natur-oper.nat-operacao <> "6917" /*"69904a"*/
                  and not natur-oper.ind-entfut 
                  and (natur-oper.tipo = 2 or
                       natur-oper.tipo = 3), /***ENTREGA FUTURA **/*/
           FIRST unid-neg-fat of it-nota-fis no-lock*/
           BREAK BY it-nota-fisc.nr-nota-fis:
           ASSIGN c-unid-neg  = "Material de Consumo"
                  c-desc-unid = "Material de Consumo". 

           FIND FIRST unid_negoc NO-LOCK
               WHERE unid_negoc.cod_unid_negoc = it-nota-fisc.cod-unid-negoc NO-ERROR.

           IF AVAIL unid_negoc THEN
               ASSIGN c-unid-neg-nota  = unid_negoc.cod_unid_negoc
                      c-desc-unid-nota = unid_negoc.des_unid_negoc.

           for first ponto-programa
                where ponto-programa.nome-programa = "boes513"
                  AND ponto-programa.ponto         = 1,
                 EACH conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.sequencia    = int(SUBSTRING(ITEM.fm-cod-com,1,2)):

               FIND FIRST unid_negoc NO-LOCK
                    WHERE unid_negoc.cdn_unid_negoc = INT(conteudo-programa.conteudo) NO-ERROR.
               IF AVAIL unid_negoc THEN
                   ASSIGN c-unid-neg  = unid_negoc.cod_unid_negoc
                          c-desc-unid = unid_negoc.des_unid_negoc.
               ELSE
                   ASSIGN c-unid-neg  = "Material de Consumo"
                          c-desc-unid = "Material de Consumo".                       
              
           end. 

           


           IF it-nota-fisc.it-codigo < tt-param.it-codigo-ini OR it-nota-fisc.it-codigo > tt-param.it-codigo-fim THEN NEXT.

           ASSIGN de-vl-comissao = 0 
                  c-periodo        = STRING(YEAR(nota-fiscal.dt-emis-nota),"9999") + STRING(MONTH(nota-fiscal.dt-emis-nota),"99").

           FOR EACH comissao-fat NO-LOCK
              WHERE comissao-fat.cod-estabel  = nota-fiscal.cod-estabel
                AND comissao-fat.serie        = nota-fiscal.serie
                AND comissao-fat.nr-nota-fis  = nota-fiscal.nr-nota-fis
                AND comissao-fat.it-codigo    = item.it-codigo
                AND comissao-fat.periodo      = c-periodo
                AND comissao-fat.unid-neg     = c-unid-neg
                AND comissao-fat.cod-rep      = nota-fiscal.cod-rep
                AND comissao-fat.cod-emitente = nota-fiscal.cod-emitente
                AND comissao-fat.sequencia    = it-nota-fisc.nr-seq-fat
                AND comissao-fat.id-tipo-inform = 1:
               ASSIGN de-vl-comissao = de-vl-comissao + comissao-fat.vl-comissao.
           END.

           ASSIGN de-perc-acordo = 0.
           RUN getAcordoComercial IN h-boes464(INPUT emitente.cgc,
                                               INPUT nota-fiscal.cod-estabel,
                                               INPUT c-unid-neg,
                                               INPUT ITEM.fm-cod-com,
                                               INPUT nota-fiscal.dt-emis-nota,
                                               OUTPUT i-id-faturamento-acordo,
                                               OUTPUT i-id-base-calc-acordo,  
                                               OUTPUT i-id-devolucoes,
                                               OUTPUT de-perc-acordo) NO-ERROR.

           RUN pi-busca-item-nf-adc (INPUT nota-fiscal.cod-estabel,  
                                     INPUT nota-fiscal.serie,        
                                     INPUT nota-fiscal.nr-nota-fis,  
                                     INPUT it-nota-fisc.nat-operacao,
                                     INPUT it-nota-fisc.it-codigo,   
                                     INPUT it-nota-fisc.nr-seq-fat,
                                     OUTPUT de-vl-icms-fcp,     
                                     OUTPUT de-vl-icms-uf-dest, 
                                     OUTPUT de-vl-icms-uf-remet).
           /* valor FCP */
           ASSIGN vlr-fcp = 0.
           FOR EACH item-nf-adc 
                WHERE item-nf-adc.cod-estab        = nota-fiscal.cod-estabel
                 AND  item-nf-adc.cod-serie        = nota-fiscal.serie
                  AND item-nf-adc.cod-nota         = nota-fiscal.nr-nota-fis
                  AND item-nf-adc.idi-tip-dado     = 25
                  AND item-nf-adc.num-seq-item-nf  = it-nota-fisc.nr-seq-fat:
              assign vlr-fcp = vlr-fcp + DEC(substr(item-nf-adc.cod-livre-4,1,30)).
           END.

           IF CAN-FIND(FIRST ped-item-segmentos
                       WHERE ped-item-segmentos.nome-abrev = nota-fiscal.nome-ab-cli
                         AND ped-item-segmentos.nr-pedcli  = nota-fiscal.nr-pedcli
                         AND ped-item-segmentos.nr-sequencia = it-nota-fisc.nr-seq-ped
                         AND ped-item-segmentos.it-codigo    = it-nota-fisc.it-codigo) THEN DO:
               FOR EACH ped-item-segmentos
                    WHERE ped-item-segmentos.nome-abrev   = nota-fiscal.nome-ab-cli
                      AND ped-item-segmentos.nr-pedcli    = nota-fiscal.nr-pedcli
                      AND ped-item-segmentos.nr-sequencia = it-nota-fisc.nr-seq-ped
                      AND ped-item-segmentos.it-codigo    = it-nota-fisc.it-codigo NO-LOCK:


                   for first ponto-programa
                        where ponto-programa.nome-programa = "boes513"
                          AND ponto-programa.ponto         = 1,
                         EACH conteudo-programa NO-LOCK
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                          AND conteudo-programa.sequencia    = INT(SUBSTRING(ped-item-segmentos.cod-segmento,1,2)):
        
                       FIND FIRST unid_negoc NO-LOCK
                            WHERE unid_negoc.cdn_unid_negoc = INT(conteudo-programa.conteudo) NO-ERROR.
                       IF AVAIL unid_negoc THEN
                           ASSIGN c-unid-neg  = unid_negoc.cod_unid_negoc
                                  c-desc-unid = unid_negoc.des_unid_negoc.
                       ELSE
                           ASSIGN c-unid-neg  = "Material de Consumo"
                                  c-desc-unid = "Material de Consumo".                       
                      
                   end. 

                   RUN pi-grava-tt-calcula-faturamento (INPUT ped-item-segmentos.cod-segmento,
                                                        INPUT ped-item-segmentos.val-percentual).
               END.
           END.
           ELSE DO:

               RUN pi-grava-tt-calcula-faturamento (INPUT substring(ITEM.fm-cod-com,1,4),
                                                    INPUT 100).
           END.
       end.    /**** FOR EACH IT-NOTA-FIS ****/
   end.

END PROCEDURE.

procedure pi-cria-tt-calcula-devol:


       assign i-nr-nota-dev      = "".

       FOR EACH devol-cli NO-LOCK
           WHERE devol-cli.dt-devol    = da-data
           and   devol-cli.cod-estabel >= tt-param.cod-estab-ini
           and   devol-cli.cod-estabel <= tt-param.cod-estab-fim,
           FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = devol-cli.cod-emitente,
           FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel   = devol-cli.cod-estabel
                 AND   nota-fiscal.serie         = devol-cli.serie
                 AND   nota-fiscal.nr-nota-fis   = devol-cli.nr-nota-fis,
           EACH item-doc-est OF devol-cli NO-LOCK,
           first it-nota-fisc no-lock
              where it-nota-fisc.cod-estabel = devol-cli.cod-estabel
                and it-nota-fisc.serie       = devol-cli.serie
                and it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
                and it-nota-fisc.it-codigo   = devol-cli.it-codigo
                and it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia,
           FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao
                 AND   natur-oper.atual-estat,
           FIRST item  NO-LOCK
           WHERE item.it-codigo = devol-cli.it-codigo
             AND ITEM.fm-cod-com >= tt-param.fm-cod-com-ini
             AND ITEM.fm-cod-com <= tt-param.fm-cod-com-fim /*,
           FIRST unid-neg-nota of item-doc-est no-lock*/
           BREAK BY item-doc-est.nro-docto:

           run pi-acompanhar in h-acomp (INPUT " Data / NFE.: " + STRING(da-data) + " - " + devol-cli.nro-docto).

           RUN pi-busca-item-nf-adc (INPUT nota-fiscal.cod-estabel,  
                                     INPUT nota-fiscal.serie,        
                                     INPUT nota-fiscal.nr-nota-fis,  
                                     INPUT it-nota-fisc.nat-operacao,
                                     INPUT it-nota-fisc.it-codigo,   
                                     INPUT it-nota-fisc.nr-seq-fat,
                                     OUTPUT de-vl-icms-fcp,     
                                     OUTPUT de-vl-icms-uf-dest, 
                                     OUTPUT de-vl-icms-uf-remet).

           /* valor FCP */
           ASSIGN vlr-fcp = 0.
           FOR EACH item-nf-adc 
                WHERE item-nf-adc.cod-estab        = nota-fiscal.cod-estabel
                 AND  item-nf-adc.cod-serie        = nota-fiscal.serie
                  AND item-nf-adc.cod-nota         = nota-fiscal.nr-nota-fis
                  AND item-nf-adc.idi-tip-dado     = 25
                  AND item-nf-adc.num-seq-item-nf  = it-nota-fisc.nr-seq-fat:
              assign vlr-fcp = vlr-fcp + DEC(substr(item-nf-adc.cod-livre-4,1,30)).
           END.

           ASSIGN c-unid-neg  = "Material de Consumo"
                  c-desc-unid = "Material de Consumo".


           FIND FIRST unid_negoc NO-LOCK
               WHERE unid_negoc.cod_unid_negoc = it-nota-fisc.cod-unid-negoc NO-ERROR.

           IF AVAIL unid_negoc THEN
               ASSIGN c-unid-neg-nota  = unid_negoc.cod_unid_negoc
                      c-desc-unid-nota = unid_negoc.des_unid_negoc.
           
           for first ponto-programa
                where ponto-programa.nome-programa = "boes513"
                  AND ponto-programa.ponto         = 1,
                 EACH conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.sequencia    = int(SUBSTRING(ITEM.fm-cod-com,1,2)):

               FIND FIRST unid_negoc NO-LOCK
                    WHERE unid_negoc.cdn_unid_negoc = INT(conteudo-programa.conteudo) NO-ERROR.
               IF AVAIL unid_negoc THEN
                   ASSIGN c-unid-neg  = unid_negoc.cod_unid_negoc
                          c-desc-unid = unid_negoc.des_unid_negoc.
               ELSE
                   ASSIGN c-unid-neg  = "Material de Consumo"
                          c-desc-unid = "Material de Consumo".                       
           end.

           FIND FIRST int-docum-est NO-LOCK
                WHERE int-docum-est.serie-docto  = item-doc-est.serie-docto 
                AND   int-docum-est.nro-docto    = item-doc-est.nro-docto   
                AND   int-docum-est.cod-emitente = emitente.cod-emitente
                AND   int-docum-est.nat-operacao = item-doc-est.nat-operacao NO-ERROR.
           IF  AVAIL int-docum-est THEN
               ASSIGN vcod-msg-devolucao = int-docum-est.cod-msg-devolucao.
           ELSE DO:
               RUN piCriaErro(INPUT 17006,
                              INPUT "Nota de devoluªío sem motivo de devoluªío cadastrado: Serie: " + item-doc-est.serie-docto + 
                                                " Docto.: " + item-doc-est.nro-docto + " Nat.Oper.: " + item-doc-est.nat-operacao +
                                                " Fornecedor: " + string(emitente.cod-emitente)).
               ASSIGN vcod-msg-devolucao = 0.
           END.
           
           
           /*validando parametros selecao*/
           IF nota-fiscal.cod-emitente < tt-param.cod-emitente-ini OR nota-fiscal.cod-emitente > tt-param.cod-emitente-fim THEN NEXT.
           IF nota-fiscal.cod-rep < tt-param.cod-rep-ini OR nota-fiscal.cod-rep > tt-param.cod-rep-fim THEN NEXT.
           IF emitente.cod-gr-cli < tt-param.cod-gr-cli-ini OR emitente.cod-gr-cli > tt-param.cod-gr-cli-fim THEN NEXT.
           
           find transporte 
                where transporte.nome-abrev  = nota-fiscal.nome-transp
                no-lock no-error.

           IF tt-param.l-vl-presente <> 0 THEN
              ASSIGN de-indice-pres = exp(tt-param.l-vl-presente,nota-fiscal.nr-praz-med / 30).
           ELSE 
              ASSIGN de-indice-pres = 1.

           find first ped-venda no-lock 
                WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli 
                AND   ped-venda.nome-abrev = nota-fiscal.nome-ab-cli no-error.

           IF AVAIL ped-venda THEN
           FIND FIRST int-ped-venda NO-LOCK
                WHERE int-ped-venda.cod-estabel = ped-venda.cod-estabel
                  AND int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

           IF it-nota-fisc.it-codigo < tt-param.it-codigo-ini OR it-nota-fisc.it-codigo > tt-param.it-codigo-fim THEN NEXT.
           
           IF CAN-FIND(FIRST ped-item-segmentos
                       WHERE ped-item-segmentos.nome-abrev = nota-fiscal.nome-ab-cli
                         AND ped-item-segmentos.nr-pedcli  = nota-fiscal.nr-pedcli) THEN DO:

               FOR EACH ped-item-segmentos
                    WHERE ped-item-segmentos.nome-abrev   = nota-fiscal.nome-ab-cli
                      AND ped-item-segmentos.nr-pedcli    = nota-fiscal.nr-pedcli
                      AND ped-item-segmentos.nr-sequencia = it-nota-fisc.nr-seq-ped
                      AND ped-item-segmentos.it-codigo    = it-nota-fisc.it-codigo NO-LOCK:


                   for first ponto-programa
                        where ponto-programa.nome-programa = "boes513"
                          AND ponto-programa.ponto         = 1,
                         EACH conteudo-programa NO-LOCK
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                          AND conteudo-programa.sequencia    = INT(SUBSTRING(ped-item-segmentos.cod-segmento,1,2)):
        
                       FIND FIRST unid_negoc NO-LOCK
                            WHERE unid_negoc.cdn_unid_negoc = INT(conteudo-programa.conteudo) NO-ERROR.
                       IF AVAIL unid_negoc THEN
                           ASSIGN c-unid-neg  = unid_negoc.cod_unid_negoc
                                  c-desc-unid = unid_negoc.des_unid_negoc.
                       ELSE
                           ASSIGN c-unid-neg  = "Material de Consumo"
                                  c-desc-unid = "Material de Consumo".                       
                       
                   end. 

                   RUN pi-grava-tt-calcula-devolucao   (INPUT ped-item-segmentos.cod-segmento,
                                                        INPUT ped-item-segmentos.val-percentual).
               END.
           END.
           ELSE DO:
               RUN pi-grava-tt-calcula-devolucao   (INPUT substring(ITEM.fm-cod-com,1,4),
                                                    INPUT 100).
           END.
       END.
END PROCEDURE. /****** FIM PROCEDURE PI-CRIA-TT-CALCULA-DEVOL. ********/
  
procedure pi-busca-preco:
   def input  param c-item     as char    no-undo.
   def input  param da-periodo as date    no-undo.
   def output param de-mat     as decimal no-undo.
   def output param de-mob     as decimal no-undo.
   find FIRST pr-it-per 
        where pr-it-per.it-codigo = c-item
        AND   pr-it-per.cod-estabel = nota-fiscal.cod-estabel
        and   pr-it-per.periodo     = da-periodo no-lock no-error.

   if avail pr-it-per then
      assign de-mat = pr-it-per.val-unit-mat-m[1] 
             de-mob = pr-it-per.val-unit-mob-m[1] + 
                      pr-it-per.val-unit-ggf-m[1].
   else do:
      find last pr-it-per 
           where pr-it-per.it-codigo = c-item
           AND   pr-it-per.cod-estabel = nota-fiscal.cod-estabel
           and pr-it-per.periodo < da-periodo no-lock no-error.
      if avail pr-it-per then
         assign de-mat = pr-it-per.val-unit-mat-m[1] 
                de-mob = pr-it-per.val-unit-mob-m[1] +
                         pr-it-per.val-unit-ggf-m[1].
      else do:
         find first pr-it-per 
              where pr-it-per.it-codigo = c-item
              AND   pr-it-per.cod-estabel = nota-fiscal.cod-estabel
              and pr-it-per.periodo > da-periodo no-lock no-error.
         if avail pr-it-per then
            assign de-mat = pr-it-per.val-unit-mat-m[1] 
                   de-mob = pr-it-per.val-unit-mob-m[1] + 
                            pr-it-per.val-unit-ggf-m[1].
         else
            assign de-mat = item.vl-mat-ant /*item.val-unit-mat[1]*/
                   de-mob = item.vl-mob-ant /*item.val-unit-mob[1]*/
                            .
      end.         
   end.
END PROCEDURE.

procedure pi-calcula-frete:
    def input  param p-cod-estabel  LIKE nota-fiscal.cod-estabel no-undo.
    def input  param p-serie        LIKE nota-fiscal.serie       no-undo.
    def input  param p-nr-nota-fis  LIKE nota-fiscal.nr-nota-fis no-undo.
    def input  param p-dt-emis-nota LIKE nota-fiscal.dt-emis-nota no-undo.
    def input  param de-tot-item    as decimal no-undo.
    def input  param de-tot-nota    as decimal no-undo.
    DEF INPUT  PARAM l-devolucao       AS LOGICAL NO-UNDO.
    def output param de-vl-frete    as decimal no-undo.
    
    def var de-vl-temp as decimal no-undo.
    DEFINE VARIABLE l-achou AS LOGICAL     NO-UNDO.

    ASSIGN de-vl-frete = 0.
    
    IF c-nr-nota-fis <> p-nr-nota-fis THEN DO:
        ASSIGN de-vl-frete-rateio = 0.

        /* TMS FOR FIRST nota-fiscal-tr NO-LOCK
            WHERE nota-fiscal-tr.cod-estabel = p-cod-estabel
              AND nota-fiscal-tr.cd-serie    = p-serie
              AND nota-fiscal-tr.nr-nf       = int(p-nr-nota-fis):
        
            ASSIGN l-achou = NO.
            FOR EACH docto-frete-nf NO-LOCK
               WHERE docto-frete-nf.cgc-rem  = nota-fiscal-tr.cgc-rem
                 AND docto-frete-nf.nr-nf    = nota-fiscal-tr.nr-nf
                 AND docto-frete-nf.cd-serie = nota-fiscal-tr.cd-serie:
        
                FOR EACH movct-tr NO-LOCK
                   WHERE movct-tr.ep-codigo    = param-global.empresa-pri
                     AND movct-tr.tp-docto     = docto-frete-nf.id-tp-docto
                     AND movct-tr.cod-estabel  = nota-fiscal-tr.cod-estabel
                     AND movct-tr.cnpj-emissor = docto-frete-nf.cnpj-emit
                     AND movct-tr.nr-docto     = INT(docto-frete-nf.nr-documento)
                     AND movct-tr.cd-serie     = docto-frete-nf.serie
                     AND movct-tr.dt-emissao   = docto-frete-nf.dt-emissao-docto:
        
                    ASSIGN l-achou = YES
                           de-vl-frete-rateio = de-vl-frete-rateio + movct-tr.vl-movimento.
                END.
            END.

            IF NOT l-achou THEN DO:
                /* Obt≤m os valores de frete total da nota por cˇlculo */
                RUN getValFreteRat IN h-botr098rat (INPUT ROWID(nota-fiscal-tr),
                                                    OUTPUT TABLE tt-rat-notas-precon).

                FOR EACH tt-rat-notas-precon:
                    ASSIGN de-vl-frete-rateio = de-vl-frete-rateio + tt-rat-notas-precon.de-frete-total.
                    DELETE tt-rat-notas-precon.
                END.
            END.
        END.*/
    END.

    IF c-nr-nota-fis = "" THEN
        ASSIGN c-nr-nota-fis = p-nr-nota-fis.

    ASSIGN de-vl-frete = de-vl-frete-rateio * (de-tot-item / de-tot-nota).
end.

PROCEDURE piCriaErro:
    DEFINE INPUT PARAM pNumero AS INT  NO-UNDO.
    DEFINE INPUT PARAM pMsg    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = 1
           tt-erro.cd-erro  = pNumero 
           tt-erro.mensagem = pMsg.
END.

PROCEDURE pi_cria_leitura:

    DEF INPUT PARAMETER p_cod_estab_ini    AS CHAR.
    DEF INPUT PARAMETER p_cod_estab_fim    AS CHAR.
    DEF INPUT PARAMETER p_cod_cta_ctbl_ini AS CHAR.
    DEF INPUT PARAMETER p_cod_cta_ctbl_fim AS CHAR.
    DEF INPUT PARAMETER p_dat_refer        AS DATE.

    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Estabelecimento Inicial"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_estab_ini
           tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
           tt_input_leitura_sdo.ttv_num_seq_2    = 2.

    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Estabelecimento Final"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_estab_fim
           tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
           tt_input_leitura_sdo.ttv_num_seq_2    = 3.
    
    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Finalidade EconÀmica"
           tt_input_leitura_sdo.ttv_des_conteudo = 'Corrente'
           tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
           tt_input_leitura_sdo.ttv_num_seq_2    = 4. 
    
    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Inicial"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_cta_ctbl_ini
           tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
           tt_input_leitura_sdo.ttv_num_seq_2    = 5.
    
    CREATE tt_input_leitura_sdo. 
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Conta Contabil Final"
           tt_input_leitura_sdo.ttv_des_conteudo = p_cod_cta_ctbl_fim
           tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
           tt_input_leitura_sdo.ttv_num_seq_2    = 6.
    
    CREATE tt_input_leitura_sdo.
    ASSIGN tt_input_leitura_sdo.ttv_cod_label    = "Data Final"
           tt_input_leitura_sdo.ttv_des_conteudo = string(p_dat_refer, '99/99/9999')
           tt_input_leitura_sdo.ttv_num_seq_1    = v_num_seq
           tt_input_leitura_sdo.ttv_num_seq_2    = 7.

END.

PROCEDURE pi-limpa-tabelas-saldo:

    FOR EACH tt_input_leitura_sdo:
        DELETE tt_input_leitura_sdo.
    END.

    FOR EACH tt_retorna_sdo_ctbl:
        DELETE tt_retorna_sdo_ctbl.
    END.

    FOR EACH tt_log_erros:
        DELETE tt_log_erros.
    END.
                            
END PROCEDURE.

PROCEDURE pi-ajustes:
    DEFINE VARIABLE c-unidade AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-valor-calc AS DECIMAL     NO-UNDO.

    FOR EACH tt-indicadores:
        DELETE tt-indicadores.
    END.

    FOR EACH tt-contab-indicadores:
        DELETE tt-contab-indicadores.
    END.

    /*/*******************************************/
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 1
           tt-indicadores.sequencia = 1
           tt-indicadores.conta     = "33130000".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 1
           tt-indicadores.sequencia = 2
           tt-indicadores.conta     = "33130005".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 1
           tt-indicadores.sequencia = 3
           tt-indicadores.conta     = "33140000".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 1
           tt-indicadores.sequencia = 4
           tt-indicadores.conta     = "33140005".
    /*******************************************/
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 2
           tt-indicadores.sequencia = 1
           tt-indicadores.conta     = "33120020".
    /*******************************************/
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 3
           tt-indicadores.sequencia = 1
           tt-indicadores.conta     = "33270020".
    /*******************************************/
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 4
           tt-indicadores.sequencia = 1
           tt-indicadores.conta     = "33320000".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 4
           tt-indicadores.sequencia = 2
           tt-indicadores.conta     = "33320005".
    /*******************************************/
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 5
           tt-indicadores.sequencia = 1
           tt-indicadores.conta     = "33370000".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 5
           tt-indicadores.sequencia = 2
           tt-indicadores.conta     = "33370005".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 5
           tt-indicadores.sequencia = 3
           tt-indicadores.conta     = "33370010".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 5
           tt-indicadores.sequencia = 4
           tt-indicadores.conta     = "33370045".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 5
           tt-indicadores.sequencia = 5
           tt-indicadores.conta     = "33380000".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 5
           tt-indicadores.sequencia = 6
           tt-indicadores.conta     = "33380005".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 5
           tt-indicadores.sequencia = 7
           tt-indicadores.conta     = "33380010".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 5
           tt-indicadores.sequencia = 8
           tt-indicadores.conta     = "33380015".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 5
           tt-indicadores.sequencia = 9
           tt-indicadores.conta     = "33390000".
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 5
           tt-indicadores.sequencia = 10
           tt-indicadores.conta     = "33390005".*/

    /*/*ICMS Cred. Presumido Importacao*/
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 6
           tt-indicadores.sequencia = 1
           tt-indicadores.conta     = "32210008".

    /*ICMS Cred. Presumido*/
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 7
           tt-indicadores.sequencia = 1
           tt-indicadores.conta     = "32220008".*/

    /*Verba Propaganda Comercial - VPC*/
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 8
           tt-indicadores.sequencia = 1
           tt-indicadores.conta     = /*"41110025"*/ "41420055".

    /*/*Acordo Comercial*/
    CREATE tt-indicadores.
    ASSIGN tt-indicadores.indicador = 9
           tt-indicadores.sequencia = 1
           tt-indicadores.conta     = "41110028".*/

    /*******************************************/

    FOR EACH tt-indicadores NO-LOCK:
        RUN pi-limpa-tabelas-saldo.

        ASSIGN v_num_seq = v_num_seq + 1.
        RUN pi_cria_leitura (INPUT '',
                             INPUT 'zzz',
                             INPUT tt-indicadores.conta,
                             INPUT tt-indicadores.conta,
                             INPUT dt-saldo).

        RUN prgfin/fgl/fgl905zb.py (INPUT 1,
                                    INPUT  TABLE tt_input_leitura_sdo,
                                    OUTPUT TABLE tt_retorna_sdo_ctbl,
                                    OUTPUT TABLE tt_log_erros).      

        
        FOR EACH tt_retorna_sdo_ctbl NO-LOCK 
           WHERE tt_retorna_sdo_ctbl.tta_cod_estab = tt-param.cod-estab-ini
            BREAK BY tta_cod_cta_ctbl:

            ASSIGN c-unidade = tt_retorna_sdo_ctbl.tta_cod_unid_negoc.

            /*IF tt_retorna_sdo_ctbl.tta_cod_estab = "102" THEN
                ASSIGN c-unidade = ""*/

            IF tt-indicadores.indicador = 1 THEN /*Joga valor total na icorp*/
                ASSIGN c-unidade = "CEN".

            IF tt-indicadores.indicador = 3 THEN /*Joga valor total na tot depois vai ratear 50% icorp e icon*/
                ASSIGN c-unidade = "TOT".

            FIND FIRST tt-contab-indicadores NO-LOCK
                 WHERE tt-contab-indicadores.indicador    = tt-indicadores.indicador
                   AND tt-contab-indicadores.cod-unid-neg = c-unidade NO-ERROR.
            IF NOT AVAIL tt-contab-indicadores THEN DO:
                CREATE tt-contab-indicadores.
                ASSIGN tt-contab-indicadores.indicador    = tt-indicadores.indicador
                       tt-contab-indicadores.cod-unid-neg = c-unidade.
            END.
            ASSIGN tt-contab-indicadores.valor = tt-contab-indicadores.valor + (tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_db - tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_cr).

        /*    DISP /*tta_num_seq                     
                 tta_cod_empresa                 
                 tta_cod_finalid_econ            
                 tta_cod_plano_cta_ctbl          */
                 tta_cod_cta_ctbl                
                 /*tta_cod_plano_ccusto            
                 tta_cod_ccusto                  
                 tta_cod_proj_financ             
                 tta_cod_cenar_ctbl              */
                 tta_cod_estab                   
                 tta_cod_unid_negoc              
                 /*tta_dat_sdo_ctbl                */
                 /*tta_val_sdo_ctbl_db             
                 tta_val_sdo_ctbl_cr             */
                 tta_val_sdo_ctbl_fim format "->>>>,>>>,>>>,>>9.99" (TOTAL)  
                 /*tta_val_apurac_restdo           
                 tta_val_apurac_restdo_db        
                 tta_val_apurac_restdo_cr        
                 tta_val_apurac_restdo_acum      
                 tta_val_sdo_ctbl_db_sint        
                 tta_val_sdo_ctbl_cr_sint        
                 tta_val_sdo_ctbl_fim_sint       
                 tta_val_apurac_restdo_sint      
                 tta_val_apurac_restdo_sint_db   
                 tta_val_apurac_restdo_sint_cr   
                 tta_val_apurac_restdo_sint_acum */
                 /*tta_val_movto_empenh            
                 tta_qtd_sdo_ctbl_db             
                 tta_qtd_sdo_ctbl_cr             
                 tta_qtd_sdo_ctbl_fim            /
                 ttv_val_movto_ctbl              
                 tta_qtd_movto_empenh            */
                /*tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_db - tt_retorna_sdo_ctbl.tta_val_sdo_ctbl_cr*/ .
            */
        END.

    END.

    /*****************Criando registros ajustes*****************************************************************/

    /*
    /*indicador 1*/
    FOR EACH tt-contab-indicadores WHERE tt-contab-indicadores.indicador = 1 AND tt-contab-indicadores.valor <> 0:
        CREATE tt-calcula.
        ASSIGN tt-calcula.ajustes      = YES
               tt-calcula.tipo         = 1
               tt-calcula.cod-estabel  = tt-param.cod-estab-ini
               tt-calcula.c-mercado    = "Interno"
               tt-calcula.c-origem     = "indicador1"
               tt-calcula.unid-neg     = tt-contab-indicadores.cod-unid-neg
               tt-calcula.custo-mat    = tt-contab-indicadores.valor.
    END.

    /*indicador 2*/
    FOR EACH tt-contab-indicadores WHERE tt-contab-indicadores.indicador = 2 AND tt-contab-indicadores.valor <> 0:
        CREATE tt-calcula.
        ASSIGN tt-calcula.ajustes      = YES
               tt-calcula.tipo         = 1
               tt-calcula.cod-estabel  = tt-param.cod-estab-ini
               tt-calcula.c-mercado    = "Interno"
               tt-calcula.c-origem     = "indicador2"
               tt-calcula.unid-neg     = tt-contab-indicadores.cod-unid-neg
               tt-calcula.custo-mat    = tt-contab-indicadores.valor.
    END.

    /*indicador 3*/
    FOR EACH tt-contab-indicadores WHERE tt-contab-indicadores.indicador = 3 AND tt-contab-indicadores.valor <> 0:
        CREATE tt-calcula.
        ASSIGN tt-calcula.ajustes      = YES
               tt-calcula.tipo         = 1
               tt-calcula.cod-estabel  = tt-param.cod-estab-ini
               tt-calcula.c-mercado    = "Interno"
               tt-calcula.c-origem     = "indicador3"
               tt-calcula.unid-neg     = "CEN"
               tt-calcula.custo-mat    = tt-contab-indicadores.valor / 2.

        CREATE tt-calcula.
        ASSIGN tt-calcula.ajustes      = YES
               tt-calcula.tipo         = 1
               tt-calcula.cod-estabel  = tt-param.cod-estab-ini
               tt-calcula.c-mercado    = "Interno"
               tt-calcula.c-origem     = "indicador3"
               tt-calcula.unid-neg     = "TER"
               tt-calcula.custo-mat    = tt-contab-indicadores.valor / 2.
    END.
    /*indicador 4*/

    /*indicador 5*/
    FOR EACH tt-contab-indicadores WHERE tt-contab-indicadores.indicador = 5 AND tt-contab-indicadores.valor <> 0:
    /*    IF tt-contab-indicadores.cod-unid-neg = "ADM" THEN DO:

        END.
        ELSE DO:*/
            CREATE tt-calcula.
            ASSIGN tt-calcula.ajustes      = YES
                   tt-calcula.tipo         = 1
                   tt-calcula.cod-estabel  = tt-param.cod-estab-ini
                   tt-calcula.c-mercado    = "Interno"
                   tt-calcula.c-origem     = "indicador5"
                   tt-calcula.unid-neg     = tt-contab-indicadores.cod-unid-neg
                   tt-calcula.custo-mat    = tt-contab-indicadores.valor.
        /*END.*/
    END.

    /*ICMS Cred. Presumido Importacao*/
    FOR EACH tt-contab-indicadores WHERE tt-contab-indicadores.indicador = 6 AND tt-contab-indicadores.valor <> 0:
        FIND FIRST tt-tot-unid NO-LOCK
             WHERE tt-tot-unid.cod-estabel  = tt-param.cod-estab-ini
               AND tt-tot-unid.cod-unid-neg = tt-contab-indicadores.cod-unid-neg NO-ERROR.
        IF NOT AVAIL tt-tot-unid THEN DO:
            CREATE tt-calcula.
            ASSIGN tt-calcula.ajustes      = YES
                   tt-calcula.tipo         = 1
                   tt-calcula.cod-estabel  = tt-param.cod-estab-ini
                   tt-calcula.c-mercado    = "Interno"
                   tt-calcula.c-origem     = "indicador6"
                   tt-calcula.unid-neg     = tt-contab-indicadores.cod-unid-neg
                   tt-calcula.vl-icms-cpi  = tt-contab-indicadores.valor.
        END.
        ELSE DO:
            IF ABS(tt-contab-indicadores.valor) <> ABS(tt-tot-unid.valor[2]) THEN DO:
                CREATE tt-calcula.
                ASSIGN tt-calcula.ajustes      = YES
                       tt-calcula.tipo         = 1
                       tt-calcula.cod-estabel  = tt-param.cod-estab-ini
                       tt-calcula.c-mercado    = "Interno"
                       tt-calcula.c-origem     = "indicador6"
                       tt-calcula.unid-neg     = tt-contab-indicadores.cod-unid-neg
                       tt-calcula.vl-icms-cpi  = ABS(tt-contab-indicadores.valor) - ABS(tt-tot-unid.valor[2]).
            END.
        END.
    END.

    /*ICMS Cred. Presumido*/
    FOR EACH tt-contab-indicadores WHERE tt-contab-indicadores.indicador = 7 AND tt-contab-indicadores.valor <> 0:
        FIND FIRST tt-tot-unid NO-LOCK
             WHERE tt-tot-unid.cod-estabel  = tt-param.cod-estab-ini
               AND tt-tot-unid.cod-unid-neg = tt-contab-indicadores.cod-unid-neg NO-ERROR.
        IF NOT AVAIL tt-tot-unid THEN DO:
            CREATE tt-calcula.
            ASSIGN tt-calcula.ajustes      = YES
                   tt-calcula.tipo         = 1
                   tt-calcula.cod-estabel  = tt-param.cod-estab-ini
                   tt-calcula.c-mercado    = "Interno"
                   tt-calcula.c-origem     = "indicador7"
                   tt-calcula.unid-neg     = tt-contab-indicadores.cod-unid-neg
                   tt-calcula.vl-icms-cp   = tt-contab-indicadores.valor.
        END.
        ELSE DO:
            IF ABS(tt-contab-indicadores.valor) <> ABS(tt-tot-unid.valor[3]) THEN DO:
                CREATE tt-calcula.
                ASSIGN tt-calcula.ajustes      = YES
                       tt-calcula.tipo         = 1
                       tt-calcula.cod-estabel  = tt-param.cod-estab-ini
                       tt-calcula.c-mercado    = "Interno"
                       tt-calcula.c-origem     = "indicador7a"
                       tt-calcula.unid-neg     = tt-contab-indicadores.cod-unid-neg
                       tt-calcula.vl-icms-cp   = ABS(tt-contab-indicadores.valor) - ABS(tt-tot-unid.valor[3]).
            END.
        END.
    END.*/

    /*VPC*/
    FOR EACH tt-contab-indicadores WHERE tt-contab-indicadores.indicador = 8 AND tt-contab-indicadores.valor <> 0:

        FIND FIRST unid_negoc NO-LOCK
             WHERE unid_negoc.cod_unid_negoc = tt-contab-indicadores.cod-unid-neg NO-ERROR.

        IF AVAIL unid_negoc THEN
            FIND FIRST fam-com-item NO-LOCK
                 WHERE fam-com-item.unidade = STRING(unid_negoc.cdn_unid_negoc) NO-ERROR.

        FIND FIRST tt-tot-unid NO-LOCK
             WHERE tt-tot-unid.cod-estabel  = tt-param.cod-estab-ini
               AND tt-tot-unid.cod-unid-neg = tt-contab-indicadores.cod-unid-neg NO-ERROR.
        IF NOT AVAIL tt-tot-unid THEN DO:
            CREATE tt-calcula.
            ASSIGN tt-calcula.ajustes        = YES
                   tt-calcula.tipo           = 1
                   tt-calcula.cod-estabel    = tt-param.cod-estab-ini
                   tt-calcula.c-mercado      = "Interno"
                   tt-calcula.c-origem       = "VPC"
                   tt-calcula.unid-neg       = tt-contab-indicadores.cod-unid-neg
                   tt-calcula.descricao-un   = IF AVAIL unid_negoc THEN unid_negoc.des_unid_negoc ELSE "Material de Consumo"
                   tt-calcula.c-desc-grupo   = "Ajustes - " + IF AVAIL unid_negoc THEN unid_negoc.des_unid_negoc ELSE tt-contab-indicadores.cod-unid-neg
                   tt-calcula.cgc            = "00000000"
                   tt-calcula.nome-abrev     = "00000000"
                   tt-calcula.cod-emitente   = 0
                   tt-calcula.nome-matriz    = "00000000"
                   tt-calcula.cod-gr-cli     = 0
                   tt-calcula.fm-cod-com     = IF AVAIL fam-com-item THEN fam-com-item.unidade + fam-com-item.segmento + "9999" ELSE "00000000"
                   tt-calcula.c-desc-familia = "Ajustes"
                   tt-calcula.nome-repres    = "1"
                   tt-calcula.estado         = "SC"
                   tt-calcula.pais           = "Brasil"
                   tt-calcula.it-codigo      = tt-calcula.fm-cod-com
                   tt-calcula.descricao      = "VPC"
                   tt-calcula.vpc            = tt-contab-indicadores.valor.
        END.
        ELSE DO:
            IF ABS(tt-contab-indicadores.valor) <> ABS(tt-tot-unid.valor[4]) THEN DO:
                CREATE tt-calcula.
                ASSIGN tt-calcula.ajustes        = YES
                       tt-calcula.tipo           = 1
                       tt-calcula.cod-estabel    = tt-param.cod-estab-ini 
                       tt-calcula.c-mercado      = "Interno"
                       tt-calcula.c-origem       = "VPC"
                       tt-calcula.unid-neg       = tt-contab-indicadores.cod-unid-neg
                       tt-calcula.descricao-un   = IF AVAIL unid_negoc THEN unid_negoc.des_unid_negoc ELSE "Material de Consumo"
                       tt-calcula.c-desc-grupo   = "Ajustes - " + IF AVAIL unid_negoc THEN unid_negoc.des_unid_negoc ELSE tt-contab-indicadores.cod-unid-neg
                       tt-calcula.cgc            = "00000000"
                       tt-calcula.nome-abrev     = "00000000"
                       tt-calcula.cod-emitente   = 0
                       tt-calcula.nome-matriz    = "00000000"
                       tt-calcula.cod-gr-cli     = 0
                       tt-calcula.fm-cod-com     = IF AVAIL fam-com-item THEN fam-com-item.unidade + fam-com-item.segmento + "9999" ELSE "00000000"
                       tt-calcula.c-desc-familia = "Ajustes"
                       tt-calcula.nome-repres    = "1"
                       tt-calcula.estado         = "SC"
                       tt-calcula.pais           = "Brasil"
                       tt-calcula.it-codigo      = tt-calcula.fm-cod-com
                       tt-calcula.descricao      = "VPC"
                       tt-calcula.vpc            = ABS(tt-contab-indicadores.valor) - ABS(tt-tot-unid.valor[4]).
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-gera-totais:
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

    /*FOR EACH tt-calcula:
        
        FIND FIRST tt-tot-unid NO-LOCK
             WHERE tt-tot-unid.cod-estabel  = tt-calcula.cod-estabel
               AND tt-tot-unid.cod-unid-neg = tt-calcula.unid-neg NO-ERROR.
        IF NOT AVAIL tt-tot-unid THEN DO:
            CREATE tt-tot-unid.
            ASSIGN tt-tot-unid.cod-estabel  = tt-calcula.cod-estabel
                   tt-tot-unid.cod-unid-neg = tt-calcula.unid-neg.
        END.

        ASSIGN tt-tot-unid.valor[2] = tt-tot-unid.valor[2] + tt-calcula.vl-icms-cpi * (IF tt-calcula.tipo = 1 THEN 1 ELSE -1) /*ICMS credito presumido importacao*/
               tt-tot-unid.valor[3] = tt-tot-unid.valor[3] + tt-calcula.vl-icms-cp  * (IF tt-calcula.tipo = 1 THEN 1 ELSE -1) /*ICMS credito presumido*/
               tt-tot-unid.valor[5] = tt-tot-unid.valor[5] + tt-calcula.vl-acordo                                             /*acordo comercial*/.

        /*FIND FIRST tt-total-vpc NO-LOCK
             WHERE tt-total-vpc.cod-estabel  = tt-calcula.cod-estabel
               AND tt-total-vpc.raiz-cnpj    = tt-calcula.cgc
               AND tt-total-vpc.cod-unid-neg = tt-calcula.unid-neg NO-ERROR.
        IF NOT AVAIL tt-total-vpc THEN DO:
            CREATE tt-total-vpc.
            ASSIGN tt-total-vpc.cod-estabel  = tt-calcula.cod-estabel
                   tt-total-vpc.raiz-cnpj    = tt-calcula.cgc
                   tt-total-vpc.cod-unid-neg = tt-calcula.unid-neg.
        END.
        ASSIGN tt-total-vpc.valor = tt-total-vpc.valor + tt-calcula.rec-sem-ipi + tt-calcula.rec-sem-ipi.*/
    END.*/

END PROCEDURE.

PROCEDURE pi-calcula-vpc:
    FOR EACH vpc NO-LOCK
       WHERE vpc.cod-estabel >= tt-param.cod-estab-ini
         AND vpc.cod-estabel <= tt-param.cod-estab-fim
         AND vpc.data-trans  >= tt-param.da-data-ini
         AND vpc.data-trans  <= tt-param.da-data-fim
         AND vpc.tipo-verba   = 1: /*somente vpc*/

        IF vpc.situacao <> 1 AND vpc.situacao <> 2 THEN NEXT. /*somente liberada ou finalizada*/

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = vpc.cod-emitente NO-ERROR.
        IF NOT AVAIL emitente THEN NEXT.

        FIND FIRST tit_ap NO-LOCK
             WHERE tit_ap.cod_estab       = vpc.cod-estabel
               AND tit_ap.cdn_fornecedor  = vpc.cod-emitente
               AND tit_ap.cod_espec_docto = vpc.cod-esp
               AND tit_ap.cod_ser_docto   = vpc.serie
               AND tit_ap.cod_tit_ap      = vpc.nro-docto
               AND tit_ap.cod_parcela     = "01" NO-ERROR.
        IF AVAIL tit_ap THEN DO:
            IF CAN-FIND(FIRST movto_tit_ap OF tit_ap NO-LOCK
                        WHERE movto_tit_ap.ind_trans_ap = "implantaá∆o"
                          AND movto_tit_ap.dat_transacao >= tt-param.da-data-ini 
                          AND movto_tit_ap.dat_transacao <= tt-param.da-data-fim ) THEN DO:

                FOR EACH vpc-rateio NO-LOCK
                    WHERE vpc-rateio.nr-vpc = vpc.nr-vpc:
                
                    FIND FIRST tt-vpc NO-LOCK
                         WHERE tt-vpc.cod-estabel  = vpc.cod-estabel
                           AND tt-vpc.raiz-cnpj    = SUBSTRING(emitente.cgc,1,8)
                           AND tt-vpc.cod-unid-neg = vpc-rateio.cod-unid-negoc NO-ERROR.
                    IF NOT AVAIL tt-vpc THEN DO:
                        CREATE tt-vpc.
                        ASSIGN tt-vpc.cod-estabel  = vpc.cod-estabel
                               tt-vpc.raiz-cnpj    = SUBSTRING(emitente.cgc,1,8)
                               tt-vpc.cod-unid-neg = vpc-rateio.cod-unid-negoc.
                    END.
                    /*ASSIGN tt-vpc.valor = tt-vpc.valor + vpc.valor.*/
                    ASSIGN tt-vpc.valor = tt-vpc.valor + vpc-rateio.valor.
                END.

            END.
        END.
    END.
    FIND b-emitente
        WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-LOCK NO-ERROR.
    FOR EACH tt-vpc WHERE tt-vpc.valor <> 0:
        FIND FIRST tt-calcula NO-LOCK
         WHERE tt-calcula.ajustes     = YES                 
           AND tt-calcula.tipo        = 1                   
           AND tt-calcula.cod-estabel = (IF tt-vpc.cod-estabel = "104" THEN "101" ELSE tt-vpc.cod-estabel)  
           AND tt-calcula.c-mercado   = "Interno"           
           AND tt-calcula.c-origem    = "VPC"       
           AND tt-calcula.cgc         = tt-vpc.raiz-cnpj
           AND tt-calcula.unid-neg    = tt-vpc.cod-unid-neg NO-ERROR.

        FIND FIRST emitente USE-INDEX cgc NO-LOCK  
             WHERE emitente.cgc BEGINS tt-vpc.raiz-cnpj
               AND emitente.natureza = 2 NO-ERROR.
    
        FIND FIRST unid_negoc NO-LOCK
             WHERE unid_negoc.cod_unid_negoc = tt-vpc.cod-unid-neg NO-ERROR.

        FIND FIRST fam-com-item NO-LOCK
             WHERE fam-com-item.unidade = STRING(unid_negoc.cdn_unid_negoc) NO-ERROR.

        IF NOT AVAIL tt-calcula THEN DO:
            CREATE tt-calcula.
            ASSIGN tt-calcula.ajustes        = YES
                   tt-calcula.tipo           = 1
                   tt-calcula.cod-estabel    = tt-vpc.cod-estabel
                   tt-calcula.c-mercado      = "Interno"
                   tt-calcula.c-origem       = "IND"
                   tt-calcula.c-desc-grupo   = "Ajustes - " + unid_negoc.des_unid_negoc
                   tt-calcula.cgc            = tt-vpc.raiz-cnpj
                   tt-calcula.unid-neg       = (IF AVAIL ped-venda AND substr(ped-venda.nat-operacao,1,1) = "7" AND emitente.natureza > 2 THEN "EXPO" ELSE tt-vpc.cod-unid-neg)
                   tt-calcula.descricao-un   = IF AVAIL unid_negoc THEN unid_negoc.des_unid_negoc ELSE "Material de Consumo"
                   tt-calcula.nome-abrev     = emitente.nome-abrev
                   tt-calcula.cod-emitente   = emitente.cod-emitente
                   tt-calcula.nome-matriz    = b-emitente.nome-emit
                   tt-calcula.cod-gr-cli     = emitente.cod-gr-cli
                   tt-calcula.fm-cod-com     = IF AVAIL fam-com-item THEN fam-com-item.unidade + fam-com-item.segmento + "9999" ELSE "00000000"
                   tt-calcula.c-desc-familia = "Ajustes"
                   tt-calcula.nome-repres    = "1"
                   tt-calcula.estado         = "SC"
                   tt-calcula.pais           = "Brasil"
                   tt-calcula.it-codigo      = tt-calcula.fm-cod-com
                   tt-calcula.descricao      = "VPC".
        END.
        ASSIGN tt-calcula.vpc = tt-calcula.vpc + tt-vpc.valor.


        FIND FIRST tt-tot-unid NO-LOCK
             WHERE tt-tot-unid.cod-estabel  = tt-calcula.cod-estabel
               AND tt-tot-unid.cod-unid-neg = tt-calcula.unid-neg NO-ERROR.
        IF NOT AVAIL tt-tot-unid THEN DO:
            CREATE tt-tot-unid.
            ASSIGN tt-tot-unid.cod-estabel  = tt-calcula.cod-estabel
                   tt-tot-unid.cod-unid-neg = tt-calcula.unid-neg.
        END.
        ASSIGN tt-tot-unid.valor[4] = tt-tot-unid.valor[4] + tt-vpc.valor /*VPC*/.

    END.    
END PROCEDURE.

PROCEDURE pi-grava-tt-calcula-faturamento:
       DEF INPUT PARAMETER pi-cod-segmento   AS CHARACTER NO-UNDO.
       DEF INPUT PARAMETER pi-val-percentual AS DEC       NO-UNDO.
       
       DEF VAR c-descricao-segmento AS CHAR NO-UNDO.
       DEF VAR c-descricao-semento-ant AS CHAR NO-UNDO.

       ASSIGN c-vertical = "PADRAO".
       
       FOR FIRST grupo-canais-clientes NO-LOCK
           WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli,
           FIRST grupo-canais NO-LOCK
           WHERE grupo-canais.cod-gr-canais = grupo-canais-clientes.cod-gr-canais:
           ASSIGN c-vertical = grupo-canais.descricao.
       END.
       
       IF  AVAIL ped-venda 
       THEN DO:
           FOR FIRST  int-ped-venda2 NO-LOCK
                WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
                  AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido
                  AND int-ped-venda2.int-1      <> 0,
               FIRST grupo-canais NO-LOCK
               WHERE grupo-canais.cod-gr-canais = int-ped-venda2.int-1:
               ASSIGN c-vertical = grupo-canais.descricao.
           END.
       END.
    
       /*------------------------- Chamado 67298 ----------------------------------- */
       ASSIGN c-descricao-segmento = fn-retorna-descricao-segmento(pi-cod-segmento).

       IF  c-descricao-segmento = 'Partes e Pecas - ICON' AND nota-fiscal.cod-estabel = "105" THEN
           ASSIGN c-descricao-segmento = "Interfonia e Monitoramento".
       ELSE
           IF  c-descricao-segmento BEGINS 'Partes e Pecas' THEN DO:
               CASE c-unid-neg:
                   WHEN 'AUT' THEN ASSIGN c-descricao-segmento = "Controle de Acesso Condominial".
                   WHEN 'TER' THEN ASSIGN c-descricao-segmento = "Comunicacao HO".
                   WHEN 'SEC' THEN ASSIGN c-descricao-segmento = "Captacao de Imagem".
                   WHEN 'NET' THEN ASSIGN c-descricao-segmento = "Redes Empresariais".
                   WHEN 'FIR' THEN ASSIGN c-descricao-segmento = "Incendio e Iluminacao".
                   WHEN 'ACE' THEN ASSIGN c-descricao-segmento = "Acessorios Corporativos".
                   WHEN 'AUT' THEN ASSIGN c-descricao-segmento = "Controle de Acesso Condominial".
                   WHEN 'ENG' THEN ASSIGN c-descricao-segmento = "Nobreaks".
               END CASE.
           END.
    
       ASSIGN c-unid-neg-subst = fn-retorna-desc-unidade(c-unid-neg).

       /* Mercado Externo */
       /*IF  AVAIL ped-venda AND substr(ped-venda.nat-operacao,1,1) = "7" AND emitente.natureza > 2 THEN*/
        IF  AVAIL ped-venda AND ped-venda.tp-pedido = "70" 
        OR  NOT AVAIL ped-venda AND nota-fiscal.estado = "ex" THEN
            ASSIGN c-unid-neg       = "EXPO"
                   c-desc-unid      = "EXPO".
       
        ASSIGN c-descricao-semento-ant = c-descricao-segmento.

       IF  emitente.cod-emitente = 105068 then
           ASSIGN pi-cod-segmento      = "T.MêXICO"
                  c-descricao-segmento = "T.MêXICO".
       ELSE
           IF  c-desc-unid = "EXPO" THEN
               ASSIGN pi-cod-segmento      = "Outros Pa°ses"
                      c-descricao-segmento = "Outros Pa°ses".

/*         ELSE                                                                           */
/*             ASSIGN pi-cod-segmento =  fn-retorna-cod-segmento (c-descricao-segmento).  */
       
       /*-----------------------------------------------------------------------------*/

       IF tt-param.l-imp-nota THEN
          find first  tt-calcula 
                where tt-calcula.tipo         = 1 
                AND   tt-calcula.cod-estabel  = (IF nota-fiscal.cod-estabel = "104" THEN "101" ELSE nota-fiscal.cod-estabel)
                and   tt-calcula.unid-neg     = c-unid-neg
                and   tt-calcula.nome-abrev   = emitente.nome-abrev
                AND   tt-calcula.cod-gr-cli   = emitente.cod-gr-cli
                and   tt-calcula.fm-cod-com   = ITEM.fm-cod-com
                and   tt-calcula.it-codigo    = it-nota-fisc.it-codigo 
                AND   tt-calcula.nr-nota-fis  = nota-fiscal.nr-nota-fis
                AND   tt-calcula.serie        = nota-fiscal.serie
               /* AND   tt-calcula.nr-seq-fat   = it-nota-fisc.nr-seq-fat */
                AND   tt-calcula.cod-rep      = nota-fiscal.cod-rep 
                AND   tt-calcula.cod-segmento = pi-cod-segmento 
                AND   tt-calcula.c-vertical   = c-vertical no-error.
       ELSE
           find first  tt-calcula 
                 where tt-calcula.tipo         = 1 
                 AND   tt-calcula.cod-estabel  = (IF nota-fiscal.cod-estabel = "104" THEN "101" ELSE nota-fiscal.cod-estabel)
                 and   tt-calcula.unid-neg     = c-unid-neg
                 and   tt-calcula.nome-abrev   = emitente.nome-abrev
                 AND   tt-calcula.cod-gr-cli   = emitente.cod-gr-cli
                 and   tt-calcula.fm-cod-com   = ITEM.fm-cod-com
                 and   tt-calcula.it-codigo    = it-nota-fisc.it-codigo 
                 AND   tt-calcula.nr-nota-fis  = nota-fiscal.nr-nota-fis
                 AND   tt-calcula.serie        = nota-fiscal.serie
               /*  AND   tt-calcula.nr-seq-fat   = it-nota-fisc.nr-seq-fat */
                 AND   tt-calcula.cod-rep      = nota-fiscal.cod-rep 
                 AND   tt-calcula.cod-segmento = pi-cod-segmento 
                 AND   tt-calcula.c-vertical   = c-vertical no-error.
    
       FIND b-emitente
           WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-LOCK NO-ERROR.
    
       if not avail tt-calcula then do:
    
           /*Somente pessoa juridica pega a matriz do primeiro cgc cadastrado*/
           IF emitente.natureza = 2 THEN
               FIND FIRST b-emitente USE-INDEX cgc NO-LOCK  
                    WHERE b-emitente.cgc BEGINS SUBSTRING(emitente.cgc,1,8)
                      AND b-emitente.natureza = 2 NO-ERROR.
    
          find first int-familia 
               where int-familia.fm-codigo = item.fm-codigo no-lock no-error.

          FIND FIRST int-nota-fiscal
               WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                 AND int-nota-fiscal.serie       = nota-fiscal.serie
                 AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
    
    
          create tt-calcula.
          assign tt-calcula.tipo = 1
                 tt-calcula.cod-estabel   = (IF nota-fiscal.cod-estabel = "104" THEN "101" ELSE nota-fiscal.cod-estabel)
                 tt-calcula.c-mercado     = IF /*nota-fiscal.estado = "ex"*/ c-desc-unid = "EXPO" THEN "Externo" ELSE "Interno"
                 tt-calcula.c-origem      = IF item.ge-codigo = 45 THEN "OEM" ELSE "IND"   //f avail int-familia AND int-familia.oem = yes then "OEM" ELSE "IND"
                 tt-calcula.unid-neg      = c-unid-neg
                 tt-calcula.descricao-un  = c-desc-unid
                 tt-calcula.unid-neg-nota      = c-unid-neg-nota
                 tt-calcula.descricao-un-nota  = c-desc-unid-nota
                 tt-calcula.nome-abrev    = emitente.nome-abrev
                 tt-calcula.nome-matriz   = IF AVAIL b-emitente THEN b-emitente.nome-emit ELSE ""
                 tt-calcula.cgc           = substring(emitente.cgc,1,8)
                 tt-calcula.cod-emitente  = emitente.cod-emitente
                 tt-calcula.cod-categoria = IF AVAIL int-ped-venda THEN SUBSTRING(int-ped-venda.char-1,12,3) ELSE ""
                 tt-calcula.cod-rep       = nota-fiscal.cod-rep
                 tt-calcula.nome-repres   = TRIM(STRING(nota-fiscal.cod-rep)) + " - " + nota-fiscal.no-ab-reppri
                 tt-calcula.estado        = nota-fiscal.estado
                 tt-calcula.pais          = nota-fiscal.pais
                 tt-calcula.cod-gr-cli    = emitente.cod-gr-cli
                 tt-calcula.cd-gr-com     = SUBSTRING(ITEM.fm-cod-com,1,7)
                 tt-calcula.fm-cod-com    = ITEM.fm-cod-com
                 tt-calcula.it-codigo     = it-nota-fisc.it-codigo
                 tt-calcula.descricao     = ITEM.desc-item
                 tt-calcula.nr-nota-fis   = nota-fiscal.nr-nota-fis /*WHEN tt-param.l-imp-nota*/
                 tt-calcula.serie         = nota-fiscal.serie
                 tt-calcula.nr-seq-fat    = it-nota-fisc.nr-seq-fat
                 tt-calcula.nr-pedcli     = nota-fiscal.nr-pedcli
                 tt-calcula.dt-emis-nota  = nota-fiscal.dt-emis-nota WHEN tt-param.l-imp-nota
                 tt-calcula.nat-operacao  = it-nota-fisc.nat-operacao
                 tt-calcula.ncm           = it-nota-fisc.class-fiscal
                 tt-calcula.cod-segmento  = pi-cod-segmento
                 tt-calcula.c-vertical    = c-vertical
                 tt-calcula.fm-codigo     = ITEM.fm-codigo
                 tt-calcula.codigo-orig   = ITEM.codigo-orig
                 tt-calcula.consum-final  = natur-oper.consum-final
                 tt-calcula.vl-bicms-it   = tt-calcula.vl-bicms-it + (it-nota-fisc.vl-bicms-it * pi-val-percentual / 100)
                 tt-calcula.cod-estab-substituido = (IF nota-fiscal.cod-estabel = "104" THEN "104" ELSE tt-calcula.cod-estabel) 
                 tt-calcula.unid-neg-substituida  = c-unid-neg-subst
                 tt-calcula.desc-segmento         = c-descricao-segmento
                 tt-calcula.desc-segmento-ant     = c-descricao-semento-ant
                 tt-calcula.de-vl-icms-fcp        = de-vl-icms-fcp
                 tt-calcula.de-vl-icms-uf-dest    = de-vl-icms-uf-dest
                 tt-calcula.de-vl-icms-uf-remet   = de-vl-icms-uf-remet
                 tt-calcula.cod-transp            = IF AVAIL transporte THEN transporte.cod-transp ELSE 0
                 tt-calcula.nome-transp           = IF AVAIL transporte THEN transporte.nome ELSE "Nao encontrado transportadora"
                 tt-calcula.dt-prev-entrega       = IF SUBSTRING(int-nota-fiscal.char-1,50,10) = "" THEN "" ELSE SUBSTRING(int-nota-fiscal.char-1,50,10) WHEN tt-param.l-imp-nota
                 tt-calcula.dt-entrega            = IF nota-fiscal.dt-entr-cli = ? THEN "" ELSE String(DATE(nota-fiscal.dt-entr-cli)) WHEN tt-param.l-imp-nota
                 tt-calcula.cidade                = nota-fiscal.cidade WHEN tt-param.l-imp-nota.
    
          /*familia2*/
          FIND FIRST fam-com-item NO-LOCK
               WHERE fam-com-item.fm-cod-com = tt-calcula.cd-gr-com NO-ERROR.
          IF AVAIL fam-com-item THEN
              ASSIGN tt-calcula.c-desc-grupo = fam-com-item.descricao.
          ELSE
              ASSIGN tt-calcula.c-desc-grupo = tt-calcula.cd-gr-com.
                
          /*produto*/
          FIND FIRST fam-com-item NO-LOCK
               WHERE fam-com-item.fm-cod-com = tt-calcula.fm-cod-com NO-ERROR.
          IF AVAIL fam-com-item THEN
              ASSIGN tt-calcula.c-desc-familia = fam-com-item.descricao.
          ELSE 
              ASSIGN tt-calcula.c-desc-familia = tt-calcula.fm-cod-com.
    
          IF AVAIL ped-venda THEN
              ASSIGN tt-calcula.atendente = ped-venda.tp-pedido.
       end.
              
       if nota-fiscal.ind-tip-nota <> 3 THEN
          assign tt-calcula.qtd          = tt-calcula.qtd + (it-nota-fisc.qt-faturada[1] * pi-val-percentual / 100).
    
       ASSIGN tt-calcula.receita      = tt-calcula.receita + ((it-nota-fisc.vl-tot-item / de-indice-pres) * pi-val-percentual / 100)
              tt-calcula.rec-sem-ipi  = tt-calcula.rec-sem-ipi + (((it-nota-fisc.vl-merc-liq + it-nota-fisc.vl-despes-it) / de-indice-pres) * pi-val-percentual / 100)
              tt-calcula.ipi          = tt-calcula.ipi + ((it-nota-fisc.vl-ipi-it / de-indice-pres) * pi-val-percentual / 100)
              tt-calcula.vl-icms      = tt-calcula.vl-icms + ((it-nota-fisc.vl-icms-it / de-indice-pres) * pi-val-percentual / 100)
              tt-calcula.vl-icms-subs = tt-calcula.vl-icms-sub + ((it-nota-fisc.vl-icmsub-it  / de-indice-pres) * pi-val-percentual / 100) + vlr-fcp
              tt-calcula.vl-iss       = tt-calcula.vl-iss + ((it-nota-fisc.vl-iss-it / de-indice-pres) * pi-val-percentual / 100).
    
       FIND FIRST tt-tot-unid NO-LOCK
            WHERE tt-tot-unid.cod-estabel  = tt-calcula.cod-estabel
              AND tt-tot-unid.cod-unid-neg = tt-calcula.unid-neg NO-ERROR.
       IF NOT AVAIL tt-tot-unid THEN DO:
           CREATE tt-tot-unid.
           ASSIGN tt-tot-unid.cod-estabel  = tt-calcula.cod-estabel
                  tt-tot-unid.cod-unid-neg = tt-calcula.unid-neg.
       END.
       ASSIGN tt-tot-unid.valor[1] = tt-tot-unid.valor[1] + (((it-nota-fisc.vl-merc-liq + (it-nota-fisc.vl-despes-it )) / de-indice-pres) * pi-val-percentual / 100).
    
       ASSIGN de-vl-acordo   = 0
              de-base-acordo = it-nota-fisc.vl-merc-liq.

       IF AVAIL natur-oper AND natur-oper.tipo = 2 AND natur-oper.emite-duplic AND NOT natur-oper.consum-final THEN 
           ASSIGN de-vl-acordo         = ROUND(( (de-base-acordo + 
                                                 (IF  i-id-faturamento-acordo = 1 THEN it-nota-fisc.vl-ipi-it    ELSE 0)   + 
                                                 (IF  i-id-base-calc-acordo   = 1 THEN it-nota-fisc.vl-icmsub-it ELSE 0)) / de-indice-pres) * (de-perc-acordo  / 100),2).
           ASSIGN tt-calcula.vl-acordo = tt-calcula.vl-acordo + (de-vl-acordo * pi-val-percentual / 100).
    
       
       ASSIGN de-vl-mkt = 0.
       IF tt-calcula.unid-neg <> "COM" AND                                                                                                                        
         (tt-calcula.cod-gr-cli = 05) THEN DO:
    
           IF tt-calcula.cod-emitente = 12022 AND tt-calcula.unid-neg = "TER" THEN DO:
               /*nao faz*/
           END.
           ELSE DO:
               ASSIGN de-vl-mkt = ROUND(((it-nota-fisc.vl-merc-liq * 0.01) / de-indice-pres),2)
                      tt-calcula.vl-mkt = tt-calcula.vl-mkt + (de-vl-mkt * pi-val-percentual / 100).
           END.
    
       END.
    
       ASSIGN tt-calcula.comissao  = tt-calcula.comissao + ((de-vl-comissao / de-indice-pres) * pi-val-percentual / 100)
              vlogImportado   = (substring(ITEM.fm-codigo,1,3) = "200" OR
                                 substring(ITEM.fm-codigo,1,3) = "400") AND
                                 substring(ITEM.fm-codigo,6,2) = "00"
              vlogImportadore = (substring(ITEM.fm-codigo,1,3) = "200" OR
                                 substring(ITEM.fm-codigo,1,3) = "400") AND
                                 substring(ITEM.fm-codigo,6,2) = "00"
              vlogBeneficiado = (substring(ITEM.fm-codigo,1,3) = "200" OR
                                 substring(ITEM.fm-codigo,1,3) = "400") AND 
                                (substring(ITEM.fm-codigo,6,2) = "30")
              vlogBenefConvenc = (substring(ITEM.fm-codigo,1,3) = "200" OR
                                  substring(ITEM.fm-codigo,1,3) = "400") AND
                                  substring(ITEM.fm-codigo,6,2) = "30"

              de-indice-fis    = 0.
    
       /***** ITEM IMPORTADO *******/
       if vLogImportado AND nota-fiscal.dt-emis-nota >= 09/29/2003 and
          it-nota-fisc.vl-icms-it <> 0 then do:
         
          if it-nota-fisc.aliquota-icm = 17 then
             assign de-indice-fis = 0.7942.
          if it-nota-fisc.aliquota-icm = 12 then
             assign de-indice-fis = 0.7084.
          if it-nota-fisc.aliquota-icm = 7 then
             assign de-indice-fis = 0.5.
           
          assign tt-calcula.vl-icms-cpi = tt-calcula.vl-icms-cpi + (((it-nota-fisc.vl-icms-it / de-indice-pres) * de-indice-fis) * pi-val-percentual / 100).
       END.
    
       /***** ITEM IMPORTADO regime especial *******/
       if vLogImportadore AND nota-fiscal.dt-emis-nota >= 09/29/2003 and
          it-nota-fisc.vl-icms-it <> 0 then do:
         
          if it-nota-fisc.aliquota-icm = 17 then
             assign de-indice-fis = 0.7647.
          if it-nota-fisc.aliquota-icm = 12 then
             assign de-indice-fis = 0.6667.
          if it-nota-fisc.aliquota-icm = 7 then
             assign de-indice-fis = 0.4286.
    
          assign tt-calcula.vl-icms-cpi = tt-calcula.vl-icms-cpi + (((it-nota-fisc.vl-icms-it / de-indice-pres) * de-indice-fis) * pi-val-percentual / 100).
           
           /*** retirei esta forma de calculo por solicitaªío de Rogerio e Lazare em 03/04/2007 ***/
    /*              assign tt-calcula.vl-icms-cpre = tt-calcula.vl-icms-cpre + ((it-nota-fisc.vl-icms-it / de-indice-pres) * de-indice-fis). */
       END.
     
       /****** Convencionais ********/
       IF vlogBenefConvenc                        AND
          it-nota-fisc.vl-icms-it <> 0             AND
          nota-fiscal.dt-emis-nota >= 03/19/2010  THEN DO:
    
           if it-nota-fisc.aliquota-icm = 7 OR it-nota-fisc.aliquota-icm = 12 OR it-nota-fisc.aliquota-icm = 17 THEN DO:
               ASSIGN de-indice-fis = 1 - (3 / it-nota-fisc.aliquota-icm) 
                      tt-calcula.vl-icms-cpi = tt-calcula.vl-icms-cpi + (((it-nota-fisc.vl-icms-it / de-indice-pres) * de-indice-fis) * pi-val-percentual / 100) .
           END.
       END.
       
       /****** ITEM LEI DE INFORMATICA ********/
       if vLogBeneficiado AND nota-fiscal.dt-emis-nota >= 09/29/2003 AND it-nota-fisc.vl-icms-it <> 0 then do:
          ASSIGN de-indice-fis = 0.9650.
         
          assign tt-calcula.vl-icms-cp = tt-calcula.vl-icms-cp + (((it-nota-fisc.vl-icms-it / de-indice-pres) * de-indice-fis) * pi-val-percentual / 100).
       END.
       
       if SUBSTRING(it-nota-fisc.char-2,96,1) = "1" AND /*** POSSUI PIS ***/
          DEC(SUBSTRING(it-nota-fisc.char-2,76,5)) <> 0 THEN do: /* ALIQUOTA DE PIS */
          assign tt-calcula.vl-pis = tt-calcula.vl-pis + (((it-nota-fisc.vl-merc-liq / de-indice-pres) * 
                                     (dec(substr(it-nota-fisc.char-2,76,5)) / 100)) * pi-val-percentual / 100).
       END.
    
       if substring(it-nota-fisc.char-2,97,1) = "1" AND /* POSSUI COFINS  */
              dec(substr(it-nota-fisc.char-2,81,5)) <> 0 then do: /* ALIQUOTA DE COFINS */
          assign tt-calcula.vl-cofins = tt-calcula.vl-cofins + (((it-nota-fisc.vl-merc-liq / de-indice-pres) * 
                                        (dec(substr(it-nota-fisc.char-2,81,5)) / 100)) * pi-val-percentual / 100) .
       END.
       
       assign de-vl-frete = 0.
    
       IF nota-fiscal.cidade-cif <> "" AND ((not nota-fiscal.nat-operacao begins "7") OR (not it-nota-fisc.nat-operacao begins "7")) then do:
    
           run pi-calcula-frete (nota-fiscal.cod-estabel,
                                 nota-fiscal.serie,
                                 nota-fiscal.nr-nota-fis,
                                 nota-fiscal.dt-emis-nota,
                                 it-nota-fisc.vl-tot-item, 
                                 nota-fiscal.vl-tot-nota /*nota-fiscal.vl-mercad*/ ,
                                 /*nota-fiscal.nome-transp,
                                 nota-fiscal.cod-rota,
                                 nota-fiscal.pais,
                                 nota-fiscal.estado,
                                 nota-fiscal.peso-bru,*/
                                 NO,
                                 output de-vl-frete).
       END.
        
       assign tt-calcula.frete = tt-calcula.frete + ((de-vl-frete / de-indice-pres) * pi-val-percentual / 100).
    
       /*PUT "1) tt-calcula.frete : " tt-calcula.frete  SKIP.*/
    
       /****** ITEM DIFERENTE DE DEBITO DIRETO ********/
       ASSIGN de-mat = 0
              de-mob = 0.
       if nota-fiscal.ind-tip-nota <> 3 and
          item.tipo-contr <> 4 /*"D"*/ then do:  
          run pi-busca-preco (it-nota-fisc.it-codigo,
                              tt-param.da-data-medio,
                              output de-mat,
                              output de-mob).  
    
          assign tt-calcula.custo-mat        = tt-calcula.custo-mat + (((de-mat * it-nota-fisc.qt-faturada[1]) / de-indice-pres) * pi-val-percentual / 100)
                 tt-calcula.custo-fixo-prod  = tt-calcula.custo-fixo-prod + (((de-mob * it-nota-fisc.qt-faturada[1]) / de-indice-pres) * pi-val-percentual / 100).
    
       END.
END PROCEDURE.

PROCEDURE pi-grava-tt-calcula-devolucao:
    DEF INPUT PARAMETER pi-cod-segmento   AS CHARACTER NO-UNDO.
    DEF INPUT PARAMETER pi-val-percentual AS DEC       NO-UNDO.
    
    DEF VAR c-descricao-segmento AS CHAR NO-UNDO.
    DEF VAR c-descricao-semento-ant AS CHAR NO-UNDO.

    ASSIGN c-vertical = "PADRAO".
    
    FOR FIRST grupo-canais-clientes NO-LOCK
        WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli,
        FIRST grupo-canais NO-LOCK
        WHERE grupo-canais.cod-gr-canais = grupo-canais-clientes.cod-gr-canais:
        ASSIGN c-vertical = grupo-canais.descricao.
    END.
    
    IF  AVAIL ped-venda 
    THEN DO:
        FOR FIRST  int-ped-venda2 NO-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido
               AND int-ped-venda2.int-1      <> 0,
            FIRST grupo-canais NO-LOCK
            WHERE grupo-canais.cod-gr-canais = int-ped-venda2.int-1:
            ASSIGN c-vertical = grupo-canais.descricao.
        END.
    END.

    /*------------------------- Chamado 67298 ----------------------------------- */
    ASSIGN c-descricao-segmento = fn-retorna-descricao-segmento(pi-cod-segmento).

    IF  c-descricao-segmento = 'Partes e Pecas - ICON' AND nota-fiscal.cod-estabel = "105" THEN
        ASSIGN c-descricao-segmento = "Interfonia e Monitoramento".
    ELSE
        IF  c-descricao-segmento BEGINS 'Partes e Pecas' THEN DO:
            CASE c-unid-neg:
                WHEN 'AUT' THEN ASSIGN c-descricao-segmento = "Controle de Acesso Condominial".
                WHEN 'TER' THEN ASSIGN c-descricao-segmento = "Comunicacao HO".
                WHEN 'SEC' THEN ASSIGN c-descricao-segmento = "Captacao de Imagem".
                WHEN 'NET' THEN ASSIGN c-descricao-segmento = "Redes Empresariais".
                WHEN 'FIR' THEN ASSIGN c-descricao-segmento = "Incendio e Iluminacao".
                WHEN 'ACE' THEN ASSIGN c-descricao-segmento = "Acessorios Corporativos".
                WHEN 'AUT' THEN ASSIGN c-descricao-segmento = "Controle de Acesso Condominial".
                WHEN 'ENG' THEN ASSIGN c-descricao-segmento = "Nobreaks".
            END CASE.
        END.

    /* Mercado Externo */
    ASSIGN c-unid-neg-subst = fn-retorna-desc-unidade(c-unid-neg).

    /*IF  AVAIL ped-venda AND substr(ped-venda.nat-operacao,1,1) = "7" AND emitente.natureza > 2 THEN*/
    IF  AVAIL ped-venda AND ped-venda.tp-pedido = "70" 
    OR  NOT AVAIL ped-venda AND nota-fiscal.estado = "ex" THEN
        ASSIGN c-unid-neg       = "EXPO"
               c-desc-unid      = "EXPO".
    
    ASSIGN c-descricao-semento-ant = c-descricao-segmento.

    /*Com a descriá∆o do segmento, retornar o c¢digo*/
    IF  emitente.cod-emitente = 105068 then
        ASSIGN pi-cod-segmento      = "T.MêXICO"
               c-descricao-segmento = "T.MêXICO".
    ELSE
        IF  c-desc-unid = "EXPO" THEN
            ASSIGN pi-cod-segmento      = "Outros Pa°ses"
                   c-descricao-segmento = "Outros Pa°ses".


    /*------------------------------------------------------------------------------*/
    
    IF tt-param.l-imp-nota THEN
      find first tt-calcula 
           where tt-calcula.tipo         = 2
             AND tt-calcula.cod-estabel  = (IF nota-fiscal.cod-estabel = "104" THEN "101" ELSE nota-fiscal.cod-estabel)
            /* and tt-calcula.cod-msg      = vcod-msg-devolucao /* int-docum-est.cod-msg */ */
             and tt-calcula.unid-neg     = c-unid-neg
             and tt-calcula.nome-abrev   = emitente.nome-abrev
             AND tt-calcula.cod-gr-cli   = emitente.cod-gr-cli
             and tt-calcula.fm-cod-com   = ITEM.fm-cod-com
             and tt-calcula.it-codigo    = item.it-codigo 
             and tt-calcula.nr-nota-fis  = nota-fiscal.nr-nota-fis 
             AND tt-calcula.serie        = nota-fiscal.serie
            /* AND tt-calcula.nr-seq-fat   = it-nota-fisc.nr-seq-fat*/
             and tt-calcula.cod-rep      = nota-fiscal.cod-rep 
             AND tt-calcula.cod-segmento = pi-cod-segmento 
             AND tt-calcula.c-vertical   = c-vertical no-error.
    else
      find first tt-calcula 
           where tt-calcula.tipo         = 2
             AND tt-calcula.cod-estabel  = (IF nota-fiscal.cod-estabel = "104" THEN "101" ELSE nota-fiscal.cod-estabel)
           /*  and tt-calcula.cod-msg      = vcod-msg-devolucao /* int-docum-est.cod-msg */ */
             and tt-calcula.unid-neg     = c-unid-neg
             and tt-calcula.nome-abrev   = emitente.nome-abrev
             AND tt-calcula.cod-gr-cli   = emitente.cod-gr-cli
             and tt-calcula.fm-cod-com   = ITEM.fm-cod-com
             and tt-calcula.it-codigo    = item.it-codigo 
             and tt-calcula.nr-nota-fis  = /* ""  */ nota-fiscal.nr-nota-fis
             AND tt-calcula.serie        = nota-fiscal.serie
            /* AND tt-calcula.nr-seq-fat   = it-nota-fisc.nr-seq-fat */
             and tt-calcula.cod-rep      = nota-fiscal.cod-rep 
             AND tt-calcula.cod-segmento = pi-cod-segmento 
             AND tt-calcula.c-vertical   = c-vertical no-error.
      
    FIND b-emitente
         WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-LOCK NO-ERROR.
    
    if not avail tt-calcula then do:
    
       /*Somente pessoa juridica pega a matriz do primeiro cgc cadastrado*/
       IF emitente.natureza = 2 THEN
           FIND FIRST b-emitente USE-INDEX cgc NO-LOCK  
                WHERE b-emitente.cgc BEGINS SUBSTRING(emitente.cgc,1,8)
                  AND b-emitente.natureza = 2 NO-ERROR.
    
      find first int-familia 
           where int-familia.fm-codigo = item.fm-codigo no-lock no-error.


      create tt-calcula.
      assign tt-calcula.tipo               = 2
             tt-calcula.cod-estabel        = (IF nota-fiscal.cod-estabel = "104" THEN "101" ELSE nota-fiscal.cod-estabel)
             tt-calcula.c-mercado          = IF /*nota-fiscal.estado = "ex"*/ c-desc-unid = "EXPO" THEN "Externo" ELSE "Interno"
             tt-calcula.c-origem           = IF item.ge-codigo = 45 THEN "OEM" ELSE "IND"  //if avail int-familia AND int-familia.oem = yes then "OEM" ELSE "IND"
             tt-calcula.cod-msg            = vcod-msg-devolucao /*int-docum-est.cod-msg*/
             tt-calcula.unid-neg           = c-unid-neg
             tt-calcula.descricao-un       = c-desc-unid
             tt-calcula.unid-neg-nota      = c-unid-neg-nota
             tt-calcula.descricao-un-nota  = c-desc-unid-nota
             tt-calcula.nome-abrev         = emitente.nome-abrev
             tt-calcula.nome-matriz        = IF AVAIL b-emitente THEN b-emitente.nome-emit ELSE ""
             tt-calcula.cgc                = substring(emitente.cgc,1,8)
             tt-calcula.cod-emitente       = emitente.cod-emitente
             tt-calcula.cod-categoria      = IF AVAIL int-ped-venda THEN SUBSTRING(int-ped-venda.char-1,12,3) ELSE ""
             tt-calcula.cod-rep            = nota-fiscal.cod-rep
             tt-calcula.nome-repres        = TRIM(STRING(nota-fiscal.cod-rep)) + " - " + nota-fiscal.no-ab-reppri
             tt-calcula.estado             = nota-fiscal.estado
             tt-calcula.pais               = nota-fiscal.pais
             tt-calcula.cod-gr-cli         = emitente.cod-gr-cli
             tt-calcula.cd-gr-com          = SUBSTRING(ITEM.fm-cod-com,1,7)
             tt-calcula.fm-cod-com         = ITEM.fm-cod-com
             tt-calcula.it-codigo          = item.it-codigo
             tt-calcula.descricao          = ITEM.desc-item
             tt-calcula.nr-nota-fis        = nota-fiscal.nr-nota-fis /*WHEN tt-param.l-imp-nota*/
             tt-calcula.serie        = nota-fiscal.serie
             tt-calcula.nr-seq-fat         = it-nota-fisc.nr-seq-fat
             tt-calcula.nr-pedcli          = nota-fiscal.nr-pedcli
             tt-calcula.dt-emis-nota       = nota-fiscal.dt-emis-nota WHEN tt-param.l-imp-nota
             tt-calcula.nat-operacao       = item-doc-est.nat-operacao
			 tt-calcula.ncm                = item-doc-est.class-fiscal
             tt-calcula.cod-segmento       = pi-cod-segmento
             tt-calcula.c-vertical         = c-vertical
             tt-calcula.fm-codigo          = ITEM.fm-codigo
             tt-calcula.codigo-orig        = ITEM.codigo-orig    
             tt-calcula.consum-final       = natur-oper.consum-final
             tt-calcula.cod-estab-substituido = (IF  nota-fiscal.cod-estabel = "104" THEN "104" ELSE tt-calcula.cod-estabel)
             tt-calcula.unid-neg-substituida  = c-unid-neg-subst
             tt-calcula.desc-segmento         = c-descricao-segmento
             tt-calcula.desc-segmento-ant     = c-descricao-semento-ant
             tt-calcula.de-vl-icms-fcp        = de-vl-icms-fcp         
             tt-calcula.de-vl-icms-uf-dest    = de-vl-icms-uf-dest 
             tt-calcula.de-vl-icms-uf-remet   = de-vl-icms-uf-remet.

      /*familia2*/
      FIND FIRST fam-com-item NO-LOCK
           WHERE fam-com-item.fm-cod-com = tt-calcula.cd-gr-com NO-ERROR.
      IF AVAIL fam-com-item THEN
          ASSIGN tt-calcula.c-desc-grupo = fam-com-item.descricao.
      ELSE
          ASSIGN tt-calcula.c-desc-grupo = tt-calcula.cd-gr-com.
            
      /*produto*/
      FIND FIRST fam-com-item NO-LOCK
           WHERE fam-com-item.fm-cod-com = tt-calcula.fm-cod-com NO-ERROR.
      IF AVAIL fam-com-item THEN
          ASSIGN tt-calcula.c-desc-familia = fam-com-item.descricao.
      ELSE 
          ASSIGN tt-calcula.c-desc-familia = tt-calcula.fm-cod-com.
    
      IF AVAIL ped-venda THEN
          ASSIGN tt-calcula.atendente = ped-venda.tp-pedido.
    end.
    
    ASSIGN de-vl-comissao = 0 
          c-periodo        = STRING(YEAR(devol-cli.dt-devol),"9999") + STRING(MONTH(devol-cli.dt-devol),"99").
    
    FOR EACH comissao-fat NO-LOCK
      WHERE comissao-fat.cod-estabel  = devol-cli.cod-estabel
        AND comissao-fat.serie        = /*devol-cli.serie-docto*/ nota-fiscal.serie
        AND comissao-fat.nr-nota-fis  = devol-cli.nro-docto  
        AND comissao-fat.it-codigo    = item.it-codigo
        AND comissao-fat.periodo      = c-periodo
        AND comissao-fat.unid-neg     = c-unid-neg
        AND comissao-fat.cod-rep      = nota-fiscal.cod-rep
        AND comissao-fat.cod-emitente = nota-fiscal.cod-emitente
        AND comissao-fat.id-tipo-inform = 2
        AND comissao-fat.dt-devolucao = devol-cli.dt-devol  :
    
       ASSIGN de-vl-comissao = de-vl-comissao + ((comissao-fat.vl-comissao * -1)  * pi-val-percentual / 100).
    
    END.
    
    ASSIGN de-perc-acordo = 0.
    RUN getAcordoComercial IN h-boes464 (INPUT emitente.cgc,
                                         INPUT nota-fiscal.cod-estabel,
                                         INPUT c-unid-neg,
                                         INPUT ITEM.fm-cod-com,
                                         INPUT nota-fiscal.dt-emis-nota,
                                         OUTPUT i-id-faturamento-acordo,
                                         OUTPUT i-id-base-calc-acordo,
                                         OUTPUT i-id-devolucoes,
                                         OUTPUT de-perc-acordo) NO-ERROR.
    
    
    FIND INT-CLASSIF-FISC
        WHERE INT-CLASSIF-FISC.class-fiscal = tt-calcula.ncm NO-LOCK NO-ERROR.

     IF  AVAIL int-classif-fisc AND int-classif-fisc.inss-faturamento = YES THEN
         ASSIGN de-CPRB = ((item-doc-est.preco-total[1] / de-indice-pres) * pi-val-percentual / 100).
     ELSE 
         ASSIGN de-CPRB = 0.


    ASSIGN de-vl-acordo   = 0
           de-base-acordo = item-doc-est.preco-total[1].


    IF AVAIL natur-oper AND natur-oper.tipo = 2 AND natur-oper.emite-duplic AND NOT natur-oper.consum-final AND i-id-devolucoes <> 9 THEN 
       ASSIGN de-vl-acordo         = ROUND(((de-base-acordo + 
                                             (IF  i-id-faturamento-acordo = 1 THEN item-doc-est.valor-ipi[1] ELSE 0) + 
                                             (IF  i-id-base-calc-acordo   = 1 THEN item-doc-est.vl-subs[1]   ELSE 0)) / de-indice-pres) * (de-perc-acordo  / 100),2)
              tt-calcula.vl-acordo = tt-calcula.vl-acordo + ( de-vl-acordo * pi-val-percentual / 100).
    
    ASSIGN de-vl-mkt = 0.
    IF tt-calcula.unid-neg <> "COM" AND
     (tt-calcula.cod-gr-cli = 05) THEN DO:
    
       IF tt-calcula.cod-emitente = 12022 AND tt-calcula.unid-neg = "TER" THEN DO:
           /*nao faz*/
       END.
       ELSE DO:
           ASSIGN de-vl-mkt = ROUND(((it-nota-fisc.vl-merc-liq * 0.01) / de-indice-pres),2)
                  tt-calcula.vl-mkt = tt-calcula.vl-mkt + ( de-vl-mkt  * pi-val-percentual / 100).
       END.
    END.
    
    
    ASSIGN tt-calcula.comissao      = tt-calcula.comissao + ((de-vl-comissao / de-indice-pres)  * pi-val-percentual / 100)
          tt-calcula.qtd           = tt-calcula.qtd + (devol-cli.qt-devolvida * pi-val-percentual / 100)
          tt-calcula.receita       = tt-calcula.receita + (((item-doc-est.preco-total[1] + item-doc-est.valor-ipi[1]) / de-indice-pres) * pi-val-percentual / 100)
          tt-calcula.rec-sem-ipi   = tt-calcula.rec-sem-ipi + (((item-doc-est.preco-total[1] -  item-doc-est.desconto[1]) / de-indice-pres) * pi-val-percentual / 100)
          tt-calcula.ipi           = tt-calcula.ipi + ((item-doc-est.valor-ipi[1] / de-indice-pres) * pi-val-percentual / 100).  
                             
    FIND FIRST tt-tot-unid NO-LOCK
        WHERE tt-tot-unid.cod-estabel  = tt-calcula.cod-estabel
          AND tt-tot-unid.cod-unid-neg = tt-calcula.unid-neg NO-ERROR.
    IF NOT AVAIL tt-tot-unid THEN DO:
       CREATE tt-tot-unid.
       ASSIGN tt-tot-unid.cod-estabel  = tt-calcula.cod-estabel
              tt-tot-unid.cod-unid-neg = tt-calcula.unid-neg.
    END.
    ASSIGN tt-tot-unid.valor[1] = tt-tot-unid.valor[1] + ((item-doc-est.preco-total[1] / de-indice-pres)  * pi-val-percentual / 100).
    
    
    ASSIGN vlogImportado   = (substring(ITEM.fm-codigo,1,3) = "200" OR
                             substring(ITEM.fm-codigo,1,3) = "400") AND
                             substring(ITEM.fm-codigo,6,2) = "00"
          vlogImportadore = (substring(ITEM.fm-codigo,1,3) = "200" OR
                             substring(ITEM.fm-codigo,1,3) = "400") AND
                             substring(ITEM.fm-codigo,6,2) = "00"
          vlogBeneficiado = (substring(ITEM.fm-codigo,1,3) = "200" OR
                             substring(ITEM.fm-codigo,1,3) = "400") AND 
                            (substring(ITEM.fm-codigo,6,2) = "30")
          vlogBenefConvenc = (substring(ITEM.fm-codigo,1,3) = "200" OR
                             substring(ITEM.fm-codigo,1,3) = "400") AND 
                            (substring(ITEM.fm-codigo,6,2) = "30")

          de-indice-fis    = 0.
    
    
    /***** ITEM IMPORTADO *******/
    if vLogImportado AND nota-fiscal.dt-emis-nota >= 09/29/2003 and
      it-nota-fisc.vl-icms-it <> 0 then do:
     
      if it-nota-fisc.aliquota-icm = 17 then
         assign de-indice-fis = 0.7942.
      if it-nota-fisc.aliquota-icm = 12 then
         assign de-indice-fis = 0.7084.
      if it-nota-fisc.aliquota-icm = 7 then
         assign de-indice-fis = 0.5.
       
      assign tt-calcula.vl-icms-cpi = tt-calcula.vl-icms-cpi + (((item-doc-est.valor-icm[1] / de-indice-pres) * de-indice-fis) * pi-val-percentual / 100).
    END.
    
    /***** ITEM IMPORTADO regime especial *******/
    if vLogImportadore AND nota-fiscal.dt-emis-nota >= 09/29/2003 and
      it-nota-fisc.vl-icms-it <> 0 then do:
     
      if it-nota-fisc.aliquota-icm = 17 then
         assign de-indice-fis = 0.7647.
      if it-nota-fisc.aliquota-icm = 12 then
         assign de-indice-fis = 0.6667.
      if it-nota-fisc.aliquota-icm = 7 then
         assign de-indice-fis = 0.4286.
       
      assign tt-calcula.vl-icms-cpi = tt-calcula.vl-icms-cpi + (((item-doc-est.valor-icm[1] / de-indice-pres) * de-indice-fis) * pi-val-percentual / 100).
      /*** retirei a linha abaixo por solicitaªío de Rogerio e Lazare em 03/04/2007 ***/
      
    /*              assign tt-calcula.vl-icms-cpre = tt-calcula.vl-icms-cpre + ((item-doc-est.valor-icm[1] / de-indice-pres) * de-indice-fis).*/
    END.
    
    
    /****** Convencionais ********/
    IF vlogBenefConvenc                        AND
      it-nota-fisc.vl-icms-it <> 0             AND
      nota-fiscal.dt-emis-nota >= 03/19/2010  THEN DO:
    
       if it-nota-fisc.aliquota-icm = 7 OR it-nota-fisc.aliquota-icm = 12 OR it-nota-fisc.aliquota-icm = 17 THEN DO:
           ASSIGN de-indice-fis = 1 - (3 / it-nota-fisc.aliquota-icm)
                  tt-calcula.vl-icms-cpi = tt-calcula.vl-icms-cpi + (((item-doc-est.valor-icm[1] / de-indice-pres) * de-indice-fis)  * pi-val-percentual / 100).
       END.
    END.
    
    /****** ITEM LEI DE INFORMATICA ********/
    if vLogBeneficiado AND nota-fiscal.dt-emis-nota >= 09/29/2003 and
      it-nota-fisc.vl-icms-it <> 0 then do:
       
      ASSIGN de-indice-fis = 0.9650.
     
      assign tt-calcula.vl-icms-cp = tt-calcula.vl-icms-cp + (((item-doc-est.valor-icm[1] / de-indice-pres) * de-indice-fis) * pi-val-percentual / 100).
    END.
    
    
    assign tt-calcula.vl-icms = tt-calcula.vl-icms + ((item-doc-est.valor-icm[1] / de-indice-pres) * pi-val-percentual / 100)
         tt-calcula.vl-icms-subs = tt-calcula.vl-icms-subs + ((item-doc-est.vl-subs[1] / de-indice-pres) * pi-val-percentual / 100) + vlr-fcp.
    
    if substring(it-nota-fisc.char-2,96,1) = "1" AND /*81,1 = "T"*/
      dec(substr(it-nota-fisc.char-2,76,5)) <> 0 then do: /*61,5*/
      assign tt-calcula.vl-pis = tt-calcula.vl-pis + ((((item-doc-est.preco-total[1] - item-doc-est.desconto[1]) * (dec(substr(it-nota-fisc.char-2,76,5)) / 100)) / de-indice-pres) * pi-val-percentual / 100).
    end.
    
    if substring(it-nota-fisc.char-2,97,1) = "1" AND /*82,1 = "T"*/
      dec(substr(it-nota-fisc.char-2,81,5)) <> 0 then do: /*66,5*/
      assign tt-calcula.vl-cofins = tt-calcula.vl-cofins + ((((item-doc-est.preco-total[1] - item-doc-est.desconto[1]) * (dec(substr(it-nota-fisc.char-2,81,5)) / 100)) / de-indice-pres) * pi-val-percentual / 100).
    end.
    
    assign tt-calcula.vl-iss = tt-calcula.vl-iss  + ((item-doc-est.valor-iss[1] / de-indice-pres) * pi-val-percentual / 100).
           tt-calcula.vl-bicms-it = tt-calcula.vl-bicms-it +  (item-doc-est.base-icm[1] * pi-val-percentual / 100).
           
    assign de-vl-frete = 0.
    
    /*if not it-nota-fisc.nat-operacao begins "7" and
      nota-fiscal.cidade-cif <> "" then
      run pi-calcula-frete (nota-fiscal.cod-estabel,
                            nota-fiscal.serie,
                            nota-fiscal.nr-nota-fis,
                            nota-fiscal.dt-emis-nota,
                            item-doc-est.preco-total[1], 
                            /*nota-fiscal.vl-tot-nota*/ nota-fiscal.vl-mercad,
                            /*nota-fiscal.nome-transp,
                            nota-fiscal.cod-rota,
                            nota-fiscal.pais,
                            nota-fiscal.estado,
                            nota-fiscal.peso-bru,*/
                            YES,
                            output de-vl-frete).
    
    ASSIGN tt-calcula.frete    = tt-calcula.frete   + (de-vl-frete / de-indice-pres).*/
    
    /*PUT "2) tt-calcula.frete : " tt-calcula.frete  SKIP.*/
    
/*     find first movto-estoq                                                                                             */
/*         where movto-estoq.it-codigo    = item.it-codigo                                                                */
/*           and movto-estoq.nro-docto    = item-doc-est.nro-docto                                                        */
/*           and movto-estoq.serie-docto  = item-doc-est.serie-docto                                                      */
/*           and movto-estoq.esp-docto    = 20 /*"nfd" */                                                                 */
/*           and movto-estoq.cod-emitente = emitente.cod-emitente                                                         */
/*           and movto-estoq.quantidade   = item-doc-est.quantidade                                                       */
/*           and movto-estoq.nat-operacao = item-doc-est.nat-operacao no-lock no-error.                                   */
/*                                                                                                                        */
/*     if avail movto-estoq then do:                                                                                      */
     ASSIGN dt-medio-devol = it-nota-fisc.dt-emis-nota.
/*                                                                                                                        */
     IF MONTH(dt-medio-devol) = 12 THEN
         ASSIGN dt-medio-devol = DATE(01,01,YEAR(it-nota-fisc.dt-emis-nota) + 1) - 1.
     ELSE
         ASSIGN dt-medio-devol = DATE(MONTH(it-nota-fisc.dt-emis-nota) + 1,01,YEAR(it-nota-fisc.dt-emis-nota)) - 1.
          
     /****** ITEM DIFERENTE DE DEBITO DIRETO ********/
     ASSIGN de-mat = 0
            de-mob = 0.
     if   nota-fiscal.ind-tip-nota <> 3 AND item.tipo-contr <> 4 /*"D"*/ then do:  
          run pi-busca-preco (item.it-codigo,
                              dt-medio-devol,
                              output de-mat,
                              output de-mob).  
    
      assign tt-calcula.custo-mat = tt-calcula.custo-mat 
                                    + (((devol-cli.qt-devolvida * de-mat) / de-indice-pres) * pi-val-percentual / 100).
    
      assign tt-calcula.custo-fixo-prod = tt-calcula.custo-fixo-prod
                                        + (((devol-cli.qt-devolvida * de-mob) / de-indice-pres) * pi-val-percentual / 100).
    
    
    end.         

END PROCEDURE.

PROCEDURE pi-busca-item-nf-adc:
    DEF INPUT PARAM p-estab AS CHAR NO-UNDO.
    DEF INPUT PARAM p-serie AS CHAR NO-UNDO.
    DEF INPUT PARAM p-nota  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-nat-oper AS CHAR NO-UNDO.
    DEF INPUT PARAM p-it-codigo AS CHAR NO-UNDO.
    DEF INPUT PARAM p-nr-seq-fat AS INTEGER NO-UNDO.
    DEF OUTPUT PARAM de-vl-icms-fcp       AS DECIMAL NO-UNDO.
    DEF OUTPUT PARAM de-vl-icms-uf-dest   AS DECIMAL NO-UNDO.
    DEF OUTPUT PARAM de-vl-icms-uf-remet  AS DECIMAL NO-UNDO.
    
    FOR EACH item-nf-adc FIELDS(cod-livre-4 val-livre-3 val-livre-4)
        WHERE item-nf-adc.cod-estab        = p-estab
        AND   item-nf-adc.cod-serie        = p-serie
        AND   item-nf-adc.cod-nota-fis     = p-nota
        AND   item-nf-adc.cod-natur-operac = p-nat-oper
        AND   item-nf-adc.cod-item         = p-it-codigo
        AND   item-nf-adc.num-seq-item-nf  = p-nr-seq-fat NO-LOCK:
    
        ASSIGN de-vl-icms-fcp      = de-vl-icms-fcp      + DEC(item-nf-adc.cod-livre-4)
               de-vl-icms-uf-dest  = de-vl-icms-uf-dest  + item-nf-adc.val-livre-3
               de-vl-icms-uf-remet = de-vl-icms-uf-remet + item-nf-adc.val-livre-4.
    END.
END.

function fn-retorna-descricao-segmento returns character
  ( p-fm-cod-com as character ) :
    
    find first b-fm-cod-com-aux
        where b-fm-cod-com-aux.fm-cod-com = substring(p-fm-cod-com, 1, 4) no-lock no-error.

   if available b-fm-cod-com-aux then
       return b-fm-cod-com-aux.descricao.
   else
       "".
end function.

function fn-retorna-cod-segmento returns character
  ( p-fm-descricao as character ) :

   IF  p-fm-descricao = "T.MêXICO" THEN
       RETURN "T.MêXICO".

   FIND b-fm-cod-com-aux
         WHERE b-fm-cod-com-aux.descricao = p-fm-descricao
         NO-LOCK NO-ERROR.

    IF  AVAIL b-fm-cod-com-aux THEN
        RETURN b-fm-cod-com-aux.fm-cod-com.
    ELSE
        RETURN "".
end function.


function fn-retorna-desc-unidade returns character
  ( p-cod-unidade as character ) :
   FIND tt-unidade
        WHERE tt-unidade.cod-unid-negoc =  p-cod-unidade
           NO-LOCK NO-ERROR.

    IF  AVAIL tt-unidade THEN
        RETURN tt-unidade.des-unid-negoc.
    ELSE
        RETURN p-cod-unidade.
end function.



 
