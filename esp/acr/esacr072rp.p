/*-----------------------------------------------------------------------------------------------------------------------*/
/*                                                                                                                       */
/*   OBJETIVO..........:  ALTERAR A DATA DE FLUXO DOS TÖTULDO DO CONTAS A PAGAR, CONFORME PARAMETRIZA€ÇO DE DIAS FLOAT   */
/*                                                                                                                       */
/*   DESENVOLVIDO POR..: ROGER MARCELINO BRUHN                                                                           */
/*                                                                                                                       */
/*-----------------------------------------------------------------------------------------------------------------------*/

{include/i-prgvrs.i esacr072rp 2.00.00.001}  

{include/i-rpvar.i}
{utp/utapi019.i} /* Temp-table para envio de e-mail */ 
{esp\acr\esacr071.i}

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario      AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-acomp            AS HANDLE     NO-UNDO.
DEFINE VARIABLE v_cod_finalid_econ AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-erro             AS LOG        NO-UNDO.
DEFINE VARIABLE l-ok               AS LOG        NO-UNDO.
DEFINE VARIABLE c-arquivo-anexo    AS CHAR       NO-UNDO.
DEFINE VARIABLE v_cod_return       AS CHARACTER   NO-UNDO.

FUNCTION fn_ultimo_dia_util_mes RETURNS LOG
  ( INPUT p-data AS DATE /* parameter-definitions */ )  FORWARD.

DEF STREAM s-arq.

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

DEFINE TEMP-TABLE tt-param NO-UNDO                            
    FIELD destino                     AS INTEGER              
    FIELD arquivo                     AS CHAR FORMAT "x(35)"
    FIELD usuario                     AS CHAR FORMAT "x(12)"
    FIELD data-exec                   AS DATE
    FIELD hora-exec                   AS INTEGER
    FIELD classifica                  AS INTEGER
    FIELD desc-classifica             AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf                  AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf               AS LOG
    FIELD tg-efetiva                  AS LOG.

DEFINE TEMP-TABLE tt-titulo
    FIELD cdn_cliente               LIKE tit_acr.cdn_cliente  
    FIELD cod_estab                 AS CHAR FORMAT "x(5)"      COLUMN-LABEL "Est"       
    FIELD cod_espec_docto           AS CHAR FORMAT "x(3)" COLUMN-LABEL "Esp"
    FIELD cod_ser_docto             AS CHAR FORMAT "x(5)" COLUMN-LABEL "Ser"
    FIELD cod_tit_acr               LIKE tit_acr.cod_tit_acr             
    FIELD cod_parcela               AS CHAR FORMAT "x(2)"  COLUMN-LABEL "Par"           
    FIELD num_id_tit_acr            LIKE tit_acr.num_id_tit_acr
    FIELD cod_portador              LIKE tit_acr.cod_portador
    FIELD cod_cart_bcia             LIKE tit_acr.cod_cart_bcia
    FIELD dias-float                AS CHAR
    FIELD dat_vencto_tit_acr        LIKE tit_acr.dat_vencto_tit_acr
    FIELD dat_prev_liquidac         LIKE tit_acr.dat_prev_liquidac
    FIELD dat_prev_liquidac_NEW     LIKE tit_acr.dat_prev_liquidac
    FIELD dat_fluxo_tit_acr         LIKE tit_acr.dat_fluxo_tit_acr
    FIELD dat_fluxo_tit_acr_new     LIKE tit_acr.dat_fluxo_tit_acr.


DEFINE TEMP-TABLE tt-portador
    FIELD codigo   AS CHAR FORMAT "x(5)"
    FIELD nome     AS CHAR FORMAT "x(40)"
    FIELD carteira AS CHAR FORMAT "x(3)".

DEFINE TEMP-TABLE tt-mensagens NO-UNDO
    FIELD num-transac    LIKE int-pagtos-supcard-ocor.num-transac
    FIELD cod-estab      LIKE tit_acr.cod_estab
    FIELD num-id-tit-acr LIKE tit_acr.num_id_tit_acr
    FIELD des-erro       AS CHARACTER FORMAT "x(150)"
    FIELD l-erro         AS LOGICAL.

