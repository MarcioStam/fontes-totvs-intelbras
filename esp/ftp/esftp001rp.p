/***********************************************************************
**  Programa..: ESP\FTP\ESFTP001RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Relatorio de Vendas
**              Convers∆o do programa es0520.p - Claudiney
**  Vers∆o....: 001 11/11/2004
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP001 2.04.00.002}
 
/****************************  Definitions  ****************************/
{esp/ftp/esftp001tt.i}
{esp/ftp/esftp001.i}

    /*
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    FIELD da-data-ini           LIKE nota-fiscal.dt-emis-nota
    FIELD da-data-fim           LIKE nota-fiscal.dt-emis-nota
    FIELD i-cod-rep-ini         LIKE repres.cod-rep
    FIELD i-cod-rep-fim         LIKE repres.cod-rep 
    FIELD i-cod-cli-ini         LIKE emitente.cod-emitente
    FIELD i-cod-cli-fim         LIKE emitente.cod-emitente
    FIELD i-gr-cli-ini          LIKE emitente.cod-gr-cli
    FIELD i-gr-cli-fim          LIKE emitente.cod-gr-cli
    FIELD c-cgc-ini             LIKE emitente.cgc
    FIELD c-cgc-fim             LIKE emitente.cgc
    FIELD i-cd-gr-com-ini       AS   INT 
    FIELD i-cd-gr-com-fim       AS   INT 
    FIELD i-cd-sub-com-ini      AS   INT 
    FIELD i-cd-sub-com-fim      AS   INT 
    FIELD i-cd-marca-ini        AS   INT 
    FIELD i-cd-marca-fim        AS   INT
    FIELD i-cd-complemento-ini  AS   INT 
    FIELD i-cd-complemento-fim  AS   INT
    field c-cod-estabel-ini     as char format "x(03)"
    field c-cod-estabel-fim     as char format "x(03)"
    field cod-estabel           as char
    FIELD ItCodigoIni           LIKE ITEM.it-codigo
    FIELD ItCodigoFim           LIKE ITEM.it-codigo.
 
define temp-table tt-digita no-undo
    field cd-gr-com as integer   format ">>9"
    field descricao as character format "x(60)"
    index id cd-gr-com.
 
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
       */
{include/i-rpvar.i}
 
/****************************  Temp-Tables  ****************************/
/* form tt-digita.cd-gr
     fam-comerc.descricao
     with frame f-mostra row 3 12 down overlay col 30. */
/****************************  Variaveis    ****************************/
/* DEFINE BUFFER bfam-comerc FOR fam-comerc. */
def var h-boes464             as handle  no-undo.
def var da-data          as date.
def var da-data-ini      like nota-fiscal.dt-emis-nota.
def var da-data-fim      like nota-fiscal.dt-emis-nota.
def var de-perc-acordo   as decimal no-undo.

DEFINE VARIABLE i-id-faturamento-acordo AS INTEGER NO-UNDO. 
DEFINE VARIABLE i-id-base-calc-acordo   AS INTEGER NO-UNDO.
DEFINE VARIABLE i-id-devolucoes         AS INTEGER NO-UNDO.

def var d-dt-ent         like ped-venda.dt-emiss.
def var c-obs            as char format "X(170)".
def var i-atendente      like ped-venda.tp-pedido.
def var c-mail           as char format "X(40)".
def var c-desc-grupo     like gr-cli.descricao.
DEFINE VARIABLE c-sit-ped AS CHARACTER FORMAT "x(12)"  NO-UNDO.
DEFINE VARIABLE c-cod-gerente AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nom-gerente AS CHARACTER   NO-UNDO.
def var i-p-medio        as dec format ">>>>>>9".
def var c-unid-neg       as char format "X(10)".
DEF VAR c-unid-nota      as char format "X(10)".
def var de-perc-comissao as dec format ">9.99".
DEF VAR c-desc-cond      LIKE cond-pagto.descricao.
DEF VAR de-preco-min     LIKE preco-item.preco-venda.
DEFINE VARIABLE dt-dt-implant LIKE ped-venda.dt-implant.
DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-obs-aux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-observ-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-perc-desc-mais-verde AS DEC NO-UNDO.
DEFINE VARIABLE de-val-desc-mais-verde  AS DEC NO-UNDO.
DEFINE VARIABLE de-perc-desc-rebate-ant AS DEC NO-UNDO.
DEFINE VARIABLE de-val-desc-rebate-ant  AS DEC NO-UNDO.
DEFINE VARIABLE de-perc-desc-top-milhao AS DEC NO-UNDO.
DEFINE VARIABLE de-val-desc-top-milhao  AS DEC NO-UNDO.
DEFINE VARIABLE de-economia-mais-verde  AS DEC NO-UNDO.
DEFINE VARIABLE de-economia-top-milhao  AS DEC NO-UNDO.
DEFINE VARIABLE de-economia-rebate-ant  AS DEC NO-UNDO.

DEFINE VARIABLE de-desc-total-nota LIKE nota-fiscal.val-desconto-total NO-UNDO.
DEFINE VARIABLE de-perc-desc-nota LIKE it-nota-fisc.val-pct-desconto-total NO-UNDO.
 
DEFINE VARIABLE hDBOcomis-rep AS HANDLE      NO-UNDO.
&GLOBAL-DEFINE ttTable        ttcomis-rep
&GLOBAL-DEFINE hDBOTable      hDBOcomis-rep
&GLOBAL-DEFINE DBOTable       comis-rep
 
def buffer b-emitente for emitente.
/****************************  Frames       ****************************/
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
 
create tt-param.
raw-transfer raw-param to tt-param.
 
for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 
 
def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
 
assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Relatorio de Vendas"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP001"
       c-versao       = "2.04"
       c-revisao      = "001".


IF tt-param.ind-exec-aut = YES THEN DO:
    ASSIGN tt-param.da-data-ini = DATE(MONTH(TODAY), 01, YEAR(TODAY))
           tt-param.da-data-fim = TODAY
           tt-param.c-cod-estabel-ini = "101"
           tt-param.c-cod-estabel-fim = "999"
           tt-param.i-dup-ini       = "S"
           tt-param.i-dup-fim       = "S".

END.
 
/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    /*{include/i-rpcab.i}*/
    {include/i-rpout.i &pagesize="0"}
    /*
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    */
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.  
 
/* **********************  Internal Procedures  *********************** */
DEF VAR cRegiao AS CHAR FORMAT 'x(40)'.
DEF VAR cPerc   AS CHAR FORMAT 'x(05)'.
DEF VAR a AS DEC FORMAT ">>>,>>>,>>9.99".
 
PROCEDURE initializeDBO:
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "boes396.p":U THEN DO:
       RUN esbo/boes396.p PERSISTENT SET {&hDBOTable}.
    END.
END.
 
PROCEDURE destroyDBO:
    /*
    IF VALID-HANDLE({&hDBOTable}) THEN DO:
       RUN destroyBO IN {&hDBOTable}.
    END.
    */
 
    DELETE PROCEDURE {&hDBOTable}.
