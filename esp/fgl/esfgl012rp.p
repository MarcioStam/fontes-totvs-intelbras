/*****************************************************************************
** Programa..............: esp/fgl/esfgl012rp.p
** Descriá∆o.............: Validaá‰es cotaá‰es
** Autor.................: Andrey M Oliveira
** Criado em.............: 25/10/2021
*****************************************************************************/
{include/i-prgvrs.i esfgl012rp 1.00.00.000}

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER NO-UNDO.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEF TEMP-TABLE tt_erros
    FIELD cod_indic_econ_base LIKE cotac_parid.cod_indic_econ_base
    FIELD cod_indic_econ_idx  LIKE cotac_parid.cod_indic_econ_idx
    FIELD ind_tip_cotac_parid LIKE cotac_parid.ind_tip_cotac_parid
    FIELD des_erro            AS CHAR FORMAT "x(200)".

def input parameter raw-param as raw no-undo.
def input parameter table     for tt-raw-digita.

{esp/es0018.i}
{utp/utapi019.i}

{include/i-rpvar.i}

DEF STREAM s_arqexport.
DEF STREAM s_arqrelat.

DEF BUFFER b_cotac_parid  FOR cotac_parid.
DEF BUFFER b_cotac_parid2 FOR cotac_parid.

DEF VAR h-acomp            AS HANDLE              NO-UNDO.
DEF VAR v_arq_erros        AS CHAR FORMAT "x(50)" NO-UNDO.
DEF VAR v_dat_ant          AS DATE                NO-UNDO.

EMPTY TEMP-TABLE tt-param.
EMPTY TEMP-TABLE tt_erros.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Inicializando...").

