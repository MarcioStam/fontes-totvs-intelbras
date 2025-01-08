/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i EPCRE1005A 2.00.00.001}  /*** 010001 ***/
/***********************************************************************
**  
**
************************************************************************/



/*--- Defini‡Æo dos Parƒmetros ---*/
{include/i-epc200.i1}
def input parameter p-ind-event as char no-undo.
def input-output param table for tt-epc.



/*--- Defini‡Æo das Tabelas Tempor rias ---*/
{cep/ceapi001k.i}  /* tt-movto */
DEFINE TEMP-TABLE tt-conta NO-UNDO
       FIELD sequen-nf      AS INTE
       FIELD conta-contabil as char 
       FIELD ct-icms-ft     as char 
       FIELD ct-ipi-ft      as char 
       FIELD ct-cofins-ft   as char 
       FIELD ct-pis-ft      as char 
       FIELD sc-icms-ft     as char 
       FIELD sc-ipi-ft      as char 
       FIELD sc-cofins-ft   as char 
       FIELD sc-pis-ft      as char 
       INDEX chapri         AS PRIMARY UNIQUE sequen-nf.

def temp-table tt-movto-un no-undo 
    field i-sequen       as integer
    field cod-unid-neg   like unid-neg-nota.cod_unid_negoc
    field perc-unid-neg  like unid-neg-nota.perc-unid-neg.



/*--- Defini‡Æo das Vari velis Locais ---*/
DEFINE VARIABLE h-ceapi001k      AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-ct-codigo      LIKE movto-estoq.ct-codigo NO-UNDO.
DEFINE VARIABLE c-sc-codigo      LIKE movto-estoq.sc-codigo NO-UNDO.
DEFINE VARIABLE i-cod-unid-neg   AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-unid-neg       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-it-codigo      AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-handle         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-tt-movto       AS HANDLE      NO-UNDO.
DEFINE VARIABLE hq-tt-movto      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-cod-estabel    AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-cod-unid-negoc AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-nat-operacao   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-ct-codigo      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-sc-codigo      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-c-it-codigo    AS HANDLE      NO-UNDO.
DEFINE VARIABLE r-docto          AS ROWID       NO-UNDO.
DEFINE VARIABLE i-empresa        LIKE param-global.empresa-prin NO-UNDO.
DEFINE VARIABLE l-erro           AS LOGICAL     NO-UNDO.

{cdp/cd0666.i}

def buffer b-movto   for movto-estoq.
def buffer b-receb   for recebimento.



