{method/dbotterr.i}

DEFINE INPUT        PARAMETER p-cod-estabel    AS CHARACTER NO-UNDO.   
DEFINE INPUT        PARAMETER p-serie          AS CHARACTER NO-UNDO.   
DEFINE INPUT        PARAMETER p-nr-nota-fis    AS CHARACTER NO-UNDO.  
DEFINE INPUT        PARAMETER p-motivo-cancela AS CHARACTER NO-UNDO.  /*'Cancelado via API padrÆo FT2200 - Projeto Integra‡Æo' + */
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR RowErrors.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
    FIELD ttv_num_cod_erro  AS INTEGER   INITIAL ?
    FIELD ttv_des_msg_ajuda AS CHARACTER INITIAL ?
    FIELD ttv_des_msg_erro  AS CHARACTER INITIAL ?.

DEFINE TEMP-TABLE tt-roman-faturam NO-UNDO LIKE roman-faturam
    FIELD r-Rowid AS ROWID
    FIELD marcado AS CHAR.

DEFINE TEMP-TABLE tt-romanAUX NO-UNDO
    FIELD num-romaneio LIKE roman-faturam.num-romaneio.

DEFINE TEMP-TABLE ttOutrasNotas NO-UNDO
    FIELD cod-estabel LIKE nota-fiscal.cod-estabel
    FIELD serie       LIKE nota-fiscal.serie
    FIELD nr-nota-fis LIKE nota-fiscal.nr-nota-fis
    FIELD dt-cancela  LIKE nota-fiscal.dt-cancela.

{dibo/bodi509.i ttRomanFaturam}

DEFINE NEW GLOBAL SHARED VARIABLE gc-NFe-nfs-a-cancelar AS CHARACTER                NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario         AS CHARACTER FORMAT "x(12)" NO-UNDO.

DEFINE VARIABLE h-axsep005           AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi509            AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-romaneio-alterados AS CHARACTER   NO-UNDO.
DEFINE VARIABLE bo-cancela           AS HANDLE      NO-UNDO.
DEFINE VARIABLE da-dt-cancela        AS DATE        NO-UNDO.
DEFINE VARIABLE c-motivo-cancela     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-msg-solic-cancel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-nota-fis        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE log-valida-dt-saida  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE log-reabre-resumo    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE log-cancela-titulos  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-arquivo-estoq      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-cdd-embarq        AS DECIMAL     NO-UNDO.

DEFINE BUFFER b-estabelec FOR estabelec.

EMPTY TEMP-TABLE RowErrors.

ASSIGN c-cod-estabel        = p-cod-estabel
       c-serie              = p-serie
       c-nr-nota-fis        = p-nr-nota-fis
       da-dt-cancela        = TODAY
       c-motivo-cancela     = p-motivo-cancela 
       log-valida-dt-saida  = FALSE
       log-reabre-resumo    = FALSE
       log-cancela-titulos  = TRUE
       c-arquivo-estoq      = RIGHT-TRIM(RIGHT-TRIM(SESSION:TEMP-DIR, '/'), '/') + '/FT2200.txt' .

FIND FIRST nota-fiscal WHERE 
     nota-fiscal.cod-estabel = c-cod-estabel AND
     nota-fiscal.serie       = c-serie       AND
     nota-fiscal.nr-nota-fis = c-nr-nota-fis NO-LOCK NO-ERROR.

IF AVAIL nota-fiscal THEN
   ASSIGN de-cdd-embarq = nota-fiscal.cdd-embarq.

IF AVAIL nota-fiscal THEN DO:
    FIND CURRENT nota-fiscal EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN nota-fiscal.dt-saida = ?.
    FIND CURRENT nota-fiscal NO-LOCK NO-ERROR.
END.                                

IF AVAIL nota-fiscal THEN DO:

    FIND FIRST ser-estab NO-LOCK
         WHERE ser-estab.cod-estab = nota-fiscal.cod-estabel
           AND ser-estab.serie     = nota-fiscal.serie
           AND ser-estab.log-nf-eletro NO-ERROR.

END.


FOR FIRST param-compra NO-LOCK: END.
/* Integra‡Æo SGT */
IF  CAN-FIND(FIRST funcao
             WHERE funcao.cd-funcao = 'spp-sgt':U
             AND   funcao.ativo     = TRUE)
OR  CAN-FIND(FIRST funcao 
             WHERE funcao.cd-funcao = 'spp-integra-ems-his':U
             AND   funcao.ativo     = TRUE) THEN DO:
        
    RUN dibo/bodi509.p PERSISTENT SET h-bodi509.
END.

/*NF-e*/
{ftp/ft2200.i1} /*Defini‡äes e pi-Trata-NFe*/
/*fim NF-e*/