END.
 
 
PROCEDURE piImprimeRelat:
    RUN initializeDBO.
 
    PUT UNFORMATTED "Nota Fis;Ser;Dup;Emissao   ;Nat Op;   Emiten;Nome do Emitente                        ;Cidade                   ;UF  ;C.G.C.M.F.         ;Regiao                                  ;Grupo do Cliente              ;Cod.Gerente;Nome Gerente;Repr.;Nome Abrev  ;Transportado;Ped Cliente ;Prev.Fatur ;Situacao Pedido;Item   ;Descricao do Item                   ;Familia   ;Descriá∆o Familia;Qtde Faturada;   Valor Sem IPI;Obs. Pedido                                                                          ;   PMedio; %ICMS  ; %Ac ;Descricao Condicao Pagamento  ;  Valor Com IPI;Unid Negoc;Comis;At;         Preco NF;        Preco Min;    Taxa do Dolar;Dt.Implant;   Matriz;Nome Abrev Matriz;Unid Neg Nota;Observacao;Cod.Rep;NF Devol;Serie Devol;Parceiro IKEDA;Categoria Pedido;CPF deu Acesso Ikeda;Est;Segmento;Frete;Item Pai Combo;Perc Desc Informado;Deposito; Integrador; Subst Trib;Dt Saida;Observ;Po Cliente;Despesa Item;Dt de entrega;Dt Previs∆o de Entrega;Mot Dev;Prioridade;Canal Venda;Prev Fat. Original;Grupo Cobranáa; Repres 2;ID Projeto;Dt Autoriz;Hr Gerada;Perc Desconto;Vl total Desconto;% Desc Mais Verde;Vl Desc Mais Verde;Economia Mais Verde;% Desc Top Milhao;Vl Desc Top Milhao;Economia Top Milhao;% Desc Rebate Ant;Vl Desc Rebate Ant;Economia Rebate Antecipado; Supervisor; Dt Negociacao;Seq Ped;Volume NF; Peso Liq NF; Peso Bru NF;Hra Implant Ped; Usuario implantacao; Tab Pre SalesForce; ICMS ST; Nr Contrato;Desc Acordo Com" SKIP.
    
    DO da-data = tt-param.da-data-ini TO tt-param.da-data-fim:

       RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + STRING(da-data,"99/99/9999")).

       FOR EACH nota-fiscal FIELDS(nome-ab-cli nr-nota-fis vl-taxa-exp serie emite-duplic dt-emis-nota nat-operacao cod-emitente cidade
                                   estado cod-rep no-ab-reppri nome-transp nr-praz-med cod-estabel nr-fatura cod-cond-pag observ-nota
                                   vl-frete dt-saida dt-entr-cli cod-canal-venda cod-protoc val-desconto-total nr-volume peso-liq peso-bru) USE-INDEX ch-distancia NO-LOCK
           WHERE nota-fiscal.dt-emis-nota = da-data
           AND   nota-fiscal.cod-estabel  >= tt-param.c-cod-estabel-ini 
           AND   nota-fiscal.cod-estabel  <= tt-param.c-cod-estabel-fim
           AND   nota-fiscal.cod-emitente >= tt-param.i-cod-cli-ini 
           AND   nota-fiscal.cod-emitente <= tt-param.i-cod-cli-fim 
           AND   nota-fiscal.estado       >= tt-param.uf-ini
           AND   nota-fiscal.estado       <= tt-param.uf-fim
           AND   nota-fiscal.dt-cancel    = ?
           AND   nota-fiscal.cod-rep      >= tt-param.i-cod-rep-ini
           AND   nota-fiscal.cod-rep      <= tt-param.i-cod-rep-fim,
           FIRST emitente FIELDS(nome-emit cgc e-mail cod-gr-cli cod-rep cod-emitente) NO-LOCK
           WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
           AND   emitente.cod-gr-cli   >= tt-param.i-gr-cli-ini 
           AND   emitente.cod-gr-cli   <= tt-param.i-gr-cli-fim
           AND   ((emitente.cgc >= c-cgc-ini AND emitente.cgc <= c-cgc-fim) OR emitente.cgc = ?),
           FIRST b-emitente  NO-LOCK
           WHERE b-emitente.nome-abrev    = emitente.nome-matriz
             AND b-emitente.cod-emitente  >= tt-param.matriz-ini
             AND b-emitente.cod-emitente  <= tt-param.matriz-fim,
           EACH it-nota-fisc FIELDS(it-codigo val-desconto-total nr-pedcli nr-seq-ped qt-faturada[1] vl-merc-liq nr-seq-fat it-codigo cod-estabel serie nr-nota-fis
                                    aliquota-icm vl-tot-item it-nota-fisc.vl-preuni vl-ipi-it nat-operacao cod-unid-neg vl-icmsub-it vl-despes-it val-pct-desconto-total) OF nota-fiscal NO-LOCK,
           FIRST ITEM fields(it-codigo desc-item fm-cod-com cod-unid-neg) NO-LOCK
           WHERE item.it-codigo  = it-nota-fisc.it-codigo:

           /*IF  b-emitente.cod-emitente < tt-param.matriz-ini THEN NEXT.
           IF  b-emitente.cod-emitente > tt-param.matriz-fim THEN NEXT.  */

           IF item.fm-cod-com <> "" THEN
               IF ITEM.fm-cod-com < tt-param.i-familia-com-ini OR ITEM.fm-cod-com > tt-param.i-familia-com-fim THEN
               NEXT.
         
          IF tt-param.i-dup-ini = "S" AND tt-param.i-dup-fim = "S" AND nota-fiscal.emite-duplic = NO THEN
              NEXT.
               
          IF tt-param.i-dup-ini = "N" AND 
             tt-param.i-dup-fim = "N" AND 
             nota-fiscal.emite-duplic = YES THEN NEXT.
           
           if (it-nota-fisc.it-codigo < ItCodigoIni or 
               it-nota-fisc.it-codigo > ItCodigoFim) then next. 
                                                                                                         
           if can-find(first tt-digita) then do:
              find first tt-digita no-lock where
                   tt-digita.cd-gr-com = ITEM.fm-cod-com no-error.
              if not avail tt-digita then next.
           end.

           FIND fam-comerc
                WHERE fam-comerc.fm-cod-com = ITEM.fm-cod-com
                NO-LOCK NO-ERROR.
 
           RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(da-data,"99/99/9999") + " - "+ nota-fiscal.nr-nota-fis).

           find first ped-venda no-lock 
                WHERE ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli 
                AND   ped-venda.nome-abrev = nota-fiscal.nome-ab-cli no-error.

           IF tt-param.l-troca THEN DO:
               
               IF AVAIL ped-venda THEN DO:
                  FIND FIRST int-ped-venda
                       WHERE int-ped-venda.cod-estabel = ped-venda.cod-estabel
                         AND int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-LOCK NO-ERROR.
                  IF AVAIL int-ped-venda THEN DO:
                      IF substring(int-ped-venda.char-1,11,1) <> "S" THEN NEXT.
                  END.
                  ELSE DO:
                      NEXT.
                  END.
               END.
               ELSE NEXT.
           END.

           FIND FIRST int-nota-fiscal NO-LOCK
                WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                  AND int-nota-fiscal.serie       = nota-fiscal.serie
                  AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
           
           assign d-dt-ent = ?
                  c-obs      = ""
                  i-atendente = ""
                  dt-dt-implant = ?.
           IF NOT AVAIL ped-venda THEN DO:
               IF tt-param.c-cod-atendente-ini <> "00" or tt-param.c-cod-atendente-fim <> "99" THEN NEXT.
           END.      

           FIND FIRST int-ped-venda2 NO-LOCK
                WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido NO-ERROR.

           IF NOT AVAIL int-ped-venda2 THEN DO:
               IF tt-param.grp-canais-ini <> 0 OR tt-param.grp-canais-fim <> 99 THEN NEXT.
           END.
           ELSE DO:
               IF int-ped-venda2.int-1 < tt-param.grp-canais-ini
               OR int-ped-venda2.int-1 > tt-param.grp-canais-fim THEN
                   NEXT.
           END.
 
           ASSIGN a = a + it-nota-fisc.vl-merc-liq.

           ASSIGN de-perc-desc-mais-verde = 0
                  de-val-desc-mais-verde  = 0
                  de-perc-desc-top-milhao = 0
                  de-val-desc-top-milhao  = 0
                  de-perc-desc-rebate-ant = 0
                  de-val-desc-rebate-ant  = 0
                  de-economia-mais-verde  = 0
                  de-economia-top-milhao  = 0
                  de-economia-rebate-ant  = 0
                  de-desc-total-nota      = it-nota-fisc.val-desconto-total
                  de-perc-desc-nota       = 0.

           if avail ped-venda then do:
              find first ped-item no-lock of ped-venda where
                   ped-item.it-codigo    = ITEM.it-codigo and
                   ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped no-error.
              find int-ped-item NO-LOCK
                 where int-ped-item.nome-abrev      = ped-venda.nome-abrev
                   and int-ped-item.nr-pedcli       = ped-venda.nr-pedcli
                   and int-ped-item.nr-sequencia    = ped-item.nr-sequencia
                   and int-ped-item.it-codigo       = ped-item.it-codigo
                   and int-ped-item.cod-refer       = ped-item.cod-refer no-error.

