/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esapb020rp 1.00.00.000}
/*****************************************************************************
**
**       Programa: esp/apb/esapb020rp.p
**
**       Data....: 28/12/2015.
**
**       Autor...: Hoepers
**
**       Objetivo: Abatimento de Antecipa‡äes.
**
*******************************************************************************/

def new global shared var v_des_contdo_prog_valid_dtsul as CHARACTER format "x(40)":U no-undo.
def new global shared var v_log_monit_tab_espec_financ  as LOGICAL initial NO         no-undo.

ASSIGN v_des_contdo_prog_valid_dtsul = "esapb020-api"
       v_log_monit_tab_espec_financ  = YES.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar      AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar       AS CHAR NO-UNDO.

{include/i-rpvar.i}    
{esp/apb/esapb020.i}
{utp/utapi019.i}

def input parameter  raw-param as raw no-undo.
def input parameter  table for tt-raw-digita.

def temp-table tt_log_erros_tit_ap_alteracao no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda_1              as character format "x(250)"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9".

def temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento".

DEF TEMP-TABLE tt_concil NO-UNDO
    FIELD num_id_tt_concil      AS INT
    FIELD cod_tip_reg           AS INT
    FIELD cod_estab             LIKE tit_ap.cod_estab     
    FIELD cdn_fornec            LIKE tit_ap.cdn_fornec    
    FIELD cod_espec             LIKE tit_ap.cod_espec     
    FIELD cod_ser               LIKE tit_ap.cod_ser      
    FIELD cod_tit_ap            LIKE tit_ap.cod_tit_ap
    FIELD cod_parcela           LIKE tit_ap.cod_parcela
    FIELD dat_transacao         LIKE tit_ap.dat_transacao
    FIELD cod_indic_econ        LIKE tit_ap.cod_indic_econ
    FIELD val_sdo               LIKE tit_ap.val_sdo
    FIELD log_conf              AS LOG LABEL "Status" FORMAT "Sim/NÆo" 
    FIELD des_status            AS CHAR LABEL "Op‡Æo" FORMAT "x(30)"
  INDEX tt_concil
        num_id_tt_concil        ASCENDING
        cod_tip_reg             ASCENDING
        cod_estab               ASCENDING
        cdn_fornec              ASCENDING
        cod_espec               ASCENDING
        cod_ser                 ASCENDING
        cod_tit_ap              ASCENDING
        cod_parcela             ASCENDING
  INDEX tt_concil_tit
        cod_estab               ASCENDING
        cdn_fornec              ASCENDING
        cod_espec               ASCENDING
        cod_ser                 ASCENDING
        cod_tit_ap              ASCENDING
        cod_parcela             ASCENDING.

DEF BUFFER b_tt_concil FOR tt_concil.

DEFINE VARIABLE h-acomp        AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-esapb020-api AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-tipo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-anexo    AS CHARACTER   NO-UNDO.
                       
create tt-param.
raw-transfer raw-param to tt-param.

ASSIGN c-arq-anexo = tt-param.arquivo.

IF  tt-param.i-tipo-concilia <> 5 /* Ambos */
THEN DO:
    IF  tt-param.i-tipo-concilia = 1 /* Imposto */
    THEN
        ASSIGN tt-param.c-email-importacao = "".
    ELSE
        ASSIGN tt-param.c-email-imposto = "".
END.

{include/i-rpout.i}


RUN utp/ut-acomp.p         PERSISTENT SET h-acomp.
RUN esp/apb/esapb020-api.p PERSISTENT SET h-esapb020-api.

EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.
EMPTY TEMP-TABLE tt_log_erros_atualiz.
EMPTY TEMP-TABLE tt_concil.

RUN pi-inicializar IN h-acomp (INPUT "Inicializando...").
RUN pi-inicializar IN h-esapb020-api (INPUT tt-param.cod_empres_usuar,
                                      INPUT tt-param.cod_estab_usuar,
                                      INPUT tt-param.i-tipo-concilia,
                                      INPUT tt-param.dt-pagto,
                                      INPUT tt-param.de-val-max-ava,
                                      INPUT tt-param.c-conta-ava,
                                      INPUT tt-param.de-val-min-parcial,
                                      OUTPUT TABLE tt_concil).

