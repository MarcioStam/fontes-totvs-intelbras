/********************************************************************************
*      Programa .....: esccp054rp.p                                             *
*      Data .........: 28 de novembro de 2022                                   *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur¡cio C.                                              *
*      Objetivo .....: Relat¢rio de Troca de Pedidos DE-PARA                    *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL   MOTIVO                            *
*      1.00.00.000  28/11/2022  Mauricio C.   Desenvolvimento                   *
********************************************************************************/
function fn-transp returns character (input i-via-transp as integer) forward.

{include/i-prgvrs.i esccp054rp 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esccp054rp ESP}
&ENDIF

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    field num-pedido-ini   as inte
    field num-pedido-fim   as inte
    field it-codigo-ini    as char
    field it-codigo-fim    as char
    field cod-emitente-ini as inte
    field cod-emitente-fim as inte
    field data-pedido-ini  as date
    field data-pedido-fim  as date
    field csv              as logi
    field diretorio        as char.

define temp-table tt-raw-digita
    field raw-digita    as raw.

def temp-table tt-pedidos no-undo
    field num-pedido-orig   like int-rel-ped-import.num-pedido-orig  
    field numero-ordem-orig like int-rel-ped-import.numero-ordem-orig 
    field it-codigo         like ordem-compra.it-codigo
    field desc-item         like item.it-codigo
    field parcela-orig      like int-rel-ped-import.parcela-orig    
    field cod-emitente      like pedido-compr.cod-emitente  
    field nome-emit         like emitente.nome-emit
    field cod-estabel       like pedido-compr.cod-estabel            
    field data-pedido       like pedido-compr.data-pedido
    field situacao          as char                         
    field cod-cond-pag-orig like int-rel-ped-import.cod-cond-pag-orig
    field desc-transp-orig  as char                     
    field quant-saldo-orig  like int-rel-ped-import.quant-saldo-orig 
    field preco-fornec-orig like int-rel-ped-import.preco-fornec-orig
    field num-pedido-dest   like int-rel-ped-import.num-pedido-dest  
    field numero-ordem-dest like int-rel-ped-import.numero-ordem-dest
    field parcela-dest      like int-rel-ped-import.parcela-dest     
    field cod-cond-pag-dest like ordem-compra.cod-cond-pag         
    field desc-transp-dest  as char                      
    field quant-saldo-dest  like int-rel-ped-import.quant-saldo-dest 
    field preco-fornec-dest like ordem-compra.preco-fornec         
    field comentarios       like int-rel-ped-import.comentarios
    field tipo-process      as inte /* 1 - Origem; 2 - Destino */
    index id is primary tipo-process
                        num-pedido-orig
                        numero-ordem-orig
                        parcela-orig
                        num-pedido-dest
                        numero-ordem-dest
                        parcela-dest
    index id1 tipo-process
              num-pedido-dest
              numero-ordem-dest
              parcela-dest
              num-pedido-orig
              numero-ordem-orig
              parcela-orig
    index id2 it-codigo
              num-pedido-orig
              numero-ordem-orig
              parcela-orig
              num-pedido-dest
              numero-ordem-dest
              parcela-dest
    index id3 tipo-process
              cod-emitente
              num-pedido-orig
              numero-ordem-orig
              parcela-orig
              num-pedido-dest
              numero-ordem-dest
              parcela-dest
    index id4 tipo-process
              cod-emitente
              num-pedido-dest
              numero-ordem-dest
              parcela-dest
              num-pedido-orig
              numero-ordem-orig
              parcela-orig
    index id5 tipo-process
              data-pedido
              num-pedido-orig
              numero-ordem-orig
              parcela-orig
              num-pedido-dest
              numero-ordem-dest
              parcela-dest
    index id6 tipo-process
              data-pedido
              num-pedido-dest
              numero-ordem-dest
              parcela-dest
              num-pedido-orig
              numero-ordem-orig
              parcela-orig.

/*  Recebimento de parametros --- */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.
find current tt-param no-error.    

