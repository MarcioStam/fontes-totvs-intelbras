/******************************************************************************
** Programa: escms004.p
** Data....: Dezembro/2004
** Autor...: Maria Ester - Gestech.
** Objetivo: Imprime log de erro do procesamento de comiss‰es
** Versao..: 1.00
******************************************************************************/

/* Temp-table para envio de e-mail */                 
def temp-table tt_mail_fax no-undo
    field ttv_nom_servid	as character format "x(30)"
    field ttv_num_porta_servid	as integer format ">>>>9"
    field ttv_log_exchange	as logical format "Sim/N∆o" initial no
    field ttv_nom_from		as character format "x(50)"
    field ttv_nom_to		as character format "x(50)" label "To"
    field ttv_nom_cc		as character format "x(50)" label "Cc"
    field ttv_nom_subject	as character format "x(30)"
    field ttv_nom_message	as character format "x(50)"
    field ttv_nom_attachfile	as character format "x(30)"
    field ttv_num_imptcia	as integer format "9"
    field ttv_log_envda		as logical format "Sim/N∆o" initial no
    field ttv_log_lida		as logical format "Sim/N∆o" initial no
    field ttv_cod_format_mail   as character format "x(8)"  initial "TEXTO".

def temp-table tt_erros_mail_fax no-undo
    field ttv_cod_erro		as character format "x(10)"
    field ttv_des_erro		as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_arquivo	as character format "x(255)".
/* Temp-table para envio de e-mail */                 


DEF TEMP-TABLE tt_erro
     FIELD cod_estab               LIKE tit_acr.cod_estab                        
     FIELD cod_especie             LIKE tit_acr.cod_espec_docto                        
     FIELD serie                   LIKE tit_acr.cod_ser_docto                              
     FIELD cod_tit_acr             LIKE tit_acr.cod_tit_acr                              
     FIELD cod_parcela             LIKE tit_acr.cod_parcela                              
     FIELD cdn_repres              LIKE tit_acr.cdn_repres                               
     FIELD nom_repres              LIKE representante.nom_abrev                          
     FIELD dat_transacao           LIKE movto_tit_acr.dat_transacao                      
     FIELD trans_abrev             LIKE movto_tit_acr.ind_trans_acr_abrev  
     FIELD cod_refer               LIKE movto_tit_acr.num_id_movto_tit_acr
     FIELD vlr_trans               LIKE movto_tit_acr.val_movto_tit_acr                  
     FIELD mensagem                AS CHAR FORMAT "x(145)" .

{esp/cms/apb900zd.i}
{esp/cms/apb768za.i}
{esp/cms/apb767zc.i}

DEFINE INPUT PARAMETER TABLE FOR tt_erro.
DEFINE INPUT PARAMETER TABLE FOR tt_log_erros_atualiz.
DEFINE INPUT PARAMETER TABLE FOR tt_log_erros_tit_ap_alteracao.
DEFINE INPUT PARAMETER TABLE FOR tt_log_erros_estorn_cancel_apb.
DEF VAR v_arquivo       AS CHAR FORMAT "x(35)"  NO-UNDO.
DEF VAR v_arquivo_email AS CHAR FORMAT "x(35)"  NO-UNDO.
DEF VAR l-manda-mail    AS LOG.


def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

DEF STREAM Stream_1.
DEF STREAM Stream_2.

/*ASSIGN v_arquivo = session:TEMP-DIRECTORY +  STRING('erro_comis') + STRING(DAY(TODAY), "99") + STRING(MONTH(today),"99") + '.txt'. em 13/04/2005 Mario Fleith*/

ASSIGN v_arquivo = session:TEMP-DIRECTORY +  STRING('ercms') + STRING(DAY(TODAY), "99") + STRING(MONTH(today),"99") + CAPS(v_cod_usuar_corren) + STRING(TIME) + '.txt'.