IF  tt-param.i-tipo-email <> 1 /* Conciliadas*/
THEN DO:
    PUT UNFORMATTED ";;;;;NÇO CONCILIADAS" SKIP.
    PUT UNFORMATTED "Estab;Fornecedor;Esp‚cie;S‚rie;T¡tulo;Parc;Transa‡Æo;Moeda;Vl Saldo" SKIP.

    FOR EACH   tt_concil
        WHERE  tt_concil.des_status BEGINS "Gera AVA"
          AND (tt_concil.val_sdo  > tt-param.de-val-max-ava
           OR  tt_concil.val_sdo  < (tt-param.de-val-max-ava * -1)),
        EACH  b_tt_concil NO-LOCK
        WHERE b_tt_concil.num_id_tt_concil = tt_concil.num_id_tt_concil:

        IF  b_tt_concil.cdn_fornec = 0 AND
            b_tt_concil.val_sdo    = 0
        THEN
            NEXT.

        IF  b_tt_concil.des_status BEGINS "Gera AVA"
        THEN
            ASSIGN b_tt_concil.cod_indic_econ = "DIFEREN€A".

        PUT UNFORMATTED b_tt_concil.cod_estab         ";"
                        b_tt_concil.cdn_fornec        ";"
                        b_tt_concil.cod_espec         ";"
                        b_tt_concil.cod_ser           ";"
                        b_tt_concil.cod_tit_ap        ";"
                        b_tt_concil.cod_parcela       ";"
                        b_tt_concil.dat_transacao     ";"
                        b_tt_concil.cod_indic_econ    ";"
                        b_tt_concil.val_sdo           ";" SKIP.
    END.
END. /* IF  tt-param.i-tipo-email <> 1 */


EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.
EMPTY TEMP-TABLE tt_log_erros_atualiz.

RUN pi_atualizar IN h-esapb020-api.

RUN pi_retorna_erros IN h-esapb020-api (OUTPUT TABLE tt_log_erros_tit_ap_alteracao,
                                        OUTPUT TABLE tt_log_erros_atualiz).

IF  NOT CAN-FIND(FIRST tt_log_erros_atualiz) AND
    NOT CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao)