/*               if not avail ped-item then */
/*                  message "Item da nota fiscal nao encontrado no pedido. Sera considerado a data de entrega do pedido. Verifique ..." skip */
/*                          "Nota fiscal: " nota-fiscal.nr-nota-fis skip                                                                     */
/*                          "       Item: " ITEM.it-codigo skip                                                                              */
/*                          "  Sequencia: " it-nota-fis.nr-seq-ped skip                                                                      */
/*                          " Num Pedido: " ped-item.nr-pedcli skip                                                                          */
/*                          "    Cliente: " ped-venda.nome-abrev view-as alert-box.                                                          */
              assign d-dt-ent  = if avail ped-item then ped-item.dt-entrega
                                                   else ped-venda.dt-entrega
                     i-atendente   = IF AVAIL int-nota-fiscal THEN SUBSTRING(int-nota-fiscal.char-1,28,2) ELSE ped-venda.tp-pedido
                     c-obs         = substr(ped-venda.observacoes,1,170)
                     dt-dt-implant = ped-venda.dt-implant
                     c-obs         = REPLACE(c-obs,CHR(10),"")
                     c-obs         = REPLACE(c-obs,CHR(13),"")
                     c-obs         = REPLACE(c-obs,CHR(9),"")
                     c-obs         = REPLACE(c-obs,";",",")
                     c-observ-item = ped-item.observacao
                     c-observ-item = REPLACE(c-observ-item,CHR(10),"")
                     c-observ-item = REPLACE(c-observ-item,CHR(13),"")
                     c-observ-item = REPLACE(c-observ-item,CHR(9),"")
                     c-observ-item = REPLACE(c-observ-item,";",","). /* pode ter conteudo separado por ponto e virgula */
              IF int(i-atendente) < int(tt-param.c-cod-atendente-ini) OR
                 int(i-atendente) > int(tt-param.c-cod-atendente-fim) THEN NEXT.

              ASSIGN de-perc-desc-nota = round(it-nota-fisc.val-pct-desconto-total,2).
              
                /* mais verde - top milhao - rebate   */
              FIND FIRST int-it-nota-fisc-rebate NO-LOCK
                   WHERE int-it-nota-fisc-rebate.cod-estabel  = it-nota-fisc.cod-estabel 
                     AND int-it-nota-fisc-rebate.nr-nota-fis  = it-nota-fisc.nr-nota-fis 
                     AND int-it-nota-fisc-rebate.serie        = it-nota-fisc.serie       
                     AND int-it-nota-fisc-rebate.it-codigo    = it-nota-fisc.it-codigo   
                     AND int-it-nota-fisc-rebate.nr-seq-fat   = it-nota-fisc.nr-seq-fat NO-ERROR.
              IF  AVAIL int-it-nota-fisc-rebate THEN DO:
                   ASSIGN de-perc-desc-mais-verde = ROUND(int-it-nota-fisc-rebate.perc-descto-verde * 100,2)
                          de-val-desc-mais-verde  = ROUND(it-nota-fisc.vl-merc-liq *  (1 + int-it-nota-fisc-rebate.perc-descto-verde) - it-nota-fisc.vl-merc-liq,2)
                          de-perc-desc-top-milhao = ROUND(int-it-nota-fisc-rebate.perc-descto-top-milhao * 100,2)
                          de-val-desc-top-milhao  = ROUND(it-nota-fisc.vl-merc-liq *  (1 + int-it-nota-fisc-rebate.perc-descto-top-milhao) - it-nota-fisc.vl-merc-liq,2)
                          de-perc-desc-rebate-ant = ROUND(int-it-nota-fisc-rebate.perc-rebate-antec * 100,2)
                          de-val-desc-rebate-ant  = ROUND(it-nota-fisc.vl-merc-liq *  (1 + int-it-nota-fisc-rebate.perc-rebate-antec) - it-nota-fisc.vl-merc-liq,2)
                          de-economia-mais-verde  = ROUND((it-nota-fisc.vl-preuni / (1 - int-it-nota-fisc-rebate.perc-rebate-antec) / (1 - int-it-nota-fisc-rebate.perc-descto-top-milhao) / (1 - int-it-nota-fisc-rebate.perc-descto-verde)) - (it-nota-fisc.vl-preuni / (1 - int-it-nota-fisc-rebate.perc-rebate-antec) / (1 - int-it-nota-fisc-rebate.perc-descto-top-milhao)),2) * it-nota-fisc.qt-faturada[1]
                          de-economia-top-milhao  = ROUND((it-nota-fisc.vl-preuni / (1 - int-it-nota-fisc-rebate.perc-rebate-antec) / (1 - int-it-nota-fisc-rebate.perc-descto-top-milhao)) - (it-nota-fisc.vl-preuni / (1 - int-it-nota-fisc-rebate.perc-rebate-antec)),2) * it-nota-fisc.qt-faturada[1]
                          de-economia-rebate-ant  = ROUND((it-nota-fisc.vl-preuni / (1 - int-it-nota-fisc-rebate.perc-rebate-antec)) - (it-nota-fisc.vl-preuni),2) * it-nota-fisc.qt-faturada[1].
              end.
              ELSE DO:
                  FIND FIRST int-ped-item-rebate NO-LOCK
                       WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev
                         AND int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli
                         AND int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
                         AND int-ped-item-rebate.it-codigo    = ped-item.it-codigo
                         AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer NO-ERROR.
                  IF AVAIL int-ped-item-rebate THEN
                      ASSIGN de-perc-desc-mais-verde = ROUND(int-ped-item-rebate.perc-descto-verde * 100,2)
                             de-val-desc-mais-verde  = ROUND(it-nota-fisc.vl-merc-liq *  (1 + int-ped-item-rebate.perc-descto-verde) - it-nota-fisc.vl-merc-liq,2)
                             de-perc-desc-top-milhao = ROUND(int-ped-item-rebate.perc-descto-top-milhao * 100,2)
                             de-val-desc-top-milhao  = ROUND(it-nota-fisc.vl-merc-liq *  (1 + int-ped-item-rebate.perc-descto-top-milhao) - it-nota-fisc.vl-merc-liq,2)
                             de-perc-desc-rebate-ant = ROUND(int-ped-item-rebate.perc-rebate-antec * 100,2)
                             de-val-desc-rebate-ant  = ROUND(it-nota-fisc.vl-merc-liq *  (1 + int-ped-item-rebate.perc-rebate-antec) - it-nota-fisc.vl-merc-liq,2)
                             de-economia-mais-verde  = ROUND((it-nota-fisc.vl-preuni / (1 - int-ped-item-rebate.perc-rebate-antec) / (1 - int-ped-item-rebate.perc-descto-top-milhao) / (1 - int-ped-item-rebate.perc-descto-verde)) - (it-nota-fisc.vl-preuni / (1 - int-ped-item-rebate.perc-rebate-antec) / (1 - int-ped-item-rebate.perc-descto-top-milhao)),2) * it-nota-fisc.qt-faturada[1]
                             de-economia-top-milhao  = ROUND((it-nota-fisc.vl-preuni / (1 - int-ped-item-rebate.perc-rebate-antec) / (1 - int-ped-item-rebate.perc-descto-top-milhao)) - (it-nota-fisc.vl-preuni / (1 - int-ped-item-rebate.perc-rebate-antec)),2) * it-nota-fisc.qt-faturada[1]
                             de-economia-rebate-ant  = ROUND((it-nota-fisc.vl-preuni / (1 - int-ped-item-rebate.perc-rebate-antec)) - (it-nota-fisc.vl-preuni),2) * it-nota-fisc.qt-faturada[1].
                
              end.

              FIND FIRST mgesp.int-ped-item-pci
                   WHERE mgesp.int-ped-item-pci.nome-abrev   = ped-item.nome-abrev
                     AND mgesp.int-ped-item-pci.nr-pedcli    = ped-item.nr-pedcli
                     AND mgesp.int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia
                     AND mgesp.int-ped-item-pci.it-codigo    = ped-item.it-codigo
                     AND mgesp.int-ped-item-pci.cod-refer    = ped-item.cod-refer NO-LOCK NO-ERROR. 
           end.

           FIND FIRST item-uni-estab
               WHERE item-uni-estab.it-codigo   = item.it-codigo
                 AND item-uni-estab.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.
           
           RUN piTrataRelat.

           IF  c-unid-neg < tt-param.c-unid-neg-ini or
               c-unid-neg > tt-param.c-unid-neg-fim THEN NEXT.
 
           FIND int-repres
                WHERE int-repres.cod-repres = nota-fiscal.cod-rep
                NO-LOCK NO-ERROR.
           IF AVAIL INT-repres THEN
              ASSIGN c-cod-gerente = string(int-repres.cod-gerente).
           ELSE
              ASSIGN c-cod-gerente = "".

           FIND gerente
                WHERE gerente.cod-gerente = INT(c-cod-gerente)
                NO-LOCK NO-ERROR.
           IF AVAIL gerente THEN 
              ASSIGN c-nom-gerente = gerente.nome.
           ELSE
              ASSIGN c-nom-gerente = "".


          ASSIGN c-sit-ped = "".
          IF AVAIL ped-venda THEN
             IF ped-venda.cod-sit-ped = 1 THEN
                ASSIGN c-sit-ped = "ABERTO".
             ELSE
                IF ped-venda.cod-sit-ped = 2 THEN 
                   ASSIGN c-sit-ped = "AT.PARCIAL".
                ELSE
                    IF ped-venda.cod-sit-ped = 3 THEN 
                       ASSIGN c-sit-ped = "AT.TOTAL".
                     ELSE
                        IF ped-venda.cod-sit-ped = 5 THEN 
                           ASSIGN c-sit-ped = "SUSPENSO".


           ASSIGN cRegiao = IF AVAIL regiao THEN regiao.nome-regiao ELSE ""
                  cPerc   = STRING(de-perc-acordo,">9.99").
            
           put UNFORMATTED string(nota-fiscal.nr-nota-fis,'x(10)')  ";"
               nota-fiscal.serie FORMAT 'x(03)'         ";".
           PUT nota-fiscal.emite-duplic                 ";".
           put UNFORMATTED    nota-fiscal.dt-emis-nota                 ";"
               it-nota-fisc.nat-operacao                ";"
               nota-fiscal.cod-emitente                 ";" 
               emitente.nome-emit                       ";"
               nota-fiscal.cidade                       ";" 
               nota-fiscal.estado                       ";"
               emitente.cgc                             ";"
               cRegiao                                  ";"
               c-desc-grupo                             ";"
               c-cod-gerente                            ";"
               c-nom-gerente                            ";"
               nota-fiscal.cod-rep                      ";" 
               nota-fiscal.no-ab-reppri                 ";"
               nota-fiscal.nome-transp                  ";" 
               it-nota-fisc.nr-pedcli                   ";"
               d-dt-ent                                 ";" 
               c-sit-ped                                ";"
               ITEM.it-codigo          format "x(07)"   ";".
                
           ASSIGN c-desc-item = fn-retira-espec(item.desc-item ).
           PUT UNFORMATTED c-desc-item    FORMAT "x(60)"            ";".             

           IF AVAIL fam-comerc THEN
              PUT UNFORMATTED fam-comerc.fm-cod-com                 ";"
                  fam-comerc.descricao                  ";".
           ELSE
               PUT UNFORMATTED "; ;".
           PUT UNFORMATTED it-nota-fisc.qt-faturada[1]              ";"
               it-nota-fisc.vl-merc-liq                 ";".
               
           ASSIGN c-obs-aux = fn-retira-espec(c-obs).
           PUT UNFORMATTED c-obs-aux format "X(200)"                ";".

           IF nota-fiscal.nr-praz-med < 0 THEN
               PUT UNFORMATTED ";".
           ELSE
               PUT UNFORMATTED nota-fiscal.nr-praz-med                                                                 ";".

           PUT UNFORMATTED
               string(it-nota-fisc.aliquota-icm,">>9.99") ";"
               cPerc                                      ";"
               c-desc-cond                                ";" 
              (it-nota-fisc.vl-merc-liq + it-nota-fisc.vl-ipi-it) FORMAT "->>>,>>>,>>9.99" ";"
               c-unid-neg                                 ";".
                
           ASSIGN de-perc-comissao = 0.
 
           /** Busca comiss∆o pela BO **/
           RUN getComissao IN {&hDBOTable} (INPUT nota-fiscal.cod-estabel,
                                            INPUT nota-fiscal.cod-rep,
                                            INPUT emitente.cod-emitente,
                                            INPUT ITEM.fm-cod-com,
                                            INPUT nota-fiscal.dt-emis-nota,
                                            OUTPUT de-perc-comissao) NO-ERROR.
           
           /*for each fat-repre FIELDS(fat-repre.perc-comis)
               where fat-repre.cod-estabel = nota-fiscal.cod-estabel
                 and fat-repre.serie  = nota-fiscal.serie
                 and fat-repre.nr-fatura = nota-fiscal.nr-fatura no-lock:
              assign de-perc-comissao = de-perc-comissao +
                                        fat-repre.perc-comis.
           end.*/
           
           FIND LAST preco-item NO-LOCK
               WHERE preco-item.it-codigo = ITEM.it-codigo
               AND   preco-item.cod-refer = ""
               AND   preco-item.nr-tabpre = "minimo" NO-ERROR.
           IF AVAIL preco-item THEN
               ASSIGN de-preco-min = preco-item.preco-venda.
           ELSE
               ASSIGN de-preco-min = 0.
               
           assign    c-obs       = REPLACE(nota-fiscal.observ-nota,CHR(10),"")
                     c-obs       = REPLACE(c-obs,CHR(13),"")
                     c-obs       = REPLACE(c-obs,CHR(09),"")
                     c-obs       = REPLACE(c-obs,";",",").               
           
           put UNFORMATTED de-perc-comissao ";" 
               i-atendente ";"
               it-nota-fisc.vl-preuni ";"
               de-preco-min ";"
               nota-fiscal.vl-taxa-exp ";"
               dt-dt-implant ";"
               b-emitente.cod-emitente ";"
               b-emitente.nome-abrev ";"
               c-unid-nota ";".

           ASSIGN c-obs-aux = fn-retira-espec(c-obs).
           PUT UNFORMATTED c-obs-aux format "X(100)"                     ";".

           assign c-obs = "".
           IF (nota-fiscal.cod-estabel = "301" OR
               nota-fiscal.cod-estabel = "103") AND
               AVAIL ped-venda THEN DO:
               FIND repres
                    WHERE repres.nome-abrev = ped-venda.no-ab-reppri
                    NO-LOCK NO-ERROR.
               IF AVAIL repres THEN
                  PUT UNFORMATTED repres.cod-rep ";".
               ELSE
                  PUT UNFORMATTED ";".
           END.
           ELSE PUT ";".

           FIND FIRST devol-cli 
                WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel   
                  AND devol-cli.serie       = nota-fiscal.serie         
                  AND devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis    
                  AND devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat
                  AND devol-cli.it-codigo    = it-nota-fisc.it-codigo
                NO-LOCK NO-ERROR.
           IF AVAIL devol-cli THEN
              PUT UNFORMATTED devol-cli.nro-docto ";"
                  devol-cli.serie-docto ";".
           ELSE DO:
              PUT " ; ; ".
           END.
           IF it-nota-fisc.nr-pedcli <> "" THEN DO:
               FIND int-ped-venda
                    WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                      AND int-ped-venda.cod-estabel = ped-venda.cod-estabel
                    NO-LOCK NO-ERROR.
               IF AVAIL INT-ped-venda THEN 
                   PUT UNFORMATTED int-ped-venda.ParceiroCodigo ";"
                       SUBSTRING(int-ped-venda.char-1,12,3) ";"
                       SUBSTRING(int-ped-venda.char-1,26,15) .
               ELSE
                   PUT ";;".
           END.
           ELSE PUT ";;".

           PUT UNFORMATTED ";":U STRING(nota-fiscal.cod-estabel, "x(3)":U).

           FIND FIRST unid_negoc NO-LOCK
               WHERE unid_negoc.cod_unid_negoc = ITEM.cod-unid-negoc NO-ERROR.

           FIND FIRST fam-com-item NO-LOCK
                WHERE fam-com-item.unidade  = SUBSTRING(item.fm-cod-com,1,2)
                  AND fam-com-item.segmento = SUBSTRING(fam-comerc.fm-cod-com,3,2)
                  AND fam-com-item.familia1 = "" NO-ERROR.
           IF  AVAIL fam-com-item THEN 
               PUT UNFORMATTED ";":U fam-com-item.descricao .
           ELSE
               PUT UNFORMATTED ";".

           PUT  UNFORMATTED ";":U nota-fiscal.vl-frete.

           IF AVAIL int-ped-item THEN
              PUT UNFORMATTED ";":U int-ped-item.it-codigo-pai.
           ELSE
              PUT UNFORMATTED ";":U.

           IF AVAIL ped-item THEN
               PUT UNFORMATTED ";":U 
                   ped-item.des-pct-desconto-inform.
           ELSE                                           
               PUT UNFORMATTED ";":U.
                                                      

           PUT UNFORMATTED ";":U.
           FOR EACH fat-ser-lote OF it-nota-fisc NO-LOCK:
               PUT UNFORMATTED fat-ser-lote.cod-depos " ".


           END.

           /********************************/

          

           /* Integrador */
           
           FIND FIRST int-nota-fiscal
                WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel   
                AND   int-nota-fiscal.serie       = nota-fiscal.serie         
                AND   int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
           IF  AVAIL int-nota-fiscal THEN
               PUT UNFORMATTED ";" substr(int-nota-fiscal.char-1, 30, 12) FORMAT "x(12)".
           ELSE
               PUT UNFORMATTED ";".
               

           PUT UNFORMATTED ";" it-nota-fisc.vl-icmsub-it FORMAT '>,>>>,>>>,>>9.99' ";"
               nota-fiscal.dt-saida ";"
               c-observ-item ";". /* pode ter conteudo separado por ponto e virgula  o ideal Ç que fique sempre na ultima coluna*/

           IF AVAIL int-ped-venda THEN
               PUT UNFORMATTED SUBSTRING(int-ped-venda.char-1,53,12) ";".
           ELSE
               PUT UNFORMATTED ";".
            

           PUT UNFORMATTED it-nota-fisc.vl-despes-it ";".
           
           PUT UNFORMATTED nota-fiscal.dt-entr-cli ";". /*data de entrega*/
           
           IF AVAIL int-nota-fiscal THEN
               PUT UNFORMATTED SUBSTRING(int-nota-fiscal.char-1,50,10) ";".  /* data de previs∆o da entrega*/
            ELSE PUT UNFORMATTED ";". 
           
           IF  AVAIL ped-venda THEN
               PUT UNFORMATTED ";" ped-venda.cod-priori ";". 
           ELSE 
               PUT UNFORMATTED ";;".

           IF  AVAIL ped-venda THEN
               FIND int-ped-venda2 NO-LOCK
                   WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    
           IF  AVAIL int-ped-venda2 THEN
               PUT UNFORMATTED STRING(int-ped-venda2.int-1) ";".
           ELSE 
               PUT UNFORMATTED ";".

           IF  AVAIL ped-venda 
           AND ped-venda.dt-entorig <> ? THEN
                PUT UNFORMATTED ped-venda.dt-entorig ";".
           ELSE
               PUT UNFORMATTED ";".

           FIND FIRST int-emitente NO-LOCK
                WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

           IF AVAIL int-emitente THEN
               PUT UNFORMATTED int-emitente.cod-gr-cob ";".
           ELSE 
               PUT UNFORMATTED ";".
           
           FIND FIRST ped-repre OF ped-venda NO-LOCK
                WHERE ped-repre.nome-ab-rep <> ped-venda.no-ab-reppri NO-ERROR.

           IF AVAIL ped-repre THEN
               PUT UNFORMATTED ped-repre.nome-ab-rep ";".
           ELSE
               PUT UNFORMATTED ";".

           IF  AVAIL ped-venda THEN
               PUT UNFORMATTED trim(REPLACE(REPLACE(ped-venda.cond-redespa,CHR(13)," "),CHR(10)," ")) ";".
           ELSE 
               PUT UNFORMATTED ";".
	       
	       FOR FIRST ret-nf-eletro NO-LOCK
               WHERE ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
                 AND ret-nf-eletro.cod-serie   = nota-fiscal.serie      
                 AND ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis
                 AND ret-nf-eletro.cod-protoc  = nota-fiscal.cod-protoc: END.
           IF AVAIL ret-nf-eletro THEN
               PUT UNFORMATTED STRING(ret-nf-eletro.dat-ret,"99/99/9999") ";"
                               STRING(ret-nf-eletro.hra-ret,"xx:xx:xx") ";".
           ELSE
               PUT UNFORMATTED ";;".    

           PUT UNFORMATTED de-perc-desc-nota       ";" 
                           de-desc-total-nota      ";" 
                           de-perc-desc-mais-verde ";" 
                           de-val-desc-mais-verde  ";"
                           de-economia-mais-verde  ";"
                           de-perc-desc-top-milhao ";" 
                           de-val-desc-top-milhao  ";"
                           de-economia-top-milhao  ";"
                           de-perc-desc-rebate-ant ";" 
                           de-val-desc-rebate-ant  ";" 
                           de-economia-rebate-ant  ";".

           IF AVAIL int-ped-venda THEN
               PUT UNFORMATTED substring(int-ped-venda.char-1,68,8) ";"
                               int-ped-venda.dt-negociacao FORMAT "99/99/9999" ";".
           ELSE
               PUT UNFORMATTED ";;".

           PUT UNFORMATTED it-nota-fisc.nr-seq-ped ";".

           PUT UNFORMATTED nota-fiscal.nr-volume ";"
                           nota-fiscal.peso-liq ";"
                           nota-fiscal.peso-bru ";".

           IF AVAIL int-ped-venda then
               PUT substring(int-ped-venda.char-1,1,8) ";". //hora entrada
           ELSE
               PUT ";".

           IF AVAIL ped-venda THEN
               PUT UNFORMATTED ped-venda.user-impl ";".
           ELSE
               PUT ";".

           IF AVAIL int-ped-item-pci THEN
                PUT UNFORMATTED mgesp.int-ped-item-pci.nr-tabpre ";".
           ELSE
              PUT ";".

          IF AVAIL ped-item THEN
              PUT IF ped-item.ind-icm-ret = YES THEN "SIM" ELSE "NAO" ";".
          ELSE
              PUT ";".

          IF AVAIL int-ped-venda THEN
             PUT UNFORMATTED SUBSTRING(int-ped-venda.char-1,80,12) ";".

          IF AVAIL int-ped-item-pci THEN
              PUT UNFORMATTED mgesp.int-ped-item-pci.desc-neg-comercial ";".
          ELSE
              PUT ";".
          
           PUT UNFORMATTED SKIP.

           ASSIGN de-perc-desc-mais-verde = 0
                  de-val-desc-mais-verde  = 0
                  de-perc-desc-top-milhao = 0
                  de-val-desc-top-milhao  = 0
                  de-perc-desc-rebate-ant = 0
                  de-val-desc-rebate-ant  = 0
                  de-economia-mais-verde  = 0
                  de-economia-top-milhao  = 0
                  de-economia-rebate-ant  = 0.
       END.

       /** DEVOLUCAO **/
 
       for each devol-cli fields(dt-devol nro-docto serie cod-emitente) USE-INDEX ch-dt-emit NO-LOCK
           where devol-cli.dt-devol      = da-data 
             and devol-cli.cod-estabel  >= tt-param.c-cod-estabel-ini
             and devol-cli.cod-estabel  <= tt-param.c-cod-estabel-fim
             and devol-cli.cod-emitente >= tt-param.i-cod-cli-ini 
             and devol-cli.cod-emitente <= tt-param.i-cod-cli-fim,
           FIRST nota-fiscal FIELDS (cod-estabel serie nr-nota-fis no-ab-reppri emite-duplic nat-operacao cidade estado nome-transp nr-pedcli nr-praz-med 
                                     vl-taxa-exp nr-fatura cod-cond-pag cod-rep dt-emis-nota observ-nota nome-ab-cli dt-entr-cli cod-protoc) NO-LOCK
                 WHERE nota-fiscal.cod-estabel   = devol-cli.cod-estabel
                 AND   nota-fiscal.serie         = devol-cli.serie
                 AND   nota-fiscal.nr-nota-fis   = devol-cli.nr-nota-fis
                 AND   nota-fiscal.emite-duplic
                 AND   nota-fiscal.estado       >= tt-param.uf-ini
                 AND   nota-fiscal.estado       <= tt-param.uf-fim, 
           first emitente fields(nome-emit cgc cod-rep cidade estado e-mail cod-gr-cli cod-emitente) no-lock 
                 WHERE emitente.cod-emitente = devol-cli.cod-emitente 
                 AND   emitente.cod-gr-cli   >= tt-param.i-gr-cli-ini 
                 AND   emitente.cod-gr-cli   <= tt-param.i-gr-cli-fim 
                 AND   emitente.cod-rep      >= tt-param.i-cod-rep-ini
                 AND   emitente.cod-rep      <= tt-param.i-cod-rep-fim
                 AND   ((emitente.cgc        >= c-cgc-ini 
                 AND   emitente.cgc          <= c-cgc-fim) 
                 OR    emitente.cgc = ?),
           FIRST b-emitente  NO-LOCK
              WHERE b-emitente.nome-abrev = emitente.nome-matriz
                AND b-emitente.cod-emitente >= tt-param.matriz-ini
                AND b-emitente.cod-emitente <= tt-param.matriz-fim,
           each item-doc-est fields(item-doc-est.serie-docto item-doc-est.nro-docto item-doc-est.nat-operacao item-doc-est.cod-emitente item-doc-est.it-codigo     item-doc-est.serie-comp     item-doc-est.nro-comp    item-doc-est.seq-comp     item-doc-est.nat-operacao
                                    item-doc-est.quantidade    item-doc-est.preco-total[1] item-doc-est.desconto[1] ITEM-doc-est.aliquota-icm item-doc-est.valor-ipi[1]
                                    item-doc-est.preco-unit[1]) of devol-cli no-lock,
           FIRST ITEM fields(it-codigo fm-cod-com desc-item cod-unid-neg) NO-LOCK 
                 WHERE item.it-codigo  = item-doc-est.it-codigo:
 
           FIND int-repres
                WHERE int-repres.cod-repres = nota-fiscal.cod-rep
                NO-LOCK NO-ERROR.
           IF AVAIL INT-repres THEN
              ASSIGN c-cod-gerente = string(int-repres.cod-gerente).
           ELSE
              ASSIGN c-cod-gerente = "".
           FIND gerente
                WHERE gerente.cod-gerente = INT(c-cod-gerente)
                NO-LOCK NO-ERROR.
           IF AVAIL gerente THEN 
              ASSIGN c-nom-gerente = gerente.nome.
           ELSE
              ASSIGN c-nom-gerente = "".

           IF item.fm-cod-com <> "" THEN
              IF ITEM.fm-cod-com < tt-param.i-familia-com-ini OR
                 ITEM.fm-cod-com > tt-param.i-familia-com-fim THEN NEXT.
            
           FIND fam-comerc
                WHERE fam-comerc.fm-cod-com = ITEM.fm-cod-com
                NO-LOCK NO-ERROR.

           IF tt-param.i-dup-ini = "S" AND 
              tt-param.i-dup-fim = "S" AND 
              nota-fiscal.emite-duplic = NO THEN NEXT.
               
           IF tt-param.i-dup-ini = "N" AND 
              tt-param.i-dup-fim = "N" AND 
              nota-fiscal.emite-duplic = YES THEN NEXT.

           if (item-doc-est.it-codigo < ItCodigoIni or 
                  item-doc-est.it-codigo > ItCodigoFim) then next. 
           
           RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(da-data,"99/99/9999") + " - "+ devol-cli.nro-docto).
           if can-find(first tt-digita) then do:
              find first tt-digita no-lock where 
                  tt-digita.cd-gr-com = ITEM.fm-cod-com no-error.
              if not avail tt-digita then next.
           end.

           find first it-nota-fisc of nota-fiscal no-lock 
               WHERE it-nota-fisc.it-codigo  = item-doc-est.it-codigo 
               AND   it-nota-fisc.nr-seq-fat = item-doc-est.seq-comp no-error.
           IF AVAIL it-nota-fisc THEN
               find first ped-venda no-lock 
                    WHERE ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli 
                    AND   ped-venda.nome-abrev = nota-fiscal.nome-ab-cli no-error.
           
           IF AVAIL ped-venda THEN DO:
              IF int(ped-venda.tp-pedido) < int(tt-param.c-cod-atendente-ini) OR
                 int(ped-venda.tp-pedido) > int(tt-param.c-cod-atendente-fim) THEN NEXT.
           END.
           ELSE DO:
                IF tt-param.c-cod-atendente-ini <> "00" or tt-param.c-cod-atendente-fim <> "99" THEN NEXT.
           END.
           assign d-dt-ent      = ?
                  c-obs         = ""
                  i-atendente   = "".

           FIND FIRST int-ped-venda2 NO-LOCK
                WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido NO-ERROR.

           IF NOT AVAIL int-ped-venda2 THEN DO:
               IF tt-param.grp-canais-ini <> 0 OR tt-param.grp-canais-fim <> 99 THEN NEXT.
           END.
           ELSE DO:
               IF int-ped-venda2.int-1 < tt-param.grp-canais-ini
               OR int-ped-venda2.int-1 > tt-param.grp-canais-fim THEN
                   NEXT.
           END.

           IF AVAIL ped-venda THEN DO:
               IF ped-venda.dt-implant <> dt-dt-implant THEN 
                   ASSIGN dt-dt-implant = ?.
           END. /* IF AVAIL ped-venda THEN DO: */

           FIND FIRST item-uni-estab
               WHERE item-uni-estab.it-codigo   = item.it-codigo
                 AND item-uni-estab.cod-estabel = devol-cli.cod-estabel NO-LOCK NO-ERROR.

           IF tt-param.l-troca THEN DO:
               IF AVAIL ped-venda THEN DO:
                  FIND FIRST int-ped-venda
                       WHERE int-ped-venda.cod-estabel = ped-venda.cod-estabel
                         AND int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-LOCK NO-ERROR.
                  IF AVAIL int-ped-venda THEN 
                      IF substring(int-ped-venda.char-1,11,1) <> "S" THEN NEXT.
                  ELSE
                      NEXT.
               END.
               ELSE NEXT.
           END.
           
           if avail ped-venda then do:
                   
              find first ped-item no-lock of ped-venda 
                   WHERE ped-item.it-codigo    = it-nota-fisc.it-codigo 
                   AND   ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped no-error.
              find int-ped-item NO-LOCK
                where int-ped-item.nome-abrev      = ped-venda.nome-abrev
                  and int-ped-item.nr-pedcli       = ped-venda.nr-pedcli
                  and int-ped-item.nr-sequencia    = ped-item.nr-sequencia
                  and int-ped-item.it-codigo       = ped-item.it-codigo
                  and int-ped-item.cod-refer       = ped-item.cod-refer no-error.

              assign d-dt-ent      = ped-item.dt-entrega
                     i-atendente   = ped-venda.tp-pedido
                     dt-dt-implant = ped-venda.dt-implant
                     c-obs         = substr(ped-venda.observacoes,1,170)
                     c-obs         = REPLACE(c-obs,CHR(10),"")
                     c-obs         = REPLACE(c-obs,CHR(13),"")
                     c-obs         = REPLACE(c-obs,CHR(09),"")
                     c-obs         = REPLACE(c-obs,";",",").
 
              /** Coloquei aqui porque a unidade de neg¢cio precisa do registro
                  da it-nota-fisc; se deixar pra rodar somente fora do bloco,
                  o registro do item Ç perdido, e a unidade ficaria sempre
                  como inv†lida **/
               run piTrataRelat.
           end.
           else
              RUN piTrataRelat.
              
           IF  c-unid-neg < tt-param.c-unid-neg-ini or
               c-unid-neg > tt-param.c-unid-neg-fim THEN NEXT.

           ASSIGN cRegiao = IF AVAIL regiao THEN regiao.nome-regiao ELSE "".

           ASSIGN c-sit-ped = "".
           IF AVAIL ped-venda THEN
              IF ped-venda.cod-sit-ped = 1 THEN
                 ASSIGN c-sit-ped = "ABERTO".
              ELSE
                 IF ped-venda.cod-sit-ped = 2 THEN 
                    ASSIGN c-sit-ped = "AT.PARCIAL".
                 ELSE
                     IF ped-venda.cod-sit-ped = 3 THEN 
                        ASSIGN c-sit-ped = "AT.TOTAL".
                      ELSE
                         IF ped-venda.cod-sit-ped = 5 THEN 
                            ASSIGN c-sit-ped = "SUSPENSO".

 
