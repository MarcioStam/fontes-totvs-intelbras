/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: esp/cep/escep055rp.p
**  Objetivo.: Listagem de parametros dos itens para planejamento de materiais.
**  Cria‡Æo..: 05/05/2010 - Gustavo Eduardo Tamanini - SQL WORKS.
**
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP055RP 2.00.00.002}

{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0018.i}

DEF QUERY qr-item-estab-fornec
    FOR item-uni-estab, item-fornec-estab.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                  AS INTEGER
    FIELD arquivo                  AS CHAR
    FIELD arquivo-csv              AS CHAR
    FIELD usuario                  AS CHAR FORMAT "x(12)"
    FIELD data-exec                AS DATE
    FIELD hora-exec                AS INTEGER    
    FIELD estab-ini                LIKE item-uni-estab.cod-estabel
    FIELD estab-fim                LIKE item-uni-estab.cod-estabel 
    FIELD comprador-ini            LIKE item-uni-estab.cod-comprado
    FIELD comprador-fim            LIKE item-uni-estab.cod-comprado
    FIELD item-ini                 LIKE item-uni-estab.it-codigo
    FIELD item-fim                 LIKE item-uni-estab.it-codigo
    FIELD emitente-ini             LIKE emitente.cod-emitente
    FIELD emitente-fim             LIKE emitente.cod-emitente
    FIELD periodo-ini              AS DATE
    FIELD periodo-fim              AS DATE
    FIELD cd-plano                 AS INTEGER
    FIELD l-consumo                AS LOGICAL
    FIELD l-saldo                  AS LOGICAL
    FIELD l-depos-saldo-diponivel  AS LOGICAL
    FIELD l-depos-disponivel-oem   AS LOGICAL
    FIELD l-param-item             AS LOGICAL
    FIELD l-entrega-cons           AS LOGICAL
    FIELD l-saldo-excesso          AS LOGICAL
    FIELD l-validade-item          AS LOGICAL
    FIELD log-ativo                AS LOGICAL 
    FIELD log-obsol-ord-auto       AS LOGICAL 
    FIELD log-obsol-todas-ord      AS LOGICAL 
    FIELD log-total-obsol          AS LOGICAL 
    FIELD log-dependente           AS LOGICAL 
    FIELD log-independente         AS LOGICAL
    FIELD log-forecast             AS LOGICAL
    FIELD log-planejadas           AS LOGICAL
    FIELD log-param-fornec         AS LOGICAL.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.
 
DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita       AS RAW.    
    
DEFINE TEMP-TABLE tt-periodo
    FIELD mes         AS INT  FORMAT "99"
    FIELD ano         AS INT  FORMAT "9999"
    FIELD anomes      AS CHAR FORMAT "x(6)"
    FIELD de-pl       LIKE it-periodo.qt-res-plan
    FIELD de-oc       AS DEC  FORMAT ">>>,>>>,>>9.99"
    FIELD de-oc-plan  AS DEC  FORMAT ">>>,>>>,>>9.99"
    INDEX id AS PRIMARY UNIQUE mes ano.

DEFINE TEMP-TABLE tt-ae
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD mes     AS INT                          
    FIELD ano     AS INT                          
    FIELD tot-qtd AS DECIMAL FORMAT ">>>>,>>>,>>9"
    FIELD periodo AS CHAR                         
    INDEX id IS PRIMARY UNIQUE     
          it-codigo
          mes  
          ano.

DEFINE BUFFER b-usuar-mater FOR usuar-mater.
DEFINE BUFFER b01-item-uni-estab FOR item-uni-estab.


{esp/imp/esimp000.i1} /*tt-emb*/

DEF TEMP-TABLE tt_unid_negoc NO-UNDO
    FIELD cod_unid_negoc AS CHARACTER FORMAT "x(3)"  LABEL "Unid Neg¢cio" COLUMN-LABEL "Un Neg"
    FIELD des_unid_negoc AS CHARACTER FORMAT "x(40)" LABEL "Descri‡Æo"    COLUMN-LABEL "Descri‡Æo"
    FIELD cdn_unid_negoc AS INTEGER   FORMAT ">>9"   INITIAL 0 LABEL "Nœmero Unidade Negoc" COLUMN-LABEL "Numero UN"
    INDEX ch-codigo IS PRIMARY UNIQUE
        cod_unid_negoc.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEF VAR h-acomp           AS HANDLE                         NO-UNDO.
DEF VAR c-cod-fornec      AS CHAR FORMAT "x(09)"            NO-UNDO.
DEF VAR c-fornec          AS CHAR FORMAT "x(16)"            NO-UNDO.
DEF VAR i-perc-fornec     LIKE item-fornec-estab.perc-compra NO-UNDO.
DEF VAR i-res-for         LIKE item-uni-estab.res-for-comp  NO-UNDO.
DEF VAR i-res-item-estab  LIKE item-uni-estab.res-for-comp  NO-UNDO.
DEF VAR c-nome-comprador  LIKE usuar-mater.nome-usuar       NO-UNDO.
DEF VAR de-lote-mult-for  LIKE item-uni-estab.lote-multipl  NO-UNDO.
DEF VAR de-lote-min-for   LIKE item-uni-estab.lote-minimo   NO-UNDO.
DEF VAR c-abc             AS CHAR                           NO-UNDO.
DEF VAR de-preco          LIKE item-estab.val-unit-mat-m[1] NO-UNDO.
DEF VAR de-pr-item        LIKE item-tab.pr-item             NO-UNDO.
DEF VAR de-aliquota-ipi   LIKE item-tab.aliquota-ipi        NO-UNDO.
DEF VAR de-preco-ul-ent   LIKE item.preco-ul-ent            NO-UNDO.
DEF VAR c-moeda-pr-item   AS CHAR                           NO-UNDO.
DEF VAR dt-ult-entrada    AS DATE      FORMAT "99/99/9999"  NO-UNDO.
DEF VAR i-num-calc-plano  AS INTE                           NO-UNDO.
DEF VAR dt-aux            AS DATE      FORMAT "99/99/9999"  NO-UNDO.
DEF VAR c-mes             AS CHARACTER FORMAT "99"          NO-UNDO.
DEF VAR c-ano             AS CHARACTER FORMAT "9999"        NO-UNDO.
DEF VAR c-cab             AS CHARACTER FORMAT "x(14)"       NO-UNDO.
DEF VAR c-cab2            AS CHARACTER FORMAT "x(15)"       NO-UNDO.
DEF VAR c-cod-obsoleto    AS CHAR FORMAT "x(30)"            NO-UNDO.
DEF VAR c-motivo-situacao AS CHAR FORMAT "x(30)"            NO-UNDO.
DEF VAR c-pais-for        AS CHAR FORMAT "x(20)"            NO-UNDO.
DEF VAR c-origem          AS CHAR FORMAT "x(20)"            NO-UNDO.
DEF VAR c-compr-fabr      AS CHAR FORMAT "x(10)"            NO-UNDO.
DEF VAR v-des-fabric      AS CHAR FORMAT "x(40)"            NO-UNDO.
DEF VAR i-origem-aux      AS INTEGER                        NO-UNDO.
DEF VAR de-saldo          LIKE saldo-estoq.qtidade-atu      NO-UNDO.
DEF VAR de-saldo-terc     LIKE saldo-estoq.qtidade-atu      NO-UNDO.
DEF VAR de-pl             LIKE it-periodo.qt-res-plan       NO-UNDO.
DEF VAR v-cod-pn-fabric   LIKE item-fabric.it-fabric        NO-UNDO. 
DEF VAR c-fm-cod          AS CHARACTER                      NO-UNDO.
DEF VAR c-fm-des          AS CHARACTER                      NO-UNDO.
def var i-saldo-rec       as i initial 0                    NO-UNDO.
def var i-saldo-alm       as i initial 0                    NO-UNDO.
def var i-saldo-pro       as i initial 0                    NO-UNDO.
def var i-saldo-ast       as i initial 0                    NO-UNDO.
DEF VAR i-cont-sal-terc   AS i initial 0                    NO-UNDO.

