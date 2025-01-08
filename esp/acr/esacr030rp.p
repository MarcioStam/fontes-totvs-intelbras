/*****************************************************************************
** Programa..............: esp/esacr030rp.p
** Descriá∆o.............: Retorno arquivo SERASA via WinSCP
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 19/08/2010
*****************************************************************************/
def temp-table tt-raw-digita
   field raw-digita      as raw.

def input parameter raw-param as raw no-undo.
def input parameter table     for tt-raw-digita.

/*********************************************************************************************

- Regras Retorno do arquivo:

	- Importar todos os arquivos do diret¢rio S:\Financeiro\Serasa\WinSCP\Retorno
	- Mover arquivos processados para o diret¢rio S:\Financeiro\Serasa\WinSCP\Retorno\bkp
	- Gerar relat¢rio contendo t°tulos, motivo (implantaá∆o/baixa) e log de processamento, gravando no diret¢rio S:\Financeiro\Serasa\WinSCP\Retorno\log. 
    - O relat¢rio enviar tambÇm via e-mail para uma lista informada no es0018, informando os arquivos importados.
	- O agendamento da importaá∆o do retorno do SERASA no ERP ser† Ös 05:30


- Pendàncias do Processo

	- alterar rotina que troca o grupo de cliente 08-06 para alterar a instruá∆o banc†ria ?
    - Grupos <> "08" e com instriá∆o_1 = "07" alterar a instruá∆o_2 para "08" - n∆o enviar SERASA
	- Grupo = "08" alterar todos para instruá∆o_1 = "07". A excess∆o, instruá∆o_2 = "08" ser† feita manualmente
    - Alterar as instruá‰es nos clientes ou alterar a instruá∆o banc†ria banco para todoas apontar para o n∆o protestar ?

***********************************************************************************************/

DEF TEMP-TABLE tt_cliente_tit_acr 
  FIELD v_cod_pais           LIKE emsuni.cliente.cod_pais           
  FIELD v_cod_id_feder       LIKE emsuni.pessoa_jurid.cod_id_feder 
  FIELD v_cod_estab          LIKE tit_acr.cod_estab                
  FIELD v_num_id_tit_acr     LIKE tit_acr.num_id_tit_acr           
  FIELD v_cdn_cliente        LIKE emsuni.cliente.cdn_cliente
  FIELD v_nom_abrev          LIKE emscad.cliente.nom_abrev
  FIELD v_tip_env            AS   CHAR /*Implantacao, Baixa e Ambos*/
  FIELD v_obs                AS   CHAR FORMAT "x(50)"
  FIELD l_tit_acr_sel        AS   LOG INITIAL NO
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

DEF STREAM s_import_dir.
DEF STREAM s_import_arq.
DEF STREAM s_arqrelat.

DEFINE VARIABLE v_cod_dir     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_dir_log AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_dir_bkp AS CHARACTER   NO-UNDO.

DEFINE VARIABLE v_cod_arq_log AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_aux     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_arq     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_linha   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-erros-ret   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_log_achou   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-cont-aux    AS INTEGER     NO-UNDO.
DEFINE VARIABLE v_num_seq     AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-msg      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

/* **
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usuˇrio Corrente"
    column-label "Usuˇrio Corrente"
    no-undo. ***/

/* ** Fixado o usu†rio pois a execuá∆o ser† agendada pelo RPW com outro usu†rio ***/
DEFINE VARIABLE v_cod_usuar_corren AS CHARACTER   NO-UNDO.
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

/* ** Executar integraá∆o com o SERASA para baixar os arquivos de retorno ***/
DEF VAR v_nom_EDI7 AS CHAR FORMAT "x(100)".
ASSIGN v_nom_EDI7 = '"' + c-dir-saida + 'serasa~\WinSCP~\serasa.bat"'.
OS-COMMAND VALUE(v_nom_EDI7).
PAUSE 50.
/* ** Fim da integraá∆o com o SERASA ***/