RUN dibo/bodi135cancel.p PERSISTENT SET bo-cancela.

/*--- Tratamento para gravar usuario de solicita‡Æo de cancelamento NFS-e ---*/
IF (NOT PROGRAM-NAME(2) MATCHES("*bodi135nfse*") )
AND (AVAIL nota-fiscal
AND CAN-FIND(FIRST ser-estab NO-LOCK
             WHERE ser-estab.cod-estab = nota-fiscal.cod-estabel
               AND ser-estab.serie     = nota-fiscal.serie
               AND &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN
                       ser-estab.log-emite-nf-serv-eletro
                   &ELSE
                       TRIM(SUBSTR(ser-estab.char-1,71,1)) = "S":U
                   &ENDIF)) 
THEN DO TRANS:

    &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN
        &GLOBAL-DEFINE IDI-SIT-NF-SERV-ELETRO        nota-fiscal.idi-sit-nf-serv-eletro
    &ELSE
        &GLOBAL-DEFINE IDI-SIT-NF-SERV-ELETRO        INTEGER(SUBSTR(nota-fiscal.char-1,143,2))
    &ENDIF


    ASSIGN c-msg-solic-cancel = "".
    ASSIGN c-msg-solic-cancel = "Solicita‡Æo de Cancelamento da NFS-e feita pelo usu rio: " + c-seg-usuario +
                                " | Situa‡Æo NFS-e no momento da solicita‡Æo de cancelamento " + '"' + {diinc/i04di135.i 04 {&IDI-SIT-NF-SERV-ELETRO}} + '"' +
                                " | Solicita‡Æo realizada atrav‚s do programa FT2200" NO-ERROR.

    CREATE ret-nf-eletro.
    ASSIGN ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
           ret-nf-eletro.cod-serie   = nota-fiscal.serie
           ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis
           ret-nf-eletro.cod-msg     = "17006"
           ret-nf-eletro.cod-livre-1 = c-msg-solic-cancel
           ret-nf-eletro.dat-ret     = TODAY
           ret-nf-eletro.hra-ret     = REPLACE(STRING(TIME, "HH:MM:SS"),":","":U)
           ret-nf-eletro.log-ativo   = YES NO-ERROR.
END.
/*---*/



&if '{&bf_dis_sgt}' = 'yes' &then
    IF  CAN-FIND(FIRST funcao
                 WHERE funcao.cd-funcao = 'spp-sgt':U
                 AND   funcao.ativo     = TRUE) THEN DO:
        EMPTY TEMP-TABLE ttOutrasNotas NO-ERROR. 
        
        RUN buscaRelacionamentos IN h-bodi509 (INPUT c-cod-estabel,
                                               INPUT c-serie,
                                               INPUT c-nr-nota-fis,
                                               OUTPUT table ttOutrasNotas).

        IF  CAN-FIND(FIRST ttOutrasNotas) THEN DO:
            FOR EACH ttOutrasNotas:
                RUN cancelaNotaFiscal IN bo-cancela (INPUT ttOutrasNotas.cod-estabel,
                                                     INPUT ttOutrasNotas.serie,
                                                     INPUT ttOutrasNotas.nr-nota-fis,
                                                     INPUT da-dt-cancela,
                                                     INPUT c-motivo-cancela,
                                                     INPUT log-valida-dt-saida,
                                                     &IF '{&BF_DIS_VERSAO_EMS}' >= '2.03' &THEN
                                                      INPUT log-reabre-resumo,
                                                     &ENDIF
                                                     &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
                                                      INPUT log-cancela-titulos,
                                                     &ENDIF
                                                     INPUT c-arquivo-estoq,
                                                     INPUT c-seg-usuario).
                /* Caso cancele a nota, a temp-table tamb‚m ‚ atualizada */
                IF  RETURN-VALUE <> 'NOK' THEN ASSIGN ttOutrasNotas.dt-cancela = da-dt-cancela.

            END. /* for each ttOutrasNotas: */
        END. /* if  can-find(first ttOutrasNotas) */
        ELSE DO:
            /* Quando for nota normal, sem a existˆncia de romaneios, e a fun‡Æo SGT esteja ativa */
            CREATE ttOutrasNotas.
            ASSIGN ttOutrasNotas.cod-estabel = c-cod-estabel
                   ttOutrasNotas.serie       = c-serie
                   ttOutrasNotas.nr-nota-fis = c-nr-nota-fis.

            FOR EACH ttOutrasNotas:
                RUN cancelaNotaFiscal IN bo-cancela (INPUT ttOutrasNotas.cod-estabel,
                                                     INPUT ttOutrasNotas.serie,
                                                     INPUT ttOutrasNotas.nr-nota-fis,
                                                     INPUT da-dt-cancela,
                                                     INPUT c-motivo-cancela,
                                                     INPUT log-valida-dt-saida,
                                                     INPUT log-reabre-resumo,
                                                     INPUT log-cancela-titulos,
                                                     INPUT c-arquivo-estoq,
                                                     INPUT c-seg-usuario).
                /* Caso cancele a nota, a temp-table tamb‚m ‚ atualizada */
                IF  RETURN-VALUE <> 'NOK' THEN ASSIGN ttOutrasNotas.dt-cancela = da-dt-cancela.
            END. /* for each ttOutrasNotas: */
        END. /* else do: */
    END. /* if  can-find(first funcao */
    ELSE DO:
        RUN cancelaNotaFiscal IN bo-cancela (INPUT c-cod-estabel,
                                             INPUT c-serie,
                                             INPUT c-nr-nota-fis,
                                             INPUT da-dt-cancela,
                                             INPUT c-motivo-cancela,
                                             INPUT log-valida-dt-saida,
                                             INPUT log-reabre-resumo,
                                             INPUT log-cancela-titulos,
                                             INPUT c-arquivo-estoq,
                                             INPUT c-seg-usuario).
    END. /* else do: */
