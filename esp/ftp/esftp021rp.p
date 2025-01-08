{include/i-prgvrs.i ESFTP021 2.04.00.001}
/***********************************************************************
**  Programa..: ESP\FTP\ESFTP002RP.P
**  Autor.....: Anderson Silvano - Gestech
**  Data......: Junho/2005 - Desenvolvimento
**  Descricao.: C lculo de estorno de ICMS
**              ConversÆo do programa es0545.p - 
**  VersÆo....: 001 14/06/2005
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp\ftp\esftp021tt.i}
{esp\ftp\esftp021a.i}

{utp/ut-glob.i}



{include/i-rpvar.i}
/****************************  Temp-Tables  ****************************/

def var de-tot          as int.
def var de-qtde         as int.
def var de-ipi          like item-doc-est.aliquota-ipi.
def var de-icms         like item-doc-est.aliquota-icm.
def var i-mat           like item.preco-base.
def var de-qt-fat       as dec.
def var l-exportacao    as log format "Sim/Nao".
def var d-data          as date.
def var de-tot-preco    as dec format ">>>>>9.9999".
def var de-tot-ipi      as dec format ">>>>>9.9999".
def var de-tot-val-ipi  as dec format ">>>>>9.9999".
def var de-tot-icms     as dec format ">>>>>9.9999".
def var de-tot-val-icms as dec format ">>>>>9.9999".

def temp-table tt-item
    field it-codigo like item.it-codigo
    field quantidade like estrutura.quant-usada
    field tem-nfe    as log
    index codigo is primary it-codigo.

def temp-table a
    field aliquota-ipi like item-doc-est.aliquota-ipi
    field qtde as int label "Qtde"
    index a is primary unique aliquota-ipi.
    
