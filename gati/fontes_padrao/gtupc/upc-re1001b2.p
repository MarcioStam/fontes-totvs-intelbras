/* ----------------------------------------------------------------------------
   Programa..: gtupc/re1001b2-upc.p
   Data......: Setembro de 2014
   Autor.....: Rodrigo Visentainer - GATI TI
   Objetivo..: UPC para bloqueio de campos para grupo especifico de usuarios
---------------------------------------------------------------------------- */

/************************ Parameter Definition Begin ************************/
{include/i-prgvrs.i UPC-RE1001B2 2.00.00.000}
{gtp/gati0000.i}

def input param p-ind-event      as char          no-undo.
def input param p-ind-object     as char          no-undo.
def input param p-wgh-object     as handle        no-undo.
def input param p-wgh-frame      as widget-handle no-undo.
def input param p-cod-table      as char          no-undo.
def input param p-row-table      as rowid         no-undo.

def new global shared variable    c-seg-usuario     as char format "x(12)" no-undo.
define new global shared variable wgh-objeto        as widget-handle no-undo.
define new global shared variable wgh-qt-do-forn    as widget-handle no-undo.

/************************* Parameter Definition End *************************/

/************************* Frame Definition Begin *************************/

define new global shared variable wgh-fpage1        as widget-handle no-undo.

/************************* Frame Definition End *************************/

/****************************** Main Code Begin *****************************/
&IF '{&pre-empresa}' = "minusa" &THEN

if p-ind-event = "AFTER-INITIALIZE" then do:

	assign wgh-objeto = p-wgh-frame:first-child.
	do while valid-handle(wgh-objeto):
	
		if wgh-objeto:name = "fpage1" then do:
			assign wgh-fpage1 = wgh-objeto.
		end.
   
		if wgh-objeto:type = 'field-group'
		then
		  assign wgh-objeto = wgh-objeto:first-child.
		else 
		  assign wgh-objeto = wgh-objeto:next-sibling.
	end.
	
	if valid-handle(wgh-fpage1) then do:
        assign wgh-objeto = wgh-fpage1:first-child.
        do while valid-handle(wgh-objeto):
								
    		for first usuar_mestre no-lock
			where usuar_mestre.cod_usuario = c-seg-usuario:		
					
				find first usuar_grp_usuar no-lock
					 where usuar_grp_usuar.cod_usuario = usuar_mestre.cod_usuario
					 and   usuar_grp_usuar.cod_grp_usuar = "FRE" no-error.
					 
				if avail usuar_grp_usuar then do:	
					
					if 	(wgh-objeto:name = "qt-do-forn") 
					or  (wgh-objeto:name = "un") 
					or  (wgh-objeto:name = "preco-total")
					or  (wgh-objeto:name = "preco-unit")
					or  (wgh-objeto:name = "quantidade") 
					or  (wgh-objeto:name = "c-nossa-unid") then do:
						assign wgh-objeto:sensitive = no.
					end.
				end.
				
				if wgh-objeto:type = 'field-group'
				then
				  assign wgh-objeto = wgh-objeto:first-child.
				else 
				  assign wgh-objeto = wgh-objeto:next-sibling.
			end.
        end.
    end.
end.

&ENDIF.

/******************************* Main Code End ******************************/

