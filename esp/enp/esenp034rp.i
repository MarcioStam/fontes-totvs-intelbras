assign i-cont = i-cont + 1.

if valid-handle(h-acomp)
then run pi-acompanhar in h-acomp (input i-cont).

create tt-dados.
assign tt-dados.cod-estabel      = item-uni-estab.cod-estabel 
       tt-dados.it-codigo        = item-uni-estab.it-codigo  
       tt-dados.desc-item        = trim(item.desc-item)      
       tt-dados.nr-linha         = item-uni-estab.nr-linha   
       tt-dados.cod-cor          = int-item.cod-cor          
       tt-dados.cod-tipo-mp      = int-item.cod-tipo-mp      
       tt-dados.cod-modelo-placa = int-item.cod-modelo-placa 
       tt-dados.cod-tam-placa    = int-item.cod-tam-placa    
       tt-dados.cod-potencia     = int-item.cod-potencia.
