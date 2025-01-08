/***********************************************************************
**  Programa..: ESP\FTP\ESFTP006RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Acompanhamento Objetivo x Realizado
**                  ConversÆo do ES0594 (Claudiney)
**  VersÆo....: 001 25/11/2004
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP006 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/ftp/esftp006tt.i}
{include/i-rpvar.i}
{esp/es0010.i}  /* serie de notas fiscais e especie de titulos */

{utp/ut-glob.i}
/****************************  Temp-Tables  ****************************/
def temp-table tt-valor
    FIELD iTipo         AS   INT
    field cod-sup       like regiao.nome-ab-reg
    field cod-rep       like repres.cod-rep 
    field nome-sup      like regiao.nome-regiao
    field nome-abrev    like repres.nome-abrev
    field vl-cota       LIKE cotas.vl-medio-prev 
    field vl-nf         as dec format ">>>,>>>,>>9.99" label "Vl Nota Fiscal"
    field vl-car        as dec format ">>>,>>>,>>9.99" label "Vl Carteira"
    field vl-devol      as dec format ">>>,>>>,>>9.99" label "Vl Devolucao"
    index tt-acomp is primary unique iTipo cod-rep cod-sup.
/****************************  Variaveis    ****************************/
def var de-cotacao      like cotacao.cotacao[1].
def var i-cod-rep       like repres.cod-rep.
def var de-perc         as dec format "->>9.99" column-label "Real S/cota".
/*Realizado!s/ a cota*/
def var de-tot-cota     as DEC EXTENT 2 format ">>>>,>>9.99".
def var de-tot-nf       as DEC EXTENT 2 format ">>>>,>>9.99".
def var de-tot-car      as DEC EXTENT 2 format ">>>>,>>9.99".
def var de-tot-devol    as DEC EXTENT 2 format ">>>>,>>9.99".
DEFINE VARIABLE vDtParam AS DATE       NO-UNDO.
/*DEFINE VARIABLE vDtTrans AS DATE       NO-UNDO.*/
DEFINE VARIABLE cTipo AS CHARACTER INIT "CEN,TER,EXP" NO-UNDO.
DEF VAR vUnidNegocio LIKE unid-neg-ped.cod_unid_negoc.
DEF VAR vNomeSup     AS CHAR    NO-UNDO.
DEF VAR vPercUnid    LIKE unid-neg-ped.perc-unid-neg.

/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/*
 * for each tt-raw-digita:
 *     create tt-digita.
 *     raw-transfer tt-raw-digita.raw-digita to tt-digita.
 * end. 
 */

def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FOR FIRST estabelec NO-LOCK
    WHERE estabelec.ep-codigo = empresa.ep-codigo: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Acompanhamento - Objetivo X Realizado"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP006"
       c-versao       = "2.04"
       c-revisao      = "001"
       vDtParam       = DATE(int(substring(tt-param.c-periodo,1,2)),
                             01,
                             int(substring(tt-param.c-periodo,3,4))).

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

   run utp/ut-acomp.p persistent set h-acomp.  

   run pi-inicializar in h-acomp (input "Montando Relat¢rio...").
   run piMontaRelat.

   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */
PROCEDURE piMontaRelat:
    for each tt-valor:
        delete tt-valor.
    end.

  IF tt-param.cotas THEN DO:

    run pi-inicializar in h-acomp (input "Montando Relat¢rio...COTAS").

    IF tt-param.detalhes THEN
        PUT 'COTAS' SKIP.

    FOR EACH  cotas NO-LOCK 
            WHERE cotas.cod-estabel   = estabelec.cod-estabel
              AND cotas.cod-rep      >= tt-param.i-cod-rep-ini
              AND cotas.cod-rep      <= tt-param.i-cod-rep-fim
              AND cotas.dt-inicial    = vDtParam,
        FIRST repres NO-LOCK
            WHERE repres.cod-rep = cotas.cod-rep /*and
              repres.cod-rep >= tt-param.i-cod-rep-ini and
              repres.cod-rep <= tt-param.i-cod-rep-fim ,
        first regiao no-lock where
              regiao.nome-ab-reg = repres.nome-ab-reg and
              regiao.nome-ab-reg >= tt-param.c-sup-ini and
              regiao.nome-ab-reg <= tt-param.c-sup-fim*/ :

        RUN pi-acompanhar IN h-acomp (INPUT "Repres.: " + STRING(repres.cod-rep)).

        RUN piAtualizaUnid.

        CREATE tt-valor.
        ASSIGN tt-valor.cod-rep     = repres.cod-rep
               tt-valor.nome-abrev  = repres.nome-abrev
               tt-valor.vl-cota     = cotas.vl-medio-prev
               tt-valor.iTipo       = LOOKUP(vUnidNegocio,cTipo)
               tt-valor.cod-sup     = vUnidNegocio /*regiao.nome-ab-reg*/
               tt-valor.nome-sup    = vNomeSup    /*regiao.nome-regiao*/.

        IF tt-param.detalhes THEN
            DISP cotas.cod-rep
                 repres.nome-abrev
                 cotas.vl-medio-prev 
                 vUnidNegocio WITH STREAM-IO DOWN.

    END.

  END.

  IF tt-param.carteira THEN DO:

    run pi-inicializar in h-acomp (input "Montando Relat¢rio...Carteira").

    IF tt-param.detalhes THEN
        PUT skip(2) 'CARTEIRA.' SKIP.

    /*DO  vDtTrans = tt-param.dt-ini-ent TO tt-param.dt-fim-ent:*/

        FOR EACH ped-item NO-LOCK
                WHERE /*ped-item.dt-entrega    = vDtTrans */
                      ped-item.dt-entrega   >= tt-param.dt-ini-ent
                  AND ped-item.dt-entrega   <= tt-param.dt-fim-ent
                  AND ped-item.cod-sit-item <> 3 /*Atendido total*/
                  AND ped-item.cod-sit-item <> 6 /*Cancelado*/ ,
            FIRST ped-venda NO-LOCK OF ped-item
                /*WHERE ped-venda.cod-sit-ped <> 3 /*Atendido total*/
                  AND ped-venda.cod-sit-ped <> 6 /*Cancelado*/ */ ,
            FIRST natur-oper NO-LOCK 
                WHERE natur-oper.nat-operacao = ped-venda.nat-operacao 
                  AND natur-oper.emite-duplic,
            FIRST repres NO-LOCK  
                WHERE repres.nome-abrev = ped-venda.no-ab-reppri 
                  AND repres.cod-rep   >= tt-param.i-cod-rep-ini 
                  AND repres.cod-rep   <= tt-param.i-cod-rep-fim,
            FIRST regiao NO-LOCK 
                WHERE regiao.nome-ab-reg = repres.nome-ab-reg 
                  AND regiao.nome-ab-reg >= tt-param.c-sup-ini 
                  AND regiao.nome-ab-reg <= tt-param.c-sup-fim :

            RUN piAtualizaUnid.

            IF vUnidNegocio <> "EXP" THEN DO:
/*              FOR FIRST unid-neg-fat NO-LOCK                                    */
/*                  WHERE unid-neg-fat.cod-estabel  = nota-fiscal.cod-estabel     */
/*                  AND   unid-neg-fat.serie        = nota-fiscal.serie           */
/*                  AND   unid-neg-fat.nr-nota-fis  = nota-fiscal.nr-nota-fis     */
/*                  AND   unid-neg-fat.nr-seq-fat   = it-nota-fisc.nr-seq-fat     */
/*                  AND   unid-neg-fat.it-codigo    = it-nota-fisc.it-codigo:     */
/*                  ASSIGN vUnidNegocio = unid-neg-fat.cod_unid_negoc             */
/*                         vPercUnid    = unid-neg-fat.perc-unid-neg.             */
/*                  CASE vUnidNegocio:                                            */
/*                      WHEN "CEN" THEN ASSIGN vNomeSup = "CENTRAIS".             */
/*                      WHEN "TER" THEN ASSIGN vNomeSup = "TERMINAIS".            */
/*                      WHEN "EXP" THEN ASSIGN vNomeSup = "EXPORTACAO".           */
/*                      OTHERWISE  ASSIGN vNomeSup = unid-neg-fat.cod_unid_negoc. */
/*                  END CASE.                                                     */
/*              END.                                                              */
                 ASSIGN vUnidNegocio = it-nota-fisc.cod-unid-neg
                        vPercUnid    = 100.
    
                 CASE vUnidNegocio:
                     WHEN "CEN" THEN ASSIGN vNomeSup = "ICORP".
                     WHEN "TER" THEN ASSIGN vNomeSup = "TELECOM".
                     WHEN "EXP" THEN ASSIGN vNomeSup = "EXPORTACAO".
                     OTHERWISE  ASSIGN vNomeSup = it-nota-fisc.cod-unid-neg.
                 END CASE.
            END.

            RUN pi-acompanhar IN h-acomp (INPUT "Pedido/Item.: " + 
                                          STRING(ped-venda.nr-pedido) + "/" +
                                          ped-item.it-codigo).

            find cotacao no-lock 
                where cotacao.mo-codigo   = ped-venda.mo-codigo 
                  and cotacao.ano-periodo = string(year(today),"9999") + string(month(today),"99") no-error.
            if avail cotacao and cotacao.cotacao[day(today)] <> 0 then
                assign de-cotacao = cotacao.cotacao[day(today)].
            else
                assign de-cotacao = 1.

