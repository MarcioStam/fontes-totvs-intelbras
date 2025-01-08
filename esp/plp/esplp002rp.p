/*
    Programa: esplp002rp.p
    Objetivo: Importaá∆o de Plano de Produá∆o
    Autor: Osnir Ribeiro Jr - Intelbras
*/    
{include/i-prgvrs.i ESPLP002RP}  /*** 010001 ***/

{utp/ut-glob.i}

{esp/plp/esplp002tt.i}

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp            as handle  no-undo.

{cdp/cd0666.i} /* definiá∆o da temp-table de erros */   

form tt-erro.cd-erro "-"   
     tt-erro.mensagem format "x(117)"
     with width 132 frame f-erros stream-io. 

{utp/ut-liter.i Erro *}
assign tt-erro.cd-erro:label in frame f-erros = trim(return-value).

{utp/ut-liter.i Descriá∆o *}
assign tt-erro.mensagem:label in frame f-erros = trim(return-value).     

def stream s-entrada.
def var c-linha          as character.
def var i-cont           as integer.
def var l-cabec          as logical.
def var l-num-automatica as log initial no.
def var l-erro           as log.
def var c-text-aux       as char no-undo.
def var i-seq-aux        as int no-undo init 0.

def var c-cod-estab  like pl-prod.cod-estabel no-undo.
def var i-cd-plano   like pl-prod.cd-plano no-undo.
def var i-nr-per-ini like pl-prod.nr-per-ini no-undo.
def var i-nr-per-fim like pl-prod.nr-per-fim no-undo.
def var i-cd-tipo    like pl-prod.cd-tipo no-undo.
def var c-it-codigo  like item.it-codigo no-undo.
def var i-ano        like pl-it-prod.ano no-undo.
def var i-periodo    like pl-it-prod.periodo no-undo.
def var i-quantidade like pl-it-prod.quantidade no-undo.
def var i-seq        as int no-undo.
def var l-ok         as logical no-undo.

/**** Inicio ****/   
for each tt-erro:
    delete tt-erro.
end.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Importaá∆o_de_plano *}
run pi-inicializar in h-acomp (input  Return-value ).

input stream s-entrada from value(tt-param.arq-entrada1) convert source session:charset.

repeat on error undo, leave
       on stop undo, leave transaction:           
    assign i-seq = i-seq + 1    
           c-cod-estab  = ""
           i-cd-plano   = 0
           i-nr-per-ini = 0
           i-nr-per-fim = 0
           i-cd-tipo = 0
           c-it-codigo = ""
           i-ano = 0
           i-periodo = 0
           i-quantidade = 0.

    import stream s-entrada delimiter ";"
           c-cod-estab
           i-cd-plano
           i-nr-per-ini
           i-nr-per-fim
           i-cd-tipo
           c-it-codigo
           i-ano
           i-periodo
           i-quantidade NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        create tt-erro.
        assign tt-erro.cd-erro = 15825
               tt-erro.mensagem = "Erro " + STRING(error-status:get-message(1)).
        undo,leave.
    END.

    if i-seq = 1 then do:
         find pl-prod NO-LOCK
              where pl-prod.cd-plano   = i-cd-plano
                and pl-prod.cd-tipo    = i-cd-tipo
                and pl-prod.nr-per-ini = i-nr-per-ini
                and pl-prod.nr-per-fim = i-nr-per-fim  no-error.
         if not avail pl-prod then do:
             create tt-erro.
             assign tt-erro.cd-erro = 15825
                    tt-erro.mensagem = "Informacoes contraditorias." + 
                                       "Verifique:" + 
                                       "- se o plano esta cadastrado;" + 
                                       "- se o periodo inicial e final estao corretos;" + 
                                       "- se o tipo de plano esta correto.".
             undo,leave.
         end.
     end.
     
     find item where item.it-codigo = c-it-codigo no-lock no-error.
     if not avail item then do:
        create tt-erro.
        assign tt-erro.cd-erro = 15825
               tt-erro.mensagem = "Item n∆o cadastrado".
        next.                                       
     end.
     
     run pi-acompanhar in h-acomp (input "Importando item " + c-it-codigo + " periodo " + string(i-periodo)).
     
     find periodo
          where periodo.cd-tipo    = i-cd-tipo
            and periodo.ano        = i-ano
            and periodo.nr-periodo = i-periodo.            
     find pl-it-prod
          where pl-it-prod.cod-estabel = c-cod-estab
            AND pl-it-prod.cd-plano  = i-cd-plano
            and pl-it-prod.it-codigo = c-it-codigo
            and pl-it-prod.ano       = i-ano
            and pl-it-prod.periodo   = i-periodo no-error.
     if avail pl-it-prod then
        assign pl-it-prod.quantidade = i-quantidade
               l-ok = yes.
     else do:
         assign l-ok = yes.
         create pl-it-prod.          
         assign pl-it-prod.cod-estabel = c-cod-estab
                pl-it-prod.cd-plano   = i-cd-plano
                pl-it-prod.it-codigo  = c-it-codigo
                pl-it-prod.ano        = i-ano
                pl-it-prod.periodo    = i-periodo
                pl-it-prod.quantidade = i-quantidade
                pl-it-prod.dt-termino = periodo.dt-termino.     
     end.
end.

input stream s-entrada close.
/*
if l-ok then do:
    find programa where programa.programa =  "esplp002"
         exclusive-lock no-error.  
    if not avail programa then do:
        create programa.
        assign programa.programa = "esplp002".
    end.
    if substring(programa.char-2,1,2) = "" then 
          assign programa.char-2 = string(today,"99/99/9999").
    else
          assign substring(programa.char-2,15,10) = string(today,"99/99/9999").

    assign programa.int-1 = programa.int-1 + 1.
end.
*/
{include/i-rpvar.i}
run utp/ut-trfrrp.p (input frame f-erros:handle).
{include/i-rpout.i &tofile=tt-param.arq-destino}

assign c-titulo-relat = "Importaá∆o Plano Produá∆o"
       c-programa     = 'ESPLP002'.

{include/i-rpcab.i}

view frame f-cabec.
view frame f-rodape.    

find first tt-erro no-error.
if avail tt-erro then
    disp tt-erro.cd-erro
         tt-erro.mensagem with frame f-erros.
else
    disp "Importaá∆o executada com sucesso".
    
{include/i-rpclo.i}

run pi-finalizar in h-acomp.

return "OK".


