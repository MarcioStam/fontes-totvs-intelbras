/***********************************************************************
**  Programa..: epc\apb735aa-epc.p
**  Data......: 10/11/2015
************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

define variable wh_button         as widget-handle  no-undo.
define variable h_object          as widget-handle  no-undo.
define variable h_prev            as widget-handle  no-undo.
define variable h_next            as widget-handle  no-undo.

def new global shared var v_rec_lote_pagto
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-pagto-orig AS WIDGET-HANDLE NO-UNDO.

if  p_ind_event = "INITIALIZE" then do:
    create button wh_button
    assign frame      = p_wgh_frame
           width      = 4
           height     = 1.13
           row        = 1.08
           col        = 50.14
           sensitive  = yes
           visible    = yes
           tooltip    = "Pagamento"
           triggers:
               on choose persistent run epc/apb735aa-epc2.p.
           end triggers.

    wh_button:load-image("image/im-pay.bmp":U).

    /* Corrigir Tab Order */
    assign h_object = p_wgh_frame:first-child
           h_object = h_object:first-child
           h_prev   = ?
           h_next   = ?.
    do  while valid-handle(h_object):
        if  h_object:type <> "field_group" then do:
            case h_object:name:
                when "bt_pri" then assign h_prev = h_object.
                when "bt_exi" then assign h_next = h_object.
            end case.
            assign h_object = h_object:next-sibling.
        end.
        else do:
            assign h_object = h_object:first-child.
        end.
        if  valid-handle(h_prev) and valid-handle(h_next) then
            leave.
    end.

end.

if  p_ind_event = "enable" then do:

    RUN piTelaUPC (INPUT  p_wgh_frame, /*** fPage3 ***/
                   INPUT  "BUTTON":U,  /*** Type ***/
                   INPUT  "bt_pay":U,  /*** Name ***/
                   OUTPUT wh-bt-pagto-orig).
    
    IF VALID-HANDLE(wh-bt-pagto-orig) 
    THEN DO:
         ASSIGN wh-bt-pagto-orig:VISIBLE = FALSE.
    END.

end.


if  p_ind_event = "DISPLAY" then
    assign v_rec_lote_pagto = p_rec_table.


PROCEDURE piTelaUPC :
/*------------------------------------------------------------------------------
  Purpose:     Buscar objetos na tela do produto padr’o.
  Parameters:  pWghFrame (WIDGET-HANDLE),
               pObjType  (CHARACTER),
               pObjName  (CHARACTER),
               phObj     (HANDLE).
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pWghFrame AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER pObjType  AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER pObjName  AS CHARACTER     NO-UNDO.
    DEFINE OUTPUT PARAMETER phObj     AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.
        END.

        IF wgh-obj:TYPE = "FIELD-GROUP":U THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

    ASSIGN wgh-obj = ?.

    RETURN "OK":U.

END PROCEDURE.
