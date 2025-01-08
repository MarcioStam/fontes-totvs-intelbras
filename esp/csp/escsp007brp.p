/***********************************************************************
**  Programa..: ESP\CSP\ESCSP007bRP.P
**  Autor.....: Raphael Matei Paini
**  Data......: AGOSTO/2008 - Desenvolvimento
**  Descricao.: Acompanhamento Entradas Produtos
**  Vers∆o....: 001 21/08/2009
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCSP007BRP 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/csp/escsp007btt.i}
{esp/es0018.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
def temp-table tt-desp      no-undo
    FIELD pai-filho         AS INT
    field it-codigo         like item.it-codigo             format "x(7)"
    FIELD desc-item         AS CHARACTER                    FORMAT "x(40)"
    FIELD codigo-orig       LIKE ITEM.codigo-orig
    field dt-fim            as date
    field dt-trans          as date
    FIELD dt-emis           AS DATE
    field nro-docto         like docum-est.nro-docto        format "x(7)"
    field serie-docto       like docum-est.serie-docto
    FIELD nat-operacao      LIKE docum-est.nat-operacao  
    FIELD cod-emitente      LIKE emitente.cod-emitente
    FIELD nome-emit         LIKE emitente.nome-emit
    FIELD unid-neg          AS CHARACTER 
    field num-pedido        like pedido-compr.num-pedido
    field embarque          like embarque-imp.embarque
    field numero-ordem      like ordem-compra.numero-ordem
    FIELD quantidade        like item-doc-est.quantidade
    FIELD qt-do-forn        LIKE item-doc-est.qt-do-forn
    FIELD qt-estrut         AS DECIMAL
    FIELD cons-mensal       AS DECIMAL
    FIELD saldo-inicial     AS DECIMAL
    FIELD saldo-mes         AS DECIMAL
    FIELD custo-anterior    AS DECIMAL
    FIELD custo-mes         AS DECIMAL
    FIELD un                like item-doc-est.un
    FIELD custo             AS DECIMAL                      
    field preco-unit        like ordem-compra.preco-unit    
    field preco-total       like ordem-compra.preco-orig    
    field peso-liq          like item.peso-liquido          
    FIELD ncm               AS CHARACTER                    
    FIELD base-importacao   AS DECIMAL                      
    FIELD aliq-importacao   AS DECIMAL                      
    FIELD val-importacao    AS DECIMAL                      
    FIELD val-frete         AS DECIMAL                      
    FIELD val-seguro        AS DECIMAL                      
    FIELD val-handling      AS DECIMAL                      
    field val-desp-out      AS DECIMAL                      
    FIELD valor-ipi         AS DECIMAL 
    FIELD valor-icm         AS DECIMAL
    FIELD aliquota-icms     AS DECIMAL
    field val-desp-total    AS DECIMAL
    field val-nc            AS DECIMAL
    field fator-internacao  like ordem-compra.preco-orig    format ">>>>9.999999"
    field fator-internacao-total  like ordem-compra.preco-orig    format ">>>>9.999999"
    field preco-unit-oc     like ordem-compra.preco-unit    
    FIELD cotacao           AS DECIMAL                      FORMAT ">>>>>9.99999"
    FIELD moeda             AS CHARACTER                    FORMAT "x(08)"
    FIELD origem            AS CHARACTER                    FORMAT "x(20)"
    FIELD via-transp        AS CHARACTER                    FORMAT "x(10)"
    FIELD di                AS CHARACTER 
    FIELD val-base-icms      LIKE it-doc-fisc.vl-icmsou-it
    FIELD cod-tributac       LIKE dwf-docto-item-impto.cod-tributac
    FIELD cod-ean            LIKE item-mat.cod-ean
    FIELD cod-estabel        LIKE docum-est.cod-estabel
    FIELD de-val-medio-venda LIKE it-doc-fisc.vl-icmsou-it
    FIELD transferido       AS LOG
    FIELD origem-valor      AS CHAR FORMAT "x(20)"
    INDEX chave it-codigo dt-fim dt-trans.

DEFINE TEMP-TABLE tt-consumo NO-UNDO
    FIELD it-codigo AS CHARACTER
    FIELD data-fim  AS DATE
    FIELD consumo   AS DECIMAL
    INDEX chave it-codigo data-fim.

DEFINE TEMP-TABLE tt-saldo NO-UNDO
    FIELD it-codigo      AS CHARACTER
    FIELD data-fim       AS DATE
    FIELD saldo-inicial  AS DECIMAL
    FIELD saldo-mes      AS DECIMAL
    FIELD custo-anterior AS DECIMAL
    FIELD custo-mes      AS DECIMAL
    INDEX chave it-codigo data-fim.

def temp-table tt-estrutura no-undo
    field it-item   as char
    field seq-cont  as integer
    field sequencia as integer
    field it-codigo as char
    field es-codigo as char
    FIELD quant-usada AS DECIMAL FORMAT "->>>,>>>,>>9.99999"
    FIELD c-aux       AS CHARACTER 
    &if defined (bf_man_sfc_lc) &then
        FIELD cod-lista-compon AS CHAR
    &endif
    INDEX codigo IS UNIQUE PRIMARY it-item seq-cont
    INDEX chave1 it-item es-codigo c-aux
    INDEX chave2 es-codigo.

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo AS CHARACTER
    FIELD qt-estrut AS DECIMAL
    FIELD codigo-orig LIKE ITEM.codigo-orig
    INDEX chave it-codigo.

DEFINE TEMP-TABLE tt-naturezas NO-UNDO
    FIELD nat-operacao AS CHARACTER
    INDEX chave nat-operacao.

/****************************  Variaveis    ****************************/
/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

DEFINE BUFFER b-item FOR ITEM.
DEFINE BUFFER b-item-fm FOR ITEM.
DEFINE BUFFER b-item-selecao FOR ITEM.

DEFINE BUFFER b-tt-estrutura FOR tt-estrutura.

DEFINE BUFFER b-docum-est    FOR docum-est.
DEFINE BUFFER b-item-doc-est FOR item-doc-est.
DEFINE BUFFER b-natur-oper FOR natur-oper.
create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 

def var h-acomp      as handle no-undo.

DEFINE VARIABLE dt-data            AS DATE  NO-UNDO.
DEFINE VARIABLE dt-ini             AS DATE  NO-UNDO.
DEFINE VARIABLE dt-fim             AS DATE  NO-UNDO.
DEFINE VARIABLE de-consumo         AS DECIMAL  NO-UNDO.
DEFINE VARIABLE de-saldo           AS DECIMAL  NO-UNDO.
DEFINE VARIABLE de-saldo-mes       AS DECIMAL  NO-UNDO.
DEFINE VARIABLE de-custo-anterior  AS DECIMAL  NO-UNDO.
DEFINE VARIABLE de-custo-mes       AS DECIMAL  NO-UNDO.

DEFINE VARIABLE i-seq              AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont             AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-refer-incluida   AS LOGICAL NO-UNDO INITIAL NO.
DEFINE VARIABLE c-refer-es         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-refer            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-aux              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-alt              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-nivel            AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-processo         AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE c-controle-nivel   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-numero-ordem     AS INTEGER     NO-UNDO.
DEFINE VARIABLE da-corte           AS DATE NO-UNDO.
DEFINE VARIABLE c-item-pai         AS CHAR FORMAT "x(16)" NO-UNDO.
DEFINE VARIABLE de-valor-medio    LIKE tt-desp.de-val-medio-venda NO-UNDO.
DEFINE VARIABLE de-parcela-importacao AS DEC NO-UNDO.
DEFINE VARIABLE de-total              AS DEC NO-UNDO.
DEFINE VARIABLE c-origem-valor        AS CHARACTER   NO-UNDO.
DEF VAR de-mes-base AS DATE FORMAT "99/99/9999" INIT TODAY NO-UNDO.

/* Para selecionar a mÇdia ponderada, ser† utilizado hist¢rico de 6 meses para tr†s, 
   partindo do màs imediatamente anterior ao corrente */
ASSIGN de-mes-base = DATE("01/" + string(MONTH(tt-param.dt-base), "99") + "/" + string(YEAR(tt-param.dt-base), "9999")).
      
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.


FIND FIRST param-estoq NO-LOCK NO-ERROR.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Acompanhamento Entradas Produtos"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCSP007B"
       c-versao       = "2.04"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */

ASSIGN da-corte = tt-param.dt-base .

{include/i-rpout.i &pagesize="0"}

