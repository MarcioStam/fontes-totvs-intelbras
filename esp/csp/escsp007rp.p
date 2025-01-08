/***********************************************************************
**  Programa..: ESP\CSP\ESCSP007RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: AGOSTO/2008 - Desenvolvimento
**  Descricao.: Acompanhamento Entradas Produtos
**  Vers∆o....: 001 21/08/2009
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCSP007RP 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/csp/escsp007tt.i}
{esp/es0018.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
def temp-table tt-desp      no-undo
    FIELD cod-estabel       LIKE docum-est.cod-estabel
    field it-codigo         like item.it-codigo             format "x(7)"
    FIELD desc-item         AS CHARACTER                    FORMAT "x(40)"
    field dt-fim            as date
    field dt-trans          as date
    FIELD dt-emis           AS DATE
    field nro-docto         like docum-est.nro-docto        format "x(7)"
    field serie-docto       like docum-est.serie-docto
    FIELD nat-operacao      LIKE docum-est.nat-operacao  
    FIELD cod-emitente      LIKE emitente.cod-emitente
    FIELD nome-emit         LIKE emitente.nome-emit
    FIELD unid-neg          AS CHARACTER format "x(40)"
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
    FIELD val-base-icms-nota     LIKE it-doc-fisc.vl-icmsou-it
    FIELD val-base-icms-calc     LIKE it-doc-fisc.vl-icmsou-it
    FIELD cod-tributac      LIKE dwf-docto-item-impto.cod-tributac
    FIELD val-desp-THC      LIKE item-doc-est-cex.val-desp
    field cod-produto-ckd   like int-pedido-compr.cod-produto-ckd
    field base-cofins       like item-doc-est.val-base-calc-cofins
    field aliq-cofins       like item-doc-est.val-aliq-cofins
    field de-tot-cof        like item-doc-est.val-cofins
    FIELD cod-comprado      LIKE ordem-compra.cod-comprado
    FIELD cod-tributac-nfe  LIKE dwf-docto-item-impto.cod-tributac
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
    INDEX chave it-codigo.

DEFINE TEMP-TABLE tt-excessao-nat NO-UNDO
    FIELD nat-operacao AS CHARACTER
    INDEX chave nat-operacao.

DEFINE TEMP-TABLE tt-nat-descons NO-UNDO
    FIELD nat-operacao AS CHARACTER
    INDEX chave nat-operacao.

/****************************  Variaveis    ****************************/
/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

DEFINE BUFFER b-item FOR ITEM.
DEFINE BUFFER b-tt-estrutura FOR tt-estrutura.

DEFINE BUFFER b-docum-est    FOR docum-est.
DEFINE BUFFER b-item-doc-est FOR item-doc-est.
create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

DEFINE VARIABLE dt-data AS DATE  NO-UNDO.
DEFINE VARIABLE dt-ini  AS DATE  NO-UNDO.
DEFINE VARIABLE dt-fim  AS DATE  NO-UNDO.
DEFINE VARIABLE de-consumo    AS DECIMAL  NO-UNDO.
DEFINE VARIABLE de-saldo      AS DECIMAL  NO-UNDO.
DEFINE VARIABLE de-saldo-mes       AS DECIMAL  NO-UNDO.
DEFINE VARIABLE de-custo-anterior  AS DECIMAL  NO-UNDO.
DEFINE VARIABLE de-custo-mes       AS DECIMAL  NO-UNDO.

DEFINE VARIABLE i-seq            AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont           AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-refer-incluida AS LOGICAL NO-UNDO INITIAL NO.
DEFINE VARIABLE c-refer-es       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-refer          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-aux            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-alt            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-nivel          AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-processo       AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE c-controle-nivel AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-numero-ordem AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-cod-estabel-aux LIKE estabelec.cod-estabel NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Acompanhamento Entradas Produtos"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCSP007"
       c-versao       = "2.04"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */

FOR EACH tt-desp:
    DELETE tt-desp.
END.

FOR EACH tt-consumo:
    DELETE tt-consumo.
END.

FOR EACH tt-saldo:
    DELETE tt-saldo.
END.

FOR EACH tt-estrutura:
    DELETE tt-estrutura.
END.

FOR EACH tt-item:
    DELETE tt-item.
END.

do on stop undo, leave:

   {include/i-rpout.i &pagesize="0"}

   run utp/ut-acomp.p persistent set h-acomp.  

   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.

   
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.