DEFINE TEMP-TABLE tt-raw-digita
   FIELD raw-digita AS RAW.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{include/i-rpout.i}
{esp\acr\acr711zo.i}


/* CRIAR A TT-TITULO */
RUN pi-principal.

IF  tt-param.tg-efetiva THEN
    RUN pi-Altera-Titulo. 

FOR EACH tt_log_erros_alter_tit_acr:
    CREATE tt-mensagens.
    ASSIGN tt-mensagens.num-transac    = ""
           tt-mensagens.cod-estab      = tt_log_erros_alter_tit_acr.tta_cod_estab
           tt-mensagens.num-id-tit-acr = tt_log_erros_alter_tit_acr.tta_num_id_tit_acr
           tt-mensagens.des-erro       = tt_log_erros_alter_tit_acr.ttv_des_msg_erro + " -> " + tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda
           tt-mensagens.l-erro         = YES
           l-erro                      = YES.
END.

/* GERA ARQUIVO COM O RESULTADO DO PROCESSAMENTO */
RUN pi-resultado-processo.

/*ENVIAR EMIAL COM O RESULTADO DA OPERA€ÇO */
RUN pi-envia-email.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.


{include/i-rpclo.i}

RETURN "OK".


PROCEDURE pi-resultado-processo :

    DEF VAR l-cabecalho     AS LOG  NO-UNDO.
    DEF VAR l-com-sucesso   AS LOG  NO-UNDO.
    DEF VAR l-com-erro      AS LOG  NO-UNDO.
    DEF VAR c-tipo          AS CHAR FORMAT "x(20)" NO-UNDO.
    
    IF  tt-param.tg-efetiva THEN
        c-tipo = "OFICIAL".
    ELSE
        c-tipo = "SIMULA€ÇO".

    IF  OPSYS = "UNIX" THEN
        ASSIGN c-arquivo-anexo = SESSION:TEMP-DIR + "/" +  c-seg-usuario + "/" + 'esacr072_result_' + STRING(DAY(TODAY)) 
                                 + '_' + STRING(MONTH(TODAY)) + '_' + STRING(YEAR(TODAY)) 
                                 + STRING(TIME) + '.txt'.
    ELSE
        ASSIGN c-arquivo-anexo = SESSION:TEMP-DIR + 'esacr072_result_' + STRING(DAY(TODAY)) 
                                 + '_' + STRING(MONTH(TODAY)) + '_' + STRING(YEAR(TODAY)) 
                                 + STRING(TIME) + '.txt'.

    OUTPUT STREAM s-arq TO VALUE( c-arquivo-anexo ) CONVERT TARGET 'ISO8859-1'.

    PUT STREAM s-arq "------------------------------------------------------------------------------------------------------------------------------------" SKIP(2).
    PUT STREAM s-arq "                                         ESACR072 - Altera‡Æo Data Prev. Liq e Data de Fluxo T¡tulos" SKIP(2).
    PUT STREAM s-arq "                                                              R E S U L T A D O                                                     " SKIP(2).
    PUT STREAM s-arq UNFORMATTED "                                                 Execu‡Æo: " c-tipo                                                       SKIP(2).
    PUT STREAM s-arq "                                         Processamento em: " STRING(TODAY, "99/99/9999") " …s " STRING(TIME, "HH:MM:SS") SKIP(2).
    PUT STREAM s-arq "------------------------------------------------------------------------------------------------------------------------------------" SKIP(2).

    FOR EACH tt-titulo NO-LOCK:
         IF  CAN-FIND (FIRST tt_log_erros_alter_tit_acr
                        WHERE tt_log_erros_alter_tit_acr.tta_cod_estab       = tt-titulo.cod_estab
                          AND tt_log_erros_alter_tit_acr.tta_num_id_tit_acr  = tt-titulo.num_id_tit_acr ) THEN
             NEXT.

         IF  NOT l-cabecalho THEN DO:
             PUT STREAM s-arq "                                            < TÖTULOS ALTERADOS COM SUCESSO >" SKIP.
             PUT STREAM s-arq "                                            ---------------------------------" SKIP(2).
             PUT STREAM s-arq "Estab  Esp‚cie  S‚rie  T¡tulo      Parcela  Portador  Carteira  Vencimento  PREV LIQUID. ANTERIOR  PREV LIQ. ATUAL  Dias Float   DT FLUXO ANTERIOR  DT FLUXO ATUAL" SKIP
                              "-----  -------  -----  ----------  -------  --------  --------  ----------  ---------------------  ---------------  -----------  -----------------  --------------" SKIP.
             l-cabecalho = YES.                                                                                                          
         END.
         
         PUT STREAM s-arq tt-titulo.cod_estab
                      tt-titulo.cod_espec_docto        AT 08
                      tt-titulo.cod_ser_docto          AT 17
                      tt-titulo.cod_tit_acr            AT 24
                      tt-titulo.cod_parcela            AT 36
                      tt-titulo.cod_portador           AT 45
                      tt-titulo.cod_cart_bcia          AT 55
                      tt-titulo.dat_vencto_tit_acr     AT 65
                      tt-titulo.dat_prev_liquidac      AT 77
                      tt-titulo.dat_prev_liquidac_NEW  AT 100
                      tt-titulo.dias-float             AT 117
                      tt-titulo.dat_fluxo_tit_acr      AT 130
                      tt-titulo.dat_fluxo_tit_acr_NEW  AT 149 SKIP.
         
         ASSIGN l-com-sucesso = YES.
    END.

    /* COM ERRORS */
    IF  l-cabecalho THEN DO:
        ASSIGN l-cabecalho = NO.
        PUT STREAM s-arq SKIP(2).
    END.

    FOR EACH tt-titulo:

         FIND tt_log_erros_alter_tit_acr
            WHERE tt_log_erros_alter_tit_acr.tta_cod_estab       = tt-titulo.cod_estab
              AND tt_log_erros_alter_tit_acr.tta_num_id_tit_acr  = tt-titulo.num_id_tit_acr NO-ERROR.
         
         IF  NOT AVAIL tt_log_erros_alter_tit_acr THEN
             NEXT.
                          
         IF  NOT l-cabecalho THEN DO:
             PUT STREAM s-arq "                                            < TÖTULOS COM ERRO >" SKIP.
             PUT STREAM s-arq "                                            --------------------" SKIP(2).

             PUT STREAM s-arq "Estab  Esp‚cie  S‚rie  T¡tulo     Parcela  Num Erro Descri‡Æo" SKIP
                          "-----  -------  -----  ---------- -------  -------- -----------------------------------------------------------" SKIP.
             l-cabecalho = YES.
         END.
        
         PUT STREAM s-arq tt-titulo.cod_estab
                      tt-titulo.cod_espec_docto                      AT 08
                      tt-titulo.cod_ser_docto                        AT 17
                      tt-titulo.cod_tit_acr                          AT 24
                      tt-titulo.cod_parcela                          AT 35
                      tt_log_erros_alter_tit_acr.ttv_num_mensagem    AT 42
                      tt_log_erros_alter_tit_acr.ttv_des_msg_erro    AT 53 SKIP
                      tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda   AT 53 SKIP(2).
         ASSIGN l-com-erro = YES.
    END.

    IF  NOT l-com-sucesso AND NOT l-com-erro THEN
        PUT STREAM s-arq skip(2) "    OBS:  Nenhum t¡tulo precisou sofrer altera‡Æo de Data de Fluxo.".

    OUTPUT STREAM s-arq CLOSE.