/*PUT "Item;Descriá∆o;NCM;EAN;Un;Transaá∆o;Estab;Ser;Docto;Natureza;Quantidade;CIF Total;CIF Unit;B ICMS Total;B ICMS Unit;Qtd Estr;Parc Import;Total Sa°da;Cont Impotaá∆o (C.I)" SKIP.*/
PUT "Item;Descriá∆o;Origem;NCM;EAN;Un;Transaá∆o;Estab;Ser;Docto;Natureza;Quantidade;Custo;Qtd Estr;Aliq ICM;Vlr IPI;Vlr ICM;Vlr Mercadoria;Frete;Seguro;Total;Parc Import;Total Sa°da;Cont Impotaá∆o (C.I)" SKIP.

run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Imprimindo...").

/* Conforme Jorge (contabilidad), ser∆o consideradas sempre todas as CFOPs de importaá∆o */
FOR EACH tt-naturezas:
    DELETE tt-naturezas.
END.

RUN esp/es0018p.p (INPUT "escsp007rp", /*Conforme Thiago (fiscal), utilizar mesma regra do escsp007rp*/
                   INPUT 1,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).

IF CAN-FIND(FIRST tt-prog-ponto NO-LOCK) THEN DO:
    FOR EACH tt-prog-ponto:
        CREATE tt-naturezas.
        ASSIGN tt-naturezas.nat-operacao = tt-prog-ponto.conteudo.
    END.
END.

IF tt-param.rs-opcao = 2 THEN DO:

    FOR EACH b-item-fm  NO-LOCK
        WHERE b-item-fm.fm-codigo >= tt-param.fm-codigo-ini
          AND b-item-fm.fm-codigo <= tt-param.fm-codigo-fim:

        IF tt-param.listar-faturaveis = YES  THEN DO:
            IF b-item-fm.ind-item-fat = NO THEN NEXT.
        END.

        ASSIGN c-item-pai = b-item-fm.it-codigo.

        RUN pi-zera-variaveis.
        RUN piImprimeRelat.
        
    END.
END.
ELSE DO:
    IF CAN-FIND (FIRST tt-digita) THEN DO:
        FOR EACH tt-digita:
            FIND FIRST b-item-selecao NO-LOCK
                 WHERE b-item-selecao.it-codigo = tt-digita.it-codigo NO-ERROR.

            IF NOT AVAIL b-item-selecao THEN
                NEXT.

            IF tt-param.listar-faturaveis = YES  THEN DO:
                IF b-item-selecao.ind-item-fat = NO THEN NEXT.
            END.
        
            ASSIGN c-item-pai = b-item-selecao.it-codigo.
    
            RUN pi-zera-variaveis.
            RUN piImprimeRelat.
        END.
    END.
    ELSE DO:
        FOR EACH b-item-selecao  NO-LOCK
            WHERE b-item-selecao.it-codigo >= tt-param.it-codigo-ini
              AND b-item-selecao.it-codigo <= tt-param.it-codigo-fim:
    
            IF tt-param.listar-faturaveis = YES  THEN DO:
                IF b-item-selecao.ind-item-fat = NO THEN NEXT.
            END.
        
            ASSIGN c-item-pai = b-item-selecao.it-codigo.
    
            RUN pi-zera-variaveis.
            RUN piImprimeRelat.
        END.
    END.
END.


run pi-finalizar in h-acomp.
{include/i-rpclo.i}
RETURN "OK".


/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE pi-zera-variaveis:
    
    /* Limpa as temp-tables */
    EMPTY TEMP-TABLE tt-desp.
    EMPTY TEMP-TABLE tt-consumo.
    EMPTY TEMP-TABLE tt-saldo.
    EMPTY TEMP-TABLE tt-estrutura.
    EMPTY TEMP-TABLE tt-item.

    ASSIGN dt-data             = ?
           dt-ini              = ?
           dt-fim              = ?
           de-consumo          = 0
           de-saldo            = 0
           de-saldo-mes        = 0
           de-custo-anterior   = 0
           de-custo-mes        = 0
           i-seq               = 0
           i-cont              = 0
           l-refer-incluida    = NO
           c-refer-es          = ""
           c-refer             = ""
           c-aux               = ""
           c-alt               = ""
           i-nivel             = 0
           c-processo          = ""
           c-controle-nivel    = 0
           i-numero-ordem      = 0.

END.

PROCEDURE pi-busca-media:

    DEF INPUT  PARAMETER p-item LIKE ITEM.it-codigo NO-UNDO.
    DEF OUTPUT PARAMETER p-de-valor-medio LIKE tt-desp.de-val-medio-venda NO-UNDO.

    DEF VAR i AS INTEGER NO-UNDO.
    DEF VAR da-ini AS DATE NO-UNDO.
    DEF VAR da-fim AS DATE NO-UNDO.
    DEF VAR l-retorno AS LOG NO-UNDO.

    ASSIGN da-ini = de-mes-base.

    DO i = 1 TO 6:
        
        ASSIGN da-fim = DATE ("01/" + string(MONTH(da-ini + 32)) + "/" + string(YEAR(da-ini + 33))).
               da-fim = da-fim - 1.
        
        RUN pi-acompanhar IN h-acomp (INPUT "buscando faturamentos entre: " + STRING(da-ini) + " e " + STRING(da-fim)).
        
        RUN pi-retorna-saida-ponderada (INPUT p-item,
                                        INPUT da-ini,
                                        INPUT da-fim,
                                        OUTPUT l-retorno,
                                        OUTPUT p-de-valor-medio).
    
        IF  l-retorno THEN
            LEAVE.
        ELSE
            da-ini =  DATE ("01/" + string(MONTH(da-ini - 1)) + "/" + string(YEAR(da-ini - 1))).
    END.

    /*ASSIGN tt-desp.de-val-medio-venda = de-valor-medio.*/
    
END.

PROCEDURE pi-retorna-saida-ponderada:

    DEF INPUT PARAM p-item LIKE ITEM.it-codigo NO-UNDO.
    DEF INPUT PARAM p-data-ini AS DATE NO-UNDO.
    DEF INPUT PARAM p-data-fim AS DATE NO-UNDO.
    DEF OUTPUT PARAM l-retornou AS LOG NO-UNDO.
    DEF OUTPUT PARAM p-valor-medio AS DEC NO-UNDO.

    DEF VAR de-quant LIKE it-nota-fisc.qt-faturada[1].
    DEF VAR de-total LIKE it-nota-fisc.vl-tot-item.
    ASSIGN c-origem-valor = "".

    FOR EACH nota-fiscal USE-INDEX nfftrm-20 NO-LOCK
        WHERE nota-fiscal.dt-emis-nota >= p-data-ini
          AND nota-fiscal.dt-emis-nota <= p-data-fim
          AND nota-fiscal.cod-estabel   = tt-param.cod-estabel
          AND nota-fiscal.dt-cancel     = ? /* N∆o estiver cancelada */
          AND nota-fiscal.dt-confirma  <> ?, /* j† atualizada no estoque */
         EACH it-nota-fisc NO-LOCK OF nota-fiscal
        WHERE it-nota-fisc.it-codigo = p-item,
        FIRST b-natur-oper NO-LOCK 
        WHERE b-natur-oper.nat-operacao               = it-nota-fisc.nat-operacao
          AND substr(b-natur-oper.nat-operacao, 1, 1) = "6":

            ASSIGN l-retornou = YES
                   de-quant = de-quant + it-nota-fisc.qt-faturada[1].
            IF it-nota-fisc.cd-trib-icm = 1 THEN
               ASSIGN de-total = de-total + it-nota-fisc.vl-merc-liq - it-nota-fisc.vl-icms-it.
            ELSE
               ASSIGN de-total = de-total + it-nota-fisc.vl-merc-liq.

    END.
   /* IF de-total = 0 THEN DO:
       FOR EACH nota-fiscal USE-INDEX nfftrm-20 NO-LOCK
            WHERE nota-fiscal.dt-emis-nota >= p-data-ini
              AND nota-fiscal.dt-emis-nota <= p-data-fim
              AND nota-fiscal.dt-cancel    = ? /* N∆o estiver cancelada */
              AND nota-fiscal.dt-confirma <> ? /* j† atualizada no estoque */
              ,EACH it-nota-fisc NO-LOCK
                OF nota-fiscal
            WHERE it-nota-fisc.it-codigo = p-item
            , FIRST b-natur-oper NO-LOCK
                WHERE b-natur-oper.nat-operacao = it-nota-fisc.nat-operacao
                  AND substr(b-natur-oper.nat-operacao, 1, 1) = "5":
    
                ASSIGN l-retornou = YES
                       de-quant = de-quant + it-nota-fisc.qt-faturada[1].
                IF it-nota-fisc.cd-trib-icm = 1 THEN
                   ASSIGN de-total = de-total + it-nota-fisc.vl-merc-liq - it-nota-fisc.vl-icms-it.
                ELSE
                   ASSIGN de-total = de-total + it-nota-fisc.vl-merc-liq.
    
        END.
    END. */
    IF de-total = 0 THEN DO:
        IF can-find(first preco-item
                    where preco-item.it-codigo  = p-item
                      AND preco-item.nr-tabpre  = "minimo"
                      and preco-item.cod-refer  = ""
                      and preco-item.situacao   = 1 no-lock) THEN DO:

            ASSIGN de-total = 0
                   de-quant = 0.
            FOR EACH preco-item
               where preco-item.it-codigo  = p-item
                 AND preco-item.nr-tabpre  = "minimo"
                 and preco-item.cod-refer  = ""
                 and preco-item.situacao   = 1 no-lock:
            
                ASSIGN de-total = de-total + preco-item.preco-venda
                       de-quant = de-quant + 1
                       c-origem-valor = "Tabela".
            END.
        END.
        ELSE
            c-origem-valor = "Inexistente".
    END.
    ELSE
        ASSIGN c-origem-valor = "Faturamento".
    ASSIGN p-valor-medio = de-total / de-quant.
   
    
