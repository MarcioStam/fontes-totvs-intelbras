{include/i-prgvrs.i ESFTP005 2.04.00.001}
/***********************************************************************
**  Programa..: ESP\FTP\ESFTP005RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Notas Fiscais de Importacao
**              ConversÆo do programa es0624.p - Claudiney
**  VersÆo....: 001 15/11/2004
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ftp/esftp005tt.i}

{include/i-rpvar.i}
/****************************  Temp-Tables  ****************************/
def temp-table tt-class
    field ncm like item.class-fiscal
    field valor as dec format ">>,>>>,>>9.99"
    index codigo is primary ncm.
/****************************  Variaveis    ****************************/
def var de-ali-icm like  it-nota-fisc.aliquota-icm no-undo.
def var c-aliquotas  as character format "x(06)" no-undo.
def var de-tot-icm   as decimal  format ">>>>>>>>9.99"  init 0 no-undo.
def var de-tot-ipi   as decimal  format ">>>>>>>>9.99"  init 0 no-undo.
def var de-tot-ii    as decimal  format ">>>>>>>>9.99" init 0 no-undo.
def var de-tot-des   as decimal  format ">>>>>>>>9.99" init 0 no-undo.
def var de-tot-pis   as decimal  format ">>>>>>>>9.99" init 0 no-undo.
def var de-tot-cof   as decimal  format ">>>>>>>>9.99" init 0 no-undo.
def var de-tot-merc  as decimal format ">>>>>>>>>9.99" init 0 no-undo.
def var total-icm    as decimal format ">>>>>>>>>9.99" init 0 no-undo.
def var total-ipi    as decimal format ">>>>>>>>>9.99" init 0 no-undo.
def var total-ii     as decimal format ">>>>>>>>>9.99" init 0 no-undo.
def var de-tot-ger   as decimal format ">>>>>>>>>9.99" init 0 no-undo.
def var nota-deb as dec.
def var nota-cre as dec.
def var nota-deb-1 as dec initial 0.
def var c-nr-di      like embarque-imp.declaracao-imp.
def var c-emb        like embarque-imp.embarque.
def var v-aliq like docum-est.aliquota-icm init 0.
def var de-tot-1  as dec.
def var de-tot-2  as dec.
def var de-tot-3  as dec.
def var de-tot-4  as dec.
def var de-tot-5  as dec.
/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Notas Fiscais de Importacao"
       c-empresa      = if avail mgcad.empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESFTP005"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    run utp/ut-acomp.p persistent set h-acomp.  

    RUN pi-inicializar in h-acomp (input "Imprimindo...").
    RUN piImprimeRelat.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */

PROCEDURE piImprimeRelat:
        for each docum-est no-lock
            where docum-est.nat-operacao >= tt-param.NatOperacaoini
            and docum-est.nat-operacao  <= tt-param.NatOperacaofim
            and docum-est.cod-emitente  >= tt-param.CodEmitenteini
            and docum-est.cod-emitente  <= tt-param.CodEmitentefim
            and docum-est.dt-trans      >= tt-param.DtEmissaoIni
            and docum-est.dt-trans      <= tt-param.DtEmissaofim
            and docum-est.uf            >= tt-param.ufini
            and docum-est.uf            <= tt-param.uffim:
        RUN pi-acompanhar IN h-acomp (INPUT "Serie/Docto: " + "/" + 
                                      docum-est.serie-docto +
                                      string(docum-est.nro-docto)).
          find emitente where
            emitente.cod-emitente = docum-est.cod-emitente
            no-lock.

          assign de-tot-ii = 0
                 nota-deb  = 0
                 de-tot-pis = 0
                 de-tot-cof = 0.

          for each docum-est-cex
              where docum-est-cex.nro-docto = docum-est.nro-docto
              and docum-est-cex.serie-docto = docum-est.serie-docto
              and docum-est-cex.cod-emitente = docum-est.cod-emitente
              and docum-est-cex.nat-operacao  = docum-est.nat-operacao
              and docum-est-cex.cod-desp = 1:
            assign de-tot-ii = de-tot-ii + docum-est-cex.val-desp.
          end.


          find mgcex.embarque-imp
               where mgcex.embarque-imp.embarque = SUBSTRING(docum-est.char-1,1,12) no-lock no-error.

          if avail mgcex.embarque-imp then
          do:
            assign c-nr-di = mgcex.embarque-imp.declaracao-imp.
            if avail mgcex.embarque-imp then
            assign c-emb      = mgcex.embarque-imp.embarque.
            else
            assign c-emb      = "".

          end.
          else
          assign c-nr-di = ""
            c-emb   = "".

          if docum-est.tipo-docto = 2 /*no*/ then
          assign de-tot-icm = docum-est.icm-deb-cre.
          else
          assign  de-tot-icm = docum-est.icm-deb-cre.

          assign de-tot-icm = de-tot-icm +
            docum-est.icm-complem.
          assign v-aliq = docum-est.aliquota-icm.


          for each item-doc-est of docum-est no-lock:

            assign de-tot-pis = de-tot-pis + item-doc-est.valor-pis   
                   de-tot-cof = de-tot-cof + item-doc-est.val-cofins. 
            
            find tt-class
              where tt-class.ncm = item-doc-est.class-fiscal no-error.
            if not avail tt-class then
            do:
              create tt-class.
              assign tt-class.ncm = item-doc-est.class-fiscal.
            end.

            assign tt-class.valor = tt-class.valor + item-doc-est.preco-total[1].

            if item-doc-est.cd-trib-ipi = 1 /* "T" */ or
               item-doc-est.cd-trib-ipi = 4 /* "R" */ or
               item-doc-est.cd-trib-ipi = 3 /* "O" */ then
            do:

              if docum-est.tipo-docto = 2 /*no*/ then
              assign nota-cre = nota-cre + item-doc-est.valor-ipi[1]
                v-aliq = item-doc-est.aliquota-icm.
              else
              assign nota-deb = nota-deb + item-doc-est.valor-ipi[1].
              assign v-aliq = item-doc-est.aliquota-icm.
            end.

            if item-doc-est.it-codigo = " " then
            do:
              assign v-aliq = item-doc-est.aliquota-icm.
              find natur-oper of docum-est no-lock no-error.
              assign v-aliq = natur-oper.aliquota-icm.
            end.
            if item-doc-est.cd-trib-icm = 2 /* "I" */ then
            do:
              assign v-aliq = 0
                de-tot-ipi = 0.
            end.
            else
            do:
              assign v-aliq = item-doc-est.aliquota-icm.
            end.
          end.
          if docum-est.nat-operacao begins "197" or
             docum-est.nat-operacao begins "297" or
             docum-est.nat-operacao begins "191" or
             docum-est.nat-operacao begins "291" then
          do:
            assign de-tot-icm = 0
              v-aliq = 0.
          end.

          disp  docum-est.nro-docto     format "9999999"            label "Nr."
                docum-est.serie-docto                               label "Ser"
                docum-est.dt-trans      format "99/99/99"           label "Data"
                docum-est.cod-emitente                              label "Emitente"
                emitente.nome-abrev                                 label "Nome"
                docum-est.nat-operacao  format "999xxx"             label "Nat."
                docum-est.valor-mercad  format ">>>>>,>>>,>>9.99"   label "Valor Mercadoria" (total)
                v-aliq                                              label "% ICMS"
                de-tot-icm              format ">>>>>,>>>,>>9.99"   label "Val.ICMS"    (total)
                nota-deb                format ">>>>>,>>>,>>9.99"   label "Val.IPI"     (total)
                de-tot-ii               format ">>>>>,>>>,>>9.99"   label "Val. II"     (total)
                de-tot-pis              format ">>>>>,>>>,>>9.99"   label "Val. PIS"    (total)
                de-tot-cof              format ">>>>>,>>>,>>9.99"   label "Val. COF"    (total)
                nota-deb + de-tot-ii + de-tot-pis + de-tot-cof 
                                        format ">>>>>,>>>,>>9.99"   label "Val Imp"     (total)
                docum-est.tot-valor     format ">>>>>,>>>,>>9.99"   label "Valor Total" (total)
                c-nr-di                                             label "DI"
                c-emb                                               label "Embarque"
                WITH WIDTH 255 NO-LABELS STREAM-IO.
        end.

        put skip(1) "Resumo por NCM: " skip.

        for each tt-class:
          disp tt-class.ncm
               tt-class.valor (total).
        end.
END PROCEDURE.