/***** VARIµVEIS *****/
{include/i-rpvar.i}
{include/tt-edit.i} 
{include/pi-edit.i}

def var h-acomp    as handle no-undo.
def var h-wprog    as handle no-undo.
def var c-dest-csv as char   no-undo.
def var i-aux      as inte   no-undo.
def var i-cont     as inte   no-undo.

def var c-desc-transp1 as char no-undo.
def var c-desc-transp2 as char no-undo.

def var c-transp-aux as char init "Rodovi rio,Aerovi rio,Mar¡timo,Ferrovi rio,Rodoferrovi rio,Rodofluvial,Rodoaerovi rio,Outros" no-undo.
def var c-situacao   as char init "Impresso,Nao Impresso,Eliminado"                                                              no-undo.

def buffer b-pedido-compr for pedido-compr.
def buffer b-ordem-compra for ordem-compra.
def buffer b-prazo-compra for prazo-compra.

def stream st-csv.

/***** FRAMES *****/
form tt-pedidos.numero-ordem-orig format "zzzzz9,99"    column-label "Ord Orig" 
     tt-pedidos.it-codigo         format "x(16)"        column-label "Item"     
     tt-pedidos.parcela-orig      format ">>>>9"        column-label "Par O"    
     tt-pedidos.cod-cond-pag-orig format ">>>9"         column-label "Pag O"  
     tt-pedidos.quant-saldo-orig  format "->>>>,>>9"    column-label "Qtde Orig"   
     tt-pedidos.preco-fornec-orig format ">>>>,>>9.999" column-label "Pre‡o Orig"  
     tt-pedidos.num-pedido-dest   format ">>>>>,>>9"    column-label "Ped Dest" 
     tt-pedidos.numero-ordem-dest format "zzzzz9,99"    column-label "Ord Dest" 
     tt-pedidos.parcela-dest      format ">>>>9"        column-label "Par D"    
     tt-pedidos.cod-cond-pag-dest format ">>>9"         column-label "Pag D"  
     tt-pedidos.desc-transp-dest  format "x(15)"        column-label "Modal Dest"  
     tt-pedidos.quant-saldo-dest  format "->>>>,>>9"    column-label "Qtde Dest"   
     tt-pedidos.preco-fornec-dest format ">>>>,>>9.999" column-label "Pre‡o Dest"
     tt-editor.conteudo           format "x(100)"       column-label "Coment rios"
     with width 250 down no-box stream-io frame f-dados-orig.

form tt-pedidos.numero-ordem-dest format "zzzzz9,99"    column-label "Ord Dest" 
     tt-pedidos.it-codigo         format "x(16)"        column-label "Item"     
     tt-pedidos.parcela-dest      format ">>>>9"        column-label "Par D"    
     tt-pedidos.cod-cond-pag-dest format ">>>9"         column-label "Pag D"   
     tt-pedidos.quant-saldo-dest  format "->>>>,>>9"    column-label "Qtde Dest"   
     tt-pedidos.preco-fornec-dest format ">>>>,>>9.999" column-label "Pre‡o Dest" 
     tt-editor.conteudo           format "x(100)"       column-label "Coment rios" 
     tt-pedidos.num-pedido-orig   format ">>>>>,>>9"    column-label "Ped Orig" 
     tt-pedidos.numero-ordem-orig format "zzzzz9,99"    column-label "Ord Orig" 
     tt-pedidos.parcela-orig      format ">>>>9"        column-label "Par O"    
     tt-pedidos.cod-cond-pag-orig format ">>>9"         column-label "Pag O"  
     tt-pedidos.desc-transp-orig  format "x(15)"        column-label "Modal Orig"  
     tt-pedidos.quant-saldo-orig  format "->>>>,>>9"    column-label "Qtde Orig"   
     tt-pedidos.preco-fornec-orig format ">>>>,>>9.999" column-label "Pre‡o Orig"
     with width 250 down no-box stream-io frame f-dados-dest.