DEFINE VARIABLE c-ds-fm-com    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cd-fm-com    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-politica     AS CHARACTER FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE c-demanda      AS CHARACTER FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE c-planejado    AS CHARACTER FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE c-tp-est-seg   AS CHARACTER FORMAT "x(10)" INITIAL "Quantidade;Tempo" NO-UNDO.
DEFINE VARIABLE c-reab-estoq   AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-classe-repro AS CHARACTER FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE c-emissao-ord  AS CHARACTER FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE c-div-ordem    AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE l-demanda-item AS LOGICAL FORMAT "Sim/NÆo" NO-UNDO.
DEFINE VARIABLE c-itiner       AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE c-pto-contr    AS CHARACTER FORMAT "x(40)" NO-UNDO.
define variable c-observacao   as character format "x(100)" no-undo.
DEFINE VARIABLE c-incoterm     LIKE emitente-cex.cod-incoterm-imp NO-UNDO.
DEFINE VARIABLE c-idioma       LIKE emitente-cex.cod-idioma       NO-UNDO.
DEFINE VARIABLE d-sd-qs        AS DECIMAL FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE d-sd-qp        AS DECIMAL FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE d-excesso      AS DECIMAL FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE d-lt-min       AS DECIMAL NO-UNDO.
DEFINE VARIABLE d-tot-de-pl    LIKE it-periodo.qt-res-plan NO-UNDO.
DEFINE VARIABLE d-cons-med     AS DECIMAL NO-UNDO.
DEFINE VARIABLE d-cons-med-r   AS DECIMAL NO-UNDO.
DEFINE VARIABLE c-cond-pagto   AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE i-horiz-fixo   AS INTEGER NO-UNDO.
DEFINE VARIABLE l-nec-inspec   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-antidumping  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-month        AS INTEGER NO-UNDO.
DEFINE VARIABLE i-year         AS INTEGER NO-UNDO.

DEFINE VARIABLE l-sit-dif-estab AS LOGICAL NO-UNDO.
DEFINE VARIABLE i-situacao      AS INTEGER NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST empresa WHERE 
           empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "":U
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-programa     = "ESCEP055":U
       /*c-versao       = "2.04":U
       c-revisao      = "000":U*/ .

EMPTY TEMP-TABLE tt-prog-ponto.

DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.

IF OPSYS = "UNIX":U THEN DO:

    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-arquivo = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-arquivo, LENGTH(c-arquivo), 1) <> "/":U THEN
        ASSIGN c-arquivo = c-arquivo + "/":U.

    ASSIGN tt-param.arquivo     = c-programa + ".lst":U
           tt-param.arquivo-csv = c-arquivo + c-seg-usuario + "/":U + STRING(tt-param.cd-plano) + "_" + tt-param.estab-ini + "_" + c-programa + ".csv":U.

END.

