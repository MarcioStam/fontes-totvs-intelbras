/***********************************************************************
**  Programa..: upc\im0100-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  VersÆo....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

/* {utp/ut-glob.i} */

/*{cxbo/bocx220c.i tt-item-doc-est}*/
define temp-table tt-item-doc-est no-undo
    field numero-ordem             like ordens-embarque.numero-ordem
    field parcela                  like ordens-embarque.parcela
    field sequencial               as   integer
    field it-codigo                like item.it-codigo
    field nr-proc-imp              like ordens-embarque.nr-proc-imp
    field quantidade               like ordens-embarque.quantidade
    field lote                     like item-doc-est.lote           
    field dt-vali-lote             like item-doc-est.dt-vali-lote
    field cod-refer                like item-doc-est.cod-refer
    field tipo-con-est             as   integer
    field encerra-pa               like item-doc-est.encerra-pa
    field situacao                 as   logical
    field quant-total              like ordens-embarque.quantidade
    field r-rowid                  as   rowid
    field class-fiscal             like classif-fisc.class-fiscal
    field nat-fiscal               like natur-oper.nat-operacao  /* CAMPO NOVO - MULTIPLAS NATUREZAS */
    field nr-ato-concessorio       as   char format "x(20)"
    field preco-unit               like item-doc-est.preco-unit  extent 0 
    field preco-unit-mo            like item-doc-est.preco-unit  extent 0
    field preco-total              like item-doc-est.preco-total extent 0
    field preco-total-mo           like item-doc-est.preco-total extent 0
    field desconto                 like item-doc-est.desconto    extent 0
    field num-pedido               like pedido-compr.num-pedido
    field tp-despesa               like ordem-compra.tp-despesa
    field cod-depos                like ordem-compra.dep-almoxar
    field peso-bruto               as   decimal format ">>>,>>>,>>9.99999"
    field peso-liquido             as   decimal format ">>>,>>>,>>9.99999"
    field val-cub-tot              as   dec format ">>>>>,>>>,>>9.999999"
    field cod-lote-fabrican        like item-doc-est.cod-lote-fabrican
    field dat-fabricc-lote         like item-doc-est.dat-fabricc-lote
    field dat-valid-lote-fabrican  like item-doc-est.dat-valid-lote-fabrican
    field nom-fabrican             like item-doc-est.nom-fabrican
    field val-cub-uni              as   dec format ">>>>>,>>>,>>9.999999"
    field cd-trib-ii               as   integer
    field cd-trib-ipi              as   integer
    field cd-trib-icms             as   integer
    field aliquota-ii              as   decimal format ">>9.99"
    field aliquota-ipi             as   decimal format ">>9.99"
    field aliquota-icms            as   decimal format ">>9.99"
    field l-regime                 as   logical
    field l-ordens-embarque        as   logical
    field un                       as   character
    field qtd-do-forn              as   decimal format ">>>>,>>9.9999"
    field un-fornec                as   character
    field suspensao-II             as   logical
    field suspensao-IPI            as   logical
    field l-selecionado            as   logical /* campo incluso para filtrar o browse da tela do im0100a */
    field l-gera-prim-nf-remes-mae as   logical
    index ordem is primary unique
          numero-ordem 
          parcela 
          sequencial.