form tt-pedidos.num-pedido-orig   format ">>>>>,>>9"    column-label "Ped Orig" 
     tt-pedidos.numero-ordem-orig format "zzzzz9,99"    column-label "Ord Orig"   
     tt-pedidos.parcela-orig      format ">>>>9"        column-label "Par O"    
     tt-pedidos.cod-cond-pag-orig format ">>>9"         column-label "Pag O"  
     tt-pedidos.desc-transp-orig  format "x(15)"        column-label "Modal Orig"  
     tt-pedidos.quant-saldo-orig  format "->>>>,>>9"    column-label "Qtde Orig"   
     tt-pedidos.preco-fornec-orig format ">>>>,>>9.999" column-label "Pre‡o Orig"  
     tt-pedidos.num-pedido-dest   format ">>>>>,>>9"    column-label "Ped Dest" 
     tt-pedidos.numero-ordem-dest format "zzzzz9,99"    column-label "Ord Dest" 
     tt-pedidos.parcela-dest      format ">>>>9"        column-label "Par D"    
     tt-pedidos.cod-cond-pag-dest format ">>>9"         column-label "Pag D"  
     tt-pedidos.desc-transp-dest  format "x(15)"        column-label "Modal Dest"  
     tt-pedidos.quant-saldo-dest  format "->>>>,>>9"    column-label "Qtde Dest"   
     tt-pedidos.preco-fornec-dest format ">>>>,>>9.999" column-label "Pre‡o Dest"
     tt-editor.conteudo           format "x(90)"        column-label "Coment rios"
     with width 250 down no-box stream-io frame f-dados-it.

find first param-global no-lock no-error.

assign c-programa     = "ESCCP054":U
       c-versao       = "1.00.00":U
       c-revisao      = "000":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "Relat¢rio de Troca de Pedidos DE-PARA"
       c-sistema      = "ESP".

assign c-rodape = "iDBA - " 
                + c-sistema 
                + " - " 
                + c-programa
                + " - V:" 
                + c-versao
                + "."
                + c-revisao
       c-rodape = fill("-", 250 - length(c-rodape)) + c-rodape.

form header
     fill("-", 250) format "x(250)" skip
     c-empresa c-titulo-relat at 50
     "Folha:" at 240 page-number  at 246 format ">>>>9" skip
     fill("-", 230) format "x(228)" today format "99/99/9999"
     "-" string(time, "HH:MM:SS")
     with stream-io width 250 no-labels no-box page-top frame f-cabec.

form header
     c-rodape format "x(250)"
     with stream-io width 250 no-labels no-box page-bottom frame f-rodape.

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

if  tt-param.csv
and tt-param.destino = 3 /* Terminal */
then run utp/ut-utils.p persistent set h-wprog.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Carregando...").

