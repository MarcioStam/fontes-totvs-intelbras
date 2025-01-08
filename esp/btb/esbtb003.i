
PROCEDURE pi-busca-estab:

    DEFINE INPUT  PARAMETER p-cod-usuario    AS CHAR    NO-UNDO.


    find usuar_mestre no-lock
         where usuar_mestre.cod_usuario = p-cod-usuario.

    find usuar_univ no-lock
         where usuar_univ.cod_usuario = usuar_mestre.cod_usuario
         no-error.

    find estabelecimento no-lock
         where estabelecimento.cod_estab = usuar_univ.cod_estab
          no-error.


    ASSIGN v_cod_estab_usuar = usuar_univ.cod_estab.

    /*
    assign v_cod_estab_usuar          = emsuni.usuar_univ.cod_estab
            v_cod_empres_usuar        = emsuni.usuar_univ.cod_empresa
            v_cod_pais_empres_usuar   = emsuni.estabelecimento.cod_pais
            v_cod_plano_ccusto_corren = emsuni.usuar_univ.cod_plano_ccusto
            v_cod_ccusto_corren       = emsuni.usuar_univ.cod_ccusto.
            */


    RETURN "OK":U.

END PROCEDURE.
