/**************************************************** Initialize **********************************************************/
def temp-table tt_erros_conexao no-undo
    field ttv_cdn_erro                     as Integer format ">>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia".

def var v_hdl_btb_connect as handle no-undo.
def var v_log_sucesso     as log    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_produt_corren
    as character
    format 'x(50)'
    no-undo.

/* ** Chamada Programa ******/
run menu-es/es0940-1.w.