RUN esp/es0018p.p (INPUT "ESCEP055":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FORM SKIP(1)
     "SELE€ÇO":U AT 13 SKIP(1)
     tt-param.estab-ini     FORMAT "x(03)":U      LABEL "Estabelecimento":U COLON 40 
     " |< >| ":U AT 59
     tt-param.estab-fim     FORMAT "x(03)":U      NO-LABEL SKIP
     tt-param.comprador-ini FORMAT "x(12)":U      LABEL "Comprador":U COLON 40
     " |< >| ":U AT 59
     tt-param.comprador-fim FORMAT "x(12)":U      NO-LABEL SKIP
     tt-param.item-ini      FORMAT "x(16)":U      LABEL "Item":U COLON 40
     " |< >| ":U AT 59
     tt-param.item-fim      FORMAT "x(16)":U      NO-LABEL SKIP
     tt-param.periodo-ini   FORMAT "99/99/9999":U LABEL "Per¡odo Consumo":U COLON 40
     " |< >| ":U AT 59
     tt-param.periodo-fim   FORMAT "99/99/9999":U NO-LABEL SKIP
     tt-param.emitente-ini  FORMAT ">>>,>>>,>>>":U LABEL "Fornecedor":U COLON 40
     " |< >| ":U AT 59
     tt-param.emitente-fim  FORMAT ">>>,>>>,>>>":U NO-LABEL SKIP
     tt-param.cd-plano      FORMAT ">>9":U        LABEL "Plano":U COLON 40
     SKIP(1)
     "PAR¶METRO":U AT 13 SKIP(1)
     tt-param.log-ativo               FORMAT "Sim/NÆo" LABEL "Ativos":U                            COLON 40 SKIP
     tt-param.log-obsol-ord-auto      FORMAT "Sim/NÆo" LABEL "Obsoleto Ordens Autom ticas":U       COLON 40 SKIP
     tt-param.log-obsol-todas-ord     FORMAT "Sim/NÆo" LABEL "Obsoleto Todas as Ordens":U          COLON 40 SKIP
     tt-param.log-total-obsol         FORMAT "Sim/NÆo" LABEL "Totalmente Obsoletos":U              COLON 40 SKIP
     tt-param.log-dependente          FORMAT "Sim/NÆo" LABEL "Demanda Dependente":U                COLON 40 SKIP
     tt-param.log-independente        FORMAT "Sim/NÆo" LABEL "Demanda Independente":U              COLON 40 SKIP
     tt-param.l-saldo                 FORMAT "Sim/NÆo" LABEL "Apenas Itens com Saldo":U            COLON 40 SKIP     
     tt-param.l-consumo               FORMAT "Sim/NÆo" LABEL "Apenas Itens com Consumo":U          COLON 40 SKIP     
     tt-param.l-depos-saldo-diponivel FORMAT "Sim/NÆo" LABEL "Somente Dep¢sito Saldo Dispon¡vel":U COLON 40 SKIP     
     tt-param.l-entrega-cons          FORMAT "Sim/NÆo" LABEL "Listar Entregas e Consumos":U        COLON 40 SKIP               
     tt-param.l-saldo-excesso         FORMAT "Sim/NÆo" LABEL "Listar Saldos e Excessos":U          COLON 40 SKIP 
     tt-param.log-forecast            FORMAT "Sim/NÆo" LABEL "Forecast":U                          COLON 40 SKIP
     SKIP(1)
     "IMPRESSÇO":U AT 13 SKIP(1)
     tt-param.arquivo       FORMAT "x(80)":U      LABEL "Destino":U           COLON 40 SKIP
     tt-param.usuario       FORMAT "x(12)":U      LABEL "Usu rio":U           COLON 40 SKIP
     tt-param.arquivo-csv   FORMAT "x(80)":U      LABEL "Arquivo CSV":U       COLON 40 SKIP(1)
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Gerando dados..":U).

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

DISP tt-param.estab-ini
     tt-param.estab-fim
     tt-param.comprador-ini
     tt-param.comprador-fim
     tt-param.item-ini     
     tt-param.item-fim
     tt-param.periodo-ini
     tt-param.periodo-fim
     tt-param.emitente-ini
     tt-param.emitente-fim
     tt-param.cd-plano
     tt-param.log-ativo          
     tt-param.log-obsol-ord-auto 
     tt-param.log-obsol-todas-ord
     tt-param.log-total-obsol    
     tt-param.log-dependente
     tt-param.log-independente
     tt-param.l-saldo
     tt-param.l-consumo
     tt-param.l-depos-saldo-diponivel
     tt-param.l-entrega-cons 
     tt-param.l-saldo-excesso
     tt-param.log-forecast
     tt-param.arquivo
     tt-param.usuario
     tt-param.arquivo-csv 
    WITH FRAME f-impressao.

{include/i-rpclo.i}

RUN pi-gera-periodo.
RUN pi-gera-csv.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar in h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK":U.
    
PROCEDURE pi-gera-csv:

    DO ON STOP UNDO, LEAVE:
        FIND FIRST pl-prod WHERE pl-prod.cd-plano = tt-param.cd-plano NO-LOCK NO-ERROR.
        ASSIGN i-num-calc-plano = IF AVAIL pl-prod THEN pl-prod.num-calc-plano ELSE 0.                                                                                    

        OUTPUT TO VALUE(tt-param.arquivo-csv) CONVERT TARGET SESSION:CHARSET.

        IF  tt-param.log-forecast = NO
        THEN DO:

            FIND FIRST b-usuar-mater NO-LOCK
                WHERE b-usuar-mater.cod-usuario = c-seg-usuario NO-ERROR.

            PUT  "Estab;Item;Descricao;Unid Negocio;Cod Fam Mat;Des Fam Mat;Cod Fam Com;Des Fam Com;Situacao;Motivo Situa‡Æo;Necessita LI;Nec Insp Origem;Antidumping;Observacao Log;".

            IF (AVAIL b-usuar-mater
            AND b-usuar-mater.usuar-comprador)
            OR CAN-FIND (FIRST tt-prog-ponto              
                         WHERE tt-prog-ponto.conteudo = c-seg-usuario)     
            THEN DO:
               IF tt-param.l-depos-disponivel-oem THEN
                  PUT  "Comprador;Preco Medio(R$);Preco Item;Moeda;Al­quota IPI;Preco Ult Ent(R$);Data Ult. Ent.;Consumo Medio;Saldo;Saldo Terc;ABC;Obtencao;Grupo Est;Descricao Grupo Estoque;".
               ELSE
                  PUT  "Comprador;Preco Medio(R$);Preco Item;Moeda;Al­quota IPI;Preco Ult Ent(R$);Data Ult. Ent.;Consumo Medio;ALM;REC;PRO;AST;Saldo Terc;ABC;Obtencao;Grupo Est;Descricao Grupo Estoque;".
            END.
            ELSE DO:
               IF tt-param.l-depos-disponivel-oem THEN
                  PUT  "Comprador;Data Ult. Ent.;Consumo Medio;Saldo;Saldo Terc;ABC;Obtencao;Grupo Est;Descricao Grupo Estoque;".
               ELSE
                  PUT  "Comprador;Data Ult. Ent.;Consumo Medio;ALM;REC;PRO;AST;Saldo Terc;ABC;Obtencao;Grupo Est;Descricao Grupo Estoque;".
            END.

            PUT  "Planejador;Politica;Demanda;Lote Multiplo;Lote Minimo;Un Item;Lote Economico;Periodo Fixo;Qtde Politica;Quantidade Segur;".
            PUT  "Tipo Estq Seguranca;Tempo Seguranca;Converte Tempo Seg;Reabastecimento;Classe Reprogramacao;".
            PUT  "Emissao Ordens;Divisao Ordens;Prioridade MRP;Repressa Demanda;Prioridade;".
            PUT  "Ressupr Compras;Ressupr CQ;Ressupr Fornec;Horizonte Liber;Horizonte Fixo;Deposito Padr;Tp Despesa;Cod Origem Estab;Desc Origem Estab;".
            PUT  "Cod Fornec;Fornecedor;% Compra Fornec;Pais;Itinerario Padrao;Ponto Controle Base;Incoterm;Idioma Padrao;Condicao Pagamento;Moeda;".
            PUT  "Tempo Ressupr;Horizonte Fixo;Lote Multiplo;Lote Minimo;Un Fornec;Fabricante;PN Fabricante;".

            IF tt-param.l-saldo-excesso 
            THEN DO:
                FOR EACH tt-periodo 
                    BY tt-periodo.ano
                    BY tt-periodo.mes:
                    ASSIGN c-cab = STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2).

                    PUT  "Saldo " c-cab ";" "Excesso " c-cab ";" "%QS " c-cab ";" "%QP " c-cab ";".
                END.
            END.
        END. /* IF  tt-param.log-forecast = NO */
        ELSE DO:
            IF tt-param.l-depos-disponivel-oem THEN
               PUT  "Estab;Item;Descricao;Saldo;Lote Multiplo;Lote Minimo;Qtde Politica;Quantidade Segur;Cod Fornec;Fornecedor;".
            ELSE
               PUT  "Estab;Item;Descricao;ALM;REC;PRO;AST;Lote Multiplo;Lote Minimo;Qtde Politica;Quantidade Segur;Cod Fornec;Fornecedor;".
        END.

        IF tt-param.l-entrega-cons 
        THEN DO:
            FOR EACH tt-periodo 
                BY tt-periodo.ano
                BY tt-periodo.mes:
                ASSIGN c-cab2 = "Entregas " + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U.
                PUT c-cab2.
            END.

            FOR EACH tt-periodo 
                BY tt-periodo.ano
                BY tt-periodo.mes:
                ASSIGN c-cab = "Consumo " + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U.
                PUT c-cab.
            END.
        END.

        IF  tt-param.log-forecast = NO
        THEN DO:
            IF  tt-param.l-entrega-cons  OR 
                tt-param.l-saldo-excesso THEN
                PUT "Cons.Med;Cons.Med(R$);Saldo/QS(%);Saldo/QP(%);Excesso(R$);Lot.Min/QP(%);".
    
            IF tt-param.l-validade-item THEN DO:
                PUT "Validade Familia;".
    
                FOR EACH  tt-periodo
                    WHERE tt-periodo.anomes >= STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99")
                       BY tt-periodo.anomes:
    
                    ASSIGN c-cab = "AE " + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U.
    
                    PUT c-cab.
                END.
            END.
        END. /* IF  tt-param.log-forecast = NO */


        IF tt-param.log-planejadas 
        THEN DO:
            FOR EACH tt-periodo 
                BY tt-periodo.ano
                BY tt-periodo.mes:
                ASSIGN c-cab = "OC Planejadas " + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U.
                PUT UNFORMATTED c-cab.
            END.
        END.

        PUT "Fat Conv;Dec;".

        /* In¡cio APS */
        put unformatted "Permite Compra Spot;"       
                        "Permite Modal Aereo;"      
                        "Item Phase-in;"        
                        "Item Phase-out;"        
                        "Tempo Transf. Estab;"     
                        "Modelo;"         
                        "Lote Minimo Compras;"
                        "Lote Minimo Fabricacao;"
                        "Lote Maximo Compras;"
                        "Lote Maximo Fabricacao;"
                        "Qtd Dias Minimo;" 
                        "Qtd Dias Alvo;"
                        "Qtd Dias Cob. MP Kit CKD/SKD;"
                        "Qtd Dias Alvo MP Kit CKD/SKD;"
                        "Qtd Dias Antec;"
                        "Item Restritivo;"
                        "Bloqueado Producao;"
                        "Requer Avaliacao;".
        /* Fim APS */

        PUT "" SKIP.

        IF NOT tt-param.log-param-fornec THEN DO:

            FOR EACH item-uni-estab
               WHERE item-uni-estab.cod-estabel  >= tt-param.estab-ini
                 AND item-uni-estab.cod-estabel  <= tt-param.estab-fim 
                 AND item-uni-estab.it-codigo    >= tt-param.item-ini
                 AND item-uni-estab.it-codigo    <= tt-param.item-fim 
                 AND item-uni-estab.cod-comprado >= tt-param.comprador-ini 
                 AND item-uni-estab.cod-comprado <= tt-param.comprador-fim NO-LOCK:
    
                IF tt-param.emitente-ini > 0 THEN DO:
    
                    FIND FIRST item-fornec-estab NO-LOCK
                         WHERE item-fornec-estab.it-codigo     = item-uni-estab.it-codigo
                           AND item-fornec-estab.cod-estabel   = item-uni-estab.cod-estabel
                           AND item-fornec-estab.ativo         = YES
                           AND item-fornec-estab.cod-emitente >= tt-param.emitente-ini
                           AND item-fornec-estab.cod-emitente <= tt-param.emitente-fim NO-ERROR.
        
                    IF NOT AVAIL item-fornec-estab THEN
                        NEXT.
                END.
    
                FIND FIRST item-fornec-estab NO-LOCK
                     WHERE item-fornec-estab.it-codigo   = item-uni-estab.it-codigo
                       AND item-fornec-estab.cod-estabel = item-uni-estab.cod-estabel
                       AND item-fornec-estab.ativo       = YES
                       AND item-fornec-estab.perc-compra > 0 NO-ERROR.
    
                IF NOT AVAIL item-fornec-estab THEN 
                    FIND FIRST item-fornec-estab NO-LOCK
                         WHERE item-fornec-estab.it-codigo   = item-uni-estab.it-codigo
                           AND item-fornec-estab.cod-estabel = item-uni-estab.cod-estabel
                           AND item-fornec-estab.ativo       = YES NO-ERROR.
    
                RUN pi-relat.            
            END.
        END.
        ELSE DO:
            OPEN QUERY qr-item-estab-fornec
            FOR EACH item-uni-estab
               WHERE item-uni-estab.cod-estabel  >= tt-param.estab-ini
                 AND item-uni-estab.cod-estabel  <= tt-param.estab-fim 
                 AND item-uni-estab.it-codigo    >= tt-param.item-ini
                 AND item-uni-estab.it-codigo    <= tt-param.item-fim 
                 AND item-uni-estab.cod-comprado >= tt-param.comprador-ini 
                 AND item-uni-estab.cod-comprado <= tt-param.comprador-fim,
                EACH item-fornec-estab OUTER-JOIN
               WHERE item-fornec-estab.it-codigo     = item-uni-estab.it-codigo
                 AND item-fornec-estab.cod-estabel   = item-uni-estab.cod-estabel
                 AND item-fornec-estab.ativo         = YES
                 AND item-fornec-estab.perc-compra   > 0 
                 AND item-fornec-estab.cod-emitente >= tt-param.emitente-ini
                 AND item-fornec-estab.cod-emitente <= tt-param.emitente-fim NO-LOCK.
                
            blk_repeat:
            REPEAT:
                GET NEXT qr-item-estab-fornec.
                IF NOT AVAIL item-uni-estab THEN
                    LEAVE blk_repeat.
    
                RUN pi-relat.            
            END.
        END.
        OUTPUT CLOSE.
    END. /* DO ON STOP UNDO, LEAVE: */
END PROCEDURE.

