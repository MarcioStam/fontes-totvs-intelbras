/**
 * Extrator para BI
 * Fato: Saldo Estoque
 *
 * Autor: Hoepers - 01/12/2011
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/fact010btt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttFactSaldoEstoque.
define output parameter table for tt-erro.

define variable dt-data          as date        no-undo.
define variable dt-inicial       as date        no-undo.
define variable dt-final         as date        no-undo.
define variable dt-final-calc    as date        no-undo.
define variable dt-ult-movto     as date        no-undo.
define variable dt-ult-nfe       as date        no-undo.
define variable c-cod-depos      as character   no-undo.
define variable c-naturezas      as character   no-undo.
define variable cd-inventario    as integer     no-undo.
define variable c-cod-unid-negoc as character   no-undo.

/************************************************************************/

EMPTY TEMP-TABLE ttFactSaldoEstoque.

ASSIGN c-naturezas = "".
FOR EACH natur-oper NO-LOCK
   WHERE natur-oper.emite-duplic:
    IF c-naturezas = "" THEN
        ASSIGN c-naturezas = natur-oper.nat-operacao.
    ELSE
        ASSIGN c-naturezas = c-naturezas + "," + natur-oper.nat-operacao.
END.

RUN pi-le-periodo.

/* NÆo enviar registros com quantidade zerada */
FOR EACH   ttFactSaldoEstoque 
    WHERE  ttFactSaldoEstoque.NM_Qtidade_Atu < 1:
    DELETE ttFactSaldoEstoque.
END.


PROCEDURE pi-le-periodo:
    find first tt-param NO-ERROR.
    
    assign dt-inicial    = date(month(tt-param.dt-inicial), 1, year(tt-param.dt-inicial))
           dt-final      = date(month(tt-param.dt-final), 1, year(tt-param.dt-final))
           dt-inicial    = add-interval(dt-inicial, 1, 'months') - 1
           dt-final      = add-interval(dt-final,   1, 'months') - 1
           dt-data       = dt-inicial
           dt-final-calc = dt-final.
    
    /** Gambi **/
    if dt-final > today then
       assign dt-final = today.
    
    repeat while dt-data <= dt-final:
       run pi-le-saldo.
    
       assign dt-data = date(month(dt-data), 1, year(dt-data))
              dt-data = add-interval(dt-data, 2, 'months') - 1.
    end.
    
    /** Se a data final tem que ser today, extrai s¢ isso aqui **/
    if (dt-final = today) and (dt-final-calc <> today) 
    then do:
       assign dt-data = today.
       run pi-le-saldo.
    end.

END PROCEDURE.


PROCEDURE pi-le-saldo:

    IF  MONTH(dt-data) = MONTH(TODAY) AND
         YEAR(dt-data) =  YEAR(TODAY)
    THEN DO:
        FOR EACH  saldo-estoq NO-LOCK 
            WHERE saldo-estoq.qtidade-atu > 0:

            RUN pi-gera-tt (INPUT saldo-estoq.cod-estabel,
                            INPUT saldo-estoq.cod-depos,
                            INPUT saldo-estoq.it-codigo,
                            INPUT saldo-estoq.qtidade-atu,
                            INPUT saldo-estoq.qt-alocada, 
                            INPUT saldo-estoq.qt-aloc-ped).
        END.
    END.
    ELSE DO:
        FOR EACH  sl-it-per NO-LOCK
            WHERE sl-it-per.periodo = dt-data:

            RUN pi-gera-tt (INPUT sl-it-per.cod-estabel,
                            INPUT sl-it-per.cod-depos,
                            INPUT sl-it-per.it-codigo,
                            INPUT sl-it-per.quantidade,
                            INPUT 0,
                            INPUT 0).
        END.
    END.
END PROCEDURE.


