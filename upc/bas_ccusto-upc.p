/*****************************************************************************
** Programa..............: cmg705aa_epc.p - bas_extrat_cta_corren
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 17/11/2008
*****************************************************************************/

def input param p_ind_event       as char           no-undo.
def input param p_ind_object      as char           no-undo.
def input param p_wgh_object      as handle         no-undo.
def input param p_wgh_frame       as widget-handle  no-undo.
def input param p_cod_table       as char           no-undo.
def input param p_rec_table       as recid          no-undo.

define variable wh_button         as widget-handle  no-undo.

def new global shared var v_rec_ccusto_upc      as RECID format ">>>>>>9" initial ? no-undo.
DEF NEW GLOBAL SHARED VAR wh-bas-tg-desp-viagem AS WIDGET-HANDLE NO-UNDO.

DEF BUFFER b_ccusto FOR emscad.ccusto.

if  p_ind_event = "INITIALIZE" 
then do:
    create button wh_button
    assign frame      = p_wgh_frame
           width      = 4
           height     = 1.08
           row        = 2.63
           col        = 76.5
           sensitive  = yes
           visible    = yes
           tooltip    = "CC x Estabelecimento x Unidade"
           triggers:
               on choose persistent run esp/fgl/esfgl001.p.
           end triggers.

    wh_button:load-image("image/im-ajusi.bmp":U).


    CREATE TOGGLE-BOX wh-bas-tg-desp-viagem
    ASSIGN NAME      = "wh-bas-tg-desp-viagem"
           FORMAT    = "Sim/NÆo"
           FRAME     = p_wgh_frame
           WIDTH     = 23.50
           HEIGHT    =  0.70
           COLUMN    = 56.90
           ROW       =  5.30
           LABEL     = "Movimenta Despesa Viagem"
           HELP      = "Movimenta Despesa Viagem"
           CHECKED   = NO
           VISIBLE   = YES
           SENSITIVE = NO.

end.

if p_ind_event = "DISPLAY" 
THEN DO:
    assign v_rec_ccusto_upc          = p_rec_table
           wh-bas-tg-desp-viagem:CHECKED = NO.

    FOR FIRST b_ccusto NO-LOCK
        WHERE RECID(b_ccusto) = p_rec_table:

        FOR FIRST cc_uni_estab NO-LOCK
            WHERE cc_uni_estab.cod_ccusto            = b_ccusto.cod_ccusto
              AND cc_uni_estab.log_movta_desp_viagem = YES:
            ASSIGN wh-bas-tg-desp-viagem:CHECKED = YES.
        END.
    END.
END.
    