END PROCEDURE.

PROCEDURE pi-envia-email:

    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.
    DEFINE VARIABLE diferenca   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-email     AS CHAR        NO-UNDO.
    DEFINE VARIABLE h-utapi019  AS HANDLE      NO-UNDO.

    RUN pi-acompanhar IN h-acomp (INPUT "Enviando Email Cliente.. ").

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    ASSIGN c-email = "".

    /* BUSCA OS DESTINATµRIOS DE EMAIL NO ES0018 */
    FIND FIRST ponto-programa NO-LOCK                                                  
      WHERE ponto-programa.nome-programa = "esacr072"                                
        AND ponto-programa.ponto         = 1 NO-ERROR.                               
                                                                                     
    IF  AVAIL ponto-programa THEN
        FOR EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            ASSIGN c-email = c-email + conteudo-programa.conteudo + ";".
        END.
    ELSE 
        ASSIGN c-email = "" .

    EMPTY TEMP-TABLE tt-envio2.   
    EMPTY TEMP-TABLE tt-mensagem.
    EMPTY TEMP-TABLE tt-erros.

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:
    END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.destino           = REPLACE (replace(c-email, "BCC",""), " ", "")
           tt-envio2.remetente         = "ems@intelbras.com.br"
           tt-envio2.copia             = ""
           tt-envio2.assunto           = "Log Altera‡Æo Data de Fluxo Contas … Receber"
           tt-envio2.arq-anexo         = c-arquivo-anexo
           tt-envio2.formato           = "TEXTO".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "Anexo log da execu‡Æo do programa esacr072 - Altera‡Æo Data de Fluxo dos T¡tuloS do Contas … Receber.".
   
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    /* TRATAMENTO DE ERROS NO ENVIO DO EMAIL */
    DEF VAR i-seq AS INTEGER NO-UNDO.

    IF  CAN-FIND(FIRST tt-erros) THEN DO:
        PUT skip(2) " ATEN€ÇO, erro envio emai para o cliente...." SKIP
                    "tt-envio2.destino.: " tt-envio2.destino FORMAT "x(1000)" SKIP.
    END.

    FOR EACH tt-erros:
        IF  i-seq = 0 THEN
            PUT skip(2) " ATEN€ÇO, existe(m) erro(s) no processo de envio de email...(tt-erros)" SKIP(1).

        ASSIGN i-seq = i-seq + 1.

        PUT "Sequˆncia Erro: " STRING(i-seq, "99") SKIP
            "Cd Erro..: " STRING(tt-erros.cod-erro) " - " tt-erros.desc-erro SKIP.
    END.

    ASSIGN i-seq = 0.
    
    IF  VALID-HANDLE(h-utapi019) 
    THEN 
        DELETE PROCEDURE h-utapi019.

    ASSIGN h-utapi019 = ?.

