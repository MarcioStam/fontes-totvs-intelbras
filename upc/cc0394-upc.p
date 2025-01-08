/******************************************************************************
*      Programa .....: CC0394-UPC.P                                           *
*      Data .........: 29 de Novembro de 2022                                 *
*      Sistema ......: CC - COMPRAS                                           *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: UPC para o CC0394                                      *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 29/11/2022  Mauricio      Desenvolvimento                  *
******************************************************************************/
{include/i-prgvrs.i "cc0394-upc" 1.00.00.000}
{upc/cc0394-upc.i}

define input param p-ind-event  as char          no-undo.
define input param p-ind-object as char          no-undo.
define input param p-wgh-object as handle        no-undo.
define input param p-wgh-frame  as widget-handle no-undo.
define input param p-cod-table  as char          no-undo.
define input param p-row-table  as rowid         no-undo.

def var c-objeto   as char            no-undo.
def var h-brTarget as handle          no-undo.
def var h-btOK-pad as handle          no-undo.
def var h-btOK-esp as widget-handle   no-undo.
def var h-objeto   as widget-handle   no-undo.
def var c-situacao as char init "4,6" no-undo.

def buffer b-pedido-compr for pedido-compr.
def buffer b-ordem-compra for ordem-compra.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,'~/'),p-wgh-object:file-name,'~/') no-error.

/* message "P-ind-event  = " p-ind-event  skip        */
/*         "P-ind-object = " p-ind-object skip        */
/*         "C-objeto     = " c-objeto     SKIP        */
/*         "P-wgh-object = " p-wgh-object skip        */
/*         "P-wgh-frame  = " p-wgh-frame  skip        */
/*         "P-cod-table  = " p-cod-table  skip        */
/*         "p-row-table  = " string(p-row-table) skip */
/*         view-as alert-box.                         */

if  p-ind-event  = 'before-initialize'
and p-ind-object = 'container'
then do:
     assign h-brTarget = ?
            h-btOK-pad = ?.

     empty temp-table tt-cc0394-upc.
     empty temp-table tt-cc0394-upc-par.
end.

if  p-ind-event  = 'after-initialize'
and p-ind-object = 'container'
then do:
     run pi-recupera-campo (input p-wgh-frame:first-child).   

     if  valid-handle(h-brTarget)
     and valid-handle(h-btOK-pad)
     then do:
          create button h-btOK-esp
          assign frame     = h-btOK-pad:frame
                 width     = h-btOK-pad:width
                 height    = h-btOK-pad:height
                 row       = h-btOK-pad:row
                 column    = h-btOK-pad:column
                 label     = "OK"
                 tooltip   = "OK (UPC)"
                 sensitive = h-btOK-pad:sensitive
                 visible   = h-btOK-pad:visible
                 triggers:
                      on choose persistent run upc/cc0394-upc01.p (input h-btOK-pad,
                                                                   input h-brTarget,
                                                                   input p-row-table).
                 end triggers.
     end.

end.

