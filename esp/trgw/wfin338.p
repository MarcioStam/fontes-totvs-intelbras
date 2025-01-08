/********************************************************************************
 ** UPC........: wfin388.p - UPC WRITE movto_bem_pat.
 ** Autor......: Andrey M Oliveira
 ** Data.......: 19/12/2018.
 ********************************************************************************/

DEF PARAM BUFFER b_movto_bem_pat     FOR movto_bem_pat.
DEF PARAM BUFFER b_old_movto_bem_pat FOR movto_bem_pat.

DEF BUFFER b_movto_bem_pat_2 FOR movto_bem_pat.
DEF BUFFER b_bem_pat         FOR bem_pat.
DEF BUFFER b_int_bem_pat_nf  FOR int_bem_pat_nf.

IF  AVAIL b_movto_bem_pat THEN DO:

    IF  b_movto_bem_pat.ind_trans_calc_bem_pat = "Implantaá∆o" THEN DO:
    
        FIND FIRST bem_pat
            WHERE bem_pat.num_id_bem_pat = b_movto_bem_pat.num_id_bem_pat EXCLUSIVE-LOCK NO-ERROR.

        IF  AVAIL bem_pat THEN DO:

            IF  b_movto_bem_pat.ind_orig_calc_bem_pat  = "Reclassificaá∆o" 
            OR  b_movto_bem_pat.ind_orig_calc_bem_pat  = "Uni∆o" 
            OR  b_movto_bem_pat.ind_orig_calc_bem_pat  = "Transferància" THEN DO:
                    
                ASSIGN bem_pat.cb3_ident_visual = string(bem_pat.num_bem_pat) + "/" + STRING(INT(bem_pat.num_seq_bem_pat),"999").

                RUN pi_localizacao.

                IF  b_movto_bem_pat.ind_orig_calc_bem_pat  = "Reclassificaá∆o" THEN DO:
                    FIND FIRST b_bem_pat NO-LOCK
                        WHERE b_bem_pat.num_id_bem_pat = b_movto_bem_pat.num_id_bem_pat_orig NO-ERROR.
            
                    IF  AVAIL b_bem_pat THEN DO:
        
                        FOR EACH int_bem_pat_nf
                            WHERE int_bem_pat_nf.cod_cta_pat     = b_bem_pat.cod_cta_pat
                            AND   int_bem_pat_nf.num_bem_pat     = b_bem_pat.num_bem_pat
                            AND   int_bem_pat_nf.num_seq_bem_pat = b_bem_pat.num_seq_bem_pat EXCLUSIVE-LOCK:
        
                            CREATE b_int_bem_pat_nf.
                            BUFFER-COPY int_bem_pat_nf EXCEPT cod_cta_pat num_bem_pat num_seq_bem_pat TO b_int_bem_pat_nf.
        
                            ASSIGN b_int_bem_pat_nf.cod_cta_pat     = bem_pat.cod_cta_pat    
                                   b_int_bem_pat_nf.num_bem_pat     = bem_pat.num_bem_pat    
                                   b_int_bem_pat_nf.num_seq_bem_pat = bem_pat.num_seq_bem_pat.
        
                            DELETE int_bem_pat_nf.
                        END.
                    END.
                END.
            END.
        END.
    END.
END.

PROCEDURE pi_localizacao:
    IF   bem_pat.cod_cta_pat <> "LOCACAO (12 MESES)"
    AND  bem_pat.cod_cta_pat <> "LOCACAO (24 MESES)"
    AND  bem_pat.cod_cta_pat <> "LOCACAO (36 MESES)"
    AND  bem_pat.cod_cta_pat <> "LOCACAO (48 MESES)"
    AND  bem_pat.cod_cta_pat <> "LOCACAO (60 MESES)"
    AND  bem_pat.cod_cta_pat <> "PROJ. ANDAM. INTAN"
    AND  bem_pat.cod_cta_pat <> "PROJETOS EM ANDAME"
    AND  bem_pat.cod_cta_pat <> "BENFEITORIA TERCER"
    AND  bem_pat.cod_cta_pat <> "VEICULOS" THEN DO:
    
        IF  bem_pat.cod_estab = "101" THEN
            ASSIGN bem_pat.cod_localiz = "PATRIMONIO".
    
        IF  bem_pat.cod_estab = "103" THEN
            ASSIGN bem_pat.cod_localiz = "MAXCOM".
    
        IF  bem_pat.cod_estab = "104" THEN
            ASSIGN bem_pat.cod_localiz = "SERTAO".
    
        IF  bem_pat.cod_estab = "105" THEN
            ASSIGN bem_pat.cod_localiz = "MANAUS".
    
        IF  bem_pat.cod_estab = "109" THEN
            ASSIGN bem_pat.cod_localiz = "DEPOSITO AM".
    END.
    ELSE
        ASSIGN bem_pat.cod_localiz = "".

END PROCEDURE.

RETURN 'OK'.