case tt-param.classifica:
    when 1 /* Pedido */
    then do:
         assign i-aux = 1. /* Origem */
         {esp/ccp/esccp054rp.i3 &1=index1 &2=num-pedido-orig &3=numero-ordem-orig &4=parcela-orig &5=numero-ordem-dest &6=parcela-dest}

         assign i-aux = 2. /* Destino */
         {esp/ccp/esccp054rp.i3 &1=index3 &2=num-pedido-dest &3=numero-ordem-dest &4=parcela-dest &5=numero-ordem-orig &6=parcela-orig}
    end. /* when 1 */
    when 2 /* Item */
    then for each ordem-compra use-index item no-lock
            where ordem-compra.it-codigo  >= tt-param.it-codigo-ini
              and ordem-compra.it-codigo  <= tt-param.it-codigo-fim
              and ordem-compra.num-pedido >= tt-param.num-pedido-ini
              and ordem-compra.num-pedido <= tt-param.num-pedido-fim,
            first item fields(it-codigo desc-item) no-lock
            where item.it-codigo = ordem-compra.it-codigo,
            first pedido-compr no-lock
            where pedido-compr.num-pedido    = ordem-compra.num-pedido
              and pedido-compr.data-pedido  >= tt-param.data-pedido-ini
              and pedido-compr.data-pedido  <= tt-param.data-pedido-fim
              and pedido-compr.cod-emitente >= tt-param.cod-emitente-ini
              and pedido-compr.cod-emitente <= tt-param.cod-emitente-fim,
            first emitente fields(cod-emitente nome-emit) no-lock
            where emitente.cod-emitente = pedido-compr.cod-emitente:
             assign i-aux = 1. /* Origem */
             {esp/ccp/esccp054rp.i4 &1=index1 &2=num-pedido-orig &3=numero-ordem-orig &4=parcela-orig &5=numero-ordem-dest &6=parcela-dest}

             assign i-aux = 2. /* Destino */
             {esp/ccp/esccp054rp.i4 &1=index3 &2=num-pedido-dest &3=numero-ordem-dest &4=parcela-dest &5=numero-ordem-orig &6=parcela-orig}
         end. /* for each ordem-compra */
    when 3 /* Fornecedor */
    then for each pedido-compr use-index emitente no-lock
            where pedido-compr.cod-emitente >= tt-param.cod-emitente-ini
              and pedido-compr.cod-emitente <= tt-param.cod-emitente-fim
              and pedido-compr.num-pedido   >= tt-param.num-pedido-ini
              and pedido-compr.num-pedido   <= tt-param.num-pedido-fim
              and pedido-compr.data-pedido  >= tt-param.data-pedido-ini
              and pedido-compr.data-pedido  <= tt-param.data-pedido-fim,
            first emitente fields(cod-emitente nome-emit) no-lock
            where emitente.cod-emitente = pedido-compr.cod-emitente:
             assign i-aux = 1. /* Origem */
             {esp/ccp/esccp054rp.i5 &1=index1 &2=num-pedido-orig &3=numero-ordem-orig &4=parcela-orig &5=numero-ordem-dest &6=parcela-dest}

             assign i-aux = 2. /* Destino */
             {esp/ccp/esccp054rp.i5 &1=index3 &2=num-pedido-dest &3=numero-ordem-dest &4=parcela-dest &5=numero-ordem-orig &6=parcela-orig}
         end. /* for each pedido-compr */     
    when 4 /* Data Pedido */
    then for each pedido-compr use-index data-pedido no-lock
            where pedido-compr.data-pedido  >= tt-param.data-pedido-ini
              and pedido-compr.data-pedido  <= tt-param.data-pedido-fim
              and pedido-compr.num-pedido   >= tt-param.num-pedido-ini
              and pedido-compr.num-pedido   <= tt-param.num-pedido-fim 
              and pedido-compr.cod-emitente >= tt-param.cod-emitente-ini
              and pedido-compr.cod-emitente <= tt-param.cod-emitente-fim,
            first emitente fields(cod-emitente nome-emit) no-lock
            where emitente.cod-emitente = pedido-compr.cod-emitente:
             assign i-aux = 1. /* Origem */
             {esp/ccp/esccp054rp.i5 &1=index1 &2=num-pedido-orig &3=numero-ordem-orig &4=parcela-orig &5=numero-ordem-dest &6=parcela-dest}

             assign i-aux = 2. /* Destino */
             {esp/ccp/esccp054rp.i5 &1=index3 &2=num-pedido-dest &3=numero-ordem-dest &4=parcela-dest &5=numero-ordem-orig &6=parcela-orig}
         end. /* for each pedido-compr */    
end case. /* case tt-param.classifica */

find current tt-pedidos no-error.
release tt-pedidos.

run pi-seta-titulo in h-acomp (input "Imprimindo...").

assign i-cont = 0.

if tt-param.csv
then do:
     assign c-dest-csv = tt-param.diretorio + "esccp054.csv".

     output stream st-csv to value(c-dest-csv) no-convert. /* convert target "iso8859-1" */

     put stream st-csv unformatted 
         "sep=;"
         skip
         "Ped Orig;Ord Orig;Item;Par Orig;Pag Orig;Modal Orig;Qtde Orig;Pre‡o Orig;Ped Dest;Ord Dest;Par Dest;Pag Dest;Modal Dest;Qtde Dest;Pre‡o Dest;Coment rios"
         skip.

     if tt-param.classifica = 2
     then do:
          {esp/ccp/esccp054rp.i6 &1=id2}
     end.
     else do:
          {esp/ccp/esccp054rp.i6 &1=id}
     end.

     output stream st-csv close.
