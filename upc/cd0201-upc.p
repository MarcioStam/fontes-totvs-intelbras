/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GCD0201 2.11.00.007 } /*** 010007 ***/

&global-define ButtonSize 9

/***********************************************************************
**
**  GR0507.P - User Program Call para o EN0507
************************************************************************/
define input parameter p-ind-event  as character     no-undo.
define input parameter p-ind-object as character     no-undo.
define input parameter p-wgh-object as handle        no-undo.
define input parameter p-wgh-frame  as widget-handle no-undo.
define input parameter p-cod-table  as character     no-undo.
define input parameter p-row-table  as rowid         no-undo.

/* Global Variable Definitions **********************************************/
define new global shared var wh-descricao         as widget-handle no-undo.
define new global shared var wh-cdn_grupo_estoque as widget-handle no-undo.
define new global shared var wh-log_ckd           as widget-handle no-undo.
define new global shared var wh-objeto            as widget-handle no-undo.
define new global shared var wh-cb_tp_item        as widget-handle no-undo.
define new global shared var h-rt-mold            as widget-handle no-undo.

/* Variable Definitions *****************************************************/

define var c-objeto       as char          no-undo.
define var c-objects      as character     no-undo.
define var wh-object      as widget-handle no-undo.

/* Main Block ***************************************************************/

 assign wh-objeto =  p-wgh-frame:first-child.
 do while valid-handle(wh-objeto):
    if wh-objeto:name = 'log_ckd' then do:
        assign wh-log_ckd  = wh-objeto.
    end.

    if wh-objeto:type = 'field-group' then
       assign wh-objeto = wh-objeto:first-child.
    else
       assign wh-objeto = wh-objeto:next-sibling.

 end.
 
 assign c-objeto   = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").

if p-ind-event  = "BEFORE-INITIALIZE" and
   p-ind-object = "VIEWER" and
   c-objeto = 'v01in142.w' then do:

    run getfieldhandle (input "descricao", output wh-descricao).
    
    create toggle-box wh-log_ckd
    assign frame             = wh-descricao:frame
           label             = "Grupo CKD"
           width             = 10
           height            = wh-descricao:height
           row               = wh-descricao:row
           col               = wh-descricao:col + 35
           visible           = yes
           sensitive         = no.
    
end.

if p-ind-event  = "display" and
   p-ind-object = "VIEWER" and
   c-objeto = 'v01in142.w' then do:

    run getfieldhandle (input "ge-codigo", output wh-cdn_grupo_estoque).

     find first in-grup-estoq where in-grup-estoq.ge-codigo = int(wh-cdn_grupo_estoque:screen-value) no-lock no-error.
     if avail in-grup-estoq then do:

         assign wh-log_ckd:screen-value       = string(in-grup-estoq.log-ckd).
     end.
     else
        assign wh-log_ckd:SCREEN-VALUE       = "no".

end.

if p-ind-event  = "add" and
   p-ind-object = "VIEWER" and
   c-objeto = 'v01in142.w' then do:

   assign wh-log_ckd:screen-value       = "no".

end.

if p-ind-event  = "assign" and
   p-ind-object = "VIEWER" and
   c-objeto = 'v01in142.w' then do:

    run getfieldhandle (input "ge-codigo", output wh-cdn_grupo_estoque).
    
    find first in-grup-estoq where in-grup-estoq.ge-codigo = int(wh-cdn_grupo_estoque:screen-value) exclusive-lock no-error. 

    if avail(in-grup-estoq) then
        assign in-grup-estoq.log-ckd    = if wh-log_ckd:screen-value = "yes" then yes else no.
    else do:
        create in-grup-estoq.
        assign in-grup-estoq.ge-codigo  = int(wh-cdn_grupo_estoque:screen-value)
               in-grup-estoq.log-ckd    = if wh-log_ckd:screen-value = "yes" then yes else no.
    end.

end.

if p-ind-event  = "enable" and
   p-ind-object = "VIEWER" and
   c-objeto = 'v01in142.w' then do:

    assign wh-log_ckd:sensitive  = yes.

end.

if p-ind-event  = "disable" and
   p-ind-object = "viewer"  and
   c-objeto = 'v01in142.w'  then do:

    assign wh-log_ckd:sensitive  = no.
    
end.

procedure getFieldHandle:
   def input parameter  p-campo  as char no-undo.
   def output parameter p-handle as handle no-undo.
  
   def var h_frame as widget-handle no-undo. 

   assign h_frame = p-wgh-frame:first-child. /* pegando o Field-Group */
   assign h_frame = h_frame:first-child.     /* pegando o 1o. Campo */
   
   do while h_Frame <> ? :
      if h_frame:type <> "field-group" then do:  
         if h_frame:name = p-campo then do :
            assign p-handle = h_Frame.
            leave.
         end.
         assign h_frame = h_frame:next-sibling.
      end. 
      else
         assign h_frame = h_frame:first-child.
   end.

end.