&else
    RUN cancelaNotaFiscal IN bo-cancela (INPUT c-cod-estabel,
                                         INPUT c-serie,
                                         INPUT c-nr-nota-fis,
                                         INPUT da-dt-cancela,
                                         INPUT c-motivo-cancela,
                                         INPUT log-valida-dt-saida,
                                         INPUT log-reabre-resumo,
                                         INPUT log-cancela-titulos,
                                         INPUT c-arquivo-estoq,
                                         INPUT c-seg-usuario).
&endif

RUN getRowErrors IN bo-cancela (OUTPUT TABLE RowErrors).

RUN destroy IN bo-cancela.

/*------------------------------------ NF-e ------------------------------------*/
IF  CAN-FIND(FIRST funcao NO-LOCK 
             WHERE funcao.cd-funcao = "SPP-NFE":U
               AND funcao.ativo = YES)
AND NOT CAN-FIND (FIRST RowErrors
                  WHERE RowErrors.ErrorNumber = 19531) /*19531 - Indica que a nota foi cancelada. Neste caso nÆo chamar rotina de solicita‡Æo de cancelamento*/
AND AVAIL nota-fiscal THEN DO:
    
    RUN pi-Trata-NFe (INPUT da-dt-cancela,    
                      INPUT c-motivo-cancela,  
                      INPUT log-reabre-resumo, 
                      INPUT log-cancela-titulos).

END.
/*------------------------------------------------------------------------------*/


/**/
IF CAN-FIND( FIRST funcao
             WHERE funcao.cd-funcao = "spp-integra-ems-his"
             AND   funcao.ativo     = YES) THEN DO:

    /* Verifica se o estabelecimento esta integrado com HIS */
    FOR FIRST b-estabelec FIELDS() NO-LOCK 
        WHERE b-estabelec.cod-estabel = c-cod-estabel
          AND SUBSTRING(b-estabelec.char-2,214,1) = "S":
    
        /*** Execu‡Æo do adapter para gera‡Æo da mensagem XML de cancelamento ***/
        IF  NOT VALID-HANDLE(h-axsep005)
        OR  h-axsep005:TYPE <> "PROCEDURE":U           
        OR  h-axsep005:FILE-NAME <> "adapters/xml/ep2/axsep005.p":U 
        THEN RUN adapters/xml/ep2/axsep005.p PERSISTENT SET h-axsep005(OUTPUT table tt_log_erro).
        
        EMPTY TEMP-TABLE RowErrors NO-ERROR.
    
        RUN PITransUpsert IN h-axsep005 (INPUT "UPD":U,
                                         INPUT "updateDocument":U,
                                         INPUT c-cod-estabel, 
                                         INPUT c-serie,       
                                         INPUT c-nr-nota-fis, 
                                         INPUT da-dt-cancela,
                                         INPUT c-motivo-cancela,
                                         OUTPUT TABLE tt_log_erro).
        
        
        IF  CAN-FIND(FIRST tt_log_erro) THEN
            FOR EACH tt_log_erro:
                CREATE rowErrors.
                ASSIGN RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro 
                       RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                       RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = IF tt_log_erro.ttv_num_cod_erro = 27979 THEN "WARNING":U ELSE "ERROR":U.
    
            END. /* FOR EACH tt_log_erro: */
    END.        
    
    IF  VALID-HANDLE(h-axsep005) THEN DO:
        DELETE PROCEDURE h-axsep005 NO-ERROR.
        ASSIGN h-axsep005 = ?.
    END.
    
    IF VALID-HANDLE(h-bodi509) THEN 
       DELETE PROCEDURE h-bodi509.
END.

