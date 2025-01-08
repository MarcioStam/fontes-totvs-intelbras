/*********************************************************************************
** Programa: esp/acr/esacr050rpa.p
** VersÆo..: 1.01
** Data....: 05/03/2012
** Autor...: Estevan Krger - Exponencial TI
** Obs.....: Programa para buscar os dados que serÆo impressos.
*********************************************************************************/

/*--- Defini‡Æo das Vari veis Locais ---*/
DEFINE VARIABLE c-transacao     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-cond-pag AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-fin-econ  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-num-parcelas  AS INTEGER     NO-UNDO.




/*--- Defini‡Æo de Temp-Tables e Buffers ---*/
DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD cod-emitente  LIKE emitente.cod-emitente
    FIELD nome-abrev    LIKE emitente.nome-abrev
    FIELD cod-estabel   LIKE int-nfs-supcard.cod-estabel
    FIELD serie         LIKE int-nfs-supcard.serie
    FIELD nr-nota-fis   LIKE int-nfs-supcard.nr-nota-fis
    FIELD cod_cart_bcia LIKE tit_acr.cod_cart_bcia
    FIELD dt-emis-nota  LIKE nota-fiscal.dt-emis-nota
    FIELD dat-movto     LIKE int-nfs-supcard.dat-movto
    FIELD val-faturado  LIKE int-nfs-supcard.val-faturado
    FIELD cod-cond-pag  LIKE nota-fiscal.cod-cond-pag
    FIELD desc-cond-pag LIKE cond-pagto.descricao
    FIELD num-parcelas  LIKE cond-pagto.num-parcelas
    FIELD unid-negoc    AS CHARACTER
    FIELD vl-unid-negoc LIKE int-nfs-supcard.val-faturado
    FIELD dt-trans      AS DATE
    FIELD vl-taxa       AS DECIMAL FORMAT "->>>,>>>,>>9.99":U
    FIELD vl-outras     AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELD c-canc-devol  AS CHARACTER FORMAT "x(15)"
    FIELD vl-devol      AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD cod-classe    LIKE int-emitente-supcard.cod-classe
    FIELD val-limite    LIKE int-emitente-supcard.val-limite
    FIELD dt-prorrog    LIKE int-pendencias-supcard.dat-envio
    FIELD dt-cancel     LIKE int-pendencias-supcard.dat-envio
    FIELD dt-envio      LIKE int-pendencias-supcard.dat-envio
    INDEX idx-nota      cod-estabel serie nr-nota-fis
    INDEX idx-data      dat-movto.

DEFINE BUFFER bf-tit_acr FOR tit_acr.

/*--- Defini‡Æo dos Parƒmetros de Entrada ---*/
DEFINE INPUT  PARAMETER pDataInicial AS DATE        NO-UNDO.
DEFINE INPUT  PARAMETER pDataFinal   AS DATE        NO-UNDO.
DEFINE INPUT  PARAMETER p-acomp      AS HANDLE      NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-dados.




/*--- Bloco Principal ---*/
IF VALID-HANDLE(p-acomp) THEN
    RUN pi-seta-titulo IN p-acomp (INPUT "Buscando Dados").