END.

PROCEDURE pi-principal:

    DEF VAR i-tipo-benef        AS INTEGER   NO-UNDO.
    DEF VAR i-canal             AS INTEGER   NO-UNDO.
    DEF VAR c-forma-pagto       AS CHAR      NO-UNDO.
    DEF VAR de-vl-aprovado      AS DEC       NO-UNDO.
    DEF VAR l-tipo              AS LOG       NO-UNDO.
    DEF VAR l-enviada           AS LOG       NO-UNDO.
    DEF VAR da-vencto-calculado AS DATE      NO-UNDO.
    DEF VAR l-todos             AS LOG       INIT YES NO-UNDO.
    DEF VAR i-emitente          AS INTEGER   NO-UNDO.
    DEF VAR da-prev-liquid      AS DATE      NO-UNDO.
    DEF VAR da-fluxo            AS DATE      NO-UNDO.
    DEF VAR l-ultimo-dia-mes    AS LOG       NO-UNDO.
    
    RUN pi-inicializar IN h-acomp (INPUT "Selecionando T¡tulos...").

    EMPTY TEMP-TABLE  tt_alter_tit_acr_base_2. 


    FIND FIRST ponto-programa NO-LOCK                                                  
        WHERE ponto-programa.nome-programa = "esacr071"                                
          AND ponto-programa.ponto         = 1 NO-ERROR.                               

    IF  AVAIL ponto-programa THEN DO:
        FOR EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

            FIND emscad.portador NO-LOCK
                WHERE emscad.portador.cod_portador = entry(1,conteudo-programa.conteudo, ";") NO-ERROR.

            IF  AVAIL emscad.portador THEN DO:
                CREATE tt-portador.
                ASSIGN tt-portador.codigo   = entry(1,conteudo-programa.conteudo, ";")
                       tt-portador.nome     = IF AVAIL portador THEN portador.nom_pessoa ELSE ""
                       tt-portador.carteira = ENTRY(2,conteudo-programa.conteudo, ";").
            END.

        END.

    END.
    
    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar:

        FOR EACH tit_acr NO-LOCK
           WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
             AND tit_acr.ind_tip_cobr_acr    = "Normal"
             AND tit_acr.ind_tip_espec_docto = "Normal"
             AND tit_acr.log_tit_acr_estordo = NO
             AND tit_acr.log_sdo_tit_acr
             AND tit_acr.dat_prev_liquidac >= TODAY
            ,FIRST emscad.cliente NO-LOCK                                  
               WHERE emscad.cliente.cod_empresa = tit_acr.cod_empresa
                 AND emscad.cliente.cdn_cliente = tit_acr.cdn_cliente:

            RUN pi_retornar_dia_util (INPUT cliente.cod_pais,
                                      INPUT tit_acr.cod_estab,
                                      INPUT "Respons vel Financeiro",
                                      INPUT 0,
                                      INPUT tit_acr.dat_vencto_tit_acr,
                                      OUTPUT da-prev-liquid,
                                      OUTPUT v_cod_return).

            /* EXISTEM EXCE€åES FLOAT INFORMADAS */
            FIND tt-portador
                WHERE tt-portador.codigo   = tit_acr.cod_portador
                  AND tt-portador.carteira = tit_acr.cod_cart_bcia NO-ERROR.

            ASSIGN da-fluxo = da-prev-liquid.

            /* VERIFICA SE CAIU NO éLTIMO DIA DO MÒS E POSSUI EXCE€ÇO FLOAT CADASTRADA */
            ASSIGN l-ultimo-dia-mes = NO.
            IF  fn_ultimo_dia_util_mes (da-prev-liquid) AND AVAIL tt-portador THEN 
                ASSIGN l-ultimo-dia-mes = YES.

            IF  NOT l-ultimo-dia-mes THEN DO:
                run pi_retornar_finalid_indic_econ (INPUT tit_acr.cod_indic_econ,
                                                    INPUT tit_acr.dat_prev_liquidac,
                                                    OUTPUT v_cod_finalid_econ).
                FIND portad_bco NO-LOCK
                    WHERE portad_bco.cod_modul_dtsul   = "ACR"
                      AND portad_bco.cod_estab         = tit_acr.cod_estab
                      AND portad_bco.cod_portador      = tit_acr.cod_portador
                      AND portad_bco.cod_cart_bcia     = tit_acr.cod_cart_bcia
                      and portad_bco.cod_finalid_econ  = v_cod_finalid_econ NO-ERROR.

                IF  AVAIL portad_bco THEN DO:        
                    IF  portad_bco.qtd_dias_float_cobr > 0 THEN DO:
                         RUN prgfin/acr/acr792za.py (INPUT tit_acr.cod_estab,
                                                     INPUT-OUTPUT da-fluxo,
                                                     INPUT portad_bco.qtd_dias_float_cobr).
                    END.
                 END.
            END.

            /* CASP A DATA DE FLUXO CALCULADA TENHA SIDO MODIFICADA */
            IF  da-fluxo       <> tit_acr.dat_fluxo_tit_acr 
            OR  da-prev-liquid <> tit_acr.dat_prev_liquidac THEN DO:

                CREATE tt-titulo.
                ASSIGN tt-titulo.cdn_cliente            = tit_acr.cdn_cliente          
                       tt-titulo.cod_estab              = tit_acr.cod_estab            
                       tt-titulo.cod_espec_docto        = tit_acr.cod_espec_docto      
                       tt-titulo.cod_ser_docto          = tit_acr.cod_ser_docto        
                       tt-titulo.cod_tit_acr            = tit_acr.cod_tit_acr          
                       tt-titulo.cod_parcela            = tit_acr.cod_parcela          
                       tt-titulo.num_id_tit_acr         = tit_acr.num_id_tit_acr    
                       tt-titulo.cod_portador           = tit_acr.cod_portador
                       tt-titulo.cod_cart_bcia          = tit_acr.cod_cart_bcia
                       tt-titulo.dias-float             = IF AVAIL portad_bco THEN STRING(portad_bco.qtd_dias_float_cobr, "99") ELSE ""
                       tt-titulo.dat_vencto_tit_acr     = tit_acr.dat_vencto_tit_acr
                       tt-titulo.dat_prev_liquidac      = tit_acr.dat_prev_liquidac
                       tt-titulo.dat_prev_liquidac_new  = da-prev-liquid
                       tt-titulo.dat_fluxo_tit_acr      = tit_acr.dat_fluxo_tit_acr 
                       tt-titulo.dat_fluxo_tit_acr_new  = da-fluxo.

                RUN pi-cria-temp-table-alt-titulo.

            END.

        END.
    END.
