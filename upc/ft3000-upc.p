/***********************************************************************
**  Programa..: UPC\FT3000-UPC.P
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
define var c-folder     as character                no-undo.
def var h-object         as handle                   no-undo. 
define new global shared var gs-panel        as handle no-undo.
define new global shared var adm-broker-hdl  as handle no-undo.
define new global shared var gs-bt-modificar as handle no-undo.
define new global shared var gs-embarque-liberado as logi no-undo.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

if p-ind-object = "VIEWER"                        
and c-objeto = "ft3000-v01.w"
and p-ind-event = "INITIALIZE" then do:

    RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                           INPUT "TABLEIO-SOURCE":U,
                                           OUTPUT c-folder).
                                           
    assign gs-panel = widget-handle(c-folder) no-error.   
    
    return "OK".
    
    
end.

if p-ind-object = "VIEWER"                        
and c-objeto = "ft3000-v01.w"
and p-ind-event = "DISPLAY" then do:

    if valid-handle(gs-panel) then do: 
        find first embarque no-lock
            where rowid(embarque) = p-row-table no-error.
        if embarque.cod-estabel ne v_cod_estab_usuar then do:     
            RUN enable-Elimina in gs-panel (Input no).    
            RUN enable-Modifica in gs-panel (Input no).    
            RUN enable-Copia in gs-panel (Input no).    
            assign gs-bt-modificar:sensitive = no when valid-handle(gs-bt-modificar)
                   gs-embarque-liberado      = no.
        end.
        else do:
            RUN enable-Elimina in gs-panel (Input yes).    
            RUN enable-Modifica in gs-panel (Input yes).    
            RUN enable-Copia in gs-panel (Input yes).    
            assign gs-bt-modificar:sensitive = yes when valid-handle(gs-bt-modificar)
                   gs-embarque-liberado      = yes.
        
        end.
    end.

    return "OK".
    
    
end.

if p-ind-object = "BROWSER"                        
and c-objeto = "ft3000-b02.w"
and p-ind-event = "INITIALIZE" then do:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.       
    DO WHILE h-object <> ? :
       if h-object:type <> "field-group" then do:  
       
            IF h-object:NAME = "bt-modificar" THEN
            DO :
               assign gs-bt-modificar = h-object.
               leave.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING.
       end.     
       else do:
           assign h-object = h-object:first-child.
       end.    
    END.

    assign gs-bt-modificar:sensitive = gs-embarque-liberado.
    
    return "OK".
    
    
end.