THEN DO:  
    IF  tt-param.i-tipo-email = 1 OR /* Conciliadas */
        tt-param.i-tipo-email = 3    /* Ambos       */
    THEN DO:
        PUT UNFORMATTED SKIP(2).
        PUT UNFORMATTED ";;;;;CONCILIADAS SEM AVA" SKIP.
        PUT UNFORMATTED "Estab;Fornecedor;Esp‚cie;S‚rie;T¡tulo;Parc;Transa‡Æo;Moeda;Vl Saldo" SKIP.

        FOR EACH  tt_concil
            WHERE tt_concil.val_sdo  = 0
              AND tt_concil.des_status BEGINS "Gera AVA",
            EACH  b_tt_concil NO-LOCK
            WHERE b_tt_concil.num_id_tt_concil = tt_concil.num_id_tt_concil:

            IF  b_tt_concil.cdn_fornec = 0 AND
                b_tt_concil.val_sdo    = 0 AND
                b_tt_concil.des_status = ""
            THEN
                NEXT.

            IF  b_tt_concil.des_status BEGINS "Gera AVA"
            THEN
                ASSIGN b_tt_concil.cod_indic_econ = "DIFEREN€A".

            PUT UNFORMATTED b_tt_concil.cod_estab         ";"
                            b_tt_concil.cdn_fornec        ";"
                            b_tt_concil.cod_espec         ";"
                            b_tt_concil.cod_ser           ";"
                            b_tt_concil.cod_tit_ap        ";"
                            b_tt_concil.cod_parcela       ";"
                            b_tt_concil.dat_transacao     ";"
                            b_tt_concil.cod_indic_econ    ";"
                            b_tt_concil.val_sdo           ";" SKIP.
        END.

        PUT UNFORMATTED SKIP(2).
        PUT UNFORMATTED ";;;;;CONCILIADAS COM AVA" SKIP.
        PUT UNFORMATTED "Estab;Fornecedor;Esp‚cie;S‚rie;T¡tulo;Parc;Transa‡Æo;Moeda;Vl Saldo" SKIP.

        FOR EACH   tt_concil
            WHERE  tt_concil.des_status BEGINS "Gera AVA"
              AND  tt_concil.val_sdo  <> 0
              AND (tt_concil.val_sdo  >= (tt-param.de-val-max-ava * -1)
              AND  tt_concil.val_sdo  <=  tt-param.de-val-max-ava),
            EACH  b_tt_concil NO-LOCK
            WHERE b_tt_concil.num_id_tt_concil = tt_concil.num_id_tt_concil:

            IF  b_tt_concil.cdn_fornec = 0 AND
                b_tt_concil.val_sdo    = 0 AND
                b_tt_concil.des_status = ""
            THEN
                NEXT.                      

            IF  b_tt_concil.des_status BEGINS "Gera AVA"
            THEN
                ASSIGN b_tt_concil.cod_indic_econ = "DIFEREN€A".

            PUT UNFORMATTED b_tt_concil.cod_estab         ";"
                            b_tt_concil.cdn_fornec        ";"
                            b_tt_concil.cod_espec         ";"
                            b_tt_concil.cod_ser           ";"
                            b_tt_concil.cod_tit_ap        ";"
                            b_tt_concil.cod_parcela       ";"
                            b_tt_concil.dat_transacao     ";"
                            b_tt_concil.cod_indic_econ    ";"
                            b_tt_concil.val_sdo           ";" SKIP.
        END.
    END. /* IF  tt-param.i-tipo-email = 1 */
END. /* IF  NOT CAN-FIND(FIRST tt_log_erros_atualiz) AND */
ELSE DO:
    PUT UNFORMATTED SKIP(2).
    PUT UNFORMATTED ";;;;;ERROS CONCILIA€ÇO" SKIP.
    PUT UNFORMATTED "Estab;Fornecedor;Esp‚cie;S‚rie;T¡tulo;Parc;MSG;Erro;Ajuda;Complemento" SKIP.

    FOR EACH tt_log_erros_tit_ap_alteracao NO-LOCK:
        PUT UNFORMATTED tt_log_erros_tit_ap_alteracao.tta_cod_estab       ";"
                        tt_log_erros_tit_ap_alteracao.tta_cdn_fornecedor  ";"
                        tt_log_erros_tit_ap_alteracao.tta_cod_espec_docto ";"
                        tt_log_erros_tit_ap_alteracao.tta_cod_ser_docto   ";"
                        tt_log_erros_tit_ap_alteracao.tta_cod_tit_ap      ";"
                        tt_log_erros_tit_ap_alteracao.tta_cod_parcela     ";"
                        tt_log_erros_tit_ap_alteracao.ttv_num_mensagem    ";"
                        tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro    ";"
                        tt_log_erros_tit_ap_alteracao.ttv_des_msg_ajuda   ";" 
                        SKIP.
    END.

    FOR EACH tt_log_erros_atualiz:
        PUT UNFORMATTED tt_log_erros_atualiz.tta_cod_estab       ";;;;;;"
                        tt_log_erros_atualiz.ttv_num_mensagem    ";"
                        tt_log_erros_atualiz.ttv_des_msg_erro    ";"
                        tt_log_erros_atualiz.ttv_des_msg_ajuda   ";"
                        tt_log_erros_atualiz.ttv_ind_tip_relacto 
                        SKIP.
    END.

END. /* ELSE IF  NOT CAN-FIND(FIRST tt_log_erros_atualiz) AND */


ASSIGN c-tipo  = "Imposto;Importa‡Æo;Nacional;Verbas;Todos"
       c-email = "Conciliadas;NÆo Conciliadas;Ambas".