/*           if avail nota-fiscal then  */
              put UNFORMATTED string(nota-fiscal.nr-nota-fis,'x(10)')                                                  ";"
                   nota-fiscal.serie FORMAT 'x(03)'                                                        ";".
              put  nota-fiscal.emite-duplic                                                                ";".
              put UNFORMATTED
                   devol-cli.dt-devol                                                                      ";"
                   nota-fiscal.nat-operacao                                                                ";"
                   devol-cli.cod-emitente                                                                  ";"
                   emitente.nome-emit                                                                      ";"
                   nota-fiscal.cidade                                                                      ";"
                   nota-fiscal.estado                                                                      ";"
                   emitente.cgc                                                                            ";"
                   cRegiao                                                                                 ";"
                   c-desc-grupo                                                                            ";"
                   c-cod-gerente                                                                           ";"
                   c-nom-gerente                                                                           ";"
                   /*nota-fiscal.cod-rep 
                     Retirado por solicitaá∆o do Luciano/Claudiney em 02/02
                     Alterado por claudiney novamente para nota-fiscal em 03/08/06 */
                   nota-fiscal.cod-rep                                                                        ";"
                   nota-fiscal.no-ab-reppri                                                                ";"
                   nota-fiscal.nome-transp                                                                 ";"
                   nota-fiscal.nr-pedcli                                                                   ";"
                   d-dt-ent                                                                                ";"
                   c-sit-ped                                                                               ";"
                   item-doc-est.it-codigo   format "x(07)"                                                 ";"
                   item.desc-item           format "X(60)"                                                 ";".
               IF AVAIL fam-comerc THEN
                  PUT UNFORMATTED fam-comerc.fm-cod-com                    ";"
                      fam-comerc.descricao                     ";".
               ELSE
                   PUT UNFORMATTED "; ;".
               PUT UNFORMATTED item-doc-est.quantidade * -1 format "->,>>>,>>9.99" " "                                 ";"
                   (item-doc-est.preco-total[1] - item-doc-est.desconto[1])  * -1 format "->>>,>>>,>>9.99" ";"
                   c-obs format "X(170)"                                                                    ";".
               IF nota-fiscal.nr-praz-med < 0 THEN
                   PUT UNFORMATTED ";".
               ELSE
                   PUT UNFORMATTED nota-fiscal.nr-praz-med                                                                 ";".
               PUT UNFORMATTED 
                   string(item-doc-est.aliquota-icm,">>9.99")                                              ";".                                                                                       