/*IF de-cotacao = 0 THEN
    MESSAGE de-cotacao VIEW-AS ALERT-BOX.*/

            find tt-valor where
                 tt-valor.cod-rep = repres.cod-rep and
                 tt-valor.cod-sup = vUnidNegocio /*repres.nome-ab-reg*/ no-error.
            if not avail tt-valor then do:
               FIND FIRST cotas NO-LOCK
                    WHERE cotas.cod-estabel   = estabelec.cod-estabel
                    AND   cotas.cod-rep       = repres.cod-rep
                    AND   cotas.dt-inicial    = vDtParam NO-ERROR.
               create tt-valor.
               assign tt-valor.cod-rep    = repres.cod-rep
                      tt-valor.iTipo      = LOOKUP(vUnidNegocio,cTipo)
                      tt-valor.cod-sup    = vUnidNegocio /*regiao.nome-ab-reg*/
                      tt-valor.nome-sup   = vNomeSup /*regiao.nome-regiao*/
                      tt-valor.nome-abrev = repres.nome-abrev
                      tt-valor.vl-cota    = cotas.vl-medio-prev WHEN AVAIL cotas.
            end.
            ASSIGN tt-valor.vl-car = tt-valor.vl-car + ((ped-item.vl-merc-abe * de-cotacao) * (vPercUnid / 100)).


            IF tt-param.detalhes THEN
                DISP ped-item.nome-abrev   
                     ped-item.nr-pedcli    
                     ped-item.nr-sequencia 
                     ped-item.it-codigo    
                     repres.cod-rep 
                     AVAIL unid-neg-ped COLUMN-LABE "ACHOU UN"
                     vUnidNegocio
                     vNomeSup     
                     ped-item.vl-merc-abe WITH STREAM-IO DOWN WIDTH 140.

        END.
    /*END.*/

  END.

  IF tt-param.devolucoes THEN DO:
    run pi-inicializar in h-acomp (input "Montando Relat¢rio...Devolu‡äes").

    IF tt-param.detalhes THEN
        PUT skip(2) 'DEVOLUCOES' SKIP.

    /*DO vDtTrans = tt-param.dt-ini-nff TO tt-param.dt-fim-nff:*/
        for each docum-est no-lock
            where docum-est.cod-estabel = tt-param.cod-estabel 
              /*and docum-est.dt-trans    = vDtTrans*/
              AND docum-est.dt-trans      >= tt-param.dt-ini-nff
              AND docum-est.dt-trans      <= tt-param.dt-fim-nff
              and (docum-est.nat-operacao begins "2201" /*"231"*/
               or  docum-est.nat-operacao begins "2202" /*"232"*/
               or  docum-est.nat-operacao begins "1201" /*"131"*/
               or  docum-est.nat-operacao begins "1202" /*"132"*/
               or  docum-est.nat-operacao begins "3201" /*"321"*/
               /*or  docum-est.nat-operacao begins "331"*/),

            each item-doc-est of docum-est no-lock,
            first emitente no-lock
                  where emitente.cod-emitente = docum-est.cod-emitente:
            RUN pi-acompanhar IN h-acomp (INPUT "Nota Fiscal.: " + STRING(item-doc-est.nro-comp)).

            find first nota-fiscal no-lock 
                 where nota-fiscal.cod-estabel = tt-param.cod-estabel 
                   and nota-fiscal.serie = item-doc-est.serie-comp 
                   and nota-fiscal.nr-nota-fis = item-doc-est.nro-comp no-error.
            IF AVAIL nota-fiscal AND NOT nota-fiscal.emite-duplic THEN NEXT.
            /* foi retirado em 02/02 por solicita‡Æo do Luciano/Claudiney.
            if avail nota-fiscal then 
               assign i-cod-rep = nota-fiscal.cod-rep.
            else*/
               assign i-cod-rep = emitente.cod-rep.

            find first repres no-lock 
                 where repres.cod-rep = i-cod-rep 
                   and repres.cod-rep >= i-cod-rep-ini 
                   and repres.cod-rep <= i-cod-rep-fim no-error.
            if not avail repres then next.
            RUN piAtualizaUnid.
            IF vUnidNegocio <> "EXP" THEN DO:
