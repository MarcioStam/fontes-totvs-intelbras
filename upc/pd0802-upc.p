/***********************************************************************
**  Programa..: upc\im0100-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

def NEW GLOBAL SHARED var wh-browse         as handle        no-undo.
def new global shared var wh-query           as widget-handle no-undo.
def new global shared var h-objeto           as widget-handle no-undo.
def new global shared var wh-buffer          as widget-handle no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR wgh-grupo AS WIDGET-HANDLE   NO-UNDO.
DEF VAR hquery                   AS HANDLE NO-UNDO.
DEF VAR hbuffer                  AS HANDLE NO-UNDO.
DEF VAR hped-venda-nr-pedcli     AS HANDLE NO-UNDO.
DEF VAR hped-venda-nome-abrev    AS HANDLE NO-UNDO.

define new global shared variable h-programa         as handle        no-undo.
define new global shared variable wgh-window         as widget-handle no-undo.

DEF NEW GLOBAL SHARED VAR wh-cod-imagem      AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-button       AS WIDGET-HANDLE    NO-UNDO.
DEF VAR h-nr-pedido         AS HANDLE NO-UNDO.
def new global shared var i-nr-pedido         as integer.

DEFINE VARIABLE c-char AS   CHAR.
def var i-linha as integer.
assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").
def new global shared temp-table tt-pedido-pd0802
    field nr-pedcli like ped-venda.nr-pedcli
    field nome-abrev like ped-venda.nome-abrev.


if  p-ind-event  = "INITIALIZE" and 
    p-ind-object = "CONTAINER" then do:
    
    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.
    create button wh-button  
    assign frame     = p-wgh-frame 
           width     = 4.00        
           height    = 1.25        
           row       = 1.10       
           col       = 60.32       
           visible   = yes
           sensitive = yes
           tooltip   = "UPC"
           triggers:
             on choose persistent run upc/pd0802a-upc.w.
           end triggers.
  if wh-button:load-image("image/gr-lay.bmp") then.

end.

IF    p-ind-event = "before-initialize":U  THEN DO:

    ASSIGN wgh-grupo = p-wgh-frame:FIRST-CHILD.

    DO WHILE VALID-HANDLE(wgh-grupo) :
       CASE wgh-grupo:TYPE:
             WHEN "browse" THEN DO:
                 ASSIGN wh-browse = wgh-grupo:HANDLE
                        wh-query  = wh-browse:QUERY
                        wh-buffer = wh-query:GET-BUFFER-HANDLE(1).
                 LEAVE.
             END.   
       END CASE.
                       
       IF  wgh-grupo:TYPE = "field-group" THEN
           ASSIGN wgh-grupo = wgh-grupo:FIRST-CHILD.
       ELSE
           ASSIGN wgh-grupo = wgh-grupo:NEXT-SIBLING. 
    END.   
END.

/* MESSAGE "Evento " p-ind-event  SKIP */
/*         "Objeto " p-ind-object SKIP */
/*         "Nome   " c-char SKIP */
/*         "Tabela " p-cod-table  SKIP */
/*         "Rowid  " STRING(p-row-table) skip */
/*         "browser " string(wh-browse) skip */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK. */
    
IF p-ind-object    = "browser":U     AND
   p-ind-event = "before-display" THEN DO:    
    for each tt-pedido-pd0802:
        delete tt-pedido-pd0802.
    end.    
end.    
IF p-ind-object    = "browser":U     AND
   p-ind-event = "value-changed" THEN DO:
    for each tt-pedido-pd0802:
        delete tt-pedido-pd0802.
    end.        
     ASSIGN hquery               = wh-browse:QUERY 
           hbuffer               = hquery:GET-BUFFER-HANDLE(2)
           hped-venda-nr-pedcli  = hbuffer:BUFFER-FIELD("nr-pedcli")
           hped-venda-nome-abrev = hbuffer:BUFFER-FIELD("nome-abrev").   

    DO i-linha = 1 TO wh-browse:NUM-SELECTED-ROWS :
        if wh-browse:fetch-selected-row(i-linha) then do:       
            find first tt-pedido-pd0802
                 where tt-pedido-pd0802.nr-pedcli = hped-venda-nr-pedcli:BUFFER-VALUE 
                   and tt-pedido-pd0802.nome-abrev = hped-venda-nome-abrev:BUFFER-VALUE 
                 no-lock no-error.
            if not avail tt-pedido-pd0802 then do:
               create tt-pedido-pd0802.
               assign tt-pedido-pd0802.nr-pedcli = hped-venda-nr-pedcli:BUFFER-VALUE 
                      tt-pedido-pd0802.nome-abrev = hped-venda-nome-abrev:BUFFER-VALUE.
            end.               
        end.
    END.
    /* for each tt-pedido: */
/*         message tt-pedido.nr-pedcli view-as alert-box. */
/*     end. */
    /*
    DO i-linha = 1 TO wh-browse:NUM-ITERATIONS :

        ASSIGN h-nr-pedido = wh-browse:GET-BROWSE-COLUMN(i-linha)
               i-nr-pedido = int(h-nr-pedido:SCREEN-VALUE).                
               
        message i-nr-pedido i-linha        view-as alert-box.

        
        
    END.*/
/*     find FIRST ped-venda WHERE */
/*                   ped-venda.nr-pedido = i-nr-pedido NO-LOCK no-error. */
/*     if avail ped-venda then do: */
/*         message avail ped-venda i-nr-pedido view-as alert-box. */
/*         find first tt-pedido */
/*              where tt-pedido.nr-pedido = i-nr-pedido no-lock no-error. */
/*         if not avail tt-pedido then do: */
/*            create tt-pedido. */
/*            assign tt-pedido.nr-pedido = i-nr-pedido. */
/*         end. */
/*     end. */
/*     for each tt-pedido: */
/*         message tt-pedido.nr-pedido view-as alert-box. */
/*     end. */

END.

