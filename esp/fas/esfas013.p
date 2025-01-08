/*****************************************************************************
** Programa..............: esp/fas/esafas013.p
** Autor.................: Fabiano Zarpe Henke.
** Criado em.............: 28/08/2013
*****************************************************************************/

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

DEFINE VARIABLE v_cod_arq    AS CHAR NO-UNDO.
DEFINE VARIABLE v_arq_aux    AS CHAR NO-UNDO.
DEFINE VARIABLE v_log_method AS LOG  NO-UNDO.

MESSAGE "Confirma leitura da Vida étil ?"
        VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Vida étil" UPDATE choice AS LOGICAL.

IF  CHOICE = NO THEN DO: 
    RETURN.
END.

ASSIGN v_log_method = SESSION:SET-WAIT-STATE("General").

ASSIGN v_cod_arq = session:temp-directory + "esfas013_fiscal.csv"
       v_arq_aux = v_cod_arq.

OUTPUT TO VALUE(v_cod_arq).

PUT 'Cen rio;Conta Patrimonial;Bem;Seq;Estab;UN;CCusto;Anos;Tx Depr' SKIP.

FOR EACH bem_pat NO-LOCK
    WHERE bem_pat.cod_empresa = v_cod_empres_usuar:

    IF bem_pat.val_perc_bxa = 100 
       THEN NEXT.

    FIND param_calc_bem_pat OF bem_pat NO-LOCK 
        WHERE param_calc_bem_pat.cod_finalid = 'corrente'
          AND param_calc_bem_pat.cod_cenar   = 'fiscal'
          AND param_calc_bem_pat.qtd_anos_vida_util <> 0 NO-ERROR.
    
    IF AVAIL param_calc_bem_pat THEN DO:
         PUT param_calc_bem_pat.cod_cenar ';' bem_pat.cod_cta_pat ';' bem_pat.num_bem_pat ';' bem_pat.num_seq_bem_pat ';' bem_pat.cod_estab ';' bem_pat.cod_unid_negoc ';' bem_pat.cod_ccusto_resp ';' param_calc_bem_pat.qtd_anos_vida_util ';' param_calc_bem_pat.val_perc_anual_dpr SKIP.
    END.

END.
OUTPUT CLOSE.

ASSIGN v_cod_arq = session:temp-directory + "esfas013_ifrs.csv"
       v_arq_aux = v_arq_aux + " / " + v_cod_arq.

OUTPUT TO VALUE(v_cod_arq).

PUT 'Cen rio;Conta Patrimonial;Bem;Seq;Estab;UN;CCusto;Anos;Tx Depr' SKIP.

FOR EACH bem_pat NO-LOCK
    WHERE bem_pat.cod_empresa = v_cod_empres_usuar:

    IF bem_pat.val_perc_bxa = 100 
       THEN NEXT.

    FIND param_calc_bem_pat OF bem_pat NO-LOCK 
        WHERE param_calc_bem_pat.cod_finalid = 'corrente'
          AND param_calc_bem_pat.cod_cenar   = 'ifrs'
          AND param_calc_bem_pat.qtd_anos_vida_util <> 0 NO-ERROR.
    
    IF AVAIL param_calc_bem_pat THEN DO:
         PUT param_calc_bem_pat.cod_cenar ';' bem_pat.cod_cta_pat ';' bem_pat.num_bem_pat ';' bem_pat.num_seq_bem_pat ';' bem_pat.cod_estab ';' bem_pat.cod_unid_negoc ';' bem_pat.cod_ccusto_resp ';' param_calc_bem_pat.qtd_anos_vida_util ';' param_calc_bem_pat.val_perc_anual_dpr SKIP.
    END.

END.
OUTPUT CLOSE.

ASSIGN v_log_method = session:SET-WAIT-STATE("").

MESSAGE 'Arquivos gerados: ' v_arq_aux
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