def temp-table b
    field aliquota-icm like item-doc-est.aliquota-icm
    field qtde as int label "Qtde"
    index a is primary unique aliquota-icm.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relatorio de Credito Presumido ICMS"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESFTP021"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}

    {include/i-rpout.i}

    for each tt-item:
        delete tt-item.
    end.
    for each a:
        delete a.
    end.
    for each b:
        delete b.
    end.

    run utp/ut-acomp.p persistent set h-acomp.  

    RUN pi-inicializar in h-acomp (input "Imprimindo...").

    for each estrutura no-lock
        where estrutura.it-codigo    = tt-param.c-it-codigo
          and estrutura.data-inicio <= tt-param.da-data
          and estrutura.data-termino > tt-param.da-data:
        find FIRST pr-it-per NO-LOCK
            where pr-it-per.it-codigo = estrutura.es-codigo NO-ERROR.

        find item NO-LOCK
            where item.it-codigo = estrutura.es-codigo NO-ERROR.
        
        if NOT AVAIL pr-it-per
        and not estrutura.fantasma then next. /* novo item sem movimento*/ 

        RUN pi-acompanhar IN h-acomp (INPUT "Item: " + estrutura.es-codigo).

        find tt-item
             where tt-item.it-codigo = estrutura.es-codigo no-error.
        if not avail tt-item then 
           create tt-item.
        assign tt-item.it-codigo  = estrutura.es-codigo
               tt-item.quantidade = tt-item.quantidade + estrutura.quant-usada.
        run pi-estrutura (estrutura.es-codigo,
                          estrutura.quant-usada,
                          da-data).
    end.
    assign de-qt-fat = 0.

    if c-periodo <> "" then do:
       do d-data = date(int(substr(c-periodo,1,2)),01,int(substr(c-periodo,3,4))) to
                   date(int(substr(c-periodo,1,2)) + 1,01,int(substr(c-periodo,3,4))) - 1:

       for each tt-ser-esp no-lock where tt-ser-esp.tipo,
           each nota-fiscal no-lock use-index ch-distancia
              where nota-fiscal.cod-estabel  = tt-param.cod-estabel
                and nota-fiscal.serie        = tt-ser-esp.codigo
                and nota-fiscal.dt-emis-nota = d-data
                and nota-fiscal.dt-cancela   = ?
                and nota-fiscal.nat-operacao begins "7",
              each it-nota-fisc of nota-fiscal no-lock where
                   it-nota-fisc.it-codigo = c-it-codigo:
              assign de-qt-fat = de-qt-fat + it-nota-fisc.qt-faturada[1]. 
          end.
       end.
    end.

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    if c-periodo <> "" then
       put "     Quant Faturada: " de-qt-fat SKIP.

    assign de-tot-preco = 0
           de-tot-ipi = 0
           de-tot-icms = 0
           de-tot-val-ipi = 0
           de-tot-val-icms = 0.

    for each tt-item 
        where tt-item.it-codigo begins "1"
        break by tt-item.it-codigo:
        for each a:
            delete a.
        end.
        for each b:
            delete b.
        end.

        assign de-tot = 0
               de-qtde = 0
               de-ipi  = 0
               de-icms = 0.

        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Item: " + tt-item.it-codigo).

    /* pegar as entradas do ultimo ano */
        for each item-doc-est no-lock 
            where item-doc-est.it-codigo = tt-item.it-codigo,
            each docum-est of item-doc-est no-lock
                 where docum-est.dt-trans >= today - 360:

            find a where a.aliquota-ipi = item-doc-est.aliquota-ipi
                 no-error.
            if not avail a then do:
               create a.
               assign a.aliquota-ipi = item-doc-est.aliquota-ipi.
            end.

            assign a.qtde = a.qtde + item-doc-est.quantidade
                   de-qtde = de-qtde + item-doc-est.quantidade.

            find b where 
                 b.aliquota-icm = item-doc-est.aliquota-icm no-error.
            if not avail b then do:
               create b.
               assign b.aliquota-icm = item-doc-est.aliquota-icm.
            end.
            assign b.qtde = b.qtde + item-doc-est.quantidade
                   tt-item.tem-nfe = yes.
        end.

        if not tt-item.tem-nfe then next.

        assign de-tot = 0.

        for each a break by a.aliquota-ipi:
            if last-of(a.aliquota-ipi) then do:
               assign de-ipi = de-ipi + (a.qtde * a.aliquota-ipi / 100).
            end.
        end.

        assign de-tot = 0.

        for each b break by b.aliquota-icm:
            if last-of(b.aliquota-icm) then do:
               assign de-icms = de-icms + (b.qtde * b.aliquota-icm / 100).
            end.
        end.

        find item NO-LOCK
             where item.it-codigo   = tt-item.it-codigo NO-ERROR.

        find pr-it-per 
             where pr-it-per.it-codigo = tt-item.it-codigo
               and month(pr-it-per.periodo) = month(da-data)
               and year(pr-it-per.periodo)  = year(da-data)
             no-lock no-error.
        if avail pr-it-per then 
           assign i-mat = pr-it-per.val-unit-mat-m[1] + pr-it-per.val-unit-mob-m[1].
        else 
           assign i-mat = item.vl-mat-ant + item.vl-mob-ant.

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-item.it-codigo NO-ERROR.

        disp tt-item.it-codigo format "X(07)" label "Item"
             " - "
             item.desc-item format "X(36)" no-label 
             with no-labels SIDE-LABELS STREAM-IO.

        for each a: 
            disp a WITH DOWN FRAME fa STREAM-IO.
            DOWN WITH FRAME fa.
        end.
        for each b:
            disp b WITH DOWN FRAME fb STREAM-IO.
            DOWN WITH FRAME fb.
        end.

        assign de-tot-preco = de-tot-preco + (i-mat + tt-item.quantidade).
        if de-qtde <> 0 then do:
           if de-ipi <> 0 then
              assign de-tot-ipi     = de-tot-ipi     + (de-ipi / de-qtde * i-mat * tt-item.quantidade)
                     de-tot-val-ipi = de-tot-val-ipi + ((((de-ipi / de-qtde) * i-mat) * tt-item.quantidade) * de-qt-fat).
           if de-icms <> 0 then
              assign de-tot-icms     = de-tot-icms     + (de-icms / de-qtde * i-mat * tt-item.quantidade)
                     de-tot-val-icms = de-tot-val-icms + ((((de-icms / de-qtde) * i-mat) * tt-item.quantidade) * de-qt-fat).
        end.

        disp tt-item.it-codigo                          format "X(07)"          label "Item"
             tt-item.quantidade                                                 label "QTD"
             i-mat * tt-item.quantidade                 format ">>>>>9.9999"    label "Preco"
             de-ipi / de-qtde * 100 when de-qtde <> 0   format ">>9.9999"       label "% IPI"
             de-ipi / de-qtde  *  i-mat * tt-item.quantidade when de-qtde <> 0  label "Valor IPI" format ">>>>>9.9999"
             (((de-ipi / de-qtde)  *  i-mat) * tt-item.quantidade) * de-qt-fat  when de-qtde <> 0 label "Valor IPI Qt" 
                                                                                                  format ">>>>>9.9999" 
             de-icms / de-qtde * 100 when de-qtde <> 0 and de-icms <> 0         format ">>9.9999" label "% ICMS"
             de-icms / de-qtde   * i-mat * tt-item.quantidade when de-qtde <> 0 label "Valor ICMS" format ">>>>>9.9999"
             (((de-icms / de-qtde) * i-mat) * tt-item.quantidade) * de-qt-fat when de-qtde <> 0    label "Valor ICMS Qt" 
                                                                                                   format ">>>>>9.9999"
             with width 132 frame f-dados STREAM-IO.
    end.

    /******** foi criado a rotina abaixo pois tem itens que sao ********/
    /******** industrializados e nao sera considerado o icms    ********/
    /******** ex. item 4085159 / es-codigo 1260529              ********/


    put "TOTAL DO RELATàRIO    " 
        de-tot-preco "          "
        de-tot-ipi "  "
        de-tot-val-ipi "          "
        de-tot-icms "   "
        de-tot-val-icms skip(2)
        "ITENS  SEM  NOTA  FISCAL  DE  ENTRADA " skip
        "===================================== " skip(2).

    for each tt-item 
        where tt-item.it-codigo begins "1"
          and not tt-item.tem-nfe
        break by tt-item.it-codigo:

        find ITEM where item.it-codigo = tt-item.it-codigo no-lock.

        find pr-it-per NO-LOCK 
             where pr-it-per.it-codigo = tt-item.it-codigo
               and month(pr-it-per.periodo) = month(da-data)
               and year(pr-it-per.periodo)  = year(da-data) no-error.
        if avail pr-it-per then 
           assign i-mat = pr-it-per.val-unit-mat-m[1] + pr-it-per.val-unit-mob-m[1].
        else 
           assign i-mat = item.vl-mat-ant + item.vl-mob-ant.

        disp tt-item.it-codigo          format "X(07)"          label "Item"
             item.desc-item             format "X(36)"          label "Descricao"
             tt-item.quantidade                                 label "QTD"
             i-mat * tt-item.quantidade format ">>>>>9.9999"    label "Preco"
             with width 132 STREAM-IO.
    end.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