PUT UNFORMATTED SKIP(2) "Parƒmetros:" SKIP(1).

PUT UNFORMATTED "Tipo Concilia‡Æo      : " ENTRY(tt-param.i-tipo-concilia,c-tipo,";") SKIP
                "Data Pagto            : " IF  tt-param.dt-pagto = ? THEN TODAY ELSE tt-param.dt-pagto FORMAT "99/99/9999"      SKIP
                "Vl Max AVA            : " tt-param.de-val-max-ava FORMAT ">>9.99"    SKIP
                "Conta AVA             : " tt-param.c-conta-ava                       SKIP
                "Vl Min Conc Parcial   : " tt-param.de-val-min-parcial                SKIP
                "E-Mail Com            : " ENTRY(tt-param.i-tipo-email,c-email,";")   SKIP
                "E-Mail Imposto Para   : " tt-param.c-email-imposto                   SKIP
                "E-Mail Importa‡Æo Para: " tt-param.c-email-importacao                SKIP.

{include/i-rpclo.i}

RUN pi-finalizar IN h-acomp.

IF  VALID-HANDLE(h-esapb020-api)
THEN DO:
    DELETE PROCEDURE h-esapb020-api.
    ASSIGN h-esapb020-api = ?.
END.


IF  tt-param.c-email-imposto <> ""
THEN
    RUN pi-envia-email (INPUT tt-param.c-email-imposto,
                        INPUT c-arq-anexo).

IF  tt-param.c-email-importacao <> ""
THEN
    RUN pi-envia-email (INPUT tt-param.c-email-importacao,
                        INPUT c-arq-anexo).

ASSIGN v_des_contdo_prog_valid_dtsul = ""
       v_log_monit_tab_espec_financ  = NO.

RETURN "OK".


PROCEDURE pi-envia-email:

    DEF INPUT PARAM p-c-destino-email AS CHAR NO-UNDO.
    DEF INPUT PARAM p-c-arq-anexo     AS CHAR NO-UNDO.

    DEFINE VARIABLE c-arquivo-email AS CHARACTER   NO-UNDO.

    IF  i-num-ped-exec-rpw = 0
    THEN
        ASSIGN p-c-arq-anexo = SEARCH(p-c-arq-anexo).
    ELSE
        ASSIGN p-c-arq-anexo = c-dir-spool-servid-exec + "/" + p-c-arq-anexo
               p-c-arq-anexo = SEARCH(p-c-arq-anexo).

    ASSIGN c-arquivo-email = p-c-arq-anexo
           c-arquivo-email = REPLACE(c-arquivo-email,".tmp",".txt")
           c-arquivo-email = REPLACE(c-arquivo-email,".lst",".txt")
           c-arquivo-email = REPLACE(c-arquivo-email,".LST",".txt").

    OS-COPY VALUE(p-c-arq-anexo) VALUE(c-arquivo-email).

    run utp/utapi019.p persistent set h-utapi019.

    EMPTY TEMP-TABLE tt-envio2.
    EMPTY TEMP-TABLE tt-erros.

    create tt-envio2.
    assign tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = ""
           tt-envio2.porta             = 0
           tt-envio2.destino           = p-c-destino-email
           tt-envio2.remetente         = "ems@intelbras.com.br"
           tt-envio2.arq-anexo         = c-arquivo-email
           tt-envio2.assunto           = "Concilia‡äes de Antecipa‡Æo" 
           tt-envio2.mensagem          = "Seu e-mail est  parametrizado para receber avisos das concilia‡äes de antecipa‡Æo."  + CHR(10) + CHR(10) + 
                                         "Atenciosamente," + CHR(10) + 
                                         "Equipe Financeira".
       
    output to value(session:temp-directory + "envemail.txt").       
    run pi-execute in h-utapi019 (input  table tt-envio2, 
                                  output table tt-erros).
    output close.

    delete procedure h-utapi019.

    if available tt-envio2 then
        delete tt-envio2.    

    RETURN "OK":U.

END PROCEDURE.




