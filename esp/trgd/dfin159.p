/********************************************************************************
 ** UPC........: UPC Delete aloc_bem
 ** Data.......: Novembro / 2020
 ** Objetivo...: Historico de exclusäes da aloca‡Æo do bem.
 ********************************************************************************/

DEF PARAM BUFFER b_aloc_bem FOR aloc_bem.

DEF VAR c-hist    AS CHAR                                                        NO-UNDO.   
DEF VAR v_num_seq AS INT FORMAT ">>>,>>9":U LABEL "Sequˆncia" COLUMN-LABEL "Seq" NO-UNDO.

DEF BUFFER b_tab_espec_financ FOR tab_espec_financ.

FUNCTION fn-monta-origem RETURNS CHAR FORWARD.

{utp/ut-glob.i}

FIND LAST b_tab_espec_financ
    WHERE b_tab_espec_financ.cod_modul_dtsul = "FAS"                            
    AND   b_tab_espec_financ.cod_tabela      = "aloc_bem"                       
    AND   b_tab_espec_financ.cod_reg_tab     = STRING(b_aloc_bem.num_id_bem_pat)
    NO-LOCK NO-ERROR.

IF  AVAIL b_tab_espec_financ THEN 
    ASSIGN v_num_seq = b_tab_espec_financ.num_seq + 1.
ELSE 
    ASSIGN v_num_seq = 1.

CREATE tab_espec_financ.
ASSIGN tab_espec_financ.cod_modul_dtsul    = "FAS"
       tab_espec_financ.cod_tabela         = "aloc_bem"
       tab_espec_financ.cod_reg_tab        = STRING(b_aloc_bem.num_id_bem_pat)
       tab_espec_financ.num_seq            = v_num_seq
       tab_espec_financ.ind_event          = "EXC"
       tab_espec_financ.dat_transacao      = TODAY
       tab_espec_financ.hra_transacao      = STRING(TIME,"HH:MM:SS" /*l_hh:mm:ss*/ )
       tab_espec_financ.des_histor_tab     = "Centro de Custo: " + b_aloc_bem.cod_ccusto             +
                                             " Plano CCusto: "   + b_aloc_bem.cod_plano_ccusto       + 
                                             " Unid Negoc: "     + b_aloc_bem.cod_unid_negoc         + 
                                             " Perc Aloc: "      + STRING(b_aloc_bem.val_perc_aprop) + CHR(10) +
                                             " Programas: "      + fn-monta-origem()
       tab_espec_financ.cod_usuario        = v_cod_usuar_corren
       tab_espec_financ.ind_tip_alter      = "Eliminado"
       tab_espec_financ.cod_release_produt = '{&emsfin_version}'
       tab_espec_financ.raw_reg_tab        = ? .

IF RECID(tab_espec_financ) <> ? THEN.

FUNCTION fn-monta-origem RETURNS CHAR:
   RETURN PROGRAM-NAME(1) + " - " +
          PROGRAM-NAME(2) + " - " +
          PROGRAM-NAME(3) + " - " +
          PROGRAM-NAME(4) + " - " +
          PROGRAM-NAME(5) + " - " +
          PROGRAM-NAME(6) .
END FUNCTION.
