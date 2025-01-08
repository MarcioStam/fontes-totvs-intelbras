
{esp/es0024.i}
{esp/es0018.i}

 DEF input parameter raw-param as raw no-undo.
 def input parameter table for tt-raw-digita.

/*****************************************************************************
**
**   Programa:  es0887.p
**
**   Funcao:  calcular fator de internacao
**
**   Data:  02/09/2003
**
**   Autor:  Flavio Schoenell   - INTELBRAS S/A.
**
******************************************************************************/

/********** INCLUDES PADROES         ***************************************/   


/********** DEFINICAO DE VARIAVEIS   ****************************************/

def var c-mail as char.
def var c-embarque like embarque-imp.embarque.
def var c-endereco as char format "x(50)" initial "flavio@intelbras.com.br".
def var de-tot-peso as dec.
def var de-geral-rat as dec.
def var de-geral-fob as dec.
def var de-cotacao as dec.
def var de-tot-fob as dec.
def var de-tot-fob-1 as dec.
def var de-tot-invoice as dec.
def var de-tot-desp as dec.
def var c-comprador like item.cod-comprado.
def var i-emitente  like emitente.cod-emitente.
DEF VAR c-arquivo AS CHAR.
DEF VAR de-peso-liq AS DECIMAL NO-UNDO.

/********** DEFINICAO DE STREAMS     ****************************************/
/********** DEFINICAO DE TEMP-TABLES ****************************************/
def temp-table tt-fi
 field embarque like embarque-imp.embarque
 field it-codigo like item.it-codigo
 field numero-ordem like ordens-embarque.numero-ordem
 field parcela like ordens-embarque.parcela
 field fob as dec
 field peso as dec
 field perc as dec format ">>9.999999"
 field desp as dec
 field desp-rat as dec
 field fi as dec
 field data as date format "99/99/9999"
    INDEX codigo IS PRIMARY embarque it-codigo numero-ordem.

/********** DEFINICAO DE BUFFERS     ****************************************/
/********** DEFINICAO DE QUERYS      ****************************************/
/********** DEFINICAO DE BROWSES     ****************************************/
/********** DEFINICAO DE FORMS       ****************************************/
/********** ON ENTRY                 ****************************************/
/********** ON LEAVE                 ****************************************/
/********** ON RETURN                ****************************************/
/********** ON ANY-KEY               ****************************************/
/********** ON VALUE-CHANGED         ****************************************/
/********** ON ROW-ENTRY             ****************************************/
/********** ON GO (F1)               ****************************************/
/********** ON HELP (F2)             ****************************************/
/********** ON END-ERROR (F4)        ****************************************/
/********** ON GET (F5)              ****************************************/
/********** ON PUT (F6)              ****************************************/
/********** ON RECALL (F7)           ****************************************/
/********** ON CLEAR (F8)            ****************************************/

/********** CORPO DO PROGRAMA        ***************************************/  

EMPTY TEMP-TABLE tt-prog-ponto.

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

    ASSIGN c-arquivo = c-arquivo + "spool/calculo-fi.txt":U.
END.
ELSE DO:
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-arquivo = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
    END.

    IF SUBSTRING(c-arquivo, LENGTH(c-arquivo), 1) <> "~\":U THEN
        ASSIGN c-arquivo = c-arquivo + "~\":U.

    ASSIGN c-arquivo = c-arquivo + "spool~\calculo-fi.txt":U.
END.

output to VALUE(c-arquivo).

