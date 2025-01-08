/****************************************************************************************
** INTEGRA°€O DE ACOES VMC
** 
********************************************************************************************/

def buffer b-emit-distrib for emitente.

FUNCTION fn-grupo-distribuidores RETURNS LOGICAL
    (p-emitente AS INT) FORWARD.

FUNCTION fn-grupo-distribuidores RETURNS LOGICAL
    (p-emitente AS INT ):
    
    FIND b-emit-distrib NO-LOCK
        WHERE b-emit-distrib.cod-emitente = p-emitente NO-ERROR.

    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "pd4000"
          AND ponto-programa.ponto         = 8:
        FOR EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa :
            IF  b-emit-distrib.cod-gr-cli = int(conteudo-programa.conteudo) then
                RETURN YES.
        END.
    END.

    RETURN NO.
END FUNCTION.

{esapi/esapi015tt.i}
{esp/wso/in/wso0010.i}

DEF VAR v_refer      LIKE tit_ap.cod_refer      NO-UNDO.
DEF VAR v_val_ajuste LIKE tit_ap.val_sdo_tit_ap NO-UNDO.

// definicao dos parametros de entrada 
DEF INPUT  PARAM Id              AS CHAR                    NO-UNDO.
DEF INPUT  param acoount         AS CHAR FORMAT "x(60)"     NO-UNDO.
DEF INPUT  param PaymentMethod   AS CHAR FORMAT "x(60)"     NO-UNDO.
DEF INPUT  PARAM VMC             AS CHAR                    NO-UNDO.
DEF INPUT  param ApprovedValue   AS DEC                     NO-UNDO.
DEF INPUT  param RequestedAmount AS DEC                     NO-UNDO. 
DEF INPUT  param cstatus         AS CHAR                    NO-UNDO.
DEF INPUT  param CreatedDate     AS CHAR                    NO-UNDO.
DEF INPUT  PARAM actiontype      AS CHAR                    NO-UNDO.
DEF INPUT  PARAM businessUnity   AS CHAR                    NO-UNDO.
DEF INPUT  PARAM discarded       AS CHAR.
  
DEF OUTPUT PARAM c-status        AS CHAR                    NO-UNDO.
DEF OUTPUT PARAM c-observacao    AS CHAR   FORMAT 'x(2000)' NO-UNDO.

DEF VAR h-bodi154sdf             AS HANDLE                  NO-UNDO.          

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen AS INT             
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".

DEF OUTPUT PARAM TABLE           FOR tt-erro .

/* ------------------------------------------------------------------ */
/*                     V A R I A V E I S  PEDIDO                      */
/* -------------------------------------------------------------------*/
DEF VAR iCount AS INT NO-UNDO.
DEF VAR i-seq  AS INT NO-UNDO.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST mgcad.empresa NO-LOCK
     WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri NO-ERROR.

DEF BUFFER b-estab      FOR estabelec.
DEF BUFFER b-fornec     FOR emitente.
DEF BUFFER b-redespacho FOR transporte.

{include/i-freeac.i}

// VERIFICA BASE LOGADA 
DEF VAR c-arquivo-log1 AS CHAR NO-UNDO.
DEF VAR l-producao     AS LOG  NO-UNDO.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF  AVAIL tt-prog-ponto
AND tt-prog-ponto.conteudo = "PRODUCAO":U THEN
    ASSIGN l-producao = YES
           i-seq      = 1.
ELSE
    ASSIGN l-producao = NO
           i-seq      = 2.

EMPTY TEMP-TABLE tt-prog-ponto.
DEF VAR l-log AS LOGICAL.

