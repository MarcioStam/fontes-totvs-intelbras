/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp029rp.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Janeiro/2008 - Desenvolvimento
**  Descricao.: Relat¢rio de pedidos em carteira
-----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i espdp029 2.04.00.002}

/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/pdp/espdp029.i}
{cdp/cd0666.i}

DEF BUFFER b-emitente FOR emitente.

FIND FIRST param-global NO-LOCK.
FIND FIRST empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Pedidos em carteira"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESPDP029"
       c-versao       = "2.04"
       c-revisao      = "002".

{esp/pdp/espdp029tt.i}

{esp/pdp/espdp006fn.i}

DEFINE VARIABLE c-sit-item      AS CHARACTER FORMAT "X(20)"  NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE d-cotacao       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-sit-cred      AS CHARACTER   FORMAT "X(20)" NO-UNDO.
DEFINE VARIABLE c-sit-ped       AS CHARACTER   NO-UNDO.

define variable c-unid-neg        like unid-neg-item.cod_unid_negoc   no-undo.
DEFINE VARIABLE c-obs             AS CHARACTER   NO-UNDO FORMAT 'x(170)'.
DEFINE VARIABLE c-cond-espec      AS CHARACTER   NO-UNDO FORMAT 'x(80)'.
DEFINE VARIABLE de-perc-comissao  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-acordo    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-id-faturamento  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-id-base-calculo AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-id-devolucoes   AS INTEGER     NO-UNDO.
DEFINE VARIABLE hDBOcomis-rep     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boes464         AS HANDLE      NO-UNDO.
&GLOBAL-DEFINE ttTable        ttcomis-rep
&GLOBAL-DEFINE hDBOTable      hDBOcomis-rep
&GLOBAL-DEFINE DBOTable       comis-rep
DEFINE VARIABLE p-de-aliquota-excessao AS DECIMAL     NO-UNDO.
DEFINE VARIABLE p-de-aliquota AS DECIMAL     NO-UNDO.
DEF BUFFER b-unid-feder FOR unid-feder.
DEFINE VARIABLE l-proc-ok-aux AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-item-descricao-1 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-item-descricao-2 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-fam-comerc-descricao AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ped-venda-desc-bloq-cr AS CHARACTER   NO-UNDO.
DEFINE VARIABLE qt-alocada         AS DECIMAL NO-UNDO.
DEFINE VARIABLE i-GrpCanais  AS INTEGER     NO-UNDO.
define variable dt-inicial as date      no-undo.
define variable dt-final   as date      no-undo.
define variable dt-data    as date      no-undo.
DEFINE VARIABLE de-alocado AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-considera-acesso-restrito AS CHARACTER  FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE de-considera-acesso AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-label-producao    AS CHAR FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE c-data-previsao AS CHAR no-undo.
DEFINE VARIABLE c-parcial   AS CHAR NO-UNDO.
DEFINE VARIABLE de-qtd-possivel AS DEC NO-UNDO.
DEFINE VARIABLE de-saldo-item   AS DEC NO-UNDO.
DEFINE VARIABLE i-cd-canal       AS INTEGER   NO-UNDO.
DEFINE VARIABLE d-valor-st       AS DEC NO-UNDO.
DEFINE VARIABLE de-perc-desc-mais-verde AS DEC NO-UNDO.
DEFINE VARIABLE de-val-desc-mais-verde  AS DEC NO-UNDO.
DEFINE VARIABLE de-perc-desc-rebate-ant AS DEC NO-UNDO.
DEFINE VARIABLE de-val-desc-rebate-ant  AS DEC NO-UNDO.
DEFINE VARIABLE de-perc-desc-top-milhao AS DEC NO-UNDO.
DEFINE VARIABLE de-val-desc-top-milhao  AS DEC NO-UNDO.
DEFINE VARIABLE de-economia-mais-verde  AS DEC NO-UNDO.
DEFINE VARIABLE de-economia-top-milhao  AS DEC NO-UNDO.
DEFINE VARIABLE de-economia-rebate-ant  AS DEC NO-UNDO.

DEFINE VARIABLE d-valor-total-aloc      AS DEC NO-UNDO.
DEFINE VARIABLE d-valor-ipi-aloc        AS DEC NO-UNDO.
DEFINE VARIABLE d-valor-st-aloc         AS DEC NO-UNDO.
DEFINE VARIABLE p-ipi-tributacao        AS INT NO-UNDO.

DEFINE BUFFER b-natur FOR natur-oper.
                 
DEF TEMP-TABLE tt-previsao
    FIELD it-codigo  AS CHAR 
    FIELD data       AS DATE
    FIELD quantidade AS DEC
    INDEX idx-primary
            it-codigo
            data.