{esp/es0018.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-query         AS HANDLE      NO-UNDO. /* Query */
DEFINE VARIABLE h-field         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-buffer        AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-browse        AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-objeto AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-it-codigo    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-numero-ordem AS INTEGER     NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

IF p-ind-event = "BEFORE-OPEN-BROWSE" THEN DO:
    run pi-busca-handle (input p-wgh-frame,
                         input p-ind-event,
                         input 'browse':U,
                         input 'browse-1':U,
                         input no,
                         output h-browse).

    /* Handle da query e do buffer */
    assign
        h-query         = h-browse:query
        h-buffer        = h-query:get-buffer-handle(1).

    /* Prepara a query e a abre */
    h-query:query-prepare('for each tt-item-doc-est').
    h-query:query-open().

    do while not h-query:query-off-end:
       assign
            h-field        = h-buffer:buffer-field("numero-ordem")
            i-numero-ordem = INT(h-field:buffer-value)
            h-field        = h-buffer:buffer-field("it-codigo")
            c-it-codigo    = h-field:BUFFER-VALUE.

       FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = c-it-codigo NO-ERROR.
       IF AVAIL ITEM THEN DO:
          IF item.tipo-con-est = 3 THEN DO: /* Item Controlado por Lote */
             FIND FIRST in-grup-estoq NO-LOCK
                  WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo NO-ERROR.
             IF in-grup-estoq.log-ckd = YES THEN DO: /* CKD */
                FIND FIRST ordem-compra NO-LOCK
                     WHERE ordem-compra.numero-ordem = i-numero-ordem NO-ERROR.
                IF AVAIL ordem-compra THEN DO:
                    RUN esp/es0018p.p (INPUT "CKD-PO", /* Nome do programa */
                                       INPUT 1,        /* Ponto do programa */
                                       INPUT 0,
                                       INPUT "",
                                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
                    IF CAN-FIND (FIRST tt-prog-ponto
                                 WHERE tt-prog-ponto.conteudo = ordem-compra.cod-estabel) THEN DO:
                       assign h-field = h-buffer:buffer-field("lote").
                       IF h-field:buffer-value = "" THEN DO:
                          ASSIGN h-field:buffer-value = "PO" + STRING(ordem-compra.num-pedido).
                       END.
                    END.
                    ELSE DO:
                       assign h-field = h-buffer:buffer-field("lote").
                       IF h-field:buffer-value = "" THEN DO:
                          ASSIGN h-field:buffer-value = "GENERICO".
                       END.
                    END.
                END.
             END.
             ELSE DO:
                assign h-field = h-buffer:buffer-field("lote").
                IF h-field:buffer-value = "" THEN DO:
                   ASSIGN h-field:buffer-value = "GENERICO".
                END.
             END.

             assign h-field = h-buffer:buffer-field("dt-vali-lote").
             IF h-field:buffer-value = ? THEN DO:
                ASSIGN h-field:buffer-value = "31/12/9999".
             END.
          END.

       END.
       h-query:get-next().
    END.
END.

IF p-ind-event = "BEFORE-CLICK-BTOK" THEN DO:  

    RUN pi-envia-tt-item-doc-est IN p-wgh-object (OUTPUT TABLE tt-item-doc-est).

    FOR EACH tt-item-doc-est:
        ASSIGN tt-item-doc-est.situacao = YES.
    END.

    RUN pi-recebe-tt-item-doc-est IN p-wgh-object (INPUT TABLE tt-item-doc-est).

end. 

procedure pi-busca-handle:
    def input  param pWghFrame  as widget-handle    no-undo.
    def input  param pIndEvent  as char             no-undo.
    def input  param pObjType   as char             no-undo.
    def input  param pObjName   as char             no-undo.
    def input  param pApresMsg  as log              no-undo.
    def output param phObj      as handle           no-undo.

    def var h-aux as handle no-undo.

    define variable wgh-obj     as widget-handle    no-undo.
    
    assign wgh-obj = pWghFrame:first-child.

    do while valid-handle(wgh-obj):
        if pApresMsg then
            message
                "Nome do Objeto " wgh-obj:name skip
                "Type do Objeto " wgh-obj:type skip
                "P-Ind-Event    " pIndEvent
                view-as alert-box.

        if wgh-obj:type =   pObjType    and
           wgh-obj:name =   pObjName    then do:
            assign phObj = wgh-obj:handle.
            leave.
        end.

        if wgh-obj:type = "field-group"  then
            assign wgh-obj = wgh-obj:first-child.
        else if wgh-obj:type = "frame" then do:
            run pi-busca-handle (input wgh-obj,
                                 input p-ind-event,
                                 input pObjType,
                                 input pObjName,
                                 input pApresMsg,
                                 output phObj).
            if valid-handle(phObj) then
                return.
            else
                assign wgh-obj = wgh-obj:next-sibling.


        end.
        else
            assign wgh-obj = wgh-obj:next-sibling.
    end.
end procedure.







