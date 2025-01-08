/*****************************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************************/
{include/i-prgvrs.i cc0509a-upc 1.00.00.000}
/*****************************************************************************************
**  Programa..: upc/cc0509a-upc - Intelbras
**  Objetivo  : Disponibilizar campo estabelecimento para visualiza‡Æo no pedido.

*****************************************************************************************/
{utp/ut-glob.i}
    
/*********************Evento Padräes*****************************************************/
def input param p-ind-event        as char                                        no-undo.
def input param p-ind-object       as char                                        no-undo.
def input param p-wgh-object       as handle                                      no-undo.
def input param p-wgh-frame        as widget-handle                               no-undo.
def input param p-cod-table        as char                                        no-undo.
def input param p-row-table        as rowid                                       no-undo.

def var wh-object           as handle no-undo.
def var wh-txt-esp          as handle no-undo.
def var wh-estab-esp        as handle no-undo.
def var wh-txt-ckd-cc0300   as handle no-undo.
def var wh-cod-ckd-cc0300   as handle no-undo.
def var wh-txt-qtckd-cc0300 as handle no-undo.
def var wh-qtd-ckd-cc0300   as handle no-undo.
/*def var wh-des-estab-esp as handle no-undo.*/

/*********************Vari vel Globais***************************************************/
/*define new global shared variable <nome>  as <tipo>                               no-undo.*/


/*********************Defini‡Æo de Vari veis Locais**************************************/
define variable c-objeto                  as character                            no-undo.


/*********************INICIO*************************************************************/
assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").

if p-ind-event  = "DISPLAY"    and
   p-ind-object = "VIEWER"     and
   c-objeto     = "v13in295.w" then do:
    
    do on error undo, return:
        run pi-get-widget(input "num-pedido", output wh-object).
        
        if valid-handle(wh-object) and
           not valid-handle(wh-estab-esp) then do:
            CREATE TEXT wh-txt-ckd-cc0300
            ASSIGN FRAME        = p-wgh-frame
                   FORMAT       = "x(09)"
                   WIDTH        = 09
                   SCREEN-VALUE = "Prod CKD:"
                   ROW          = 3.35
                   COL          = 40
                   VISIBLE      = YES.
        
            CREATE FILL-IN wh-cod-ckd-cc0300
            ASSIGN FRAME             = p-wgh-frame
                   DATA-TYPE         = "CHARACTER"
                   FORMAT            = "X(08)" 
                   WIDTH             = 8
                   HEIGHT            = .88
                   ROW               = 3.25
                   COL               = 47.5
                   VISIBLE           = YES
                   SENSITIVE         = NO.
    
            CREATE TEXT wh-txt-qtckd-cc0300
            ASSIGN FRAME        = p-wgh-frame
                   FORMAT       = "x(09)"
                   WIDTH        = 09
                   SCREEN-VALUE = "Qtd CKD:"
                   ROW          = 4.35
                   COL          = 40.8
                   VISIBLE      = YES.
        
            CREATE FILL-IN wh-qtd-ckd-cc0300
            ASSIGN FRAME             = p-wgh-frame
                   DATA-TYPE         = "CHARACTER"
                   FORMAT            = "x(12)" 
                   WIDTH             = 10
                   HEIGHT            = .88
                   ROW               = 4.25
                   COL               = 47.5
                   VISIBLE           = YES
                   SENSITIVE         = NO.

            create text wh-txt-esp
            assign frame    = p-wgh-frame
            format          = "x(6)"
            width           = 6
            height          = 0.75
            screen-value    = "Estab:":U
            row             = wh-object:row
            col             = wh-object:col + 11.25
            fgcolor         = 0
            visible         = yes.

            create fill-in wh-estab-esp
            assign frame         = p-wgh-frame
            width                = 7.00
            height               = wh-object:height
            row                  = wh-object:row
            help                 = "Est Entrega"
            col                  = wh-object:col + 16
            name                 = "end-entrega"
            data-type            = "character"
            format               = "x(3)"
            visible              = yes
            sensitive            = false
            tooltip              = "Estabelecimento entrega".
        
        end.

        if valid-handle(wh-object)    and
           valid-handle(wh-estab-esp) then do:
            FOR FIRST int-pedido-compr NO-LOCK 
                WHERE int-pedido-compr.num-pedido = int(wh-object:screen-value):
                ASSIGN wh-qtd-ckd-cc0300:SCREEN-VALUE = STRING(INT(int-pedido-compr.qtd-pedido-ckd),">,>>>,>>9")
                       wh-cod-ckd-cc0300:SCREEN-VALUE = int-pedido-compr.cod-produto-ckd                        .
            END.
            find first pedido-compr no-lock
                 where pedido-compr.num-pedido = int(wh-object:screen-value) no-error.
            if avail pedido-compr then
                assign wh-estab-esp:screen-value = string(pedido-compr.end-entrega).
        end.
    end.
end.

/************************ Procedure *****************************************************/
procedure pi-get-widget:
    def input  param p_name   as char   no-undo.
    def output param p_widget as widget no-undo.
    
    assign p_widget = p-wgh-frame:first-child.
    do while valid-handle(p_widget):
        if p_widget:name = p_name then return.
        if p_widget:type = "field-group" then
            assign p_widget = p_widget:first-child.
        else
            assign p_widget = p_widget:next-sibling.
    end.
    assign p_widget = ?.
    return error.
end procedure.