FOR EACH  int-nfs-supcard NO-LOCK
    WHERE int-nfs-supcard.dat-movto >= pDataInicial
    AND   int-nfs-supcard.dat-movto <= pDataFinal
    BREAK BY MONTH(int-nfs-supcard.dat-movto)
          BY YEAR(int-nfs-supcard.dat-movto)
          BY int-nfs-supcard.dat-movto:

    ASSIGN c-transacao = STRING(INT(int-nfs-supcard.cod-estabel), "9999") + STRING(INT(int-nfs-supcard.serie), "999") + STRING(INT(int-nfs-supcard.nr-nota-fis), "9999999").

    IF VALID-HANDLE(p-acomp) THEN
        RUN pi-acompanhar IN p-acomp (INPUT "Transa‡Æo: ":U + c-transacao).

    IF  NOT CAN-FIND(FIRST int-emitente-supcard-ocor NO-LOCK
                     WHERE int-emitente-supcard-ocor.num-transac = c-transacao
                     AND   int-emitente-supcard-ocor.ind-ocor    = "8.3"
                     AND   int-emitente-supcard-ocor.log-habilitado) THEN
        NEXT.

    FIND int-emitente-supcard NO-LOCK
        WHERE int-emitente-supcard.raiz-cnpj     = int-nfs-supcard.raiz-cnpj
          AND int-emitente-supcard.dat-avaliacao = int-nfs-supcard.dat-movto NO-ERROR.
    IF NOT AVAIL int-emitente-supcard 
       THEN NEXT.

    FIND FIRST tt-dados NO-LOCK
        WHERE  tt-dados.cod-estabel = int-nfs-supcard.cod-estabel
        AND    tt-dados.serie       = int-nfs-supcard.serie
        AND    tt-dados.nr-nota-fis = int-nfs-supcard.nr-nota-fis NO-ERROR.
    IF  NOT AVAIL tt-dados THEN DO:
        FIND FIRST nota-fiscal NO-LOCK
            WHERE  nota-fiscal.cod-estabel = int-nfs-supcard.cod-estabel
            AND    nota-fiscal.serie       = int-nfs-supcard.serie
            AND    nota-fiscal.nr-nota-fis = int-nfs-supcard.nr-nota-fis NO-ERROR.
        IF  AVAIL  nota-fiscal THEN DO:

            FIND FIRST cond-pagto NO-LOCK
                WHERE  cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-ERROR.
            IF  AVAIL  cond-pagto THEN
                ASSIGN c-desc-cond-pag = cond-pagto.descricao
                       i-num-parcelas  = cond-pagto.num-parcelas.

            FIND FIRST tit_acr NO-LOCK
                WHERE  tit_acr.cod_estab     = nota-fiscal.cod-estabel
                AND    tit_acr.cod_espec     = "DM"
                AND    tit_acr.cod_ser_docto = nota-fiscal.serie
                AND    tit_acr.cod_tit_acr   = nota-fiscal.nr-nota-fis
                AND    tit_acr.cod_parcela   = "01" NO-ERROR.
            IF  NOT AVAIL tit_acr THEN
                NEXT.

            FIND int-emitente NO-LOCK
                WHERE int-emitente.cod-emitente = tit_acr.cdn_cliente NO-ERROR.

            /* Busca a Finalidade Econ“mica */
            FIND FIRST histor_finalid_econ NO-LOCK
                WHERE  histor_finalid_econ.cod_indic_econ          = tit_acr.cod_indic_econ
                AND    histor_finalid_econ.dat_inic_valid_finalid <= TODAY
                AND    histor_finalid_econ.dat_fim_valid_finalid   > TODAY NO-ERROR.
            IF  AVAIL  histor_finalid_econ THEN
                ASSIGN c-cod-fin-econ = histor_finalid_econ.cod_finalid_econ.

            /* Cria os dados por Unidade de Neg¢cio da nota */
            FOR EACH  val_tit_acr NO-LOCK
                WHERE val_tit_acr.cod_estab        = tit_acr.cod_estab
                AND   val_tit_acr.num_id_tit_acr   = tit_acr.num_id_tit_acr
                AND   val_tit_acr.cod_finalid_econ = c-cod-fin-econ
                AND   val_tit_acr.val_perc_rat     > 0:
                
                CREATE tt-dados.
                ASSIGN tt-dados.cod-estabel   = nota-fiscal.cod-estabel
                       tt-dados.serie         = nota-fiscal.serie
                       tt-dados.nr-nota-fis   = nota-fiscal.nr-nota-fis
                       tt-dados.dt-emis-nota  = nota-fiscal.dt-emis-nota
                       tt-dados.dat-movto     = int-nfs-supcard.dat-movto
                       tt-dados.val-faturado  = nota-fiscal.vl-tot-nota
                       tt-dados.nome-abrev    = nota-fiscal.nome-ab-cli
                       tt-dados.cod-cond-pag  = nota-fiscal.cod-cond-pag
                       tt-dados.desc-cond-pag = c-desc-cond-pag
                       tt-dados.num-parcelas  = i-num-parcelas
                       tt-dados.unid-negoc    = val_tit_acr.cod_unid_negoc
                       tt-dados.vl-unid-negoc = (nota-fiscal.vl-tot-nota * val_tit_acr.val_perc_rat) / 100
                       tt-dados.vl-taxa       = 0
                       tt-dados.vl-devol      = 0
                       tt-dados.vl-outras     = 0
                       tt-dados.cod-classe    = int-emitente-supcard.cod-classe
                       tt-dados.val-limite    = int-emitente-supcard.val-limite
                       tt-dados.cod-emitente  = tit_acr.cdn_cliente
                       tt-dados.cod_cart_bcia = IF AVAIL int-emitente THEN STRING(int-emitente.cod-gr-cob) ELSE "".

                IF  nota-fiscal.dt-cancela <> ? THEN
                    ASSIGN tt-dados.c-canc-devol = "Cancelada".

                FOR EACH bf-tit_acr
                    WHERE bf-tit_acr.cod_estab     = nota-fiscal.cod-estabel
                      AND bf-tit_acr.cod_espec     = "DM":U
                      AND bf-tit_acr.cod_ser_docto = nota-fiscal.serie
                      AND bf-tit_acr.cod_tit_acr   = nota-fiscal.nr-nota-fis,
                    EACH movto_tit_acr NO-LOCK USE-INDEX mvtttcr_id
                    WHERE movto_tit_acr.cod_estab      = bf-tit_acr.cod_estab
                      AND movto_tit_acr.num_id_tit_acr = bf-tit_acr.num_id_tit_acr
                      AND movto_tit_acr.ind_trans_acr  = "Acerto Valor a Menor":U,
                    EACH aprop_ctbl_acr NO-LOCK USE-INDEX aprpctbd_id
                    WHERE aprop_ctbl_acr.cod_estab            = movto_tit_acr.cod_estab
                      AND aprop_ctbl_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr
                      AND aprop_ctbl_acr.cod_cta_ctbl         = "51110050":U
                      AND aprop_ctbl_acr.cod_unid_negoc       = val_tit_acr.cod_unid_negoc:
                        ASSIGN tt-dados.dt-trans = aprop_ctbl_acr.dat_transacao
                               tt-dados.vl-taxa  = tt-dados.vl-taxa + aprop_ctbl_acr.val_aprop_ctbl.
                END.

                FOR FIRST emitente NO-LOCK
                    WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli,
                    EACH int-pagtos-supcard-ocor NO-LOCK
                    WHERE int-pagtos-supcard-ocor.cnpj        = emitente.cgc
                    AND   int-pagtos-supcard-ocor.num-transac = c-transacao:

                    IF  int-pagtos-supcard-ocor.num-bordero = "RPASSP":U 
                    OR  int-pagtos-supcard-ocor.num-bordero = "RPASSC":U 
                    OR  int-pagtos-supcard-ocor.num-bordero = "CANCEP":U 
                    OR  int-pagtos-supcard-ocor.num-bordero = "BONIFI":U THEN
                        ASSIGN tt-dados.vl-outras = tt-dados.vl-outras + ((int-pagtos-supcard-ocor.val-lancamento * -1) * (val_tit_acr.val_perc_rat / 100)).

                END.

                FOR EACH devol-cli NO-LOCK
                    WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel
                    AND   devol-cli.serie       = nota-fiscal.serie
                    AND   devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis:

                    ASSIGN tt-dados.vl-devol     = tt-dados.vl-devol + devol-cli.vl-devol
                           tt-dados.c-canc-devol = "Devolu‡Æo".
                END.

                FOR EACH int-emitente-supcard-ocor
                    WHERE int-emitente-supcard-ocor.raiz-cnpj   = int-emitente-supcard.raiz-cnpj 
                    AND   int-emitente-supcard-ocor.num-transac = c-transacao NO-LOCK:

                    IF  int-emitente-supcard-ocor.ind-env-ret = 1 THEN 
                        NEXT.
                    
                    IF  int-emitente-supcard-ocor.ind-ocor = "8.3" THEN /* envio */
                        ASSIGN tt-dados.dt-envio = int-emitente-supcard-ocor.dat-avaliacao.

                    IF  int-emitente-supcard-ocor.ind-ocor = "8.3"
                    OR  int-emitente-supcard-ocor.ind-ocor = "8.5" THEN DO: /* outras opera‡äes */

                        FOR EACH int-pendencias-supcard NO-LOCK
                            WHERE int-pendencias-supcard.cod-estab     = tit_acr.cod_estab    
                            AND   int-pendencias-supcard.cod-espec     = tit_acr.cod_espec    
                            AND   int-pendencias-supcard.cod-ser-docto = tit_acr.cod_ser_docto
                            AND   int-pendencias-supcard.cod-tit-acr   = tit_acr.cod_tit_acr  
                            AND   int-pendencias-supcard.cod-parcela   = tit_acr.cod_parcela:
        
                            IF  int-pendencias-supcard.identific = 03      /* cancelamento */
                            OR  int-pendencias-supcard.identific = 10 THEN /* cancelamento parcial */
                                ASSIGN tt-dados.dt-cancel = int-emitente-supcard-ocor.dat-avaliacao.

                            IF  int-pendencias-supcard.identific = 02 THEN /* prorroga‡Æo */
                                ASSIGN tt-dados.dt-prorrog = int-emitente-supcard-ocor.dat-avaliacao.
                        END.

                    END.
                END.                
            END.
        END.
    END.
END.

RETURN "OK":U.