/* ** Verifica se existe arquivo de envio, caso exista, move para a pasta bkp pois foi enviado neste processamento ***/
DEFINE VARIABLE v_cod_arq_env     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_arq_env_new AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_dir_env     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_dir_bkp_env AS CHARACTER   NO-UNDO.

ASSIGN v_cod_dir_env     = c-dir-saida + "serasa~\WinSCP~\Envio~\"      /* ** local onde o Intelbras disponibiliza os arquivos ***/
       v_cod_dir_bkp_env = c-dir-saida + "serasa~\WinSCP~\Envio~\bkp~\"  /* ** transfere bkp arquivos enviados                  ***/
       v_cod_arq_env     = v_cod_dir_env + "convem.txt"
       v_cod_arq_env_new = v_cod_dir_env + "convem" + STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") + STRING(DAY(TODAY), "99") + STRING(TIME) + ".txt".

OS-RENAME VALUE(v_cod_arq_env)     VALUE(v_cod_arq_env_new).
OS-COPY   VALUE(v_cod_arq_env_new) VALUE(v_cod_dir_bkp_env).
OS-DELETE VALUE(v_cod_arq_env_new).

/* ** Tratamento para a Importaá∆o dos arquivos de Retorno ***/
ASSIGN v_cod_dir     = c-dir-saida + "serasa~\WinSCP~\Retorno~\"      /* ** local onde o SERASA disponibiliza todos os arquivos ***/
       v_cod_dir_log = c-dir-saida + "serasa~\WinSCP~\Retorno~\log~\"  /* ** criar log do resultado da importaá∆o                ***/
       v_cod_dir_bkp = c-dir-saida + "serasa~\WinSCP~\Retorno~\bkp~\". /* ** transfere bkp arquivos importados.                  ***/

INPUT STREAM s_import_dir FROM OS-DIR (v_cod_dir).