/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat:
    DEFINE VARIABLE de-custo-medio  AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-custo-total  AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-preco-total  AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-custo-total-cif AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-quantidade     AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-val-frete    AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-val-peso     AS DECIMAL  NO-UNDO.

    DEFINE VARIABLE l-escsp013 AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-usuarios AS CHARACTER   NO-UNDO.

    FIND FIRST tt-param.

    EMPTY TEMP-TABLE tt-excessao-nat NO-ERROR.
    EMPTY TEMP-TABLE tt-nat-descons  NO-ERROR.

    /*---[ Exceá‰es de naturezas ]-----------------------------------------------*/
    EMPTY TEMP-TABLE tt-prog-ponto NO-ERROR.
    RUN esp/es0018p.p (INPUT "escsp007rp",
                       INPUT 1,
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).
    
    IF  CAN-FIND(FIRST tt-prog-ponto NO-LOCK) THEN DO:
        FOR EACH tt-prog-ponto:
            CREATE tt-excessao-nat.
            ASSIGN tt-excessao-nat.nat-operacao = tt-prog-ponto.conteudo.
        END. /* FOR EACH tt-prog-ponto: */
    END. /* IF  CAN-FIND(FIRST tt-prog-ponto NO-LOCK) THEN DO: */


    /* escsp013 - Usu†rios com permiss∆o  */
    EMPTY TEMP-TABLE tt-prog-ponto NO-ERROR.
    RUN esp/es0018p.p (INPUT "escsp013",
                       INPUT 1,
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).
    
    ASSIGN c-usuarios = "".

    FOR EACH tt-prog-ponto NO-LOCK:

        ASSIGN c-usuarios = c-usuarios + tt-prog-ponto.conteudo + ",".

    END.

    ASSIGN c-usuarios = SUBSTRING(c-usuarios, 1, LENGTH(c-usuarios) - 1)
           l-escsp013 = FALSE.

    IF LOOKUP(v_cod_usuar_corren, c-usuarios) <> 0 AND
       tt-param.prog-chamador = 'escsp013' THEN
        ASSIGN l-escsp013 = TRUE.

    /*---[ Naturezas que ser∆o desconsideradas no processo ]---------------------*/
    EMPTY TEMP-TABLE tt-prog-ponto NO-ERROR.
    RUN esp/es0018p.p (INPUT "escsp007rp",
                       INPUT 2,
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).
    
    IF  CAN-FIND(FIRST tt-prog-ponto NO-LOCK) THEN DO:
        FOR EACH tt-prog-ponto:
            CREATE tt-nat-descons.
            ASSIGN tt-nat-descons.nat-operacao = tt-prog-ponto.conteudo.
        END. /* FOR EACH tt-prog-ponto: */
    END. /* IF  CAN-FIND(FIRST tt-prog-ponto NO-LOCK) THEN DO: */

    
    IF  tt-param.l-estrutura THEN DO:
        RUN pi-busca-estrutura.
        /*RUN pi-filtra-materias.*/

        FOR EACH docum-est use-index est-origem no-lock  
           WHERE docum-est.cod-estabel >= tt-param.cod-estabel-ini
             AND docum-est.cod-estabel <= tt-param.cod-estabel-fim
             AND docum-est.dt-trans    >= tt-param.data-ini
             AND docum-est.dt-trans    <= tt-param.data-fim,
           FIRST natur-oper NO-LOCK
           WHERE natur-oper.nat-operacao = docum-est.nat-operacao,
           FIRST emitente NO-LOCK
           WHERE emitente.cod-emitente = docum-est.cod-emitente,
            EACH item-doc-est of docum-est NO-LOCK
           WHERE item-doc-est.it-codigo <> "",
           FIRST tt-item NO-LOCK
           WHERE tt-item.it-codigo = item-doc-est.it-codigo,
           FIRST item no-lock
           WHERE item.it-codigo    = item-doc-est.it-codigo
              BY item-doc-est.data DESCENDING:

            /*Quando marcado £ltima entrada s¢ cria uma linha pro item*/
            IF CAN-FIND(FIRST tt-desp NO-LOCK
                        WHERE tt-desp.it-codigo = tt-item.it-codigo) 
            AND tt-param.l-ultima-entrada THEN DO:
                NEXT.
            END.
            
            IF CAN-FIND(FIRST tt-nat-descons NO-LOCK 
                        WHERE tt-nat-descons.nat-operacao = natur-oper.nat-operacao) THEN NEXT.
            
            IF  NOT CAN-FIND(FIRST tt-excessao-nat NO-LOCK 
                             WHERE tt-excessao-nat.nat-operacao = natur-oper.nat-operacao) THEN DO:
                IF NOT natur-oper.emite-duplic OR natur-oper.tipo-compra <> 1 THEN NEXT.
            END. /* IF  NOT CAN-FIND(FIRST tt-excessao-nat */

            RUN pi-acompanhar IN h-acomp ("Data: " + STRING(docum-est.dt-trans,"99/99/99") + " - NF: " + trim(docum-est.nro-docto) + " - Item: " + TRIM(item-doc-est.it-codigo)).

            RUN pi-carrega-tt.
        END. /* FOR EACH  docum-est use-index ... */
    END. /* IF  tt-param.l-estrutura THEN DO: */
    ELSE DO:
        RUN pi-busca-itens.
        /*RUN pi-filtra-materias.*/

        DEF VAR i-cont-acomp AS INTEGER NO-UNDO.

        FOR EACH tt-item NO-LOCK,
            FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-item.it-codigo,
            EACH  item-doc-est NO-LOCK
            WHERE item-doc-est.it-codigo = tt-item.it-codigo,
            FIRST docum-est OF item-doc-est NO-LOCK
            WHERE docum-est.cod-estabel >= tt-param.cod-estabel-ini
            AND   docum-est.cod-estabel <= tt-param.cod-estabel-fim
            AND   docum-est.dt-trans    >= tt-param.data-ini
            AND   docum-est.dt-trans    <= tt-param.data-fim,
            FIRST natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = docum-est.nat-operacao,
            FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = docum-est.cod-emitente
               BY item-doc-est.data DESCENDING:
/*         FOR EACH estabelec NO-LOCK                                         */
/*             WHERE estabelec.cod-estabel >= tt-param.cod-estabel-ini        */
/*               AND estabelec.cod-estabel <= tt-param.cod-estabel-fim        */
/*             ,EACH docum-est NO-LOCK                                        */
/*                 WHERE docum-est.cod-estabel  = estabelec.cod-estabel       */
/*                   AND docum-est.dt-trans    >= tt-param.data-ini           */
/*                   AND docum-est.dt-trans    <= tt-param.data-fim           */
/*                 ,FIRST natur-oper NO-LOCK                                  */
/*                     WHERE natur-oper.nat-operacao = docum-est.nat-operacao */
/*                 ,FIRST emitente NO-LOCK                                    */
/*                     WHERE emitente.cod-emitente = docum-est.cod-emitente   */
/*                 ,EACH item-doc-est NO-LOCK OF docum-est                    */
/*                 ,FIRST ITEM NO-LOCK                                        */
/*                      WHERE ITEM.it-codigo = item-doc-est.it-codigo         */
/*                 ,FIRST tt-item                                             */
/*                     WHERE tt-item.it-codigo = item-doc-est.it-codigo       */
/*                     BY item-doc-est.data DESCENDING:                       */

            ASSIGN i-cont-acomp = i-cont-acomp + 1.
            /*Quando marcado ultima entrada s¢ cria uma linha pro item*/
            IF CAN-FIND(FIRST tt-desp NO-LOCK
                        WHERE tt-desp.it-codigo = tt-item.it-codigo) 
            AND tt-param.l-ultima-entrada THEN DO:
                NEXT.
            END.
            
            IF CAN-FIND(FIRST tt-nat-descons NO-LOCK 
                        WHERE tt-nat-descons.nat-operacao = natur-oper.nat-operacao) THEN NEXT.
             
            IF NOT CAN-FIND(FIRST tt-excessao-nat NO-LOCK 
                            WHERE tt-excessao-nat.nat-operacao = natur-oper.nat-operacao) THEN DO:
                IF NOT natur-oper.emite-duplic OR natur-oper.tipo-compra <> 1 THEN NEXT.
            END. /* IF NOT CAN-FIND(FIRST tt-excessao-nat NO-LOCK */

            IF  i-cont-acomp > 1000 THEN DO:
                RUN pi-acompanhar IN h-acomp ("Item: " + TRIM(item-doc-est.it-codigo) + " - Data: " + STRING(docum-est.dt-trans,"99/99/99") + " - NF: " + trim(docum-est.nro-docto)).
                ASSIGN i-cont-acomp = 0.
            END.
            
            RUN pi-carrega-tt.
        END. /* FOR EACH tt-item NO-LOCK, */
    END. /* ELSE DO: */

    IF  tt-param.l-ultima-entrada THEN DO:
        /* busca ultima entrada - caso n∆o tenha encontrado entrada no periodo */

        FOR EACH tt-item NO-LOCK,
            FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-item.it-codigo:
            IF  NOT CAN-FIND(FIRST tt-desp NO-LOCK
                             WHERE tt-desp.it-codigo = tt-item.it-codigo) THEN DO:
                FOR EACH  item-doc-est NO-LOCK
                    WHERE item-doc-est.it-codigo = tt-item.it-codigo,
                    FIRST docum-est OF item-doc-est NO-LOCK
                    WHERE docum-est.cod-estabel >= tt-param.cod-estabel-ini
                    AND   docum-est.cod-estabel <= tt-param.cod-estabel-fim
                    AND   docum-est.dt-trans    <= tt-param.data-ini,
                    FIRST natur-oper NO-LOCK
                    WHERE natur-oper.nat-operacao = docum-est.nat-operacao,
                    FIRST emitente NO-LOCK
                    WHERE emitente.cod-emitente = docum-est.cod-emitente
                    BY item-doc-est.data DESCENDING:
                    
                    IF CAN-FIND(FIRST tt-nat-descons NO-LOCK 
                                WHERE tt-nat-descons.nat-operacao = natur-oper.nat-operacao) THEN NEXT.

                    IF NOT CAN-FIND(FIRST tt-excessao-nat NO-LOCK 
                                    WHERE tt-excessao-nat.nat-operacao = natur-oper.nat-operacao) THEN DO:
                        IF NOT natur-oper.emite-duplic OR natur-oper.tipo-compra <> 1 THEN NEXT.
                    END.

                    RUN pi-acompanhar IN h-acomp ("Item: " + TRIM(item-doc-est.it-codigo) + " - Data: " + STRING(docum-est.dt-trans,"99/99/99") + " - NF: " + trim(docum-est.nro-docto)).

                    RUN pi-carrega-tt.


                    LEAVE.
                END. /* FOR EACH  item-doc-est NO-LOCK */
            END. /* IF  NOT CAN-FIND(FIRST tt-desp NO-LOCK */
        END. /* FOR EACH tt-item NO-LOCK, */
    END. /* IF  tt-param.l-ultima-entrada THEN DO: */

    IF l-escsp013 THEN
        PUT "Estab;Item;Descriá∆o;Transaá∆o;Emiss∆o;Un Neg;CIF;CIF Total;FOB;FOB Total;Transporte;Qtd;Qtd. Forn;Cotaá∆o;Moeda;NFE;Ser;Nat;Emitente;Nome;DI;Pedido;Embarque;Cod Prod CKD; Comprador da OC;".
    ELSE
        PUT "Estab;Item;Descriá∆o;Transaá∆o;Emiss∆o;Un Neg;Custo Ant;Custo Mes;CIF;CIF Total;FOB;FOB Total;FI;FI Total;Transporte;Qtd;Qtd. Forn;Qtd. Estrut.;Saldo Ini;Saldo Mes;Cons.Mensal;UN;P.U. OC;Cotaá∆o;Moeda;Base II;Aliq. II;II;Frete;Seguro;Handling;Outras Desp;Total Desp.;VL.NF.COMP.;Peso liq;NCM;NFE;Ser;Nat;Emitente;Nome;DI;Pedido;Embarque;Ord. Comp.;Origem;Base ICMS Nota;Base ICMS Calc;CST;Base COFINS;Aliq ;Vlr COFINS;Cod Prod CKD; Comprador da OC;".

    IF  tt-param.l-listar-THC THEN 
        PUT "THC;Origem NFE".
    ELSE PUT "Origem NFE".

    PUT SKIP.

    for each tt-desp
        break by tt-desp.it-codigo
              by tt-desp.dt-fim
              by tt-desp.dt-trans:

        IF tt-param.l-calc-custo THEN DO:
            IF FIRST-OF(tt-desp.it-codigo) OR FIRST-OF(tt-desp.dt-fim) THEN
                ASSIGN de-custo-medio = 0
                       de-preco-total = 0
                       de-quantidade  = 0
                       de-custo-total = 0
                       de-val-frete   = 0
                       de-val-peso    = 0.


            ASSIGN de-preco-total = de-preco-total + tt-desp.preco-total
                   de-quantidade    = de-quantidade    + tt-desp.quantidade
                   de-custo-total = de-custo-total + (tt-desp.custo * tt-desp.quantidade)
                   de-val-frete   = de-val-frete   + tt-desp.val-frete
                   de-val-peso    = de-val-peso    + tt-desp.peso-liq .
        END.

        /*ASSIGN de-custo-total-cif = tt-desp.preco-unit * tt-desp.fator-internacao-total.*/ 
        ASSIGN de-custo-total-cif = tt-desp.custo * tt-desp.quantidade.      

        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuar = tt-desp.cod-comprado NO-ERROR.

        PUT UNFORMATTED
             tt-desp.cod-estabel                                                                  ";"
             tt-desp.it-codigo                                                                    ";"
             tt-desp.desc-item                                                                    ";"
             tt-desp.dt-trans                                                                     ";"
             tt-desp.dt-emis                                                                      ";"
             tt-desp.unid-neg                                                                     ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.custo-anterior, ">,>>>,>>9.99999999")   +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.custo-mes, ">,>>>,>>9.99999999")        +  ";"
             string(tt-desp.custo, ">,>>>,>>9.99999999")                                          ";"
             string(de-custo-total-cif, ">,>>>,>>9.99999999")                                     ";"
           //  tt-desp.preco-unit        FORMAT ">,>>>,>>9.9999"                                    ";" 
             tt-desp.preco-total / tt-desp.quantidade FORMAT ">,>>>,>>9.99999999"                 ";"
             tt-desp.preco-total       FORMAT ">,>>>,>>>,>>9.99"                                  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.fator-internacao)                       +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.fator-internacao-total)                 +  ";"
             tt-desp.via-transp        FORMAT "x(10)"                                             ";" 
             tt-desp.quantidade        FORMAT ">,>>>,>>>,>>9.99"                                  ";"
             tt-desp.qt-do-forn        FORMAT ">,>>>,>>>,>>9.99"                                  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.qt-estrut, ">,>>>,>>>,>>9.999999")      +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.saldo-inicial, ">,>>>,>>>,>>9.99")      +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.saldo-mes, ">,>>>,>>>,>>9.99")          +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.cons-mensal, ">,>>>,>>>,>>9.99")        +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.un)                                     +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.preco-unit-oc, ">,>>>,>>9.99999")       +  ";"
             tt-desp.cotacao           FORMAT ">>>,>>>,>>9.99999"                                 ";"
             tt-desp.moeda                                                                        ";" 
             IF l-escsp013 THEN "" ELSE string(tt-desp.base-importacao, ">,>>>,>>>,>>9.99")    +  ";" 
             IF l-escsp013 THEN "" ELSE string(tt-desp.aliq-importacao, ">>>>>9.99")           +  "%;" 
             IF l-escsp013 THEN "" ELSE string(tt-desp.val-importacao, ">,>>>,>>>,>>9.99")     +  ";" 
             IF l-escsp013 THEN "" ELSE string(tt-desp.val-frete, ">,>>>,>>>,>>9.99")          +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.val-seguro, ">,>>>,>>>,>>9.99")         +  ";" 
             IF l-escsp013 THEN "" ELSE string(tt-desp.val-handling, ">,>>>,>>>,>>9.99")       +  ";" 
             IF l-escsp013 THEN "" ELSE string(tt-desp.val-desp-out, "->,>>>,>>>,>>9.99")      +  ";" 
             IF l-escsp013 THEN "" ELSE string(tt-desp.val-desp-total, "->,>>>,>>>,>>9.99")    +  ";" 
             IF l-escsp013 THEN "" ELSE string(tt-desp.val-nc, ">,>>>,>>>,>>9.99")             +  " ;"
             IF l-escsp013 THEN "" ELSE string(tt-desp.peso-liq, ">,>>>,>>>,>>9.99")           +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.ncm, "x(10)")                           +  ";" 
             tt-desp.nro-docto                                                                    ";" 
             tt-desp.serie-docto                                                                  ";" 
             tt-desp.nat-operacao                                                                 ";" 
             tt-desp.cod-emitente                                                                 ";" 
             tt-desp.nome-emit                                                                    ";" 
             tt-desp.di                                                                           ";"
             tt-desp.num-pedido                                                                   ";" 
             tt-desp.embarque                                                                     ";" 
             IF l-escsp013 THEN "" ELSE string(tt-desp.numero-ordem)                           +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.origem)                                 +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.val-base-icms-nota)                     +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.val-base-icms-calc)                     +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.cod-tributac)                           +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.base-cofins)                            +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.aliq-cofins)                            +  ";"
             IF l-escsp013 THEN "" ELSE string(tt-desp.de-tot-cof )                            +  ";"
             tt-desp.cod-produto-ckd                                                              ";"
	         IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuar + ";" ELSE ""                   +  ";".

             
        IF  tt-param.l-listar-THC THEN 
            PUT UNFORMATTED STRING(tt-desp.val-desp-THC) + ";".
        
        PUT UNFORMATTED STRING(tt-desp.cod-tributac-nfe) + ";".

        PUT UNFORMATTED SKIP.  
            
        IF tt-param.l-calc-custo THEN DO:
            IF LAST-OF(tt-desp.it-codigo) OR LAST-OF(tt-desp.dt-fim) THEN DO:

                ASSIGN de-custo-medio = de-custo-total / de-quantidade.

                ASSIGN de-custo-total-cif = de-custo-medio + tt-desp.fator-internacao-total - tt-desp.fator-internacao.

                PUT UNFORMATTED skip
                 tt-desp.cod-estabel                                      ";"
                 tt-desp.it-codigo                                        ";"
                 tt-desp.desc-item                                        ";"
                 tt-desp.dt-trans                                         ";"
                 tt-desp.dt-emis                                          ";"
                                                                       "TOT;"
                 tt-desp.custo-anterior   FORMAT ">,>>>,>>9.9999"         ";" 
                 tt-desp.custo-mes        FORMAT ">,>>>,>>9.9999"         ";" 
                 de-custo-medio           FORMAT ">,>>>,>>9.9999"         ";"
                 de-custo-total-cif       FORMAT ">,>>>,>>9.9999"         ";"
                                                                          " ;"
                 de-preco-total           FORMAT ">,>>>,>>>,>>9.99"       ";"
                 tt-desp.fator-internacao                                 ";"
                 tt-desp.fator-internacao-total                           ";"
                 tt-desp.via-transp       FORMAT "x(10)"                  ";"
                 de-quantidade            FORMAT ">,>>>,>>>,>>9.99"       ";"
                 tt-desp.qt-estrut        FORMAT ">,>>>,>>>,>>9.999999"  ";"
                 tt-desp.saldo-inicial    FORMAT ">,>>>,>>>,>>9.99"       ";"
                 tt-desp.saldo-mes        FORMAT ">,>>>,>>>,>>9.99"       ";"
                 tt-desp.cons-mensal      format ">,>>>,>>>,>>9.99"       ";"
                                                                          " ;"
                 tt-desp.un                                               ";"
                 tt-desp.preco-unit-oc    FORMAT ">,>>>,>>9.99999"        ";"
                 tt-desp.cotacao          FORMAT ">>>,>>>,>>9.99999"          ";"
                 tt-desp.moeda                                            ";"
                                                                          " ;"                                            
                                                                          " ;"                                            
                                                                          " ;"
                 de-val-frete             FORMAT ">,>>>,>>>,>>9.99"       ";"
                                                                          " ;"
                                                                          " ;"
                                                                          " ;"
                                                                          " ;"
                 /*tt-desp.val-nc           FORMAT ">,>>>,>>>,>>9.99"*/   " ;"
                 de-val-peso              FORMAT ">,>>>,>>>,>>9.99"       ";"
                 tt-desp.ncm              FORMAT "x(10)"                  ";"
                                                                          ";"
                                                                          " ;"
                                                                          " ;"
                                                                          " ;"
                                                                          " ;"
                                                                          " ;"
                                                                          " ;"
                                                                          " ;"
                                                                          " ;".
                 PUT UNFORMATTED FILL(" ;",40) skip.
            END.           
        END.
        
                 
    END.