for each embarque-imp no-lock
   where embarque-imp.situacao = 2 :

    FIND FIRST fator-internacao NO-LOCK
        WHERE fator-internacao.embarque = embarque-imp.embarque NO-ERROR.
    IF AVAIL fator-internacao THEN NEXT.

    put "Embarque " embarque-imp.embarque skip(1).

    EMPTY TEMP-TABLE tt-fi.

    find first historico-embarque of embarque-imp no-lock.

    FIND FIRST itinerario NO-LOCK
         WHERE itinerario.cod-itiner = historico-embarque.cod-itiner.

    FIND FIRST historico-embarque NO-LOCK
         WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
           AND historico-embarque.embarque      = embarque-imp.embarque
           AND historico-embarque.cod-itiner    = itinerario.cod-itiner 
           AND historico-embarque.cod-pto-contr = itinerario.pto-chegada NO-ERROR. 
    IF NOT AVAIL historico-embarque THEN DO:
        FIND FIRST historico-embarque of embarque-imp 
             WHERE historico-embarque.cod-pto-contr = itinerario.pto-chegada.
    END.

    run pi-busca-cotacao(historico-embarque.dt-efetiva).

    assign de-tot-fob = 0
           de-tot-invoice = 0
           de-tot-fob-1 = 0
           de-tot-desp = 0
           de-tot-peso = 0.

    for each invoice-emb-imp no-lock of embarque-imp:
        assign de-tot-invoice = de-tot-invoice + invoice-emb-imp.vl-invoice.
    end.
    
    for each ordens-embarque no-lock of embarque-imp:
        find ordem-compra where ordem-compra.numero-ordem = 
        ordens-embarque.numero-ordem no-lock.
        assign c-comprador = ordem-compra.cod-comprado
               i-emitente = ordem-compra.cod-emitente.
    
        find first cotacao-item no-lock
             where cotacao-item.numero-ordem = ordens-embarque.numero-ordem
               and cotacao-item.cot-aprovada.
    
        find item no-lock
             where item.it-codigo = cotacao-item.it-codigo.
    
        ASSIGN de-peso-liq = ordens-embarque.peso-liquido NO-ERROR.
        IF de-peso-liq = 0 OR de-peso-liq = ? THEN
            ASSIGN de-peso-liq = item.peso-liquido * ordens-embarque.quantidade.

        assign de-tot-fob = de-tot-fob + cotacao-item.preco-fornec * ordens-embarque.qt-do-forn
               de-tot-peso = de-tot-peso + de-peso-liq.
    
        create tt-fi.
        assign tt-fi.embarque     = embarque-imp.embarque
               tt-fi.numero-ordem = ordens-embarque.numero-ordem
               tt-fi.parcela      = ordens-embarque.parcela
               tt-fi.it-codigo    = cotacao-item.it-codigo
               tt-fi.fob          = cotacao-item.preco-fornec * ordens-embarque.qt-do-forn 
               tt-fi.peso         = de-peso-liq /*item.peso-liquido * ordens-embarque.quantidade*/ 
               tt-fi.data         = historico-embarque.dt-efetiva.
    end.

    for each desp-embarque no-lock of embarque-imp
       where desp-embarque.cod-emitente-desp = i-emitente:
        assign de-tot-fob-1 = de-tot-fob-1 + desp-embarque.val-desp.
    end.

    assign de-tot-fob-1 = de-tot-fob-1 + de-tot-fob.
    if trunc(de-tot-invoice,0) <> trunc(de-tot-fob-1,0) then do:
        if trunc(de-tot-invoice / de-tot-fob-1,4) <> 1 then
        disp  embarque-imp.embarque
              embarque-imp.cod-conhecto-master
              de-tot-invoice format ">>>,>>>,>>9.999999"
              de-tot-fob format ">>>,>>>,>>9.999999"
              c-comprador with width 132.
    end.
    else do:

        for each desp-embarque no-lock of embarque-imp
           where desp-embarque.cod-emitente-desp <> i-emitente
              break by desp-embarque.mo-codigo:
    
            disp desp-embarque.cod-desp.
            find desp-imp of desp-embarque.
            disp desp-imp.descricao.
            disp desp-embarque.val-desp (total by mo-codigo)
                 desp-embarque.mo-codigo
                 de-cotacao
                 desp-embarque.val-desp / if mo-codigo = 0 then de-cotacao 
                 else 1 (total by mo-codigo) with width 132.
    
            if desp-embarque.mo-codigo = 1 then 
                assign de-tot-desp = de-tot-desp + desp-embarque.val-desp.
            else do:
                       assign de-tot-desp = de-tot-desp + 
                              desp-embarque.val-desp / de-cotacao.               
            end.
    
        end.

        put "Imposto de Importacao" skip (1).


        DEF VAR l-tem AS LOG.

        ASSIGN l-tem = NO.

        FOR EACH docum-est NO-LOCK
           WHERE docum-est.cod-emitente = i-emitente:

            ASSIGN l-tem = NO.

            IF  substring(docum-est.char-1,1,12) = embarque-imp.embarque  THEN
                ASSIGN l-tem = YES.

            IF NOT l-tem THEN NEXT.

            FOR EACH tt-fi
               WHERE tt-fi.embarque = embarque-imp.embarque:
                ASSIGN tt-fi.data = docum-est.dt-trans.
            END.

            for each docum-est-cex 
               where docum-est-cex.nro-docto    = string(docum-est.nro-docto)
                 and docum-est-cex.nat-operacao = docum-est.nat-operacao
                 and docum-est-cex.serie-docto  = docum-est.serie-docto
                 and docum-est-cex.cod-emitente = docum-est.cod-emitente:
                 for each item-doc-est-cex of docum-est-cex NO-LOCK
                    where item-doc-est-cex.cod-desp = 1:
                     disp  item-doc-est-cex.sequencia.
                     find item-doc-est 
                          where item-doc-est.nro-docto =   item-doc-est-cex.nro-docto
                            and item-doc-est.serie-docto = item-doc-est-cex.serie-docto    
                            and item-doc-est.nat-operacao = item-doc-est-cex.nat-operacao
                            and item-doc-est.cod-emitente = item-doc-est-cex.cod-emitente
                            and item-doc-est.sequencia = item-doc-est-cex.sequencia no-lock.
                     find FIRST tt-fi
                          where tt-fi.it-codigo = item-doc-est.it-codigo
                            and tt-fi.numero-ordem = item-doc-est.numero-ordem
                            and tt-fi.parcela = item-doc-est.parcela NO-ERROR.
                     IF AVAIL tt-fi THEN DO:
                         disp item-doc-est.nro-docto
                              item-doc-est.numero-ordem
                              item-doc-est.parcela
                              item-doc-est.it-codigo
                              item-doc-est-cex.val-desp (total) 
                              item-doc-est-cex.val-desp / de-cotacao (total) WITH WIDTH 132.

                        assign tt-fi.desp = tt-fi.desp + (item-doc-est-cex.val-desp / de-cotacao).
                     END.
                 end.
             end.
        END.
      /*
            IF l-tem = NO THEN DO:
                 FOR EACH docum-est NO-LOCK
                    WHERE docum-est.serie = "4"
                      AND docum-est.cod-emitente = i-emitente:
    
                       IF  substring(docum-est.char-1,1,12) = embarque-imp.embarque  THEN
                           ASSIGN l-tem = YES.
                 END.
            END.
        */
            /*
            find first docum-est 
                 where substring(docum-est.char-1,1,12) = embarque-imp.embarque 
                   AND docum-est.cod-estabel = "101"
                   AND docum-est.cod-emitente = i-emitente
                   AND docum-est.serie = "2" 
                       no-lock no-error.
            if not avail docum-est then do:
                
                
                find first docum-est 
                 where substring(docum-est.char-1,1,12) = embarque-imp.embarque 
                   AND docum-est.cod-estabel = "101"
                    AND docum-est.cod-emitente = i-emitente
                   AND docum-est.serie = "4" 
                       no-lock no-error.

                if not avail docum-est THEN NEXT.
                
            end. 
            
            */

