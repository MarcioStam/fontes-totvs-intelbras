/******************************************************************************
** Programa..............: rpt_gera_e-mail_AVA
** Versao................:  1.00.00.000
** Nome Externo..........: esp/es0032rp.p
** Criado por............: Fabiano
** Criado em.............: 07/07/2008
** Objetivo..............: Gerar e-mail relacionando os AVAs do dia.
******************************************************************************/

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input parameter raw-param  as raw no-undo.
def input parameter table     for tt-raw-digita.

DEF VAR v_ind_trans AS CHAR INITIAL "AVMN,AVMA,AVCR,AVDB".
DEF VAR v_int       AS INT.

DEFINE VAR cRemetente AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR CDestino   AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR CAssunto   AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR CDescEmail AS CHAR FORMAT 'x(2000)' NO-UNDO.
DEFINE VAR CArqEmail  AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR level      AS INT INITIAL 1.

{utp/utapi019.i}
{esp/es0018.i}

ASSIGN cArqEmail = session:temp-directory + "AVA-ACR.CSV".

OUTPUT TO value(cArqEmail).

PUT UNFORMATTED "Estab;Espec;Ser;Titulo;Parc;Cliente;Nome;Data;Movimento;Valor;Usuario;Nat;Conta;CCusto;UN;Valor;Moeda" SKIP.

DO v_int = 1 TO NUM-ENTRIES(v_ind_trans):

    FOR EACH estabelecimento NO-LOCK:

        FOR EACH movto_tit_acr NO-LOCK
            WHERE movto_tit_acr.cod_estab           = estabelecimento.cod_estab
              AND movto_tit_acr.dat_transacao       = (TODAY - 1)
              AND movto_tit_acr.ind_trans_acr_abrev = ENTRY(v_int,v_ind_trans)
              AND movto_tit_acr.log_ctbz_aprop_ctbl = YES 
              AND movto_tit_acr.log_movto_estordo   = NO:
            IF movto_tit_acr.val_movto_tit_acr = 0 
               THEN NEXT.
            FIND tit_acr NO-LOCK
                WHERE tit_acr.cod_estab      = movto_tit_acr.cod_estab
                  AND tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr NO-ERROR.
            FIND emscad.cliente NO-LOCK
                WHERE cliente.cod_empresa = estabelecimento.cod_empresa
                  AND cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
            FOR EACH aprop_ctbl_acr OF movto_tit_acr NO-LOCK:
                PUT UNFORMATTED tit_acr.cod_estab ";" tit_acr.cod_espec ";" tit_acr.cod_ser ";" tit_acr.cod_tit_acr ";" tit_acr.cod_parcela ";" 
                                tit_acr.cdn_cliente ";" emscad.cliente.nom_abrev ";" movto_tit_acr.dat_transacao ";" movto_tit_acr.ind_trans_acr ";"
                                movto_tit_acr.val_movto_tit_acr ";" movto_tit_acr.cod_usuario ";"
                                aprop_ctbl_acr.ind_natur ";" aprop_ctbl_acr.cod_cta_ctbl ";" aprop_ctbl_acr.cod_ccusto ";" aprop_ctbl_acr.cod_unid_negoc ";" 
                                aprop_ctbl_acr.val_aprop_ctbl ";" aprop_ctbl_acr.cod_indic_econ SKIP.
            END.
        END.
    END.
END.

OUTPUT CLOSE.

/* Seleciona usuarios de destino do e-mail  */
RUN esp/es0018p.p (INPUT "es0032", /* Nome do programa */
                   INPUT 1,        /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

FOR EACH tt-prog-ponto:
    IF cDestino = '' 
       THEN ASSIGN cDestino = tt-prog-ponto.conteudo.
       ELSE ASSIGN cDestino = cDestino + ',' + tt-prog-ponto.conteudo.
END.

IF cDestino = '' THEN 
   ASSIGN cDestino = 'fabiano.henke@intelbras.com.br'.


ASSIGN cDescEmail = "Segue anexo arquivo contendo as movimenta‡äes de AVAs no contas a receber efetuadas em: " + string((TODAY - 1), '99/99/9999') + "." + CHR(13) + CHR(13) +
                    "Data e-mail: " + STRING((TODAY),"99/99/9999")  + CHR(13) +
                    "Hora e-mail: " + STRING(TIME,"HH:MM:ss")
       cAssunto   = "AVAs Contas a Receber - " + string((TODAY - 1), '99/99/9999')
       cRemetente = "ems@intelbras.com.br".

RUN piEnviaEmail(INPUT cRemetente,
                 INPUT cDestino,
                 INPUT cAssunto,
                 INPUT cDescEmail,
                 INPUT cArqEmail).

OS-DELETE value(cArqEmail).

PROCEDURE piEnviaEmail:

    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    FIND FIRST param_geral_btb NO-LOCK.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   
        DELETE tt-envio2.   
    END.
    FOR EACH tt-mensagem. 
        DELETE tt-mensagem. 
    END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param_geral_btb.cod_ip_servid_mail    /* Servidor de E-Mail */ 
           tt-envio2.porta             = param_geral_btb.num_porta_servid_e_mail /* Porta do Servidor  */ 
           tt-envio2.destino           = pdestino                              /* Destinat rio       */ 
           tt-envio2.remetente         = pRemetente                            /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                              /* Assunto            */
           tt-envio2.arq-anexo         = pArquivo                              /* Arquivo Tempor rio */
           tt-envio2.formato           = "TEXTO".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = pDescEmail + CHR(13). /* Mensagem */
   
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros 
    THEN DO:
         OUTPUT TO erros-ava.LOG APPEND.

         FOR EACH tt-erros:
             DISP tt-erros.cod-erro
                  tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
         END.
         OUTPUT CLOSE.
    END.

    IF VALID-HANDLE(h-utapi019) 
       THEN DELETE PROCEDURE h-utapi019.

END PROCEDURE.