END.


PROCEDURE piImprimeRelat:
    DEFINE VARIABLE de-custo-medio     AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-custo-total     AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-preco-total     AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-custo-total-cif AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-quantidade      AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-val-frete       AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-val-peso        AS DECIMAL  NO-UNDO.

    FIND FIRST tt-param.

    /* Buscar valor mÇdia ponderada de venda */
    ASSIGN de-valor-medio = 0. 
    RUN pi-busca-media (INPUT c-item-pai,
                        OUTPUT de-valor-medio).
    
    IF  (de-valor-medio = 0 OR de-valor-medio = ?) AND NOT tt-param.listar-sem-venda THEN
        RETURN "OK".

    RUN pi-busca-estrutura.

    RUN pi-filtra-materias.

    /******************************* ROTINA PARA BUSCA DA ÈLTIMA ENTRADA **************************************************/


    /**********************************************************************************************************************/


    /**************************************** Busca os IMPORTADOS ****************************************/
    /* Para essa primeira busca, a regra Ç apenas listar se a £ltima entrada do item for uma IMPORTAÄ«O. */
    /* caso contr†rio, desconsiderar o item                                                              */
    FOR EACH tt-item NO-LOCK,
       FIRST ITEM NO-LOCK
       WHERE ITEM.it-codigo = tt-item.it-codigo:

        IF NOT CAN-FIND(FIRST tt-desp NO-LOCK
                        WHERE tt-desp.it-codigo = tt-item.it-codigo) THEN DO:
            FOR EACH item-doc-est NO-LOCK
               WHERE item-doc-est.it-codigo = tt-item.it-codigo
                 AND item-doc-est.data <= tt-param.dt-base,
               FIRST docum-est OF item-doc-est NO-LOCK
                   WHERE docum-est.cod-estabel = tt-param.cod-estabel
                     AND docum-est.CE-atual    = YES
               ,
               FIRST natur-oper NO-LOCK
                   WHERE natur-oper.nat-operacao = item-doc-est.nat-operacao
               ,
               FIRST emitente NO-LOCK
                   WHERE emitente.cod-emitente = docum-est.cod-emitente
                BY item-doc-est.data DESCENDING:

                IF NOT natur-oper.emite-duplic OR natur-oper.tipo-compra <> 1 THEN NEXT.

/*                 IF NOT CAN-FIND(FIRST tt-naturezas NO-LOCK                                 */
/*                                 WHERE tt-naturezas.nat-operacao = natur-oper.nat-operacao) */
/*                 THEN NEXT.                                                                 */
/*                                                                                            */

/*                     IF  NOT CAN-FIND(FIRST tt-naturezas NO-LOCK                                         */  /* chamado ir 105137 passou a considerar somente os codigos de origem de 1 2 ou 3 */
/*                                     WHERE tt-naturezas.nat-operacao = natur-oper.nat-operacao) THEN DO: */
/*                         IF  NOT natur-oper.emite-duplic OR natur-oper.tipo-compra <> 1 THEN             */
/*                             NEXT.                                                                       */
/*                     END.                                                                                */


/*                 IF  SUBSTR(natur-oper.nat-operacao, 1, 1) <> "3" THEN  */
/*                    /* NEXT.*/                                          */
/*                     LEAVE.                                             */

                RUN pi-acompanhar IN h-acomp ("Item: " + TRIM(item-doc-est.it-codigo) + " - Data: " + STRING(docum-est.dt-trans,"99/99/99") + " - NF: " + trim(docum-est.nro-docto)).
                
                IF INT(SUBSTRING(natur-oper.nat-operacao,2,3)) < 101 OR
                   INT(SUBSTRING(natur-oper.nat-operacao,2,3)) > 124 THEN next.
                
                RUN pi-carrega-tt.

                LEAVE.
            END.
        END.
    END.


    /*Para os itens que ele n∆o achou na buscar da utlima entrada no estabelecimento informado, o programa tenta buscar a ult entrada em outro estab */
    FOR EACH tt-item NO-LOCK,
       FIRST ITEM NO-LOCK
       WHERE ITEM.it-codigo = tt-item.it-codigo:

        IF NOT CAN-FIND(FIRST tt-desp NO-LOCK
                        WHERE tt-desp.it-codigo = tt-item.it-codigo) THEN DO:
            FOR EACH item-doc-est NO-LOCK
               WHERE item-doc-est.it-codigo = tt-item.it-codigo
                 AND item-doc-est.data <= tt-param.dt-base,
               FIRST docum-est OF item-doc-est NO-LOCK
                   WHERE docum-est.cod-estabel <> tt-param.cod-estabel
               ,
               FIRST natur-oper NO-LOCK
                   WHERE natur-oper.nat-operacao = item-doc-est.nat-operacao
               ,
               FIRST emitente NO-LOCK
                   WHERE emitente.cod-emitente = docum-est.cod-emitente
                BY item-doc-est.data DESCENDING:

/*                                                                                                   */
/*                 IF  NOT CAN-FIND(FIRST tt-naturezas NO-LOCK                                       */ /* chamado ir 105137 passou a considerar somente os codigos de origem de 1 2 ou 3 */
/*                               WHERE tt-naturezas.nat-operacao = natur-oper.nat-operacao) THEN DO: */
/*                     IF  NOT natur-oper.emite-duplic OR natur-oper.tipo-compra <> 1 THEN           */
/*                         NEXT.                                                                     */
/*                 END.                                                                              */

/*                 IF NOT CAN-FIND(FIRST tt-naturezas NO-LOCK                                 */
/*                                 WHERE tt-naturezas.nat-operacao = natur-oper.nat-operacao) */
/*                 THEN NEXT.                                                                 */
/*                                                                                            */

/*                 IF  SUBSTR(natur-oper.nat-operacao, 1, 1) <> "3" THEN  */
/*                    /* NEXT.*/                                          */
/*                     LEAVE.                                             */

                RUN pi-acompanhar IN h-acomp ("Item: " + TRIM(item-doc-est.it-codigo) + " - Data: " + STRING(docum-est.dt-trans,"99/99/99") + " - NF: " + trim(docum-est.nro-docto)).
                
                IF INT(SUBSTRING(natur-oper.nat-operacao,2,3)) < 101 OR
                   INT(SUBSTRING(natur-oper.nat-operacao,2,3)) > 124 THEN next.
               
                RUN pi-carrega-tt.

                LEAVE.
            END.
        END.
    END.

    /******************************************* Cria a tt-desp para o item PAI *****************************************/
     FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = c-item-pai NO-ERROR.
   
     IF NOT AVAIL ITEM THEN
         RETURN "ok".
   
     create tt-desp.
     assign tt-desp.pai-filho        = 0
            tt-desp.it-codigo        = ITEM.it-codigo
            tt-desp.desc-item        = ITEM.desc-item
            tt-desp.codigo-orig      = ITEM.codigo-orig
            tt-desp.ncm              = ITEM.class-fisc
            tt-desp.origem-valor     = c-origem-valor.
   
     FIND FIRST item-mat NO-LOCK
         WHERE  item-mat.it-codigo = ITEM.it-codigo NO-ERROR.
   
     IF  AVAIL item-mat THEN
         ASSIGN tt-desp.cod-ean = item-mat.cod-ean.
   
     ASSIGN tt-desp.un = ITEM.un.
   

    /********************************************************************************************************************/

    DEF VAR de-tot-parcela  LIKE tt-desp.qt-estrut        NO-UNDO.

    /*Elimina os registros que possuem quantida de estrutura zerada*/
    FOR EACH tt-desp:
        IF  tt-desp.qt-estrut = 0 AND tt-desp.pai-filho = 1 THEN  DO:
            DELETE tt-desp.
            NEXT.
        END.