END PROCEDURE.

PROCEDURE pi-carrega-tt:
    DEFINE VARIABLE dt-custo AS DATE        NO-UNDO.

    DEF VAR de-valor-mat LIKE movto-estoq.valor-mat-m[1] NO-UNDO.
    DEF VAR de-qtde      LIKE movto-estoq.quantidade     NO-UNDO.

    create tt-desp.
    assign tt-desp.cod-estabel      = docum-est.cod-estabel
           tt-desp.it-codigo        = item-doc-est.it-codigo
           tt-desp.desc-item        = ITEM.desc-item
           tt-desp.dt-trans         = docum-est.dt-trans
           tt-desp.dt-emis          = docum-est.dt-emissao
           tt-desp.nro-docto        = docum-est.nro-docto
           tt-desp.serie-docto      = docum-est.serie-docto
           tt-desp.cod-emitente     = emitente.cod-emitente
           tt-desp.nome-emit        = emitente.nome-emit
           tt-desp.quantidade       = item-doc-est.quantidade
           tt-desp.qt-do-forn       = item-doc-est.qt-do-forn
           tt-desp.qt-estrut        = tt-item.qt-estrut
           tt-desp.un               = item-doc-est.un
           tt-desp.preco-unit       = item-doc-est.preco-unit[1]
           tt-desp.preco-total      = item-doc-est.preco-total[1]
           tt-desp.peso-liq         = item-doc-est.peso-liquido
           tt-desp.nat-operacao     = item-doc-est.nat-of.

    &IF  "{&bf_dis_versao_ems}" < "2.09" &THEN
        ASSIGN tt-desp.cod-tributac-nfe = SUBSTRING(item-doc-est.char-2,637,3).
    &ELSE
        ASSIGN tt-desp.cod-tributac-nfe = item-doc-est.num-origem.
    &ENDIF
     
    /* busca Cofins*/        
    if natur-oper.cod-cfop begins '3' then       
        assign tt-desp.base-cofins      = item-doc-est.val-base-calc-cofins
               tt-desp.aliq-cofins      = item-doc-est.val-aliq-cofins
               tt-desp.de-tot-cof       = item-doc-est.val-cofins.
    else
        assign tt-desp.base-cofins      = 0
               tt-desp.aliq-cofins      = 0
               tt-desp.de-tot-cof       = 0.           
     
    /* busca THC */
    IF  tt-param.l-listar-THC THEN DO:

        FIND FIRST desp-imp NO-LOCK
            WHERE  desp-imp.descricao = "THC" NO-ERROR.
        IF  AVAIL  desp-imp THEN DO:
            FOR EACH  item-doc-est-cex NO-LOCK
                WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
                AND   item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
                AND   item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
                AND   item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
                AND   item-doc-est-cex.sequencia    = item-doc-est.sequencia
                AND   item-doc-est-cex.cod-desp     = desp-imp.cod-desp:
                
                ASSIGN tt-desp.val-desp-THC = tt-desp.val-desp-THC + item-doc-est-cex.val-desp.
            
            END. /* FOR EACH  item-doc-est-cex NO-LOCK */
        END. /* IF  AVAIL  desp-imp THEN DO: */
        
    END. /* IF  tt-param.l-listar-THC THEN DO: */
                                               
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
        ASSIGN tt-desp.val-base-icms-nota = it-doc-fisc.vl-bicms-it. 
                                               
        /* Taxa 19 - Despesa SIXCOMEX */       
        FOR FIRST item-doc-est-cex FIELDS(val-desp)
            WHERE item-doc-est-cex.cod-emitente = docum-est.cod-emitente
              AND item-doc-est-cex.nro-docto    = docum-est.nro-docto
              AND item-doc-est-cex.nat-operacao = docum-est.nat-operacao
              AND item-doc-est-cex.serie-docto  = docum-est.serie-docto
              AND item-doc-est-cex.sequencia    = item-doc-est.sequencia
              AND item-doc-est-cex.cod-desp     = 19 NO-LOCK:
        END.                                   
                                               
        ASSIGN tt-desp.val-base-icms-calc =  (it-doc-fisc.vl-bipi-it 
                                           + it-doc-fisc.vl-ipi-it
                                           + it-doc-fisc.val-pis
                                           + it-doc-fisc.val-cofins
                                           + IF AVAIL item-doc-est-cex THEN item-doc-est-cex.val-desp ELSE 0) / .83.
                                               
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
               tt-desp.preco-unit-oc    = ordem-compra.preco-unit
               tt-desp.cod-comprado     = ordem-compra.cod-comprado.

        FOR FIRST cotacao-item FIELDS (char-1) 
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
               AND cotacao-item.cot-aprovada NO-LOCK:
                                               
            /*ASSIGN tt-desp.aliq-importacao = DEC(TRIM(SUBSTRING(cotacao-item.char-1,61,6))) NO-ERROR.
            IF tt-desp.aliq-importacao = ? OR tt-desp.aliq-importacao < 0 THEN
                ASSIGN tt-desp.aliq-importacao = 0.*/
                                               
            ASSIGN tt-desp.ncm = TRIM(REPLACE(SUBSTRING(cotacao-item.char-1,81,20),".","")).
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
                                               
    /* FIND FIRST unid-neg-fam-com NO-LOCK */
