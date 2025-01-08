/*****************************************************************************
** Descricao.............: Importaá∆o Seguranáa Oráamento
** Nome Externo..........: esp/es0512zh.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 26/05/2015
*****************************************************************************/

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=22":U.
/*************************************  *************************************/

def temp-table tt_log_erros no-undo 
    field tta_num_seq        as integer format ">>>9" initial 0 label "Sequància" column-label "Seq" 
    field ttv_des_msg_erro   as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància" 
    field ttv_des_msg_ajuda  as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda". 

DEF TEMP-TABLE tt_seguranca NO-UNDO  
    FIELD tta_cod_usuario    AS CHAR
    FIELD tta_ccusto         AS CHAR
    FIELD tta_cod_empresa    AS CHAR
    FIELD tta_cod_estab      AS CHAR
    FIELD tta_cod_unid_negoc AS CHAR
    FIELD tta_num_seq        AS INT.

/************************** Stream Definition Begin *************************/

def stream s_1.

/*************************** Stream Definition End **************************/

DEFINE VARIABLE v_log_method AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_num_line   AS INTEGER     NO-UNDO.
def new global shared var v_nom_filename_import
    as character
    format "x(80)":U
    view-as editor max-chars 250 no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    label "Nome Arquivo"
    column-label "Arquivo"
    no-undo.
DEFINE VARIABLE v_des_reg_import AS CHARACTER   NO-UNDO.

/****************************** Main Code Begin *****************************/

run pi_rnl_histor_fornec_importar_ems.

/******************************* Main Code End ******************************/