IF v_cod_usuar_corren <> 'SUPER' THEN DO:
   FOR EACH tt_erro EXCLUSIVE-LOCK
       WHERE tt_erro.mensagem BEGINS '3 - Pr'
       OR    tt_erro.mensagem BEGINS '14 - Ti'
       OR    tt_erro.mensagem BEGINS '7 - N':
       DELETE tt_erro.
   END.
END.
   

OUTPUT STREAM stream_1 TO  VALUE(v_arquivo).

FIND FIRST tt_erro NO-LOCK NO-ERROR.
IF AVAIL tt_erro THEN DO:
   ASSIGN l-manda-mail = YES.
   PUT STREAM Stream_1 SKIP(1)
              STRING(TODAY) ' ' STRING(TIME,'hh:mm:ss') ' ' CAPS(v_cod_usuar_corren) ' '
              'Ocorreram o(s) seguinte(s) erro(s) na pesquisa dos t°tulos do Contas a Receber, Alteraá∆o Inv†lida!!:' SKIP(2).    
   FOR EACH tt_erro
       BREAK BY tt_erro.cod_estab
             BY tt_erro.cod_tit_acr:
       IF FIRST-OF(tt_erro.cod_tit_acr) THEN DO:
          DISP STREAM Stream_1 
               tt_erro.cod_estab     COLUMN-LABEL "Estab"
               tt_erro.cod_especie   COLUMN-LABEL "Esp"
               tt_erro.serie         COLUMN-LABEL "Sr"
               tt_erro.cod_tit_acr   COLUMN-LABEL "Titulo"
               tt_erro.cod_parcela   COLUMN-LABEL "P"
               tt_erro.cod_refer     COLUMN-LABEL "Refer"
               tt_erro.cdn_repres    COLUMN-LABEL "Repres"
               tt_erro.nom_repres    COLUMN-LABEL "Nome abrev"
               WITH DOWN FRAME f_erro STREAM-IO NO-BOX WIDTH 145.
       END.
       DISPLAY STREAM Stream_1 
               tt_erro.dat_transacao COLUMN-LABEL "Dat.Trans"
               tt_erro.TRANS_abrev   COLUMN-LABEL "Trans"
               tt_erro.vlr_trans     COLUMN-LABEL  "Valor"
               tt_erro.mensagem      COLUMN-LABEL "Mensagem" 
               WITH DOWN FRAME f_erro STREAM-IO NO-BOX WIDTH 145.
       DOWN WITH FRAME f-erro.
   END.
END.

FIND FIRST tt_log_erros_atualiz NO-LOCK NO-ERROR.
IF AVAIL tt_log_erros_atualiz THEN DO:
   ASSIGN l-manda-mail = YES.
   /* Erros na execuá∆o da API */
   PUT STREAM stream_1 SKIP(2)
                       STRING(TODAY) ' ' STRING(TIME,'hh:mm:ss') ' ' CAPS(v_cod_usuar_corren) ' '
                       'Ocorreram o(s) seguinte(s) erro(s) na geraá∆o dos t°tulos de previs∆o/provis∆o de comiss∆o no Contas a Pagar:' SKIP(2). 
   FOR EACH tt_log_erros_atualiz NO-LOCK:
       PUT STREAM Stream_1  "Estab: "     tt_log_erros_atualiz.tta_cod_estab     " ; "       
                            "Refer: "     tt_log_erros_atualiz.tta_cod_refer     " ; " 
                            "Seq: "       tt_log_erros_atualiz.tta_num_seq_refer " ; "       
                            "Num Msg: "   tt_log_erros_atualiz.ttv_num_mensagem   " ; "       
                            "Desc Msg: "  tt_log_erros_atualiz.ttv_des_msg_erro  " ; "       
                            "Ajuda Msg: " tt_log_erros_atualiz.ttv_des_msg_ajuda FORMAT "x(200)" " ; " skip. 
       FIND FIRST movto_tit_ap 
            WHERE movto_tit_ap.cod_estab = tt_log_erros_atualiz.tta_cod_estab
            AND   movto_tit_ap.cod_refer =  tt_log_erros_atualiz.tta_cod_refer no-lock no-error.
       FIND FIRST tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.
       IF AVAIL tit_ap THEN
           PUT STREAM Stream_1 "Fornecedor: " tit_ap.cdn_fornecedor " ; "
                               "Especie: " tit_ap.cod_espec_docto " ; "
                               "Serie:   " tit_ap.cod_ser_docto " ; "
                               "Titulo:  " tit_ap.cod_tit_ap " ; "
                               "Parcela: " tit_ap.cod_parcela " ; " SKIP.
   END.
