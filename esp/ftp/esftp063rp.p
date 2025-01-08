/***********************************************************************
**  Programa..: ESP\FTP\ESFTP063RP.P
**  Autor.....: Anderson Cenci
**  Data......: Mar‡o/2009 - Desenvolvimento
**  Descricao.: Relatorio de Remunera‡Æo Vari vel
**  VersÆo....: 001 10/03/2009
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP063 2.04.00.002}

/****************************  Definitions  ****************************/
{esp/ftp/esftp063.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/
DEFINE VARIABLE da-dt-emissao-fim       AS DATE        NO-UNDO.
DEFINE VARIABLE da-dt-emissao-ini       AS DATE        NO-UNDO.
DEFINE VARIABLE de-perc-comissao        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE da-data                 AS DATE        NO-UNDO.
DEFINE VARIABLE de-valor-comissao       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-unid-neg-rel          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-valor-devol          AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-nro-unidades          AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-participacao-unidade AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-total-comissao       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-zerou-comissao        AS LOGICAL     NO-UNDO.
                   
def var c-mes as char  extent 12 initial ["Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"] format "x(20)".
{utp/utapi019.i}

/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

DEF TEMP-TABLE tt-remuneracao
    FIELD id-tipo             AS INTEGER
    FIELD cod-colaborador     AS INTEGER
    FIELD matricula           AS CHARACTER
    FIELD unid-neg            AS CHAR
    FIELD cod-rep             AS INTEGER
    FIELD vl-meta             AS DECIMAL  
    FIELD vl-merc-liq         AS DECIMAL
        INDEX ch_princ id-tipo cod-colaborador unid-neg.
DEF TEMP-TABLE tt-resumo-rh
    FIELD empresa   AS INTEGER
    FIELD periodo   AS CHAR
    FIELD matricula AS CHARACTER
    FIELD valor     AS DECIMAL.

DEF BUFFER b-int-repres FOR int-repres.
def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Remunera‡Æo Vari vel"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP063"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
   {include/i-rpcab.i}
   {include/i-rpout.i &pagesize="0"}
    
   VIEW FRAME f-cabec.
   VIEW FRAME f-rodape.
    
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   run pi-finalizar in h-acomp.

   {include/i-rpclo.i}
   RETURN "OK".
end.

PROCEDURE piImprimeRelat:
    ASSIGN da-dt-emissao-ini = DATE( int(substring(tt-param.fi-periodo,5,2)) , 01 , int(substring(tt-param.fi-periodo,1,4))  ).

    IF int(substring(tt-param.fi-periodo,5,2)) = 12 THEN
       ASSIGN da-dt-emissao-fim = DATE( 01 , 01 , int(substring(tt-param.fi-periodo,1,4)) + 1  ) - 1.
    ELSE
       ASSIGN da-dt-emissao-fim = DATE( int(substring(tt-param.fi-periodo,5,2)) + 1 , 01 , int(substring(tt-param.fi-periodo,1,4))  ) - 1.
                           
   PUT "Estab.;Serie;Nota;Dt.Emissao;Cod.Rep.;Nome Repres.;Cod.Gerente;Nome Gerente;Cod.Assistente;Nome Assistente;Unid.Negocio;Valor ;" SKIP.

    do da-data = da-dt-emissao-ini to da-dt-emissao-fim:
       RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(da-data,"99/99/9999")).
       for each nota-fiscal  USE-INDEX ch-distancia
           WHERE nota-fiscal.dt-emis-nota = da-data
             AND nota-fiscal.cod-estabel  >= tt-param.fi-estab-ini 
             AND nota-fiscal.cod-estabel  <= tt-param.fi-estab-fim          
             AND nota-fiscal.dt-cancel    = ?,
           first emitente no-lock 
           WHERE emitente.cod-emitente    = nota-fiscal.cod-emitente,
           each it-nota-fisc of nota-fiscal no-lock,
           FIRST ITEM NO-LOCK 
           WHERE item.it-codigo           = it-nota-fisc.it-codigo,
           each  fat-repre no-lock
           where fat-repre.cod-estabel    = nota-fiscal.cod-estabel
             and fat-repre.serie          = nota-fiscal.serie
             and fat-repre.nr-fatura      = nota-fiscal.nr-fatura,
           first repres no-lock
           where repres.nome-abrev        = fat-repre.nome-ab-rep
             and repres.cod-rep          >= tt-param.fi-cod-repres-ini
             and repres.cod-rep          <= tt-param.fi-cod-repres-fim
             AND repres.tipo-repres       = 1, /* Funcionario */
           first int-repres NO-LOCK
           WHERE int-repres.cod-repres    = repres.cod-rep:

           RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(da-data,"99/99/9999") + " - "+ nota-fiscal.nr-nota-fis).
           FIND gerente
                WHERE gerente.cod-gerente = int-repres.cod-gerente
                NO-LOCK NO-ERROR.
           IF NOT AVAIL gerente  THEN NEXT.
           FIND assistente
                WHERE assistente.cod-assistente = int-repres.cod-assistente
                NO-LOCK NO-ERROR.
           IF NOT AVAIL assistente  THEN NEXT.


           ASSIGN c-unid-neg-rel = it-nota-fisc.cod-unid-neg.

           RUN pi-gera-temp-table (INPUT 1, 
                                   INPUT int-repres.cod-gerente,
                                   INPUT it-nota-fisc.vl-merc-liq).
           RUN pi-gera-temp-table (INPUT 2, 
                                   INPUT int-repres.cod-gerente,
                                   INPUT it-nota-fisc.vl-merc-liq).
           RUN pi-gera-temp-table (INPUT 3, 
                                   INPUT int-repres.cod-rep,
                                   INPUT it-nota-fisc.vl-merc-liq).
           RUN pi-gera-temp-table (INPUT 4,
                                   INPUT int-repres.cod-assistente,
                                   INPUT it-nota-fisc.vl-merc-liq).



           PUT nota-fiscal.cod-estabel ";"
               nota-fiscal.serie ";"
               nota-fiscal.nr-nota-fis ";"
               nota-fiscal.dt-emis-nota ";" 
               nota-fiscal.cod-rep ";"
               repres.nome ";"
               int-repres.cod-gerente ";"
               gerente.nome ";"
               int-repres.cod-assistente ";"
               assistente.nome ";"
               c-unid-neg-rel ";"
               it-nota-fisc.vl-merc-liq ";" SKIP.
       END.
       for each devol-cli USE-INDEX ch-dt-emit NO-LOCK
           where devol-cli.dt-devol        = da-data 
             and devol-cli.cod-estabel    >= tt-param.fi-estab-ini
             and devol-cli.cod-estabel    <= tt-param.fi-estab-fim,
           FIRST nota-fiscal  NO-LOCK
           WHERE nota-fiscal.cod-estabel   = devol-cli.cod-estabel
             AND nota-fiscal.serie         = devol-cli.serie
             AND nota-fiscal.nr-nota-fis   = devol-cli.nr-nota-fis
             AND nota-fiscal.emite-duplic, 
           first emitente no-lock 
           WHERE emitente.cod-emitente     = devol-cli.cod-emitente ,
           each  item-doc-est of devol-cli no-lock,                 
           first ITEM NO-LOCK 
           WHERE item.it-codigo            = item-doc-est.it-codigo,
           first repres no-lock
           where repres.nome-abrev         = nota-fiscal.no-ab-reppri
             and repres.cod-rep           >= tt-param.fi-cod-repres-ini
             and repres.cod-rep           <= tt-param.fi-cod-repres-fim
             AND repres.tipo-repres        = 1, /* Funcionario */
           first int-repres NO-LOCK
           WHERE int-repres.cod-repres     = repres.cod-rep:

           RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(da-data,"99/99/9999") + " - "+ nota-fiscal.nr-nota-fis).
           
           FIND gerente
                WHERE gerente.cod-gerente = int-repres.cod-gerente
                NO-LOCK NO-ERROR.
           IF NOT AVAIL gerente  THEN NEXT.
           FIND assistente
                WHERE assistente.cod-assistente = int-repres.cod-assistente
                NO-LOCK NO-ERROR.
           IF NOT AVAIL assistente  THEN NEXT.

           
           ASSIGN c-unid-neg-rel = ITEM.cod-unid-neg.
           ASSIGN de-valor-devol = (item-doc-est.preco-total[1] - item-doc-est.desconto[1]) * -1.
           RUN pi-gera-temp-table (INPUT 1, 
                                   INPUT int-repres.cod-gerente,
                                   INPUT de-valor-devol ).
           RUN pi-gera-temp-table (INPUT 2, 
                                   INPUT int-repres.cod-gerente,
                                   INPUT de-valor-devol).
           RUN pi-gera-temp-table (INPUT 3, 
                                   INPUT int-repres.cod-rep,
                                   INPUT de-valor-devol).
           RUN pi-gera-temp-table (INPUT 4,
                                   INPUT int-repres.cod-assistente,
                                   INPUT de-valor-devol).

           PUT nota-fiscal.cod-estabel ";"
               nota-fiscal.serie ";"
               nota-fiscal.nr-nota-fis ";"
               nota-fiscal.dt-emis-nota ";" 
               nota-fiscal.cod-rep ";"
               repres.nome ";"
               int-repres.cod-gerente ";"
               gerente.nome ";"
               int-repres.cod-assistente ";"
               assistente.nome ";"
               c-unid-neg-rel ";"
               de-valor-devol ";" SKIP.
           
       END.
    end.

    output close.     
    output to value(c-dir-spool-servid-exec +  tt-param.arquivo + "2").

    PUT "Tipo ; Cod Colaborador ; Nome Colaborador ; Limite Inf.; Limite Sup.; Vlr Faturado Liq;Vlr Meta;Salario Base;Perc.Comissao;Vlr.Comissao;" SKIP.

    FOR  EACH tt-remuneracao NO-LOCK
        WHERE tt-remuneracao.id-tipo <> 2,
        first comis-variavel NO-LOCK
        WHERE comis-variavel.id-tipo-colaborador = tt-remuneracao.id-tipo
          AND comis-variavel.cod-colaborador     = tt-remuneracao.cod-colaborador
        BREAK BY tt-remuneracao.id-tipo
              BY tt-remuneracao.cod-colaborador:
             
        ASSIGN de-perc-comissao = tt-remuneracao.vl-merc-liq / tt-remuneracao.vl-meta * 100.

        IF de-perc-comissao < comis-variavel.perc-limite-inferior THEN 
           ASSIGN de-perc-comissao = 0.
        IF de-perc-comissao > comis-variavel.perc-limite-superior THEN
           ASSIGN de-perc-comissao = comis-variavel.perc-limite-superior.

        PUT tt-remuneracao.id-tipo ";"
            tt-remuneracao.cod-colaborador ";".

        IF tt-remuneracao.id-tipo = 1 THEN DO:
            FIND gerente
                 WHERE gerente.cod-gerente = tt-remuneracao.cod-colaborador
                NO-LOCK NO-ERROR.
            PUT gerente.nome ";".
        END.
        ELSE DO:
            IF tt-remuneracao.id-tipo = 3 THEN DO:
                FIND repres
                     WHERE repres.cod-rep = tt-remuneracao.cod-colaborador
                    NO-LOCK NO-ERROR.
                PUT repres.nome ";".
            END.
            ELSE DO:
                FIND assistente
                     WHERE assistente.cod-assistente = tt-remuneracao.cod-colaborador
                     NO-LOCK NO-ERROR.
                PUT assistente.nome ";".
            END.
        END.
        ASSIGN de-valor-comissao = comis-variavel.vlr-base * de-perc-comissao / 100.
        PUT comis-variavel.perc-limite-inferior ";"
            comis-variavel.perc-limite-superior ";"
            tt-remuneracao.vl-merc-liq          format ">>>,>>>,>>>,>>9.99" ";"
            tt-remuneracao.vl-meta              format ">>>,>>>,>>>,>>9.99" ";"
            comis-variavel.vlr-base             format ">>>,>>>,>>>,>>9.99"  ";"
            de-perc-comissao ";"
            de-valor-comissao                   format ">>>,>>>,>>>,>>9.99" ";" SKIP.
        IF tt-param.rs-previa-oficial = 2 THEN DO:
            FIND comis-variavel-resumo
                 WHERE comis-variavel-resumo.cod-estabel         = tt-param.fi-estab-ini
                   AND comis-variavel-resumo.id-tipo-colaborador = tt-remuneracao.id-tipo
                   AND comis-variavel-resumo.cod-colaborador     = tt-remuneracao.cod-colaborador
                   AND comis-variavel-resumo.periodo             = tt-param.fi-periodo
                   no-LOCK NO-ERROR.
            IF NOT AVAIL comis-variavel-resumo THEN DO:
                CREATE comis-variavel-resumo.
                ASSIGN  comis-variavel-resumo.cod-estabel         = tt-param.fi-estab-ini
                        comis-variavel-resumo.id-tipo-colaborador = tt-remuneracao.id-tipo
                        comis-variavel-resumo.cod-colaborador     = tt-remuneracao.cod-colaborador
                        comis-variavel-resumo.periodo             = tt-param.fi-periodo
                        comis-variavel-resumo.vl-a-pagar         = de-valor-comissao.
                CREATE tt-resumo-rh.
                IF tt-param.fi-estab-ini = "101" THEN
                   ASSIGN tt-resumo-rh.empresa   = 1.
                ELSE
                    IF tt-param.fi-estab-ini = "301" OR
                       tt-param.fi-estab-ini = "103" THEN
                       ASSIGN tt-resumo-rh.empresa   = 6.
                ASSIGN tt-resumo-rh.periodo   = tt-param.fi-periodo
                       tt-resumo-rh.matricula = tt-remuneracao.matricula
                       tt-resumo-rh.valor     = de-valor-comissao.
            END.
        END.

    END.

    ASSIGN i-nro-unidades = 0.
    FOR  EACH tt-remuneracao NO-LOCK
        WHERE tt-remuneracao.id-tipo = 2
        BREAK BY tt-remuneracao.unid-neg:
        IF LAST-OF(tt-remuneracao.unid-neg) THEN
           ASSIGN i-nro-unidades = i-nro-unidades + 1.
    END.

    PUT "Tipo;Cod.Colaborador;Nome Colaborador;Unid.Neg;Nro Unidades;Participacao;Perc.Inferior;Perc.Superior;Perc.Min.Pagto;Vlr Mercadoria Liq;Vlr.Meta;Salario Base;Perc.Comissao;Valor Comissao;" SKIP.

    FOR  EACH tt-remuneracao NO-LOCK
        WHERE tt-remuneracao.id-tipo = 2,
        first comis-variavel NO-LOCK
        WHERE comis-variavel.id-tipo-colaborador = tt-remuneracao.id-tipo
          AND comis-variavel.cod-colaborador     = tt-remuneracao.cod-colaborador
        BREAK BY tt-remuneracao.cod-colaborador
              BY tt-remuneracao.unid-neg:
        IF first-OF(tt-remuneracao.cod-colaborador) THEN DO:
           ASSIGN de-total-comissao = 0
                  l-zerou-comissao = no.
        END.

        ASSIGN de-perc-comissao         = tt-remuneracao.vl-merc-liq / tt-remuneracao.vl-meta.
               de-participacao-unidade  = 1 / i-nro-unidades.

        IF  tt-remuneracao.vl-meta <> 0 THEN
            IF de-perc-comissao * 100 < comis-variavel.perc-limite-inferior THEN
               ASSIGN de-perc-comissao  = 0
                      de-valor-comissao = 0.
            ELSE
                IF de-perc-comissao * 100 >= comis-variavel.perc-limite-superior THEN 
                   ASSIGN de-valor-comissao = de-participacao-unidade * comis-variavel.vlr-base.
                ELSE
                    ASSIGN de-valor-comissao = de-participacao-unidade * comis-variavel.vlr-base * de-perc-comissao.
        ELSE
            ASSIGN de-valor-comissao = 0.

        PUT tt-remuneracao.id-tipo ";"
            tt-remuneracao.cod-colaborador ";".

        FIND gerente
             WHERE gerente.cod-gerente = tt-remuneracao.cod-colaborador
             NO-LOCK NO-ERROR.

        PUT gerente.nome ";"
            tt-remuneracao.unid-neg ";"
            i-nro-unidades ";"
            de-participacao-unidade ";"
            comis-variavel.perc-limite-inferior ";"
            comis-variavel.perc-limite-superior ";"
            comis-variavel.perc-minimo-pgto     ";"
            tt-remuneracao.vl-merc-liq          format ">>>,>>>,>>>,>>9.99" ";"
            tt-remuneracao.vl-meta              format ">>>,>>>,>>>,>>9.99" ";"
            comis-variavel.vlr-base             format ">>>,>>>,>>>,>>9.99"  ";"
            de-perc-comissao * 100              ";"
            de-valor-comissao                   format ">>>,>>>,>>>,>>9.99" ";" .

        IF  tt-remuneracao.vl-meta <> 0 THEN
            IF de-perc-comissao * 100 < comis-variavel.perc-minimo-pgto THEN DO:
                ASSIGN de-total-comissao = 0
                       l-zerou-comissao = YES.
                PUT "Abaixo do Valor Minimo ".
            END.
            ELSE
                ASSIGN de-total-comissao = de-total-comissao + de-valor-comissao.
        PUT ";" SKIP.

        IF LAST-OF(tt-remuneracao.cod-colaborador) THEN DO:
            IF l-zerou-comissao = yes THEN DO:
                PUT tt-remuneracao.id-tipo ";"
                    tt-remuneracao.cod-colaborador ";"
                    gerente.nome ";"
                    "Total"      ";"
                                 ";"
                                 ";"
                                 ";"
                                 ";"
                                 ";"
                                 ";"
                                 ";"
                                 ";"
                                 ";"
                               0 ";" SKIP.
            END.
            ELSE DO:
                PUT tt-remuneracao.id-tipo ";"
                    tt-remuneracao.cod-colaborador ";"
                    gerente.nome ";"
                    "Total"      ";"
                                 ";"
                                 ";"
                                 ";"
                                 ";"
                                 ";"
                                 ";"
                                 ";"
                                 ";"
                                 ";"
                     de-total-comissao           format ">>>,>>>,>>>,>>9.99" ";" SKIP.
                IF tt-param.rs-previa-oficial = 2 THEN DO:
                    FIND comis-variavel-resumo
                         WHERE comis-variavel-resumo.cod-estabel = tt-param.fi-estab-ini
                           AND comis-variavel-resumo.id-tipo-colaborador = 2
                           AND comis-variavel-resumo.cod-colaborador     = tt-remuneracao.cod-colaborador
                           AND comis-variavel-resumo.periodo             = tt-param.fi-periodo
                           no-LOCK NO-ERROR.
                    IF NOT AVAIL comis-variavel-resumo THEN DO:
                        CREATE comis-variavel-resumo.
                        ASSIGN  comis-variavel-resumo.cod-estabel = tt-param.fi-estab-ini
                                comis-variavel-resumo.id-tipo-colaborador = 2
                                comis-variavel-resumo.cod-colaborador     = tt-remuneracao.cod-colaborador
                                comis-variavel-resumo.periodo             = tt-param.fi-periodo
                                comis-variavel-resumo.vl-a-pagar         = de-total-comissao.
                        IF tt-param.fi-estab-ini = "101" THEN 
                            FIND tt-resumo-rh
                                 WHERE tt-resumo-rh.empresa  = 1
                                   AND tt-resumo-rh.matricula = tt-remuneracao.matricula
                                   AND tt-resumo-rh.periodo   = tt-param.fi-periodo
                                 NO-ERROR.
                        ELSE
                            IF tt-param.fi-estab-ini = "301" or
                               tt-param.fi-estab-ini = "103" THEN
                                FIND tt-resumo-rh
                                     WHERE tt-resumo-rh.empresa  = 3
                                       AND tt-resumo-rh.matricula = tt-remuneracao.matricula
                                       AND tt-resumo-rh.periodo   = tt-param.fi-periodo
                                     NO-ERROR.                      

                        IF NOT AVAIL tt-resumo-rh THEN DO:
                            CREATE tt-resumo-rh.
                            IF tt-param.fi-estab-ini = "101" THEN
                               ASSIGN tt-resumo-rh.empresa   = 1.
                            ELSE
                                IF tt-param.fi-estab-ini = "301" OR
                                   tt-param.fi-estab-ini = "103" THEN
                                   ASSIGN tt-resumo-rh.empresa   = 6.
                            ASSIGN tt-resumo-rh.periodo   = tt-param.fi-periodo
                                   tt-resumo-rh.matricula = tt-remuneracao.matricula.
                        END.
                        ASSIGN tt-resumo-rh.valor     = tt-resumo-rh.valor + de-total-comissao.
                    END.
                END.
            END.
        END.
    END.
    output close.     
    IF tt-param.rs-previa-oficial = 2 THEN DO:
        output to value(c-dir-spool-servid-exec +  tt-param.arquivo + "rh").
    
        FOR EACH tt-resumo-rh:
            IF tt-resumo-rh.valor = ? OR tt-resumo-rh.valor = 0 THEN NEXT.
            PUT tt-resumo-rh.empresa format "99" " "
                tt-resumo-rh.periodo " "
                tt-resumo-rh.matricula " "
                tt-resumo-rh.valor FORMAT ">>>,>>>,>>9.99" SKIP.
    
        END.
        OUTPUT CLOSE.
    END.