PROCEDURE pi-gera-tt:
    DEF INPUT PARAM p-cod-estabel    AS CHAR                     NO-UNDO.
    DEF INPUT PARAM p-cod-depos      AS CHAR                     NO-UNDO.
    DEF INPUT PARAM p-it-codigo      AS CHAR                     NO-UNDO.
    DEF INPUT PARAM p-qtd-item     LIKE saldo-estoq.qtidade-atu  NO-UNDO.
    DEF INPUT PARAM p-qtd-alocada  LIKE saldo-estoq.qt-alocada   NO-UNDO.
    DEF INPUT PARAM p-qtd-aloc-ped LIKE saldo-estoq.qt-aloc-ped  NO-UNDO.

    assign p-cod-estabel = fn-free-accent(upper(trim(p-cod-estabel)))
           p-cod-depos   = fn-free-accent(upper(trim(p-cod-depos)))
           p-it-codigo   = fn-free-accent(upper(trim(p-it-codigo))).

    /* Criar Unidade Neg¢cio do Item */
    FIND ITEM NO-LOCK 
        WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    find item-uni-estab no-lock
        where item-uni-estab.it-codigo   = item.it-codigo
          and item-uni-estab.cod-estabel = p-cod-estabel no-error.

    assign c-cod-unid-negoc = fn-free-accent(upper(trim(if avail item-uni-estab then item-uni-estab.cod-unid-negoc else 'INV'))).
    
    find ttFactSaldoEstoque
        where ttFactSaldoEstoque.CD_Estabelecimento = p-cod-estabel
          and ttFactSaldoEstoque.CD_Deposito        = p-cod-depos
          and ttFactSaldoEstoque.CD_Item            = p-it-codigo
          and ttFactSaldoEstoque.CD_Unidade_Negocio = c-cod-unid-negoc
          AND ttFactSaldoEstoque.DT_Posicao         = dt-data no-error.

    IF  NOT AVAIL(ttFactSaldoEstoque) 
    then do:
        create ttFactSaldoEstoque.
        assign ttFactSaldoEstoque.CD_Estabelecimento     = p-cod-estabel
               ttFactSaldoEstoque.CD_Deposito            = p-cod-depos  
               ttFactSaldoEstoque.CD_Item                = p-it-codigo  
               ttFactSaldoEstoque.CD_Unidade_Negocio     = upper(c-cod-unid-negoc)
               ttFactSaldoEstoque.DT_Posicao             = dt-data
               ttFactSaldoEstoque.DT_Ultima_Movimentacao = ?
               ttFactSaldoEstoque.DT_Ultima_NFE          = ?.

        RUN pi-busca-ultimo-movto (INPUT p-cod-estabel,
                                   INPUT p-cod-depos,
                                   INPUT p-it-codigo).

        ASSIGN ttFactSaldoEstoque.DT_Ultima_Movimentacao = dt-ult-movto
               ttFactSaldoEstoque.DT_Ultima_NFE          = dt-ult-nfe
               ttFactSaldoEstoque.CD_Inventario          = cd-inventario.

        find item-estab no-lock
           where item-estab.cod-estabel = p-cod-estabel
             and item-estab.it-codigo   = p-it-codigo no-error.

        FIND pr-it-per NO-LOCK
           WHERE  pr-it-per.it-codigo   = p-it-codigo
             AND  pr-it-per.cod-estabel = p-cod-estabel
             AND  pr-it-per.periodo     = dt-data NO-ERROR.


        IF  YEAR(dt-data) <> YEAR(TODAY)
        THEN DO:
            IF  AVAIL pr-it-per
            THEN
                ASSIGN ttFactSaldoEstoque.NM_Valor_Medio = pr-it-per.val-unit-mat-m[1] + pr-it-per.val-unit-mob-m[1] + pr-it-per.val-unit-ggf-m[1].

            IF  ttFactSaldoEstoque.NM_Valor_Medio = 0 AND
                AVAIL item-estab
            THEN
                ASSIGN ttFactSaldoEstoque.NM_Valor_Medio = item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1].
        END.
        ELSE DO:
            IF  MONTH(dt-data) <> MONTH(TODAY)
            THEN DO:
                IF  AVAIL pr-it-per
                THEN
                    ASSIGN ttFactSaldoEstoque.NM_Valor_Medio = pr-it-per.val-unit-mat-m[1] + pr-it-per.val-unit-mob-m[1] + pr-it-per.val-unit-ggf-m[1].

                IF  ttFactSaldoEstoque.NM_Valor_Medio = 0 AND
                    AVAIL item-estab
                THEN
                    ASSIGN ttFactSaldoEstoque.NM_Valor_Medio = item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1].
            END.
            ELSE
                IF  AVAIL item-estab
                THEN
                    ASSIGN ttFactSaldoEstoque.NM_Valor_Medio = item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1].
        END.

        IF  ttFactSaldoEstoque.NM_Valor_Medio = 0 AND
            AVAIL item-estab
        THEN
            ASSIGN ttFactSaldoEstoque.NM_Valor_Medio = item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1].
    end.

    assign ttFactSaldoEstoque.NM_Qtidade_Atu       = ttFactSaldoEstoque.NM_Qtidade_Atu      + p-qtd-item
           ttFactSaldoEstoque.NM_Qtidade_Alocada   = ttFactSaldoEstoque.NM_Qtidade_Alocada  + p-qtd-alocada
           ttFactSaldoEstoque.NM_Qtidade_Aloc_Ped  = ttFactSaldoEstoque.NM_Qtidade_Aloc_Ped + p-qtd-aloc-ped.

