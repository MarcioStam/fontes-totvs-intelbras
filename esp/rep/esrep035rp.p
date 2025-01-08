/***********************************************************************
**  Programa..: ESP\REP\ESREP035RP.P
**  Autor.....: Giovane Oliveira
**  Data......: FEVEREIRO/2006 - Desenvolvimento
**  Descricao.: NF de Entrada
**  VersÆo....: 001 07/02/2006
**                  Desenvolvimento Programa
compile \\tsclient\c\fontes\esp\rep\esrep035rp.p save into c:\temp\esp\rep.

************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESREP035 1.00.00.000}

/****************************  Definitions  ****************************/
{esp/rep/esrep035tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

def var de-ali-icm like  it-nota-fisc.aliquota-icm no-undo.
def var c-aliquotas  as character format "x(06)" no-undo.
def var de-tot-ipi   as decimal  format ">>>>>>>>9.99"  init 0 no-undo.
def var de-tot-ii    as decimal  format ">>>>>>>>9.99" init 0 no-undo.
def var de-tot-des   as decimal  format ">>>>>>>>9.99" init 0 no-undo.

def var nota-cre as dec NO-UNDO.
def var nota-deb-1 as dec  NO-UNDO.
def var c-emb        like embarque-imp.embarque  NO-UNDO.
/* def var v-aliq like docum-est.aliquota-icm init 0  NO-UNDO. */
def var c-nr-di like embarque-imp.declaracao-import NO-UNDO.

DEF VAR de-cotacao-entrada AS DEC  NO-UNDO.
DEF VAR de-cotacao-emb     AS DEC  NO-UNDO.
DEF VAR tx-adm             AS DEC  NO-UNDO.
DEF VAR de-cotacao-di      AS DEC  NO-UNDO.
DEFINE VARIABLE de-tot-cof-calc AS DECIMAL     NO-UNDO.

DEF VAR de-tot-icm  AS decimal  format ">>>>>>>>9.99"  init 0 no-undo.
DEF VAR de-tot-pis  AS decimal  format ">>>>>>>>9.99" init 0 no-undo.
DEF VAR de-tot-cof  AS decimal  format ">>>>>>>>9.99" init 0 no-undo.

DEF VAR de-tot-impostos as decimal FORMAT ">,>>>,>>>,>>9.99" no-undo.
DEF VAR de-impostos as decimal FORMAT ">,>>>,>>>,>>9.99" no-undo.
def var de-tot-frete as decimal FORMAT ">>,>>>,>>>,>>9.99" no-undo.
def var de-frete as decimal FORMAT ">>,>>>,>>>,>>9.99" no-undo.
def var de-seguro      as decimal FORMAT ">>,>>>,>>>,>>9.99" no-undo.
def var de-vl-mercadoria LIKE docum-est.valor-mercad no-undo.
def var de-vl-invoice LIKE invoice-emb-imp.vl-invoice no-undo.
def var de-nota-deb   LIKE item-doc-est.valor-ipi[1] no-undo.
def var de-tot-valor  like docum-est.tot-valor no-undo.
def var l-imp as logical no-undo.

DEF VAR v-aliq        LIKE docum-est.aliquota-icm init 0  NO-UNDO.
DEF VAR cod-motivacao LIKE int-docum-est.cod-msg-devolucao.
def var de-proporcao as decimal no-undo.

DEFINE VARIABLE de-tx-adm  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-tx-adm2 AS DECIMAL     NO-UNDO.

DEFINE VARIABLE i-colunas        AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-linha-corrente AS INTEGER     NO-UNDO.
DEFINE BUFFER b-historico-embarque FOR historico-embarque.

/****************************  Temp-Tables  ****************************/
DEF TEMP-TABLE tt-class
    FIELD ncm like item.class-fiscal
    FIELD valor as dec format ">>,>>>,>>9.99"
    INDEX codigo is primary ncm.


/****************************  Temp-Tables  ****************************/
DEF TEMP-TABLE tt-documento
    FIELD dt-trans          LIKE docum-est.dt-trans
    FIELD dt-emissao        LIKE docum-est.dt-emissao
    FIELD serie-docto       LIKE docum-est.serie-docto
    FIELD nro-docto         LIKE docum-est.nro-docto
    FIELD cod-emitente      LIKE docum-est.cod-emitente
    FIELD nome-abrev        LIKE emitente.nome-abrev 
    FIELD cgc               LIKE emitente.cgc
    FIELD estado            LIKE emitente.estado
    FIELD cidade            LIKE emitente.cidade
    FIELD pais              LIKE emitente.pais
    FIELD nat-operacao      LIKE docum-est.nat-operacao
    FIELD v-aliq            LIKE item-doc-est.aliquota-icm
    FIELD cod-devolucao     LIKE int-docum-est.cod-msg-devolucao
    FIELD sequencia         LIKE item-doc-est.sequencia
    FIELD it-codigo         LIKE item-doc-est.it-codigo
    FIELD descricao-1       LIKE ITEM.descricao-1
    FIELD descricao-2       LIKE ITEM.descricao-2
    FIELD narrativa         as char
    FIELD class-fiscal      LIKE item-doc-est.class-fiscal
    FIELD aliquota-ipi      LIKE item-doc-est.aliquota-ipi
    FIELD cod-depos         LIKE item-doc-est.cod-depos
    FIELD cod-localiz       LIKE item-doc-est.cod-localiz
    FIELD quantidade        LIKE item-doc-est.quantidade
    FIELD valor-mercadoria  LIKE docum-est.valor-mercad
    FIELD icm-deb-cre       LIKE item-doc-est.valor-icm[1]
    FIELD icm-complem       LIKE item-doc-est.icm-complem[1]
    FIELD nota-deb          LIKE item-doc-est.valor-ipi[1]
    FIELD base-cofins       AS DECIMAL  FORMAT ">>>>>>>>9.99"
    FIELD aliq-cofins       AS DEC      FORMAT ">>9.99" 
    FIELD de-tot-cof        AS DECIMAL  FORMAT ">>>>>>>>9.99"
    FIELD tot-valor         AS DECIMAL  FORMAT ">>>>>>>>9.99"
    FIELD nro-comp          LIKE item-doc-est.nro-comp
    FIELD usuario           LIKE docum-est.usuario
    FIELD valor-frete       LIKE docum-est.valor-frete
    FIELD valor-seguro      LIKE docum-est.valor-frete
    FIELD tx-adm       LIKE desp-embarque.val-desp
    FIELD vl-invoice   LIKE invoice-emb-imp.vl-invoice
    FIELD char-1       LIKE docum-est.char-1
    FIELD aliquota-icm LIKE docum-est.aliquota-icm
    FIELD de-tot-ii    AS DECIMAL  FORMAT ">>>>>>>>9.99" /*init 0 no-undo */
    FIELD c-emb        LIKE embarque-imp.embarque
    FIELD c-nr-di      LIKE embarque-imp.declaracao-import
    FIELD de-tot-icm   AS DECIMAL  format ">>>>>>>>9.99"
    FIELD de-tot-ipi   as decimal  format ">>>>>>>>9.99"
    field preco-unit   like item-doc-est.preco-unit[1]
    FIELD dt-vencto    LIKE dupli-apagar.dt-vencim
    FIELD esp-dupli    LIKE dupli-apagar.cod-esp
    FIELD r-docum-est  AS ROWID
    field preco-unit-dl as decimal 
    field cotacao-di   as dec 
    FIELD cotacao-entrada AS DEC
    FIELD cotacao-emb  AS DEC
    FIELD nr-ord-prod LIKE item-doc-est.nr-ord-prod
    FIELD nf-rateio   LIKE rat-docum.nro-docto
    FIELD vlr-rateio  as dec format ">>>,>>9.99"
    FIELD nf-desp-aces LIKE docum-est.nro-docto
    FIELD vlr-desp-aces as dec format ">>>,>>9.99"
    FIELD cod-estabel AS CHARACTER FORMAT "x(3)"
    FIELD data-di     AS CHARACTER FORMAT "x(10)"
    FIELD hr-atualiza LIKE docum-est.hr-atualiza
    FIELD vl-cofins-of AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    INDEX chave1 dt-trans r-docum-est.
         



/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.

    IF tt-digita.nat-operacao = "" THEN
        DELETE tt-digita.
end.

DEF VAR h-acomp      as handle no-undo.
def var c-separador  as char format "x(01)".
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "NF de Entrada"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESREP035"
       c-versao       = "2.04"
       c-revisao      = "002".

assign c-separador = ";".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i &pagesize="9999999"}

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    
    RUN piRelatAnalitico.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.