/*--- Bloco Principal ---*/
CASE p-ind-event:
    WHEN "before-CEAPI001":U THEN DO:
        FIND FIRST tt-epc NO-LOCK
             WHERE tt-epc.cod-event     = p-ind-event
               AND tt-epc.cod-parameter = "handle(tt-movto)":U NO-ERROR.
        IF  AVAIL tt-epc THEN DO:
            ASSIGN h-handle   = WIDGET-HANDLE(tt-epc.val-parameter)
                   h-tt-movto = h-handle:DEFAULT-BUFFER-HANDLE.

            CREATE QUERY hq-tt-movto.
            hq-tt-movto:SET-BUFFERS(h-tt-movto).
            hq-tt-movto:QUERY-PREPARE("FOR EACH tt-movto EXCLUSIVE-LOCK").
            hq-tt-movto:QUERY-OPEN.
            hq-tt-movto:GET-FIRST().

            ASSIGN h-cod-estabel    = h-tt-movto:BUFFER-FIELD("cod-estabel")
                   h-cod-unid-negoc = h-tt-movto:BUFFER-FIELD("cod-unid-negoc")
                   h-nat-operacao   = h-tt-movto:BUFFER-FIELD("nat-operacao")
                   h-ct-codigo      = h-tt-movto:BUFFER-FIELD("ct-codigo")
                   h-sc-codigo      = h-tt-movto:BUFFER-FIELD("sc-codigo")
                   h-c-it-codigo    = h-tt-movto:BUFFER-FIELD("it-codigo").
        
            DO WHILE NOT hq-tt-movto:QUERY-OFF-END:
                FIND ITEM
                    WHERE ITEM.it-codigo = h-c-it-codigo:BUFFER-VALUE 
                    NO-LOCK NO-ERROR.
  
                IF AVAIL ITEM AND
                    ITEM.tipo-contr <> 4 THEN DO:

                    FIND FIRST int-unid-neg-natur NO-LOCK
                        WHERE  int-unid-neg-natur.cod-estabel  = h-cod-estabel:BUFFER-VALUE
                        AND    int-unid-neg-natur.cod-unid-neg = h-cod-unid-negoc:BUFFER-VALUE
                        AND    int-unid-neg-natur.nat-operacao = h-nat-operacao:BUFFER-VALUE NO-ERROR.
                    IF  AVAIL  int-unid-neg-natur THEN
                        ASSIGN h-ct-codigo:BUFFER-VALUE = int-unid-neg-natur.ct-codigo
                               h-sc-codigo:BUFFER-VALUE = int-unid-neg-natur.sc-codigo.

                END.
        
                hq-tt-movto:GET-NEXT.
            END.
        
            hq-tt-movto:QUERY-CLOSE.
            DELETE OBJECT hq-tt-movto.                                   
        END.
    END.

    WHEN "End-Tax-Calculation":U THEN DO: 
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event     = p-ind-event
               AND tt-epc.cod-parameter = "rowid(docum-est)":U NO-ERROR.
        IF AVAIL tt-epc THEN DO:
            FIND FIRST docum-est NO-LOCK
                 WHERE ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
            IF  NOT AVAIL docum-est THEN 
                RETURN "NOK":U.

            /* Incidente 1156 - Contabiliza?’o de notas de devolu?a„ da ASTEC por unidade de negocio do item/familia */
            IF docum-est.cod-observa = 3 THEN DO:
                FIND natur-oper WHERE
                     natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
                IF NOT AVAIL natur-oper THEN RETURN "OK".

                FOR EACH tt-movto
                   WHERE tt-movto.nro-docto    = docum-est.nro-docto
                     AND tt-movto.serie-docto  = docum-est.serie-docto
                     AND tt-movto.cod-emitente = docum-est.cod-emitente
                     AND tt-movto.nat-operacao = docum-est.nat-operacao:

                     IF tt-movto.it-codigo <> "" THEN 
                         ASSIGN c-it-codigo = tt-movto.it-codigo.

                     IF  SUBSTRING(tt-movto.ct-codigo,1,1) = "3"
                     AND substring(c-it-codigo,1,1) <> "4" THEN DO:

                        FIND item-uni-estab NO-LOCK
                            WHERE item-uni-estab.it-codigo   = c-it-codigo
                              AND item-uni-estab.cod-estabel = tt-movto.cod-estabel NO-ERROR.

                        IF  AVAIL item-uni-estab THEN DO:
                            ASSIGN tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-neg.
                        END.
                    END.
                END.
                FIND int-natur-oper WHERE
                     int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-LOCK NO-ERROR.
                IF AVAIL int-natur-oper 
                     AND int-natur-oper.contab-unid-neg THEN DO:
                    FIND FIRST param-global NO-LOCK NO-ERROR.
                    ASSIGN i-empresa = param-global.empresa-prin.

                    find estabelec where
                         estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.

                    run cdp/cd9970.p (input rowid(estabelec),
                                      output i-empresa).

                    FIND FIRST item-doc-est OF docum-est NO-LOCK NO-ERROR.
                    IF AVAIL item-doc-est
                         AND SUBSTRING(item-doc-est.nat-oper,1,1) <> "3" THEN DO:  /* n’o gerar para NF de varia?’o cambial e devolu?’o de exporta?’o */
                        FOR EACH tt-movto 
                           WHERE tt-movto.nro-docto    = docum-est.nro-docto
                             AND tt-movto.serie-docto  = docum-est.serie-docto
                             AND tt-movto.cod-emitente = docum-est.cod-emitente
                             AND tt-movto.nat-operacao = docum-est.nat-operacao:

                            IF tt-movto.it-codigo <> "" THEN DO:
                                RUN pi-atualiza-movto.
                            END.
                            ELSE DO:
                                FIND FIRST tt-conta
                                     WHERE tt-conta.sequen-nf = tt-movto.sequen-nf NO-ERROR.
                                IF AVAIL tt-conta THEN DO:
                                    IF TRIM(tt-movto.referencia) = "ICMS" THEN
                                        ASSIGN tt-movto.ct-codigo      = tt-conta.ct-icms-ft
                                               tt-movto.sc-codigo      = tt-conta.sc-icms-ft.
                                    ELSE IF TRIM(tt-movto.referencia) = "IPI" THEN
                                        ASSIGN tt-movto.ct-codigo      = tt-conta.ct-ipi-ft
                                               tt-movto.sc-codigo      = tt-conta.sc-ipi-ft.
                                    ELSE IF TRIM(tt-movto.referencia) = "COFINS" THEN
                                        ASSIGN tt-movto.ct-codigo      = tt-conta.ct-cofins-ft
                                               tt-movto.sc-codigo      = tt-conta.sc-cofins-ft.
                                    ELSE IF TRIM(tt-movto.referencia) = "PIS" THEN
                                        ASSIGN tt-movto.ct-codigo      = tt-conta.ct-pis-ft
                                               tt-movto.sc-codigo      = tt-conta.sc-pis-ft.
                                END.
                            END. 
                        END. /* FOR EACH tt-movto  */
                    END.
                END. /* IF AVAIL int-natur-oper  */
            END.
        END. /* IF AVAIL tt-epc THEN DO: */
    END.

    WHEN "troca-empresa" THEN DO:
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event     = p-ind-event
               AND tt-epc.cod-parameter = "docum-est rowid" no-lock no-error.
        IF NOT AVAIL tt-epc THEN RETURN "OK":U.

        FIND docum-est WHERE ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.

        /* Implementado para Log­stica */
        IF  AVAIL docum-est THEN DO:
            ASSIGN r-docto = ROWID(docum-est).

            RUN piAtualizaMatrizRateio.
            IF RETURN-VALUE = "NOK" THEN DO:
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "troca-empresa"
                       tt-epc.cod-parameter = "return-error"
                       tt-epc.val-parameter = "yes".
            END.

            RUN piContabDespesaPrepaid. /* incidente Luiz Demaria */
            
            IF RETURN-VALUE = "NOK" THEN DO:
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "troca-empresa"
                       tt-epc.cod-parameter = "return-error"
                       tt-epc.val-parameter = "yes".
            END.
        END.
    END.
