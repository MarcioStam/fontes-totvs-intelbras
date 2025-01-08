
def input param pi-cod-estabel as char no-undo.
DEF INPUT PARAMETER c-cod-depos LIKE deposito.cod-depos.
def input parameter c-loc-ini       like item.cod-localiz.
def input parameter c-loc-fim       like item.cod-localiz   initial "zzzzzzzzzzzz".
def input parameter i-ge-ini        like item.ge-codigo     initial 00.
def input parameter i-ge-fim        like item.ge-codigo     initial 99.
def input parameter c-fm-ini        like item.fm-codigo     initial "".
def input parameter c-fm-fim        like item.fm-codigo     initial "zzzzzzzz".
def input parameter c-it-ini        like item.it-codigo     initial "".
def input parameter c-it-fim        like item.it-codigo     initial "zzzzzzzzzzzzzzzzzzzzzz".
def input parameter c-comprador-ini like item.cod-comprado  initial "".
def input parameter c-comprador-fim like item.cod-comprado  initial "ZZZZZZZZZZZZZ".
def input parameter l-ativo         AS LOGICAL .
def input parameter l-obsoleto-auto AS LOGICAL .
def input parameter l-obsoleto      AS LOGICAL .
def input parameter l-total         AS LOGICAL .
DEF INPUT PARAMETER i-mat           as INTEGER.
DEF OUTPUT PARAMETER de-total-dep AS DEC NO-UNDO.


def var de-val-unit     as dec.
def var de-val-mat      as dec.
def var de-val-mob      as dec.
def var de-val-ggf      as dec.

{esp/cep/escep003tt.i}

DEF OUTPUT PARAMETER TABLE FOR tt-itens. 

FIND deposito NO-LOCK
             WHERE deposito.cod-depos = c-cod-depos.



EMPTY TEMP-TABLE tt-itens.

/*     FIND FIRST param-estoq NO-LOCK NO-ERROR. */
/*    */
/*    for each saldo-estoq no-lock 
   where saldo-estoq.cod-estabel  = pi-cod-estabel
     and saldo-estoq.cod-depos    = c-cod-depos
     and saldo-estoq.cod-localiz >= c-loc-ini
     and saldo-estoq.cod-localiz <= c-loc-fim
     and saldo-estoq.it-codigo   >= c-it-ini
     and saldo-estoq.it-codigo   <= c-it-fim,
    each item no-lock
   where item.it-codigo     = saldo-estoq.it-codigo:
  */
   for each saldo-estoq no-lock 
       where saldo-estoq.cod-estabel  = pi-cod-estabel
         and saldo-estoq.cod-depos    = c-cod-depos
         and saldo-estoq.cod-localiz >= c-loc-ini
         and saldo-estoq.cod-localiz <= c-loc-fim
         and saldo-estoq.it-codigo   >= c-it-ini
         and saldo-estoq.it-codigo   <= c-it-fim
         AND saldo-estoq.qtidade-atu <> 0,
       EACH item-uni-estab
      WHERE item-uni-estab.cod-estabel = saldo-estoq.cod-estabel
        AND item-uni-estab.it-codigo   = saldo-estoq.it-codigo
        AND item-uni-estab.cod-comprado >= c-comprador-ini
        AND item-uni-estab.cod-comprado <= c-comprador-fim NO-LOCK,
       each item no-lock
           where item.it-codigo     = saldo-estoq.it-codigo
           AND   item.ge-codigo    >= i-ge-ini
           AND   item.ge-codigo    <= i-ge-fim
           AND   item.fm-codigo    >= c-fm-ini
           AND   item.fm-codigo    <= c-fm-fim
           AND  ((ITEM.cod-obsoleto = 1 AND l-ativo = YES)
           OR    (ITEM.cod-obsoleto = 2 AND l-obsoleto-auto = YES)
           OR    (ITEM.cod-obsoleto = 3 AND l-obsoleto = YES)
           OR    (ITEM.cod-obsoleto = 4 AND l-total = YES)):
