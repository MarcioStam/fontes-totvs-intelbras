/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: ADEEDIT\(C).P
**  Objetivo: <comment>
**  Autor...: Intelbras - USER    
**  Data....: 19.05.2008 16:11
*******************************************************************************/

DEF INPUT PARAMETER c-cod-estabel  LIKE docum-est.cod-estabel.
DEF INPUT PARAMETER c-cod-esp      LIKE fat-duplic.cod-esp    .
DEF INPUT PARAMETER c-serie        LIKE fat-duplic.serie       .
DEF INPUT PARAMETER c-nr-fatura    LIKE fat-duplic.nr-fatura    .
DEF INPUT PARAMETER c-parcela      LIKE fat-duplic.parcela       .
DEF OUTPUT PARAMETER c-retorno     AS CHARACTER.
    
    ASSIGN c-retorno = "OK".
    FIND tit_acr NO-LOCK
        WHERE tit_acr.cod_estab   = c-cod-estabel
          AND tit_acr.cod_espec   = c-cod-esp
          AND tit_acr.cod_ser     = c-serie
          AND tit_acr.cod_tit_acr = c-nr-fatura
          AND tit_acr.cod_parcela = c-parcela NO-ERROR.

    IF  AVAIL tit_acr
    AND tit_acr.val_sdo_tit_acr > 0
    AND tit_acr.log_tit_acr_cobr_bcia = yes THEN DO:

         FIND LAST movto_ocor_bcia
              WHERE movto_ocor_bcia.cod_estab = tit_acr.cod_estab
              AND   movto_ocor_bcia.num_id_tit_acr = tit_acr.num_id_tit_acr
              AND   movto_ocor_bcia.ind_ocor_bcia_remes_ret = "Remessa"
              AND   (movto_ocor_bcia.ind_tip_ocor_bcia = "Implanta‡Æo"
              OR     movto_ocor_bcia.ind_tip_ocor_bcia  = "Envio Planilha")
              AND   movto_ocor_bcia.cod_portador = tit_acr.cod_portador
              AND   movto_ocor_bcia.cod_cart_bcia = tit_acr.cod_cart_bcia
              AND   movto_ocor_bcia.log_movto_envdo_bco = YES 
              USE-INDEX mvtcrbc_id NO-LOCK NO-ERROR.
         IF  AVAIL movto_ocor_bcia AND movto_ocor_bcia.log_confir_movto_envdo_bco = NO 
         AND (movto_ocor_bcia.num_id_movto_ocor_confir  = 0 OR movto_ocor_bcia.num_id_movto_ocor_confir  = ?) 
         THEN DO:
              ASSIGN c-retorno = "NOK".
         END.
    END.     
    RETURN.