/*         IF  SUBSTR(tt-desp.nat-operacao, 1, 1) <> "3" AND tt-desp.pai-filho = 1 THEN */
/*             DELETE tt-desp.                                                          */
    END.

    ASSIGN de-tot-parcela    = 0.

    FOR EACH tt-desp
        WHERE tt-desp.pai-filho = 1. /* Là a apenas os filhos */
        ASSIGN de-total =   (tt-desp.preco-unit + 
                            tt-desp.val-frete  + 
                            tt-desp.val-seguro) * tt-desp.qt-estrut.

        IF  tt-desp.codigo-orig = 8  THEN
            ASSIGN de-parcela-importacao = (tt-desp.preco-unit - tt-desp.valor-icm / tt-desp.quantidade)  * tt-desp.qt-estrut.
        ELSE 
            IF  tt-desp.codigo-orig = 2 THEN
                   ASSIGN de-parcela-importacao = (tt-desp.preco-unit - tt-desp.valor-icm / tt-desp.quantidade)  * tt-desp.qt-estrut.
            ELSE
                IF tt-desp.codigo-orig = 3 THEN 
                    ASSIGN de-parcela-importacao = (((tt-desp.preco-unit  - tt-desp.valor-icm / tt-desp.quantidade)  * tt-desp.qt-estrut) / 2). /* È dividido por 2 porque o cst 3 È considerado 50% nacional e 50% immportado */
                ELSE
                    ASSIGN de-parcela-importacao = de-total.

        ASSIGN de-tot-parcela    = de-tot-parcela + de-parcela-importacao.
    END.


    FOR EACH tt-desp
        BREAK BY tt-desp.pai-filho:

        IF  tt-desp.pai-filho = 0 THEN DO:
            PUT UNFORMATTED 
                tt-desp.it-codigo                                        ";"
                tt-desp.desc-item                                        ";"
                tt-desp.codigo-orig                                      ";"
                tt-desp.ncm              FORMAT "x(10)"                  ";"
                tt-desp.cod-ean                                          ";"
                tt-desp.un                                               ";"
                                                                         ";"
                                                                         ";"
                                                                         ";" 
                                                                         ";" 
                                                                         ";" 
                                                                         ";"
                                                                         ";"
                                                                         ";"
                                                                         ";"
                                                                         ";"
                                                                         ";"
                                                                          ";"   
                                                                          ";"   
                                                                          ";"   
                                                                          ";"   
                de-tot-parcela                                           ";"
                de-valor-medio                                           ";"
                de-tot-parcela / de-valor-medio FORMAT ">,>>>,>>9.9999"   ";"
                tt-desp.origem-valor      SKIP.
            
        END.
        ELSE DO:
            IF tt-param.listar-sintetico = NO THEN DO:
           
                ASSIGN de-total =   (tt-desp.preco-unit + 
                                    tt-desp.val-frete  + 
                                    tt-desp.val-seguro) * tt-desp.qt-estrut.
    
                IF  tt-desp.codigo-orig = 8  THEN
                    ASSIGN de-parcela-importacao = (tt-desp.preco-unit - tt-desp.valor-icm / tt-desp.quantidade)  * tt-desp.qt-estrut.
                ELSE
                    IF  tt-desp.codigo-orig = 2  THEN
                        ASSIGN de-parcela-importacao = (tt-desp.preco-unit - tt-desp.valor-icm / tt-desp.quantidade)  * tt-desp.qt-estrut.
                    ELSE                          
                        IF tt-desp.codigo-orig = 3 THEN 
                            ASSIGN de-parcela-importacao = (((tt-desp.preco-unit - tt-desp.valor-icm / tt-desp.quantidade)  * tt-desp.qt-estrut) / 2). /* È dividido por 2 porque o cst 3 È considerado 50% nacional e 50% immportado */
                        ELSE
                            ASSIGN de-parcela-importacao = de-total.
                
                PUT UNFORMATTED 
                    tt-desp.it-codigo                                        ";"
                    tt-desp.desc-item                                        ";"
                    tt-desp.codigo-orig                                      ";"
                    tt-desp.ncm              FORMAT "x(10)"                  ";"
                    tt-desp.cod-ean                                          ";"
                    tt-desp.un                                               ";"
                    tt-desp.dt-trans                                         ";"
                    tt-desp.cod-estabel                                      ";"
                    tt-desp.serie-docto                                      ";" 
                    tt-desp.nro-docto                                        ";" 
                    tt-desp.nat-operacao                                     ";" 
                    tt-desp.quantidade        FORMAT ">,>>>,>>>,>>9.99"      ";"
                    /*de-custo-total-cif        FORMAT ">,>>>,>>9.9999"         ";"*/
                    tt-desp.custo             FORMAT ">,>>>,>>9.9999"         ";"
    
                    tt-desp.qt-estrut         FORMAT ">,>>>,>>>,>>9.999999"   ";"
    
                    tt-desp.aliquota-icm                                      ";"
                    tt-desp.valor-ipi / tt-desp.quantidade                    ";"
                    tt-desp.valor-icm / tt-desp.quantidade                    ";"
    
                    tt-desp.preco-unit        FORMAT ">,>>>,>>>,>>9.999999"   ";"
                    tt-desp.val-frete         FORMAT ">,>>>,>>>,>>9.999999"   ";"
                    tt-desp.val-seguro        FORMAT ">,>>>,>>>,>>9.999999"   ";"
                    de-total                  FORMAT "->>>,>>>,>>9.999999"   ";"
                    de-parcela-importacao     FORMAT "->>>,>>>,>>9.999999"   ";"
                    0                                          ";"
                    0                                          ";"  SKIP.
            END.
        END.
    END.

    /*PUT SKIP(1).*/



end procedure.