/*      if saldo-estoq.qtidade-atu = 0 then next.

     IF ITEM.cod-obsoleto = 1 AND NOT l-ativo         THEN NEXT.
     IF ITEM.cod-obsoleto = 2 AND NOT l-obsoleto-auto THEN NEXT.
     IF ITEM.cod-obsoleto = 3 AND NOT l-obsoleto      THEN NEXT.
     IF ITEM.cod-obsoleto = 4 AND NOT l-total         THEN NEXT.

     IF item.ge-codigo    < i-ge-ini
     OR item.ge-codigo    > i-ge-fim        THEN NEXT.
     IF item.fm-codigo    < c-fm-ini
     OR item.fm-codigo    > c-fm-fim        THEN NEXT.
     IF item.cod-comprado < c-comprador-ini
     OR item.cod-comprado > c-comprador-fim THEN NEXT.
   */

/*
    FOR EACH grup-estoque NO-LOCK
        WHERE grup-estoque.ge-codigo >= i-ge-ini
        AND   grup-estoque.ge-codigo <= i-ge-fim,
        EACH ITEM NO-LOCK
            WHERE item.ge-codigo = grup-estoque.ge-codigo
            AND   item.it-codigo   >= c-it-ini
            and   ITEM.it-codigo   <= c-it-fim
            AND   item.fm-codigo   >= c-fm-ini
            AND   item.fm-codigo   <= c-fm-fim
            AND   item.cod-comprado >= c-comprador-ini
            AND   item.cod-comprado <= c-comprador-fim
            AND  ((ITEM.cod-obsoleto = 1 AND l-ativo = YES)
            OR    (ITEM.cod-obsoleto = 2 AND l-obsoleto-auto = YES)
            OR    (ITEM.cod-obsoleto = 3 AND l-obsoleto = YES)
            OR    (ITEM.cod-obsoleto = 4 AND  l-total = YES)),
        each saldo-estoq no-lock
            where saldo-estoq.cod-estabel  = pi-cod-estabel
            and saldo-estoq.cod-depos    = c-cod-depos
            AND saldo-estoq.it-codigo    = ITEM.it-codigo
            and saldo-estoq.cod-localiz >= c-loc-ini
            and saldo-estoq.cod-localiz <= c-loc-fim
            AND saldo-estoq.qtidade-atu <> 0:
  */        
         find tt-itens
              where tt-itens.it-codigo = saldo-estoq.it-codigo no-error.
         if not avail tt-itens then do:
             create tt-itens.
             assign tt-itens.it-codigo = saldo-estoq.it-codigo.
         end.
         assign tt-itens.quantidade = tt-itens.quantidade + saldo-estoq.qtidade-atu
                tt-itens.disponivel = tt-itens.disponivel + (saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped).
    end.
    assign de-total-dep = 0.
    for each tt-itens:
        find item no-lock 
            where item.it-codigo = tt-itens.it-codigo.
        
        /*******************   esp/es0012.i   *****************/
        assign de-val-unit = 0
               de-val-mat  = 0
               de-val-mob  = 0
               de-val-ggf  = 0.
                               
        FOR FIRST item-estab no-lock
            where item-estab.cod-estabel = pi-cod-estabel 
              and item-estab.it-codigo   = item.it-codigo:
           ASSIGN de-val-unit = item-estab.val-unit-mat-m[1]
                              + item-estab.val-unit-mob-m[1]
                              + item-estab.val-unit-ggf-m[1]
                  de-val-mat  = item-estab.val-unit-mat-m[1]
                  de-val-mob  = item-estab.val-unit-mob-m[1]
                  de-val-ggf  = item-estab.val-unit-ggf-m[1].
        END.

        /******************* fim esp/es0012.i ****************/
        assign tt-itens.descricao = item.desc-item
               tt-itens.cod-depos = c-cod-depos
               tt-itens.nome      = deposito.nome
                
               tt-itens.unit-mat  = item-estab.val-unit-mat-m[1]
               tt-itens.unit-mob  = item-estab.val-unit-mob-m[1]
               tt-itens.unit-ggf  = item-estab.val-unit-ggf-m[1]
               tt-itens.valor     = tt-itens.quantidade * de-val-unit

               /*tt-itens.valor     = tt-itens.quantidade * (de-val-mat + if i-mat = 2 then de-val-mob else 0)*/

               de-total-dep       = de-total-dep + tt-itens.valor.
   
    end.
