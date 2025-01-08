if movto-estoq.nr-ord-prod = 0 or
   movto-estoq.nr-ord-prod = ? then next.

IF CAN-FIND (FIRST tt-digita WHERE 
            tt-digita.it-codigo = movto-estoq.it-codigo) THEN NEXT.

run pi-acompanhar in h-acomp (input "Item " + movto-estoq.it-codigo).

find item NO-LOCK where item.it-codigo = movto-estoq.it-codigo no-error.
if movto-estoq.it-codigo begins "108" or 
   movto-estoq.it-codigo begins "102" or
   movto-estoq.it-codigo begins "138" or
   movto-estoq.it-codigo begins "107" or
   movto-estoq.it-codigo begins "220" OR
   movto-estoq.it-codigo BEGINS "5"   OR
   movto-estoq.it-codigo BEGINS "602" OR /* Mem¢rias */
   movto-estoq.it-codigo BEGINS "308" OR /* Placas */
   movto-estoq.it-codigo BEGINS "302" OR /* CKD */
  (item.ge-codigo <> 10 and
   item.ge-codigo <> 12) then do:
   create tt-itens-erro.
   assign tt-itens-erro.it-codigo = movto-estoq.it-codigo
          tt-itens-erro.cod-estabel = movto-estoq.cod-estabel                    
          tt-itens-erro.cod-depos = movto-estoq.cod-depos
          tt-itens-erro.cd-erro   = 0
          tt-itens-erro.mensagem  = "Item/GE n∆o pode gerar perdas.".     
   
end.                

assign l-congelado = no.

run congelado(input movto-estoq.it-codigo,
              input movto-estoq.cod-depos,
              input "").            

if l-congelado then do:
    create tt-itens-erro.
    assign tt-itens-erro.it-codigo = movto-estoq.it-codigo
           tt-itens-erro.cod-estabel = movto-estoq.cod-estabel                    
           tt-itens-erro.cod-depos = movto-estoq.cod-depos
           tt-itens-erro.cd-erro   = 17567
           tt-itens-erro.mensagem  = "Item/Dep¢sito/Localizaá∆o Congelado para Invent†rio.".
end.                               

if can-find (first tt-itens-erro
             where tt-itens-erro.cod-estabel = movto-estoq.cod-estabel
               and tt-itens-erro.cod-depos   = movto-estoq.cod-depos
               and tt-itens-erro.it-codigo   = movto-estoq.it-codigo) then next.

if can-find(first b-movto-estoq no-lock
            where b-movto-estoq.cod-estabel = movto-estoq.cod-estabel
              and b-movto-estoq.esp-docto   = movto-estoq.esp-docto
              and b-movto-estoq.dt-trans    = movto-estoq.dt-trans
              and b-movto-estoq.it-codigo   = movto-estoq.it-codigo
              and b-movto-estoq.serie-docto = "RP2"
              and b-movto-estoq.cod-depos   = movto-estoq.cod-depos) then next.            

ASSIGN c-sc-codigo   = ""
       c-ct-codigo   = ""
       de-perc-perda = 0.

FIND FIRST movto-ggf
     WHERE movto-ggf.nr-ord-prod = movto-estoq.nr-ord-prod NO-LOCK NO-ERROR.
IF not AVAIL movto-ggf THEN do:
    create tt-itens-erro.
    assign tt-itens-erro.it-codigo = movto-estoq.it-codigo
           tt-itens-erro.cod-estabel = movto-estoq.cod-estabel                    
           tt-itens-erro.cod-depos = movto-estoq.cod-depos
           tt-itens-erro.cd-erro   = 17567
           tt-itens-erro.mensagem  = "Nao encontrado GGF para a OP " + string(movto-estoq.nr-ord-prod) + ". - Procure o departamento de Controladoria.".
    next.
end.
ASSIGN c-sc-codigo = movto-ggf.sc-cr-ggf[1].


for each tt-prog-ponto:

    if entry(1, tt-prog-ponto.conteudo,";") = movto-estoq.cod-estabel and
       entry(2, tt-prog-ponto.conteudo,";") = c-sc-codigo then do:
       
        assign c-ct-codigo   = ENTRY(3, tt-prog-ponto.conteudo,";")
               de-perc-perda = DEC(entry(4, tt-prog-ponto.conteudo,";")).
        leave.
        
    end.    
    
end.           


find first tt-itens
     where tt-itens.cod-estabel = movto-estoq.cod-estabel
       and tt-itens.cod-depos   = movto-estoq.cod-depos
       and tt-itens.it-codigo   = movto-estoq.it-codigo
       AND tt-itens.ct-codigo   = c-ct-codigo
       and tt-itens.sc-codigo   = c-sc-codigo
       and tt-itens.dt-trans    = movto-estoq.dt-trans no-error.         
if not avail tt-itens then do:                
    create tt-itens.
    assign tt-itens.it-codigo  = movto-estoq.it-codigo
           tt-itens.dt-trans   = movto-estoq.dt-trans
           tt-itens.desc-item  = item.desc-item
           tt-itens.un         = item.un
           tt-itens.cod-depos  = movto-estoq.cod-depos
           tt-itens.cod-estabel = movto-estoq.cod-estabel
           tt-itens.ct-codigo   = c-ct-codigo
           tt-itens.sc-codigo   = c-sc-codigo
           tt-itens.perc-perda  = de-perc-perda.
end.

if movto-estoq.esp-docto = 28 then  /* REQ */
    assign tt-itens.quantidade = tt-itens.quantidade + movto-estoq.quantidade.
if movto-estoq.esp-docto = 31 then  /* RRQ */
    assign tt-itens.quantidade = tt-itens.quantidade - movto-estoq.quantidade.