/*              FOR FIRST unid-neg-fat NO-LOCK                                    */
/*                  WHERE unid-neg-fat.cod-estabel  = nota-fiscal.cod-estabel     */
/*                  AND   unid-neg-fat.serie        = nota-fiscal.serie           */
/*                  AND   unid-neg-fat.nr-nota-fis  = nota-fiscal.nr-nota-fis     */
/*                  AND   unid-neg-fat.nr-seq-fat   = it-nota-fisc.nr-seq-fat     */
/*                  AND   unid-neg-fat.it-codigo    = it-nota-fisc.it-codigo:     */
/*                  ASSIGN vUnidNegocio = unid-neg-fat.cod_unid_negoc             */
/*                         vPercUnid    = unid-neg-fat.perc-unid-neg.             */
/*                  CASE vUnidNegocio:                                            */
/*                      WHEN "CEN" THEN ASSIGN vNomeSup = "CENTRAIS".             */
/*                      WHEN "TER" THEN ASSIGN vNomeSup = "TERMINAIS".            */
/*                      WHEN "EXP" THEN ASSIGN vNomeSup = "EXPORTACAO".           */
/*                      OTHERWISE  ASSIGN vNomeSup = unid-neg-fat.cod_unid_negoc. */
/*                  END CASE.                                                     */
/*              END.                                                              */
                 ASSIGN vUnidNegocio = it-nota-fisc.cod-unid-neg
                        vPercUnid    = 100.
    
                 CASE vUnidNegocio:
                     WHEN "CEN" THEN ASSIGN vNomeSup = "ICORP".
                     WHEN "TER" THEN ASSIGN vNomeSup = "TELECOM".
                     WHEN "EXP" THEN ASSIGN vNomeSup = "EXPORTACAO".
                     OTHERWISE  ASSIGN vNomeSup = it-nota-fisc.cod-unid-neg.
                 END CASE.
            END.
    
            find first regiao no-lock 
                  where regiao.nome-ab-reg = repres.nome-ab-reg 
                    and regiao.nome-ab-reg >= c-sup-ini 
                    and regiao.nome-ab-reg <= c-sup-fim no-error.
            if not avail regiao then next.

            IF tt-param.detalhes THEN
                DISP item-doc-est.serie-docto  
                     item-doc-est.nro-docto    
                     item-doc-est.cod-emitente 
                     item-doc-est.nat-operacao 
                     item-doc-est.it-codigo
                     i-cod-rep
                     AVAIL unid-neg-nota COLUMN-LABE "ACHOU UN"
                     vUnidNegocio
                     vNomeSup     
                    (item-doc-est.preco-total[1] - item-doc-est.desconto[1]) 
                   WITH STREAM-IO DOWN WIDTH 130.

            find tt-valor where
                 tt-valor.cod-sup = vUnidNegocio /*repres.nome-ab-reg*/ and
                 tt-valor.cod-rep = i-cod-rep no-error.
            if not avail tt-valor then do:
                FIND FIRST cotas NO-LOCK
                     WHERE cotas.cod-estabel   = estabelec.cod-estabel
                     AND   cotas.cod-rep       = i-cod-rep
                     AND   cotas.dt-inicial    = vDtParam NO-ERROR.
               create tt-valor.
               assign tt-valor.cod-rep      = i-cod-rep
                      tt-valor.iTipo        = LOOKUP(vUnidNegocio,cTipo)
                      tt-valor.cod-sup      = vUnidNegocio /*repres.nome-ab-reg*/
                      tt-valor.nome-sup     = vNomeSup /*regiao.nome-regiao*/
                      tt-valor.nome-abrev   = repres.nome-abrev
                      tt-valor.vl-cota      = cotas.vl-medio-prev WHEN AVAIL cotas.
            end.
            assign tt-valor.vl-devol = tt-valor.vl-devol + ((item-doc-est.preco-total[1] - item-doc-est.desconto[1]) * (vPercUnid / 100)).
        END.
    /*end.*/

  END.

  IF tt-param.realizado THEN DO:
    run pi-inicializar in h-acomp (input "Montando Relat¢rio...Realizado").

    IF tt-param.detalhes THEN
        PUT skip(2) 'REALIZADO' SKIP.

    for each tt-ser-esp no-lock where tt-ser-esp.tipo,
        each nota-fiscal no-lock /*use-index ch-distancia*/ where
        nota-fiscal.cod-estabel = tt-param.cod-estabel and
        nota-fiscal.serie = tt-ser-esp.codigo and
        nota-fiscal.dt-emis-nota >= tt-param.dt-ini-nff and
        nota-fiscal.dt-emis-nota <= tt-param.dt-fim-nff and
        nota-fiscal.dt-cancel = ? and
        nota-fiscal.emite-dup,
        first repres no-lock where
              repres.cod-rep = nota-fiscal.cod-rep and
              repres.cod-rep >= tt-param.i-cod-rep-ini and
              repres.cod-rep <= tt-param.i-cod-rep-fim,
        first regiao no-lock where
              regiao.nome-ab-reg = repres.nome-ab-reg and
              regiao.nome-ab-reg >= tt-param.c-sup-ini and
              regiao.nome-ab-reg <= tt-param.c-sup-fim,
        EACH it-nota-fisc NO-LOCK OF nota-fiscal:

        RUN pi-acompanhar IN h-acomp (INPUT "NF.DT: " + string(nota-fiscal.nr-nota-fis) + " - " + 
                                      STRING(nota-fiscal.dt-emis-nota)).

        RUN piAtualizaUnid.
        IF   vUnidNegocio <> "EXP" THEN DO:
/*              FOR FIRST unid-neg-fat NO-LOCK                                    */
/*                  WHERE unid-neg-fat.cod-estabel  = nota-fiscal.cod-estabel     */
/*                  AND   unid-neg-fat.serie        = nota-fiscal.serie           */
/*                  AND   unid-neg-fat.nr-nota-fis  = nota-fiscal.nr-nota-fis     */
/*                  AND   unid-neg-fat.nr-seq-fat   = it-nota-fisc.nr-seq-fat     */
/*                  AND   unid-neg-fat.it-codigo    = it-nota-fisc.it-codigo:     */
/*                  ASSIGN vUnidNegocio = unid-neg-fat.cod_unid_negoc             */
/*                         vPercUnid    = unid-neg-fat.perc-unid-neg.             */
/*                  CASE vUnidNegocio:                                            */
/*                      WHEN "CEN" THEN ASSIGN vNomeSup = "CENTRAIS".             */
/*                      WHEN "TER" THEN ASSIGN vNomeSup = "TERMINAIS".            */
/*                      WHEN "EXP" THEN ASSIGN vNomeSup = "EXPORTACAO".           */
/*                      OTHERWISE  ASSIGN vNomeSup = unid-neg-fat.cod_unid_negoc. */
/*                  END CASE.                                                     */
/*              END.                                                              */
             ASSIGN vUnidNegocio = it-nota-fisc.cod-unid-neg
                    vPercUnid    = 100.

             CASE vUnidNegocio:
                 WHEN "CEN" THEN ASSIGN vNomeSup = "ICORP".
                 WHEN "TER" THEN ASSIGN vNomeSup = "TELECOM".
                 WHEN "EXP" THEN ASSIGN vNomeSup = "EXPORTACAO".
                 OTHERWISE  ASSIGN vNomeSup = it-nota-fisc.cod-unid-neg.
             END CASE.
        END.
        /*
        IF LOOKUP(vUnidNegocio,cTipo) = 0 THEN
           DISP vUnidNegocio cTipo WITH STREAM-IO.
        */
        find FIRST tt-valor where
             tt-valor.cod-sup = vUnidNegocio /*repres.nome-ab-reg*/ and
             tt-valor.cod-rep = nota-fiscal.cod-rep no-error.
        if  not avail tt-valor then do:
            FIND FIRST cotas NO-LOCK
                 WHERE cotas.cod-estabel   = estabelec.cod-estabel
                 AND   cotas.cod-rep       = nota-fiscal.cod-rep
                 AND   cotas.dt-inicial    = vDtParam NO-ERROR.
           create tt-valor.
           assign tt-valor.cod-rep      = nota-fiscal.cod-rep
                  tt-valor.iTipo        = LOOKUP(vUnidNegocio,cTipo)
                  tt-valor.cod-sup      = vUnidNegocio /*repres.nome-ab-reg*/
                  tt-valor.nome-sup     = vNomeSup
                                          /*regiao.nome-regiao*/
                  tt-valor.nome-abrev   = repres.nome-abrev
                  tt-valor.vl-cota      = cotas.vl-medio-prev WHEN AVAIL cotas.

        end.

        IF tt-param.detalhes THEN
            DISP nota-fiscal.serie
                 nota-fiscal.nr-nota-fis
                 it-nota-fisc.it-codigo
                 nota-fiscal.vl-mercad 
                 it-nota-fisc.vl-merc-liq 
                 nota-fiscal.cod-rep
                 AVAIL unid-neg-item COLUMN-LABE "ACHOU.UN"
                 vUnidNegocio
                 vPercUnid
                 WITH STREAM-IO DOWN WIDTH 132.

        assign tt-valor.vl-nf = tt-valor.vl-nf + 
            (it-nota-fisc.vl-merc-liq  * (vPercUnid / 100)).

    end.

  END.

    IF tt-param.detalhes THEN
        PAGE.