PROCEDURE pi-relat:
    
    FIND FIRST int-item-uni-estab NO-LOCK
         WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
           AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-ERROR.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Item: " + STRING(item-uni-estab.it-codigo)).

    FIND FIRST ITEM NO-LOCK 
         WHERE ITEM.it-codigo = item-uni-estab.it-codigo NO-ERROR.

    IF NOT AVAIL item THEN 
        NEXT.

    IF item.tipo-contr <> 2 THEN 
        NEXT.

    IF  item-uni-estab.cod-obsoleto = 1 
    AND tt-param.log-ativo          = NO THEN 
        NEXT.

    IF  item-uni-estab.cod-obsoleto = 2 AND
        tt-param.log-obsol-ord-auto = NO
    THEN 
        NEXT.

    IF  item-uni-estab.cod-obsoleto  = 3 AND
        tt-param.log-obsol-todas-ord = NO
    THEN 
        NEXT.

    IF  item-uni-estab.cod-obsoleto = 4 AND
        tt-param.log-total-obsol    = NO
    THEN 
        NEXT.

    IF item-uni-estab.demanda  = 1 AND
       tt-param.log-dependente = NO
    THEN 
        NEXT.

    IF item-uni-estab.demanda    = 2 AND
       tt-param.log-independente = NO
    THEN 
        NEXT.

    ASSIGN de-saldo      = 0
           de-saldo-terc = 0
           i-saldo-rec   = 0
           i-saldo-alm   = 0
           i-saldo-pro   = 0
           i-saldo-ast   = 0.

    FOR EACH saldo-terc NO-LOCK
       WHERE saldo-terc.cod-estabel = item-uni-estab.cod-estabel
         AND saldo-terc.it-codigo   = item-uni-estab.it-codigo
         AND saldo-terc.quantidade > 0:

        IF  tt-param.l-depos-disponivel-oem THEN DO:

            IF  saldo-terc.cod-depos <> "ACA" 
            AND saldo-terc.cod-depos <> "EXP" 
            AND saldo-terc.cod-depos <> "WEX" THEN DO:
                FIND FIRST deposito NO-LOCK
                     WHERE deposito.cod-depos = saldo-terc.cod-depos NO-ERROR.
    
                IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN NEXT.
            END.
        END.

         FIND FIRST deposito NO-LOCK
              WHERE deposito.cod-depos = saldo-terc.cod-depos NO-ERROR.
    
         IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN NEXT.
         
         ASSIGN de-saldo-terc = de-saldo-terc + saldo-terc.quantidade.
    END.

    /* Busca os mesmos dep¢sitos que o programa ESCEP025RP e retorna na temp tt-prog-ponto*/
    RUN esp/es0018p.p (INPUT "escep025rp":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    /* Busca Saldos */
    find first tt-prog-ponto no-error.
    if avail tt-prog-ponto then DO:
        FOR EACH tt-prog-ponto:
            FOR EACH saldo-estoq
                WHERE saldo-estoq.cod-estabel = item-uni-estab.cod-estabel 
                  AND saldo-estoq.cod-depos   = tt-prog-ponto.conteudo
                  and saldo-estoq.it-codigo   = item-uni-estab.it-codigo NO-LOCK:
                 ASSIGN i-saldo-pro = i-saldo-pro + saldo-estoq.qtidade-atu.
            END.
        END.
    END.

    FOR EACH saldo-estoq
        WHERE saldo-estoq.cod-estabel = item-uni-estab.cod-estabel
          and saldo-estoq.cod-depos   = "rec"          
          AND saldo-estoq.it-codigo   = item-uni-estab.it-codigo NO-LOCK:
         ASSIGN i-saldo-rec = i-saldo-rec + saldo-estoq.qtidade-atu.
    END.

    FOR EACH saldo-estoq                              
       WHERE saldo-estoq.cod-estabel = item-uni-estab.cod-estabel         
         and saldo-estoq.cod-depos   = "alm"
         AND saldo-estoq.it-codigo   = item-uni-estab.it-codigo NO-LOCK:
        ASSIGN i-saldo-alm = i-saldo-alm + saldo-estoq.qtidade-atu.
    END.       

    FOR EACH saldo-estoq                              
       WHERE saldo-estoq.cod-estabel = item-uni-estab.cod-estabel         
         and saldo-estoq.cod-depos   = "wal"
         AND saldo-estoq.it-codigo   = item-uni-estab.it-codigo NO-LOCK:
        ASSIGN i-saldo-alm = i-saldo-alm + saldo-estoq.qtidade-atu.
    END.       

    FOR EACH saldo-estoq
       WHERE saldo-estoq.cod-estabel = item-uni-estab.cod-estabel           
         and saldo-estoq.cod-depos   = "ast"
         AND saldo-estoq.it-codigo   = item-uni-estab.it-codigo NO-LOCK:
        ASSIGN i-saldo-ast = i-saldo-ast + saldo-estoq.qtidade-atu.
    END.
    /* Fim Busca Saldos */

    FOR EACH saldo-estoq
       WHERE saldo-estoq.cod-estabel = item-uni-estab.cod-estabel
         AND saldo-estoq.it-codigo   = item-uni-estab.it-codigo NO-LOCK:

        IF tt-param.l-depos-saldo-diponivel THEN DO:
            FIND FIRST deposito
                WHERE deposito.cod-depos = saldo-estoq.cod-depos NO-LOCK NO-ERROR.

            IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN NEXT.
            /*chamado: 47875*/
            IF AVAILABLE deposito AND deposito.cod-depos = 'OBS' THEN NEXT. 
        END.

        IF  tt-param.l-depos-disponivel-oem THEN DO:

            IF  saldo-estoq.cod-depos <> "ACA" 
            AND saldo-estoq.cod-depos <> "EXP" 
            AND saldo-estoq.cod-depos <> "WEX" THEN DO:
                FIND FIRST deposito NO-LOCK
                     WHERE deposito.cod-depos = saldo-estoq.cod-depos NO-ERROR.
    
                IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN NEXT.
            END.
        END.

        ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu.
    END.

    IF NOT(tt-param.l-saldo) OR (tt-param.l-saldo AND de-saldo > 0) 
    THEN DO:
        FIND FIRST usuar-mater NO-LOCK
             WHERE usuar-mater.cod-usuario = item-uni-estab.cod-comprado NO-ERROR.
        ASSIGN c-nome-comprador = IF AVAIL usuar-mater THEN usuar-mater.nome-usuar ELSE "".

        /*Busca pre?o e data da ultima entrada*/
        ASSIGN de-preco-ul-ent = 0
               dt-ult-entrada  = ?.
        FOR EACH recebimento NO-LOCK USE-INDEX ITEM
           WHERE recebimento.it-codigo = ITEM.it-codigo,
           FIRST ordem-compra NO-LOCK
           WHERE ordem-compra.numero-ordem = recebimento.numero-ordem
             AND ordem-compra.cod-estabel  = item-uni-estab.cod-estabel
            BREAK BY recebimento.data-movto DESC:
                run cdp/cd0812.p (INPUT 0, 
                                  INPUT 0,
                                  INPUT recebimento.preco-unit,
                                   INPUT recebimento.data-nota,
                                  OUTPUT de-preco-ul-ent).
    
                ASSIGN dt-ult-entrada = recebimento.data-movto.
             LEAVE.
        END.

        /*ASSIGN de-preco-ul-ent = item.preco-ul-ent
                 dt-ult-entrada  = ITEM.data-ult-ent.*/

        ASSIGN de-pl = 0.

        FOR EACH tt-periodo:
            ASSIGN tt-periodo.de-pl      = 0
                   tt-periodo.de-oc      = 0
                   tt-periodo.de-oc-plan = 0.
        END.

        FOR EACH prazo-compra NO-LOCK
           WHERE prazo-compra.data-entrega >= tt-param.periodo-ini 
             AND prazo-compra.data-entrega <= tt-param.periodo-fim 
             AND prazo-compra.situacao = 2 
             AND prazo-compra.it-codigo = item-uni-estab.it-codigo 
             AND prazo-compra.quant-saldo <> 0,
           FIRST ordem-compra NO-LOCK 
           WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem 
             AND ordem-compra.cod-estabel  = item-uni-estab.cod-estabel      
             AND ordem-compra.num-pedido <> 0:
             
            /*chamado: 47875*/ 
            IF tt-param.l-depos-saldo-diponivel THEN DO:
                
                FIND FIRST deposito
                    WHERE deposito.cod-depos = ordem-compra.dep-almoxar NO-LOCK NO-ERROR.
                    
                IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN NEXT.
            END. 

            /*chamado: 47875*/ 
            IF  tt-param.l-depos-disponivel-oem THEN DO:

                /*
                IF ITEM.ge-codigo = 45 
                    AND deposito.cod-depos <> "ACA" 
                    AND deposito.cod-depos <> "EXP"
                    AND deposito.cod-depos <> "OEM" THEN NEXT.
                 */

                IF  ordem-compra.dep-almoxar <> "ACA" 
                AND ordem-compra.dep-almoxar <> "EXP" 
                AND ordem-compra.dep-almoxar <> "WEX" THEN DO:
                    FIND FIRST deposito NO-LOCK
                         WHERE deposito.cod-depos = ordem-compra.dep-almoxar NO-ERROR.
        
                    IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN NEXT.
                END.
            END.

            FOR EACH ordens-embarque NO-LOCK 
               WHERE ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
                 AND ordens-embarque.parcela       = prazo-compra.parcela 
                 AND ordens-embarque.cod-estabel   = ordem-compra.cod-estabel:
                RUN busca-posicao. 
            end.

            FIND FIRST tt-emb NO-ERROR.
/*                     IF AVAIL tt-emb AND tt-emb.situacao = 4 THEN NEXT. */

            FIND FIRST tt-periodo WHERE
                       tt-periodo.mes = MONTH(prazo-compra.data-entrega) AND
                       tt-periodo.ano = YEAR(prazo-compra.data-entrega)  NO-LOCK NO-ERROR.

            IF AVAIL tt-periodo THEN
                ASSIGN tt-periodo.de-oc = tt-periodo.de-oc + prazo-compra.quant-saldo.
        END. /* FOR EACH prazo-compra */
        
        FOR EACH reservas NO-LOCK USE-INDEX planejamento
           WHERE reservas.it-codigo   = ITEM.it-codigo
             AND reservas.estado      = 1
             AND reservas.dt-reserva >= tt-param.periodo-ini
             AND reservas.dt-reserva <= tt-param.periodo-fim,
           FIRST ord-prod NO-LOCK
           WHERE ord-prod.nr-ord-produ = reservas.nr-ord-produ
             AND ord-prod.cod-estabel  = item-uni-estab.cod-estabel: /*tem que verificar estabelecimento se nÆo fizer isso e pegar v rios estabelecimento irÿ duplicar reservas*/ 

            FIND FIRST tt-periodo WHERE
                       tt-periodo.mes = MONTH(reservas.dt-reserva) AND
                       tt-periodo.ano = YEAR(reservas.dt-reserva)  NO-LOCK NO-ERROR.

            IF AVAIL tt-periodo THEN
                ASSIGN tt-periodo.de-pl = tt-periodo.de-pl + reservas.quant-orig - reservas.quant-atend
                       de-pl            = de-pl + tt-periodo.de-pl.
        END.


        IF AVAIL pl-prod AND pl-prod.log-multi-estabel = NO THEN DO:
           FOR EACH it-periodo NO-LOCK 
              WHERE it-periodo.num-calc-plano = i-num-calc-plano 
/*                 AND it-periodo.cod-estabel    = item-uni-estab.cod-estabel */
                AND it-periodo.it-codigo      = item-uni-estab.it-codigo
                AND it-periodo.data          >= tt-param.periodo-ini
                AND it-periodo.data          <= tt-param.periodo-fim:
           
               FIND FIRST tt-periodo WHERE
                          tt-periodo.mes = MONTH(it-periodo.data) AND
                          tt-periodo.ano = YEAR(it-periodo.data)  NO-LOCK NO-ERROR.
           
               IF AVAIL tt-periodo 
               THEN DO:
                   ASSIGN tt-periodo.de-pl = tt-periodo.de-pl + it-periodo.qt-res-plan
                          de-pl            = de-pl + tt-periodo.de-pl.
           
                   IF  tt-param.log-planejadas
                   THEN
                       ASSIGN tt-periodo.de-oc-plan = tt-periodo.de-oc-plan + it-periodo.qt-ord-plan.
               END.
           END.
        END.
        ELSE DO:
           FOR EACH it-periodo NO-LOCK 
              WHERE it-periodo.num-calc-plano = i-num-calc-plano 
                AND it-periodo.cod-estabel    = item-uni-estab.cod-estabel
                AND it-periodo.it-codigo      = item-uni-estab.it-codigo
                AND it-periodo.data          >= tt-param.periodo-ini
                AND it-periodo.data          <= tt-param.periodo-fim:
           
               FIND FIRST tt-periodo WHERE
                          tt-periodo.mes = MONTH(it-periodo.data) AND
                          tt-periodo.ano = YEAR(it-periodo.data)  NO-LOCK NO-ERROR.
           
               IF AVAIL tt-periodo 
               THEN DO:
                   ASSIGN tt-periodo.de-pl = tt-periodo.de-pl + it-periodo.qt-res-plan
                          de-pl            = de-pl + tt-periodo.de-pl.
           
                   IF  tt-param.log-planejadas
                   THEN
                       ASSIGN tt-periodo.de-oc-plan = tt-periodo.de-oc-plan + it-periodo.qt-ord-plan.
               END.
           END.
        END.
        

        IF tt-param.l-consumo AND de-pl <= 0 THEN NEXT.

        ASSIGN de-preco = 0.

        FIND item-estab WHERE
             item-estab.cod-estabel = item-uni-estab.cod-estabel AND
             item-estab.it-codigo   = item-uni-estab.it-codigo   NO-LOCK NO-ERROR.
        IF AVAIL item-estab THEN
            ASSIGN de-preco = item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1].

        CASE item-uni-estab.classif-abc:
            WHEN 1 THEN
                ASSIGN c-abc = "A".
            WHEN 2 THEN
                ASSIGN c-abc = "B".
            WHEN 3 THEN
                ASSIGN c-abc = "C".
            OTHERWISE ASSIGN c-abc = "".
        END CASE.

        ASSIGN i-res-item-estab = item-uni-estab.res-for-comp
               c-cod-fornec     = ""
               c-fornec         = ""
               i-perc-fornec    = 0
               c-pais-for       = ""
               i-res-for        = 0
               de-lote-mult-for = 0
               de-lote-min-for  = 0
               c-itiner         = ""
               c-pto-contr      = ""
               c-incoterm       = ""
               c-idioma         = ""
               c-cond-pagto     = ""
               c-moeda-pr-item  = ""
               de-pr-item       = 0
               de-aliquota-ipi  = 0
               i-horiz-fixo     = 0
               l-nec-inspec     = FALSE.

        IF AVAIL item-fornec-estab 
        THEN DO:
            FIND FIRST emitente WHERE emitente.cod-emitente = item-fornec-estab.cod-emitente NO-LOCK NO-ERROR.
            ASSIGN c-cod-fornec     = TRIM(STRING(emitente.cod-emitente, ">>>>>>>>9"))
                   c-fornec         = emitente.nome-abrev
                   i-perc-fornec    = item-fornec-estab.perc-compra
                   c-pais-for       = emitente.pais
                   i-res-for        = item-fornec-estab.tempo-ressup
                   de-lote-mult-for = item-fornec-estab.lote-mul-for
                   de-lote-min-for  = item-fornec-estab.lote-minimo
                   i-horiz-fixo     = item-fornec-estab.horiz-fixo.

            FIND FIRST cond-pagto
                 WHERE cond-pagto.cod-cond-pag = item-fornec-estab.cod-cond-pag NO-LOCK NO-ERROR.
            IF AVAIL cond-pagto THEN DO:
                ASSIGN c-cond-pagto = STRING(cond-pagto.cod-cond-pag) + " - ":U + cond-pagto.descricao.

                FOR EACH tb-pr-cc NO-LOCK USE-INDEX ch-codigo
                    WHERE tb-pr-cc.cod-emitente = emitente.cod-emitente
                      AND tb-pr-cc.cod-cond-pag = cond-pagto.cod-cond-pag
                      AND tb-pr-cc.situacao     = 1
                      AND tb-pr-cc.dt-inicio   <= TODAY
                      AND tb-pr-cc.dt-termino  >= TODAY,
                    FIRST item-tab NO-LOCK USE-INDEX tab-item
                    WHERE item-tab.cod-emitente = tb-pr-cc.cod-emitente
                      AND item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
                      AND item-tab.nr-tab       = tb-pr-cc.nr-tab
                      AND item-tab.dt-inicio    = tb-pr-cc.dt-inicio
                      AND item-tab.it-codigo    = item-fornec-estab.it-codigo:
                    ASSIGN de-pr-item      = item-tab.pr-item
                           de-aliquota-ipi = item-tab.aliquota-ipi.

                    FIND moeda NO-LOCK
                        WHERE moeda.mo-codigo = tb-pr-cc.mo-codigo NO-ERROR.

                    IF  AVAIL moeda
                    THEN
                        ASSIGN c-moeda-pr-item = moeda.descricao.
                    LEAVE.
                END.
            END.

            FIND FIRST emitente-cex 
                 WHERE emitente-cex.cod-emitente = item-fornec-estab.cod-emitente NO-LOCK NO-ERROR.
            IF AVAIL emitente-cex THEN DO:                    
                ASSIGN c-itiner    = STRING(emitente-cex.cod-itiner-imp)
                       c-pto-contr = STRING(emitente-cex.cod-pto-contr)
                       c-incoterm  = emitente-cex.cod-incoterm-imp
                       c-idioma    = emitente-cex.cod-idioma.

                FIND FIRST itinerario WHERE
                           itinerario.cod-itiner = emitente-cex.cod-itiner-imp NO-LOCK NO-ERROR.
                IF AVAIL itinerario THEN
                    ASSIGN c-itiner = STRING(emitente-cex.cod-itiner-imp) + " - " + itinerario.descricao.

                FIND FIRST pto-contr NO-LOCK
                     WHERE pto-contr.cod-pto-contr = emitente-cex.cod-pto-contr NO-ERROR.

                IF AVAIL pto-contr THEN
                    ASSIGN c-pto-contr = STRING(pto-contr.cod-pto-contr) + " - " + pto-contr.descricao. 
            END.

            FOR FIRST int-item-fornec-estab NO-LOCK
                WHERE int-item-fornec-estab.it-codigo    = item-fornec-estab.it-codigo
                  AND int-item-fornec-estab.cod-emitente = item-fornec-estab.cod-emitente
                  AND int-item-fornec-estab.cod-estabel  = item-fornec-estab.cod-estabel:

                ASSIGN l-nec-inspec = int-item-fornec-estab.log-nec-inspec.
            END.
        END. 

        EMPTY TEMP-TABLE tt-ae.

        FOR EACH  familia NO-LOCK
            WHERE familia.fm-codigo = ITEM.fm-codigo,
             EACH int-familia OF familia
            WHERE int-familia.meses-validade > 0,
             EACH ae-item NO-LOCK
            WHERE ae-item.cod-estabel   = item-uni-estab.cod-estabel
             AND  ae-item.it-codigo     = ITEM.it-codigo
             AND  ae-item.situacao      = NO
             AND  (ae-item.cod-depos     = "alm" OR
                   ae-item.cod-depos     = "wal")
             AND (ae-item.data-validade = ? OR 
                  ae-item.data-validade < tt-param.periodo-fim)
          BREAK BY ae-item.it-codigo
                BY ae-item.nr-ae
                BY ae-item.sequencia:

            IF  ae-item.data-validade = ?     OR
                ae-item.data-validade < TODAY THEN
                ASSIGN i-month = MONTH(TODAY)
                       i-year  = YEAR(TODAY).
            ELSE
                ASSIGN i-month = MONTH(ae-item.data-validade)
                       i-year  = YEAR(ae-item.data-validade).

            FIND FIRST tt-ae
                 WHERE tt-ae.it-codigo = ITEM.it-codigo
                   AND tt-ae.mes       = i-month
                   AND tt-ae.ano       = i-year NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ae THEN DO:
                CREATE tt-ae.
                ASSIGN tt-ae.it-codigo = ITEM.it-codigo
                       tt-ae.mes       = i-month
                       tt-ae.ano       = i-year 
                       tt-ae.tot-qtd   = ae-item.quantidade
                       tt-ae.periodo   = STRING(i-year,"9999") + STRING(i-month,"99").
            END.
            ELSE
                ASSIGN tt-ae.tot-qtd = tt-ae.tot-qtd + ae-item.quantidade.  
        END.

        FIND FIRST planejad
             WHERE planejad.cd-planejado = item-uni-estab.cd-planejado NO-LOCK NO-ERROR.

        /* Necessÿrio este tratamento pois o cadastro estÿ com a diferen?a de uma posi‡Æoo para as informa‡äes da include */
        ASSIGN i-origem-aux = IF AVAIL int-item-uni-estab THEN int-item-uni-estab.codigo-orig + 1 ELSE 1.

        ASSIGN c-cod-obsoleto = IF item-uni-estab.cod-obsoleto <> 0 THEN {ininc/i17in172.i 04 item-uni-estab.cod-obsoleto} ELSE ""
               c-politica     = IF item-uni-estab.politica <> 0 THEN {ininc/i04in122.i 04 item-uni-estab.politica} ELSE ""
               c-demanda      = IF item-uni-estab.demanda = 1 THEN "Dependente" ELSE "Independente"
               c-planejado    = item-uni-estab.cd-planejado + " - " + IF AVAIL planejad THEN planejad.nome ELSE ""
               c-reab-estoq   = IF SUBSTR(item-uni-estab.char-1,10,1) = "" OR SUBSTR(item-uni-estab.char-1,10,1) = "0"
                                THEN {ininc/i26in172.i 04 1}
                                ELSE {ininc/i26in172.i 04 INT(SUBSTR(item-uni-estab.char-1,10,1))}
               c-classe-repro = IF item-uni-estab.classe-repro <> 0 THEN {ininc/i06in122.i 04 item-uni-estab.classe-repro} ELSE ""
               c-emissao-ord  = IF item-uni-estab.emissao-ord  <> 0 THEN {ininc/i03in122.i 04 item-uni-estab.emissao-ord}  ELSE ""
               c-div-ordem    = IF item-uni-estab.div-ordem    <> 0 THEN {ininc/i12in122.i 04 item-uni-estab.div-ordem}    ELSE ""
               c-origem       = {ininc/i18in122.i 04 i-origem-aux} 
               c-compr-fabr   = IF ITEM.compr-fabric = 1 THEN "Comprado" ELSE "Fabricado" NO-ERROR.

        IF SUBSTRING(item-uni-estab.char-1,132,1) = "1" THEN
            ASSIGN l-demanda-item = YES.
        ELSE 
            ASSIGN l-demanda-item = NO.

        ASSIGN i-situacao     = 0
               l-sit-dif-estab = NO.

        FOR EACH b01-item-uni-estab NO-LOCK 
            WHERE b01-item-uni-estab.it-codigo = item-uni-estab.it-codigo :
            IF i-situacao = 0 THEN
               ASSIGN i-situacao = b01-item-uni-estab.cod-obsoleto.
            ELSE DO:
               IF i-situacao <> b01-item-uni-estab.cod-obsoleto THEN
                  ASSIGN l-sit-dif-estab = YES.
            END.                                  
        END.


        FIND FIRST int-item-uni-estab NO-LOCK
             WHERE int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo  
               AND int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel NO-ERROR.

        ASSIGN c-motivo-situacao = "".
        
        IF NOT l-sit-dif-estab THEN DO:
           FIND FIRST int-item NO-LOCK
                WHERE int-item.it-codigo = item-uni-estab.it-codigo NO-ERROR.

           IF AVAIL int-item THEN DO:
              CASE int-item.motivo-situacao:
                 WHEN 1 THEN
                    ASSIGN c-motivo-situacao = "Altera‡Æo de estrutura".
                 WHEN 2 THEN
                    ASSIGN c-motivo-situacao = "Phase out produto".
                 WHEN 3 THEN
                    ASSIGN c-motivo-situacao = "Item EOL".
                 WHEN 4 THEN
                    ASSIGN c-motivo-situacao = "Bloqueado compra".
              END CASE.
           END.
        END.
        ELSE DO:
            IF AVAIL int-item-uni-estab THEN DO:
                CASE int-item-uni-estab.int-1:
                    WHEN 1 THEN
                       ASSIGN c-motivo-situacao = "Altera‡Æo de estrutura".
                    WHEN 2 THEN
                       ASSIGN c-motivo-situacao = "Phase out produto".
                    WHEN 3 THEN
                       ASSIGN c-motivo-situacao = "Item EOL".
                    WHEN 4 THEN
                       ASSIGN c-motivo-situacao = "Bloqueado para compra".
                END CASE.
            END.
        END.
        

        IF  tt-param.log-forecast = NO THEN DO:

            find first int-item-uni-estab no-lock
                 where int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel 
                   and int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo no-error.
            IF AVAIL int-item-uni-estab THEN
                assign c-observacao = int-item-uni-estab.observacao.
            else
                assign c-observacao = "".

            if avail int-item THEN DO:
                assign l-antidumping = int-item.log-antidumping.
            END.
            else
                assign l-antidumping = no.

            FIND FIRST familia NO-LOCK 
                 WHERE familia.fm-codigo = ITEM.fm-codigo NO-ERROR.

            FIND FIRST fam-comerc NO-LOCK
                 WHERE fam-comerc.fm-cod-com = ITEM.fm-cod-com NO-ERROR.

            ASSIGN c-ds-fm-com = IF AVAIL fam-comerc THEN fam-comerc.descricao  ELSE ""
                   c-cd-fm-com = IF AVAIL fam-comerc THEN fam-comerc.fm-cod-com ELSE ""
                   c-fm-des    = IF AVAIL familia    THEN familia.descricao     ELSE ""
                   c-fm-cod    = IF AVAIL familia    THEN familia.fm-codigo     ELSE "".

            PUT  item-uni-estab.cod-estabel             ";"
                 item-uni-estab.it-codigo               ";"
                 item.desc-item                         ";"
                 item-uni-estab.cod-unid-negoc          ";" /*Unidade Neg¢cio*/
                 c-fm-cod                               ";"
                 c-fm-des FORMAT "x(60)"                ";"
                 c-cd-fm-com                            ";"
                 c-ds-fm-com FORMAT "x(60)"             ";"
                 c-cod-obsoleto                         ";" /*Situacao       */                                  
                 c-motivo-situacao                      ";" /*Motivo Situacao*/
                 ITEM.log-necessita-li FORMAT "X/"      ";"
                 l-nec-inspec FORMAT "X/"               ";"
                 l-antidumping FORMAT "X/"              ";"
                 c-observacao                           ";".

            PUT  c-nome-comprador                       ";". /*Comprador       */

            RUN esp/es0018p.p (INPUT "ESCEP055":U,
                               INPUT 1,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).

            IF (AVAIL b-usuar-mater
                  AND b-usuar-mater.usuar-comprador)
                   OR CAN-FIND (FIRST tt-prog-ponto              
                                WHERE tt-prog-ponto.conteudo = c-seg-usuario)     THEN DO:

                 PUT de-preco                               ";" /*Preco Medio     */
                     de-pr-item                             ";" /*Pre?o Item      */
                     c-moeda-pr-item                        ";" /*Moeda           */
                     de-aliquota-ipi                        ";" /*Al­quota IPI    */
                     de-preco-ul-ent                        ";". /*Pre‡o élt. Ent. */
            END.

            IF tt-param.l-depos-disponivel-oem THEN
               PUT dt-ult-entrada                         ";" /*Data élt. Ent.  */
                   item-uni-estab.consumo-prev            ";" /*Consumo Medio   */
                   de-saldo                               ";" /*Saldo           */ 
                 /*  i-saldo-alm                            ";"
                   i-saldo-rec                            ";"
                   i-saldo-pro                            ";"
                   i-saldo-ast                            ";" */
                   de-saldo-terc                          ";"
                   c-abc                                  ";"
                   c-compr-fabr                           ";"
                   ITEM.ge-codigo                         ";".
            ELSE
               PUT dt-ult-entrada                         ";" /*Data élt. Ent.  */
                   item-uni-estab.consumo-prev            ";" /*Consumo Medio   */
                 /*  de-saldo                               ";" /*Saldo           */ */
                   i-saldo-alm                            ";"
                   i-saldo-rec                            ";"
                   i-saldo-pro                            ";"
                   i-saldo-ast                            ";"
                   de-saldo-terc                          ";"
                   c-abc                                  ";"
                   c-compr-fabr                           ";"
                   ITEM.ge-codigo                         ";".

            FIND grup-estoque NO-LOCK
                WHERE grup-estoque.ge-codigo = ITEM.ge-codigo NO-ERROR.

            IF  AVAIL grup-estoque
            THEN
                PUT grup-estoque.descricao ";".
            ELSE
                PUT ";".

            /* Busca Part Number do item fornecedor */
            ASSIGN v-des-fabric    = "Sem Rela‡Æo"
                   v-cod-pn-fabric = "".
            
            IF  AVAIL item-fornec-estab
            THEN DO:
                FIND FIRST item-fabric NO-LOCK
                     WHERE item-fabric.it-codigo  = item-fornec-estab.it-codigo
                       AND item-fabric.cod-fabric = INT(item-fornec-estab.item-do-for) 
                       AND item-fabric.estado     = YES /* Ativo */ NO-ERROR.
          
                IF  AVAIL item-fabric
                THEN DO:
                    ASSIGN v-cod-pn-fabric = item-fabric.it-fabric.

                    FIND fabricante NO-LOCK
                        WHERE fabricante.cod-fabric = ITEM-fabric.cod-fabric NO-ERROR.

                    IF  AVAIL fabricante
                    THEN
                        ASSIGN v-des-fabric = string(fabricante.cod-fabric) + " - " + fabricante.nome-abrev.
                    ELSE
                        ASSIGN v-des-fabric = string(fabricante.cod-fabric).
                END.
            END.
            /* Fim Busca Part Number do item fornecedor */
            
            
            PUT c-planejado                               ";" /*Planejador     */
                c-politica                                ";" /*Politica       */
                c-demanda                                 ";" /*Demanda*/
                item-uni-estab.lote-multipl               ";" /*Lote Multiplo  */
                item-uni-estab.lote-minimo                ";" /*Lote Minimo    */
                if avail item then item.un else ''        ";" /*Unid Med Item */
                item-uni-estab.lote-economi               ";" /*Lote Economico */
                item-uni-estab.periodo-fixo               ";" /*Periodo Fixo   */
                (IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol ELSE 0) FORMAT "->>>,>>>,>>>,>>9.99"     ";" /*Qtde Politica*/
                item-uni-estab.quant-segur                ";" /*Quantidade Segur   */
                trim(entry(item-uni-estab.tipo-est-seg, c-tp-est-seg, ";")) FORMAT 'X(10)':U ";" /*Tipo Estq Seguranca*/
                item-uni-estab.tempo-segur                ";"
                item-uni-estab.conv-tempo-seg             ";"
                c-reab-estoq                              ";" /*Reabastecimento      */
                c-classe-repro                            ";" /*Classe Reprogramacao */
                c-emissao-ord                             ";" /*Emissao Ordens       */
                c-div-ordem                               ";" /*Divisao Ordens       */
                item-uni-estab.int-1                      ";" /*Prioridade MRP       */
                l-demanda-item                            ";" /*Repressa Demanda     */
                item-uni-estab.prioridade                 ";"
                item-uni-estab.res-int-comp               ";" /*Ressupr Compras     */
                item-uni-estab.res-cq-comp                ";" /*Ressupr CQ          */
                i-res-item-estab                          ";" /*Ressupr Fornec      */
                SUBSTRING(item-uni-estab.char-1,129,3)    ";" /*Horizonte Liber     */                
                item-uni-estab.horiz-fixo                 ";" /*Horizonte Fixo      */               
                item-uni-estab.deposito-pad               ";" /*Deposito Padr       */
                item-uni-estab.tp-desp-padrao             ";" /*Tp Despesa          */
                IF AVAIL int-item-uni-estab THEN STRING(int-item-uni-estab.codigo-orig) ELSE "" ";" /*Cod Origem          */
                (IF AVAIL int-item-uni-estab THEN c-origem ELSE "") FORMAT "X(40)"      ";" /*Desc Origem         */
                c-cod-fornec                              ";" /*C¢digo Fornecedor   */
                c-fornec                                  ";" /*Fornecedor          */
                i-perc-fornec                             ";" /*Perc Compra Fornec  */
                c-pais-for                                ";" /*Pais                */
                c-itiner                                  ";" /*Itinerario Padrao   */
                c-pto-contr                               ";" /*Ponto Controle Base */
                c-incoterm                                ";" /*Incoterm            */
                c-idioma                                  ";" /*Idioma Padrao       */
                c-cond-pagto                              ";"
                c-moeda-pr-item                           ";"
                i-res-for                                 ";" /*Tempo Ressupr       */
                i-horiz-fixo                              ";"
                de-lote-mult-for                          ";"  /*Lote Multiplo      */
                de-lote-min-for                           ";"  /*Lote Minimo        */
                if avail item-fornec-estab then item-fornec-estab.unid-med-for else '' ";"
                v-des-fabric                              ";"  /*Fabricante do Componente */
                v-cod-pn-fabric                           ";". /*Part Number do componente para o Fabricante */

            IF tt-param.l-saldo-excesso THEN DO:

                ASSIGN d-sd-qs         = 0
                       d-sd-qp         = 0
                       d-excesso       = 0
                       i-cont-sal-terc = 0.

                FOR EACH tt-periodo 
                    BY tt-periodo.ano
                    BY tt-periodo.mes:

                    ASSIGN i-cont-sal-terc = i-cont-sal-terc + 1.

                    ASSIGN de-saldo  = (de-saldo + tt-periodo.de-oc + (IF i-cont-sal-terc = 1 THEN de-saldo-terc ELSE 0)) - (tt-periodo.de-pl)
                           d-excesso = ((de-saldo - (IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol ELSE 0)) * de-preco)
                           d-sd-qs   = ((de-saldo / item-uni-estab.quant-segur) * 100)
                           d-sd-qp   = ((de-saldo / IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol ELSE 0) * 100).

                    IF d-sd-qs = ? THEN ASSIGN d-sd-qs = 0.
                    IF d-sd-qp = ? THEN ASSIGN d-sd-qp = 0.

                    PUT de-saldo ";" STRING(d-excesso) ";" d-sd-qs ";"  d-sd-qp ";".
                  /*  PUT i-saldo-alm ";"
                        i-saldo-rec ";"
                        i-saldo-pro ";"
                        i-saldo-ast ";"
                        STRING(d-excesso) ";" d-sd-qs ";"  d-sd-qp ";". */
                END.

            END.
        END. /* IF  tt-param.log-forecast = NO */
        ELSE
            IF tt-param.l-depos-disponivel-oem THEN
               PUT item-uni-estab.cod-estabel                ";"
                   item-uni-estab.it-codigo                  ";"
                   item.desc-item                            ";"
                   de-saldo                                  ";" /*Saldo              */ 
                  /* i-saldo-alm                               ";"
                   i-saldo-rec                               ";"
                   i-saldo-pro                               ";"
                   i-saldo-ast                               ";" */
                   item-uni-estab.lote-multipl               ";" /*Lote Multiplo      */
                   item-uni-estab.lote-minimo                ";" /*Lote Minimo        */
                  (IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol ELSE 0) FORMAT "->>>,>>>,>>>,>>9.99"     ";" /*Qtde Politica*/
                   item-uni-estab.quant-segur                ";" /*Quantidade Segur   */  
                   c-cod-fornec                              ";" /*C¢digo Fornecedor  */
                   c-fornec                                  ";". /*Fornecedor        */
            ELSE
               PUT item-uni-estab.cod-estabel                ";"
                   item-uni-estab.it-codigo                  ";"
                   item.desc-item                            ";"
                 /*  de-saldo                                  ";" /*Saldo              */ */
                   i-saldo-alm                               ";"
                   i-saldo-rec                               ";"
                   i-saldo-pro                               ";"
                   i-saldo-ast                               ";"
                   item-uni-estab.lote-multipl               ";" /*Lote Multiplo      */
                   item-uni-estab.lote-minimo                ";" /*Lote Minimo        */
                  (IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol ELSE 0) FORMAT "->>>,>>>,>>>,>>9.99"     ";" /*Qtde Politica*/
                   item-uni-estab.quant-segur                ";" /*Quantidade Segur   */  
                   c-cod-fornec                              ";" /*C¢digo Fornecedor  */
                   c-fornec                                  ";". /*Fornecedor        */

        IF tt-param.l-entrega-cons 
        THEN DO:
            FOR EACH tt-periodo
                BY tt-periodo.ano
                BY tt-periodo.mes:
                PUT tt-periodo.de-oc ";".
            END.

            ASSIGN d-tot-de-pl  = 0
                   d-sd-qs      = 0
                   d-sd-qp      = 0
                   d-excesso    = 0
                   d-lt-min     = 0
                   d-cons-med   = 0
                   d-cons-med-r = 0.

            FOR EACH tt-periodo
                BY tt-periodo.ano
                BY tt-periodo.mes:
                PUT tt-periodo.de-pl ";".
                ASSIGN d-tot-de-pl = d-tot-de-pl + tt-periodo.de-pl.
            END.
        END.

        ASSIGN d-sd-qs = (de-saldo / item-uni-estab.quant-segur) * 100
               d-sd-qp = (de-saldo / (IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol ELSE 0)) * 100
               d-excesso = (de-saldo - (IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol ELSE 0)) * de-preco
               d-lt-min  = (item-uni-estab.lote-minimo / (IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol ELSE 0)) * 100
               d-cons-med = d-tot-de-pl / (tt-param.periodo-fim - tt-param.periodo-ini)
               d-cons-med-r = d-cons-med * de-preco. 

        IF  tt-param.log-forecast = NO
        THEN DO:
            IF  tt-param.l-entrega-cons  OR 
                tt-param.l-saldo-excesso THEN
                PUT d-cons-med   ";"
                    d-cons-med-r ";"
                    d-sd-qs      ";"
                    d-sd-qp      ";" 
                    d-excesso    ";"
                    d-lt-min     ";".
        END.

        IF  tt-param.log-forecast = NO
        THEN DO:
            IF tt-param.l-validade-item 
            THEN DO:
                FOR FIRST familia NO-LOCK
                    WHERE familia.fm-codigo = ITEM.fm-codigo,
                    FIRST int-familia OF familia:
                END.

                IF AVAIL int-familia THEN
                    PUT int-familia.meses-validade ";".
                ELSE
                    PUT ";".

                FOR EACH  tt-periodo
                    WHERE tt-periodo.anomes >= STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99")
                       BY tt-periodo.anomes:

                    IF CAN-FIND(FIRST tt-ae
                                WHERE tt-ae.it-codigo = ITEM.it-codigo
                                  AND tt-ae.periodo   = tt-periodo.anomes) THEN
                        FOR FIRST tt-ae
                            WHERE tt-ae.it-codigo = ITEM.it-codigo
                              AND tt-ae.periodo   = tt-periodo.anomes NO-LOCK:

                        PUT tt-ae.tot-qtd ";".
                    END.
                    ELSE
                        PUT ";".
                END.
            END. /* IF tt-param.l-validade-item */
        END. /* IF  tt-param.log-forecast = NO */

        IF tt-param.log-planejadas
        THEN DO:
            FOR EACH tt-periodo
                BY tt-periodo.ano
                BY tt-periodo.mes:
                PUT tt-periodo.de-oc-plan ";".
            END.
        END.

        PUT (if avail item-fornec-estab then item-fornec-estab.fator-conver else 0) FORM ">>>>>>>>9" ";"
            (if avail item-fornec-estab then item-fornec-estab.num-casa-dec else 0) ";".

        /* In¡cio APS */
        if not avail int-item-uni-estab
        then put ";;;;;;;;;;;;;;;;;;".
        else put int-item-uni-estab.log-comp-spot    FORMAT "Sim/NÆo" ";"
                 int-item-uni-estab.log-mod-aereo    FORMAT "Sim/NÆo" ";"
                 int-item-uni-estab.log-phase-in     FORMAT "Sim/NÆo" ";"
                 int-item-uni-estab.log-phase-out    FORMAT "Sim/NÆo" ";"
                 int-item-uni-estab.num-dias-transf                   ";"
                 int-item-uni-estab.cod-modelo                        ";"
                 int-item-uni-estab.qtd-min-comp                      ";"
                 int-item-uni-estab.qtd-min-fab                       ";"
                 int-item-uni-estab.qtd-max-comp                      ";"
                 int-item-uni-estab.qtd-max-fab                       ";"
                 int-item-uni-estab.num-dias-min                      ";"
                 int-item-uni-estab.num-dias-alvo                     ";"
                 int-item-uni-estab.num-dias-cob-mp                   ";"
                 int-item-uni-estab.num-dias-alvo-mp                  ";"
                 int-item-uni-estab.num-dias-antec                    ";"
                 int-item-uni-estab.log-item-rest    FORMAT "Sim/NÆo" ";"
                 int-item-uni-estab.log-bloq-prod    FORMAT "Sim/NÆo" ";"
                 int-item-uni-estab.log-requer-aval  FORMAT "Sim/NÆo" ";".
        /* Fim APS */
        
        PUT "" SKIP.
        
    END. /* IF NOT(tt-param.l-saldo) OR (tt-param.l-saldo AND de-saldo > 0) */

    
END PROCEDURE.

PROCEDURE pi-gera-periodo:
    EMPTY TEMP-TABLE tt-periodo.

    ASSIGN dt-aux = tt-param.periodo-ini.

    DO WHILE(dt-aux <= tt-param.periodo-fim):
        CREATE tt-periodo.
        ASSIGN tt-periodo.mes    = MONTH(dt-aux)
               tt-periodo.ano    = YEAR(dt-aux)
               tt-periodo.anomes = STRING(YEAR(dt-aux), "9999":U) + STRING(MONTH(dt-aux), "99":U).

        ASSIGN dt-aux = ADD-INTERVAL(dt-aux, 1, "MONTHS":U).
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE busca-posicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each embarque-imp no-lock
       where embarque-imp.situacao = 1
         AND embarque-imp.cod-estabel = ordens-embarque.cod-estabel
         and embarque-imp.embarque = ordens-embarque.embarque:

        {esp/imp/esimp000.i} 
    end.

END PROCEDURE.