end. /* if tt-param.csv */ 
else case tt-param.classifica:
         when 1 /* Pedido */
         then do:
             {esp/ccp/esccp054rp.i1 &1=id  &2=tt-pedidos.num-pedido-orig &3=tt-pedidos.numero-ordem-orig}
             {esp/ccp/esccp054rp.i2 &1=id1 &2=tt-pedidos.num-pedido-dest &3=tt-pedidos.numero-ordem-dest}
         end.
         when 2 /* Item */
         then for each tt-pedidos use-index id2
                       break by tt-pedidos.it-codigo:
                  assign i-cont = i-cont + 1.

                  if i-cont mod 10 = 0
                  then run pi-acompanhar in h-acomp (input i-cont).

                  if first-of(tt-pedidos.it-codigo)
                  then put unformatted skip(1)
                                       "Item:"            at 1
                                       tt-pedidos.it-codigo + " - " + tt-pedidos.desc-item at 7
                                       skip(1).

                  empty temp-table tt-editor.

                  run pi-print-editor(tt-pedidos.comentarios, 90).

                  for first tt-editor
                      where tt-editor.conteudo <> "": end.

                  disp tt-pedidos.num-pedido-orig
                       tt-pedidos.numero-ordem-orig
                       tt-pedidos.parcela-orig
                       tt-pedidos.cod-cond-pag-orig
                       tt-pedidos.desc-transp-orig
                       tt-pedidos.quant-saldo-orig
                       tt-pedidos.preco-fornec-orig
                       tt-pedidos.num-pedido-dest
                       tt-pedidos.numero-ordem-dest
                       tt-pedidos.parcela-dest
                       tt-pedidos.cod-cond-pag-dest
                       tt-pedidos.desc-transp-dest
                       tt-pedidos.quant-saldo-dest
                       tt-pedidos.preco-fornec-dest
                       tt-editor.conteudo when avail tt-editor
                       with frame f-dados-it.
                  down with frame f-dados-it.

                  if avail tt-editor
                  then delete tt-editor.

                  for each tt-editor
                     where tt-editor.conteudo <> "":
                      disp tt-editor.conteudo
                           with frame f-dados-it.
                      down with frame f-dados-it.
                  end. /* for each tt-editor */

                  if last-of(tt-pedidos.it-codigo)
                  then put unformatted skip(1)
                                       fill("-",250) at 1
                                       skip.
              end. /* for each tt-pedidos */
         when 3 /* Fornecedor */
         then do:
             {esp/ccp/esccp054rp.i1 &1=id3 &2=tt-pedidos.cod-emitente &3=tt-pedidos.num-pedido-orig}
             {esp/ccp/esccp054rp.i2 &1=id4 &2=tt-pedidos.cod-emitente &3=tt-pedidos.num-pedido-dest}
         end.
         when 4 /* Data Pedido */
         then do:
             {esp/ccp/esccp054rp.i1 &1=id5 &2=tt-pedidos.data-pedido &3=tt-pedidos.num-pedido-orig}
             {esp/ccp/esccp054rp.i2 &1=id6 &2=tt-pedidos.data-pedido &3=tt-pedidos.num-pedido-dest}
         end.
     end case. /* case tt-param.classifica */

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

if valid-handle(h-wprog)
then do:
     run OpenDocument in h-wprog (input c-dest-csv). 
     delete procedure h-wprog no-error.
end.

return "OK":U.

/******************** PROCEDURES and FUNCTIONS ********************/
function fn-transp returns character (input i-via-transp as integer):
  if  i-via-transp > 0 
  and i-via-transp < 9 
  then return entry(i-via-transp,c-transp-aux,",").

  return "".
end function.

