


/******************** Definio de Parametros **************************/
def input param           p-ind-event         as char          no-undo.
def input param           p-ind-object        as char          no-undo.
def input param           p-wgh-object        as handle        no-undo.
def input param           p-wgh-frame         as widget-handle no-undo.
def input param           p-cod-table         as char          no-undo.
def input param           p-row-table         as rowid         no-undo.


{utp\ut-glob.i}
/****************** Definio de Variveis Locais **********************/
def var c-char                                as char          no-undo.

/****************** Definio de Variveis Globais **********************/
def var h-objeto                            as widget-handle no-undo.
def var h-objeto-filho                      as widget-handle no-undo.
def var wh-frame                            as widget-handle no-undo.
def var wh as widget-handle.
def new global shared var wh-rs-orig-cidad-prestac-serv                 as widget-handle no-undo. 
def new global shared var wh-descricao                 as widget-handle no-undo.
def new global shared var wh-perc-desc-max             as widget-handle no-undo.
def new global shared var wh-tipo                      as widget-handle no-undo.
def new global shared var wh-log-1                     as widget-handle no-undo.
def new global shared var wh-log-tabela-base           as widget-handle no-undo.
def new global shared var tx-label-0                   as widget-handle no-undo.
def new global shared var tx-label-1                   as widget-handle no-undo.


def var hDBOEX007 as handle no-undo.
/*************************************** Inicializar ********************************************/

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/* message "Evento..........:" string(p-ind-event)  skip */
/*         "Objeto..........:" string(p-ind-object) skip */
/*         "Handle do Objeto:" string(p-wgh-object) skip */
/*         "Handle da Frame.:" string(p-wgh-frame)  skip */
/*         "Tabela..........:" p-cod-table          skip */
/*         "Rowid...........:" string(p-row-table)  skip */
/*         p-wgh-object:file-name                        */
/*         view-as alert-box.                            */


/****************** Inicializar *****************/
if  p-ind-object = "Container"     and
    p-ind-event  = "Before-initialize" then do:

     assign h-objeto = p-wgh-frame:first-child.
    do  while valid-handle(h-objeto):
	
/*              message "objeto: " h-objeto:name view-as alert-box. */

             if h-objeto:name = "f-main" then do:

                 assign h-objeto-filho = h-objeto:first-child.
                 do  while valid-handle(h-objeto-filho):

/*                     message "objeto-filho: " h-objeto-filho:name view-as alert-box. */

                    IF  h-objeto-filho:NAME = 'rs-orig-cidad-prestac-serv' 
                    THEN wh-rs-orig-cidad-prestac-serv = h-objeto-filho:HANDLE. 
                    
                    if  h-objeto-filho:type <> "field-group" then 
                        assign h-objeto-filho = h-objeto-filho:next-sibling.
                    else 
                        Assign h-objeto-filho = h-objeto-filho:first-child.

                 END.

             END.

             if  h-objeto:type <> "field-group" then 
                assign h-objeto = h-objeto:next-sibling.
            else 
                Assign h-objeto = h-objeto:first-child.
    end.


    IF  VALID-HANDLE(wh-rs-orig-cidad-prestac-serv)    THEN DO:

        wh-rs-orig-cidad-prestac-serv:WIDTH = wh-rs-orig-cidad-prestac-serv:WIDTH - 5.

        create text tx-label-1
             assign frame        = p-wgh-frame
             format              = "x(8)"
             width               = 3.5
             height              = .75
             screen-value        = "Tipo:"
             row                 = wh-rs-orig-cidad-prestac-serv:ROW + 1.7  
             col                 = wh-rs-orig-cidad-prestac-serv:COL + 40
             visible             = yes
             SENSITIVE           = NO.
         
         CREATE RADIO-SET wh-tipo
                ASSIGN ROW    = wh-rs-orig-cidad-prestac-serv:ROW + 1.7
                COLUMN        = wh-rs-orig-cidad-prestac-serv:COL + 45
                HEIGHT-CHARS  = 1
                WIDTH-CHARS   = 3.0
                FRAME         = p-wgh-frame
                HORIZONTAL    = TRUE
                AUTO-RESIZE   = TRUE 
                .
         wh-tipo:ADD-LAST("Servi‡o", "0").
         wh-tipo:ADD-LAST("Saas", "1").
         
         
    END.

end.

/*Display*/
if (p-ind-event = "DISPLAY") then do:

    IF  VALID-HANDLE(wh-tipo)
    AND VALID-HANDLE(tx-label-1)
    THEN do: 
         ASSIGN wh-tipo:SENSITIVE  = NO
                wh-tipo:VISIBLE    = YES
                tx-label-1:VISIBLE = YES.
        tx-label-1:MOVE-TO-TOP().
    END.

    IF  VALID-HANDLE(wh-tipo)
    THEN DO:
         find tab-codser no-lock
              where rowid(tab-codser) = p-row-table no-error.
         if avail tab-codser then do:
             assign wh-tipo:screen-value         = string(tab-codser.int-2)
                 .
         end.
         else do:
             assign wh-tipo:screen-value         = string(0).
         end.

    END.
   

end.

/*Criar ou Modificar*/
if (p-ind-event  = "after-enable") then do:

    IF  VALID-HANDLE(wh-tipo)
    AND VALID-HANDLE(wh-rs-orig-cidad-prestac-serv)
    THEN do: 
         ASSIGN wh-tipo:SENSITIVE  = YES.
    END.

end.

if (p-ind-event  = "after-disable") then do:

    IF  VALID-HANDLE(wh-tipo)
    AND VALID-HANDLE(wh-rs-orig-cidad-prestac-serv)
    THEN do: 
         ASSIGN wh-tipo:SENSITIVE  = NO.
    END.

end.


/*Criar ou Modificar*/
if (p-ind-event  = "before-assign") then do:

    IF  VALID-HANDLE(wh-tipo)
    THEN DO:
         find tab-codser EXCLUSIVE-LOCK
              where rowid(tab-codser) = p-row-table no-error.
         if avail tab-codser then do:
             tab-codser.int-2 = INTE(wh-tipo:screen-value).
         end.
    END.
end.

    

return 'ok'.