END.
  
FIND FIRST tt_log_erros_estorn_cancel_apb NO-LOCK NO-ERROR.                                                                                         
IF AVAIL tt_log_erros_estorn_cancel_apb THEN DO:
   ASSIGN l-manda-mail = YES.
    /* Erros no cancelamento da previs∆o de comissao */
   PUT STREAM stream_1 SKIP(2)
                       STRING(TODAY) ' ' STRING(TIME,'hh:mm:ss') ' ' CAPS(v_cod_usuar_corren) ' '
                       'Ocorreram o(s) seguinte(s) erro(s) no cancelamento do t°tulo de provis∆o de comiss∆o no Contas a Pagar:' SKIP(2).     
   FOR EACH tt_log_erros_estorn_cancel_apb NO-LOCK:                                                                                                   
       PUT STREAM Stream_1  "Estab: "     tt_log_erros_estorn_cancel_apb.tta_cod_estab     " ; "                                                      
                            "Refer: "     tt_log_erros_estorn_cancel_apb.tta_cod_refer     " ; "                                                      
                            "Num Msg: "   tt_log_erros_estorn_cancel_apb.tta_num_mensagem  " ; "                                                      
                            "Desc Msg: "  tt_log_erros_estorn_cancel_apb.ttv_des_msg_erro  " ; "                                                      
                            "Ajuda Msg: " tt_log_erros_estorn_cancel_apb.ttv_des_msg_ajuda FORMAT "x(200)" " ; " skip.                                
       FIND FIRST movto_tit_ap 
            WHERE movto_tit_ap.cod_estab = tt_log_erros_estorn_cancel_apb.tta_cod_estab
            AND   movto_tit_ap.cod_refer = tt_log_erros_estorn_cancel_apb.tta_cod_refer no-lock no-error.
       FIND FIRST tit_ap OF movto_tit_ap NO-LOCK NO-ERROR.
       IF AVAIL tit_ap THEN
          PUT STREAM Stream_1 "Fornecedor: " tit_ap.cdn_fornecedor " ; "
                              "Especie: " tit_ap.cod_espec_docto " ; "
                              "Serie:   " tit_ap.cod_ser_docto " ; "
                              "Titulo:  " tit_ap.cod_tit_ap " ; "
                              "Parcela: " tit_ap.cod_parcela " ; " SKIP.
   END.
END.
    

FIND FIRST tt_log_erros_tit_ap_alteracao NO-LOCK NO-ERROR.
IF AVAIL tt_log_erros_tit_ap_alteracao THEN DO:
   ASSIGN l-manda-mail = YES.
    /* Erros na execuá∆o da API */
   PUT STREAM stream_1 SKIP(2) 
                       STRING(TODAY) ' ' STRING(TIME,'hh:mm:ss') ' ' CAPS(v_cod_usuar_corren) ' '
                       'Ocorreram o(s) seguinte(s) erro(s) na alteraá∆o dos t°tulos de previs∆o de comiss∆o no Contas a Pagar:' SKIP(2). 
   FOR EACH tt_log_erros_tit_ap_alteracao NO-LOCK:
       PUT STREAM Stream_1  "Estab: "     tt_log_erros_tit_ap_alteracao.tta_cod_estab       " ; "       
                            "Fornec: "    tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor  " ; "     
                            "espec: "    tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto " ; "    
                            "serie "     tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto   " ; "    
                            "t°tulo: "   tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap      " ; "    
                            "Parc: "     tt_log_erros_tit_ap_alteracao.tta_cod_parcela     " ; "  
                            "Num Msg: "   tt_log_erros_tit_ap_alteracao.ttv_num_mensagem  " ; "       
                            "Desc Msg: "  tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro  " ; "       
                            "Ajuda Msg: " tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda FORMAT "x(200)" " ; " skip. 
   END.