/*---------------------------  ParÉmetros   ---------------------------*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
   {include/i-rpcab.i}
   {include/i-rpout.i &pagesize="0"}
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").
   RUN initializeDBO.
   RUN piImprimeRelat.
   RUN destroyDBO.
   RUN pi-finalizar IN h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
END.

PROCEDURE initializeDBO:
   IF NOT VALID-HANDLE({&hDBOTable}) OR
      {&hDBOTable}:TYPE <> "PROCEDURE":U OR
      {&hDBOTable}:FILE-NAME <> "boes396.p":U THEN DO:
      RUN esbo/boes396.p PERSISTENT SET {&hDBOTable}.
   END.
   IF NOT VALID-HANDLE(h-boes464) THEN
      RUN esbo/boes464.p PERSISTENT SET h-boes464.
   
END.

PROCEDURE destroyDBO:
   IF VALID-HANDLE({&hDBOTable}) THEN DO:
      RUN destroy IN {&hDBOTable}.
   END.

   DELETE PROCEDURE {&hDBOTable}.
   DELETE PROCEDURE h-boes464.
END.


PROCEDURE piImprimeRelat:

    
   IF  tt-param.tg-importa THEN DO:
       ASSIGN c-label-producao = "Previs∆o Produá∆o;Atende?;Resta no Estoque".
       RUN pi-importa-previsao-producao.
   END.

   /*assign dt-inicial = date(month(today), 1, year(today)).
   if (day(today) <= 3) then
      assign dt-inicial = add-interval(dt-inicial, -1, 'months').

   assign dt-final = date(month(today), 1, year(today))
          dt-final = add-interval(dt-final, 1, 'months') - 1. */

   IF DAY(TODAY) < 21 THEN DO:
       IF MONTH(TODAY) = 1 THEN
          ASSIGN dt-inicial = date(12, 21, year(today) - 1).
       ELSE
          ASSIGN dt-inicial = date((month(today) - 1), 21, year(today)).
   END.
   ELSE 
      assign dt-inicial = date(month(today), 21, year(today)).
 
   IF MONTH(TODAY) = 12 THEN
      assign dt-final = date(01 , 20, year(today) + 1).
   ELSE DO:
      IF DAY(TODAY) < 21 THEN
         assign dt-final = DATE(MONTH(TODAY), 20, year(today)).
      ELSE
         assign dt-final = date((MONTH(TODAY) + 1), 20, year(today)).
        // dt-final = add-interval(dt-final, 20, 'days') + 30. 
   END.



   IF  tt-param.l-cancelados OR tt-param.l-itens-cancelados THEN DO:
       IF  c-label-producao = "" THEN
           ASSIGN c-label-producao = ";Motivo Cancelamento;Dt Cancel".
       ELSE
           ASSIGN c-label-producao = ';' + c-label-producao + ";Motivo Cancelamento;Dt Cancel".
   END.

   PUT UNFORMATTED "Cliente;Gr Cli;Nome abrev;Cod.Matriz;Nome Matriz;Estab;Nr Pedido;Dup;Dt Implant;Hora Impl.;Prev.Fatur;Completo;Usuar Implantou;Atend;Repres;Nome Repres;Cidade;UF;ICMS;Nat Op.;Cond Pagto;Item;Descricao;Cod.Familia;Desc.Familia;Categoria;Prioridade;Unid.Neg;Saldo;Vl Total;Comis;Acordo;Vl com IPI;Situacao Pedido;Situacao Item Pedido;Sit Credito;Motivo Aval.Cred;Observacao do Pedido;Observacao da Nota Fiscal;Valor Frete;Preáo Minimo;Segmento;Qt Log Aloc;PO Cliente;Transportadora;Sequencia Item Pedido;Valor Acesso Restrito;Motivo Acesso Restrito;Prev. Fat Pedido;Canal de venda;Prev. Fat. Original;ID Projeto;REP2;Vl ST; Transp Redesp" c-label-producao ";% Desc Mais Verde;Vl Desc Mais Verde;Economia Mais Verde;% Desc Top Milhao;Vl Desc Top Milhao;Economia Top Milhao;% Desc Rebate Ant;Vl Desc Rebate Ant;Economia Rebate Antecipado;Vl Aloc; Vl IPI Aloc; Vl ST Aloc; Supervisor;Preco Orig; %Desc Item; Dt Negociacao;Troca NF;Desc Ped;Cod Cond Pagto; Destino Merc; Contribuinte ICMS;Dias Negoc;Fat Parcial;Tab Preco SalesForce;ICMS ST;Desc Acordo Com" SKIP.
   
   IF  tt-param.tg-importa THEN DO: /* CASO TENHA SELECIONADO A OPÄ«O IMPORTAR ARQUIVO DE PREVIS«O DE PRODUÄ«O */
       CASE tt-param.rs-class:
           WHEN 1 THEN DO:    
               IF  tt-param.l-selecao-acesso-restrito THEN DO:
                   {esp/pdp/espdp029rp.i1 "by ped-venda.nr-pedcli" "by ped-venda.nr-pedido"} 
               END.
               ELSE DO:
                   {esp/pdp/espdp029rp.i2 "by ped-venda.nr-pedcli" "by ped-venda.nr-pedido"} 
               END.
           END.
           WHEN 2 THEN DO:
               IF  tt-param.l-selecao-acesso-restrito THEN DO:
                   {esp/pdp/espdp029rp.i1 "by ped-venda.dt-implant" "by ped-venda.nr-pedido"} 
               END.
               ELSE DO:
                   {esp/pdp/espdp029rp.i2 "by ped-venda.dt-implant"  "by ped-venda.nr-pedido"} 
               END.
           END.
           WHEN 3 THEN DO:
               IF  tt-param.l-selecao-acesso-restrito THEN DO:
                   {esp/pdp/espdp029rp.i1 "by ped-item.dt-entrega" "by ped-venda.nr-pedido"} 
               END.
               ELSE DO:
                   {esp/pdp/espdp029rp.i2 "by ped-item.dt-entrega" "by ped-venda.nr-pedido"} 
               END.
           END.
       END CASE.
   END.
   ELSE DO:
       IF  tt-param.l-selecao-acesso-restrito THEN DO:
           {esp/pdp/espdp029rp.i1 "by ped-venda.nr-pedido"} 
       END.
       ELSE DO:
           {esp/pdp/espdp029rp.i2 "by ped-venda.nr-pedido"} 
       END.
   END.

   RETURN "OK".
