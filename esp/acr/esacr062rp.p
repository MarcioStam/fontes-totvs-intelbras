DEFINE TEMP-TABLE tt_param NO-UNDO
    FIELD arquivo            AS CHARACTER
    FIELD dat_emis_docto_ini LIKE tit_acr.dat_emis_docto
    FIELD dat_emis_docto_fim LIKE tit_acr.dat_emis_docto.

DEFINE INPUT PARAMETER TABLE FOR tt_param.

DEF BUFFER b_tit_acr       FOR tit_acr.
DEF BUFFER b_movto_tit_acr FOR movto_tit_acr.
DEFINE VARIABLE v_data  AS DATE        NO-UNDO.

FIND FIRST tt_param NO-LOCK NO-ERROR.

OUTPUT TO VALUE(tt_param.arquivo) NO-CONVERT.

PUT UNFORMATTED "Estab;EspÇcie;SÇrie;T°tulo;Parcela;Valor" SKIP.

DO v_data = tt_param.dat_emis_docto_ini TO tt_param.dat_emis_docto_fim:
    FOR EACH estabelecimento NO-LOCK:
        FOR EACH  tit_acr NO-LOCK
            WHERE tit_acr.cod_estab     = estabelecimento.cod_estab
              AND tit_acr.dat_emis      = v_data
              AND tit_acr.ind_tip_espec = 'antecipaá∆o':
            FIND FIRST movto_tit_acr OF tit_acr NO-LOCK
                WHERE  movto_tit_acr.ind_trans_acr = 'implantaá∆o' NO-ERROR.
            IF  NOT AVAIL movto_tit_acr THEN
                NEXT.

            FIND FIRST b_movto_tit_acr NO-LOCK
                WHERE  b_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab_tit_acr_pai
                  AND  b_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr_pai NO-ERROR.
            IF AVAIL b_movto_tit_acr THEN DO:
                 FIND FIRST b_tit_acr NO-LOCK
                     WHERE  b_tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                       AND  b_tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr
                       AND  b_tit_acr.num_id_tit_acr <> tit_acr.num_id_tit_acr NO-ERROR.
                 IF  b_tit_acr.val_abat_tit_acr = movto_tit_acr.val_movto_tit_acr THEN
                     PUT UNFORMATTED tit_acr.cod_estab ";" tit_acr.cod_espec ";" tit_acr.cod_ser ";" tit_acr.cod_tit_acr ";" tit_acr.cod_parcela ";" movto_tit_acr.val_movto_tit_acr SKIP.
            END.
        END.
    END.
END.

OUTPUT CLOSE.

MESSAGE "Impress∆o Finalizada!" SKIP
        "Arquivo gerado em: " tt_param.arquivo
    VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Impress∆o Finalizada!".