RUN esp/es0018p.p (INPUT "esfgl012",
                   INPUT 1,
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

FOR EACH tt-prog-ponto NO-LOCK:
    
    RUN pi-acompanhar IN h-acomp (INPUT "Validando cotaá∆o moedas ...").

    RUN pi_busca_dia_util_ant (INPUT 1, /* dia util anterior */
                               OUTPUT v_dat_ant).

    FIND FIRST cotac_parid
         WHERE cotac_parid.cod_indic_econ_base  = ENTRY(1,tt-prog-ponto.conteudo,";")
         AND   cotac_parid.cod_indic_econ_idx   = ENTRY(2,tt-prog-ponto.conteudo,";")
         AND   cotac_parid.dat_cotac_indic_econ = v_dat_ant
         AND   cotac_parid.ind_tip_cotac_parid  = ENTRY(3,tt-prog-ponto.conteudo,";") NO-LOCK NO-ERROR.

    IF  NOT AVAIL cotac_parid THEN DO:
        CREATE tt_erros.
        ASSIGN tt_erros.cod_indic_econ_base  = ENTRY(1,tt-prog-ponto.conteudo,";")
               tt_erros.cod_indic_econ_idx   = ENTRY(2,tt-prog-ponto.conteudo,";")                        
               tt_erros.ind_tip_cotac_parid  = ENTRY(3,tt-prog-ponto.conteudo,";")
               tt_erros.des_erro             = "Cotaá∆o n∆o encontrada para o dia £til anterior " + STRING(v_dat_ant) + " !".
    END.
    ELSE DO:
        IF  cotac_parid.val_cotac_indic_econ = 0 THEN DO:
            CREATE tt_erros.
            ASSIGN tt_erros.cod_indic_econ_base  = ENTRY(1,tt-prog-ponto.conteudo,";")
                   tt_erros.cod_indic_econ_idx   = ENTRY(2,tt-prog-ponto.conteudo,";")                        
                   tt_erros.ind_tip_cotac_parid  = ENTRY(3,tt-prog-ponto.conteudo,";")
                   tt_erros.des_erro             = "Cotaá∆o do dia £til anterior est† zerada " + STRING(v_dat_ant) + " !".

        END.
        ELSE DO:

            FIND FIRST b_cotac_parid
                 WHERE b_cotac_parid.cod_indic_econ_base  = ENTRY(1,tt-prog-ponto.conteudo,";")
                 AND   b_cotac_parid.cod_indic_econ_idx   = ENTRY(2,tt-prog-ponto.conteudo,";")
                 AND   b_cotac_parid.dat_cotac_indic_econ = TODAY
                 AND   b_cotac_parid.ind_tip_cotac_parid  = ENTRY(3,tt-prog-ponto.conteudo,";") NO-LOCK NO-ERROR.

            IF  AVAIL b_cotac_parid THEN DO:
                IF  b_cotac_parid.val_cotac_indic_econ <> cotac_parid.val_cotac_indic_econ THEN DO:
                    CREATE tt_erros.
                    ASSIGN tt_erros.cod_indic_econ_base  = ENTRY(1,tt-prog-ponto.conteudo,";")
                           tt_erros.cod_indic_econ_idx   = ENTRY(2,tt-prog-ponto.conteudo,";")                        
                           tt_erros.ind_tip_cotac_parid  = ENTRY(3,tt-prog-ponto.conteudo,";")
                           tt_erros.des_erro             = "Cotaá∆o de hoje diferente da cotaá∆o do dia £til anterior. Dias: " + STRING(b_cotac_parid.dat_cotac_indic_econ) 
                                                         + " e " + STRING(cotac_parid.dat_cotac_indic_econ) + " !".
                END.
                ELSE DO:
                    RUN pi_busca_dia_util_ant (INPUT 2, /* dia util anterior */
                                               OUTPUT v_dat_ant).

                    FIND FIRST b_cotac_parid2
                         WHERE b_cotac_parid2.cod_indic_econ_base  = ENTRY(1,tt-prog-ponto.conteudo,";")
                         AND   b_cotac_parid2.cod_indic_econ_idx   = ENTRY(2,tt-prog-ponto.conteudo,";")
                         AND   b_cotac_parid2.dat_cotac_indic_econ = v_dat_ant
                         AND   b_cotac_parid2.ind_tip_cotac_parid  = ENTRY(3,tt-prog-ponto.conteudo,";") NO-LOCK NO-ERROR.

                    IF  NOT AVAIL b_cotac_parid2 THEN DO:
                        CREATE tt_erros.
                        ASSIGN tt_erros.cod_indic_econ_base  = ENTRY(1,tt-prog-ponto.conteudo,";")
                               tt_erros.cod_indic_econ_idx   = ENTRY(2,tt-prog-ponto.conteudo,";")                        
                               tt_erros.ind_tip_cotac_parid  = ENTRY(3,tt-prog-ponto.conteudo,";")
                               tt_erros.des_erro             = "Cotaá∆o n∆o encontrada para o segundo dia £til anterior " + STRING(v_dat_ant) + " !".
                    END.
                    ELSE DO:
                        IF  b_cotac_parid.val_cotac_indic_econ = b_cotac_parid2.val_cotac_indic_econ THEN DO:
                            CREATE tt_erros.
                            ASSIGN tt_erros.cod_indic_econ_base  = ENTRY(1,tt-prog-ponto.conteudo,";")
                                   tt_erros.cod_indic_econ_idx   = ENTRY(2,tt-prog-ponto.conteudo,";")                        
                                   tt_erros.ind_tip_cotac_parid  = ENTRY(3,tt-prog-ponto.conteudo,";")
                                   tt_erros.des_erro             = "Cotaá‰es dos £ltimos dois dias £teis n∆o foram alteradas. Necess†rio validar a importaá∆o de cotaá‰es.".
                        END.
                    END.
                END.
            END.
            ELSE DO:
                CREATE tt_erros.
                ASSIGN tt_erros.cod_indic_econ_base  = ENTRY(1,tt-prog-ponto.conteudo,";")
                       tt_erros.cod_indic_econ_idx   = ENTRY(2,tt-prog-ponto.conteudo,";")                        
                       tt_erros.ind_tip_cotac_parid  = ENTRY(3,tt-prog-ponto.conteudo,";")
                       tt_erros.des_erro             = "Cotaá∆o n∆o localizada para o dia " + STRING(TODAY) + " !".
            END.
        END.
    END.
END.

IF  OPSYS = "UNIX" THEN
    ASSIGN v_arq_erros = "/mnt/spool/" + v_cod_usuar_corren + "/esfgl012-" + STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(YEAR(TODAY)) + ".txt".
ELSE
    ASSIGN v_arq_erros = "\\erpapp\spool\" + v_cod_usuar_corren + "\esfgl012-" + STRING(DAY(TODAY)) + STRING(MONTH(TODAY)) + STRING(YEAR(TODAY)) + ".txt".


OUTPUT TO VALUE(v_arq_erros).

IF CAN-FIND(FIRST tt_erros) THEN
    PUT "Moeda Base;Moeda ÷ndice;Erro" SKIP.

FOR EACH tt_erros:

    PUT tt_erros.cod_indic_econ_base ";"
        tt_erros.cod_indic_econ_idx  ";"
        tt_erros.des_erro SKIP.

    /*
    DISP tt_erros.cod_indic_econ_base COLUMN-LABEL "Moeda Base"
         tt_erros.cod_indic_econ_idx  COLUMN-LABEL "Moeda ÷ndice"
         tt_erros.des_erro            COLUMN-LABEL "Erro" 
         WITH DOWN FRAME f_erros.

    DOWN WITH WIDTH 100 FRAME f_erros.
    */
END.
OUTPUT CLOSE.

{include/i-rpout.i}

IF CAN-FIND(FIRST tt_erros) THEN
    PUT "Moeda Base;Moeda ÷ndice;Erro" SKIP.

FOR EACH tt_erros:

    PUT tt_erros.cod_indic_econ_base ";"
        tt_erros.cod_indic_econ_idx  ";"
        tt_erros.des_erro SKIP.

    /*
    DISP tt_erros.cod_indic_econ_base COLUMN-LABEL "Moeda Base"
         tt_erros.cod_indic_econ_idx  COLUMN-LABEL "Moeda ÷ndice"
         tt_erros.des_erro            COLUMN-LABEL "Erro" 
         WITH DOWN FRAME f_erros2.

    DOWN WITH WIDTH 100 FRAME f_erros2.
    */
END.

{include/i-rpclo.i}

IF  CAN-FIND(FIRST tt_erros) THEN
    RUN pi-envia-email.

RUN pi-finalizar IN h-acomp.

RETURN "OK".


PROCEDURE pi-envia-email:

    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.
    DEFINE VARIABLE diferenca   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-email     AS CHAR        NO-UNDO.
    DEFINE VARIABLE h-utapi019  AS HANDLE      NO-UNDO.

    RUN pi-acompanhar IN h-acomp (INPUT "Enviando Email ...").

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    ASSIGN c-email = "".

    /* BUSCA OS DESTINATµRIOS DE EMAIL NO ES0018 */
    FIND FIRST ponto-programa NO-LOCK                                                  
      WHERE ponto-programa.nome-programa = "esfgl012"
        AND ponto-programa.ponto         = 2 NO-ERROR.                               
                                                                                     
    IF  AVAIL ponto-programa THEN DO:
        FOR EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

            IF  c-email = "" THEN
                ASSIGN c-email = conteudo-programa.conteudo.
            ELSE
                ASSIGN c-email = c-email + ";" + conteudo-programa.conteudo.
        END.
    END.
    ELSE 
        ASSIGN c-email = "" .

    EMPTY TEMP-TABLE tt-envio2.   
    EMPTY TEMP-TABLE tt-mensagem.
    EMPTY TEMP-TABLE tt-erros.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.destino           = REPLACE (replace(c-email, "BCC",""), " ", "")
           tt-envio2.remetente         = "ems@intelbras.com.br"
           tt-envio2.copia             = ""
           tt-envio2.assunto           = "Validaá∆o de cotaá‰es - Data: " + string(TODAY,"99/99/9999")
           tt-envio2.arq-anexo         = v_arq_erros
           tt-envio2.formato           = "TEXTO".

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "Prezado(a)," + chr(13) + chr(13) + "Segue anexo contendo o log de execuá∆o do programa ESFGL012, com os erros relacionados as cotaá‰es nesta data." + chr(13) + chr(13) + "Atenciosamente." .
   
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    /* TRATAMENTO DE ERROS NO ENVIO DO EMAIL */
    DEF VAR i-seq AS INTEGER NO-UNDO.

    IF  CAN-FIND(FIRST tt-erros) THEN DO:
        PUT skip(2) " ATENÄ«O, erro envio email ..." SKIP
                    "tt-envio2.destino.: " tt-envio2.destino FORMAT "x(1000)" SKIP.
    END.

    FOR EACH tt-erros:
        IF  i-seq = 0 THEN
            PUT skip(2) " ATENÄ«O, existe(m) erro(s) no processo de envio de email...(tt-erros)" SKIP(1).

        ASSIGN i-seq = i-seq + 1.

        PUT "Sequància Erro: " STRING(i-seq, "99") SKIP
            "Cd Erro..: " STRING(tt-erros.cod-erro) " - " tt-erros.desc-erro SKIP.
    END.

    ASSIGN i-seq = 0.
    
    IF  VALID-HANDLE(h-utapi019) THEN 
        DELETE PROCEDURE h-utapi019.

    ASSIGN h-utapi019 = ?.
END.

PROCEDURE pi_busca_dia_util_ant:
    
    DEF INPUT  PARAM p_num_dias     AS INT  NO-UNDO.
    DEF OUTPUT PARAM p_dat_util_ant AS DATE NO-UNDO.

    DEF VAR v_cont AS INT  NO-UNDO.

    ASSIGN v_cont         = 0
           p_dat_util_ant = TODAY.

    REPEAT WHILE v_cont < p_num_dias:

        ASSIGN p_dat_util_ant = p_dat_util_ant - 1.

        FIND FIRST dia_calend_glob
            WHERE dia_calend_glob.cod_calend = "Fiscal":U
            AND   dia_calend_glob.dat_calend = p_dat_util_ant NO-LOCK NO-ERROR.

        IF  dia_calend_glob.log_dia_util THEN
            ASSIGN v_cont = v_cont + 1.
        ELSE
            NEXT.
    END.

END.