PROCEDURE pi_rnl_histor_fornec_importar_ems:

    DEFINE VARIABLE v_cod_arq     AS CHARACTER   NO-UNDO.

    ASSIGN v_cod_arq = SESSION:TEMP-DIRECTORY + 'erro_seg_es5500.txt'.

    ASSIGN v_log_method = SESSION:SET-WAIT-STATE('general') 
           v_num_line = 0.

    INPUT FROM VALUE(v_nom_filename_import).

    REPEAT:
               
        IMPORT UNFORMATTED v_des_reg_import.

        ASSIGN v_num_line = v_num_line + 1.

        /* ** Registro Header ***/
        IF ENTRY(1, v_des_reg_import, ";") BEGINS "usu" 
           THEN NEXT.

        CREATE tt_seguranca.
        ASSIGN tt_seguranca.tta_cod_usuario    = ENTRY(1, v_des_reg_import, ";")
               tt_seguranca.tta_ccusto         = ENTRY(3, v_des_reg_import, ";")
               tt_seguranca.tta_cod_empresa    = ENTRY(5, v_des_reg_import, ";")
               tt_seguranca.tta_cod_estab      = ENTRY(6, v_des_reg_import, ";")
               tt_seguranca.tta_cod_unid_negoc = ENTRY(7, v_des_reg_import, ";")
               tt_seguranca.tta_num_seq        = v_num_line.

    END.

    INPUT CLOSE.

    FOR EACH tt_seguranca:

        FIND emscad.empresa NO-LOCK
            WHERE emscad.empresa.cod_empresa = tt_seguranca.tta_cod_empresa NO-ERROR.
        IF NOT AVAIL emscad.empresa
        THEN DO:
             CREATE tt_log_erros.
             ASSIGN tt_log_erros.tta_num_seq       = tt_seguranca.tta_num_seq
                    tt_log_erros.ttv_des_msg_erro  = "Empresa n∆o localizada!"
                    tt_log_erros.ttv_des_msg_ajuda = tt_seguranca.tta_cod_empresa.
             NEXT.
        END.

        FIND estabelecimento NO-LOCK
            WHERE estabelecimento.cod_empresa = tt_seguranca.tta_cod_empresa 
              AND estabelecimento.cod_estab   = tt_seguranca.tta_cod_estab NO-ERROR.
        IF NOT AVAIL estabelecimento
        THEN DO:
             CREATE tt_log_erros.
             ASSIGN tt_log_erros.tta_num_seq       = tt_seguranca.tta_num_seq
                    tt_log_erros.ttv_des_msg_erro  = "Estabelecimento n∆o localizado!"
                    tt_log_erros.ttv_des_msg_ajuda = tt_seguranca.tta_cod_empresa + " / " + tt_seguranca.tta_cod_estab.
             NEXT.
        END.
        
        FIND usuar_mestre NO-LOCK
            WHERE usuar_mestre.cod_usuario = tt_seguranca.tta_cod_usuario NO-ERROR.
        IF NOT AVAIL usuar_mestre
        THEN DO:
             CREATE tt_log_erros.
             ASSIGN tt_log_erros.tta_num_seq       = tt_seguranca.tta_num_seq
                    tt_log_erros.ttv_des_msg_erro  = "Usu†rio n∆o localizado!"
                    tt_log_erros.ttv_des_msg_ajuda = tt_seguranca.tta_cod_usuario.
             NEXT.
        END.

        FIND emscad.ccusto NO-LOCK
            WHERE emscad.ccusto.cod_empresa      = tt_seguranca.tta_cod_empresa
              AND emscad.ccusto.cod_plano_ccusto = "padrao"
              AND emscad.ccusto.cod_ccusto       = tt_seguranca.tta_ccusto NO-ERROR.
        IF NOT AVAIL emscad.ccusto
        AND tt_seguranca.tta_ccusto <> "*"
        THEN DO:
             CREATE tt_log_erros.
             ASSIGN tt_log_erros.tta_num_seq       = tt_seguranca.tta_num_seq
                    tt_log_erros.ttv_des_msg_erro  = "CCusto n∆o localizado!"
                    tt_log_erros.ttv_des_msg_ajuda = tt_seguranca.tta_ccusto.
             NEXT.
        END.

        FIND unid_negoc NO-LOCK
            WHERE unid_negoc.cod_unid_negoc = tt_seguranca.tta_cod_unid_negoc NO-ERROR.
        IF NOT AVAIL unid_negoc
        AND tt_seguranca.tta_cod_unid_negoc <> "*"
        THEN DO:
             CREATE tt_log_erros.
             ASSIGN tt_log_erros.tta_num_seq       = tt_seguranca.tta_num_seq
                    tt_log_erros.ttv_des_msg_erro  = "Unidade de Neg¢cio n∆o localizada!"
                    tt_log_erros.ttv_des_msg_ajuda = tt_seguranca.tta_cod_unid_negoc.
             NEXT.
        END.

    END.

    IF CAN-FIND(FIRST tt_log_erros) 
    THEN DO: 

         OUTPUT TO VALUE(v_cod_arq) CONVERT TARGET 'iso8859-1'.
    
         PUT UNFORMATTED "Seq;Mensagem;Ajuda" SKIP.

         FOR EACH tt_log_erros:
             PUT UNFORMATTED tt_log_erros.tta_num_seq ";" tt_log_erros.ttv_des_msg_erro ";" tt_log_erros.ttv_des_msg_ajuda SKIP.
         END.

         OUTPUT CLOSE.

         ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").
         
         MESSAGE "Erro ao importar o arquivo !" SKIP(1)
                 "Log dos erros no arquivo: " v_cod_arq
             VIEW-AS ALERT-BOX INFO BUTTONS OK.

         RETURN.
    END.
    
    /*bloco para eliminar a seguranáa e criar a seguranáa*/
    import_block:
    do on endkey undo import_block, leave import_block on error undo import_block, leave import_block:

        ASSIGN v_cod_arq = SESSION:TEMP-DIRECTORY + "usu-cc-un-orc.d".
        OUTPUT TO VALUE(v_cod_arq) CONVERT TARGET 'iso8859-1'.
        FOR EACH usu-cc-un-orc EXCLUSIVE-LOCK:
            EXPORT usu-cc-un-orc.
            DELETE usu-cc-un-orc.
        END.
        OUTPUT CLOSE.

        FOR EACH tt_seguranca:
            FIND usu-cc-un-orc NO-LOCK
                WHERE usu-cc-un-orc.cod-ccusto     = tt_seguranca.tta_ccusto        
                  AND usu-cc-un-orc.cod-empresa    = tt_seguranca.tta_cod_empresa   
                  AND usu-cc-un-orc.cod-estab      = tt_seguranca.tta_cod_estab     
                  AND usu-cc-un-orc.cod-unid-negoc = tt_seguranca.tta_cod_unid_negoc
                  AND usu-cc-un-orc.cod-usuario    = tt_seguranca.tta_cod_usuario NO-ERROR.
            IF AVAIL usu-cc-un-orc 
               THEN NEXT.

            CREATE usu-cc-un-orc.
            ASSIGN usu-cc-un-orc.cod-ccusto     = tt_seguranca.tta_ccusto
                   usu-cc-un-orc.cod-empresa    = tt_seguranca.tta_cod_empresa
                   usu-cc-un-orc.cod-estab      = tt_seguranca.tta_cod_estab
                   usu-cc-un-orc.cod-unid-negoc = tt_seguranca.tta_cod_unid_negoc
                   usu-cc-un-orc.cod-usuario    = tt_seguranca.tta_cod_usuario.

        END.

    END.

    ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").

    MESSAGE "Importaá∆o conclu°da!" VIEW-AS ALERT-BOX.

END PROCEDURE.