/*          WHERE unid-neg-fam-com.fm-codigo = ITEM.fm-cod-com NO-ERROR. */
/*     IF AVAIL unid-neg-fam-com THEN */
/*         ASSIGN tt-desp.unid-neg = unid-neg-fam-com.cod_unid_negoc. */
    
    /*alterado conforme chamado 51606*/    
    find first item-uni-estab no-lock
        where item-uni-estab.cod-estabel = docum-est.cod-estabel 
          and item-uni-estab.it-codigo   = item.it-codigo no-error. 
           
    if avail item-uni-estab then do:
    
        find first unid-negoc no-lock
            where unid-negoc.cod-unid-negoc = item-uni-estab.cod-unid-negoc no-error.
        
        if avail unid-negoc then 
             ASSIGN tt-desp.unid-neg = unid-negoc.des-unid-negoc. 
        else 
             ASSIGN tt-desp.unid-neg = ''. 
    end.
    else 
        ASSIGN tt-desp.unid-neg = ''. 
                                                   
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
               WHERE b-item-doc-est.nro-comp   = docum-est.nro-docto 
                 AND b-item-doc-est.serie-comp = docum-est.serie 
                 AND b-item-doc-est.it-codigo  = item-doc-est.it-codigo 
                 AND b-item-doc-est.seq-comp  = item-doc-est.sequencia NO-LOCK:
                                               
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
    
    IF AVAIL ordem-compra THEN DO:
    
        find first int-pedido-compr no-lock
             where int-pedido-compr.num-pedido = ordem-compra.num-pedido no-error.
            
        if avail int-pedido-compr then
            assign tt-desp.cod-produto-ckd = int-pedido-compr.cod-produto-ckd.
        else 
            assign tt-desp.cod-produto-ckd = ''. 
    end.
    else
        assign tt-desp.cod-produto-ckd = ''.
                                                     
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
                                               
