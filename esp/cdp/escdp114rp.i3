procedure pi-procedimento-03:
    form item.it-codigo         format "x(16)" column-label "Item"
         operacao.op-codigo     format ">>>>9" column-label "Oper"
         operacao.descricao     format "x(34)" column-label "Descri‡Æo"
         grup-maquina.gm-codigo format "x(9)"  column-label "Grupo Maq"
         with width 80 down no-box stream-io frame f-03.

    assign i-cont         = 0
           c-arquivo      = tt-param.diretorio + "operacoes-em-gm-desativados.txt"
           c-titulo-relat = "It ativ c/ Oper em Gr Maq desativ".

    if valid-handle(h-acomp)
    then do:
         run pi-seta-titulo in h-acomp (input "Itens ativ c/ Oper ativas em Gr Maq desativ...").
         run pi-acompanhar  in h-acomp (input 0).
    end.

    output stream st-relat to value(c-arquivo) paged page-size 64 convert target "iso8859-1".

    view stream st-relat frame f-cabec-80.
    view stream st-relat frame f-rodape-80.

    for each item fields(it-codigo) no-lock
       where item.it-codigo   <> ""
         and item.cod-obsoleto = 1,
        each operacao fields(op-codigo descricao) no-lock
       where operacao.it-codigo     = item.it-codigo
         and operacao.data-termino >= today,
       first grup-maquina fields(gm-codigo) no-lock
       where grup-maquina.gm-codigo = operacao.gm-codigo
         and grup-maquina.log-1:
        assign i-cont = i-cont + 1.

        if  i-cont mod 10 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        disp stream st-relat
             item.it-codigo
             operacao.op-codigo
             operacao.descricao
             grup-maquina.gm-codigo
             with frame f-03.
        down stream st-relat with frame f-03.
    end. /* for each item */

    output stream st-relat close.

    if valid-handle(h-wprog)
    then run OpenDocument in h-wprog (input c-arquivo). 

    return "OK".
end procedure. /* procedure pi-procedimento-03 */
