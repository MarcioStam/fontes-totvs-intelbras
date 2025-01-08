/***********************************************************************
**  Programa..: UPC\FT4005-UPCA.P
**  Autor.....: Giovane - Developer
**  Data......: Junho/2007 - Desenvolvimento
**  Descricao.: Invocar programa de preview da NF
**  Vers∆o....: 001 06/06/2007
**                  Desenvolvimento Programa
************************************************************************/
DEFINE NEW GLOBAL SHARED VARIABLE hFT4003-frame0 AS HANDLE NO-UNDO.
def new global shared var h-ft4005-upcb as handle no-undo.
def var wh-object as widget-handle   no-undo.
DEFINE VARIABLE c-nome-abrev AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-pedcli AS CHARACTER   NO-UNDO.
def temp-table tt-documentos no-undo
    field seq-wt-docto as int
    index codigo
          seq-wt-docto. 

          
if valid-handle(hFT4003-frame0) then do:
    ASSIGN wh-object = hFT4003-frame0:FIRST-CHILD
           wh-object = wh-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(wh-object):
        IF wh-object:TYPE <> "field-group" THEN DO:
            
            IF wh-object:NAME = "nome-abrev" THEN
                ASSIGN c-nome-abrev = wh-object:screen-value.
                
            IF wh-object:NAME = "nr-pedcli" THEN
                ASSIGN c-nr-pedcli = wh-object:screen-value.

            IF wh-object:NAME = 'seq-wt-docto' THEN leave.
            ASSIGN wh-object = wh-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.
    if c-nr-pedcli = "" THEN do:
        IF valid-handle(wh-object) then do:
        
            for each tt-documentos:
                delete tt-documentos.
            end.
    
            create tt-documentos. 
            assign tt-documentos.seq-wt-docto = int(wh-object:screen-value).
            
            run upc/ft4005-upcb.w persistent set h-ft4005-upcb (input table tt-documentos).
            run dispatch in h-ft4005-upcb (input "initialize").
            CURRENT-WINDOW:WINDOW-STATE = 3.
        END.
    end.
    ELSE DO:
        IF c-nr-pedcli <> "" THEN DO:
            FIND wt-docto
                WHERE wt-docto.nr-pedcli = c-nr-pedcli
                  AND wt-docto.nome-abrev = c-nome-abrev NO-LOCK NO-ERROR.
            IF AVAIL wt-docto THEN DO:
                for each tt-documentos:
                    delete tt-documentos.
                end.

                create tt-documentos. 
                assign tt-documentos.seq-wt-docto = wt-docto.seq-wt-docto.
                
                run upc/ft4005-upcb.w persistent set h-ft4005-upcb (input table tt-documentos).
                run dispatch in h-ft4005-upcb (input "initialize").
                CURRENT-WINDOW:WINDOW-STATE = 3.

            END.


        END.
    END.

end.
                        
return "OK".