PROCEDURE pi-carrega-tt:
    DEFINE VARIABLE dt-custo AS DATE        NO-UNDO.

    DEF VAR de-valor-mat LIKE movto-estoq.valor-mat-m[1] NO-UNDO.
    DEF VAR de-qtde      LIKE movto-estoq.quantidade     NO-UNDO.

    create tt-desp.
    assign tt-desp.pai-filho          = 1
           tt-desp.it-codigo          = item-doc-est.it-codigo
           tt-desp.desc-item          = ITEM.desc-item
           tt-desp.ncm                = ITEM.class-fisc
           tt-desp.codigo-orig        = ITEM.codigo-orig
           tt-desp.dt-trans           = docum-est.dt-trans
           tt-desp.dt-emis            = docum-est.dt-emissao
           tt-desp.nro-docto          = docum-est.nro-docto
           tt-desp.serie-docto        = docum-est.serie-docto
           tt-desp.cod-emitente       = emitente.cod-emitente
           tt-desp.nome-emit          = emitente.nome-emit
           tt-desp.quantidade         = item-doc-est.quantidade
           tt-desp.qt-do-forn         = item-doc-est.qt-do-forn
           tt-desp.qt-estrut          = tt-item.qt-estrut
           tt-desp.un                 = item-doc-est.un
           tt-desp.preco-unit         = item-doc-est.preco-total[1] / item-doc-est.quantidade
           tt-desp.preco-total        = item-doc-est.preco-total[1]
           tt-desp.peso-liq           = item-doc-est.peso-liquido
           tt-desp.nat-operacao       = item-doc-est.nat-of
           tt-desp.cod-estabel        = docum-est.cod-estabel

           tt-desp.aliquota-icm       = item-doc-est.aliquota-icm
           tt-desp.valor-ipi          = item-doc-est.valor-ipi[1]   
           tt-desp.valor-icm          = item-doc-est.valor-icm[1].   
                                      
           

    /* Buscar base ICMS e CST */
    FIND it-doc-fisc NO-LOCK
        WHERE it-doc-fisc.cod-estabel  = docum-est.cod-estabel
          AND it-doc-fisc.serie        = docum-est.serie-docto
          AND it-doc-fisc.nr-doc-fis   = docum-est.nro-docto
          AND it-doc-fisc.cod-emitente = docum-est.cod-emitente
          AND it-doc-fisc.nat-operacao = docum-est.nat-operacao
          AND it-doc-fisc.nr-seq-doc   = (item-doc-est.sequencia * 2) - 10 NO-ERROR.

    IF  AVAIL it-doc-fisc
    THEN DO:
        /* ASSIGN tt-desp.val-base-icms = it-doc-fisc.vl-icmsou-it.*/

        /* Taxa 19 - Despesa SIXCOMEX */
        FOR FIRST item-doc-est-cex FIELDS(val-desp)
            WHERE item-doc-est-cex.cod-emitente = docum-est.cod-emitente
              AND item-doc-est-cex.nro-docto    = docum-est.nro-docto
              AND item-doc-est-cex.nat-operacao = docum-est.nat-operacao
              AND item-doc-est-cex.serie-docto  = docum-est.serie-docto
              AND item-doc-est-cex.sequencia    = item-doc-est.sequencia
              AND item-doc-est-cex.cod-desp     = 19 NO-LOCK:
        END.

        ASSIGN tt-desp.val-base-icms = it-doc-fisc.vl-bipi-it 
                                     + it-doc-fisc.vl-ipi-it
                                     + it-doc-fisc.val-pis
                                     + it-doc-fisc.val-cofins
                                     + IF AVAIL item-doc-est-cex THEN item-doc-est-cex.val-desp ELSE 0.

        FIND LAST dwf-docto-item-impto NO-LOCK
            WHERE dwf-docto-item-impto.cod-estab         = it-doc-fisc.cod-estabel 
              AND dwf-docto-item-impto.cod-serie         = it-doc-fisc.serie       
              AND dwf-docto-item-impto.cod-docto         = it-doc-fisc.nr-doc-fis  
              AND dwf-docto-item-impto.cod-emitente      = STRING(it-doc-fisc.cod-emitente)
              AND dwf-docto-item-impto.cod-natur-operac  = it-doc-fisc.nat-operacao
              AND dwf-docto-item-impto.num-seq-item      = it-doc-fisc.nr-seq-doc 
              AND dwf-docto-item-impto.cod-impto         = "ICMS" NO-ERROR.

        IF  AVAIL dwf-docto-item-impto
        THEN
            ASSIGN tt-desp.cod-tributac = dwf-docto-item-impto.cod-tributac.
    END.

    FIND FIRST item-mat NO-LOCK
        WHERE  item-mat.it-codigo = item-doc-est.it-codigo NO-ERROR.

    IF  AVAIL item-mat
    THEN
        ASSIGN tt-desp.cod-ean = item-mat.cod-ean.

    ASSIGN i-numero-ordem = item-doc-est.numero-ordem 
           de-valor-mat   = 0
           de-qtde        = 0.
    
    IF i-numero-ordem = 0 THEN DO:
        FIND FIRST rat-ordem OF item-doc-est NO-LOCK NO-ERROR.
        IF AVAIL rat-ordem THEN
            ASSIGN i-numero-ordem = rat-ordem.numero-ordem.
    END.

    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = i-numero-ordem NO-ERROR.
    IF AVAIL ordem-compra THEN DO:
        ASSIGN tt-desp.num-pedido       = ordem-compra.num-pedido
               tt-desp.numero-ordem     = ordem-compra.numero-ordem
               tt-desp.preco-unit-oc    = ordem-compra.preco-unit.

        FOR FIRST cotacao-item FIELDS (char-1)
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
               AND cotacao-item.cot-aprovada NO-LOCK:

            /*ASSIGN tt-desp.aliq-importacao = DEC(TRIM(SUBSTRING(cotacao-item.char-1,61,6))) NO-ERROR.
            IF tt-desp.aliq-importacao = ? OR tt-desp.aliq-importacao < 0 THEN
                ASSIGN tt-desp.aliq-importacao = 0.*/

        END.

        FIND FIRST movto-estoq NO-LOCK 
             WHERE movto-estoq.serie-docto  = docum-est.serie-docto
               AND movto-estoq.nro-docto    = docum-est.nro-docto
               AND movto-estoq.cod-emitente = docum-est.cod-emitente
               AND movto-estoq.nat-operacao = docum-est.nat-operacao 
               AND movto-estoq.numero-ordem = ordem-compra.numero-ordem
               AND movto-estoq.dt-trans     = docum-est.dt-trans
               AND movto-estoq.it-codigo    = item-doc-est.it-codigo
               AND movto-estoq.tipo-trans   = 1
               AND movto-estoq.esp-docto    = 21 
               AND movto-estoq.quantidade   = item-doc-est.quantidade NO-ERROR.
        IF AVAIL movto-estoq THEN DO:
            ASSIGN de-valor-mat = movto-estoq.valor-mat-m[1]
                   de-qtde      = item-doc-est.quantidade.
        END.
        ELSE DO:
            FIND FIRST movto-estoq NO-LOCK
                 WHERE movto-estoq.serie-docto  = docum-est.serie-docto
                   AND movto-estoq.nro-docto    = docum-est.nro-docto
                   AND movto-estoq.cod-emitente = docum-est.cod-emitente
                   AND movto-estoq.nat-operacao = docum-est.nat-operacao 
                   AND movto-estoq.numero-ordem = ordem-compra.numero-ordem
                   AND movto-estoq.it-codigo    = item-doc-est.it-codigo
                   AND movto-estoq.dt-trans     = docum-est.dt-trans
                   AND movto-estoq.tipo-trans   = 1
                   AND movto-estoq.esp-docto    = 21 NO-ERROR.
            IF AVAIL movto-estoq THEN DO:
                ASSIGN de-valor-mat = movto-estoq.valor-mat-m[1]
                       de-qtde      = item-doc-est.quantidade.
            END.
        END.

        find moeda where moeda.mo-codigo = ordem-compra.mo-codigo no-lock no-error. 
        if avail moeda then
            assign tt-desp.moeda = moeda.descricao.
        ELSE
            assign tt-desp.moeda = STRING(ordem-compra.mo-codigo).
    END.
    
    IF NOT AVAIL ordem-compra OR tt-desp.custo = 0 OR tt-desp.custo = ? THEN DO:
        FIND FIRST movto-estoq NO-LOCK 
             WHERE movto-estoq.serie-docto  = docum-est.serie-docto
               AND movto-estoq.nro-docto    = docum-est.nro-docto
               AND movto-estoq.cod-emitente = docum-est.cod-emitente
               AND movto-estoq.nat-operacao = docum-est.nat-operacao 
               AND movto-estoq.dt-trans     = docum-est.dt-trans
               AND movto-estoq.it-codigo    = item-doc-est.it-codigo
               AND movto-estoq.tipo-trans   = 1
               AND movto-estoq.esp-docto    = 21 
               AND movto-estoq.quantidade   = item-doc-est.quantidade NO-ERROR.
        IF AVAIL movto-estoq THEN DO:
            ASSIGN de-valor-mat = movto-estoq.valor-mat-m[1]
                   de-qtde      = item-doc-est.quantidade.
        END.
        ELSE DO:
            FIND FIRST movto-estoq NO-LOCK
                 WHERE movto-estoq.serie-docto  = docum-est.serie-docto
                   AND movto-estoq.nro-docto    = docum-est.nro-docto
                   AND movto-estoq.cod-emitente = docum-est.cod-emitente
                   AND movto-estoq.nat-operacao = docum-est.nat-operacao 
                   AND movto-estoq.it-codigo    = item-doc-est.it-codigo
                   AND movto-estoq.dt-trans     = docum-est.dt-trans
                   AND movto-estoq.tipo-trans   = 1
                   AND movto-estoq.esp-docto    = 21 NO-ERROR.
            IF AVAIL movto-estoq THEN DO:
                ASSIGN de-valor-mat = movto-estoq.valor-mat-m[1]
                       de-qtde      = item-doc-est.quantidade.
            END.
        END.
    END.

    for each item-doc-est-cex of item-doc-est no-lock:
        FOR FIRST desp-imp NO-LOCK
            WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp:
            IF desp-imp.log-2 /*incide base imposto importacao*/ THEN
                ASSIGN tt-desp.base-importacao = tt-desp.base-importacao + item-doc-est-cex.val-desp.
        END.
        IF AVAIL desp-imp THEN DO:
            IF desp-imp.gera-custo THEN  do: /* ver se devo considerar apenas as despesas que geram custo ao item */
                assign tt-desp.val-desp-total = tt-desp.val-desp-total + item-doc-est-cex.val-desp.
    
                IF item-doc-est-cex.cod-desp = 1 THEN
                    ASSIGN tt-desp.val-importacao = tt-desp.val-importacao + item-doc-est-cex.val-desp.
                ELSE IF item-doc-est-cex.cod-desp = 3 OR item-doc-est-cex.cod-desp = 27 OR item-doc-est-cex.cod-desp = 93 THEN
                    ASSIGN tt-desp.val-frete = tt-desp.val-frete + item-doc-est-cex.val-desp.
                ELSE IF item-doc-est-cex.cod-desp = 22 THEN
                    ASSIGN tt-desp.val-seguro = tt-desp.val-seguro + item-doc-est-cex.val-desp.
                ELSE IF item-doc-est-cex.cod-desp = 32 THEN
                    ASSIGN tt-desp.val-handling = tt-desp.val-handling + item-doc-est-cex.val-desp.
            END.
            ELSE DO:
                ASSIGN de-valor-mat = de-valor-mat - item-doc-est-cex.val-desp.
            END.
        END.
    end.
    ASSIGN tt-desp.val-frete  = tt-desp.val-frete  / de-qtde
           tt-desp.val-seguro = tt-desp.val-seguro / de-qtde.
           

    IF de-valor-mat > 0 THEN DO:
        ASSIGN tt-desp.custo = de-valor-mat / de-qtde.
    END.

    IF tt-desp.custo = ? THEN
        ASSIGN tt-desp.custo = 0.

    ASSIGN tt-desp.fator-internacao = (tt-desp.preco-total + tt-desp.val-desp-total) / tt-desp.preco-total.

    IF tt-desp.aliq-importacao = ? THEN
        ASSIGN tt-desp.aliq-importacao = 0.

    IF tt-desp.fator-internacao = ? THEN
        ASSIGN tt-desp.fator-internacao = 0.

    FIND FIRST unid-neg-fam-com NO-LOCK
         WHERE unid-neg-fam-com.fm-codigo = ITEM.fm-cod-com NO-ERROR.
    IF AVAIL unid-neg-fam-com THEN 
        ASSIGN tt-desp.unid-neg = unid-neg-fam-com.cod_unid_negoc.

    ASSIGN tt-desp.base-importacao = tt-desp.base-importacao + tt-desp.preco-total
           tt-desp.aliq-importacao = tt-desp.val-importacao / tt-desp.base-importacao * 100
           tt-desp.val-desp-out    = tt-desp.val-desp-total - tt-desp.val-importacao - tt-desp.val-frete - tt-desp.val-seguro - tt-desp.val-handling
           tt-desp.cotacao         = IF tt-desp.preco-unit-oc = 0 THEN 0 ELSE tt-desp.preco-unit / tt-desp.preco-unit-oc.

    FIND FIRST embarque-imp NO-LOCK
         WHERE embarque-imp.cod-estabel = docum-est.cod-estabel
           AND embarque-imp.embarque    = SUBSTRING(docum-est.char-1,1,12) NO-ERROR.
    IF AVAIL embarque-imp THEN DO:
        ASSIGN tt-desp.via-transp = /*string(embarque-imp.cod-via-transp)*/ {adinc/i01ad268.i 04 embarque-imp.cod-via-transp}
               tt-desp.origem     = emitente.pais + " - " + embarque-imp.cod-conhecto-master
               tt-desp.embarque   = embarque-imp.embarque
               tt-desp.di         = embarque-imp.declaracao-imp.
    END.

    ASSIGN dt-ini = DATE(MONTH(docum-est.dt-trans),01,YEAR(docum-est.dt-trans)).
    IF MONTH(docum-est.dt-trans) = 12 THEN
        ASSIGN dt-fim = DATE(12,31,YEAR(docum-est.dt-trans)).
    ELSE
        ASSIGN dt-fim = DATE(MONTH(docum-est.dt-trans) + 1,1,YEAR(docum-est.dt-trans)) - 1.

    FIND FIRST tt-consumo NO-LOCK
         WHERE tt-consumo.it-codigo = tt-desp.it-codigo 
           AND tt-consumo.data-fim  = dt-fim NO-ERROR.
    IF NOT AVAIL tt-consumo THEN DO:
        ASSIGN de-consumo = 0.
        DO dt-data = dt-ini TO dt-fim:
            FOR EACH movto-estoq NO-LOCK
               WHERE movto-estoq.it-codigo   = tt-desp.it-codigo
                 AND movto-estoq.cod-estabel = docum-est.cod-estabel
                 AND movto-estoq.dt-trans    = dt-data:

                IF  movto-estoq.esp-docto = 33 OR movto-estoq.esp-docto = 21 THEN NEXT.

                IF movto-estoq.tipo-trans = 2 THEN
                    ASSIGN de-consumo = de-consumo + movto-estoq.quantidade.
                ELSE 
                    ASSIGN de-consumo = de-consumo - movto-estoq.quantidade.
            END.
        END.

        FIND FIRST tt-consumo NO-LOCK
             WHERE tt-consumo.it-codigo = tt-desp.it-codigo 
               AND tt-consumo.data-fim  = dt-fim NO-ERROR.
        IF NOT AVAIL tt-consumo THEN DO:
            CREATE tt-consumo.
            ASSIGN tt-consumo.it-codigo = tt-desp.it-codigo 
                   tt-consumo.data-fim  = dt-fim
                   tt-consumo.consumo   = IF de-consumo < 0 THEN 0 ELSE de-consumo.
        END.
    END.
    ASSIGN tt-desp.cons-mensal = tt-consumo.consumo.

    FIND FIRST tt-saldo NO-LOCK
         WHERE tt-saldo.it-codigo = tt-desp.it-codigo 
           AND tt-saldo.data-fim  = dt-ini - 1 NO-ERROR.
    IF NOT AVAIL tt-saldo THEN DO:
        ASSIGN de-saldo          = 0
               de-saldo-mes      = 0
               de-custo-anterior = 0
               de-custo-mes      = 0.

        FOR EACH sl-it-per NO-LOCK
           WHERE sl-it-per.it-codigo   = tt-desp.it-codigo
             AND sl-it-per.cod-estabel = docum-est.cod-estabel
             AND sl-it-per.periodo     = dt-ini - 1:
        
            ASSIGN de-saldo = de-saldo + sl-it-per.quantidade.
        END.

        FOR EACH sl-it-per NO-LOCK
           WHERE sl-it-per.it-codigo   = tt-desp.it-codigo
             AND sl-it-per.cod-estabel = docum-est.cod-estabel
             AND sl-it-per.periodo     = dt-fim:
        
            ASSIGN de-saldo-mes = de-saldo-mes + sl-it-per.quantidade.
        END.

        IF CAN-FIND(FIRST pr-it-per NO-LOCK
                    WHERE pr-it-per.it-codigo   = tt-desp.it-codigo
                      AND pr-it-per.cod-estabel = docum-est.cod-estabel
                       AND pr-it-per.periodo     = dt-ini - 1) THEN DO:
            FOR EACH pr-it-per NO-LOCK
               WHERE pr-it-per.it-codigo   = tt-desp.it-codigo
                 AND pr-it-per.cod-estabel = docum-est.cod-estabel
                 AND pr-it-per.periodo     = dt-ini - 1:

                ASSIGN de-custo-anterior = de-custo-anterior + pr-it-per.val-unit-mat-m[1].
            END.
        END.
        ELSE DO:
            FIND LAST pr-it-per NO-LOCK
                WHERE pr-it-per.it-codigo   = tt-desp.it-codigo
                  AND pr-it-per.cod-estabel = docum-est.cod-estabel
                  AND pr-it-per.periodo     <= dt-ini - 1 NO-ERROR.
            IF AVAIL pr-it-per THEN DO:
                ASSIGN dt-custo = pr-it-per.periodo.

                FOR EACH pr-it-per NO-LOCK
                   WHERE pr-it-per.it-codigo   = tt-desp.it-codigo
                     AND pr-it-per.cod-estabel = docum-est.cod-estabel
                     AND pr-it-per.periodo     = dt-custo:

                    ASSIGN de-custo-anterior = de-custo-anterior + pr-it-per.val-unit-mat-m[1].
                END.
            END.
            
        END.

        FOR EACH pr-it-per NO-LOCK
           WHERE pr-it-per.it-codigo   = tt-desp.it-codigo
             AND pr-it-per.cod-estabel = docum-est.cod-estabel
             AND pr-it-per.periodo     = dt-fim:
        
            ASSIGN de-custo-mes = de-custo-mes + pr-it-per.val-unit-mat-m[1].
        END.

        FIND FIRST tt-saldo NO-LOCK
             WHERE tt-saldo.it-codigo = tt-desp.it-codigo 
               AND tt-saldo.data-fim  = dt-ini - 1 NO-ERROR.
        IF NOT AVAIL tt-saldo THEN DO:
            CREATE tt-saldo.
            ASSIGN tt-saldo.it-codigo = tt-desp.it-codigo 
                   tt-saldo.data-fim  = dt-ini - 1
                   tt-saldo.saldo-inicial  = IF de-saldo          < 0 THEN 0 ELSE de-saldo
                   tt-saldo.saldo-mes      = IF de-saldo-mes      < 0 THEN 0 ELSE de-saldo-mes
                   tt-saldo.custo-anterior = IF de-custo-anterior < 0 THEN 0 ELSE de-custo-anterior
                   tt-saldo.custo-mes      = IF de-custo-mes      < 0 THEN 0 ELSE de-custo-mes.
        END.
    END.
    ASSIGN tt-desp.saldo-inicial  = tt-saldo.saldo-inicial
           tt-desp.saldo-mes      = tt-saldo.saldo-mes
           tt-desp.custo-anterior = tt-saldo.custo-anterior
           tt-desp.custo-mes      = tt-saldo.custo-mes
           tt-desp.dt-fim         = dt-fim.

    FOR EACH rat-docum NO-LOCK USE-INDEX nf-docto
       WHERE rat-docum.nf-serie  = docum-est.serie-docto
         AND rat-docum.nf-nro       = docum-est.nro-docto
         AND rat-docum.nf-emitente     = docum-est.cod-emitente
         AND rat-docum.nf-nat-oper  = docum-est.nat-oper:

        FIND FIRST b-docum-est USE-INDEX documento 
             WHERE b-docum-est.serie-docto = rat-docum.serie-docto 
               AND b-docum-est.nro-docto   = rat-docum.nro-docto   
               AND b-docum-est.cod-emitente = rat-docum.cod-emitente 
               AND b-docum-est.nat-operacao = rat-docum.nat-operacao NO-LOCK NO-ERROR.

        IF AVAIL b-docum-est THEN DO:
            FOR EACH b-item-doc-est OF b-docum-est
               WHERE b-item-doc-est.it-codigo = item-doc-est.it-codigo NO-LOCK:
        
                FIND FIRST movto-estoq NO-LOCK
                     WHERE movto-estoq.serie-docto  = b-docum-est.serie-docto
                       AND movto-estoq.nro-docto    = b-docum-est.nro-docto
                       AND movto-estoq.cod-emitente = b-docum-est.cod-emitente
                       AND movto-estoq.nat-operacao = b-docum-est.nat-operacao 
                       AND movto-estoq.it-codigo    = b-item-doc-est.it-codigo
                       AND movto-estoq.sequen-nf    = b-item-doc-est.sequencia
                       AND movto-estoq.dt-trans     = b-docum-est.dt-trans
                       AND movto-estoq.tipo-trans   = 1
                       AND movto-estoq.esp-docto    = 18 NO-ERROR.
                IF AVAIL movto-estoq THEN
                    ASSIGN tt-desp.val-nc = tt-desp.val-nc + movto-estoq.valor-mat-m[1].
            END.
        END.
    END.

    ASSIGN tt-desp.fator-internacao-total = (tt-desp.preco-total + tt-desp.val-desp-total + tt-desp.val-nc) / tt-desp.preco-total.

    IF tt-desp.moeda = "" THEN
        ASSIGN tt-desp.moeda = " ".
    IF tt-desp.unid-neg = "" THEN
        ASSIGN tt-desp.unid-neg = " ".
    IF tt-desp.embarque = "" THEN
        ASSIGN tt-desp.embarque = " ".
    IF tt-desp.di = "" THEN
        ASSIGN tt-desp.di = " ".
    IF tt-desp.origem = "" THEN
        ASSIGN tt-desp.origem = " ".