END PROCEDURE.

PROCEDURE pi-gera-temp-table:
    DEF INPUT PARAMETER p-id-tipo         AS INTEGER.
    DEF INPUT PARAMETER p-cod-colaborador AS INTEGER.
    DEF INPUT PARAMETER p-vl-merc-liq     AS DECIMAL.
    DEFINE VARIABLE c-unid-neg AS CHARACTER   NO-UNDO.
    

    FIND tt-remuneracao
         WHERE tt-remuneracao.id-tipo            = p-id-tipo
           AND tt-remuneracao.cod-colaborador    = p-cod-colaborador
           AND tt-remuneracao.unid-neg           = c-unid-neg
         NO-ERROR.
    IF NOT AVAIL tt-remuneracao THEN DO:
       CREATE tt-remuneracao.
       ASSIGN tt-remuneracao.id-tipo             = p-id-tipo
              tt-remuneracao.cod-colaborador     = p-cod-colaborador
              tt-remuneracao.unid-neg            = c-unid-neg
              tt-remuneracao.cod-rep             = int-repres.cod-repres.

       IF p-id-tipo = 1 THEN DO:
           ASSIGN tt-remuneracao.matricula   = gerente.matricula.
           FOR EACH meta-rep NO-LOCK
               where meta-rep.periodo            = tt-param.fi-periodo
                 AND meta-rep.cod-gerente        = int-repres.cod-gerente:
               ASSIGN tt-remuneracao.vl-meta     = tt-remuneracao.vl-meta + meta-rep.Valor.
           END.
       END.
       ELSE DO:
           IF p-id-tipo = 2 THEN DO:
              ASSIGN tt-remuneracao.matricula   = gerente.matricula.
               FOR EACH meta-rep NO-LOCK
                   where meta-rep.periodo        = tt-param.fi-periodo
                     AND meta-rep.cod-gerente    = int-repres.cod-gerente
                     AND meta-rep.cod-diretoria  = c-unid-neg:
                   ASSIGN tt-remuneracao.vl-meta = tt-remuneracao.vl-meta + meta-rep.Valor.
               END.
           END.
           ELSE DO:
               IF p-id-tipo = 3 THEN DO:
                   ASSIGN tt-remuneracao.matricula   = int-repres.matricula.
                   FOR EACH meta-rep NO-LOCK
                       where meta-rep.periodo        = tt-param.fi-periodo
                         AND meta-rep.cod-rep        = int-repres.cod-repres:
                       ASSIGN tt-remuneracao.vl-meta = tt-remuneracao.vl-meta + meta-rep.Valor.
                   END.
               END.
               ELSE DO:
                   IF p-id-tipo = 4 THEN DO:
                       ASSIGN tt-remuneracao.matricula   = assistente.matricula.
                       FOR EACH b-int-repres
                           WHERE b-int-repres.cod-assistente = tt-remuneracao.cod-colaborador NO-LOCK:
                           FOR EACH meta-rep NO-LOCK
                               where meta-rep.periodo        = tt-param.fi-periodo
                                 AND meta-rep.cod-rep        = b-int-repres.cod-repres:
                               ASSIGN tt-remuneracao.vl-meta = tt-remuneracao.vl-meta + meta-rep.Valor.
                           END.
                       END.
                   END.
               END.
           END.
       END.
    END.

    ASSIGN tt-remuneracao.vl-merc-liq = tt-remuneracao.vl-merc-liq +  p-vl-merc-liq.

END PROCEDURE.