END CASE.

RETURN "OK":U.


/* *************** PROCEDURE INTERNAS ******************* */
PROCEDURE piContabDespesaPrepaid:
    
    for each tt-movto:
        delete tt-movto.
    end.
    
    assign l-erro = no.
    
    for each docum-est-cex NO-LOCK
       where docum-est-cex.serie-docto  = docum-est.serie-docto
         AND docum-est-cex.nro-docto    = docum-est.nro-docto
         AND docum-est-cex.cod-emitente = docum-est.cod-emitente
         and docum-est-cex.nat-operacao = docum-est.nat-operacao:

        find desp-imp where
             desp-imp.cod-desp = docum-est-cex.cod-desp no-lock no-error.
        if not avail desp-imp
                  or desp-imp.gera-custo then next.

        for EACH item-doc-est-cex of docum-est-cex 
           WHERE item-doc-est-cex.cod-desp = docum-est-cex.cod-desp NO-LOCK
           BREAK BY item-doc-est-cex.cod-desp:

            find item-doc-est where 
                 item-doc-est.nro-docto =   item-doc-est-cex.nro-docto and 
                 item-doc-est.serie-docto = item-doc-est-cex.serie-docto and
                 item-doc-est.nat-operacao = item-doc-est-cex.nat-operacao and
                 item-doc-est.cod-emitente = item-doc-est-cex.cod-emitente and 
                 item-doc-est.sequencia = item-doc-est-cex.sequencia NO-LOCK NO-ERROR.
            IF NOT AVAIL item-doc-est THEN NEXT.

            FOR FIRST ITEM
                WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK: END.
            IF NOT AVAIL ITEM THEN NEXT.

            FOR EACH  movto-estoq NO-LOCK 
                WHERE movto-estoq.serie-docto  = item-doc-est.serie-docto  
                  AND movto-estoq.nro-docto    = item-doc-est.nro-docto    
                  AND movto-estoq.cod-emitente = item-doc-est.cod-emitente 
                  AND movto-estoq.nat-operacao = item-doc-est.nat-operacao 
                  AND movto-estoq.esp-docto    = 21                        
                  AND movto-estoq.sequen-nf    = item-doc-est.sequencia    
                  AND movto-estoq.it-codigo    = item-doc-est.it-codigo: 

                IF ITEM.tipo-contr = 4 THEN DO: /* se for controle D‚bito Direto */
                    IF movto-estoq.ct-codigo BEGINS "1" AND movto-estoq.ct-codigo <> "11910015" THEN do: /* conta de imobilizado */
                        ASSIGN c-ct-codigo      = movto-estoq.ct-codigo
                               c-sc-codigo      = movto-estoq.sc-codigo.
                        NEXT.
                    END.
                END.
                ELSE ASSIGN c-ct-codigo      = movto-estoq.ct-codigo
                            c-sc-codigo      = movto-estoq.sc-codigo.

                /* Foi feito esta valida‡Æo devido a um problema que come‡ou a ocorrer em abril/2011 onde ao utilizara conta de CPV 33370005 deixava a variavel zerada
                   e com isso gerava a TT com a conta em branco. Isto dava um erro na CEAPI001 de conta contabil inexistente. Com isso as notas eram enviadas para a Sefaz
                   por‚m sem estarem atualizadas no estoque.*/
                IF c-ct-codigo = "" THEN NEXT. 

                create tt-movto.
                assign tt-movto.esp-docto    = 28             
                       tt-movto.cod-depos    = item-doc-est.cod-depos
                       tt-movto.cod-emitente = docum-est.cod-emitente
                       tt-movto.cod-estabel  = docum-est.cod-estabel
                       tt-movto.cod-refer    = item-doc-est.cod-refer
                       tt-movto.dt-trans     = docum-est.dt-trans
                       tt-movto.it-codigo    = item-doc-est.it-codigo
                       tt-movto.cod-localiz  = item-doc-est.cod-localiz
                       tt-movto.lote         = item-doc-est.lote
                       tt-movto.nat-operacao = docum-est.nat-operacao
                       tt-movto.nro-docto    = docum-est.nro-docto
                       tt-movto.numero-ordem = ordem-compra.numero-ordem
                       tt-movto.peso-liquido = item-doc-est.peso-liquido
                       tt-movto.serie-docto  = docum-est.serie-docto
                       tt-movto.tipo-trans   = 2
                       tt-movto.un           = item.un
                       tt-movto.sequen-nf    = item-doc-est.sequencia
                       tt-movto.referencia   = "prepaid"
                       tt-movto.ct-codigo    = c-ct-codigo 
                       tt-movto.sc-codigo    = c-sc-codigo 
                       tt-movto.ct-db        = IF item.tipo-contr = 4 THEN movto-estoq.ct-codigo ELSE movto-estoq.ct-saldo
                       tt-movto.sc-db        = IF item.tipo-contr = 4 THEN movto-estoq.sc-codigo ELSE movto-estoq.sc-saldo
                       tt-movto.descricao-db = item-doc-est.narrativa
                       tt-movto.cod-versao-integracao = 1
                       tt-movto.quantidade   = 0
                       tt-movto.valor-mat-m[1] = item-doc-est-cex.val-desp.

            END. /* FOR EACH movto-estoq WHERE */
        END.
    END.
    
    find first tt-movto no-error.
    if  avail tt-movto then do:
        run cep/ceapi001k.p persistent set h-ceapi001k.

        if  valid-handle(h-ceapi001k) THEN DO:
            run pi-valida-movto-uneg in h-ceapi001k (input table tt-movto-un).

            RUN pi-execute in h-ceapi001k (input-output table tt-movto,
                                           input-output table tt-erro,
                                           input yes).
            delete procedure h-ceapi001k.
        END.

        for each tt-erro :
            put docum-est.serie-docto at 1.
            put docum-est.nro-docto   at 7.
            put string(docum-est.cod-emitente,">>>>>9") at 24.
            put docum-est.nat-operacao at 32.
            put string(tt-erro.cd-erro,">>>>>9") at 42.
            put tt-erro.mensagem at 50 format "X(80)" skip.
            ASSIGN l-erro = YES.
        end.
    end.
    
    IF l-erro THEN
        RETURN "NOK".

    RETURN "OK".    