END.

PROCEDURE localizaUnidFederOrigem:
    /* Definiªío dos par≥metros de Entrada/Sa≠da */
    def input  param p-c-pais            like unid-feder.pais   no-undo.
    def input  param p-c-estado          like unid-feder.estado no-undo.
    def input  param p-c-estado-destino          like unid-feder.estado no-undo.
    
    def output param p-l-procedimento-ok as log                 no-undo.

    

    /* Definiªío de variˇveis locais */
    def var i-cont as int no-undo.
    

    /* Localiza unidade de federaªío origem e disponibiliza somente os campos necessˇrios */
    for first b-unid-feder
        where b-unid-feder.pais   = p-c-pais
        and   b-unid-feder.estado = p-c-estado no-lock:
    end.

    /*------------------------------------------------------------------------------------+
     | Buscar a aliquota de ICMS e desconto de ICMS nas  excessÑes  agora  e  para evitar |
     | processamento desnecessˇrio quando serˇ determinada a aliquota o desconto de ICMS. |
     | O registro da tabela b-b-unid-feder-dest deve estar dispon≠vel obrigatoriamente.     |
     +------------------------------------------------------------------------------------+*/
    
    if  avail b-unid-feder then 
        do  i-cont = 1 to 12:
            if  b-unid-feder.est-exc[i-cont] = p-c-estado-destino then
                assign p-de-aliquota-excessao  = b-unid-feder.perc-exc[i-cont].
    end.
END PROCEDURE.

