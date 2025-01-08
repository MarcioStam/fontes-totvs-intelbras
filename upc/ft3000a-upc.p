/***********************************************************************
**  Programa..: UPC\FT3000A-UPC.P
**  Autor.....: Giovane Alves - Sys Developer
**  Data......: JANEIRO/2008 - Desenvolvimento
**  Descricao.: UPC Manutená∆o Preparaá∆o Faturamento Manual
**  Vers∆o....: 001 14/01/2008
**                  Desenvolvimento Programa
**               Bloqueia o acesso a embarques que n∆o sejam do      
**               estabelecimento do usu†rio logado                     
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

{upc/btb910za-upc.i}
DEF VAR c-objeto        AS CHAR                     NO-UNDO.
def var h-object        as handle                   no-undo. 

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

if p-ind-object = "ADD"                        
and c-objeto = "ft3000a-v01.w"
and p-ind-event = "AFTER-ENABLE" then do:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.       
    DO WHILE h-object <> ? :
       if h-object:type <> "field-group" then do:  
       
            IF h-object:NAME = "cod-estabel" THEN
            DO :
               leave.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING.
       end.     
       else do:
           assign h-object = h-object:first-child.
       end.    
    END.
    assign h-object:screen-value = v_cod_estab_usuar
           h-object:sensitive    = yes.
  
    apply "leave" to h-object.
  
    return "OK".
    
    
end.
