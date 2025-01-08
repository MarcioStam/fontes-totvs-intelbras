/************************************************************************
**
**  Include: escep041.i - Imprime as linhas do relat¢rio
**
************************************************************************/

assign c-ok = "".
if  tt-param.lista = 2 then do:
    if   val-apurado[3] <> ?

    or  (val-apurado[2] <> ?
    and (val-apurado[2]  = val-apurado[1]
    or  (val-apurado[2]  = qtidade-atu
         and param-estoq.cons-invent = 1) ))

    or  (val-apurado[1] <> ?
    and  val-apurado[1]  = qtidade-atu    
    and  param-estoq.cons-invent = 1)

    or  (val-apurado[3]  = ?
    and  val-apurado[2] <> ?
    and  not tt-param.contagem-3)

    or  (val-apurado[2]  = ?
    and  val-apurado[1] <> ?
    and  not tt-param.contagem-2)

    or  (val-apurado[1]  = ?
    and  not tt-param.contagem-1) then next.
end.
if  not tt-param.lista-qt
    and inventario.situacao <> 1
    and tt-param.lista       = 2 then do:
         
        disp inventario.nr-ficha
             item.it-codigo
             item.desc-item
             item.un
             inventario.cod-estabel
             inventario.cod-depos
             inventario.cod-localiz
             inventario.lote
             inventario.cod-refer
             with frame f-situacao2.
        down with frame f-situacao2.
        assign c-item-aux = item.it-codigo.
   
end.

/* Fim Include */