PROCEDURE pi-imprime:
    RUN pi-acompanhar IN h-acomp (INPUT "Selecionando pedido: " + STRING(ped-venda.nr-pedido)).

    IF ped-item.cod-unid-neg <> "" THEN
        ASSIGN c-unid-neg = ped-item.cod-unid-neg.
    ELSE DO:
        ASSIGN c-unid-neg = "INVALIDA".

        FOR EACH unid-neg-ped OF ped-item NO-LOCK:
           ASSIGN c-unid-neg = unid-neg-ped.cod_unid_negoc.
        END.
        IF c-unid-neg = "INVALIDA" THEN DO:
            FIND unid-neg-fam-com
                WHERE unid-neg-fam-com.fm-codigo = ITEM.fm-cod-com
                NO-LOCK NO-ERROR.
            IF AVAIL unid-neg-fam-com THEN DO:
                ASSIGN c-unid-neg = unid-neg-fam-com.cod_unid_negoc.
            END.
        END.
    END.

    FIND FIRST cotacao NO-LOCK
       WHERE cotacao.mo-codigo   = ped-venda.mo-codigo
         AND cotacao.ano-periodo = STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") NO-ERROR.
    IF AVAILABLE (cotacao) AND (cotacao.cotacao[DAY(TODAY)] <> 0) THEN
       ASSIGN d-cotacao = cotacao.cotacao[DAY(TODAY)].
    ELSE
       ASSIGN d-cotacao = 1.

    FIND FIRST cond-pagto NO-LOCK
       WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.

    FIND FIRST unid-feder NO-LOCK
          WHERE unid-feder.pais   = emitente.pais
            AND unid-feder.estado = emitente.estado NO-ERROR.


    ASSIGN p-de-aliquota-excessao = 0
           p-de-aliquota          = 0.
    if  not avail unid-feder
    or  unid-feder.estado <> estabelec.estado
    or  unid-feder.pais   <> estabelec.pais then do:
        run localizaUnidFederOrigem(input  estabelec.pais,
                                    input  estabelec.estado,
                                    INPUT  emitente.estado,
                                    output l-proc-ok-aux).
    end.

    FIND FIRST icms-it-uf NO-LOCK /*Chamado 153597 ft0312*/
         WHERE icms-it-uf.it-codigo = ped-item.it-codigo 
           AND icms-it-uf.estado    = ped-venda.estado NO-ERROR.
    IF AVAIL icms-it-uf THEN 
       ASSIGN p-de-aliquota = icms-it-uf.aliquota-icm.
    ELSE DO:
         if emitente.contrib-icms                                      /* Contribuinte de ICMS    */
            and estabelec.estado <> unid-feder.estado THEN DO: /* UF destino <> UF origem */
                   if   p-de-aliquota-excessao > 0   then 
                        assign p-de-aliquota = p-de-aliquota-excessao.             
                   else do:
                         if   unid-feder.per-icms-ext > 0 then DO:
           
                             assign p-de-aliquota = unid-feder.per-icms-ext.    
                         END.     
                   END.
            END.
            else /* Utiliza da natureza de operacao */
                IF  unid-feder.per-icms-int > 0  THEN
                    ASSIGN p-de-aliquota =  unid-feder.per-icms-int. 
    END.

    if  p-de-aliquota = 0 then
        assign p-de-aliquota = natur-oper.aliquota-icm.


    RUN getAcordoComercial IN h-boes464 (INPUT emitente.cgc,                 /*raiz-cnpj ou cnpj completo (ser† tratado na bo)*/
                                         INPUT ped-venda.cod-estabel,        /*estabelecimento*/
                                         INPUT c-unid-neg,                   /*unidade negocio*/
                                         INPUT ITEM.fm-cod-com,              /*familia comercial*/
                                         INPUT ped-venda.dt-emissao,
                                         OUTPUT i-id-faturamento,
                                         OUTPUT i-id-base-calculo,
                                         OUTPUT i-id-devolucoes,
                                         OUTPUT de-perc-acordo) NO-ERROR.
    FIND b-emitente
         WHERE b-emitente.nome-abrev = emitente.nome-matriz
         NO-LOCK NO-ERROR.
    FIND int-ped-venda
        WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
          AND int-ped-venda.cod-estabel = ped-venda.cod-estabel
        NO-LOCK NO-ERROR.
    
    FIND FIRST ped-repre NO-LOCK
         WHERE ped-repre.nr-pedido   = ped-venda.nr-pedido
           AND ped-repre.ind-repbase = NO NO-ERROR.
    PUT
       emitente.cod-emitente ";"
       emitente.cod-gr-cli ";"
       emitente.nome-abrev ";"
       IF NOT AVAIL b-emitente THEN 0 ELSE b-emitente.cod-emitente ";"
       emitente.nome-matriz ";"
       ped-venda.cod-estabel ";"
       ped-venda.nr-pedcli ";"
       natur-oper.emite-duplic ";"
       ped-venda.dt-implant ";".
       IF AVAIL int-ped-venda then
           PUT substring(int-ped-venda.char-1,1,8) ";".
       ELSE
           PUT ";".
   PUT ped-item.dt-entrega ";"
       ped-venda.completo  ";"
       ped-venda.user-impl ";"
       ped-venda.tp-pedido ";"
       repres.cod-rep ";"
       repres.nome-abrev ";"
       loc-entr.cidade ";"
       loc-entr.estado ";"
       p-de-aliquota ";"    
       natur-oper.nat-operacao ";".

    IF AVAILABLE (cond-pagto) THEN
       PUT cond-pagto.descricao ";".
    ELSE
       PUT "NAO ENCONTRADA OU ESPECIAL;".

    PUT
       ped-item.it-codigo FORMAT 'x(7)' ";".

    ASSIGN c-item-descricao-1 = fn-retira-espec(item.descricao-1)
           c-item-descricao-2 = fn-retira-espec(item.descricao-2).

    PUT UNFORMAT c-item-descricao-1   
                 c-item-descricao-2 ";".

    find fam-comerc
         where fam-comerc.fm-cod-com = item.fm-cod-com no-lock no-error.
    if avail fam-comerc then DO:
        ASSIGN c-fam-comerc-descricao = fn-retira-espec(fam-comerc.descricao).

        PUT UNFORMAT fam-comerc.fm-cod-com ";"
                     c-fam-comerc-descricao ";".
    END.
    ELSE
        PUT ";Familia nao cadastrada" ";".

    IF AVAIL int-ped-venda THEN
       PUT substring(int-ped-venda.char-1,12,3) ";".
    ELSE
        PUT ";".

    PUT ped-venda.cod-priori ";".

    PUT c-unid-neg ";".

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
               ELSE
                   IF ped-venda.cod-sit-ped = 6 THEN 
                      ASSIGN c-sit-ped = "CANCELADO".
                          ELSE
                              ASSIGN c-sit-ped = "".

    IF ped-item.cod-sit-item = 1 THEN 
       ASSIGN c-sit-item = "ABERTO".
    ELSE
       IF ped-item.cod-sit-item = 2 THEN
          ASSIGN c-sit-item = "AT.PARCIAL".
       ELSE
           IF ped-item.cod-sit-item = 6 THEN
              ASSIGN c-sit-item = "CANCELADO".
                   ELSE
                       ASSIGN c-sit-item = "".

    PUT (ped-item.qt-pedida - ped-item.qt-atendida) ";"
        (ped-item.vl-preuni * d-cotacao) * (ped-item.qt-pedida - ped-item.qt-atendida) FORMAT "->>>,>>>,>>9.99" ";".

    ASSIGN d-valor-total-aloc = (ped-item.vl-preuni * d-cotacao) * ped-item.qt-log-aloc.

    ASSIGN de-perc-comissao = 0.
    /** Busca comiss∆o pela BO **/
    RUN getComissao IN {&hDBOTable} (INPUT ped-venda.cod-estabel,
                                     INPUT repres.cod-rep,
                                     INPUT emitente.cod-emitente,
                                     INPUT item.fm-cod-com,
                                     INPUT ped-item.dt-entrega,
                                     OUTPUT de-perc-comissao) NO-ERROR.

    PUT de-perc-comissao ";"
        de-perc-acordo ";".
    find cotacao no-lock
       where cotacao.mo-codigo   = ped-venda.mo-codigo
         and cotacao.ano-periodo = string(year(today), "9999") + string(month(today), "99") no-error.
    if available (cotacao) and (cotacao.cotacao[day(today)] <> 0) then
       assign d-cotacao = cotacao.cotacao[day(today)].
    else
       assign d-cotacao = 1.
        
    ASSIGN d-valor-st         = 0
           d-valor-ipi-aloc   = 0
           d-valor-st-aloc    = 0.
    IF tt-param.l-selecao-acesso-restrito THEN DO:

        if (ped-venda.cod-priori = 10 AND
            (ped-item.qt-alocada + ped-item.qt-log-aloca) > 0) then
            assign de-alocado = ped-item.vl-preuni * (ped-item.qt-alocada + ped-item.qt-log-aloca - ped-item.qt-atendida).
         else
            assign de-alocado = 0.

         if (ped-item.dt-entrega = dt-final + 1) THEN 
             PUT "0" .
         else do:
            if (ped-venda.cod-priori = 10 AND
                (ped-item.qt-alocada + ped-item.qt-log-aloca) > 0) THEN 
                PUT "0".
            else
               PUT (ped-item.vl-merc-abe - de-alocado) * d-cotacao.
         end.
    END.
    ELSE DO:
        FIND FIRST b-natur NO-LOCK
             WHERE b-natur.nat-oper = ped-item.nat-oper NO-ERROR.
        IF natur-oper.subs-trib THEN DO:
            assign d-valor-st       = ped-item.vl-tot-it - ped-item.vl-liq-it - ROUND(((ped-item.qt-pedida - ped-item.qt-atendida) * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100),2). /*- de-frete-item*/ 

            IF ped-item.qt-log-aloca > 0 THEN DO:
                ASSIGN d-valor-st-aloc =  ROUND(((ped-item.vl-tot-it - ped-item.vl-liq-it -
                       (ped-item.qt-pedida * ped-item.vl-preuni) * (ped-item.aliquota-ipi / 100)) / ped-item.qt-pedida) * ped-item.qt-log-aloc,2).
            END.
        END.
        ELSE
           ASSIGN d-valor-st = 0.

        PUT ped-item.vl-liq-abe - d-valor-st FORMAT "->>>,>>>,>>9.99".
    END.

    assign p-ipi-tributacao = if  natur-oper.cd-trib-ipi = 1
                                then if  item.cd-trib-ipi = 1
                                     or  item.cd-trib-ipi = 4
                                     then 1
                                     else item.cd-trib-ipi
                                else if  natur-oper.cd-trib-ipi = 2
                                     or  natur-oper.cd-trib-ipi = 3
                                     then natur-oper.cd-trib-ipi
                                     else item.cd-trib-ipi.
    IF p-ipi-tributacao = 1 THEN
        assign d-valor-ipi-aloc = ROUND((ped-item.qt-log-aloc * ped-item.vl-preuni ) * (ped-item.aliquota-ipi / 100),2).
    ELSE
        assign d-valor-ipi-aloc = 0.

    
    PUT UNFORMATTED ";" C-SIT-PED ";"
        c-sit-item ";".

    CASE ped-venda.cod-sit-aval:
        WHEN 1 THEN
            ASSIGN c-sit-cred = "N∆o Avaliado".
        WHEN 2 THEN
            ASSIGN c-sit-cred = "Avaliado"    .
        WHEN 3 THEN
            ASSIGN c-sit-cred = "Aprovado"    .
        WHEN 4 THEN
            ASSIGN c-sit-cred = "N∆o Aprovado".
        WHEN 5 THEN
            ASSIGN c-sit-cred = "Pendente Informaá∆o".
    END.

    ASSIGN c-ped-venda-desc-bloq-cr = fn-retira-espec(ped-venda.desc-bloq-cr).

    PUT UNFORMATTED c-sit-cred ";"
        c-ped-venda-desc-bloq-cr FORMAT "x(80)" ";".

    ASSIGN c-obs = fn-retira-espec(c-obs)
           c-cond-espec = fn-retira-espec(c-cond-espec).

    PUT UNFORMATTED c-obs FORMAT "x(170)" ";"
        c-cond-espec FORMAT "x(100)" ";".

    IF AVAIL int-ped-venda THEN
       PUT int-ped-venda.vl-frete ";".

    FIND LAST preco-item NO-LOCK
             WHERE preco-item.it-codigo = ITEM.it-codigo
             AND   preco-item.cod-refer = ""
             AND   preco-item.nr-tabpre = "minimo" NO-ERROR.
    IF AVAIL preco-item THEN
        PUT preco-item.preco-venda ";".
    ELSE
        PUT "0;".

    FIND FIRST fam-com-item NO-LOCK
         WHERE fam-com-item.unidade  = SUBSTRING(fam-comerc.fm-cod-com,1,2)
           AND fam-com-item.segmento = SUBSTRING(fam-comerc.fm-cod-com,3,2)
           AND fam-com-item.familia1 = "" NO-ERROR.
    IF AVAIL fam-com-item THEN 
        PUT UNFORMATTED fam-com-item.descricao ";".
    ELSE
         PUT  UNFORMATTED ";".

    PUT  UNFORMATTED ped-item.qt-log-aloca ";".

    IF  AVAIL int-ped-venda THEN
        PUT UNFORMATTED SUBSTRING(int-ped-venda.char-1,53,12) ";".
    ELSE 
        PUT UNFORMATTED ";".

    PUT UNFORMATTED ped-venda.nome-transp ";".

    if (ped-venda.cod-priori = 10 AND
        (ped-item.qt-alocada + ped-item.qt-log-aloca) > 0) then
        assign de-alocado = ped-item.vl-preuni * (ped-item.qt-alocada + ped-item.qt-log-aloca - ped-item.qt-atendida).
    else
        assign de-alocado = 0.

    if (ped-item.dt-entrega = dt-final + 1) THEN 
        ASSIGN de-considera-acesso = 0
               c-considera-acesso-restrito = "Nao - Entrega dia 01 prox Mes".
    else do:
       if (ped-venda.cod-priori = 10 AND
           (ped-item.qt-alocada + ped-item.qt-log-aloca) > 0) THEN 
           ASSIGN de-considera-acesso = 0
                  c-considera-acesso-restrito = "Nao - Prioridade 10".
       else
          ASSIGN de-considera-acesso = (ped-item.vl-merc-abe - de-alocado) * d-cotacao.
                 
    end.
 
    /*--------------------------- PREVIS«O PRODUÄ«O -------------------------*/
    IF  tt-param.tg-importa THEN DO:
        RUN pi-gera-previsao (INPUT   ped-venda.cod-estabel,
                              INPUT   ped-item.it-codigo,
                              INPUT  (ped-item.qt-pedida - ped-item.qt-atendida - ped-item.qt-alocada),
                              OUTPUT  de-qtd-possivel,
                              OUTPUT  c-data-previsao,
                              OUTPUT  c-parcial,
                              OUTPUT  de-saldo-item).

        IF  c-data-previsao = "?" THEN
            ASSIGN c-data-previsao = "".

        PUT UNFORMATTED ped-item.nr-sequencia       ";"
                        de-considera-acesso         ";"
                        c-considera-acesso-restrito ";"
                        STRING(ped-venda.dt-entrega,"99/99/9999") ";".

        FIND FIRST grupo-canais-clientes NO-LOCK 
             WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-ERROR.

        ASSIGN i-cd-canal = IF AVAIL grupo-canais-clientes THEN grupo-canais-clientes.cod-gr-canais ELSE 0.

        FIND FIRST int-ped-venda2 NO-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

        IF AVAIL int-ped-venda2 THEN
            ASSIGN i-cd-canal = int-ped-venda2.int-1.
        
        PUT UNFORMATTED i-cd-canal           ";"
                        ped-venda.dt-entorig ";"
                        c-data-previsao      ";" 
                        c-parcial            ";"
                        de-saldo-item        ";".
         
        /*
        IF  tt-param.l-cancelados THEN 
            PUT UNFORMATTED replace(replace(replace(ped-venda.desc-cancela, CHR(13), " "), ";", "."), CHR(10), " ") ";"
                            STRING(ped-venda.dt-cancela) ";".
        IF  tt-param.l-itens-cancelados THEN
            PUT UNFORMATTED replace(replace(replace(ped-item.desc-cancela, CHR(13), " "), ";", "."), CHR(10), " ") ";"
                            STRING(ped-item.dt-canseq) ";".*/

    END.
    ELSE DO:
        FIND FIRST grupo-canais-clientes NO-LOCK 
             WHERE grupo-canais-clientes.cod-gr-cli = emitente.cod-gr-cli NO-ERROR.

        ASSIGN i-cd-canal = IF AVAIL grupo-canais-clientes THEN grupo-canais-clientes.cod-gr-canais ELSE 0.

        PUT UNFORMATTED ped-item.nr-sequencia       ";"
                        de-considera-acesso         ";"
                        c-considera-acesso-restrito ";"
                        STRING(ped-venda.dt-entrega,"99/99/9999") ";".
                        
        FIND FIRST int-ped-venda2 NO-LOCK
             WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
               AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

        IF AVAIL int-ped-venda2 THEN
            ASSIGN i-cd-canal = int-ped-venda2.int-1.
        
        PUT UNFORMATTED i-cd-canal ";"
                        ped-venda.dt-entorig ";".
         
        /*
        IF  tt-param.l-cancelados THEN 
           PUT UNFORMATTED replace(replace(replace(ped-venda.desc-cancela, CHR(13), " "), ";", "."), CHR(10), " ") ";"
                           STRING(ped-venda.dt-cancela) ";".
       IF  tt-param.l-itens-cancelados THEN
           PUT UNFORMATTED replace(replace(replace(ped-item.desc-cancela, CHR(13), " "), ";", "."), CHR(10), " ") ";"
                           STRING(ped-item.dt-canseq) ";".*/
    END.
    PUT UNFORMATTED trim(replace(REPLACE(REPLACE(ped-venda.cond-redespa,CHR(13)," "),CHR(10)," "),';','')) ";".

    IF AVAIL ped-repre THEN
        PUT UNFORMATTED ped-repre.nome-ab-rep ";".
    ELSE 
        PUT UNFORMATTED "" ";".

    PUT UNFORMATTED d-valor-st ";".

    PUT UNFORMATTED ped-venda.nome-tr-red ";".

    //C2102-0811 - Ajustar colunas de Pedidos Cancelados

    IF tt-param.l-cancelados THEN 
       PUT UNFORMATTED replace(replace(replace(ped-venda.desc-cancela, CHR(13), " "), ";", "."), CHR(10), " ") ";"
                        STRING(ped-venda.dt-cancela) ";".

    IF tt-param.l-itens-cancelados THEN
       PUT UNFORMATTED replace(replace(replace(ped-item.desc-cancela, CHR(13), " "), ";", "."), CHR(10), " ") ";"
                        STRING(ped-item.dt-canseq) ";".

    ASSIGN de-perc-desc-mais-verde = 0
           de-val-desc-mais-verde  = 0
           de-perc-desc-top-milhao = 0
           de-val-desc-top-milhao  = 0
           de-perc-desc-rebate-ant = 0
           de-val-desc-rebate-ant  = 0
           de-economia-mais-verde  = 0
           de-economia-top-milhao  = 0
           de-economia-rebate-ant  = 0.

    FIND FIRST int-ped-item-rebate
         WHERE int-ped-item-rebate.nome-abrev   = ped-item.nome-abrev
           AND int-ped-item-rebate.nr-pedcli    = ped-item.nr-pedcli  
           AND int-ped-item-rebate.nr-sequencia = ped-item.nr-sequencia
           AND int-ped-item-rebate.it-codigo    = ped-item.it-codigo  
           AND int-ped-item-rebate.cod-refer    = ped-item.cod-refer NO-LOCK NO-ERROR.
    IF AVAIL int-ped-item-rebate THEN
        ASSIGN de-perc-desc-mais-verde = ROUND(int-ped-item-rebate.perc-descto-verde * 100,2)
               de-val-desc-mais-verde  = ROUND(ped-item.vl-tot-it *  (1 + int-ped-item-rebate.perc-descto-verde) - ped-item.vl-tot-it,2)
               de-perc-desc-top-milhao = ROUND(int-ped-item-rebate.perc-descto-top-milhao * 100,2)
               de-val-desc-top-milhao  = ROUND(ped-item.vl-tot-it *  (1 + int-ped-item-rebate.perc-descto-top-milhao) - ped-item.vl-tot-it,2)
               de-perc-desc-rebate-ant = ROUND(int-ped-item-rebate.perc-rebate-antec * 100,2)
               de-val-desc-rebate-ant  = ROUND(ped-item.vl-tot-it *  (1 + int-ped-item-rebate.perc-rebate-antec) - ped-item.vl-tot-it,2)
               de-economia-mais-verde  = ROUND((ped-item.vl-preori / (1 - int-ped-item-rebate.perc-rebate-antec) / (1 - int-ped-item-rebate.perc-descto-top-milhao) / (1 - int-ped-item-rebate.perc-descto-verde)) - (ped-item.vl-preori / (1 - int-ped-item-rebate.perc-rebate-antec) / (1 - int-ped-item-rebate.perc-descto-top-milhao)),2) * ped-item.qt-un-fat
               de-economia-top-milhao  = ROUND((ped-item.vl-preori / (1 - int-ped-item-rebate.perc-rebate-antec) / (1 - int-ped-item-rebate.perc-descto-top-milhao)) - (ped-item.vl-preori / (1 - int-ped-item-rebate.perc-rebate-antec)),2) * ped-item.qt-un-fat
               de-economia-rebate-ant  = ROUND((ped-item.vl-preori / (1 - int-ped-item-rebate.perc-rebate-antec)) - (ped-item.vl-preori),2) * ped-item.qt-un-fat.

    PUT UNFORMATTED de-perc-desc-mais-verde ";" 
                    de-val-desc-mais-verde  ";"
                    de-economia-mais-verde  ";"
                    de-perc-desc-top-milhao ";" 
                    de-val-desc-top-milhao  ";"
                    de-economia-top-milhao  ";"
                    de-perc-desc-rebate-ant ";" 
                    de-val-desc-rebate-ant  ";" 
                    de-economia-rebate-ant  ";".

    PUT UNFORMATTED d-valor-total-aloc FORMAT "->>>,>>>,>>9.99" ";"
                    d-valor-ipi-aloc   FORMAT "->>>,>>>,>>9.99" ";"
                    d-valor-st-aloc    FORMAT "->>>,>>>,>>9.99" ";".
    /*-----------------------------------------------------------------------*/

    /*marcio*/
    IF AVAIL int-ped-venda THEN
        PUT UNFORMATTED substring(int-ped-venda.char-1,68,8) ";".
    ELSE
        PUT UNFORMATTED "" ";".

    PUT UNFORMATTED ped-item.vl-preori FORMAT "->>>,>>>,>>9.99" ";".
    PUT UNFORMATTED ped-item.des-pct-desconto-inform  ";".

    IF AVAIL int-ped-venda THEN
    DO:
        PUT UNFORMATTED int-ped-venda.dt-negociacao FORMAT "99/99/9999" ";".

        IF SUBSTRING(int-ped-venda.char-1, 11, 1) = "S" THEN
           PUT UNFORMATTED "Sim" ";".
        ELSE
           PUT UNFORMATTED "Nao" ";".
    END.
    ELSE
        PUT UNFORMATTED ";;".

    PUT UNFORMATTED ped-venda.des-pct-desconto-inform ";".

    IF AVAIL cond-pagto THEN
        PUT string(cond-pagto.cod-cond-pag) ";".
    ELSE
        PUT ";".

    //PUT ped-venda.cod-des-mer ";".
        IF INT(ped-venda.cod-des-mer) = 1 THEN
            PUT UNFORMATTED "Comercio/Industria" ";".
        ELSE
            PUT UNFORMATTED "Consumo Proprio/Ativo" ";".
        
    PUT STRING(emitente.contrib-icms,"Sim/Nao") ";".
    PUT UNFORMATTED int-ped-venda.dias-negociacao ";".

    IF ped-venda.ind-fat-par = YES THEN
        PUT UNFORMATTED "Sim" ";".
    ELSE
        PUT UNFORMATTED "Nao" ";".

    IF AVAIL mgesp.int-ped-item-pci THEN
        PUT UNFORMATTED mgesp.int-ped-item-pci.nr-tabpre ";".
    ELSE
        PUT ";".

    PUT UNFORMATTED IF ped-item.ind-icm-ret = YES THEN "SIM" ELSE "NAO" ";".

        IF AVAIL mgesp.int-ped-item-pci THEN
        PUT UNFORMATTED mgesp.int-ped-item-pci.desc-neg-comercial ";".
    ELSE
        PUT ";".
    
    PUT SKIP.
    
