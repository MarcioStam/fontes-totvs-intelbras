/*****************************************************************************
**     Programa.........: esp/cfl/escfl001rp.p
**     Descricao .......: Relat¢rio Gera‡Æo fluxo de caixa
*******************************************************************************/

def var v_hdl_btb_connect as handle no-undo.
def var v_log_sucesso     as log    no-undo.

DEF NEW GLOBAL SHARED VAR V_Num_Ped_Exec_Corren   AS   INTE   FORM ">>>>>9" NO-UNDO.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

def temp-table tt_erros_conexao no-undo
    field ttv_cdn_erro                     as Integer format ">>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia".

/* ** Chamada Programa ******/
RUN esp/cfl/escfl001rp-2.p.
