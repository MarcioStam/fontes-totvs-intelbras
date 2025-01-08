/* ---------------------------------------------------------------------------
Programa : ft4003-upc.p
Funcao   : Preencher automaticamente os dados do c†lculo da NF com os valores
           obtidos das tabelas espec°ficas.
           O programa se utiliza de BOs da Datasul para a criaá∆o das
           WT's, tabelas que ap¢s efetivadas d∆o origem a Nota Fiscal.
Autor    : Robinson Rafael Koprowski
Data     : 11/2004
Alteraá∆o:
--------------------------------------------------------------------------- */

DEFINE TEMP-TABLE tt-priori NO-UNDO
    FIELD priori-ini AS INTEGER     FORMAT '99'
    FIELD priori-fim AS INTEGER     FORMAT '99'.


DEFINE INPUT PARAMETER p-ind-event      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object     AS HANDLE           NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame      AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-row-table      AS ROWID            NO-UNDO.
DEFINE VARIABLE c-objeto AS CHARACTER  NO-UNDO.
def var h-object        as handle                   no-undo. 
{upc/btb910za-upc.i}

IF p-ind-object = "CONTAINER" AND p-ind-event = "INITIALIZE" THEN DO:


    assign h-object = p-wgh-object:current-window
           h-object = h-object:first-child
           h-object = h-object:first-child.
    
    DO WHILE h-object <> ? :
       if h-object:type <> "field-group" then do:
  
            IF h-object:NAME = "c-cod-estabel-ini" or h-object:NAME = "c-cod-estabel-fim" THEN
            DO :
               assign h-object:screen-value = v_cod_estab_usuar
                      h-object:sensitive    = no.
            END.
            if h-object:NAME = "dt-entrega-ini" then
                apply "entry" to h-object.
            ASSIGN h-object = h-object:NEXT-SIBLING.
       end.
       else do:
           assign h-object = h-object:first-child.
       end.
    END.

    CREATE tt-priori.
    ASSIGN tt-priori.priori-ini = 10
           tt-priori.priori-fim = 10.

    RUN pi-recebe-tt-priori in p-wgh-object (INPUT TABLE tt-priori).
    
END.