END.

OUTPUT STREAM Stream_1 CLOSE.

    /*    envio de e-mail */
    
IF l-manda-mail = YES THEN DO:

    find first param_geral_btb no-lock no-error.
        
    create tt_mail_fax.
    assign tt_mail_fax.ttv_nom_to           = "fran@intelbras.com.br,grupo.contabil@intelbras.com.br"
           tt_mail_fax.ttv_nom_from         = "ems@intelbras.com.br"
           tt_mail_fax.ttv_nom_message      = "ESCMS004 - Ocorreram inconsistàncias na geraá∆o da rotina de comiss∆o de representante, favor verificar o arquivo anexado."
           tt_mail_fax.ttv_nom_attachfile   = v_arquivo    
           tt_mail_fax.ttv_num_imptcia      = 2
           tt_mail_fax.ttv_cod_format_mail  = "texto"
           tt_mail_fax.ttv_nom_servid       = param_geral_btb.cod_ip_servid_mail 
           tt_mail_fax.ttv_num_porta_servid = param_geral_btb.num_porta_servid_e_mail
           tt_mail_fax.ttv_log_exchange     = NO.                    
        
    IF entry(4,dbparam("emsfin")) BEGINS '-S 18'  THEN DO:
       ASSIGN tt_mail_fax.ttv_nom_subject  = '| TESTE |' + CAPS(v_cod_usuar_corren) + ' ' + STRING(TODAY) + ' ' + STRING(TIME,'hh:mm:ss') + ' ' + string(entry(4,dbparam("emsfin")),'x(10)') + ' - ' + 
                                             " Inconsistàncias na rotina de comiss∆o de representante".
    END.
    ELSE DO:
       ASSIGN tt_mail_fax.ttv_nom_subject = CAPS(v_cod_usuar_corren) + ' ' + STRING(TODAY) + ' ' + STRING(TIME,'hh:mm:ss') + '  - ' +
                                            " Inconsistàncias na rotina de comiss∆o de representante".
    END.
        
    run prgtec/btb/btb916za.py (input "1",
                      	        input  table tt_mail_fax,
               	                output table tt_erros_mail_fax).
                                   
        /* Erro da API de envio de email ser∆o enviados para um arquivo no diret¢rio tempor†rio */
    IF CAN-FIND(tt_erros_mail_fax) THEN DO:
       ASSIGN v_arquivo_email = session:TEMP-DIRECTORY +  STRING('log_erro_email') + STRING(DAY(TODAY), "99") + STRING(MONTH(today),"99") + '.txt'.
        
       OUTPUT STREAM stream_2 TO  VALUE(v_arquivo_email) APPEND.
        
       PUT STREAM stream_2 SKIP(2)
                           STRING(TODAY) ' ' STRING(TIME,'hh:mm:ss') ' ' CAPS(v_cod_usuar_corren) ' '
                           'Ocorreram o(s) seguinte(s) erro(s) na API de envio de email referente a rotina de comiss∆o:' SKIP(2).     
        
       FOR EACH tt_erros_mail_fax NO-LOCK:                                                                                                   
           PUT STREAM Stream_2  "Erro: "       tt_erros_mail_fax.ttv_cod_erro  " ; "                                                      
                                "Desc Erro: "  tt_erros_mail_fax.ttv_des_erro      " ; "                                                      
                                "Desc Arq: "   tt_erros_mail_fax.ttv_des_arquivo  " ; " skip.                                
       END.
       OUTPUT STREAM Stream_2 CLOSE.
    END.
    ELSE DO:
       OS-DELETE VALUE(v_arquivo). 
    END.
END.
RETURN "ok".