end.

PROCEDURE pi-estrutura:
    def input parameter p-it-codigo  like item.it-codigo.
    def input parameter p-quantidade like estrutura.quant-usada.
    def input parameter p-data       as date.
    
    for each estrutura no-lock
       where estrutura.it-codigo    = p-it-codigo
         and estrutura.data-inicio <= p-data
         and estrutura.data-termino > p-data:
        find FIRST pr-it-per NO-LOCK
            where pr-it-per.it-codigo = estrutura.es-codigo NO-ERROR.
        find item  no-lock
             where item.it-codigo = estrutura.es-codigo.
        /* busca a pr-it-per para verificar se o item tem movimento - no magnus era item.val-unit-mat[1] = 0 */
        if NOT AVAIL pr-it-per then next. /* novo item sem movimento*/  

        RUN pi-acompanhar IN h-acomp (INPUT "Item: " + estrutura.es-codigo).

        find tt-item
             where tt-item.it-codigo = estrutura.es-codigo no-error.
        if not avail tt-item then create tt-item.
        assign tt-item.it-codigo  = estrutura.es-codigo
               tt-item.quantidade = tt-item.quantidade + (estrutura.quant-usada * p-quantidade).
        run pi-estrutura(estrutura.es-codigo,
                         estrutura.quant-usada * p-quantidade,
                         p-data).
    end.
END.