/*
            IF NOT l-tem THEN NEXT.

            for each docum-est-cex 
               where docum-est-cex.nro-docto    = string(docum-est.nro-docto)
                 and docum-est-cex.nat-operacao = docum-est.nat-operacao
                 and docum-est-cex.serie-docto  = docum-est.serie-docto
                 and docum-est-cex.cod-emitente = docum-est.cod-emitente:
                 for each item-doc-est-cex of docum-est-cex no-lock:
                    /*where item-doc-est-cex.cod-desp = 1: */
                     disp  item-doc-est-cex.sequencia
                           item-doc-est-cex.cod-desp.
                     find item-doc-est 
                          where item-doc-est.nro-docto =   item-doc-est-cex.nro-docto
                            and item-doc-est.serie-docto = item-doc-est-cex.serie-docto    
                            and item-doc-est.nat-operacao = item-doc-est-cex.nat-operacao
                            and item-doc-est.cod-emitente = item-doc-est-cex.cod-emitente
                            and item-doc-est.sequencia = item-doc-est-cex.sequencia no-lock.
                     disp item-doc-est.numero-ordem
                          item-doc-est.parcela
                          item-doc-est-cex.val-desp (total) 
                          item-doc-est-cex.val-desp / de-cotacao (total).
                     find tt-fi
                          where tt-fi.it-codigo = item-doc-est.it-codigo
                            and tt-fi.numero-ordem = item-doc-est.numero-ordem
                            and tt-fi.parcela = item-doc-est.parcela.
                     assign tt-fi.desp = tt-fi.desp + (item-doc-est-cex.val-desp /                        de-cotacao).
                 end.
             end.
*/             
    end.    
    assign de-geral-rat = 0
           de-geral-fob = 0.

    for each tt-fi:
        assign tt-fi.perc = tt-fi.peso / de-tot-peso
               tt-fi.desp-rat = tt-fi.desp + 
                                (de-tot-desp * tt-fi.perc)
               tt-fi.fi        = (tt-fi.desp-rat + tt-fi.fob) / tt-fi.fob.
        assign de-geral-rat = de-geral-rat + tt-fi.desp-rat  
               de-geral-fob = de-geral-fob + tt-fi.fob.
    end.
                    
    for each tt-fi:
         find fator-internacao
              where fator-internacao.embarque     = tt-fi.embarque
                and fator-internacao.numero-ordem = tt-fi.numero-ordem
                and fator-internacao.parcela      = tt-fi.parcela no-error.
         if not avail fator-internacao then do:
             create fator-internacao.
             assign fator-internacao.embarque     = tt-fi.embarque
                    fator-internacao.numero-orde  = tt-fi.numero-ordem
                    fator-internacao.parcela      = tt-fi.parcela
                    fator-internacao.it-codigo    = tt-fi.it-codigo
                    fator-internacao.fi           = tt-fi.fi
                    fator-internacao.data         = tt-fi.data
                    fator-internacao.fi-geral     = 
                    (de-geral-rat + de-geral-fob) / de-geral-fob.

             IF fator-internacao.fi = 0 OR
                fator-internacao.fi = 1 THEN
                 ASSIGN fator-internacao.fi = fator-internacao.fi-geral.
         END.
    end.
end.

output close.

/********** PROCEDURES                 ***************************************/  
procedure pi-busca-cotacao.
def input parameter da-data as date.

find cotacao no-lock 
     where cotacao.mo-codigo   = 1
       and cotacao.ano-periodo = string(year(da-data),"9999") +
                                 string(month(da-data),"99")
     no-error.

if avail cotacao and cotacao.cotacao[day(da-data)] <> 0 then do:
   assign de-cotacao = cotacao.cotacao[day(da-data)].
end.
else
   assign de-cotacao = 1.

end.