END PROCEDURE.

PROCEDURE piImprimeRelat:

    run pi-inicializar in h-acomp (input "Imprimindo Relat¢rio...").

    PUT "Selecao:    Periodo do Valor da Cota:   " tt-param.c-periodo  skip
        "           Data de Entrega do Pedido:   " tt-param.dt-ini-ent  " at‚ " 
                                                   tt-param.dt-fim-ent skip
        "            Data Emissao Nota Fiscal:   " tt-param.dt-ini-nff  " at‚ "
                                                    tt-param.dt-fim-nff SKIP 
        skip(1).


    for each tt-valor 
        break by tt-valor.iTipo
              by tt-valor.cod-sup
              by tt-valor.cod-rep:
        if first-of(tt-valor.cod-sup) then do:
           put /*"Superintendente: "  */
                 "UNIDADE NEGàCIO.:  "
                tt-valor.nome-sup skip.
        end.

        assign de-tot-cota[1]  = de-tot-cota[1]  + tt-valor.vl-cota
               de-tot-nf[1]    = de-tot-nf[1]    + (tt-valor.vl-nf - tt-valor.vl-devol)
               de-tot-car[1]   = de-tot-car[1]   + tt-valor.vl-car
               de-tot-devol[1] = de-tot-devol[1] + tt-valor.vl-devol.

        /*
        accum tt-valor.vl-cota  (total by tt-valor.cod-sup)
              tt-valor.vl-cota  (total)
              tt-valor.vl-car   (total by tt-valor.cod-sup)
              tt-valor.vl-car   (total)
              tt-valor.vl-nf - tt-valor.vl-devol    (total by tt-valor.cod-sup)
              tt-valor.vl-nf - tt-valor.vl-devol    (total)
              tt-valor.vl-devol (total by tt-valor.cod-sup)
              tt-valor.vl-devol (total).*/

        assign de-perc = (((tt-valor.vl-nf - tt-valor.vl-devol) * 100) 
                         / tt-valor.vl-cota).
        if de-perc = ? or tt-valor.vl-cota = 0.01 then 
           assign de-perc = 0.

        DISP tt-valor.cod-rep                           COLUMN-LABEL 'Repres.'
             tt-valor.nome-abrev                        COLUMN-LABEL 'Nome Abreviado'
             tt-valor.vl-cota                           COLUMN-LABEL 'Valor Cota'
             de-perc                                    
            (tt-valor.vl-nf - tt-valor.vl-devol)        COLUMN-LABEL "Realiz - Devolv." format "->>,>>>,>>9.99"
             tt-valor.vl-car
            ((tt-valor.vl-nf - tt-valor.vl-devol) + 
               tt-valor.vl-car) format "->>,>>>,>>9.99"  COLUMN-LABEL "Realizado + Cart.Mˆs" 
             tt-valor.vl-devol skip
             with FRAME fDisp width 132 STREAM-IO DOWN.

        if last-of(tt-valor.cod-sup) then do:
            /*
           assign de-tot-cota   = accum total by tt-valor.cod-sup tt-valor.vl-cota
                  de-tot-nf     = accum total by tt-valor.cod-sup tt-valor.vl-nf - tt-valor.vl-devol
                  de-tot-car    = accum total by tt-valor.cod-sup tt-valor.vl-car
                  de-tot-devol  = accum total by tt-valor.cod-sup tt-valor.vl-devol.
           */
           assign de-perc = ((de-tot-nf[1] * 100) / de-tot-cota[1]).
           if de-perc = ? or de-perc > 999 then
              assign de-perc = 0.
           IF tt-valor.iTipo = 3 THEN
                put skip(1)
                    "TOTAL UNIDADE EXPORTA€ÇO   ".
           ELSE put skip(1)
                    "TOTAL DA UNIDADE NEGOCIO   ".
           PUT de-tot-cota[1] "     "
               de-perc "   "
               de-tot-nf[1]                 format "->>,>>>,>>9.99"
               "    "
               de-tot-car[1]   
               "       "
               de-tot-car[1] + de-tot-nf[1] format "->>,>>>,>>9.99" 
               de-tot-devol[1]              format ">>>>,>>>,>>9.99"
               skip(1).
           ASSIGN de-tot-cota[2]  = de-tot-cota[2]  + de-tot-cota[1]
                  de-tot-nf[2]    = de-tot-nf[2]    + de-tot-nf[1]
                  de-tot-car[2]   = de-tot-car[2]   + de-tot-car[1]
                  de-tot-devol[2] = de-tot-devol[2] + de-tot-devol[1].
           ASSIGN de-tot-cota[1]  = 0
                  de-tot-nf[1]    = 0
                  de-tot-car[1]   = 0
                  de-tot-devol[1] = 0.

           IF tt-valor.iTipo = 2 THEN
           DO:
               put skip(1)
                   "TOTAL UNIDADE NACIONAL     "
                   de-tot-cota[2] "     "
                   de-perc "   "
                   de-tot-nf[2]                 format "->>,>>>,>>9.99"
                   "    "
                   de-tot-car[2]   
                   "       "
                   de-tot-car[2] + de-tot-nf[2] format "->>,>>>,>>9.99" 
                   de-tot-devol[2]              format ">>>>,>>>,>>9.99"
                   skip(1).
           END.
        end.

    end.

    /*
    assign de-tot-cota  = accum total tt-valor.vl-cota
           de-tot-nf    = accum total tt-valor.vl-nf - tt-valor.vl-devol
           de-tot-car   = accum total tt-valor.vl-car
           de-tot-devol = accum total tt-valor.vl-devol.
    */
    assign de-perc = ((de-tot-nf[2] * 100) / de-tot-cota[2]).
    if de-perc = ? or de-perc > 999 then
       assign de-perc = 0.
    

    put "Total Geral do Relatorio" 
        de-tot-cota[2]          format ">>>,>>>,>>9.99"
        "     "
        de-perc 
        "   "
        de-tot-nf[2]            format "->>,>>>,>>9.99"
        " "
        de-tot-car[2]           format "->>,>>>,>>9.99"
        "       "
        de-tot-car[2] + de-tot-nf[2] format "->>,>>>,>>9.99" 
        de-tot-devol[2]        format ">>>>,>>>,>>9.99"
        skip(2).
END PROCEDURE.

PROCEDURE piAtualizaUnid:

    /*atribui valor, caso encontre unidade de negocio, este sera sobreposto*/
    ASSIGN vPercUnid = 100.

    IF /*repres.cod-rep >= 0 AND*/ repres.cod-rep < 4000 /*<= 3999*/ THEN
        ASSIGN vUnidNegocio = "CEN"
               vNomeSup     = "ICORP".
    ELSE IF /*repres.cod-rep >= 4000 AND*/ repres.cod-rep < 5000 /*<= 4999*/ THEN
        ASSIGN vUnidNegocio = "TER"
               vNomeSup     = "TELECOM".
    ELSE /*IF repres.cod-rep >= 5000 THEN*/
        ASSIGN vUnidNegocio = "EXP"
               vNomeSup     = "EXPORTACAO".

END PROCEDURE.