blk_arquivo:
REPEAT:

     IMPORT STREAM s_import_dir v_cod_aux.

     IF v_cod_aux = "." 
     OR v_cod_aux = ".." 
     OR SEARCH(v_cod_dir + v_cod_aux) = ?
        THEN NEXT.

     ASSIGN v_cod_arq = v_cod_dir + v_cod_aux.

     IF  v_cod_arq MATCHES "*INF*" 
     OR  v_cod_arq MATCHES "*RELATO*" THEN
         NEXT.

     /* ** Tratamento LOG ***/
     ASSIGN v_num_seq = v_num_seq + 1.
     ASSIGN v_cod_arq_log = v_cod_dir_log + "SER" + STRING(YEAR(TODAY), "9999") + STRING(MONTH(TODAY), "99") + STRING(DAY(TODAY), "99") + STRING(TIME) + STRING(v_num_seq, "99") + ".LOG".
     OUTPUT STREAM s_arqrelat TO VALUE(v_cod_arq_log) PAGED PAGE-SIZE VALUE(66) CONVERT TARGET 'iso8859-1'.

     INPUT STREAM s_import_arq FROM VALUE(v_cod_arq). 

     FOR EACH tt_cliente_tit_acr:
         DELETE tt_cliente_tit_acr.
     END.

     blk_import:
     REPEAT:

         ASSIGN v_cod_linha = ""
                c-erros-ret = "".

         IMPORT STREAM s_import_arq UNFORMATTED v_cod_linha.

         IF v_cod_linha = "" 
            THEN NEXT.

         IF  SUBSTRING(v_cod_linha,1,1)    = "0" 
         AND SUBSTRING(v_cod_linha,126,1) <> "R" 
         THEN DO:

              RUN pi_imprime_cabecalho (INPUT NO).
              PUT STREAM s_arqrelat SKIP(3).
              PUT STREAM s_arqrelat UNFORMATTED "ERRO: ARQUIVO INVµLIDO - Arquivo Informado N∆o Ç de Retorno do SERASA!" SKIP.             
              RUN pi_imprime_rodape.

              OUTPUT STREAM s_arqrelat   CLOSE.
              INPUT  STREAM s_import_arq CLOSE.

              /* ** Transfere arquivos para pasta de j† importados ***/
              OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_bkp).
              OS-DELETE VALUE(v_cod_arq).

              /* ** criar temp-table para enviar e-mail com os arquivos de log. ***/
              ASSIGN c-msg      = "ERRO - Importaá∆o PEFIN - " + STRING(TODAY)
                     c-mensagem = "Em anexo resumo da importaá∆o do PEFIN/SERASA.".
        
              CREATE tt_mail_fax.
              ASSIGN tt_mail_fax.ttv_nom_to          = c-email
                     tt_mail_fax.ttv_nom_subject     = c-msg
                     tt_mail_fax.ttv_nom_message     = c-mensagem
                     tt_mail_fax.ttv_nom_attachfile  = v_cod_arq_log    
                     tt_mail_fax.ttv_num_imptcia     = 2
                     tt_mail_fax.ttv_cod_format_mail = "texto"
                     tt_mail_fax.ttv_nom_from        = "ems@intelbras.com.br".

              NEXT blk_arquivo.

         END.
             
         IF  SUBSTRING(v_cod_linha,1,1)    = "0" 
         AND SUBSTRING(v_cod_linha,534,3) <> ""
         THEN DO:

              RUN pi_imprime_cabecalho (INPUT NO).
              PUT STREAM s_arqrelat SKIP(3).
              PUT STREAM s_arqrelat UNFORMATTED "ERRO: ARQUIVO REJEITADO - C¢digo de Erro: " SUBSTRING(v_cod_linha,534,3) SKIP.             
              RUN pi_imprime_rodape.
              
              OUTPUT STREAM s_arqrelat   CLOSE.
              INPUT  STREAM s_import_arq CLOSE.

              /* ** Transfere arquivos para pasta de j† importados ***/
              OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_bkp).
              OS-DELETE VALUE(v_cod_arq).

              /* ** criar temp-table para enviar e-mail com os arquivos de log. ***/
              ASSIGN c-msg      = "ERRO - Importaá∆o PEFIN - " + STRING(TODAY)
                     c-mensagem = "Em anexo resumo da importaá∆o do PEFIN/SERASA.".
        
              CREATE tt_mail_fax.
              ASSIGN tt_mail_fax.ttv_nom_to          = c-email
                     tt_mail_fax.ttv_nom_subject     = c-msg
                     tt_mail_fax.ttv_nom_message     = c-mensagem
                     tt_mail_fax.ttv_nom_attachfile  = v_cod_arq_log    
                     tt_mail_fax.ttv_num_imptcia     = 2
                     tt_mail_fax.ttv_cod_format_mail = "texto"
                     tt_mail_fax.ttv_nom_from        = "ems@intelbras.com.br".

              NEXT blk_arquivo.

         END.

         IF  SUBSTRING(v_cod_linha,1,1)  = "1" THEN DO:

             /* antes de entrar na alteraá∆o de t°tulos, deve ser validado se tem erros no arquivo */
             ASSIGN v_log_achou = NO.
             FOR EACH estabelecimento NO-LOCK
                 WHERE estabelecimento.cod_empres = v_cod_empres_usuar:
                 FIND FIRST tit_acr NO-LOCK
                      WHERE tit_acr.cod_estab         = estabelecimento.cod_estab
                        AND tit_acr.cod_espec_docto   = SUBSTRING(v_cod_linha,439,3)
                        AND tit_acr.cod_ser_docto     = SUBSTRING(v_cod_linha,442,3)
                        AND tit_acr.cod_tit_acr       = SUBSTRING(v_cod_linha,445,8)
                        AND tit_acr.cod_parcela       = SUBSTRING(v_cod_linha,453,2)  NO-ERROR.
                 IF AVAIL tit_acr 
                 THEN DO: 
                      /* ** Verificar o cliente pois n∆o temos espaáo do layout do SERASA para enviar o estabelecimento. ***/
                      IF SUBSTRING(v_cod_linha,32,1) = "J" 
                      THEN DO:
                           FIND FIRST emscad.cliente NO-LOCK
                                WHERE emscad.cliente.cod_pais     = "BRA"
                                  AND emscad.cliente.cod_id_feder = SUBSTRING(v_cod_linha,35,14) NO-ERROR.
                      END.
                      ELSE DO:
                           FIND FIRST emscad.cliente NO-LOCK
                                WHERE emscad.cliente.cod_pais     = "BRA"
                                  AND emscad.cliente.cod_id_feder = SUBSTRING(v_cod_linha,38,11) NO-ERROR.
                      END.
                      IF AVAIL emscad.cliente
                      AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente 
                      THEN DO:
                           ASSIGN v_log_achou = YES.
                           LEAVE.
                      END.
                 END.
             END.

             IF v_log_achou = NO 
             THEN DO: 
                  /* ** Cria registro para indicar que o t°tulo n∆o foi localizado ***/
                  CREATE tt_cliente_tit_acr.
                  ASSIGN tt_cliente_tit_acr.v_cod_pais       = "BRA"      
                         tt_cliente_tit_acr.v_cod_id_feder   = SUBSTRING(v_cod_linha,35,14)  
                         tt_cliente_tit_acr.cod_espec_docto  = SUBSTRING(v_cod_linha,439,3)
                         tt_cliente_tit_acr.cod_ser_docto    = SUBSTRING(v_cod_linha,442,3)
                         tt_cliente_tit_acr.cod_tit_acr      = SUBSTRING(v_cod_linha,445,8)
                         tt_cliente_tit_acr.cod_parcela      = SUBSTRING(v_cod_linha,453,2)
                         tt_cliente_tit_acr.v_tip_env        = SUBSTRING(v_cod_linha,2,1)
                         tt_cliente_tit_acr.v_nom_abrev      = "N∆o Localizado"
                         tt_cliente_tit_acr.v_obs            = "*** T°tulo n∆o localizado"
                         tt_cliente_tit_acr.l_tit_acr_sel    = NO
                         tt_cliente_tit_acr.v_num_id_tit_acr = INT(SUBSTRING(v_cod_linha,594,7)) /* ** Tratamento para n∆o duplicar temp-table ***/.  
                  NEXT.    
             END.
                 
             /* ** O retorno da Baixa j† foi processado para o t°tulo ***/
             FIND FIRST int_tit_acr NO-LOCK
                  WHERE int_tit_acr.cod_estab      = tit_acr.cod_estab     
                    AND int_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr NO-ERROR.
             IF  AVAIL int_tit_acr 
             AND int_tit_acr.dat_ret_asses_cob <> ? 
             AND SUBSTRING(v_cod_linha,2,1)    <> "E" THEN DO: 
                  /* ** Cria registro para indicar que o t°tulo j† foi processado ***/
                  FIND FIRST tt_cliente_tit_acr NO-LOCK
                      WHERE tt_cliente_tit_acr.v_cod_pais       = emscad.cliente.cod_pais
                      AND   tt_cliente_tit_acr.v_cod_id_feder   = emscad.cliente.cod_id_feder
                      AND   tt_cliente_tit_acr.v_cod_estab      = tit_acr.cod_estab
                      AND   tt_cliente_tit_acr.v_num_id_tit_acr = tit_acr.num_id_tit_acr
                      AND   tt_cliente_tit_acr.v_cdn_cliente    = emscad.cliente.cdn_cliente NO-ERROR.
                  IF NOT AVAIL tt_cliente_tit_acr 
                  THEN DO:
                       CREATE tt_cliente_tit_acr.
                       ASSIGN tt_cliente_tit_acr.v_cod_pais       = emscad.cliente.cod_pais      
                              tt_cliente_tit_acr.v_cod_id_feder   = emscad.cliente.cod_id_feder  
                              tt_cliente_tit_acr.v_cod_estab      = tit_acr.cod_estab     
                              tt_cliente_tit_acr.v_num_id_tit_acr = tit_acr.num_id_tit_acr
                              tt_cliente_tit_acr.v_cdn_cliente    = emscad.cliente.cdn_cliente
                              tt_cliente_tit_acr.v_tip_env        = SUBSTRING(v_cod_linha,2,1)
                              tt_cliente_tit_acr.v_nom_abrev      = emscad.cliente.nom_abrev
                              tt_cliente_tit_acr.v_obs            = "*** T°tulo j† processado em " + STRING(int_tit_acr.dat_ret_asses_cob, "99/99/9999") + "."
                              tt_cliente_tit_acr.l_tit_acr_sel    = NO.  
                  END.
                  NEXT.       
             END.
                 
             /* ** Altera condiá∆o de cobranáa e gera hist¢rico para o retorno de implantaá∆o e de baixa ***/
             RUN pi_carrega_tt_acr711zo_ret (INPUT SUBSTRING(v_cod_linha,2,1),
                                             INPUT SUBSTRING(v_cod_linha,534,60)).

             /* Os erros podem ocorrer atÇ 20 vezes sequencialmente com 3 d°gitos, dessa forma gravo separado por "," para apresentar no relat¢rio*/
             IF SUBSTRING(v_cod_linha,534,60) <> "" THEN DO:
                 ASSIGN i-cont-aux  = 534
                        c-erros-ret = "".
                 REPEAT:
                     IF SUBSTRING(v_cod_linha,i-cont-aux,3) <> "" THEN DO:
                         ASSIGN c-erros-ret = IF c-erros-ret = "" THEN "Erros Ret.: " + SUBSTRING(v_cod_linha,i-cont-aux,3)
                                              ELSE c-erros-ret + "," + SUBSTRING(v_cod_linha,i-cont-aux,3)
                                i-cont-aux  = i-cont-aux + 3.
                     END.
                     ELSE LEAVE.
                 END.
             END.

             FIND FIRST tt_cliente_tit_acr NO-LOCK
                 WHERE tt_cliente_tit_acr.v_cod_pais       = emscad.cliente.cod_pais
                 AND   tt_cliente_tit_acr.v_cod_id_feder   = emscad.cliente.cod_id_feder
                 AND   tt_cliente_tit_acr.v_cod_estab      = tit_acr.cod_estab
                 AND   tt_cliente_tit_acr.v_num_id_tit_acr = tit_acr.num_id_tit_acr
                 AND   tt_cliente_tit_acr.v_cdn_cliente    = emscad.cliente.cdn_cliente NO-ERROR.
             IF NOT AVAIL tt_cliente_tit_acr THEN DO:

                CREATE tt_cliente_tit_acr.
                ASSIGN tt_cliente_tit_acr.v_cod_pais       = emscad.cliente.cod_pais      
                       tt_cliente_tit_acr.v_cod_id_feder   = emscad.cliente.cod_id_feder  
                       tt_cliente_tit_acr.v_cod_estab      = tit_acr.cod_estab     
                       tt_cliente_tit_acr.v_num_id_tit_acr = tit_acr.num_id_tit_acr
                       tt_cliente_tit_acr.v_cdn_cliente    = emscad.cliente.cdn_cliente
                       tt_cliente_tit_acr.v_tip_env        = SUBSTRING(v_cod_linha,2,1)
                       tt_cliente_tit_acr.v_nom_abrev      = emscad.cliente.nom_abrev
                       tt_cliente_tit_acr.v_obs            = IF c-erros-ret <> "" THEN c-erros-ret ELSE ""
                       tt_cliente_tit_acr.l_tit_acr_sel    = YES.  
             END.
         END.

     END.

     INPUT STREAM s_import_arq CLOSE.

     RUN pi_roda_acr711zo.     
     FOR EACH tt_cliente_tit_acr:
         /* se houve erro na alteraá∆o de t°tulos, grava o mesmo na observaá∆o  */
         IF NOT CAN-FIND(FIRST tt_log_erros_alter_tit_acr
                         WHERE tt_log_erros_alter_tit_acr.tta_cod_estab      = tt_cliente_tit_acr.v_cod_estab     
                           AND tt_log_erros_alter_tit_acr.tta_num_id_tit_acr = tt_cliente_tit_acr.v_num_id_tit_acr) 
         THEN DO:
              FIND FIRST int_tit_acr EXCLUSIVE-LOCK
                   WHERE int_tit_acr.cod_estab      = tt_cliente_tit_acr.v_cod_estab     
                     AND int_tit_acr.num_id_tit_acr = tt_cliente_tit_acr.v_num_id_tit_acr NO-ERROR.
              IF AVAIL int_tit_acr 
              THEN DO:
                   /* ** SERASA acatou a Baixa, e a API de alteraá∆o n∆o retornou erro ***/
                   IF tt_cliente_tit_acr.v_obs = ""
                   THEN DO:
                        IF tt_cliente_tit_acr.v_tip_env = "E"  
                           THEN ASSIGN int_tit_acr.dat_ret_asses_cob = TODAY.
                   END.
                   ELSE DO:
                        /* Para Registros de Implantaá∆o que retornaram com Erros do SERASA, deve-se eliminar valor da Data de Envio para poss°vel reenvio */
                        IF tt_cliente_tit_acr.v_tip_env = "I" 
                           THEN ASSIGN int_tit_acr.dat_envi_asses_cob = ?.
                   END.
              END.
         END.
         ELSE DO:
              FIND FIRST tt_log_erros_alter_tit_acr
                   WHERE tt_log_erros_alter_tit_acr.tta_cod_estab      = tt_cliente_tit_acr.v_cod_estab
                     AND tt_log_erros_alter_tit_acr.tta_num_id_tit_acr = tt_cliente_tit_acr.v_num_id_tit_acr NO-ERROR.
              IF AVAIL tt_log_erros_alter_tit_acr 
                 THEN ASSIGN tt_cliente_tit_acr.v_obs = STRING(tt_log_erros_alter_tit_acr.ttv_num_mensagem) + " - " + STRING(tt_log_erros_alter_tit_acr.ttv_des_msg_erro).
         END.
     END.

     RUN pi_imprime_relat.

     OUTPUT STREAM s_arqrelat  CLOSE.

     /* ** Transfere arquivos para pasta de j† importados ***/
     OS-COPY VALUE(v_cod_arq) VALUE(v_cod_dir_bkp).
     OS-DELETE VALUE(v_cod_arq).

     /* ** criar temp-table para enviar e-mail com os arquivos de log. ***/
     ASSIGN c-msg      = "Importaá∆o PEFIN - " + STRING(TODAY)
            c-mensagem = "Em anexo resumo da importaá∆o do PEFIN/SERASA.".
     CREATE tt_mail_fax.
     ASSIGN tt_mail_fax.ttv_nom_to          = c-email
            tt_mail_fax.ttv_nom_subject     = c-msg
            tt_mail_fax.ttv_nom_message     = c-mensagem
            tt_mail_fax.ttv_nom_attachfile  = v_cod_arq_log    
            tt_mail_fax.ttv_num_imptcia     = 2
            tt_mail_fax.ttv_cod_format_mail = "texto"
            tt_mail_fax.ttv_nom_from        = "ems@intelbras.com.br".