END PROCEDURE.

DEF TEMP-TABLE tt-saldo
    FIELD cod-estabel AS CHAR
    FIELD it-codigo   AS CHAR
    FIELD quantidade  AS DEC
    FIELD da-ult-prev AS DATE INIT ?
    FIELD parcial     AS CHAR 
    INDEX idx-primary 
            cod-estabel 
            it-codigo.

PROCEDURE pi-gera-previsao:

    DEF INPUT  PARAM p-cod-estabel     AS CHAR NO-UNDO.
    DEF INPUT  PARAM p-it-codigo       AS CHAR NO-UNDO.
    DEF INPUT  PARAM p-qt-a-atender    AS DEC  NO-UNDO.
    DEF OUTPUT PARAM p-qtd-possivel    AS DEC  NO-UNDO.
    DEF OUTPUT PARAM p-c-previsao      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-parcial         AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-conta-corrente  AS DEC  NO-UNDO.

    DEF VAR de-qt-atual AS DEC NO-UNDO.
    DEF VAR de-saldo    AS DEC NO-UNDO.
    DEF VAR da-base-procura AS DATE NO-UNDO.


    IF  p-qt-a-atender = 0 THEN 
        RETURN "OK".

    FIND FIRST tt-saldo
         WHERE tt-saldo.cod-estabel = p-cod-estabel
           AND tt-saldo.it-codigo   = p-it-codigo NO-ERROR.

    IF  NOT AVAIL tt-saldo THEN DO:
        /* CARREGA O SALDO INICIA DA TT-SALDO DE ACORDO COM O SALDO DE ESTOQUE DOS DEP‡SITOS INFORMADOS NA TELA */
        FOR EACH tt-digita:
            ASSIGN de-saldo = de-saldo + fnEstoque (p-cod-estabel, 
                                                    p-it-codigo, 
                                                    tt-digita.cod-depos, 
                                                    "", 
                                                    NO /*S¢ central pronta*/ ).
        END.
        CREATE tt-saldo.
        ASSIGN tt-saldo.cod-estabel = p-cod-estabel
               tt-saldo.it-codigo   = p-it-codigo
               tt-saldo.quantidade  = de-saldo
               p-conta-corrente    = tt-saldo.quantidade.
    END.
    ELSE 
        ASSIGN de-saldo         = tt-saldo.quantidade
               p-conta-corrente = tt-saldo.quantidade.

    /* VERIFICAR SE A QUANTIDADE DO ESTOQUE ATENDE O QUE FALTA A ATENDER DESTE ITEM DO PEDIDO */
    IF  de-saldo >= p-qt-a-atender THEN DO:
        ASSIGN tt-saldo.quantidade  = tt-saldo.quantidade - p-qt-a-atender
               p-conta-corrente     = tt-saldo.quantidade.

        /* Data de previs∆o neste caso Ç D + 2*/
        IF  tt-saldo.da-ult-prev = ? THEN DO:
            ASSIGN p-c-previsao = STRING((TODAY + 2), "99/99/9999").
            RETURN "OK".
        END.            
        
        ASSIGN p-c-previsao = string(tt-saldo.da-ult-prev, "99/99/9999").

        RETURN "OK".
    END.

    /* SALDO ESTOQUE N«O SUFICIENTE, PESQUISAR PREVIS«O DE PRODUÄ«O*/
    IF  de-saldo < p-qt-a-atender THEN DO: 
        IF  tt-saldo.da-ult-prev = ? THEN
            ASSIGN tt-saldo.da-ult-prev = TODAY.

        /* PROCURA ATê ENCONTRAR SALDO NA PREVIS«O DE PRODUÄ«O, A PARTIR DA ÈLTIMA DATA GRAVADA */
        ASSIGN da-base-procura = (IF  tt-saldo.da-ult-prev = ? THEN (TODAY - 1)  ELSE tt-saldo.da-ult-prev).

        FOR EACH tt-previsao
            WHERE tt-previsao.it-codigo  = p-it-codigo
              AND tt-previsao.data       > da-base-procura
                BY tt-previsao.data:

                ASSIGN de-saldo = de-saldo + tt-previsao.quantidade.
    
                ASSIGN p-c-previsao         = STRING(tt-previsao.data, "99/99/9999") 
                       tt-saldo.da-ult-prev = tt-previsao.data /*para que na pr¢xima procura, n∆o encontre ela mesmo*/.
                IF  de-saldo >= p-qt-a-atender THEN DO:
                    ASSIGN  tt-saldo.quantidade = de-saldo - p-qt-a-atender
                            p-conta-corrente    = tt-saldo.quantidade
                            p-qtd-possivel      = de-saldo.    
                    RETURN "OK".
                END.
        END.
        
        /*CASO N«O ENCONTRE NENHUM SALDO*/
        IF  de-saldo = 0 THEN DO:
            ASSIGN p-parcial      = ""
                   p-c-previsao   = ""
                   p-qtd-possivel = 0     .
            RETURN "OK".
        END.

        IF  de-saldo < p-qt-a-atender THEN DO:
            ASSIGN p-parcial            = "PARCIAL"
                   tt-saldo.quantidade  = 0
                   p-conta-corrente     = 0
                   p-qtd-possivel       = de-saldo.
            IF  tt-saldo.da-ult-prev = ? OR tt-saldo.da-ult-prev = TODAY THEN
                   ASSIGN tt-saldo.da-ult-prev = TODAY
                          p-c-previsao         = STRING((TODAY + 2), "99/99/9999"). 
        END.

    END.

    RETURN "OK".
END.


PROCEDURE pi-importa-previsao-producao:

    IF  NOT tt-param.tg-importa THEN
        RETURN "OK".

    DEF VAR c-Linha     AS CHAR FORMAT "X(100)".
    DEF VAR i           AS INTEGER INIT 1 NO-UNDO.
    
    INPUT FROM value(tt-param.fi-arquivo-imp).
    
    REPEAT:
        IMPORT UNFORMATTED c-Linha.

        RUN pi-acompanhar IN h-acomp ("Linha: " + STRING(i)).

        CREATE tt-previsao.
        ASSIGN tt-previsao.it-codigo  = entry(01, c-Linha, ";")
               tt-previsao.data       = DATE(entry(02, c-Linha, ";"))
               tt-previsao.quantidade = DEC(entry(03, c-Linha, ";")).

        ASSIGN i = i + 1.
    
        IF  c-Linha = "" THEN
            LEAVE.

    END.

END.