/*           else DO:
               put string(devol-cli.nro-docto,"x(10)")       ";"
                   devol-cli.serie FORMAT 'x(03)' 
                   ";Sim;"
                   devol-cli.dt-devol        ";"                                                           
                   item-doc-est.nat-operacao ";"
                   devol-cli.cod-emitente    ";" 
                   emitente.nome-emit        ";"
                   b-emitente.cod-emitente   ";"
                   emitente.cidade           ";" 
                   emitente.estado           ";"
                   emitente.cgc              ";" 
                   cRegiao                                                                                 ";"
                   c-desc-grupo              ";"
                   emitente.cod-rep          ";" 
                   repres.nome-abrev         ";" 
                   "            ;            ;"
                   d-dt-ent                  ";" 
                   item-doc-est.it-codigo    format "x(07)" ";"
                   item.desc-item            format "X(36)" ";"
                   c-ds-gr                   ";" 
                   c-ds-sub                  ";" 
                   c-ds-cor                  ";"
                   item-doc-est.quantidade * -1 format "->,>>>,>>9.99" ";"
                   (item-doc-est.preco-total[1] -
                   item-doc-est.desconto[1]) * -1 format "->>>>,>>>,>>9.99" ";"
                   c-obs format "X(30)" ";"
                   i-p-medio   ";"
                   string(item-doc-est.aliquota-icm,">>9.99") ";".
           end.    */
           PUT UNFORMATTED de-perc-acordo format ">9.99".
              
           put UNFORMATTED ";COND INVALIDA-NFS NAO ENCONTR ;"
                (item-doc-est.preco-total[1] - item-doc-est.desconto[1] +
                 item-doc-est.valor-ipi[1]) * -1 format "->>>>,>>>,>>9.99" ";"
               c-unid-neg ";".
 
           ASSIGN de-perc-comissao = 0.
 
           /** Busca comiss∆o pela BO **/
           RUN getComissao IN {&hDBOTable} (INPUT nota-fiscal.cod-estabel,
                                            INPUT nota-fiscal.cod-rep,
                                            INPUT emitente.cod-emitente,
                                            INPUT ITEM.fm-cod-com,
                                            INPUT nota-fiscal.dt-emis-nota,
                                            OUTPUT de-perc-comissao) NO-ERROR.
           
           if nota-fiscal.dt-emis-nota < 03/01/2008 then
                for each fat-repre 
                    where fat-repre.cod-estabel = nota-fiscal.cod-estabel
                      and fat-repre.serie       = nota-fiscal.serie
                      and fat-repre.nr-fatura   = nota-fiscal.nr-fatura no-lock:
                   assign de-perc-comissao = fat-repre.perc-comis.
                end.
     
           FIND LAST preco-item NO-LOCK
                WHERE preco-item.it-codigo = item-doc-est.it-codigo
                AND   preco-item.cod-refer = ""
                AND   preco-item.nr-tabpre = "minimo" NO-ERROR.
           IF AVAIL preco-item THEN
              ASSIGN de-preco-min = preco-item.preco-venda.
           ELSE
               ASSIGN de-preco-min = 0.
           assign    c-obs       = REPLACE(nota-fiscal.observ-nota,CHR(10),"")
                     c-obs       = REPLACE(c-obs,CHR(13),"")
                     c-obs       = REPLACE(c-obs,CHR(09),"")
                     c-obs       = REPLACE(c-obs,";",",").               
           
           PUT UNFORMATTED de-perc-comissao ";" 
               i-atendente ";"
               item-doc-est.preco-unit[1] ";"
               de-preco-min ";"
               nota-fiscal.vl-taxa-exp ";"
               dt-dt-implant ";"
               b-emitente.cod-emitente ";"
               b-emitente.nome-abrev ";"
               c-unid-nota ";"
               c-obs format "x(140)" ";".
           assign c-obs = "".
           IF (nota-fiscal.cod-estabel = "103" OR
               nota-fiscal.cod-estabel = "301") AND
               AVAIL ped-venda THEN DO:
               FIND repres
                    WHERE repres.nome-abrev = ped-venda.no-ab-reppri
                    NO-LOCK NO-ERROR.
               IF AVAIL repres THEN
                  PUT UNFORMATTED repres.cod-rep ";".
               ELSE
                  PUT  UNFORMATTED ";".
           END.
           ELSE PUT UNFORMATTED ";".

           PUT UNFORMATTED devol-cli.nro-docto ";"
               devol-cli.serie-docto ";".
           IF nota-fiscal.nr-pedcli <> "" THEN DO:
               FIND int-ped-venda
                    WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                      AND int-ped-venda.cod-estabel = ped-venda.cod-estabel
                    NO-LOCK NO-ERROR.
               IF AVAIL INT-ped-venda THEN 
                   PUT UNFORMATTED int-ped-venda.ParceiroCodigo ";"
                        SUBSTRING(int-ped-venda.char-1,12,3) ";"
                        SUBSTRING(int-ped-venda.char-1,26,15) .
               ELSE
                   PUT UNFORMATTED ";;".
           END.
           ELSE PUT UNFORMATTED ";;".

           PUT UNFORMATTED ";":U STRING(nota-fiscal.cod-estabel, "x(3)":U).

           FIND FIRST unid_negoc NO-LOCK
               WHERE unid_negoc.cod_unid_negoc = ITEM.cod-unid-negoc NO-ERROR.

           FIND FIRST fam-com-item NO-LOCK
                WHERE fam-com-item.unidade  = SUBSTRING(item.fm-cod-com,1,2)
                  AND fam-com-item.segmento = SUBSTRING(fam-comerc.fm-cod-com,3,2)
                  AND fam-com-item.familia1 = "" NO-ERROR.
           IF  AVAIL fam-com-item THEN 
               PUT UNFORMATTED ";":U fam-com-item.descricao.
           ELSE 
               PUT UNFORMATTED ";".

           PUT UNFORMATTED ";".


        PUT  UNFORMATTED ";":U
                         ";":U
                         ";":U
                         ";":U
                         ";":U
                         ";":U
                         ";":U 
                         ";":U
                         ";":U.



        IF nota-fiscal.nr-pedcli <> "" THEN DO:
           FIND ped-venda
               WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli
                 AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
               NO-LOCK NO-ERROR.
           FIND int-ped-venda
                 WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                 NO-LOCK NO-ERROR.
    
            IF AVAIL int-ped-venda THEN
    
                PUT UNFORMATTED  SUBSTRING(int-ped-venda.char-1,53,12) ";".
            ELSE
                PUT UNFORMATTED ";".
    
         END.
         ELSE PUT UNFORMATTED ";":U.

         PUT UNFORMATTED nota-fiscal.dt-entr-cli ";". /*data de entrega*/
           
         IF AVAIL int-nota-fiscal THEN
             PUT UNFORMATTED SUBSTRING(int-nota-fiscal.char-1,50,10) ";" .  /* data de previs∆o da entrega*/
         ELSE
             PUT UNFORMATTED ";":U .
         
         FOR FIRST docum-est OF item-doc-est NO-LOCK:
         END.
         FIND FIRST int-docum-est OF docum-est NO-LOCK NO-ERROR.

         FIND FIRST int-ped-venda2
              WHERE int-ped-venda2.nr-pedido   = ped-venda.nr-pedido  NO-LOCK NO-ERROR.

         PUT UNFORMATTED IF AVAIL int-docum-est  THEN int-docum-est.cod-msg-devolucao ELSE 0  FORMAT "999"   ";".
         PUT UNFORMATTED IF AVAIL ped-venda      THEN string(ped-venda.cod-priori)    ELSE "" FORMAT "X(10)" ";".
         PUT UNFORMATTED (IF AVAIL int-ped-venda2 THEN int-ped-venda2.int-1 ELSE 0) ";".
         PUT UNFORMATTED ";;;;".

         FOR FIRST ret-nf-eletro NO-LOCK
             WHERE ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
               AND ret-nf-eletro.cod-serie   = nota-fiscal.serie      
               AND ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis
               AND ret-nf-eletro.cod-protoc  = nota-fiscal.cod-protoc: END.
         IF AVAIL ret-nf-eletro THEN
            PUT UNFORMATTED STRING(ret-nf-eletro.dat-ret,"99/99/9999") ";"
                            STRING(ret-nf-eletro.hra-ret,"xx:xx:xx") ";".
         ELSE
            PUT UNFORMATTED ";;".

         PUT UNFORMATTED de-perc-desc-nota       ";" 
                         de-desc-total-nota      ";" 
                         de-perc-desc-mais-verde ";" 
                         de-val-desc-mais-verde  ";"
                         de-economia-mais-verde  ";"
                         de-perc-desc-rebate-ant ";" 
                         de-val-desc-rebate-ant  ";" 
                         de-economia-rebate-ant  ";"
                         de-perc-desc-top-milhao ";" 
                         de-val-desc-top-milhao  ";"
                         de-economia-top-milhao  ";".

         PUT UNFORMATTED SKIP.

         ASSIGN de-perc-desc-mais-verde = 0
                de-val-desc-mais-verde  = 0
                de-perc-desc-top-milhao = 0
                de-val-desc-top-milhao  = 0
                de-perc-desc-rebate-ant = 0
                de-val-desc-rebate-ant  = 0
                de-economia-mais-verde  = 0
                de-economia-top-milhao  = 0
                de-economia-rebate-ant  = 0.

     END.

     /* Desconto mais verde */
    END.
    PUT UNFORMATTED    
    "     " skip.
 
    RUN destroyDBO.
 
