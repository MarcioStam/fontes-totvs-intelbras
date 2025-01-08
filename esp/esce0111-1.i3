/********************************************************************************
**
**   Include: CE0111.i3 - Alterando o Modulo de Faturamento
**
********************************************************************************/

disable triggers for load of fat-ser-lote.
disable triggers for load of it-dep-fat.

if  param-global.modulo-ft then do:
    {utp/ut-liter.i Alterando_Faturamento... mce l}

    run pi-acompanhar in h-acomp (input trim (return-value)) .

    for each it-nota-fisc exclusive-lock
       where it-nota-fisc.it-codigo = item.it-codigo:

        assign it-nota-fisc.tipo-con-est = 3
               it-nota-fisc.cod-refer    = "".
    end.

    for each fat-ser-lote exclusive-lock
       where fat-ser-lote.it-codigo = item.it-codigo:

       for each b-fat-ser-lote no-lock
          where b-fat-ser-lote.cod-estabel = fat-ser-lote.cod-estabel
            and b-fat-ser-lote.serie       = fat-ser-lote.serie
            and b-fat-ser-lote.nr-nota-fis = fat-ser-lote.nr-nota-fis
            and b-fat-ser-lote.nr-seq-fat  = fat-ser-lote.nr-seq-fat
            and b-fat-ser-lote.it-codigo   = fat-ser-lote.it-codigo
            and b-fat-ser-lote.cod-depos   = fat-ser-lote.cod-depos
            and b-fat-ser-lote.cod-localiz = fat-ser-lote.cod-localiz
            and rowid(b-fat-ser-lote)     <> rowid(fat-ser-lote):

           do i-cont = 1 to 2:
               assign fat-ser-lote.qt-baixada[i-cont]
                          = fat-ser-lote.qt-baixada[i-cont]
                          + b-fat-ser-lote.qt-baixada[i-cont].
           end.

           find first b2-fat-ser-lote exclusive-lock
                where rowid(b2-fat-ser-lote) = rowid(b-fat-ser-lote) no-error.
                
           delete b2-fat-ser-lote validate(true,"").
       end.

       if item.tipo-con-est > 1
       and tt-param.lote <> "" then 
           assign fat-ser-lote.nr-serlote = tt-param.lote.
    end.        

    for each it-dep-fat exclusive-lock
       where it-dep-fat.it-codigo = item.it-codigo:

        for each b-it-dep-fat no-lock
           where b-it-dep-fat.cdd-embarq   = it-dep-fat.cdd-embarq
             and b-it-dep-fat.nr-resumo    = it-dep-fat.nr-resumo
             and b-it-dep-fat.nome-abrev   = it-dep-fat.nome-abrev
             and b-it-dep-fat.nr-pedcli    = it-dep-fat.nr-pedcli
             and b-it-dep-fat.it-codigo    = it-dep-fat.it-codigo
             and b-it-dep-fat.cod-depos    = it-dep-fat.cod-depos
             and b-it-dep-fat.cod-localiz  = it-dep-fat.cod-localiz
             and b-it-dep-fat.nr-sequencia = it-dep-fat.nr-sequencia
             and b-it-dep-fat.cod-estabel  = it-dep-fat.cod-estabel
             and b-it-dep-fat.nr-entrega   = it-dep-fat.nr-entrega
             and rowid (b-it-dep-fat)     <> rowid (it-dep-fat):

            assign it-dep-fat.qt-alocada = it-dep-fat.qt-alocada
                                         + b-it-dep-fat.qt-alocada.
            find first b2-it-dep-fat exclusive-lock
                 where rowid(b2-it-dep-fat) = rowid(b-it-dep-fat) no-error.
                 
            delete b2-it-dep-fat validate(true,"").
        end.

        if  item.tipo-con-est > 1
        and tt-param.lote <> "" then
            assign it-dep-fat.nr-serlote = tt-param.lote. /* a variavel c-lote terah conteudo qdo o item for 2, 3 ou 4.
                   Quando trocado de 2 ou 3 para 4 o c-lote fica em branco para que o lote nao seja alterado */

        if item.tipo-con-est = 1 then
            assign it-dep-fat.nr-serlote = "".

        assign it-dep-fat.cod-refer = "".
    end.

    for each it-pre-fat exclusive-lock
       where it-pre-fat.it-codigo = item.it-codigo:

        assign it-pre-fat.cod-refer = "".
    end.
end.
status input "".

/* fim include */