END.

/* ** Caso nao tenha sido importado nenhum arquivo, enviar e-mail informando que n∆o houve importaá∆o neste dia ***/
IF NOT CAN-FIND (FIRST tt_mail_fax)
THEN DO:

     ASSIGN c-msg      = "Importaá∆o PEFIN - " + STRING(TODAY)
            c-mensagem = "Nenhum arquivo foi importado.".

     CREATE tt_mail_fax.
     ASSIGN tt_mail_fax.ttv_nom_to          = c-email
            tt_mail_fax.ttv_nom_subject     = c-msg
            tt_mail_fax.ttv_nom_message     = c-mensagem
            tt_mail_fax.ttv_nom_attachfile  = ""
            tt_mail_fax.ttv_num_imptcia     = 2
            tt_mail_fax.ttv_cod_format_mail = "texto"
            tt_mail_fax.ttv_nom_from        = "ems@intelbras.com.br".

END.

INPUT STREAM s_import_dir CLOSE.

RUN pi-envia-email.

PROCEDURE pi_carrega_tt_acr711zo_ret :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p_tipo_retorno      AS CHAR FORMAT "x(01)".
    DEF INPUT PARAM p_erro_retorno      AS CHAR FORMAT "x(60)".

    DEF VAR v_cod_refer    LIKE tit_acr.cod_refer.
    DEF VAR v_num_aux_2    AS INT.
    DEF VAR v_num_aux_3    AS INT.
    DEF VAR v_num_aux      AS INT.
    DEF VAR v_hist_tit_acr AS CHAR.
    DEF VAR v_cond_cobr    AS CHAR.

    DEFINE VARIABLE c-erros-ret AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cont-aux  AS INTEGER     NO-UNDO.
                     
    /* ** Zarpe
          Quando:
          N∆o Retorna ERRO: 
              - Retorno de Implantaá∆o: gera hist¢tico
              - Retorno de Baixa: gera hist¢rico, altera condiá∆o de cobranáa para "", grava data de retorno na int_tit_acr = today
          Retorna ERRO:
              - Retorno de Implantaá∆o: gera hist¢rico, altera condiá∆o de cobranáa para "", altera data de envio na int_tit_acr = ?
              - Retorno de Baixa: gera hist¢rico
    ***/

    IF p_erro_retorno = "" 
    THEN DO:
         IF p_tipo_retorno = "I" 
            THEN ASSIGN v_hist_tit_acr = "T°tulo Aceito Pelo SERASA. "
                        v_cond_cobr    = ?.
            ELSE ASSIGN v_hist_tit_acr = "Confirmado Baixa Pelo SERASA. Usu†rio: "
                        v_cond_cobr    = "".
    END.
    ELSE DO:

         ASSIGN i-cont-aux  = 1
                c-erros-ret = "".
         REPEAT:
            IF SUBSTRING(p_erro_retorno,i-cont-aux,3) <> "" THEN DO:
                ASSIGN c-erros-ret = IF c-erros-ret = "" THEN "Erros Ret.: " + SUBSTRING(p_erro_retorno,i-cont-aux,3)
                                     ELSE c-erros-ret + "," + SUBSTRING(p_erro_retorno,i-cont-aux,3)
                       i-cont-aux  = i-cont-aux + 3.
            END.
            ELSE LEAVE.
         END.

         IF  p_tipo_retorno = "I" THEN 
             ASSIGN v_hist_tit_acr = "SERASA Reportou Erro no Retorno da Implantaá∆o do T°tulo. "  + TRIM(c-erros-ret) + ". Usu†rio: "
                    v_cond_cobr    = "".
         ELSE 
             IF  AVAIL int_tit_acr 
             AND int_tit_acr.dat_ret_asses_cob <> ? THEN
                 ASSIGN v_hist_tit_acr = "SERASA Reportou Erro no Retorno da Baixa do T°tulo. " + TRIM(c-erros-ret) + ". Usu†rio: "
                        v_cond_cobr    = "".
             ELSE
                 ASSIGN v_hist_tit_acr = "SERASA Reportou Erro no Retorno da Baixa do T°tulo. " + TRIM(c-erros-ret) + ". Usu†rio: "
                        v_cond_cobr    = ?.
    END.

    IF  p_tipo_retorno = "E" THEN DO:
        IF  AVAIL int_tit_acr 
        AND int_tit_acr.dat_ret_asses_cob = ? THEN
            RUN pi_cria_histor(INPUT v_hist_tit_acr,
                               INPUT v_cond_cobr).
            RETURN.
    END.

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
           WHERE tt_alter_tit_acr_base_2.tta_cod_refer = v_cod_refer no-error.

       FIND FIRST movto_tit_acr NO-LOCK
            WHERE movto_tit_acr.cod_estab = tit_acr.cod_estab 
              AND movto_tit_acr.cod_refer = v_cod_refer NO-ERROR.

       IF  NOT AVAIL movto_tit_acr 
       AND NOT AVAIL tt_alter_tit_acr_base_2 
           THEN LEAVE.

    END.                              

    CREATE tt_alter_tit_acr_base_2.
    ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                     = tit_acr.cod_estab
           tt_alter_tit_acr_base_2.tta_num_id_tit_acr                = tit_acr.num_id_tit_Acr
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
           tt_alter_tit_acr_base_2.tta_cod_cond_cobr                 = v_cond_cobr
           tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr               = ?
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
           tt_alter_tit_acr_base_2.ttv_des_text_histor               = "Convem - Pefin; " + v_hist_tit_acr + 
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
    IF AVAIL tt_alter_tit_acr_base_2 THEN DO:
    
        run prgfin/acr/acr711zo.py (Input 4,
                                    Input  table tt_alter_tit_acr_base_2,
                                    Input  table tt_alter_tit_acr_rateio,
                                    Input  table tt_alter_tit_acr_ped_vda,
                                    Input  table tt_alter_tit_acr_comis,
                                    Input  table tt_alter_tit_acr_cheq,
                                    Input  table tt_alter_tit_acr_iva,
                                    Input  table tt_alter_tit_acr_impto_retid_2,
                                    Input  table tt_alter_tit_acr_cobr_espec_2,
                                    Input  table tt_alter_tit_acr_rat_desp_rec,
                                    output table tt_log_erros_alter_tit_acr,
                                    Input no).
    
        IF CAN-FIND(FIRST tt_log_erros_alter_tit_acr) 
        THEN DO:
                 
             RUN pi_imprime_cabecalho (INPUT YES).

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

             RUN pi_imprime_rodape.

        END.
        FOR EACH tt_alter_tit_acr_base_2: 
            DELETE tt_alter_tit_acr_base_2. 
        END.

    END. /*IF AVAIL tt_alter_tit_acr_base_2 THEN DO:*/
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

  FOR EACH tt_cliente_tit_acr NO-LOCK:

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
       ELSE DO:

            ASSIGN v_dat_remes  = ?
                   v_dat_ret    = ?
                   v_cod_operac = "Rejeitado".

            PUT STREAM s_arqrelat 
               tt_cliente_tit_acr.v_cod_estab        FORMAT "X(03)"      " "
               tt_cliente_tit_acr.v_cdn_cliente      FORMAT "ZZZZZZZZ9"  " "
               tt_cliente_tit_acr.v_nom_abrev        FORMAT "X(10)"      " "
               tt_cliente_tit_acr.cod_espec_docto    FORMAT "X(03)"      " "
               tt_cliente_tit_acr.cod_ser_docto      FORMAT "X(03)"      " "
               tt_cliente_tit_acr.cod_tit_Acr        FORMAT "X(10)"      " "
               tt_cliente_tit_acr.cod_parcela        FORMAT "X(02)"      " "
               tt_cliente_tit_acr.dat_emis_docto     FORMAT "99/99/9999" " "
               tt_cliente_tit_acr.dat_vencto_tit_acr FORMAT "99/99/9999" " "
               v_cod_operac                          FORMAT "x(10)"      " "
               v_dat_remes                           FORMAT "99/99/9999" " "
               v_dat_ret                             FORMAT "99/99/9999" " "
               tt_cliente_tit_acr.cod_portador       FORMAT "X(05)"      " "
               tt_cliente_tit_acr.cod_cart_bcia      FORMAT "X(03)"      "  "
               "   "                                 FORMAT "X(03)"      " "
               "   "          /*FORMAT ">>>>>>.>>9,99"*/ " "
               tt_cliente_tit_acr.v_obs              FORMAT "X(100)"   " " SKIP.

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
                                  "Retorno PEFIN/SERASA"        AT 64 
                                  "Pag: "                       AT 123
                                  "1"                           TO 131 SKIP
                                  FILL("-",109) FORM "x(109)"          
                                  TODAY FORM "99/99/9999"       TO 120
                                  " - "
                                  String(TIME,"HH:MM:SS")       TO 131.

  PUT STREAM s_arqrelat UNFORMATTED SKIP(1)
             "Arquivo Importado:"           AT 20
             STRING(v_cod_arq, "x(85)")     AT 40 SKIP 
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
        "Intelbras - Espec°ficos - ESACR030 - 1.00.00.000" to 131 SKIP.

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