END PROCEDURE.
 
PROCEDURE piTrataRelat:
 
    find first cond-pagto no-lock where
          cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag no-error.
 
    if avail cond-pagto then
       ASSIGN c-desc-cond = cond-pagto.descricao.
    ELSE
       ASSIGN c-desc-cond = "N«O ENCONTRADA OU ESPECIAL".
    assign c-mail = emitente.e-mail.
    
    find gr-cli no-lock where
         gr-cli.cod-gr-cli = emitente.cod-gr-cli no-error.
    if avail gr-cli then
       assign c-desc-grupo = gr-cli.descricao.
    else
       assign c-desc-grupo = string(emitente.cod-gr-cli,"99") + 
                             " - Grupo nao cadastrado".
    
    find first repres no-lock where
         repres.nome-abrev = nota-fiscal.no-ab-reppri no-error.
 
    find first regiao no-lock where    
         regiao.nome-ab-reg = repres.nome-ab-reg no-error.
 
/*     assign c-unid-neg = "".                                               */
/*     find first unid-neg-item no-lock                                      */
/*          where unid-neg-item.it-codigo = item.it-codigo no-error.         */
/*     if   avail unid-neg-item then                                         */
/*          assign c-unid-neg = unid-neg-item.cod_unid_negoc.                */
/*     ELSE DO:                                                              */
/*         FIND FIRST unid-neg-fam-com NO-LOCK                               */
/*              WHERE unid-neg-fam-com.fm-codigo = item.fm-cod-com NO-ERROR. */
/*         if   avail unid-neg-fam-com then                                  */
/*              assign c-unid-neg = unid-neg-fam-com.cod_unid_negoc.         */
/*         else assign c-unid-neg = "INVALIDA".                              */
/*     END.                                                                  */
 