PROCEDURE pi-busca-itens:                      
    
    FOR EACH ITEM NO-LOCK                      
       WHERE ITEM.it-codigo >= tt-param.it-codigo-ini 
         AND ITEM.it-codigo <= tt-param.it-codigo-fim:

        IF ITEM.it-codigo <> "" THEN DO:
            RUN pi-acompanhar IN h-acomp (INPUT "Lendo Itens: " + ITEM.it-codigo).
            CREATE tt-item.
            ASSIGN tt-item.it-codigo = ITEM.it-codigo.
        END.
    END.
    
END PROCEDURE.

PROCEDURE pi-filtra-materias:

    FOR EACH tt-item NO-LOCK:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = tt-item.it-codigo NO-ERROR.

        IF NOT AVAIL ITEM THEN 
            DELETE tt-item.

        IF ITEM.ge-codigo < 19 OR
           ITEM.ge-codigo = 45 THEN NEXT.
        ELSE
            DELETE tt-item.
    END. 
END PROCEDURE.

PROCEDURE pi-busca-estrutura:
    DEFINE VARIABLE de-quantidade   AS DECIMAL     NO-UNDO.
    define var de-quant-usada like estrutura.quant-usada  FORMAT "->>>>,>>9.9999999999" NO-UNDO.
    define var de-quant-liquid like estrutura.quant-liquid  FORMAT "->>>>,>>9.9999999999" NO-UNDO.

    FOR FIRST ITEM WHERE ITEM.it-codigo = tt-param.it-codigo NO-LOCK:

        RUN pi-acompanhar IN h-acomp (INPUT "Lendo Estrutura - Item: " + ITEM.it-codigo).

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

            if ((estrutura.data-inicio  <= tt-param.data-corte and
                estrutura.data-termino > tt-param.data-corte) or tt-param.data-corte = ?) and estrutura.cod-lista-compon = c-processo then do:

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
                  if estrutura.fantasma then 
                     assign c-aux = '#'.
                  else
                     assign c-aux = ''.

                  if can-find (first alternativo 
                               where alternativo.es-codigo = estrutura.es-codigo
                                 and alternativo.it-codigo = estrutura.it-codigo
                                 and alternativo.sequencia = estrutura.sequencia no-lock) then
                     assign c-aux = c-aux +  c-alt.

                  if today >= estrutura.data-termino or today < data-inicio then
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
       WHERE tt-estrutura.es-codigo <> ""
        BREAK BY tt-estrutura.es-codigo:

        IF FIRST-OF(tt-estrutura.es-codigo) THEN DO:
            CREATE tt-item.
            ASSIGN tt-item.it-codigo = tt-estrutura.es-codigo.

            FOR EACH b-tt-estrutura NO-LOCK
               WHERE b-tt-estrutura.es-codigo = tt-estrutura.es-codigo:
                ASSIGN tt-item.qt-estrut = tt-item.qt-estrut + b-tt-estrutura.quant-usada.
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
    
    for each b-estrutura of b1-item no-lock:
    
        if (b-estrutura.data-inicio  <= tt-param.data-corte and
            b-estrutura.data-termino >  tt-param.data-corte) or tt-param.data-corte = ? then do:
    
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
            ELSE assign l-refer-incluida = yes.
    
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
    
               if today >= b-estrutura.data-termino or today < b-estrutura.data-inicio then
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
    
               run pi-gera-estrutura-filho(buffer b2-item, c-refer-es, de-quant-usada, p-nivel, i-cont - 1).
           end.
        end.
    end.
END PROCEDURE.

/**** Fim do programa ****/
