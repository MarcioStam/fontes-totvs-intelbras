
{esp/cms/apb900zd.i}
{esp/cms/apb768za.i}
{esp/cms/apb767zc.i}

DEF TEMP-TABLE tt_log_erro_atualiz_rpc NO-UNDO 
    FIELD tta_cod_estab                    AS CHARACTER FORMAT "x(3)"     LABEL "Estabelecimento" column-label "Estab" 
    FIELD tta_cod_refer                    AS CHARACTER FORMAT "x(10)"    LABEL "Referºncia" column-label "Referºncia" 
    FIELD tta_num_seq_refer                AS INTEGER   FORMAT ">>>9"     INITIAL 0 label "Sequºncia" column-label "Seq" 
    FIELD ttv_num_mensagem                 AS INTEGER   FORMAT ">>>>,>>9" LABEL "Número" column-label "Número Mensagem" 
    FIELD ttv_des_msg_erro                 AS CHARACTER FORMAT "x(60)"    LABEL "Mensagem Erro" column-label "Inconsistºncia" 
    FIELD ttv_des_msg_ajuda                AS CHARACTER FORMAT "x(40)"    LABEL "Mensagem Ajuda" column-label "Mensagem Ajuda" 
    FIELD ttv_ind_tip_relacto              AS CHARACTER FORMAT "X(15)"    LABEL "Tipo Relacionamento" column-label "Tipo Relac" 
    FIELD ttv_num_relacto                  AS INTEGER   FORMAT ">>>>,>>9" LABEL  "Relacionamento" column-label "Relacionamento". 


DEFINE INPUT PARAMETER TABLE FOR tt_log_erros_atualiz.
DEFINE INPUT PARAMETER TABLE FOR tt_log_erros_tit_ap_alteracao.
DEFINE INPUT PARAMETER TABLE FOR tt_log_erro_atualiz_rpc.

DEFINE OUTPUT PARAMETER p_arquivo AS CHAR FORMAT "x(35)" NO-UNDO.


DEF VAR v_arquivo       AS CHAR FORMAT "x(35)"  NO-UNDO.

DEF STREAM Stream_1.
DEF STREAM Stream_2.

ASSIGN v_arquivo = session:TEMP-DIRECTORY +  STRING('erro_comis') + STRING(DAY(TODAY), "99") + STRING(MONTH(today),"99") + '.txt'.

OUTPUT STREAM stream_1 TO  VALUE(v_arquivo).

bloco:
DO TRANSACTION ON ERROR UNDO, LEAVE:

  FIND FIRST tt_log_erros_atualiz NO-LOCK NO-ERROR.
  IF AVAIL tt_log_erros_atualiz THEN 
  DO:
    /* Erros na execuá∆o da API */
    PUT STREAM stream_1 SKIP(2)'Ocorreram o(s) seguinte(s) erro(s) na IMPLANTAÄ«O do novo t°tulo e BAIXA das provis‰es de comiss∆o no Contas a Pagar:' SKIP(2). 
    FOR EACH tt_log_erros_atualiz NO-LOCK:
      PUT STREAM Stream_1  "Estab: "      tt_log_erros_atualiz.tta_cod_estab                    " ; "
                           "Refer: "     tt_log_erros_atualiz.tta_cod_refer                     " ; "
                           "Seq: "       tt_log_erros_atualiz.tta_num_seq_refer                 " ; "
                           "Num Msg: "   tt_log_erros_atualiz.ttv_num_mensagem                  " ; "
                           "Desc Msg: "  tt_log_erros_atualiz.ttv_des_msg_erro  FORMAT "x(20)"  " ; "
                           "Ajuda Msg: " tt_log_erros_atualiz.ttv_des_msg_ajuda FORMAT "x(200)" " ; " skip. 
    END.
    OUTPUT CLOSE.
  END.

  FIND FIRST tt_log_erro_atualiz_rpc NO-LOCK NO-ERROR.
  IF AVAIL tt_log_erro_atualiz_rpc THEN 
  DO:
    /* Erros na execuá∆o da API */
    PUT STREAM stream_1 SKIP(2)'Ocorreram o(s) seguinte(s) erro(s) na IMPLANTAÄ«O do novo t°tulo e BAIXA das provis‰es de comiss∆o no Contas a Pagar:' SKIP(2). 
    FOR EACH tt_log_erro_atualiz_rpc NO-LOCK:
      PUT STREAM Stream_1  "Estab: "     tt_log_erro_atualiz_rpc.tta_cod_estab                     " ; "
                           "Refer: "     tt_log_erro_atualiz_rpc.tta_cod_refer                     " ; "
                           "Seq: "       tt_log_erro_atualiz_rpc.tta_num_seq_refer                 " ; "
                           "Num Msg: "   tt_log_erro_atualiz_rpc.ttv_num_mensagem                  " ; "
                           "Desc Msg: "  tt_log_erro_atualiz_rpc.ttv_des_msg_erro  FORMAT "x(20)"  " ; "
                           "Ajuda Msg: " tt_log_erro_atualiz_rpc.ttv_des_msg_ajuda FORMAT "x(200)" " ; " skip. 
    END.
    OUTPUT CLOSE.
  END.

  
  FIND FIRST tt_log_erros_tit_ap_alteracao NO-LOCK NO-ERROR.
  IF AVAIL tt_log_erros_tit_ap_alteracao THEN 
  DO:
    /* Erros na execuá∆o da API */
    PUT STREAM stream_1 SKIP(2)'Ocorreram o(s) seguinte(s) erro(s) na ALTERAÄ«O (AVA) do novo t°tulo de comiss∆o no Contas a Pagar:' SKIP(2). 
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
    OUTPUT CLOSE.
  END.
   
END. /*do transaction*/


OUTPUT STREAM Stream_1 CLOSE.

ASSIGN p_arquivo = v_arquivo.
RUN pi-abre-edit (INPUT v_arquivo).

RETURN "ok".

PROCEDURE pi-abre-edit:
  DEF INPUT PARAM P_Cod_Dwb_File AS CHAR FORM "x(40)" NO-UNDO.
  DEF VAR V_Cod_Key_Value        AS CHAR FORM "x(08)" NO-UNDO.

  GET-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE V_Cod_Key_Value.
  if V_Cod_Key_Value = "" OR 
     V_Cod_Key_Value = ?  THEN 
  DO.
    ASSIGN V_Cod_Key_Value = 'start'.
    PUT-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE V_Cod_Key_Value NO-ERROR.
  END. /* End do - if V_Cod_Key_Value = "" OR V_Cod_Key_Value = ? */

  OS-COMMAND SILENT VALUE(V_Cod_Key_Value + CHR(32) + P_Cod_Dwb_File).
END PROCEDURE.






