END PROCEDURE.

PROCEDURE piAtualizaMatrizRateio:
    DEF VAR de-saldo-val-rec LIKE recebimento.val-rec        NO-UNDO.
    DEF VAR rat-qtd-rec-forn like recebimento.qtd-rec-forn   no-undo.
    DEF VAR rat-quant-receb  like recebimento.quant-receb    no-undo.
    DEF VAR rat-qtd-rej-forn like recebimento.qtd-rej-forn   no-undo.
    DEF VAR rat-quant-rejei  like recebimento.quant-rejei    no-undo.
    DEF VAR rat-valor-total  like recebimento.valor-total    no-undo.
    DEF VAR rat-valor-icm    like recebimento.valor-icm      no-undo.
    DEF VAR rat-valor-ipi    like recebimento.valor-ipi      no-undo.
    DEF VAR rat-valor-iss    like recebimento.valor-iss      no-undo.
    def var rat-qtd-saldo    like tt-movto.quantidade        no-undo.
    def var de-qtd-saldo     like tt-movto.quantidade        no-undo.
    def var bas-qtd-saldo    like tt-movto.quantidade        no-undo.
    def var rat-saldo-val-m  like tt-movto.valor-mat-m       no-undo.
    def var rat-saldo-val-p  like tt-movto.valor-mat-m       no-undo.
    def var rat-saldo-val-o  like tt-movto.valor-mat-m       no-undo.
    def var bas-saldo-val-m  like tt-movto.valor-mat-m       no-undo.
    def var bas-saldo-val-p  like tt-movto.valor-mat-m       no-undo.
    def var bas-saldo-val-o  like tt-movto.valor-mat-m       no-undo.
    def var bas-qtd-rec-forn like recebimento.qtd-rec-forn   no-undo.
    def var bas-quant-receb  like recebimento.quant-receb    no-undo.
    def var bas-qtd-rej-forn like recebimento.qtd-rej-forn   no-undo.
    def var bas-quant-rejei  like recebimento.quant-rejei    no-undo.
    def var bas-valor-total  like recebimento.valor-total    no-undo.
    def var bas-valor-icm    like recebimento.valor-icm      no-undo.
    def var bas-valor-ipi    like recebimento.valor-ipi      no-undo.
    def var bas-valor-iss    like recebimento.valor-iss      no-undo.
    def var i-cont           as int                          no-undo.
    def var i-seq            as int                          no-undo.
    def var de-saldo-val     AS DEC FORMAT ">>>>,>>>,>>9.99" NO-UNDO EXTENT 3.
    def var de-valor-mat     AS DEC FORMAT ">>>>,>>>,>>9.99" NO-UNDO EXTENT 3. 
    def var c-saldo-val      AS CHAR                         NO-UNDO.
    def var c-valor-mat      AS CHAR                         NO-UNDO.
    def var r-receb          as rowid                        no-undo.
    def var r-movto          as rowid                        no-undo.

    for each tt-movto:
        delete tt-movto.
    end.   
    
    assign l-erro = no.                        

    for each item-doc-est {cdp/cd8900.i docum-est item-doc-est} no-lock:
        IF item-doc-est.numero-ordem = 0 THEN DO:
            FIND FIRST rat-ordem 
                 WHERE rat-ordem.cod-emitente = item-doc-est.cod-emitente
                   AND rat-ordem.serie-docto  = item-doc-est.serie-docto
                   AND rat-ordem.nro-docto    = item-doc-est.nro-docto
                   AND rat-ordem.nat-operacao = item-doc-est.nat-operacao 
                   AND rat-ordem.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.
            IF AVAIL rat-ordem THEN DO:
                find ordem-compra where 
                     ordem-compra.numero-ordem = rat-ordem.numero-ordem no-lock no-error. 
                if not avail ordem-compra then next.

                IF NOT CAN-FIND (FIRST matriz-rat-ordem
                                 WHERE matriz-rat-ordem.numero-ordem = ordem-compra.numero-ordem NO-LOCK) THEN NEXT.

                find first b-receb use-index data 
                     where b-receb.data-movto   = docum-est.dt-trans
                       and b-receb.num-pedido   = rat-ordem.num-pedido
                       and b-receb.numero-ordem = rat-ordem.numero-ordem
                       and b-receb.parcela      = rat-ordem.parcela
                       and b-receb.numero-nota  = item-doc-est.nro-docto 
                       and b-receb.nat-operacao = docum-est.nat-operacao no-lock no-error.
                if  not avail b-receb then next.

                {epc/epcre1005a.i}  /* criar tt-movto atraves da matriz de rateio */
            END.
        END.
        ELSE DO:
            find ordem-compra where 
                 ordem-compra.numero-ordem = item-doc-est.numero-ordem no-lock no-error. 
            if not avail ordem-compra then next.

            IF NOT CAN-FIND (FIRST matriz-rat-ordem
                             WHERE matriz-rat-ordem.numero-ordem = ordem-compra.numero-ordem NO-LOCK) THEN NEXT.

            find first b-receb use-index data 
                 where b-receb.data-movto   = docum-est.dt-trans
                   and b-receb.num-pedido   = item-doc-est.num-pedido
                   and b-receb.numero-ordem = item-doc-est.numero-ordem
                   and b-receb.parcela      = item-doc-est.parcela
                   and b-receb.numero-nota  = item-doc-est.nro-docto 
                   and b-receb.nat-operacao = docum-est.nat-operacao no-lock no-error.
            if  not avail b-receb then next.

            {epc/epcre1005a.i}  /* criar tt-movto atraves da matriz de rateio */
        END.
    end.                        /* for each item-doc-est    */

    find first tt-movto no-error.
    if  avail tt-movto then do:
        run cep/ceapi001k.p persistent set h-ceapi001k.

        if  valid-handle(h-ceapi001k) THEN DO:
            run pi-valida-movto-uneg in h-ceapi001k (input table tt-movto-un).

            RUN pi-execute in h-ceapi001k (input-output table tt-movto,
                                           input-output table tt-erro,
                                           input yes).
        END.
        delete procedure h-ceapi001k.

        for each tt-erro :
            put docum-est.serie-docto at 1.
            put docum-est.nro-docto   at 7.
            put string(docum-est.cod-emitente,">>>>>9") at 24.
            put docum-est.nat-operacao at 32.
            put string(tt-erro.cd-erro,">>>>>9") at 42.
            put tt-erro.mensagem at 50 format "X(80)" skip.
            ASSIGN l-erro = YES.
        end.
    end.
    
    IF l-erro THEN
        RETURN "NOK".

    RETURN "OK".
