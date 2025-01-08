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

/* ** Verifica Bancos Externos somente se executado pelo EMS5, caso contr rio o banco j  est  conectado ****/
if v_cod_produt_corren = "EMS5"
then do:

     if not valid-handle(v_hdl_btb_connect) 
        then run prgtec/btb/btb009za.p persistent set v_hdl_btb_connect (Input 1,
                                                                         Input 1,
                                                                         Input "",
                                                                         Input "",
                                                                         output v_log_sucesso,
                                                                         output table tt_erros_conexao).

     /* ** Connect ***************/
     {include/i-connect.i 1 mgcad}

end.

/* ** Chamada Programa ******/
run esp/acr/esacr050-2.w.

if v_cod_produt_corren = "EMS5"
then do:

     /* ** Disconnect ************/
     {include/i-connect.i 2 mgcad}

     if valid-handle(v_hdl_btb_connect) 
        then delete procedure v_hdl_btb_connect.

end.