RUN esp/es0018p.p (INPUT "log-wso2":U,
                  INPUT 2,
                  INPUT 0,
                  INPUT "":U,
                  OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto 
   WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'wso0018' NO-ERROR.
IF AVAILABLE tt-prog-ponto AND
   ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
   ASSIGN l-log = YES.
ELSE
   ASSIGN l-log = NO.


// ABERTURA DO LOG 

IF l-log = YES THEN DO:

    IF  OPSYS = 'UNIX' THEN
        ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_wso0018_'.
    ELSE
        ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_wso0018_'.
    
    IF  l-producao THEN
        ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
    ELSE 
        ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.
END.

// Inicio 

ASSIGN v_val_ajuste = 0.

RUN pi-gerar-dados-extrato ("ID : " + string(id)).

RUN pi-gerar-dados-extrato ("VMC : " + string(vmc)).

IF  Id <> '' THEN DO:
    
    FIND FIRST int-cc-benef                                 
         WHERE string(rowid(int-cc-benef)) = vmc NO-LOCK NO-ERROR.
    
    IF  NOT AVAIL int-cc-benef THEN DO:
        RUN pi-erro IN THIS-PROCEDURE (INPUT 17006,
                                       INPUT "ID do Saldo nÆo encontrado no Totvs. NÆo foi poss¡vel encontrar o registro de saldo referente a esta a‡Æo." ).
    
        RUN pi-gerar-dados-extrato ("ID do Saldo nÆo encontrado no Totvs.").
        RETURN "NOK".
    END.
    ELSE DO:
        blk_principal:
            DO TRANSACTION
            ON ERROR UNDO blk_principal,LEAVE blk_principal
            ON STOP  UNDO blk_principal,LEAVE blk_principal:
          
            RUN pi-gerar-dados-extrato ("Inicio do bloco principal").
            
            FIND FIRST emitente
                 WHERE emitente.cgc  = SUBSTR(acoount,3,15) NO-LOCK NO-ERROR.
            
            IF  NOT AVAIL emitente THEN DO:
                RUN pi-erro IN THIS-PROCEDURE (INPUT 17006,
                                               INPUT "Cliente nÆo cadastrado. NÆo foi poss¡vel encontrar o cliente com o documento informado." + " " + id ).
                
                RUN pi-gerar-dados-extrato ("Cliente nÆo cadastrado.").
                RETURN "NOK".
            END.
    
            FIND FIRST int-solicitacao
                WHERE int-solicitacao.codigosolicitacaobeneficio = id NO-ERROR.
            
            IF  NOT AVAIL int-solicitacao THEN DO:
                CREATE int-solicitacao.
                ASSIGN int-solicitacao.CodigoSolicitacaoBeneficio = Id
                       c-observacao = 'Acao criada no Totvs'.
                
            END.
            ELSE 
                ASSIGN c-observacao = 'Acao alterada no Totvs'.
            
            IF  int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006 THEN DO:
                ASSIGN c-observacao = 'Acao ja cancelada no Totvs'.
            END.
            ELSE DO:
                RUN pi-gerar-dados-extrato ( "Alterando int-solicitacao").
                
                ASSIGN int-solicitacao.cod-emitente                     = emitente.cod-emitente
                       int-solicitacao.CodigoAcaoSubsidiadaVMC          = 'Ajuste'
                       int-solicitacao.Ajuste                           = NO   /* INDICA SE È AJUSTE OU NORMAL */    
                       int-solicitacao.CodigoAssistente                 = 36
                       int-solicitacao.CodigoFormaPagamento             = "Dinheiro"
                       int-solicitacao.CodigoSupervisorEms              = 'al027000'
                       int-solicitacao.CodigoTipoSolicitacao            = ''
                       int-solicitacao.CodigoUnidadeNegocio             = businessUnity
                       int-solicitacao.da-vencto                        = int-cc-benef.dt-periodo-fim
                       int-solicitacao.DescricaoSolicitacao             = 'Integra‡Æo ocorrida atraves do Salesforce'
                       int-solicitacao.NomeSolicitacaoBeneficio         = 'VMC'
                       int-solicitacao.RazaoStatusSolicitacaoBeneficio  = 993520002
                       int-solicitacao.StatusPagamento                  = 993520000
                       int-solicitacao.TrimestreCompetencia             = STRING(YEAR(int-cc-benef.dt-periodo-ini)) + "-T".
                
                IF MONTH(int-cc-benef.dt-periodo-ini) >= 1  AND MONTH(int-cc-benef.dt-periodo-ini) <= 3  then assign int-solicitacao.TrimestreCompetencia = int-solicitacao.TrimestreCompetencia + '1'. ELSE
                IF MONTH(int-cc-benef.dt-periodo-ini) >= 4  AND MONTH(int-cc-benef.dt-periodo-ini) <= 6  THEN assign int-solicitacao.TrimestreCompetencia = int-solicitacao.TrimestreCompetencia + '2'. ELSE
                IF MONTH(int-cc-benef.dt-periodo-ini) >= 7  AND MONTH(int-cc-benef.dt-periodo-ini) <= 9  THEN assign int-solicitacao.TrimestreCompetencia = int-solicitacao.TrimestreCompetencia + '3'. ELSE
                IF MONTH(int-cc-benef.dt-periodo-ini) >= 10 AND MONTH(int-cc-benef.dt-periodo-ini) <= 12 THEN assign int-solicitacao.TrimestreCompetencia = int-solicitacao.TrimestreCompetencia + '4'. ELSE
                   ASSIGN int-solicitacao.TrimestreCompetencia = int-solicitacao.TrimestreCompetencia + '?'.
               
                IF  int-solicitacao.dt-periodo-ini = ? THEN 
                    ASSIGN int-solicitacao.dt-periodo-fim          = int-cc-benef.dt-periodo-fim
                           int-solicitacao.dt-periodo-ini          = int-cc-benef.dt-periodo-ini
                           int-solicitacao.DataCriacao             = TODAY
                           int-solicitacao.DataPrevistaRetornoAcao = TODAY
                           int-solicitacao.dt-trans                = TODAY
                           int-solicitacao.DataValidade            = TODAY + 124.
        
                ASSIGN int-solicitacao.desc-forma-pagto                 = "Dinheiro"
                       int-solicitacao.Proprietario                     = ''
                       int-solicitacao.TipoProprietario                 = "systemuser"
                       int-solicitacao.tipo-beneficio                   = 21
                       int-solicitacao.CodigoBeneficio                  = '21'  /* VMC */
                       int-solicitacao.CodigoBeneficioCanal             = ""
                       int-solicitacao.CodigoCondicaoPagamento          = ?
                       int-solicitacao.CodigoConta                      = acoount
                       int-solicitacao.CodigoFilial                     = ''
                       int-solicitacao.cod_estab                        = ''
                       int-solicitacao.DescartarVerba                   = NO
                       int-solicitacao.FormaCancelamento                = ?
                       int-solicitacao.hora-trans                       = STRING(TIME, "HH:MM:SS")
                       int-solicitacao.log-historica                    = NO
                       int-solicitacao.situacao                         = 0
                       int-solicitacao.SolicitacaoIrregular             = NO
                       int-solicitacao.DescricaoSituacaoIrregular       = ""
                       int-solicitacao.ValorAbater                      = ApprovedValue
                       int-solicitacao.ValorAbaterOriginalCRM           = ApprovedValue
                       int-solicitacao.ValorAcao                        = ApprovedValue
                       int-solicitacao.ValorAprovado                    = ApprovedValue
                       int-solicitacao.ValorSolicitado                  = requestedAmount 
                       int-solicitacao.ValorSolicitadoOrigemCRM         = ApprovedValue
                       int-solicitacao.int-1                            = IF fn-grupo-distribuidores (emitente.cod-emitente) THEN 0 ELSE 1. /* 1 indica que ² revenda */
        
                RUN pi-gerar-dados-extrato ("Acao da VMC: " + cstatus).
          
                IF  cstatus = 'Criada' 
                OR  cstatus = 'Aprovada'
                OR  cstatus = 'Comprova‡Æo Parcial' THEN
                    ASSIGN int-solicitacao.SituacaoSolicitacaoBeneficio = 993520002.
                
                IF  cstatus = 'Pagamento Pendente' THEN
                    ASSIGN int-solicitacao.SituacaoSolicitacaoBeneficio = 993520003.
        
                IF  cstatus = 'Pagamento Efetuado' THEN DO:
                    RUN pi-gerar-dados-extrato (" 1 - Canal: " + string(int-solicitacao.cod-emitente) + "int-solicitacao.ValorSolicitado " + string(int-solicitacao.ValorSolicitado) + 
                                                " approvedValue " + STRING(approvedValue)).

                    ASSIGN int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004.

                    IF  int-solicitacao.ValorSolicitado > ApprovedValue THEN
                        ASSIGN v_val_ajuste = int-solicitacao.ValorSolicitado - ApprovedValue.

                    RUN pi-gerar-dados-extrato (" 2 - Canal: " + string(int-solicitacao.cod-emitente) + " v_val_ajuste " + string(v_val_ajuste)).

                    IF  v_val_ajuste > 0 THEN DO:
                        
                        RUN pi-gerar-dados-extrato (" 3 - Canal: " + string(int-solicitacao.cod-emitente) + "v_val_ajuste " + string(v_val_ajuste)).

                        FIND FIRST int-cc-benef
                             WHERE int-cc-benef.dt-periodo-ini = int-solicitacao.dt-periodo-ini
                             AND   int-cc-benef.dt-periodo-fim = int-solicitacao.dt-periodo-fim
                             AND   int-cc-benef.id-status      = 1
                             AND   int-cc-benef.tp-movto       = 2
                             AND   int-cc-benef.canal          = int-solicitacao.cod-emitente
                             AND   int-cc-benef.unid-neg       = "ADM"
                             AND   int-cc-benef.tipo-beneficio = 21 EXCLUSIVE-LOCK NO-ERROR. 
                        
                        IF  AVAIL int-cc-benef THEN.
                            /*ASSIGN int-cc-benef.VerbaCancelada =  int-cc-benef.VerbaCancelada + ApprovedValue.*/
                        
                        RUN pi-gerar-dados-extrato (" 4 - Canal: " + string(int-solicitacao.cod-emitente) + "v_val_ajuste " + string(v_val_ajuste)).
                        
                        RUN pi_altera_saldo_apb.
                                  
                        IF  c-status <> '' THEN
                            UNDO blk_principal, LEAVE blk_principal.
                        ELSE 
                            ASSIGN c-observacao = 'Acao cancelada no Totvs'.
                    END.
                    ELSE 
                        RUN pi-gerar-dados-extrato (" Pagamento total no valor de " + STRING(approvedValue)).
                END.
          
                IF  cstatus = 'Cancelada'             THEN do:
                    FIND FIRST int-cc-benef
                         WHERE int-cc-benef.dt-periodo-ini = int-solicitacao.dt-periodo-ini
                         AND   int-cc-benef.dt-periodo-fim = int-solicitacao.dt-periodo-fim
                         AND   int-cc-benef.id-status      = 1
                         AND   int-cc-benef.tp-movto       = 2
                         AND   int-cc-benef.canal          = int-solicitacao.cod-emitente
                         AND   int-cc-benef.unid-neg       = "ADM"
                         AND   int-cc-benef.tipo-beneficio = 21 EXCLUSIVE-LOCK NO-ERROR. 
                    
                    IF  AVAIL int-cc-benef THEN DO:
                        ASSIGN int-cc-benef.VerbaCancelada = int-cc-benef.VerbaCancelada + /*IF ApprovedValue > 0 THEN ApprovedValue ELSE*/ int-solicitacao.ValorSolicitado.
                    END.
                    ELSE DO:
                        RUN pi-erro IN THIS-PROCEDURE (INPUT 17006,
                                                       INPUT "Saldo da VMC nÆo encontrado para solicita‡Æo Cancelada. Canal: " + string(int-solicitacao.cod-emitente)
                                                           + " - Dt Ini: " + string(int-solicitacao.dt-periodo-ini) +
                                                              "- Dt Fim: " + string(int-solicitacao.dt-periodo-fim) + " - UN: ADM ." ).

                        RUN pi-gerar-dados-extrato (" Status Cancelada - Saldo da VMC nÆo encontrado.").
                        
                        RETURN "NOK".
                    END.

                    RUN pi-gerar-dados-extrato (" Cancelando a acao no valor de " + STRING(approvedValue)).
                    
                    ASSIGN int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006.
                    
                    IF  discarded BEGINS 'Y'
                    OR  discarded BEGINS 'S'
                    OR  discarded BEGINS 'T' THEN DO:
                        ASSIGN int-solicitacao.DescartarVerba = YES
                               v_val_ajuste                   = /*IF ApprovedValue > 0 THEN ApprovedValue ELSE*/ int-solicitacao.ValorSolicitado.
                       
                        RUN pi-gerar-dados-extrato ("Descartando verba ").
                    
                        RUN pi_altera_saldo_apb.
                    END. // descarte de verba
                              
                    IF  c-status <> '' THEN
                        UNDO blk_principal, LEAVE blk_principal.
                    ELSE 
                        ASSIGN c-observacao = 'Acao cancelada no Totvs'.
                END. // status cancelada.
            END.
        
            IF  c-status = '' THEN
                ASSIGN c-status = 'OK'.
    
        END.  // blk_principal
    END.  // avail int-cc-benef
END. // id valido

PROCEDURE pi_altera_saldo_apb:
    
    RUN pi-gerar-dados-extrato (" 5 - Canal: " + string(int-solicitacao.cod-emitente) + "v_val_ajuste " + string(v_val_ajuste)).

    FIND FIRST tit_ap
         WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab
         AND   tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-LOCK NO-ERROR.

    IF  AVAIL tit_ap THEN DO:
        RUN pi-gerar-dados-extrato (" 6 - Canal: " + string(int-solicitacao.cod-emitente) + "v_val_ajuste " + string(v_val_ajuste)).

        RUN pi-gerar-dados-extrato ( "Alterando titulo existente ").

        EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1.
        EMPTY TEMP-TABLE tt_tit_ap_alteracao_rateio.
        EMPTY TEMP-TABLE tt_log_erros_tit_ap_alteracao.

        RUN pi-busca-referencia (INPUT  "BNEF",
                                 INPUT  tit_ap.cod_estab,
                                 OUTPUT v_refer).

        create tt_tit_ap_alteracao_base_aux_1.
        assign tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren             = 'integra'
               tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                  = tit_ap.cod_empresa
               tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                    = tit_ap.cod_estab
               tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                = tit_ap.num_id_tit_ap
               tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                   = recid(tt_tit_ap_alteracao_base_aux_1)
               tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor               = tit_ap.cdn_fornecedor
               tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto              = tit_ap.cod_espec_docto
               tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto                = tit_ap.cod_ser_docto
               tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                   = tit_ap.cod_tit_ap
               tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                  = tit_ap.cod_parcela
               tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                = TODAY
               tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                    = v_refer 
               tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap               = tit_ap.val_sdo_tit_ap - v_val_ajuste /*ApprovedValue*/
               tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto               = tit_ap.dat_emis_docto
               tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap            = tit_ap.dat_vencto_tit_ap
               tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto               = tit_ap.dat_prev_pagto
               tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                = tit_ap.dat_ult_pagto
               tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso              = tit_ap.num_dias_atraso
               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso        = tit_ap.val_perc_multa_atraso
               tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso         = tit_ap.val_juros_dia_atraso
               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso    = tit_ap.val_perc_juros_dia_atraso
               tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                 = tit_ap.dat_desconto
               tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                = tit_ap.val_perc_desc
               tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                 = tit_ap.val_desconto
               tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                 = tit_ap.cod_portador
               tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo             = tit_ap.log_pagto_bloqdo
               tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora               = tit_ap.cod_seguradora
               tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro              = tit_ap.cod_apol_seguro
               tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador               = tit_ap.cod_arrendador
               tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas             = tit_ap.cod_contrat_leas
               tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto          = tit_ap.ind_tip_espec_docto
               tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ               = tit_ap.cod_indic_econ
               tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap   = "Altera‡Æo"
               tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr              = ""
               tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr              = "Cancelamento - Saldo descartado -> Programas chamadores: " +  (IF  PROGRAM-NAME( 1) <> ? THEN PROGRAM-NAME( 1) ELSE "") + chr(10)
                                                                                                                         +  (IF  PROGRAM-NAME( 2) <> ? THEN PROGRAM-NAME( 2) ELSE "") + chr(10)
                                                                                                                         +  (IF  PROGRAM-NAME( 3) <> ? THEN PROGRAM-NAME( 3) ELSE "") + chr(10)
                                                                                                                         +  (IF  PROGRAM-NAME( 4) <> ? THEN PROGRAM-NAME( 4) ELSE "") + chr(10)
                                                                                                                         +  (IF  PROGRAM-NAME( 5) <> ? THEN PROGRAM-NAME( 5) ELSE "") + chr(10)
                                                                                                                         +  (IF  PROGRAM-NAME( 6) <> ? THEN PROGRAM-NAME( 6) ELSE "") + chr(10)
                                                                                                                         +  (IF  PROGRAM-NAME( 7) <> ? THEN PROGRAM-NAME( 7) ELSE "") + chr(10)
                                                                                                                         +  (IF  PROGRAM-NAME( 8) <> ? THEN PROGRAM-NAME( 8) ELSE "") + chr(10)
                                                                                                                         +  (IF  PROGRAM-NAME( 9) <> ? THEN PROGRAM-NAME( 9) ELSE "") + chr(10)
                                                                                                                         +  (IF  PROGRAM-NAME(10) <> ? THEN PROGRAM-NAME(10) ELSE "")
               tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap               = tit_ap.ind_sit_tit_ap              
               tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto              = tit_ap.cod_forma_pagto.

               VALIDATE tt_tit_ap_alteracao_base_aux_1.

        RUN pi-gerar-dados-extrato ( "Apos a criacao da alteracao de titulo - pagamento parcial").

        IF  CAN-FIND (FIRST tt_tit_ap_alteracao_base_aux_1)  THEN DO:
            RUN pi-gerar-dados-extrato ( "Antes de executar a api Totvs ").
            run prgfin/apb/apb767ze.py(input 1,
                                       input "",
                                       INPUT "",
                                       input-output table tt_tit_ap_alteracao_base_aux_1,
                                       input-output table tt_tit_ap_alteracao_rateio,
                                       output table       tt_log_erros_tit_ap_alteracao).

            RUN pi-gerar-dados-extrato ( "Depois de executar a api Totvs ").

            IF  CAN-FIND(FIRST tt_log_erros_tit_ap_alteracao 
                            WHERE  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 6542  
                              AND  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 11834 
                              AND  tt_log_erros_tit_ap_alteracao.ttv_num_mensagem <> 20260 ) THEN DO:

                RUN pi-gerar-dados-extrato ( "Encontrado Erros na API ").
                ASSIGN c-status = 'NOK'.

                FOR EACH tt_log_erros_tit_ap_alteracao:
                   //DISP tt_log_erros_tit_ap_alteracao.ttv_num_mensagem
                   //     tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro.
                    ASSIGN c-observacao = c-observacao + tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro + ' ' .
                    RUN pi-gerar-dados-extrato (tt_log_erros_tit_ap_alteracao.ttv_des_msg_erro).
                END.
            END. // CAN-FIND
        END. // CAN-FIND
    END. // avail tit_ap

END PROCEDURE.

PROCEDURE pi-busca-referencia:
    DEFINE INPUT PARAMETER  p-sigla       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  p-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-refer       AS CHARACTER NO-UNDO.

    def var v_log_refer_uni AS LOGICAL format "Sim/N’o" INITIAL YES NO-UNDO.
    def var v_cod_refer     AS CHARACTER format "x(10)" NO-UNDO.

    ASSIGN v_log_refer_uni = NO.

    REPEAT WHILE v_log_refer_uni = NO:

        run pi_retorna_sugestao_referencia (INPUT  p-sigla,
                                            OUTPUT v_cod_refer).

        run pi_verifica_refer_unica_apb (INPUT  p-cod-estabel,
                                         INPUT  v_cod_refer,
                                         INPUT  "lote_impl_tit_ap",
                                         INPUT  ?,
                                         OUTPUT v_log_refer_uni).
    END.

    ASSIGN p-refer = v_cod_refer.

END PROCEDURE.

PROCEDURE pi_retorna_sugestao_referencia:

    /************************ Parameter Definition Begin ************************/
               
    DEF INPUT  param p_ind_tip_atualiz AS CHARACTER format "X(08)" NO-UNDO.
    DEF OUTPUT param p_cod_refer       AS CHARACTER format "x(10)" NO-UNDO.

    DEF VAR v_num_aux   AS INTEGER NO-UNDO. 
    DEF VAR v_num_aux_2 AS INTEGER NO-UNDO. 
    DEF VAR v_num_cont  AS INTEGER NO-UNDO. 

    ASSIGN p_cod_refer = SUBSTRING(p_ind_tip_atualiz,1,4)
           v_num_aux_2 = INTEGER(this-procedure:handle).

    DO  v_num_cont = 1 TO 6:
        ASSIGN v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    END.

END PROCEDURE.

PROCEDURE pi_verifica_refer_unica_apb:

    DEF INPUT  PARAM p_cod_estab        AS CHARACTER FORMAT "x(3)"    NO-UNDO.
    DEF INPUT  PARAM p_cod_refer        AS CHARACTER FORMAT "x(10)"   NO-UNDO.
    DEF INPUT  PARAM p_cod_table        AS CHARACTER FORMAT "x(8)"    NO-UNDO.
    DEF INPUT  PARAM p_rec_movto_tit_ap AS RECID     FORMAT ">>>>>>9" NO-UNDO. 
    DEF OUTPUT PARAM p_log_refer_uni    AS LOGICAL   FORMAT "Sim/N’o" NO-UNDO.

    DEF BUFFER b_antecip_pef_pend FOR antecip_pef_pend.
    DEF BUFFER b_lote_impl_tit_ap FOR lote_impl_tit_ap.
    DEF BUFFER b_lote_pagto       FOR lote_pagto.
    DEF BUFFER b_movto_tit_ap     FOR movto_tit_ap.

    /*************************** Buffer Definition End **************************/
    ASSIGN p_log_refer_uni = YES.

    find first b_antecip_pef_pend no-lock
         where b_antecip_pef_pend.cod_estab = p_cod_estab
           and b_antecip_pef_pend.cod_refer = p_cod_refer no-error.
    if  avail b_antecip_pef_pend then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_lote_impl_tit_ap no-lock
         where b_lote_impl_tit_ap.cod_estab = p_cod_estab
           and b_lote_impl_tit_ap.cod_refer = p_cod_refer no-error.
    if  avail b_lote_impl_tit_ap then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_lote_pagto no-lock
         where b_lote_pagto.cod_estab_refer = p_cod_estab
           and b_lote_pagto.cod_refer = p_cod_refer no-error.
    if  avail b_lote_pagto then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.
    find first b_movto_tit_ap NO-LOCK where b_movto_tit_ap.cod_estab = p_cod_estab
           and b_movto_tit_ap.cod_refer = p_cod_refer
           and recid(b_movto_tit_ap) <> p_rec_movto_tit_ap no-error.
    if  avail b_movto_tit_ap then do:
        assign p_log_refer_uni = no.
        RETURN.
    end.

END PROCEDURE.

procedure pi-erro:
  define input parameter p-cd-erro  as integer   no-undo.
  define input parameter p-mensagem as character no-undo.

    create tt-erro.
    assign iCount           = iCount + 1
           tt-erro.i-sequen = iCount
           tt-erro.cd-erro  = p-cd-erro 
           tt-erro.mensagem = p-mensagem.
end procedure.


PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.
            
    if  c-arquivo-log1 <> "" and c-arquivo-log1 <> ? then do:
    
        output to value(c-arquivo-log1) append.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-ponto-executado AS CHARACTER FORMAT "X(24)" NO-UNDO.
             {utp/ut-liter.i "Ponto_Executado" *}
             ASSIGN c-lbl-liter-ponto-executado = TRIM(RETURN-VALUE).
             put "     " + c-lbl-liter-ponto-executado + ": " p-string format "x(100)" skip.
        output close. 
    
    end.
END.
