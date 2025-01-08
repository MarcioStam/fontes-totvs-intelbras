/******************************************************************************
*      Programa .....: EN0109-UPC.P                                           *
*      Data .........: 08 de Fevereiro de 2023                                *
*      Sistema ......: EN - ENGENHARIA                                        *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: UPC para o EN0109                                      *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 08/02/2023  Mauricio      Desenvolvimento                  *
******************************************************************************/
{include/i-prgvrs.i "en0109-epc" 2.12.00.000}
{cdp/cdcfgman.i}
define input param p-ind-event  as char          no-undo.
define input param p-ind-object as char          no-undo.
define input param p-wgh-object as handle        no-undo.
define input param p-wgh-frame  as widget-handle no-undo.
define input param p-cod-table  as char          no-undo.
define input param p-row-table  as rowid         no-undo.

def var c-objeto as char no-undo.
def var i-aux    as inte no-undo.

def var h-bt-excluir-en0109 as handle no-undo.
def var h-en0109-upc        as handle no-undo.
def var ProgramHandle       as handle no-undo.
def var ProgramHandle2      as handle no-undo.

def new global shared var wh-altern-en0109 as widget-handle no-undo.
def new global shared var c-en0109-upc     as char          no-undo.
def new global shared var c-en0109-upc-aux as char          no-undo.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,'~/'),p-wgh-object:file-name,'~/') no-error.

/* message "P-ind-event  = " p-ind-event         skip */
/*         "P-ind-object = " p-ind-object        skip */
/*         "P-wgh-object = " p-wgh-object        skip */
/*         "P-wgh-frame  = " p-wgh-frame         skip */
/*         "P-cod-table  = " p-cod-table         skip */
/*         "p-row-table  = " string(p-row-table) skip */
/*         "c-objeto     = " c-objeto                 */
/*         view-as alert-box.                         */

/* output to "C:/temp/en0109.txt" no-convert append.              */
/* put unformatted "P-ind-event  = " p-ind-event         skip     */
/*                 "P-ind-object = " p-ind-object        skip     */
/*                 "P-wgh-object = " p-wgh-object        skip     */
/*                 "P-wgh-frame  = " p-wgh-frame         skip     */
/*                 "P-cod-table  = " p-cod-table         skip     */
/*                 "p-row-table  = " string(p-row-table) skip     */
/*                 "c-objeto     = " c-objeto            skip(1). */
/* output close.                                                  */

if  p-ind-event  = 'before-initialize'
and p-ind-object = 'container'
and c-objeto     = 'en0109.w'
then do:
     assign ProgramHandle = session:first-procedure
            i-aux         = 0.

     /* Verifica quantas instƒncias do programa h  na mem¢ria */
     do while valid-handle(ProgramHandle):
         if ProgramHandle:file-name = "enp/en0109.w"
         or ProgramHandle:file-name = "enp\en0109.w"
         then assign i-aux          = i-aux + 1
                     ProgramHandle2 = ProgramHandle.

         assign ProgramHandle = ProgramHandle:next-sibling.
     end.

     if i-aux > 1
     then do:
          run utp\ut-msgs.p(input "show", input 19085, input "EN0109 j  est  aberto!").
          delete procedure ProgramHandle2.
          return "NOK".
     end.

     run pi-zera.

     run pi-recupera-campo (input p-wgh-frame:first-child).

     if valid-handle(h-bt-excluir-en0109)
     then do:
          run upc/en0109-upc.p persistent set h-en0109-upc(input "",            
                                                           input "",            
                                                           input p-wgh-object,  
                                                           input p-wgh-frame,   
                                                           input "",            
                                                           input p-row-table).

          create button wh-altern-en0109
          assign frame     = h-bt-excluir-en0109:frame
                 width     = h-bt-excluir-en0109:width
                 height    = h-bt-excluir-en0109:height
                 row       = h-bt-excluir-en0109:row
                 column    = h-bt-excluir-en0109:column + 28.29
                 label     = "Criar Alternativo"
                 tooltip   = "Criar Alternativo"
                 sensitive = no
                 visible   = yes
                 triggers:
                      on choose persistent run pi-cria-altern in h-en0109-upc.
                 end triggers.

          wh-altern-en0109:load-image-up("image/im-new.bmp").
          wh-altern-en0109:move-after-tab(h-bt-excluir-en0109) no-error. 
     end. /* if valid-handle(h-bt-excluir-en0109) */

     assign h-bt-excluir-en0109 = ?.
end.

if  p-ind-event  = 'display'
and p-ind-object = 'viewer'
and c-objeto     = 'v20in172.w'
and valid-handle(wh-altern-en0109)
then do:
     assign c-en0109-upc-aux = "".

     for first item fields(it-codigo) no-lock
         where rowid(item)       = p-row-table
           and item.cod-obsoleto = 1:
         assign c-en0109-upc-aux = item.it-codigo.
     end. /* for first item */

     assign wh-altern-en0109:sensitive = c-en0109-upc-aux <> "" and
                                         can-find(first estrutura use-index onde-se-usa where
                                                        estrutura.es-codigo     = c-en0109-upc-aux
                                                    and estrutura.data-inicio  <= today
                                                    and estrutura.data-termino >= today
                                                    &IF DEFINED (bf_man_sfc_lc) &THEN
                                                    and estrutura.cod-lista-compon = ""
                                                    &ENDIF
                                                        no-lock).
end. /* if  p-ind-event  = 'display' */

if  p-ind-event  = 'destroy'
and p-ind-object = 'container'
and c-objeto     = 'en0109.w'
then run pi-zera.

/********** PROCEDURES **********/
procedure pi-recupera-campo:
    def input parameter h_frame_cad as widget-handle no-undo.

    assign h_frame_cad = h_frame_cad:first-child.

    do while valid-handle(h_frame_cad):
        if  h_frame_cad:type = "BUTTON"
        and h_frame_cad:name = "bt-Excluir"
        then do:
             assign h-bt-excluir-en0109 = h_frame_cad:handle.
             leave.
        end.

        assign h_frame_cad = h_frame_cad:next-sibling.
    end. /* do while valid-handle(p-wh-objeto-cad) */

    return "OK":U.
end procedure. /* procedure pi-recupera-campo */

procedure pi-zera:
    assign c-en0109-upc     = ""
           c-en0109-upc-aux = ""
           wh-altern-en0109 = ?.

    if valid-handle(h-en0109-upc)
    then delete procedure h-en0109-upc no-error.

    return "OK".
end procedure. /* procedure pi-zera */

procedure pi-cria-altern:
    assign c-en0109-upc = c-en0109-upc-aux.

    run esp/enp/esen0109.w.
end procedure.