END PROCEDURE.

PROCEDURE pi-filtra-materias:

    FOR EACH tt-item:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = tt-item.it-codigo NO-ERROR.

        IF  NOT AVAIL ITEM THEN 
            DELETE tt-item.
    /* Conforme solicitaá∆o do Rodrigo Vanderlei: 
        > eliminar todos os itens que comeá∆o com "188" itens estes que comp‰em a estrutura mas n∆o devem ser considerados 
        > Eliminar os itens que possuem quantidade da estrutura = 0
    */
        ELSE
                IF item.codigo-orig <> 1 AND
                   item.codigo-orig <> 2 AND
                   item.codigo-orig <> 3 and
                   item.codigo-orig <> 8 THEN 
                   DELETE tt-item. /* N∆o devera considerar no relatorio */
    END.
END PROCEDURE.

PROCEDURE pi-busca-estrutura:
    DEFINE VARIABLE de-quantidade   AS DECIMAL     NO-UNDO.

    define var de-quant-usada like estrutura.quant-usada  FORMAT "->>>>,>>9.9999999999" NO-UNDO.
    define var de-quant-liquid like estrutura.quant-liquid  FORMAT "->>>>,>>9.9999999999" NO-UNDO.

   FOR FIRST ITEM WHERE ITEM.it-codigo = c-item-pai NO-LOCK:

        RUN pi-acompanhar IN h-acomp (INPUT "Lendo Estrutura - Item: " + ITEM.it-codigo).

        /*IF NOT CAN-FIND(FIRST ord-prod NO-LOCK
                        WHERE ord-prod.it-codigo   = ITEM.it-codigo
                          AND ord-prod.dt-inicio  >= dt-inicio
                          AND ord-prod.dt-termino <= dt-fim) THEN NEXT.*/

        ASSIGN c-refer = ITEM.cod-refer
               i-seq   = 1
               i-cont  = 1.

        find first tt-estrutura no-lock 
             where tt-estrutura.it-item  = item.it-codigo
               and tt-estrutura.seq-cont = 0 no-error.
        if not avail tt-estrutura then do:
           create tt-estrutura.
           assign tt-estrutura.it-item     = item.it-codigo
                  tt-estrutura.seq-cont    = 0
                  tt-estrutura.quant-usada = 1 /*de-quant-requis*/.
        end.

        ASSIGN de-quantidade = 1.

        for each estrutura of item no-lock,
             first b-item fields (it-codigo cod-estabel  tipo-con-est   desc-item   un)
             where b-item.it-codigo = estrutura.es-codigo no-lock:

            RUN pi-acompanhar IN h-acomp (INPUT "b-item.it-codigo: " + b-item.it-codigo).
            if ((estrutura.data-inicio  <= TODAY and
                estrutura.data-termino > TODAY)) and estrutura.cod-lista-compon = c-processo then do:

               &IF DEFINED (bf_man_sfc_lc) &THEN 
               assign de-quant-usada =  ((estrutura.qtd-compon / estrutura.qtd-item) * (estrutura.proporcao / 100)) * de-quantidade 
                      de-quant-liquid = de-quant-usada * (1 - (estrutura.fator-perda / 100)).  
               &ELSE
               assign de-quant-usada =  de-quantidade * estrutura.quant-usada *
                                        (estrutura.proporcao / 100)
                      de-quant-liquid = de-quantidade * estrutura.quant-usada *
                                        (estrutura.proporcao / 100) * (1 - (estrutura.fator-perda / 100)).            
               &ENDIF

               if b-item.tipo-con-est = 4 or 
                    item.tipo-con-est = 4 then do:

                    for first ref-estrut fields (it-codigo   cod-ref-it   es-codigo
                                                 sequencia   cod-ref-es)
                        where ref-estrut.it-codigo  = estrutura.it-codigo and  
                              ref-estrut.es-codigo  = estrutura.es-codigo and
                              ref-estrut.sequencia  = estrutura.sequencia no-lock: end.

                    if  not avail ref-estrut THEN DO:
                        assign l-refer-incluida = yes
                               c-refer-es       = ''.           
                    END.
                    else do:
                        IF item.tipo-con-est = 4 THEN DO:
                           for first ref-estrut fields (it-codigo   cod-ref-it   es-codigo
                                                     sequencia   cod-ref-es)
                                where ref-estrut.it-codigo  = estrutura.it-codigo and  
                                      ref-estrut.cod-ref-it = c-refer and  
                                      ref-estrut.es-codigo  = estrutura.es-codigo and
                                      ref-estrut.sequencia  = estrutura.sequencia no-lock: end.
                            if available ref-estrut then
                               assign c-refer-es       = ref-estrut.cod-ref-es
                                       l-refer-incluida = yes.
                            else DO:
                               assign l-refer-incluida = no.                         
                            END.
                        END.
                        ELSE DO:
                            assign l-refer-incluida = yes
                                   c-refer-es       = ''.                                   
                        END.
                    end.
               end.
               else
                   assign l-refer-incluida = yes
                          c-refer-es       = ''.
                    if c-processo <> "" then
                            assign l-refer-incluida = yes.
                   
               if l-refer-incluida then do: 
                  if estrutura.fantasma THEN
                     assign c-aux = '#'.
                  else
                     assign c-aux = ''.

                  if can-find (first alternativo 
                               where alternativo.es-codigo = estrutura.es-codigo
                                 and alternativo.it-codigo = estrutura.it-codigo
                                 and alternativo.sequencia = estrutura.sequencia no-lock) then
                     assign c-aux = c-aux +  c-alt.

                  if TODAY >= estrutura.data-termino or TODAY < data-inicio then
                     assign c-aux = c-aux +  '?'.

                  find first tt-estrutura no-lock 
                       where tt-estrutura.it-item   = item.it-codigo
                         and tt-estrutura.seq-cont = i-cont no-error.
                  if not avail tt-estrutura then do:
                     create tt-estrutura.
                     assign tt-estrutura.it-item   = item.it-codigo
                            tt-estrutura.seq-cont = i-cont.
                  end.
                  assign tt-estrutura.sequencia = estrutura.sequencia
                         tt-estrutura.it-codigo = estrutura.it-codigo
                         tt-estrutura.es-codigo = estrutura.es-codigo
                         &if defined (bf_man_sfc_lc) &then
                             tt-estrutura.cod-lista-compon = estrutura.cod-lista-compon
                         &endif
                         tt-estrutura.quant-usada = de-quant-usada
                         tt-estrutura.c-aux       = c-aux. 
                                                              
                  assign i-cont = i-cont + 1.

                  run pi-gera-estrutura-filho(buffer b-item, 
                                              c-refer-es, 
                                              de-quant-usada, 
                                              i-nivel,
                                              i-cont - 1).
               end.
            end.  
         end.
    END.

    FOR EACH tt-estrutura NO-LOCK
        BREAK BY tt-estrutura.es-codigo:
        IF INDEX(tt-estrutura.c-aux,"#") <> 0 THEN do:
           
            NEXT.
        END.
                  
        IF FIRST-OF(tt-estrutura.es-codigo) 
        THEN DO:
            IF  tt-estrutura.es-codigo = ""
            THEN DO:
               IF CAN-FIND(FIRST estrutura 
                    WHERE estrutura.it-codigo = tt-estrutura.it-codigo) THEN NEXT.
                CREATE tt-item.
                ASSIGN tt-item.it-codigo = tt-estrutura.it-codigo.
                       
            END.
            ELSE DO:
                IF CAN-FIND(FIRST estrutura 
                     WHERE estrutura.it-codigo = tt-estrutura.es-codigo) THEN NEXT.

                CREATE tt-item.
                ASSIGN tt-item.it-codigo = tt-estrutura.es-codigo.
    
                FOR EACH b-tt-estrutura NO-LOCK
                   WHERE b-tt-estrutura.es-codigo = tt-estrutura.es-codigo:
                    ASSIGN tt-item.qt-estrut = tt-item.qt-estrut + b-tt-estrutura.quant-usada.
                END.
            END.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-gera-estrutura-filho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define parameter buffer b1-item for item.
    define input parameter p-refer as char no-undo.
    define input parameter p-quantidade as decimal no-undo.
    define input parameter p-nivel as integer no-undo.
    define input parameter p-pai   as integer no-undo.
    
    define buffer b2-item for item.
    define buffer b-estrutura for estrutura.
    define var de-quant-usada like estrutura.quant-usada  FORMAT "->>>>,>>9.9999999999" NO-UNDO.
    define var de-quant-liquid like estrutura.quant-liquid  FORMAT "->>>>,>>9.9999999999" NO-UNDO.
    define var i as integer.
    
    assign p-nivel = p-nivel + 1.
    
    if p-nivel > c-controle-nivel then
       assign c-controle-nivel = p-nivel.
    
    RUN pi-acompanhar IN h-acomp (INPUT "Gerando itens filhos...").
    for each b-estrutura of b1-item no-lock:
    
        RUN pi-acompanhar IN h-acomp (INPUT "Gerando itens filhos: " + b-estrutura.it-codigo).
        if (b-estrutura.data-inicio  <= TODAY and
            b-estrutura.data-termino >  TODAY) then do:
    
            for first b2-item fields (it-codigo cod-estabel  tipo-con-est   desc-item   un)
                where b2-item.it-codigo = b-estrutura.es-codigo no-lock: end.
    
            &IF DEFINED (bf_man_sfc_lc) &THEN
            assign de-quant-usada =  ((b-estrutura.qtd-compon / b-estrutura.qtd-item) * (b-estrutura.proporcao / 100)) * p-quantidade 
                   de-quant-liquid = de-quant-usada * (1 - (b-estrutura.fator-perda / 100)).
            &ELSE
            assign de-quant-usada =  p-quantidade * b-estrutura.quant-usada *
                                    (b-estrutura.proporcao / 100)
                   de-quant-liquid = p-quantidade * b-estrutura.quant-usada *
                                    (b-estrutura.proporcao / 100) * (1 - (b-estrutura.fator-perda / 100)).
            &ENDIF
            
            &IF DEFINED (bf_man_206b) &THEN
                IF l-usa-unid-negoc THEN DO:
                    RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT  b2-item.cod-estabel,
                                                             INPUT  b2-item.it-codigo,
                                                             INPUT  "",
                                                             OUTPUT c-unid-retornada).
                ASSIGN c-retornado = c-unid-retornada.
            END.
            &ENDIF
            
            if b2-item.tipo-con-est = 4 or 
              b1-item.tipo-con-est = 4 then do:
    
                 for first ref-estrut fields (it-codigo   cod-ref-it  es-codigo
                                               sequencia   cod-ref-es)
                      where ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                            ref-estrut.es-codigo  = b-estrutura.es-codigo and
                            ref-estrut.sequencia  = b-estrutura.sequencia no-lock: end.
    
                 if not avail ref-estrut then
                    assign l-refer-incluida = yes
                           /*c-refer-es       = ''*/.
                 else do:
                    IF b1-item.tipo-con-est = 4 THEN DO:
                         for first ref-estrut fields (it-codigo   cod-ref-it  es-codigo
                                                       sequencia   cod-ref-es)
                              where ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                                    ref-estrut.cod-ref-it = p-refer and  
                                    ref-estrut.es-codigo  = b-estrutura.es-codigo and
                                    ref-estrut.sequencia  = b-estrutura.sequencia no-lock: end.
        
                         if available ref-estrut then
                              assign c-refer-es       = ref-estrut.cod-ref-es
                                     l-refer-incluida = yes.
                         else DO:              
                              assign l-refer-incluida = no.                    
    
                         END.
                    END.
                    ELSE DO:
                         assign /*c-refer-es       = ''*/
                                l-refer-incluida = yes.
                    END.
                 end.         
            end.
            else
                assign l-refer-incluida = yes
                       /*c-refer-es       = ''*/.

           if l-refer-incluida then do:
               if b-estrutura.fantasma then 
                  assign c-aux = '#'.
               else
                   assign c-aux = ''.
               if can-find (first alternativo 
                            where alternativo.es-codigo = b-estrutura.es-codigo
                              and alternativo.it-codigo = b-estrutura.it-codigo
                              and alternativo.sequencia = b-estrutura.sequencia no-lock) then
                  assign c-aux = c-aux +  c-alt.
    
               if TODAY >= b-estrutura.data-termino or TODAY < b-estrutura.data-inicio then
                  assign c-aux = c-aux +  '?'.  
    
               find first tt-estrutura no-lock 
                    where tt-estrutura.it-item   = item.it-codigo
                      and tt-estrutura.seq-cont = i-cont no-error.
               if not avail tt-estrutura then do:
                  create tt-estrutura.
                  assign tt-estrutura.seq-cont = i-cont
                         tt-estrutura.it-item   = item.it-codigo.
               end.
               assign tt-estrutura.sequencia = b-estrutura.sequencia
                      tt-estrutura.it-codigo = b-estrutura.it-codigo
                      tt-estrutura.es-codigo = b-estrutura.es-codigo
                      &if defined (bf_man_sfc_lc) &then
                          tt-estrutura.cod-lista-compon = b-estrutura.cod-lista-compon
                      &endif
                      tt-estrutura.quant-usada = de-quant-usada
                      tt-estrutura.c-aux       = c-aux.

               assign i-cont = i-cont + 1.
    
               run pi-gera-estrutura-filho(buffer b2-item, 
                                           c-refer-es, 
                                           de-quant-usada, 
                                           p-nivel,
                                           i-cont - 1).
           end.
        end.
    end.
END PROCEDURE.

/**** Fim do programa ****/