END.


PROCEDURE pi_retornar_finalid_indic_econ :
    def Input param p_cod_indic_econ    as CHARACTER format "x(8)"       no-undo.
    def Input param p_dat_transacao     as DATE      format "99/99/9999" no-undo.
    def output param p_cod_finalid_econ as CHARACTER format "x(10)"      no-undo.

     find first histor_finalid_econ no-lock
        where histor_finalid_econ.cod_indic_econ          = p_cod_indic_econ
        and   histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
        and   histor_finalid_econ.dat_fim_valid_finalid  > p_dat_transacao no-error.

        if avail histor_finalid_econ then
           assign p_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.
    RETURN "OK".
END PROCEDURE.



PROCEDURE pi-Altera-Titulo :

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


    RETURN "OK".
END PROCEDURE.


PROCEDURE pi-cria-temp-table-alt-titulo :

    DEFINE VARIABLE v_num_aux_2      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_num_cont       AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_num_aux        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_cod_refer_impl AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-historico      AS CHAR       NO-UNDO.

    /*Calcula referencia automatica*/
    REPEAT:       
      ASSIGN v_num_aux_2 = INTEGER(this-procedure:HANDLE).
             v_cod_refer_impl = 'PR' + SUBSTR(STRING(YEAR (TODAY), '9999'), 3,2)
                                     + STRING(MONTH(TODAY), '99').
      do v_num_cont = 1 to 3:
        assign v_num_aux   = (RANDOM(0,v_num_aux_2) MOD 26) + 97
               v_cod_refer_impl = v_cod_refer_impl + CHR(v_num_aux).
      end.

      FIND FIRST  movto_tit_acr 
           WHERE  movto_tit_acr.cod_estab   = tit_acr.cod_estab
             AND  movto_tit_acr.cod_refer = v_cod_refer_impl NO-LOCK  NO-ERROR .
      IF  NOT AVAIL movto_tit_acr THEN DO:
          FIND tt_alter_tit_acr_base_2
              WHERE tt_alter_tit_acr_base_2.tta_cod_refer = v_cod_refer_impl NO-ERROR.

          IF  NOT AVAIL tt_alter_tit_acr_base_2 THEN
              LEAVE.
      END.

    END.

    c-historico = "Altera‡Æo Data de Fluxo atrav‚s do programa esacr072." +
                  "Data de fluxo alterada de " + STRING(tit_acr.dat_fluxo_tit_acr) + 
                  " Para: " + STRING(tt-titulo.dat_fluxo_tit_acr_new) + ", pelo usu rio: " + c-seg-usuario. 

    CREATE tt_alter_tit_acr_base_2.
    ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = tit_acr.cod_estab                     
           tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr

           tt_alter_tit_acr_base_2.tta_dat_transacao               = TODAY /*tit_acr.dat_transacao*/
           tt_alter_tit_acr_base_2.tta_cod_refer                   = v_cod_refer_impl
           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ?
           tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = ? /*tit_acr.val_sdo_tit_acr*/
           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = ?
           tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = ?
           tt_alter_tit_acr_base_2.tta_cod_portador                = ? /*tit_acr.cod_portador                   */
           tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = ? /*tit_acr.cod_cart_bcia                  */
           tt_alter_tit_acr_base_2.tta_val_despes_bcia             = ? /*tit_acr.val_despes_bcia                */
           tt_alter_tit_acr_base_2.tta_cod_agenc_cobr_bcia         = ? /*tit_acr.cod_agenc_cobr_bcia            */
           tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ? /*tit_acr.cod_tit_acr_bco                */
           tt_alter_tit_acr_base_2.tta_dat_emis_docto              = ? /*tit_acr.dat_emis_docto                 */
           tt_alter_tit_acr_base_2.tta_dat_vencto_tit_acr          = tit_acr.dat_vencto_tit_acr
           tt_alter_tit_acr_base_2.tta_dat_prev_liquidac           = tt-titulo.dat_prev_liquidac_new
           tt_alter_tit_acr_base_2.tta_dat_fluxo_tit_acr           = tt-titulo.dat_fluxo_tit_acr_new
           tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr             = ? /*tit_acr.ind_sit_tit_acr                */
           tt_alter_tit_acr_base_2.tta_cod_cond_cobr               = ? /*tit_acr.cod_cond_cobr                  */
           tt_alter_tit_acr_base_2.tta_log_tip_cr_perda_dedut_tit  = ? /*tit_acr.log_tip_cr_perda_dedut_tit     */
           tt_alter_tit_acr_base_2.tta_dat_abat_tit_acr            = ? /*tit_acr.dat_abat_tit_acr               */
           tt_alter_tit_acr_base_2.tta_val_perc_abat_acr           = ? /*tit_acr.val_perc_abat_acr              */
           tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = ? /*tit_acr.val_abat_tit_acr               */
           tt_alter_tit_acr_base_2.tta_dat_desconto                = ? /*tit_acr.dat_desconto                   */
           tt_alter_tit_acr_base_2.tta_val_perc_desc               = ? /*tit_acr.val_perc_desc                  */
           tt_alter_tit_acr_base_2.tta_val_desc_tit_acr            = ? /*tit_acr.val_desc_tit_acr               */
           tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_juros_acr   = ? /*tit_acr.qtd_dias_carenc_juros_acr      */
           tt_alter_tit_acr_base_2.tta_val_perc_juros_dia_atraso   = ? /*tit_acr.val_perc_juros_dia_atraso      */
           tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_multa_acr   = ? /*tit_acr.qtd_dias_carenc_multa_acr      */
           tt_alter_tit_acr_base_2.tta_val_perc_multa_atraso       = ? /*tit_acr.val_perc_multa_atraso          */
           tt_alter_tit_acr_base_2.ttv_cod_portador_mov            = ?                                        
           tt_alter_tit_acr_base_2.tta_ind_tip_cobr_acr            = ? /*tit_acr.ind_tip_cobr_acr               */
           tt_alter_tit_acr_base_2.tta_ind_ender_cobr              = ? /*tit_acr.ind_ender_cobr                 */
           tt_alter_tit_acr_base_2.tta_nom_abrev_contat            = ? /*tit_acr.nom_abrev_contat               */
           tt_alter_tit_acr_base_2.tta_val_liq_tit_acr             = ? /*tit_acr.val_liq_tit_acr                */
           tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_1_movto    = ?                                         
           tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_2_movto    = ?                                        
           tt_alter_tit_acr_base_2.tta_log_tit_acr_destndo         = ? /*tit_acr.log_tit_acr_destndo            */
           tt_alter_tit_acr_base_2.tta_cod_histor_padr             = ?                                        
           tt_alter_tit_acr_base_2.ttv_des_text_histor             = c-historico
           tt_alter_tit_acr_base_2.tta_des_obs_cobr                = ? /*tit_acr.des_obs_cobr                     */
           tt_alter_tit_acr_base_2.tta_num_seq_tit_acr             = ? /*tit_acr.num_seq_tit_acr*/              
           tt_alter_tit_acr_base_2.ttv_cod_estab_planilha          = ? /*tit_acr.cod_estab */
           tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ? 
           tt_alter_tit_acr_base_2.tta_cod_portador                = ?
           tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = ?.
                                                                                                                    
END PROCEDURE.

FUNCTION fn_ultimo_dia_util_mes RETURNS LOG
  ( INPUT p-data AS DATE /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEF VAR da-proxima AS DATE NO-UNDO.
   DEF VAR da-nova    AS DATE NO-UNDO.
   
   ASSIGN da-proxima = p-data + 1.
   IF  MONTH(p-data) <> MONTH(da-proxima) THEN
       RETURN YES.
   ELSE DO:
        RUN pi_retornar_dia_util (INPUT emscad.cliente.cod_pais,
                                  INPUT tit_acr.cod_estab,
                                  INPUT "Respons vel Financeiro",
                                  INPUT 0,
                                  INPUT da-proxima,
                                  OUTPUT da-nova,
                                  OUTPUT v_cod_return).
       IF  MONTH(da-proxima) <> MONTH(da-nova) THEN
           RETURN YES.

   END.
   
   RETURN NO.   /* Function return value. */

END FUNCTION.
