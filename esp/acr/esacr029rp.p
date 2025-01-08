/*****************************************************************************
** Programa..............: esp/esacr029rp.p
** Descriá∆o.............: Envio arquivo SERASA via WinSCP
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 19/08/2010
*****************************************************************************/

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input parameter raw-param as raw no-undo.
def input parameter table     for tt-raw-digita.

/*********************************************************************************************

Regras para seleá∆o:

	Implantaá∆o

	- T°tulos Vencidos a mais do que nr de dias definidos no es0018, ponto ESACR029/1 e 
      enviados a banco
	- Data de emiss∆o <> data de vencimento
	- Ignorar carteiras 70, 71, 88 e 89
	- Ignorar portadores assessoria
	- Ignorar t°tulos em perda dedut°vel
	- Ignorar portador 999
	- Ignorar clientes com a segunda instruá∆o igual a "08"

	Baixa

	- T°tulo na condiá∆o de cobranáa 99 e sem saldo
    - Desconsiderar pedido de Baixa para t°tulos que estejam em Perdas Dedut°veis
	- Selecionar para baixa todos os t°tulos que estiverem na condiá∆o 98, mesmo possuindo saldo

Geraá∆o do arquivo:

	- Ser† gerado somente um arquivo por dia com o nome CONVEM.TXT
	- Gerar o arquivo no diret¢rio S:\Financeiro\Serasa\WinSCP\Envio
	- Antes de gerar o arquivo verificar se j† existe o arquivo com o mesmo nome, caso j† exista Ç um processamento pendente. Neste caso mover o arquivo para o diret¢rio S:\Financeiro\Serasa\WinSCP\Envio\bkp com o nome CONVEM-ddmmaaaa.txt. Incluir um alerta no e-mail enviado informando esta situaá∆o ?
	- Gerar relat¢rio contendo t°tulos, motivo (implantaá∆o/baixa) e log de processamento, gravando no diret¢rio S:\Financeiro\Serasa\WinSCP\Envio\log. O relat¢rio enviar tambÇm via e-mail para uma lista informada no es0018.
	- O agendamento da execuá∆o do WinSCP ser† Ös 05:00 (Processar retorno SERASA) e 20:00 (Processar envio SERASA)
	- O agendamento da geraá∆o do arquivo pelo ERP ser† Ös 18:00

- Pendente
    - alterar rotina que troca o grupo de cliente 08-06 para alterar a instruá∆o banc†ria ?
	- Grupos <> "08" e com instriá∆o_1 = "07" alterar a instruá∆o_2 para "08" - n∆o enviar SERASA
	- Grupo = "08" alterar todos para instruá∆o_1 = "07". A excess∆o, instruá∆o_2 = "08" ser† feita manualmente
	- Alterar as instruá‰es nos clientes ou alterar a instruá∆o banc†ria banco para todoas apontar para o n∆o protestar ?

***********************************************************************************************/

DEF TEMP-TABLE tt_cliente_tit_acr 
  FIELD v_cod_estab          LIKE tit_acr.cod_estab                
  FIELD v_num_id_tit_acr     LIKE tit_acr.num_id_tit_acr           
  FIELD v_cdn_cliente        LIKE emsuni.cliente.cdn_cliente
  FIELD v_nom_abrev          LIKE emscad.cliente.nom_abrev
  FIELD v_tip_env            AS   CHAR /*Implantacao, Baixa e Ambos*/
  FIELD v_obs                AS   CHAR FORMAT "x(50)"
  FIELD cod_espec_docto      LIKE tit_acr.cod_espec_docto     
  FIELD cod_ser_docto        LIKE tit_acr.cod_ser_docto       
  FIELD cod_tit_acr          LIKE tit_acr.cod_tit_acr         
  FIELD cod_parcela          LIKE tit_acr.cod_parcela         
  FIELD cod_portador         LIKE tit_acr.cod_portador        
  FIELD cod_cart_bcia        LIKE tit_acr.cod_cart_bcia       
  FIELD cod_grp_clien        LIKE tit_acr.cod_grp_clien
  FIELD dat_emis_docto       LIKE tit_acr.dat_emis_docto      
  FIELD dat_vencto_tit_acr   LIKE tit_acr.dat_vencto_tit_acr  
  FIELD dat_liquidac_tit_acr LIKE tit_acr.dat_liquidac_tit_acr
  FIELD val_sdo_tit_acr      LIKE tit_acr.val_sdo_tit_acr   
  FIELD dat_envi_asses_cob   LIKE int_tit_acr.dat_envi_asses_cob
  FIELD dat_ret_asses_cob    LIKE int_tit_acr.dat_ret_asses_cob
  FIELD l_tit_acr_sel        AS   LOG INITIAL NO
  INDEX tt_cliente IS PRIMARY UNIQUE v_cod_estab      
                                     v_num_id_tit_acr.

/* Temp-table para envio de e-mail */                 
def temp-table tt_mail_fax no-undo
    field ttv_nom_servid            as character format "x(30)"
    field ttv_num_porta_servid      as integer   format ">>>>9"
    field ttv_log_exchange          as logical   format "Sim/N∆o" initial no
    field ttv_nom_from              as character format "x(50)"
    field ttv_nom_to                as character format "x(50)" label "To"
    field ttv_nom_cc                as character format "x(50)" label "Cc"
    field ttv_nom_subject           as character format "x(30)"
    field ttv_nom_message           as character format "x(50)"
    field ttv_nom_attachfile        as character format "x(30)"
    field ttv_num_imptcia           as integer   format "9"
    field ttv_log_envda             as logical   format "Sim/N∆o" initial no
    field ttv_log_lida              as logical   format "Sim/N∆o" initial no
    field ttv_cod_format_mail       as character format "x(8)"    initial "TEXTO".

def temp-table tt_erros_mail_fax no-undo
    field ttv_cod_erro          as character format "x(10)"
    field ttv_des_erro          as character format "x(50)" label "Inconsistància" column-label "Inconsistància"
    field ttv_des_arquivo       as character format "x(255)".
/* Temp-table para envio de e-mail */

DEF TEMP-TABLE tt_mail_fax_btb LIKE tt_mail_fax.

{esp/acr/acr711zo.i}
{esp/es0018.i}

/* Local Stream Definitions                                             */
DEF STREAM s_arqexport.
DEF STREAM s_arqrelat.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar
    AS CHARACTER FORMAT "x(3)" LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.
/* **
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usuˇrio Corrente"
    column-label "Usuˇrio Corrente"
    no-undo. ***/

DEFINE VARIABLE v_cod_dir     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_dir_log AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-email    AS CHARACTER   NO-UNDO.

/* ** Fixado o usu†rio pois a execuá∆o ser† agendada pelo RPW com outro usu†rio ***/
DEFINE VARIABLE v_cod_usuar_corren AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-dias-venc AS INTEGER     NO-UNDO.

DEF BUFFER b_cliente FOR emscad.cliente.

ASSIGN v_cod_usuar_corren = "lu046326".


EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "FINANC":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:

    ASSIGN c-dir-saida = replace(tt-prog-ponto.conteudo, "/", "~\").

    IF SUBSTRING(c-dir-saida, LENGTH(c-dir-saida), 1) <> "~\" THEN
        ASSIGN c-dir-saida = c-dir-saida + "~\".

END.


ASSIGN v_cod_dir     = c-dir-saida + "serasa~\WinSCP~\Envio~\"      /* ** local onde o SERASA disponibiliza todos os arquivos ***/
       v_cod_dir_log = c-dir-saida + "serasa~\WinSCP~\Envio~\log~\". /* ** criar log do resultado da importaá∆o                ***/

/* ** Tratamento para o envio do e-mail ***/
FOR EACH tt_mail_fax:
    DELETE tt_mail_fax.
END.
/* Seleciona usuarios de destino do e-mail  */
RUN esp/es0018p.p (INPUT "esacr030", /* Nome do programa */
                   INPUT 1,          /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.
FOR EACH tt-prog-ponto:
    IF c-email = '' 
       THEN ASSIGN c-email = tt-prog-ponto.conteudo.
       ELSE ASSIGN c-email = c-email + ',' + tt-prog-ponto.conteudo.
END.
IF c-email = '' THEN 
   ASSIGN c-email = 'andrey.oliveira@intelbras.com.br'.
/** * Fim tratamento envio e-mail ***/

DEFINE VARIABLE v_cod_arq_log    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_tip_envio      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c_arquivo_export AS CHARACTER   NO-UNDO.
     
ASSIGN v_cod_arq_log = v_cod_dir_log + "SER" + STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") + STRING(DAY(TODAY), "99") + STRING(TIME) + ".LOG".
OUTPUT STREAM s_arqrelat TO VALUE(v_cod_arq_log) PAGED PAGE-SIZE VALUE(66) CONVERT TARGET 'iso8859-1'.

ASSIGN c_arquivo_export = c-dir-saida + "serasa~\WinSCP~\Envio~\convem.txt".

blk_serasa:
DO TRANSACTION:

   RUN pi_exporta_dados.

   /* ** Zarpe - Inclu°do para teste ***
   UNDO blk_serasa. ***/

END.

OUTPUT STREAM s_arqrelat CLOSE.

/* ** Executar integraá∆o com o SERASA para baixar os arquivos de retorno ***/
DEF VAR v_nom_EDI7 AS CHAR FORMAT "x(100)".
ASSIGN v_nom_EDI7 = '"' + c-dir-saida + 'serasa~\WinSCP~\serasa.bat"'.
OS-COMMAND VALUE(v_nom_EDI7).
PAUSE 50.
/* ** Fim da integraá∆o com o SERASA ***/

/* ** Verifica se existe arquivo de envio, caso exista, move para a pasta bkp pois foi enviado neste processamento ***/
DEFINE VARIABLE v_cod_arq_env_new AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_dir_bkp_env AS CHARACTER   NO-UNDO.

ASSIGN v_cod_dir_bkp_env = c-dir-saida + "serasa~\WinSCP~\Envio~\bkp~\"  /* ** transfere bkp arquivos enviados                  ***/
       v_cod_arq_env_new = v_cod_dir + "convem" + STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") + STRING(DAY(TODAY), "99") + STRING(TIME) + ".txt".

OS-RENAME VALUE(c_arquivo_export)  VALUE(v_cod_arq_env_new).
OS-COPY   VALUE(v_cod_arq_env_new) VALUE(v_cod_dir_bkp_env).
OS-DELETE VALUE(v_cod_arq_env_new).

/* ** Envia e-mail de acompanhamento ***/
DEFINE VARIABLE c-msg      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

/* ** Caso nao tenha sido importado nenhum arquivo, enviar e-mail informando que n∆o houve importaá∆o neste dia ***/
IF NOT CAN-FIND (FIRST tt_cliente_tit_acr)
THEN DO:
     ASSIGN c-msg      = "Exportaá∆o PEFIN - " + STRING(TODAY)
            c-mensagem = "Nenhum arquivo foi exportado.".

     CREATE tt_mail_fax.
     ASSIGN tt_mail_fax.ttv_nom_to          = c-email
            tt_mail_fax.ttv_nom_subject     = c-msg
            tt_mail_fax.ttv_nom_message     = c-mensagem
            tt_mail_fax.ttv_nom_attachfile  = ""
            tt_mail_fax.ttv_num_imptcia     = 2
            tt_mail_fax.ttv_cod_format_mail = "texto"
            tt_mail_fax.ttv_nom_from        = "ems@intelbras.com.br".

END.
ELSE DO:
     ASSIGN c-msg      = "Exportaá∆o PEFIN - " + STRING(TODAY)
            c-mensagem = "Em anexo resumo da exportaá∆o do PEFIN/SERASA.".
     CREATE tt_mail_fax.
     ASSIGN tt_mail_fax.ttv_nom_to          = c-email
            tt_mail_fax.ttv_nom_subject     = c-msg
            tt_mail_fax.ttv_nom_message     = c-mensagem
            tt_mail_fax.ttv_nom_attachfile  = v_cod_arq_log    
            tt_mail_fax.ttv_num_imptcia     = 2
            tt_mail_fax.ttv_cod_format_mail = "texto"
            tt_mail_fax.ttv_nom_from        = "ems@intelbras.com.br".
END.

RUN pi-envia-email.

/************************************************************************************************************************************************************************/
PROCEDURE pi_exporta_dados:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt_cliente_tit_acr:
        DELETE tt_cliente_tit_acr.
    END.
    FOR EACH tt_alter_tit_acr_base_2:
        DELETE tt_alter_tit_acr_base_2.
    END.

    RUN pi_envio_implantacao.
    RUN pi_envio_implantacao_97.
    RUN pi_envio_baixa_98.
    RUN pi_envio_baixa_99.

    /* ** Cria hist¢rico para o envio da implantaá∆o ***/
    FOR EACH tt_cliente_tit_acr
        WHERE tt_cliente_tit_acr.v_tip_env = "I":
        FIND FIRST tit_acr NO-LOCK
             WHERE tit_acr.cod_estab      = tt_cliente_tit_acr.v_cod_estab
               AND tit_acr.num_id_tit_acr = tt_cliente_tit_acr.v_num_id_tit_acr NO-ERROR.
        IF AVAIL tit_acr 
           THEN RUN pi_carrega_tt_acr711zo.
    END.
    IF CAN-FIND(FIRST tt_alter_tit_acr_base_2) 
    THEN DO:
         RUN pi_roda_acr711zo.
         RUN pi_cria_int_tit_acr.
    END.

    /* ** Cria hist¢rico para o envio do pedido de baixa ***/
    FOR EACH tt_cliente_tit_acr
        WHERE tt_cliente_tit_acr.v_tip_env     = "E":
        FIND FIRST tit_acr NO-LOCK
             WHERE tit_acr.cod_estab      = tt_cliente_tit_acr.v_cod_estab
               AND tit_acr.num_id_tit_acr = tt_cliente_tit_acr.v_num_id_tit_acr NO-ERROR.
        IF AVAIL tit_acr 
           THEN RUN pi_cria_histor(INPUT "Solicitado Baixa do Serasa pelo Usu†rio: ",
                                   INPUT ?).
    END.

    IF CAN-FIND (FIRST tt_cliente_tit_acr)
    THEN DO:
         RUN pi_gera_arquivo.
         RUN pi_imprime_relat.
    END.

END PROCEDURE.

PROCEDURE pi_envio_implantacao:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "ESACR029":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN i-dias-venc = INT(tt-prog-ponto.conteudo).
    END.

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar:

        /* ** Filtra Filial MG, pois a cobranáa n∆o est† centralizada **
        IF estabelecimento.cod_estab = '103' 
           THEN NEXT. ***/

        FOR EACH espec_docto_financ_acr NO-LOCK 
            WHERE espec_docto_financ_acr.cod_espec_docto = "DM"
               OR espec_docto_financ_acr.cod_espec_docto = "VD"
               OR espec_docto_financ_acr.cod_espec_docto = "LC":

            FOR EACH tit_acr NO-LOCK USE-INDEX titacr_espec_vencto
                WHERE tit_acr.cod_estab            = estabelecimento.cod_estab
                  AND tit_acr.cod_espec_docto      = espec_docto_financ_acr.cod_espec_docto
                  AND tit_acr.log_sdo_tit_acr      = YES
                  AND tit_acr.log_tit_acr_estordo  = NO 
                  AND tit_acr.cod_cond_cobr       <> "99" 
                  AND tit_acr.cod_cond_cobr       <> "96":
                
                /* ** Regras para a seleá∆o dos t°tulos ***/

                /* Ignorar titulos gerados via galaxy pay */
                IF  tit_acr.cod_tit_acr_bco BEGINS "GLX" THEN
                    NEXT.

                /* ** PJ possui data de corte na data de emiss∆o (05/11/2010), pois foram registrados com instruá∆o de protesto ***/
                IF  tit_acr.num_pessoa MODULO 2 <> 0 /* ** PJ ***/
                AND tit_acr.dat_emis_docto < 11/06/2010
                    THEN NEXT.

                /* ** Vencidos a mais do que x dias definidos no es0018 - ponto esacr029 ***/ 
                IF (TODAY - tit_acr.dat_vencto_tit_acr) < i-dias-venc /*dias £teis ou corridos ?*/
                   THEN NEXT.

                /* ** Somente portador Banco ***/
                FIND emscad.portador NO-LOCK
                    WHERE emscad.portador.cod_portador = tit_acr.cod_portador NO-ERROR.
                IF NOT AVAIL emscad.portador
                OR emscad.portador.ind_tip_portad <> "Banco" 
                   THEN NEXT.
                IF tit_acr.cod_portador = '9996' 
                   THEN NEXT.

                /* ** Vencimento igual a Emiss∆o ***/
                IF tit_acr.dat_vencto_tit_acr = tit_acr.dat_emis_docto 
                   THEN NEXT.

                /* ** Carteira e-commerce ***/
                IF tit_acr.cod_cart_bcia = "70" 
                OR tit_acr.cod_cart_bcia = "71"
                OR tit_acr.cod_cart_bcia = "88"
                OR tit_acr.cod_cart_bcia = "89"
                   THEN NEXT.

                /* ** T°tulo em perdas dedut°veis ***/
                IF tit_acr.dat_indcao_perda_dedut <> 12/31/9999 
                   THEN NEXT.

                FIND FIRST int_tit_acr NO-LOCK 
                     WHERE int_tit_acr.cod_estab  = tit_acr.cod_estab 
                       AND int_tit_acr.num_id_tit = tit_acr.num_id_tit NO-ERROR.

                /* ** T°tulo j† foi enviado anteriormente para o SERASA, n∆o ser† enviado novamente ***/
                /* Retirada validaá∆o conforme chamado C2301-2019
                IF  AVAIL int_tit_acr 
                AND int_tit_acr.dat_envi_asses_cob <> ? 
                    THEN NEXT.
                */

                /* **  Filtrar clientes financeiros que possuem instruá∆o de cobranáa 08 - N∆o enviar SERASA 
                       Considerar a instruá∆o 2 do cliente matriz ***/
                FIND emscad.cliente NO-LOCK
                    WHERE emscad.cliente.cod_empresa = tit_acr.cod_empresa
                      AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
                
                IF  NOT AVAIL emscad.cliente THEN
                    NEXT.

                IF  emscad.cliente.num_pessoa MODULO 2 = 0 THEN DO:
                    FIND FIRST pessoa_fisic
                        WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-LOCK NO-ERROR.

                    IF  AVAIL pessoa_fisic THEN DO:
                        IF  pessoa_fisic.num_pessoa_fisic <> pessoa_fisic.num_pessoa_fisic_matriz THEN DO:
                            FIND FIRST b_cliente NO-LOCK
                                WHERE b_cliente.num_pessoa = pessoa_fisic.num_pessoa_fisic_matriz NO-ERROR.

                            IF  NOT AVAIL b_cliente THEN
                                NEXT.

                            FIND FIRST clien_financ
                                WHERE clien_financ.cod_empresa = tit_acr.cod_empresa
                                AND   clien_financ.cdn_cliente = b_cliente.cdn_cliente NO-LOCK NO-ERROR.

                            IF  NOT AVAIL clien_financ
                            OR  clien_financ.cod_instruc_bcia_2_acr = "08" /* ** N∆o enviar SERASA ***/ THEN 
                                NEXT.
                        END.
                        ELSE DO:
                            FIND FIRST clien_financ
                                WHERE clien_financ.cod_empresa = tit_acr.cod_empresa
                                AND   clien_financ.cdn_cliente = emscad.cliente.cdn_cliente NO-LOCK NO-ERROR.

                            IF  NOT AVAIL clien_financ
                            OR  clien_financ.cod_instruc_bcia_2_acr = "08" /* ** N∆o enviar SERASA ***/ THEN 
                                NEXT.
                        END.
                    END.
                END.
                ELSE DO:
                    FIND FIRST pessoa_jurid
                        WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-LOCK NO-ERROR.

                    IF  AVAIL pessoa_jurid THEN DO:
                        IF  pessoa_jurid.num_pessoa_jurid <> pessoa_jurid.num_pessoa_jurid_matriz THEN DO:
                            FIND FIRST b_cliente NO-LOCK
                                WHERE b_cliente.num_pessoa = pessoa_jurid.num_pessoa_jurid_matriz NO-ERROR.

                            IF  NOT AVAIL b_cliente THEN 
                                NEXT.

                            FIND FIRST clien_financ
                                WHERE clien_financ.cod_empresa = tit_acr.cod_empresa
                                AND   clien_financ.cdn_cliente = b_cliente.cdn_cliente NO-LOCK NO-ERROR.

                            IF  NOT AVAIL clien_financ
                            OR  clien_financ.cod_instruc_bcia_2_acr = "08" /* ** N∆o enviar SERASA ***/ THEN 
                                NEXT.
                        END.
                        ELSE DO:
                            FIND FIRST clien_financ
                                WHERE clien_financ.cod_empresa = tit_acr.cod_empresa
                                AND   clien_financ.cdn_cliente = emscad.cliente.cdn_cliente NO-LOCK NO-ERROR.

                            IF  NOT AVAIL clien_financ
                            OR  clien_financ.cod_instruc_bcia_2_acr = "08" /* ** N∆o enviar SERASA ***/ THEN 
                                NEXT.
                        END.
                    END.
                END.

                /* ** T°tulo enviado para Protesto ***/
                IF tit_acr.log_tit_acr_cobr = YES 
                THEN DO:
                     FIND FIRST movto_ocor_bcia NO-LOCK
                          WHERE movto_ocor_bcia.cod_estab               = tit_acr.cod_estab
                            AND movto_ocor_bcia.num_id_tit_acr          = tit_acr.num_id_tit_acr
                            AND movto_ocor_bcia.cod_portador            = tit_acr.cod_portador
                            AND movto_ocor_bcia.cod_cart_bcia           = tit_acr.cod_cart_bcia
                            AND movto_ocor_bcia.ind_ocor_bcia_remes_ret = "Retorno"
                            AND movto_ocor_bcia.ind_tip_ocor_bcia       = "Enviado Cart¢rio" NO-ERROR.
                     IF AVAIL movto_ocor_bcia 
                        THEN NEXT.

                     FIND FIRST movto_ocor_bcia NO-LOCK
                          WHERE movto_ocor_bcia.cod_estab               = tit_acr.cod_estab
                            AND movto_ocor_bcia.num_id_tit_acr          = tit_acr.num_id_tit_acr
                            AND movto_ocor_bcia.cod_portador            = tit_acr.cod_portador
                            AND movto_ocor_bcia.cod_cart_bcia           = tit_acr.cod_cart_bcia
                            AND movto_ocor_bcia.ind_ocor_bcia_remes_ret = "Retorno"
                            AND movto_ocor_bcia.ind_tip_ocor_bcia       = "DêBITO CUSTAS CARTORIAIS" NO-ERROR.
                     IF AVAIL movto_ocor_bcia 
                        THEN NEXT.
                END.
                
                /* ** T°tulo enviado para SERASA pelo Banco ***/
                FIND FIRST movto_ocor_bcia NO-LOCK
                     WHERE movto_ocor_bcia.cod_estab               = tit_acr.cod_estab
                       AND movto_ocor_bcia.num_id_tit_acr          = tit_acr.num_id_tit_acr
                       AND movto_ocor_bcia.cod_portador            = tit_acr.cod_portador
                       AND movto_ocor_bcia.cod_cart_bcia           = tit_acr.cod_cart_bcia
                       AND movto_ocor_bcia.ind_ocor_bcia_remes_ret = "Retorno"
                       AND movto_ocor_bcia.ind_tip_ocor_bcia       = "Outras Baixas" NO-ERROR.
                IF AVAIL movto_ocor_bcia 
                    THEN NEXT.

                ASSIGN v_tip_envio = "Implantaá∆o".

                RUN pi_cria_tt_cliente_tit_acr.

            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi_envio_implantacao_97:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* ** A condiá∆o de cobranáa 97 serve para incluir o t°tulo do SERASA sem que o mesmo atenda a regra de inadimplància
          A alteraá∆o da condiá∆o de cobranáa para 97 ser† feita manualmente ***/

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar:

        /* ** Filtra Filial MG, pois a cobranáa n∆o est† centralizada **
        IF estabelecimento.cod_estab = '103' 
           THEN NEXT. ***/

        FOR EACH tit_acr NO-LOCK USE-INDEX titacr_cond_cob
            WHERE tit_acr.cod_estab     = estabelecimento.cod_estab
              AND tit_acr.cod_cond_cobr = "97":

            /* Ignorar titulos gerados via galaxy pay */
            IF  tit_acr.cod_tit_acr_bco BEGINS "GLX" THEN
                NEXT.

            FIND FIRST int_tit_acr NO-LOCK 
                 WHERE int_tit_acr.cod_estab  = tit_acr.cod_estab 
                   AND int_tit_acr.num_id_tit = tit_acr.num_id_tit NO-ERROR.

            /* ** T°tulo j† foi enviado anteriormente para o SERASA, n∆o ser† enviado novamente ***/
            /* Retirada validaá∆o conforme chamado C2301-2019
            IF  AVAIL int_tit_acr 
            AND int_tit_acr.dat_envi_asses_cob <> ? 
                THEN NEXT.
            */

            ASSIGN v_tip_envio = "Implantaá∆o".

            RUN pi_cria_tt_cliente_tit_acr.

        END.

    END.

END PROCEDURE.

PROCEDURE pi_envio_baixa_98:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* ** A condiá∆o de cobranáa 98 serve para retirar o t°tulo do SERASA sem que o mesmo seja liquidado
          Isto pode ocorrer quando um t°tulo Ç enviado por engano e Ç necess†rio solicitar a Baixa do SERASA
          A alteraá∆o da condiá∆o de cobranáa para 98 ser† feita manualmente ***/

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar:

        /* ** Filtra Filial MG, pois a cobranáa n∆o est† centralizada ***
        IF estabelecimento.cod_estab = '103' 
           THEN NEXT. ***/

        FOR EACH tit_acr NO-LOCK USE-INDEX titacr_cond_cob
            WHERE tit_acr.cod_estab     = estabelecimento.cod_estab
              AND tit_acr.cod_cond_cobr = "98":

            /* Ignorar titulos gerados via galaxy pay */
            IF  tit_acr.cod_tit_acr_bco BEGINS "GLX" THEN
                NEXT.

            /* ** T°tulo n∆o foi enviado ao SERASA ou j† foi Baixado - Somente esta na condiá∆o de cobranáa 98 por algum outro motivo ***/
            FIND FIRST int_tit_acr NO-LOCK
                 WHERE int_tit_acr.cod_estab      = tit_acr.cod_estab      
                   AND int_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr NO-ERROR.
            IF NOT AVAIL int_tit_acr 
            OR int_tit_acr.dat_ret_asses_cob <> ?   
               THEN NEXT.

            ASSIGN v_tip_envio = "Baixa".

            RUN pi_cria_tt_cliente_tit_acr.

        END.
    END.

END PROCEDURE.

PROCEDURE pi_envio_baixa_99:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* ** Os t°tulos que est∆o na condiá∆o de cobranáa 99 sem saldo
          indicam que o valor foi recebido, sendo necess†rio solicitar a Baixa do SERASA ***/

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empres = v_cod_empres_usuar:

        /* ** Filtra Filial MG, pois a cobranáa n∆o est† centralizada ***
        IF estabelecimento.cod_estab = '103' 
           THEN NEXT. ***/

        FOR EACH tit_acr NO-LOCK USE-INDEX titacr_cond_cob
            WHERE tit_acr.cod_estab       = estabelecimento.cod_estab
              AND tit_acr.cod_cond_cobr   = "99"
              AND tit_acr.log_sdo_tit_acr = NO:

            /* Ignorar titulos gerados via galaxy pay */
            IF  tit_acr.cod_tit_acr_bco BEGINS "GLX" THEN
                NEXT.

            /* ** T°tulo em perdas dedut°veis ***/
            IF  tit_acr.dat_indcao_perda_dedut <> 12/31/9999 
            AND tit_acr.val_sdo_tit_acr        <> 0
                THEN NEXT.
    
            /* ** T°tulo n∆o foi enviado ao SERASA ou j† foi Baixado - Somente esta na condiá∆o de cobranáa 99 por algum outro motivo 
            FIND FIRST int_tit_acr NO-LOCK
                 WHERE int_tit_acr.cod_estab      = tit_acr.cod_estab      
                   AND int_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr NO-ERROR.
            IF NOT AVAIL int_tit_acr 
            OR int_tit_acr.dat_ret_asses_cob <> ?   
               THEN NEXT. ***/
    
            ASSIGN v_tip_envio = "Baixa".
    
            RUN pi_cria_tt_cliente_tit_acr.
    
        END.

    END.

END PROCEDURE.

PROCEDURE pi_gera_arquivo:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR v_cod_id_feder_empresa LIKE pessoa_jurid.cod_id_feder.
    DEF VAR v_cod_id_feder_cliente LIKE pessoa_jurid.cod_id_feder.
    DEF VAR CONT AS INT INITIAL 0.
    DEF VAR v-data-header AS CHAR FORMAT "x(8)" NO-UNDO.
    DEF VAR v-mot-baixa AS CHAR FORMAT "x(2)" NO-UNDO.
    DEF VAR v_ind_tip_pessoa AS CHAR FORMAT "x(01)" NO-UNDO.

    DEFINE VARIABLE v_cod_telefone     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_nom_endereco     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_nom_bairro       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_nom_cidade       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_cod_unid_federac AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_cod_cep          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_nom_pessoa       AS CHARACTER   NO-UNDO.

    IF NOT CAN-FIND(FIRST tt_cliente_tit_acr
                    WHERE l_tit_acr_sel = YES) 
       THEN RETURN.

    ASSIGN v-data-header = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99").

    OUTPUT STREAM s_arqexport TO VALUE(c_arquivo_export) CONVERT TARGET 'iso8859-1'.
        
    FIND FIRST param-int EXCLUSIVE-LOCK
        WHERE param-int.cod-estab = v_cod_empres_usuar NO-ERROR.
    ASSIGN param-int.seq-pefin = param-int.seq-pefin + 1.
        
    FIND FIRST estabelecimento NO-LOCK
        WHERE estabelecimento.cod_estab = '101' NO-ERROR.
    
    FIND FIRST pessoa_jurid NO-LOCK
        WHERE pessoa_jurid.num_pessoa_jurid = estabelecimento.num_pessoa_jurid NO-ERROR.
    ASSIGN v_cod_id_feder_empresa = pessoa_jurid.cod_id_feder.
    PUT stream s_arqexport UNFORMATTED
        "0" AT 001
        INT(SUBSTRING(v_cod_id_feder_empresa,1,8)) FORMAT "999999999" AT 002
        v-data-header AT 011
        "0048" AT 019
        "32819577" AT 023
        "0000" AT 031
        "FABIANO" AT 035
        "SERASA-CONVEM04" AT 105
        param-int.seq-pefin FORMAT "999999" AT 120
        "E" AT 126
        "0000001" AT 594.
    
    ASSIGN cont = 1.

    RUN esp/es0018p.p (INPUT "ESACR029":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt_cliente_tit_acr NO-LOCK
        WHERE l_tit_acr_sel = YES:
    
        FIND FIRST tit_acr NO-LOCK USE-INDEX titacr_token
            WHERE tit_acr.cod_estab      = tt_cliente_tit_acr.v_cod_estab
            AND   tit_acr.num_id_tit_Acr = tt_cliente_tit_acr.v_num_id_tit_acr NO-ERROR.
    
        IF NOT AVAIL tit_acr 
           THEN NEXT.

        IF  tit_acr.cod_cond_cobr <> "99"
        AND tit_acr.cod_cond_cobr <> "98"
           THEN NEXT.
    
        FIND FIRST emscad.cliente NO-LOCK
            WHERE emscad.cliente.cod_empresa = tit_acr.cod_empresa
            AND   emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.
    
        IF emscad.cliente.cod_pais <> "BRA" 
           THEN NEXT.
    
        /* es0018 - programa: ESACR029 - ponto: 2 */
        IF  CAN-FIND(FIRST tt-prog-ponto
                    WHERE entry(1,tt-prog-ponto.conteudo,";") = string(tit_acr.cdn_cliente)) THEN DO:

            FOR EACH tt-prog-ponto
                WHERE entry(1,tt-prog-ponto.conteudo,";") = string(tit_acr.cdn_cliente) NO-LOCK:

                ASSIGN v_cod_id_feder_cliente = string(entry(2,tt-prog-ponto.conteudo,";"))
                       v_ind_tip_pessoa       = string(entry(3,tt-prog-ponto.conteudo,";"))
                       v_cod_telefone         = string(entry(5,tt-prog-ponto.conteudo,";"))
                       v_nom_endereco         = string(entry(6,tt-prog-ponto.conteudo,";"))
                       v_nom_bairro           = string(entry(7,tt-prog-ponto.conteudo,";"))
                       v_nom_cidade           = string(entry(8,tt-prog-ponto.conteudo,";"))     
                       v_cod_unid_federac     = string(entry(9,tt-prog-ponto.conteudo,";"))
                       v_cod_cep              = string(entry(10,tt-prog-ponto.conteudo,";"))
                       v_nom_pessoa           = string(entry(4,tt-prog-ponto.conteudo,";")).

                /*Somente tem Motivo de Baixa para T°tulos que foram Baixados*/
                IF v_tip_env = "E" THEN
                    ASSIGN v-mot-baixa = "01".
                ELSE
                    ASSIGN v-mot-baixa = "".
        
                ASSIGN cont = cont + 1.
                PUT stream s_arqexport UNFORMATTED
                    "1"  AT 001
                    CAPS(v_tip_env)  AT 002
                    STRING(SUBSTRING(v_cod_id_feder_empresa,9,6),"999999") AT 003
                    STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999") + STRING(MONTH(tit_acr.dat_vencto_tit_acr),"99") + STRING(DAY(tit_acr.dat_vencto_tit_acr),"99") AT 009
                    STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999") + STRING(MONTH(tit_acr.dat_vencto_tit_acr),"99") + STRING(DAY(tit_acr.dat_vencto_tit_acr),"99") AT 017
                    "DP"   AT 025
                    "    " AT 028
                    v_ind_tip_pessoa FORMAT "x(01)"              AT 032
                    IF v_ind_tip_pessoa = "F" THEN "2" ELSE "1"  AT 033
                    DEC(v_cod_id_feder_cliente) FORMAT "999999999999999" AT 034
                    v-mot-baixa  AT 049
                    CAPS(v_nom_pessoa) FORMAT "x(70)" AT 106
                    "00000000" AT 176
                    CAPS(v_nom_endereco)     FORMAT "X(045)" AT 324
                    CAPS(v_nom_bairro)       FORMAT "X(020)" AT 369
                    CAPS(v_nom_cidade)       FORMAT "X(025)" AT 389
                    CAPS(v_cod_unid_federac) FORMAT "X(002)" AT 414
                    INT(v_cod_cep)           FORMAT "99999999" AT 416
                    DEC(tit_acr.val_sdo_tit_acr * 100)  FORMAT "999999999999999" AT 424
                    CAPS(tit_acr.cod_espec_docto) FORMAT "X(3)"  AT 439
                    CAPS(tit_acr.cod_ser_docto)   FORMAT "X(3)"  AT 442
                    CAPS(tit_acr.cod_tit_acr)     FORMAT "X(8)"  AT 445
                    CAPS(tit_acr.cod_parcela)     FORMAT "x(2)"  AT 453
                    DEC(substring(tit_acr.cod_tit_acr_bco,1,9)) FORMAT "999999999" AT 455
                    v_cod_telefone FORMAT "x(13)" AT 489
                    cont FORMAT "9999999" AT 594.

                NEXT.
            END.
        END.
        ELSE DO:

            IF emscad.cliente.num_pessoa MODULO 2 = 0 
            THEN DO:
                 FIND FIRST pessoa_fisic NO-LOCK
                      WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
                 ASSIGN v_cod_id_feder_cliente = pessoa_fisic.cod_id_feder
                        v_ind_tip_pessoa       = "F"
                        v_cod_telefone         = pessoa_fisic.cod_telefone
                        v_nom_endereco         = pessoa_fisic.nom_endereco
                        v_nom_bairro           = pessoa_fisic.nom_bairro
                        v_nom_cidade           = pessoa_fisic.nom_cidade      
                        v_cod_unid_federac     = pessoa_fisic.cod_unid_federac
                        v_cod_cep              = pessoa_fisic.cod_cep
                        v_nom_pessoa           = pessoa_fisic.nom_pessoa.
            END.
            ELSE DO:
                 FIND FIRST pessoa_jurid NO-LOCK
                      WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
                 ASSIGN v_cod_id_feder_cliente = pessoa_jurid.cod_id_feder
                        v_ind_tip_pessoa       = "J"
                        v_cod_telefone         = pessoa_jurid.cod_telefone
                        v_nom_endereco         = pessoa_jurid.nom_endereco
                        v_nom_bairro           = pessoa_jurid.nom_bairro
                        v_nom_cidade           = pessoa_jurid.nom_cidade      
                        v_cod_unid_federac     = pessoa_jurid.cod_unid_federac
                        v_cod_cep              = pessoa_jurid.cod_cep
                        v_nom_pessoa           = pessoa_jurid.nom_pessoa.
            END.

            /*Somente tem Motivo de Baixa para T°tulos que foram Baixados*/
            IF v_tip_env = "E" THEN
                ASSIGN v-mot-baixa = "01".
            ELSE
                ASSIGN v-mot-baixa = "".
    
            ASSIGN cont = cont + 1.
            PUT stream s_arqexport UNFORMATTED
                "1"  AT 001
                CAPS(v_tip_env)  AT 002
                STRING(SUBSTRING(v_cod_id_feder_empresa,9,6),"999999") AT 003
                STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999") + STRING(MONTH(tit_acr.dat_vencto_tit_acr),"99") + STRING(DAY(tit_acr.dat_vencto_tit_acr),"99") AT 009
                STRING(YEAR(tit_acr.dat_vencto_tit_acr),"9999") + STRING(MONTH(tit_acr.dat_vencto_tit_acr),"99") + STRING(DAY(tit_acr.dat_vencto_tit_acr),"99") AT 017
                "DP"   AT 025
                "    " AT 028
                v_ind_tip_pessoa FORMAT "x(01)"              AT 032
                IF v_ind_tip_pessoa = "F" THEN "2" ELSE "1"  AT 033
                DEC(v_cod_id_feder_cliente) FORMAT "999999999999999" AT 034
                v-mot-baixa  AT 049
                CAPS(v_nom_pessoa) FORMAT "x(70)" AT 106
                "00000000" AT 176
                CAPS(v_nom_endereco)     FORMAT "X(045)" AT 324
                CAPS(v_nom_bairro)       FORMAT "X(020)" AT 369
                CAPS(v_nom_cidade)       FORMAT "X(025)" AT 389
                CAPS(v_cod_unid_federac) FORMAT "X(002)" AT 414
                INT(v_cod_cep)           FORMAT "99999999" AT 416
                DEC(tit_acr.val_sdo_tit_acr * 100)  FORMAT "999999999999999" AT 424
                CAPS(tit_acr.cod_espec_docto) FORMAT "X(3)"  AT 439
                CAPS(tit_acr.cod_ser_docto)   FORMAT "X(3)"  AT 442
                CAPS(tit_acr.cod_tit_acr)     FORMAT "X(8)"  AT 445
                CAPS(tit_acr.cod_parcela)     FORMAT "x(2)"  AT 453
                DEC(substring(tit_acr.cod_tit_acr_bco,1,9)) FORMAT "999999999" AT 455
                v_cod_telefone FORMAT "x(13)" AT 489
                cont FORMAT "9999999" AT 594.

        END.
    END. /*FOR EACH tt_cliente_tit_acr NO-LOCK:    */
    ASSIGN cont = cont + 1.     
    PUT stream s_arqexport UNFORMATTED
        "9" AT 01
        cont FORMAT "9999999" AT 594.
    
    OUTPUT STREAM s_arqexport CLOSE.

END PROCEDURE.

PROCEDURE pi_cria_tt_cliente_tit_acr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST tt_cliente_tit_acr NO-LOCK
         WHERE tt_cliente_tit_acr.v_cod_estab      = tit_acr.cod_estab
           AND tt_cliente_tit_acr.v_num_id_tit_acr = tit_acr.num_id_tit_acr NO-ERROR.
    
    IF NOT AVAIL tt_cliente_tit_acr 
    THEN DO:

         FIND FIRST emscad.cliente NO-LOCK 
              WHERE emscad.cliente.cod_empresa = tit_acr.cod_empresa
                AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.

         IF emscad.cliente.cod_pais <> "BRA" 
            THEN NEXT.

         CREATE tt_cliente_tit_acr.
         ASSIGN tt_cliente_tit_acr.v_cod_estab          = tit_acr.cod_estab     
                tt_cliente_tit_acr.v_num_id_tit_acr     = tit_acr.num_id_tit_acr
                tt_cliente_tit_acr.v_cdn_cliente        = emscad.cliente.cdn_cliente
                tt_cliente_tit_acr.v_tip_env            = IF v_tip_envio = "Implantaá∆o" THEN "I" ELSE "E"
                tt_cliente_tit_acr.l_tit_acr_sel        = YES
                tt_cliente_tit_acr.v_nom_abrev          = emscad.cliente.nom_abrev
                tt_cliente_tit_acr.cod_espec_docto      = tit_acr.cod_espec_docto     
                tt_cliente_tit_acr.cod_ser_docto        = tit_acr.cod_ser_docto       
                tt_cliente_tit_acr.cod_tit_acr          = tit_acr.cod_tit_acr         
                tt_cliente_tit_acr.cod_parcela          = tit_acr.cod_parcela         
                tt_cliente_tit_acr.cod_portador         = tit_acr.cod_portador        
                tt_cliente_tit_acr.cod_cart_bcia        = tit_acr.cod_cart_bcia       
                tt_cliente_tit_acr.cod_grp_clien        = emscad.cliente.cod_grp_clien
                tt_cliente_tit_acr.dat_emis_docto       = tit_acr.dat_emis_docto      
                tt_cliente_tit_acr.dat_vencto_tit_acr   = tit_acr.dat_vencto_tit_acr  
                tt_cliente_tit_acr.dat_liquidac_tit_acr = tit_acr.dat_liquidac_tit_acr
                tt_cliente_tit_acr.val_sdo_tit_acr      = tit_acr.val_sdo_tit_acr     
                tt_cliente_tit_acr.dat_envi_asses_cob   = IF AVAIL int_tit_acr THEN int_tit_acr.dat_envi_asses_cob ELSE ?
                tt_cliente_tit_acr.dat_ret_asses_cob    = IF AVAIL int_tit_acr THEN int_tit_acr.dat_ret_asses_cob  ELSE ?.

    END.

END PROCEDURE.

PROCEDURE pi_carrega_tt_acr711zo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR v_cod_refer LIKE tit_acr.cod_refer.
    DEF VAR v_num_aux_2 AS INT.
    DEF VAR v_num_aux_3 AS INT.
    DEF VAR v_num_aux   AS INT.

    REPEAT:

       ASSIGN v_cod_refer = string(time)                        
              v_num_aux_2 = integer(this-procedure:handle)      
              v_num_aux_3 = TIME                                
              v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97 
              v_cod_refer = v_cod_refer + chr(v_num_aux)        
              v_num_aux   = (random(0,v_num_aux_3) mod 26) + 97 
              v_cod_refer = v_cod_refer + chr(v_num_aux)        
              v_num_aux   = (random(0,v_num_aux) mod 26) + 97   
              v_cod_refer = v_cod_refer + chr(v_num_aux)        
              v_num_aux   = (random(0,v_num_aux) mod 26) + 97   
              v_cod_refer = v_cod_refer + chr(v_num_aux)        
              v_num_aux   = (random(0,v_num_aux) mod 26) + 97   
              v_cod_refer = v_cod_refer + chr(v_num_aux).       

       FIND FIRST tt_alter_tit_acr_base_2 NO-LOCK
           WHERE tt_alter_tit_acr_base_2.tta_cod_refer = v_cod_refer NO-ERROR.
       FIND FIRST movto_tit_acr NO-LOCK
           WHERE movto_tit_acr.cod_estab = tit_acr.cod_estab 
             AND movto_tit_acr.cod_refer = v_cod_refer NO-ERROR.
       IF  NOT AVAIL movto_tit_acr 
       AND NOT AVAIL tt_alter_tit_acr_base_2 
           THEN LEAVE.

    END.                                       

    CREATE tt_alter_tit_acr_base_2.
    ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                     = tit_acr.cod_estab
           tt_alter_tit_acr_base_2.tta_num_id_tit_acr                = tit_acr.num_id_tit_acr
           tt_alter_tit_acr_base_2.tta_dat_transacao                 = TODAY 
           tt_alter_tit_acr_base_2.tta_cod_refer                     = v_cod_refer
           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp   = ?
           tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr               = ?
           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt   = ?
           tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val          = ?
           tt_alter_tit_acr_base_2.tta_cod_portador                  = ?
           tt_alter_tit_acr_base_2.tta_cod_cart_bcia                 = ?
           tt_alter_tit_acr_base_2.tta_val_despes_bcia               = ?
           tt_alter_tit_acr_base_2.tta_cod_agenc_cobr_bcia           = ?
           tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco               = ?
           tt_alter_tit_acr_base_2.tta_dat_emis_docto                = 01/01/0001
           tt_alter_tit_acr_base_2.tta_dat_vencto_tit_acr            = 01/01/0001
           tt_alter_tit_acr_base_2.tta_dat_prev_liquidac             = 01/01/0001
           tt_alter_tit_acr_base_2.tta_dat_fluxo_tit_acr             = 01/01/0001
           tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr               = ?
           tt_alter_tit_acr_base_2.tta_cod_cond_cobr                 = "99"
           tt_alter_tit_acr_base_2.tta_log_tip_cr_perda_dedut_tit    = ?
           tt_alter_tit_acr_base_2.tta_dat_abat_tit_acr              = ?
           tt_alter_tit_acr_base_2.tta_val_perc_abat_acr             = ?
           tt_alter_tit_acr_base_2.tta_val_abat_tit_acr              = ?
           tt_alter_tit_acr_base_2.tta_dat_desconto                  = 01/01/0001
           tt_alter_tit_acr_base_2.tta_val_perc_desc                 = ?
           tt_alter_tit_acr_base_2.tta_val_desc_tit_acr              = ?
           tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_juros_acr     = ?
           tt_alter_tit_acr_base_2.tta_val_perc_juros_dia_atraso     = ?
           tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_multa_acr     = ?
           tt_alter_tit_acr_base_2.tta_val_perc_multa_atraso         = ?
           tt_alter_tit_acr_base_2.ttv_cod_portador_mov              = ?
           tt_alter_tit_acr_base_2.tta_ind_tip_cobr_acr              = ?
           tt_alter_tit_acr_base_2.tta_ind_ender_cobr                = ?
           tt_alter_tit_acr_base_2.tta_nom_abrev_contat              = ?
           tt_alter_tit_acr_base_2.tta_val_liq_tit_acr               = ?
           tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_1_movto      = ?
           tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_2_movto      = ?
           tt_alter_tit_acr_base_2.tta_log_tit_acr_destndo           = ?
           tt_alter_tit_acr_base_2.tta_cod_histor_padr               = ?
           tt_alter_tit_acr_base_2.ttv_des_text_histor               = "Convem - Pefin; Alocado a Condiá∆o de Cobranáa 99 pelo usu†rio " + 
                                                                        CAPS(v_cod_usuar_corren) + " as " + STRING(TIME,"hh:mm:ss") + " no dia " +
                                                                        STRING(TODAY)
           tt_alter_tit_acr_base_2.tta_des_obs_cobr                  = ?
           tt_alter_tit_acr_base_2.ttv_wgh_lista                     = ?
           tt_alter_tit_acr_base_2.tta_num_seq_tit_acr               = ?
           tt_alter_tit_acr_base_2.ttv_cod_estab_planilha            = ?
           tt_alter_tit_acr_base_2.ttv_num_planilha_vendor           = ?
           tt_alter_tit_acr_base_2.ttv_cod_cond_pagto_vendor         = ?
           tt_alter_tit_acr_base_2.ttv_val_cotac_tax_vendor_clien    = ?
           tt_alter_tit_acr_base_2.ttv_dat_base_fechto_vendor        = ?
           tt_alter_tit_acr_base_2.ttv_qti_dias_carenc_fechto        = ?
           tt_alter_tit_acr_base_2.ttv_log_assume_tax_bco            = ?
           tt_alter_tit_acr_base_2.ttv_log_vendor                    = ?.

END PROCEDURE.

PROCEDURE pi_roda_acr711zo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF BUFFER b_tit_acr_log FOR tit_acr.

    FIND FIRST tt_alter_tit_acr_base_2 NO-LOCK NO-ERROR.
    IF AVAIL tt_alter_tit_acr_base_2 
    THEN DO:
   
         RUN prgfin/acr/acr711zo.py (INPUT 4,
                                     INPUT  TABLE tt_alter_tit_acr_base_2,
                                     INPUT  TABLE tt_alter_tit_acr_rateio,
                                     INPUT  TABLE tt_alter_tit_acr_ped_vda,
                                     INPUT  TABLE tt_alter_tit_acr_comis,
                                     INPUT  TABLE tt_alter_tit_acr_cheq,
                                     INPUT  TABLE tt_alter_tit_acr_iva,
                                     INPUT  TABLE tt_alter_tit_acr_impto_retid_2,
                                     INPUT  TABLE tt_alter_tit_acr_cobr_espec_2,
                                     INPUT  TABLE tt_alter_tit_acr_rat_desp_rec,
                                     OUTPUT TABLE tt_log_erros_alter_tit_acr,
                                     INPUT NO).
      
         IF CAN-FIND(FIRST tt_log_erros_alter_tit_acr) 
         THEN DO:
              FOR EACH tt_log_erros_alter_tit_acr:
                  FIND b_tit_acr_log NO-LOCK
                      WHERE b_tit_acr_log.cod_estab      = tt_log_erros_alter_tit_acr.tta_cod_estab
                        AND b_tit_acr_log.num_id_tit_acr = tt_log_erros_alter_tit_acr.tta_num_id_tit_acr NO-ERROR.

                  PUT STREAM s_arqrelat SKIP(2).
                  PUT STREAM s_arqrelat UNFORMATTED "Estab: "             b_tit_acr_log.cod_estab          SKIP
                                                    "Espec: "             b_tit_acr_log.cod_espec_docto    SKIP
                                                    "Ser:   "             b_tit_acr_log.cod_ser_docto      SKIP
                                                    "T°tulo:"             b_tit_acr_log.cod_tit_acr        SKIP
                                                    "Parc:  "             b_tit_acr_log.cod_parcela        SKIP
                                                    "Token Cta Receber: " tt_log_erros_alter_tit_acr.tta_num_id_tit_acr  SKIP
                                                    "N£mero Mensagem: "   tt_log_erros_alter_tit_acr.ttv_num_mensagem    SKIP
                                                    "Tipo Mensagem: "     tt_log_erros_alter_tit_acr.ttv_cod_tip_msg_dwb SKIP
                                                    "Inconsistància: "    tt_log_erros_alter_tit_acr.ttv_des_msg_erro    SKIP
                                                    "Mensagem Ajuda: "    tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda   SKIP.

                  /* ** Localiza temp-table que ser† exportada e retira o t°tulo da seleá∆o ***/
                  FIND tt_cliente_tit_acr
                      WHERE tt_cliente_tit_acr.v_cod_estab      = tt_log_erros_alter_tit_acr.tta_cod_estab
                        AND tt_cliente_tit_acr.v_num_id_tit_acr = tt_log_erros_alter_tit_acr.tta_num_id_tit_acr NO-ERROR.
                  IF AVAIL tt_cliente_tit_acr 
                     THEN ASSIGN tt_cliente_tit_acr.l_tit_acr_sel = NO.

              END.
         END.
         FOR EACH tt_alter_tit_acr_base_2: 
             DELETE tt_alter_tit_acr_base_2. 
         END.

    END.

END PROCEDURE.

PROCEDURE pi_cria_int_tit_acr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt_cliente_tit_acr NO-LOCK
        WHERE tt_cliente_tit_acr.l_tit_acr_sel = YES:
        FIND FIRST tit_acr NO-LOCK
             WHERE tit_acr.cod_estab      = tt_cliente_tit_acr.v_cod_estab
               AND tit_acr.num_id_tit_acr = tt_cliente_tit_acr.v_num_id_tit_acr NO-ERROR.
        IF tit_acr.cod_cond_cobr  = "99" /*Condicao de Cobranáa do Serasa*/ 
        THEN DO:

             FIND FIRST int_tit_acr OF tit_acr NO-ERROR.
             IF NOT AVAIL int_tit_acr 
             THEN DO:
                  CREATE int_tit_acr.
                  ASSIGN int_tit_acr.cod_estab      = tit_acr.cod_estab
                         int_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr.
             END.
             ASSIGN int_tit_acr.dat_envi_asses_cob = TODAY.
             
        END.
        ELSE DO:
             FIND FIRST tt_log_erros_alter_tit_acr NO-LOCK
                  WHERE tt_log_erros_alter_tit_acr.tta_cod_estab      = tt_cliente_tit_acr.v_cod_estab
                    AND tt_log_erros_alter_tit_acr.tta_num_id_tit_acr = tt_cliente_tit_acr.v_num_id_tit_acr NO-ERROR.
             IF AVAIL tt_log_erros_alter_tit_acr 
                THEN ASSIGN tt_cliente_tit_acr.v_obs = STRING(tt_log_erros_alter_tit_acr.ttv_num_mensagem) + " - " + STRING(tt_log_erros_alter_tit_acr.ttv_des_msg_erro).
                ELSE IF tit_acr.cod_cond_cobr <> "98" 
                        THEN ASSIGN tt_cliente_tit_acr.v_obs = "Titulo n∆o alocado com Condiáo de Cobranáa 99.".
        END.
    END.

END PROCEDURE.

PROCEDURE pi_cria_histor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p_obs  AS CHARACTER FORMAT "x(40)" NO-UNDO.
    DEF INPUT PARAM p_cond AS CHARACTER FORMAT "x(40)" NO-UNDO.

    DEF BUFFER b_histor_movto_tit_acr FOR histor_movto_tit_acr.

    FIND LAST movto_tit_acr NO-LOCK
         WHERE movto_tit_acr.cod_estab         = tit_acr.cod_estab
           AND movto_tit_acr.num_id_tit_acr    = tit_acr.num_id_tit_acr
           AND (movto_tit_acr.ind_trans_acr    = "Implantaá∆o" OR    
                movto_tit_acr.ind_trans_acr    = "Renegociaá∆o")
           AND movto_tit_acr.log_movto_estordo = NO NO-ERROR.

    IF AVAIL movto_tit_acr 
    THEN DO:
         FIND LAST b_histor_movto_tit_acr NO-LOCK
              WHERE b_histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                AND b_histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                AND b_histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.

         CREATE histor_movto_tit_acr.
         ASSIGN histor_movto_tit_acr.cod_estab                   = movto_tit_acr.cod_estab
                histor_movto_tit_acr.num_id_tit_acr              = movto_tit_acr.num_id_tit_acr
                histor_movto_tit_acr.num_id_movto_tit_acr        = movto_tit_acr.num_id_movto_tit_acr
                histor_movto_tit_acr.num_seq_histor_movto_acr    = IF AVAIL b_histor_movto_tit_acr THEN (b_histor_movto_tit_acr.num_seq_histor_movto_acr + 1) ELSE 1
                histor_movto_tit_acr.ind_orig_histor_acr         = "Sistema"
                histor_movto_tit_acr.des_text_histor             = "Convem - Pefin; " + p_obs + CAPS(v_cod_usuar_corren) + " as " + STRING(TIME,"hh:mm:ss") + " no dia " + STRING(TODAY).

         IF p_cond = "" 
         THEN DO:
              FIND CURRENT tit_acr EXCLUSIVE-LOCK.
              IF AVAIL tit_acr 
              THEN DO:
                   ASSIGN tit_acr.cod_cond_cobr = "".

                   FIND LAST b_histor_movto_tit_acr NO-LOCK
                        WHERE b_histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
                          AND b_histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
                          AND b_histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.

                   CREATE histor_movto_tit_acr.
                   ASSIGN histor_movto_tit_acr.cod_estab                   = movto_tit_acr.cod_estab
                          histor_movto_tit_acr.num_id_tit_acr              = movto_tit_acr.num_id_tit_acr
                          histor_movto_tit_acr.num_id_movto_tit_acr        = movto_tit_acr.num_id_movto_tit_acr
                          histor_movto_tit_acr.num_seq_histor_movto_acr    = IF AVAIL b_histor_movto_tit_acr THEN (b_histor_movto_tit_acr.num_seq_histor_movto_acr + 1) ELSE 1
                          histor_movto_tit_acr.ind_orig_histor_acr         = "Sistema"
                          histor_movto_tit_acr.des_text_histor             = "Convem - Pefin; " + "Retirada a Condiá∆o de Cobranáa 99 do t°tulo conforme Baixa do Serasa. Usu†rio: " + CAPS(v_cod_usuar_corren) + " as " + STRING(TIME,"hh:mm:ss") + " no dia " + STRING(TODAY).

              END.
         END.
    END.
END PROCEDURE.

PROCEDURE pi_imprime_relat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR v_dat_remes  LIKE int_tit_acr.dat_envi_asses_cob.
  DEF VAR v_dat_ret    LIKE int_tit_acr.dat_envi_asses_cob.
  DEF VAR v_cod_operac AS CHAR.


  RUN Pi_Imprime_Cabecalho (INPUT NO).

  FOR EACH tt_cliente_tit_acr NO-LOCK
      WHERE tt_cliente_tit_acr.l_tit_acr_sel = YES:

       FIND FIRST tit_acr NO-LOCK
            WHERE tit_acr.cod_estab      = tt_cliente_tit_acr.v_cod_estab
              AND tit_acr.num_id_tit_acr = tt_cliente_tit_acr.v_num_id_tit_acr NO-ERROR.
       IF AVAIL tit_acr 
       THEN DO:

           FIND FIRST int_tit_acr OF tit_acr NO-ERROR.
           IF AVAIL int_tit_acr 
              THEN ASSIGN v_dat_remes = int_tit_acr.dat_envi_asses_cob 
                          v_dat_ret   = int_tit_acr.dat_ret_asses_cob. 
              ELSE ASSIGN v_dat_remes = ?
                          v_dat_ret   = ?.

           FIND emscad.cliente NO-LOCK
               WHERE emscad.cliente.cod_empresa = tit_acr.cod_empresa
                 AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.

           FIND int-emitente NO-LOCK
               WHERE int-emitente.cod-emitente = emscad.cliente.cdn_cliente NO-ERROR.

           IF tt_cliente_tit_acr.v_tip_env = "I" 
              THEN ASSIGN v_cod_operac = "Entrada".
              ELSE ASSIGN v_cod_operac = "Baixa".
           IF tt_cliente_tit_acr.v_obs <> "" 
              THEN ASSIGN v_cod_operac = "Rejeitado".

           PUT STREAM s_arqrelat 
               tt_cliente_tit_acr.v_cod_estab   FORMAT "X(03)"      " "
               tt_cliente_tit_acr.v_cdn_cliente FORMAT "ZZZZZZZZ9"  " "
               tt_cliente_tit_acr.v_nom_abrev   FORMAT "X(10)"      " "
               tit_acr.cod_espec_docto          FORMAT "X(03)"      " "
               tit_acr.cod_ser_docto            FORMAT "X(03)"      " "
               tit_acr.cod_tit_Acr              FORMAT "X(10)"      " "
               tit_acr.cod_parcela              FORMAT "X(02)"      " "
               tit_acr.dat_emis_docto           FORMAT "99/99/9999" " "
               tit_acr.dat_vencto_tit_acr       FORMAT "99/99/9999" " "
               v_cod_operac                     FORMAT "x(10)"      " "
               v_dat_remes                      FORMAT "99/99/9999" " "
               v_dat_ret                        FORMAT "99/99/9999" " "
               tit_acr.cod_portador             FORMAT "X(05)"      " "
               tit_acr.cod_cart_bcia            FORMAT "X(03)"      "  "
               IF AVAIL int-emitente THEN string(int-emitente.cod-gr-cob) ELSE emscad.cliente.cod_grp_clien       FORMAT "X(03)"      " "
               tit_acr.val_sdo_tit_acr          /*FORMAT ">>>>>>.>>9,99"*/ " "
               tt_cliente_tit_acr.v_obs         FORMAT "X(100)"   " " SKIP.

       END.
  END.

  RUN Pi_Imprime_Rodape.

END PROCEDURE.

PROCEDURE pi_imprime_cabecalho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAM P_Log_Pula      AS LOGI NO-UNDO.
  DEF VAR c-empresa LIKE emscad.empresa.nom_razao_social.

  FIND FIRST emscad.empresa NO-LOCK
      WHERE empresa.cod_emp = v_cod_empres_usuar NO-ERROR.

  ASSIGN  c-empresa = IF AVAIL empresa THEN empresa.nom_razao_social ELSE "".

  IF P_Log_Pula THEN DO:
      IF (60 - LINE-COUNTER(s_arqrelat)) > 0  THEN 
          PUT STREAM s_arqrelat SKIP(60 - LINE-COUNTER(s_arqrelat)).
      RUN Pi_Imprime_Rodape.
      PAGE STREAM s_arqrelat.
  END. /* End do - IF P_Log_Pula */

  PUT STREAM s_arqrelat UNFORMATTED FILL("-",131) FORM "x(131)" AT 01 SKIP
                                  C-Empresa                     AT 01
                                  "Envio PEFIN/SERASA"          AT 64 
                                  "Pag: "                       AT 123
                                  "1"                           TO 131 SKIP
                                  FILL("-",109) FORM "x(109)"          
                                  TODAY FORM "99/99/9999"       TO 120
                                  " - "
                                  String(TIME,"HH:MM:SS")       TO 131.

  PUT STREAM s_arqrelat UNFORMATTED SKIP(1)
             "Arquivo Exportado:"           AT 20
             STRING(c_arquivo_export, "x(85)")     AT 40 SKIP 
             "Arquivo de Log:"              AT 20
             STRING(v_cod_arq_log, "x(85)") AT 40 SKIP
             "Data: "                       AT 20
             TODAY                          AT 26
             "Hora: "                       AT 40
             STRING(TIME,"hh:mm:ss")        AT 46
             SKIP(1).

  PUT STREAM s_arqrelat UNFORMATTED 
             "Dat."      AT 048
             "Dat."      AT 059
             "Env."      AT 081
             "Baixa"     AT 092
             "Cart."     AT 109
             "Est"       AT 001
             "Cliente"   AT 005
             "NomeAbrev" AT 015
             "Esp"       AT 026
             "Ser"       AT 030
             "Titulo"    AT 034
             "/P"        AT 045
             "Emiss"     AT 048
             "Vencto"    AT 059
             "Operaá∆o"  AT 070
             "Serasa"    AT 081
             "Serasa"    AT 092
             "Port"      AT 103
             "Bcia"      AT 109
             "Grp"       AT 114
             "Val Sdo"   AT 125
             FILL("-",131) FORM "x(131)"   AT 01 SKIP .

END PROCEDURE.

PROCEDURE pi_imprime_rodape :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    PUT STREAM s_arqrelat SKIP(3).

    IF (60 - LINE-COUNTER(s_arqrelat)) > 0 THEN 
       PUT STREAM s_arqrelat SKIP(60 - LINE-COUNTER(s_arqrelat)).

    PUT STREAM s_arqrelat UNFORMATTED FILL("-",81)  FORM "x(81)"
        "Intelbras - Espec°ficos - ESACR029 - 1.00.00.000" to 131 SKIP.

END PROCEDURE.

PROCEDURE pi-envia-email:

    FOR EACH tt_mail_fax:

        EMPTY TEMP-TABLE tt_mail_fax_btb.
        EMPTY TEMP-TABLE tt_erros_mail_fax.

        BUFFER-COPY tt_mail_fax TO tt_mail_fax_btb.

        RUN prgtec\btb\btb916za.py (INPUT "1",
                                    INPUT  TABLE tt_mail_fax_btb,
                                    OUTPUT TABLE tt_erros_mail_fax).
    
        /* Erro da API de envio de email ser∆o enviados para um arquivo no diret¢rio tempor†rio */
        IF  CAN-FIND(tt_erros_mail_fax) 
        THEN DO:
             FIND FIRST tt_erros_mail_fax NO-LOCK NO-ERROR.
             IF AVAIL tt_erros_mail_fax THEN
                 MESSAGE "Erro: "       tt_erros_mail_fax.ttv_cod_erro SKIP
                         "Desc Erro: "  tt_erros_mail_fax.ttv_des_erro SKIP
                         "Desc Arq: "   tt_erros_mail_fax.ttv_des_arquivo                          
                         VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.

    END.

END.