END PROCEDURE.


PROCEDURE pi-atualiza-movto.
    DEF VAR c-unid-neg AS CHAR NO-UNDO.

    FIND item-uni-estab NO-LOCK
        WHERE item-uni-estab.it-codigo   = tt-movto.it-codigo
          AND item-uni-estab.cod-estabel = tt-movto.cod-estabel NO-ERROR.

    IF  AVAIL item-uni-estab
    THEN
        ASSIGN c-unid-neg = item-uni-estab.cod-unid-neg.

    IF c-unid-neg <> "" THEN DO:
        FIND FIRST int-unid-neg-natur
             WHERE int-unid-neg-natur.cod-estabel  = tt-movto.cod-estabel
               AND int-unid-neg-natur.cod-unid-neg = c-unid-neg
               AND int-unid-neg-natur.nat-operacao = tt-movto.nat-operacao NO-ERROR.
        IF AVAIL int-unid-neg-natur THEN DO:
            
        
            assign tt-movto.ct-codigo      = int-unid-neg-natur.ct-codigo
                   tt-movto.sc-codigo      = int-unid-neg-natur.sc-codigo.

            FIND FIRST tt-conta
                 WHERE tt-conta.sequen-nf      = tt-movto.sequen-nf NO-ERROR.
            IF NOT AVAIL tt-conta THEN DO:
                CREATE tt-conta.
                ASSIGN tt-conta.conta-contabil = int-unid-neg-natur.conta-contabil
                       tt-conta.sequen-nf      = tt-movto.sequen-nf
                       tt-conta.ct-icms-ft     = int-unid-neg-natur.ct-codigo
                       tt-conta.ct-ipi-ft      = int-unid-neg-natur.ct-codigo
                       tt-conta.ct-cofins-ft   = int-unid-neg-natur.ct-codigo
                       tt-conta.ct-pis-ft      = int-unid-neg-natur.ct-codigo
                       tt-conta.sc-icms-ft     = int-unid-neg-natur.sc-codigo   
                       tt-conta.sc-ipi-ft      = int-unid-neg-natur.sc-codigo
                       tt-conta.sc-cofins-ft   = int-unid-neg-natur.sc-codigo
                       tt-conta.sc-pis-ft      = int-unid-neg-natur.sc-codigo.
            END.
        END.
    END.

    RETURN "OK".
END PROCEDURE.