END PROCEDURE.


PROCEDURE pi-busca-ultimo-movto:
    DEF INPUT PARAM p-cod-estabel AS CHAR NO-UNDO.
    DEF INPUT PARAM p-cod-depos   AS CHAR NO-UNDO.
    DEF INPUT PARAM p-it-codigo   AS CHAR NO-UNDO.

    assign dt-ult-movto  = ?
           dt-ult-nfe    = ?
           cd-inventario = 0. 

    find last movto-estoq NO-LOCK
        where movto-estoq.it-codigo    = p-it-codigo 
          and movto-estoq.cod-estabel  = p-cod-estabel
          and movto-estoq.dt-trans    <= dt-data
          and (movto-estoq.esp-docto   = 28            /* REQ   */
           or (movto-estoq.esp-docto   = 23            /* NFT   */    
          AND  movto-estoq.tipo-trans  = 2)            /* Sa¡da */
           OR (movto-estoq.esp-docto   = 30 AND ITEM.ge-codigo = 30) /* RM  */   
           or (movto-estoq.esp-docto   = 22 AND (LOOKUP(movto-estoq.nat-operacao,c-naturezas) <> 0)
           OR movto-estoq.cod-depos                         = "SUC")) /* NFS */
          AND movto-estoq.quantidade   > 0 NO-ERROR.

    IF  AVAIL movto-estoq
    THEN
        ASSIGN dt-ult-movto = movto-estoq.dt-trans.

    RELEASE movto-estoq.
    find first movto-estoq NO-LOCK
         where movto-estoq.it-codigo   = p-it-codigo
           and movto-estoq.cod-estabel = p-cod-estabel
           and movto-estoq.dt-trans   <= dt-data
           and movto-estoq.esp-docto  <> 33 /* <> transferencia*/
           and movto-estoq.quantidade  > 0
           and movto-estoq.tipo-trans  = 1 no-error.

    IF  AVAIL movto-estoq
    THEN DO:
        ASSIGN dt-ult-nfe = movto-estoq.dt-trans.

        IF  movto-estoq.esp-docto = 15 /* invent rio    */ 
        THEN
            ASSIGN cd-inventario = 1.
        ELSE
            ASSIGN cd-inventario = 0.
    END.

END PROCEDURE.
