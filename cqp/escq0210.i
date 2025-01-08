/****************************************************************************
**                                                                         **
**                                                                         **
**         ESCQ0210.I  -  Include para cria‡Æo do res-fic-cq                 **
**                                                                         **
**                                                                         **
****************************************************************************/

find ficha-cq no-lock where ficha-cq.nr-ficha = exam-ficha.nr-ficha no-error.

find {1}comp-exame where rowid({1}comp-exame) = r-comp-exame no-error.


if tt-resultado.origem = 1 then 
    find first res-fic-cq EXCLUSIVE-LOCK
         where res-fic-cq.nr-ficha  = ficha-cq.nr-ficha 
           and res-fic-cq.it-codigo = ficha-cq.it-codigo
           and res-fic-cq.cod-exame = exam-ficha.cod-exame
           and res-fic-cq.cod-comp  = it-comp-exame.cod-comp
           no-error.
else 
    find first res-fic-cq EXCLUSIVE-LOCK
         where res-fic-cq.nr-ficha  = ficha-cq.nr-ficha 
           and res-fic-cq.it-codigo = ficha-cq.it-codigo
           and res-fic-cq.cod-exame = exam-ficha.cod-exame
           and res-fic-cq.cod-comp  = comp-exame.cod-comp
           no-error.           


if  not avail res-fic-cq then do:
    
    create res-fic-cq.
    assign res-fic-cq.nr-ficha    = ficha-cq.nr-ficha
           res-fic-cq.it-codigo   = ficha-cq.it-codigo
           res-fic-cq.cod-exame   = exam-ficha.cod-exame
           res-fic-cq.dt-result   = today
           res-fic-cq.cod-resp    = exam-ficha.responsavel.
    
    assign res-fic-cq.cod-comp    = if tt-resultado.origem = 1 then it-comp-exame.cod-comp
                                                               else comp-exame.cod-comp.
    assign res-fic-cq.tipo-result = if tt-resultado.origem = 1 then it-comp-exame.tipo-result
                                                               else comp-exame.tipo-result.
    
    assign res-fic-cq.nr-tabela   = if tt-resultado.origem = 1 then it-comp-exame.nr-tabela
                                                               else comp-exame.nr-tabela.

       validate res-fic-cq.
       validate it-comp-exame. 
end.

