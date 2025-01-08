/***********************************************************************
**  Programa..: upc\en0507-upc.p
**  Autor.....: ?
**  Data......: ?
**  Descricao.: 
**  Vers∆o....: 001 - Desenvolvimento Programa
**  Vers∆o....: 002 - 
************************************************************************/
define input parameter p-ind-event      as character        no-undo.
define input parameter p-ind-object     as character        no-undo.
define input parameter p-wgh-object     as handle           no-undo.
define input parameter p-wgh-frame      as widget-handle    no-undo.
define input parameter p-cod-table      as character        no-undo.
define input parameter p-row-table      as rowid            no-undo.

{utp/ut-glob.i}
{upc/utils.i}

/* Global Variable Definitions **********************************************/
define new global shared var adm-broker-hdl as handle no-undo.
define new global shared var h-folder       as handle no-undo.
define new global shared var h-viewer       as handle no-undo.
DEF NEW GLOBAL SHARED VAR h-fill-item AS HANDLE NO-UNDO.

/* Variable Definitions *****************************************************/
define variable c-folder        as character    no-undo.
define variable c-objects       as character    no-undo.
define variable h-object        as handle       no-undo.
define variable i-objects       as integer      no-undo.
define variable l-record        as logical      no-undo initial no.
define variable l-group-assign  as logical      no-undo initial no.
DEFINE VARIABLE hBtAPS          AS HANDLE       NO-UNDO.
                 
def var h-br-table       as        handle no-undo.
def var h-objeto         as widget-handle no-undo.
def var h-this-procedure as widget-handle no-undo.
def var wh-nro-homem-aps as widget-handle no-undo.
DEF VAR h-field          AS        HANDLE NO-UNDO.
DEF VAR i-cont           AS        INTE   NO-UNDO.

/*     output to "C:/temp/en0507.txt" no-convert append.  */
/*     put unformatted p-ind-event         skip           */
/*                     p-ind-object        skip           */
/*                     p-wgh-object:file-name        skip */
/*                     p-wgh-object        skip           */
/*                     p-wgh-frame         skip           */
/*                     p-cod-table         skip           */
/*                     string(p-row-table) skip(1).       */
/*     output close.                                      */

/* Main Block ***************************************************************/

IF p-ind-event = "INITIALIZE" AND p-ind-object = "CONTAINER" THEN DO:

     run pi-recupera-campo (input p-wgh-frame:first-child).
     
     assign h-objeto = p-wgh-object.
     
     do while valid-handle(h-objeto):
         if h-objeto:file-name = "enp/en0507.w"
         then do:
              assign h-this-procedure = h-objeto.
              leave.
         end.
     
         assign h-objeto = h-objeto:next-sibling.
     end.

    CREATE BUTTON hBtAPS
    ASSIGN FRAME     = p-wgh-frame:HANDLE
           NAME      = "btAps"
           WIDTH     = 4
           HEIGHT    = 1.2
           COL       = 50
           ROW       = 1.2
           VISIBLE   = yes
           SENSITIVE = true
           FONT      = 1
           TOOLTIP   = "Cadastro APS".

    hBtAPS:load-image-up("image\im-plin").

    ON 'CHOOSE':U OF hBtAPS PERSISTENT
        RUN upc/en0507-upc.p (INPUT "piAbreAps",
                              INPUT p-ind-object,
                              INPUT p-wgh-object,
                              INPUT p-wgh-frame,
                              INPUT p-cod-table,
                              INPUT p-row-table).

     if  valid-handle(h-this-procedure)
     AND valid-handle(h-br-table)
     then do:
          assign h-field = h-br-table:get-browse-column(10) no-error.

          if not valid-handle(h-field)
          then return.

          IF h-field:LABEL <> "Hom"
          THEN.
          else DO i-cont = 1 TO h-br-table:NUM-COLUMNS:
                   assign h-field = h-br-table:get-browse-column(i-cont).

                   IF h-field:LABEL = "Hom"
                   THEN leave.
                   
                   assign h-field = ?.
               END.

          if valid-handle(h-field)
          then do:
               assign h-field:label   = "".
               assign h-field:visible = no.

               assign wh-nro-homem-aps           = h-br-table:add-calc-column("DECIMAL",">>9.9","","Hom APS",10)
                      wh-nro-homem-aps:read-only = true.

               ON row-display  of h-br-table persistent run upc/en0507-upc02.p (input h-br-table:query,
                                                                                input wh-nro-homem-aps).
          end.
     END.
END.

IF p-ind-event = "piAbreAps" THEN DO:

    ASSIGN h-fill-item = fc-get-object-handle (p-wgh-frame,
                                               FALSE,
                                               FALSE,
                                               "it-codigo", // nome objeto
                                               "FILL-IN",  // tipo objeto
                                               "").
    IF VALID-HANDLE (h-fill-item) THEN
        RUN upc\en0507-upc01.w (INPUT h-fill-item:SCREEN-VALUE).

END.

/********** PROCEDURES **********/
procedure pi-recupera-campo:
    def input parameter h_frame_cad as widget-handle no-undo.

    def var h_frame_cad2 as widget-handle no-undo.
    
    assign h_frame_cad = h_frame_cad:parent.

    output to "C:/temp/browser_en0507.txt" no-convert append.
    
    do while valid-handle(h_frame_cad):                                                                  
        assign h_frame_cad2 = h_frame_cad
               h_frame_cad  = h_frame_cad:parent.
    end.
    
    assign h_frame_cad = h_frame_cad2.
    assign h_frame_cad = h_frame_cad:first-child.                              
    
    run pi-localiza (input h_frame_cad, 
                     input h_frame_cad2).

    output close.
    
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
            put unformatted p-wh-objeto-cad:name skip.
             assign h-br-table = p-wh-objeto-cad:handle.
             return "OK".
        end.
        
        assign p-wh-objeto-cad = p-wh-objeto-cad:next-sibling.                                                       
    end. /* do while valid-handle(p-wh-objeto-cad) */

    return "OK".
end procedure. /* pi-localiza */