/*     assign c-unid-nota = "INVALIDA".                              */
/*                                                                   */
/*     for each unid-neg-fat no-lock                                 */
/*         where unid-neg-fat.cod-estabel = it-nota-fisc.cod-estabel */
/*           and unid-neg-fat.serie       = it-nota-fisc.serie       */
/*           and unid-neg-fat.nr-nota-fis = it-nota-fisc.nr-nota-fis */
/*           and unid-neg-fat.nr-seq-fat  = it-nota-fisc.nr-seq-fat  */
/*           and unid-neg-fat.it-codigo   = it-nota-fisc.it-codigo:  */
/*        assign c-unid-nota = unid-neg-fat.cod_unid_negoc.          */
/*     end.                                                          */
/*                                                                   */


    assign c-unid-neg  = IF AVAILABLE item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE item.cod-unid-negoc.
           c-unid-nota = it-nota-fisc.cod-unid-negoc.
 
    RUN esbo/boes464.p PERSISTENT SET h-boes464.
    RUN getAcordoComercial IN h-boes464    (INPUT emitente.cgc,
                                            INPUT nota-fiscal.cod-estabel,
                                            INPUT c-unid-nota,
                                            INPUT ITEM.fm-cod-com,
                                            INPUT nota-fiscal.dt-emis-nota,
                                            OUTPUT i-id-faturamento-acordo,
                                            OUTPUT i-id-base-calc-acordo,
                                            OUTPUT i-id-devolucoes,
                                            OUTPUT de-perc-acordo) NO-ERROR.
    IF VALID-HANDLE(h-boes464) THEN
        DELETE PROCEDURE h-boes464.
    
    IF AVAIL cond-pagto THEN DO:
        assign i-p-medio = (cond-pagto.prazos[1] + cond-pagto.prazos[2] +
                            cond-pagto.prazos[3] + cond-pagto.prazos[4] +
                            cond-pagto.prazos[5] + cond-pagto.prazos[6] +
                            cond-pagto.prazos[7] + cond-pagto.prazos[8] +
                            cond-pagto.prazos[9] + cond-pagto.prazos[10] +
                            cond-pagto.prazos[11] + cond-pagto.prazos[12]) /
                            cond-pagto.num-parcelas.
        IF i-p-medio < 0 THEN
           ASSIGN i-p-medio = 0.
    END.
        
    ELSE
        ASSIGN i-p-medio = 1.               

END PROCEDURE.