if  p-ind-event  = 'before-destroy-interface'
and p-ind-object = 'container'
then do transaction:
         for first pedido-compr fields(num-pedido via-transp) no-lock
             where rowid(pedido-compr) = p-row-table,
              each tt-cc0394-upc
             where tt-cc0394-upc.num-pedido-dest = pedido-compr.num-pedido:
             if  tt-cc0394-upc.validado
             and can-find(first tt-cc0394-upc-par where
                                tt-cc0394-upc-par.r-tt-cc0394 = rowid(tt-cc0394-upc))
             then.
             else next.

             for first b-pedido-compr fields(num-pedido via-transp)
                 where b-pedido-compr.num-pedido = tt-cc0394-upc.num-pedido-orig
                       no-lock: end.

             for first b-ordem-compra fields(numero-ordem cod-cond-pag preco-fornec)
                 where b-ordem-compra.numero-ordem = tt-cc0394-upc.numero-ordem-orig
                       no-lock: end.

             find first tt-cc0394-upc-par
                  where tt-cc0394-upc-par.r-tt-cc0394 = rowid(tt-cc0394-upc)
                        no-error.   
    
             for first ordem-compra fields(numero-ordem preco-fornec cod-comprado) no-lock
                 where ordem-compra.numero-ordem = tt-cc0394-upc.numero-ordem-dest,
                  each prazo-compra fields(numero-ordem parcela quant-saldo) no-lock
                 where prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                 if can-find(first int-rel-ped-import where
                                   int-rel-ped-import.num-pedido-orig   = tt-cc0394-upc.num-pedido-orig
                               and int-rel-ped-import.numero-ordem-orig = tt-cc0394-upc.numero-ordem-orig
                               and int-rel-ped-import.parcela-orig      = tt-cc0394-upc-par.parcela
                               and int-rel-ped-import.num-pedido-dest   = pedido-compr.num-pedido
                               and int-rel-ped-import.numero-ordem-dest = ordem-compra.numero-ordem
                               and int-rel-ped-import.parcela-dest      = prazo-compra.parcela
                                   no-lock)
                 then next.

                 if  avail tt-cc0394-upc-par
                 and avail b-ordem-compra
                 and lookup(string(b-ordem-compra.situacao),c-situacao) > 0 /* Eliminada ou Recebida */
                 and tt-cc0394-upc-par.quant-saldo = prazo-compra.quant-saldo
                 and ordem-compra.preco-fornec     = b-ordem-compra.preco-fornec
                 and ordem-compra.cod-comprado     = b-ordem-compra.cod-comprado
                 then.
                 else do:
                      run utp/ut-msgs.p (input "show", input 17567, input "Ocorreu uma inconsistància. A gravaá∆o do relacionamento n∆o foi realizada!").
                      undo, leave.
                 end. /* else do */
                 
                 create int-rel-ped-import.
                 assign int-rel-ped-import.num-pedido-orig   = tt-cc0394-upc.num-pedido-orig  
                        int-rel-ped-import.numero-ordem-orig = tt-cc0394-upc.numero-ordem-orig 
                        int-rel-ped-import.parcela-orig      = tt-cc0394-upc-par.parcela         
                        int-rel-ped-import.cod-cond-pag-orig = b-ordem-compra.cod-cond-pag
                        int-rel-ped-import.via-transp-orig   = b-pedido-compr.via-transp
                        int-rel-ped-import.quant-saldo-orig  = tt-cc0394-upc-par.quant-saldo
                        int-rel-ped-import.preco-fornec-orig = b-ordem-compra.preco-fornec
                        int-rel-ped-import.num-pedido-dest   = pedido-compr.num-pedido  
                        int-rel-ped-import.numero-ordem-dest = ordem-compra.numero-ordem 
                        int-rel-ped-import.parcela-dest      = prazo-compra.parcela     
                        int-rel-ped-import.via-transp-dest   = pedido-compr.via-transp
                        int-rel-ped-import.quant-saldo-dest  = prazo-compra.quant-saldo
                        int-rel-ped-import.comentarios       = "CC0394".
                 find current int-rel-ped-import no-lock no-error.
                 release int-rel-ped-import.
    
                 find next tt-cc0394-upc-par
                     where tt-cc0394-upc-par.r-tt-cc0394 = rowid(tt-cc0394-upc)
                           no-error.
             end. /* for each ordem-compra */   
         end. /* for first pedido-compr */
     end. /* do transaction */

if  p-ind-event  = 'after-destroy-interface'
and p-ind-object = 'container'
then do:
     empty temp-table tt-cc0394-upc.
     empty temp-table tt-cc0394-upc-par.
end.

/********** PROCEDURES **********/
procedure pi-recupera-campo:
    def input parameter h_frame_cad as widget-handle no-undo.

    def var h_frame_cad2 as widget-handle no-undo.

    assign h_frame_cad = h_frame_cad:parent.

    do while valid-handle(h_frame_cad):
        assign h_frame_cad2 = h_frame_cad
               h_frame_cad  = h_frame_cad:parent.
    end.

    assign h_frame_cad = h_frame_cad2.
    assign h_frame_cad = h_frame_cad:first-child.

    run pi-localiza (input h_frame_cad,
                     input h_frame_cad2).

    return "OK":U.
end procedure. /* procedure pi-recupera-campo */

procedure pi-localiza:
    def input param p-wh-objeto-cad as widget-handle no-undo.
    def input param p-wh-frame-cad  as widget-handle no-undo.

    def var wh-objeto-cad as widget-handle no-undo.

    if  valid-handle(h-brTarget)
    and valid-handle(h-btOK-pad)
    then return "OK".

    do while valid-handle(p-wh-objeto-cad):
        if p-wh-objeto-cad:type = 'FRAME'
        then do:
             assign wh-objeto-cad = p-wh-objeto-cad:first-child.
             assign wh-objeto-cad = wh-objeto-cad:first-child.

             run pi-localiza (input  wh-objeto-cad,
                              input  p-wh-objeto-cad).
        end.

        if  p-wh-objeto-cad:type = "BUTTON"
        and p-wh-objeto-cad:name = "btOK"
        then assign h-btOK-pad = p-wh-objeto-cad:handle.

        if  p-wh-objeto-cad:type = "BROWSE"
        and p-wh-objeto-cad:name = "brTarget"
        then do:
             assign h-brTarget = p-wh-objeto-cad:handle.
             return "OK".
        end.

        assign p-wh-objeto-cad = p-wh-objeto-cad:next-sibling.
    end. /* do while valid-handle(p-wh-objeto-cad) */

    return "OK".
end procedure. /* pi-localiza */
