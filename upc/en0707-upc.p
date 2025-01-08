/******************************************************************************
*      Programa .....: EN0707-UPC.P                                           *
*      Data .........: 10 de Maio de 2022                                     *
*      Sistema ......: EN - ENGENHARIA                                        *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: UPC para o EN0707                                      *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 10/05/2022  Mauricio      Desenvolvimento                  *
******************************************************************************/
{include/i-prgvrs.i "en0707-epc" 1.00.00.000}

define input param p-ind-event  as char          no-undo.
define input param p-ind-object as char          no-undo.
define input param p-wgh-object as handle        no-undo.
define input param p-wgh-frame  as widget-handle no-undo.
define input param p-cod-table  as char          no-undo.
define input param p-row-table  as rowid         no-undo.

def var c-objeto         as char          no-undo.
def var h-br-table       as handle        no-undo.
def var h-objeto         as widget-handle no-undo.
def var h-this-procedure as widget-handle no-undo.
def var wh-nro-homem-aps as widget-handle no-undo.
def var h-field          as handle        no-undo.
def var i-cont           as inte          no-undo.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,'~/'),p-wgh-object:file-name,'~/') no-error.

/* message "P-ind-event  = " p-ind-event    skip        */
/*           "P-ind-object = " p-ind-object skip        */
/*           "P-wgh-object = " p-wgh-object skip        */
/*           "P-wgh-frame  = " p-wgh-frame  skip        */
/*           "P-cod-table  = " p-cod-table  skip        */
/*           "p-row-table  = " string(p-row-table) skip */
/*           view-as alert-box.                         */

if  p-ind-event  = 'before-initialize'
and p-ind-object = 'container'
then do:
     run pi-recupera-campo (input p-wgh-frame:first-child).
     
     assign h-objeto = p-wgh-object.
     
     do while valid-handle(h-objeto):
         if h-objeto:file-name = "enp/en0707.w"
         then do:
              assign h-this-procedure = h-objeto.
              leave.
         end.
     
         assign h-objeto = h-objeto:next-sibling.
     end.

     if  valid-handle(h-this-procedure)
     and valid-handle(h-br-table)
     then do:
          assign h-field = h-br-table:get-browse-column(10) no-error.

          if not valid-handle(h-field)
          then return.

          IF h-field:label <> "Hom"
          then.
          else do i-cont = 1 to h-br-table:num-columns:
                   assign h-field = h-br-table:get-browse-column(i-cont).

                   if h-field:label = "Hom"
                   then leave.
                   
                   assign h-field = ?.
               end.

          if valid-handle(h-field)
          then do:
               assign h-field:label   = "".
               assign h-field:visible = no.

               assign wh-nro-homem-aps           = h-br-table:add-calc-column("DECIMAL",">>9.9","","Hom APS",10)
                      wh-nro-homem-aps:read-only = true.

               ON row-display  of h-br-table persistent run upc/en0707-upc01.p (input h-br-table:query,
                                                                                input wh-nro-homem-aps).
          end.
     END.
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

    if valid-handle(h-br-table)
    then return "OK".

    do while valid-handle(p-wh-objeto-cad):
        if p-wh-objeto-cad:type = 'FRAME'
        then do:
             assign wh-objeto-cad = p-wh-objeto-cad:first-child.
             assign wh-objeto-cad = wh-objeto-cad:first-child.

             run pi-localiza (input  wh-objeto-cad,
                              input  p-wh-objeto-cad).
        end.

        if  p-wh-objeto-cad:type = "BROWSE"
        and p-wh-objeto-cad:name = "br-table"
        then do:
             assign h-br-table = p-wh-objeto-cad:handle.
             return "OK".
        end.

        assign p-wh-objeto-cad = p-wh-objeto-cad:next-sibling.
    end. /* do while valid-handle(p-wh-objeto-cad) */

    return "OK".
end procedure. /* pi-localiza */