PROCEDURE piRelatAnalitico:
    def var i as int no-undo.

    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

    FOR EACH docum-est NO-LOCK                                   WHERE
             docum-est.cod-emitente >= tt-param.ini-cod-emitente AND
             docum-est.cod-emitente <= tt-param.fim-cod-emitente AND
             docum-est.cod-estabel  >= tt-param.cod-estabel-ini  and
             docum-est.cod-estabel  <= tt-param.cod-estabel-fim  and 
/*              docum-est.nat-operacao >= tt-param.ini-nat-operacao AND  */
/*              docum-est.nat-operacao <= tt-param.fim-nat-operacao AND  */
             docum-est.dt-trans     >= tt-param.ini-data         AND
             docum-est.dt-trans     <= tt-param.fim-data         AND
             docum-est.uf           >= tt-param.ini-uf           AND
             docum-est.uf           <= tt-param.fim-uf:

        RUN pi-acompanhar in h-acomp (input "Lendo Documento = "  + docum-est.nro-docto ). 
/*         if can-find(first tt-digita) then                                                     */
/*             if not can-find(first tt-digita no-lock                                           */
/*                             where tt-digita.nat-operacao = docum-est.nat-operacao) then next. */
/*                                                                                               */
        FIND FIRST emitente WHERE
                   emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.

        if tt-param.natureza = 1 and emitente.natureza <> 1 then next.
        if tt-param.natureza = 2 and emitente.natureza <> 2 then next.
        
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.
        IF NOT AVAIL natur-oper THEN NEXT.

        IF NOT tt-param.imprime-devol AND natur-oper.tipo-compra = 3 THEN NEXT.

        FIND FIRST int-docum-est WHERE 
                   int-docum-est.serie-docto  = docum-est.serie-docto  AND
                   int-docum-est.nro-docto    = docum-est.nro-docto    AND
                   int-docum-est.cod-emitente = docum-est.cod-emitente AND
                   int-docum-est.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR. 
        IF AVAIL int-docum-est THEN DO:
           ASSIGN cod-motivacao = int-docum-est.cod-msg-devolucao. 
        END.
        ELSE DO:
           ASSIGN cod-motivacao = 0.
        END.

        ASSIGN de-frete  = 0
               de-seguro = 0
               de-tot-frete = 0.
        FIND embarque-imp WHERE
             embarque-imp.cod-estabel = docum-est.cod-estabel AND
             embarque-imp.embarque = substring(docum-est.char-1,1,12) NO-LOCK NO-ERROR.
        if avail embarque-imp THEN DO:
        END.
        FOR EACH item-doc-est OF docum-est NO-LOCK
            WHERE item-doc-est.nat-of >= tt-param.ini-nat-operacao 
              AND item-doc-est.nat-of <= tt-param.fim-nat-operacao:

              if can-find(first tt-digita) then                                                     
                  if not can-find(first tt-digita no-lock                                           
                                  where tt-digita.nat-operacao = item-doc-est.nat-of) then next. 

              FIND FIRST it-doc-fisc
                    WHERE  it-doc-fisc.cod-estabel   = docum-est.cod-estabel
                      AND  it-doc-fisc.serie         = item-doc-est.serie-docto
                      AND  it-doc-fisc.nr-doc-fis    = item-doc-est.nro-docto
                      AND  it-doc-fisc.cod-emitente  = docum-est.cod-emitente
                      AND  it-doc-fisc.nat-operacao  = item-doc-est.nat-of
                      AND  it-doc-fisc.it-codigo     = item-doc-est.it-codigo
                      AND  it-doc-fisc.quantidade    = item-doc-est.qt-do-forn   
                      AND  it-doc-fisc.vl-merc-liq   = (item-doc-est.preco-total[1] - item-doc-est.desconto[1])
                    NO-LOCK NO-ERROR.

            IF item-doc-est.it-codigo < tt-param.it-codigo-ini OR
               item-doc-est.it-codigo > tt-param.it-codigo-fim THEN NEXT.

            /*---[ Alterado conforme chamado 46641 ]---------------------------------------------------------*/
            IF  item-doc-est.val-aliq-cofins <>  8.6 
            AND item-doc-est.val-aliq-cofins <> 10.65
            AND item-doc-est.val-aliq-cofins <> 11.8  THEN NEXT.
            /*---------------------------------------------------------[ Alterado conforme chamado 46641 ]---*/

            FIND ITEM 
                 WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.

            RUN pi-acompanhar IN h-acomp (INPUT "Nota: " + docum-est.nro-docto + " - Data: " + STRING(docum-est.dt-trans,"99/99/9999")).

            CREATE tt-documento.
            ASSIGN tt-documento.dt-trans        = docum-est.dt-trans
                   tt-documento.dt-emissao      = docum-est.dt-emissao
                   tt-documento.serie-docto     = docum-est.serie-docto
                   tt-documento.nro-docto       = docum-est.nro-docto
                   tt-documento.cod-emitente    = docum-est.cod-emitente
                   tt-documento.nome-abrev      = emitente.nome-abrev
                   tt-documento.nat-operacao    = item-doc-est.nat-of
                   tt-documento.cod-devolucao   = cod-motivacao
                   tt-documento.it-codigo       = item-doc-est.it-codigo
                   tt-documento.sequencia       = item-doc-est.sequencia
                   tt-documento.descricao-1     = ITEM.descricao-1
                   tt-documento.descricao-2     = ITEM.descricao-2
                   tt-documento.narrativa       = REPLACE(replace(item-doc-est.narrativa,CHR(10)," "),CHR(13)," ")
                   tt-documento.class-fiscal    = item-doc-est.class-fiscal 
                   tt-documento.aliquota-ipi    = item-doc-est.aliquota-ipi
                   tt-documento.cod-depos       = item-doc-est.cod-depos
                   tt-documento.cod-localiz     = item-doc-est.cod-localiz
                   tt-documento.quantidade      = item-doc-est.quantidade   
                   tt-documento.valor-mercadoria = item-doc-est.preco-total[1]
                   
                   tt-documento.base-cofins     = item-doc-est.val-base-calc-cofins
                   tt-documento.aliq-cofins     = item-doc-est.val-aliq-cofins
                   tt-documento.de-tot-cof      = item-doc-est.val-cofins
                   tt-documento.tot-valor       = docum-est.tot-valor * (item-doc-est.preco-total[1] / docum-est.valor-mercad) /*item-doc-est.preco-total[1] + item-doc-est.valor-ipi[1] /*+ tt-documento.valor-frete + tt-documento.tx-adm*/ * (item-doc-est.preco-total[1] / docum-est.tot-valor)*/
                   tt-documento.nro-comp        = item-doc-est.nro-comp
                   tt-documento.usuario         = docum-est.usuario

                   tt-documento.r-docum-est     = ROWID(docum-est)
                   tt-documento.cod-estabel     = docum-est.cod-estabel

                   tt-documento.c-emb           = IF AVAIL embarque-imp THEN embarque-imp.embarque ELSE "".

            IF AVAIL embarque-imp THEN
                ASSIGN tt-documento.c-nr-di = embarque-imp.declaracao-imp
                       tt-documento.data-di = IF embarque-imp.data-di = ? THEN "" ELSE STRING(embarque-imp.data-di,"99/99/9999").
            ELSE
                ASSIGN tt-documento.c-nr-di = ""
                       tt-documento.data-di = "".
            IF AVAIL it-doc-fisc THEN DO:
                ASSIGN tt-documento.vl-cofins-of = it-doc-fisc.val-cofins.
            END.
      
        END.
    END.
    
    PUT UNFORMATTED "Dt Trans;Emissao;Serie;Nro Docto;Estab;Emitente;Nome Abreviado;Embarque;DI;Nat Operacao;Seq;Item;Descricao;Quantidade;Class Fiscal;Base Cofins;Aliquota Cofins;Vlr Cofins;Vlr Aliq Calc;Cofins OF;Diferenca;Usuario" SKIP.
    
    FOR EACH tt-documento break by tt-documento.dt-trans:

    
        RUN pi-acompanhar in h-acomp (input "Imprimindo Documento = "  + tt-documento.nro-docto + " " + STRING(tt-documento.dt-trans) ).
        PUT UNFORMATTED 
             tt-documento.dt-trans                  FORMAT "99/99/9999"
             c-separador
             tt-documento.dt-emissao                FORMAT "99/99/9999"    
             c-separador
             tt-documento.serie-docto                        
             c-separador
             tt-documento.nro-docto                 FORMAT "9999999"      
             c-separador
             tt-documento.cod-estab                 format "x(3)"
             c-separador
             tt-documento.cod-emitente                       
             c-separador
             tt-documento.nome-abrev                FORMAT "x(12)"         
             c-separador
             tt-documento.c-emb   
             c-separador
             tt-documento.c-nr-di                                FORMAT "x(20)" 
             c-separador
             
             tt-documento.nat-operacao              FORMAT "999xxx"   
             c-separador
             tt-documento.sequencia 
             c-separador
             tt-documento.it-codigo                 FORMAT "x(10)"                       
             c-separador
             tt-documento.descricao-1               
             tt-documento.descricao-2
             c-separador
             tt-documento.quantidade                FORMAT "->,>>>,>>9.99" 
             c-separador
             tt-documento.class-fiscal              FORMAT "9999.99.99" 
             c-separador
             tt-documento.base-cofins               FORMAT "->>,>>>,>>9.99" 
             c-separador
             tt-documento.aliq-cofins               FORMAT ">>9.99" 
             c-separador
             tt-documento.de-tot-cof                FORMAT "->>,>>>,>>9.99"
             c-separador .

        ASSIGN de-tot-cof-calc = tt-documento.base-cofins * (tt-documento.aliq-cofins - 1) / 100.

        PUT de-tot-cof-calc
            c-separador
            tt-documento.vl-cofins-of
            c-separador
            tt-documento.de-tot-cof  - de-tot-cof-calc.

        PUT  c-separador
             tt-documento.usuario
             SKIP.
    END.
END PROCEDURE.

