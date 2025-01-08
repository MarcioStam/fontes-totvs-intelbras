/* ----------------------------------------------------------------------------
   Programa..: upc/boin135cancel-upc.p
   Data......: Dezembro / 2004.
   Autor.....: Robinson Rafael Koprowski - Datasul Gestech.
   Objetivo..: Manutená∆o da Ped-fiscal no cancelamento de NFs
   
   
   Alteracao.: 29 de junho de 2009
   Autor.....: Renersson Ricardo Agostini - GATI - Gestao e Tecnologia em TI
   Objetivo..: Controle e validacoes necessarias para o processo de gati-nfe.
----------------------------------------------------------------------------  */

DEFINE VARIABLE i                      AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-escrm001api          AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arquivo-cancelamento AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-wms-estab-ativo      AS LOGICAL     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE cb-inutiliza-denega-parametro-ft2201 AS INTEGER NO-UNDO.
/* Include i-epc200.i: Definiá∆o Temp-Table tt-epc */
{include/i-epc200.i1}
{cdp/cd0666.i}
{esapi/esapi010tt.i}
{esp/es0018.i}

{method/dbotterr.i}

DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.
DEFINE VARIABLE c-hora    AS CHARACTER   NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wgh-desc-cancela  AS widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE gProtocoloNFE-bodi135 AS character no-undo.
DEFINE new global shared VARIABLE wh-envia-email        as WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE c-email-destino AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hBODI135-cancel AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-motivo AS CHARACTER FORMAT "x(200)"  NO-UNDO.
DEFINE VARIABLE c-chave  AS CHARACTER FORMAT "x(60)"  NO-UNDO.
DEFINE VARIABLE i-idi-tip-transm AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad107na AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-boin090 AS HANDLE      NO-UNDO.
DEFINE BUFFER bfPed-fiscal FOR ped-fiscal.
DEFINE VARIABLE l-achou-usuario AS LOGICAL     NO-UNDO.
DEFINE VARIABLE log-erro-wms    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-eswmpapi005   AS HANDLE      NO-UNDO.
DEF STREAM arq-email.

/* TMS DEFINE BUFFER bfparam-tf FOR param-tf. 
DEFINE BUFFER bfnota-conhec FOR nota-conhec.*/

DEFINE VARIABLE lImportado AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-dig-ver-nfe AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-soma-mod-nfe AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-count-nfe AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-mult-nfe AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-chave-nfe  AS CHARACTER   NO-UNDO.
DEF BUFFER  b-estab-nfe FOR estabelec.
DEFINE VARIABLE c-serie-nfe LIKE nota-fiscal.serie NO-UNDO.
DEFINE VARIABLE c-nota-nfe  LIKE nota-fiscal.nr-nota-fis NO-UNDO.
{utp/ut-glob.i}
{utp/utapi019.i}

DEFINE TEMP-TABLE TT_File NO-UNDO 
    FIELD FILENAME   AS CHARACTER
    FIELD FullPath   AS CHARACTER
    FIELD FILE       AS CHARACTER
    FIELD lImportado AS LOGICAL.

DEFINE VARIABLE i-time         AS INTEGER     NO-UNDO.
DEFINE VARIABLE cCampo1        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo2        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo3        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo4        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo5        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo6        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo7  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iLetra   AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-nr-transacao AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-eswmpapi004   AS HANDLE NO-UNDO.

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.

define temp-table tt-ft0604 NO-UNDO
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field da-periodo-ini   as date
    field da-periodo-fim   as date
    field c-estabel-ini    as character
    field c-estabel-fim    as character
    field rs-tipo-nota     as integer
    field rs-data-atualiz  as INTEGER
    FIELD tg-serie-padrao  AS LOGICAL.

find first param-global no-lock no-error.

{include/i-freeac.i}

DEFINE VARIABLE l-cancel-nf      AS LOGICAL     NO-UNDO INITIAL YES.
DEFINE VARIABLE l-achou-usuar-uf AS LOGICAL     NO-UNDO INITIAL NO. 
DEFINE VARIABLE l-continua-pendencia AS LOGICAL  INITIAL YES   NO-UNDO.

DEFINE VARIABLE h-esapi018 AS HANDLE      NO-UNDO.

RUN prmupc/prmupc-bodi135cancel.p(INPUT p-ind-event, INPUT-OUTPUT TABLE tt-epc).

IF p-ind-event = 'onValidateCancel'    THEN DO:  
    
    FIND tt-epc NO-LOCK
        WHERE tt-epc.cod-event = p-ind-event
          AND (tt-epc.cod-parameter = 'nota-fiscal-rowid' 
           OR  tt-epc.cod-parameter = 'notafiscal-rowid'
           OR  tt-epc.cod-parameter = 'table-rowid') NO-ERROR.
    IF AVAIL tt-epc THEN DO:
        FIND nota-fiscal EXCLUSIVE-LOCK WHERE ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
        IF AVAILABLE nota-fiscal THEN DO:


            FOR FIRST natur-oper
                WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
                NO-LOCK:
            END.
            find tt-epc
                where tt-epc.cod-event     = p-ind-event
                  AND tt-epc.cod-parameter = "object-handle"
                  NO-LOCK NO-ERROR.

            ASSIGN hBODI135-cancel = WIDGET-HANDLE(tt-epc.val-parameter).
            
            IF AVAIL natur-oper
               AND   natur-oper.especie = "NFT" THEN DO:
                FIND estabelec
                     WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel
                     NO-LOCK NO-ERROR.
                FIND docum-est
                    WHERE docum-est.cod-emitente = estabelec.cod-emitente
                      AND docum-est.serie-docto  = nota-fiscal.serie
                      AND docum-est.nro-docto    = nota-fiscal.nr-nota-fis
                      AND docum-est.nat-operacao = natur-oper.nat-comp
                    NO-LOCK NO-ERROR.
                IF AVAIL DOCUM-EST AND
                    DOCUM-EST.CE-ATUAL = YES THEN DO:
                    RUN _insertErrorManual IN hBODI135-cancel  (INPUT 0,
                                                                           INPUT "EMS",
                                                                           INPUT "ERROR",
                                                                           INPUT "Documento atualizado NO recebimento, n∆o Ç permitido o cancelamento, entrar em contato com grupo.fiscal",
                                                                           INPUT "N∆o Ç poss°vel cancelar.",
                                                                           INPUT "":U).
                              RETURN 'NOK'.
                END.

            END.
            
            FIND FIRST it-nota-fisc OF nota-fiscal
                WHERE it-nota-fisc.vl-bsubs-it > 0 NO-LOCK NO-ERROR.

            IF AVAILABLE it-nota-fisc THEN DO:
                FOR FIRST ponto-programa NO-LOCK USE-INDEX ponto
                    WHERE ponto-programa.nome-programa = "ft2200":U
                      AND ponto-programa.ponto         = 3:

                    FIND FIRST conteudo-programa
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                          AND  ENTRY(1, conteudo-programa.conteudo, "|":U) = nota-fiscal.estado
                          AND (ENTRY(2, conteudo-programa.conteudo, "|":U) = "*":U
                           OR  LOOKUP(nota-fiscal.cod-estabel, ENTRY(2, conteudo-programa.conteudo, "|":U), ",":U) > 0) NO-LOCK NO-ERROR.

                    IF AVAILABLE conteudo-programa THEN DO:
                        IF LOOKUP(v_cod_usuar_corren, ENTRY(3, conteudo-programa.conteudo, "|":U), ",":U) = 0 THEN
                            ASSIGN l-cancel-nf = NO.
                        ELSE
                            ASSIGN l-achou-usuar-uf = YES.
                    END.
                END.
            END.
            
            IF NOT l-cancel-nf THEN DO:
                
                RUN _insertErrorManual IN hBODI135-cancel  (INPUT 0,
                                                            INPUT "EMS":U,
                                                            INPUT "ERROR":U,
                                                            INPUT "Usu†rio n∆o tem permiss∆o para cancelar nota fiscal":U,
                                                            INPUT "Usu†rio ~"":U + v_cod_usuar_corren + "~" n∆o tem permiss∆o para cancelar a nota fiscal da UF ~"":U + nota-fiscal.estado + "~" com substituiá∆o tribut†ria.":U,
                                                            INPUT "":U).

                RETURN "NOK":U.
            END.

            IF VALID-HANDLE(wgh-desc-cancela) AND LENGTH(wgh-desc-cancela:SCREEN-VALUE) < 16 
            AND VALID-HANDLE(hBODI135-cancel) THEN DO:
                RUN _insertErrorManual IN hBODI135-cancel  (INPUT 0,
                                                            INPUT "EMS",
                                                            INPUT "ERROR",
                                                            INPUT "Motivo de cancelamento precisa ter mais do que 15 caracteres.",
                                                            INPUT "Motivo de cancelamento precisa ter mais do que 15 caracteres.",
                                                            INPUT "":U).
                RETURN 'NOK'.
            END.



            IF  NOT VALID-HANDLE(h-boad107na) THEN DO:
                RUN adbo/boad107na.p PERSISTENT SET h-boad107na.
                RUN openQueryStatic IN h-boad107na (INPUT "Main":U).
            END.
            
            IF  VALID-HANDLE(h-boad107na) THEN DO:
                RUN goToKey     IN h-boad107na (INPUT nota-fiscal.cod-estabel).
                RUN getIntField IN h-boad107na (INPUT "idi-tip-transm":U,
                                                OUTPUT i-idi-tip-transm).
            
                DELETE PROCEDURE h-boad107na NO-ERROR.
                ASSIGN h-boad107na = ?.
            END.
            
            
            /* Tratamento WMS - Verifica */
            RUN esp/wmp/eswmpapi006.p( INPUT nota-fiscal.cod-estabel, OUTPUT l-wms-estab-ativo).
            IF  l-wms-estab-ativo THEN DO:
                ASSIGN log-erro-wms = NO.
                IF NOT VALID-HANDLE(h-eswmpapi004) THEN
                    RUN esp/wmp/eswmpapi004.p PERSISTENT SET h-eswmpapi004.

                FOR EACH fat-ser-lote OF nota-fiscal NO-LOCK,
                    FIRST deposito OF fat-ser-lote WHERE
                        deposito.log-gera-wms = YES NO-LOCK:
                    
                    RUN piVerifica IN h-eswmpapi004 (INPUT  ROWID(nota-fiscal),
                                                    OUTPUT TABLE RowErrors).
                    ASSIGN log-erro-wms = CAN-FIND(FIRST RowErrors) AND RETURN-VALUE <> "OK".

                    LEAVE.
                END.

                DELETE PROCEDURE h-eswmpapi004.
                ASSIGN h-eswmpapi004 = ?.

                IF log-erro-wms = YES THEN DO:
                    FOR EACH RowErrors:
                        RUN _insertErrorManual IN hBODI135-cancel  (INPUT RowErrors.ErrorNumber,
                                                                    INPUT "EMS",
                                                                    INPUT "ERROR",
                                                                    INPUT RowErrors.ErrorDescription,
                                                                    INPUT RowErrors.ErrorHelp,
                                                                    INPUT "":U).
                        RETURN 'NOK':U.
                    END.
                END.
            END. 
        END.
    END.
END.

 

IF p-ind-event = 'Fim_CancelaNotaFiscal' THEN DO:

    FIND tt-epc NO-LOCK
        WHERE tt-epc.cod-event = p-ind-event
          AND (tt-epc.cod-parameter = 'NotaFiscal-Rowid'
           OR  tt-epc.cod-parameter = 'table-rowid') NO-ERROR.

    IF AVAIL tt-epc THEN DO:
        FIND nota-fiscal EXCLUSIVE-LOCK WHERE ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
    END.

    IF AVAILABLE nota-fiscal THEN DO:
        /*    
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:

            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                   AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
    
            FIND FIRST int-ped-venda2 NO-LOCK
                 WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido NO-ERROR.
            
            FIND FIRST int-pv-canal EXCLUSIVE-LOCK
                 WHERE int-pv-canal.cod-canal = int-ped-venda2.int-1
                   AND int-pv-canal.it-codigo = it-nota-fisc.it-codigo
                   AND int-pv-canal.mes-meta  = MONTH(nota-fiscal.dt-emis)
                   AND int-pv-canal.ano-meta  = YEAR(nota-fiscal.dt-emis) NO-ERROR.
    
            IF AVAIL int-pv-canal THEN DO:
                ASSIGN int-pv-canal.qt-faturada = int-pv-canal.qt-faturada - it-nota-fisc.qt-faturada[1].
            END.
        END.
        */
        
        FIND natur-oper
            WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.

        /* Envia email ao financeiro informando cancelamento de nota de devoluá∆o */
        IF  natur-oper.especie = "NFD" THEN
            RUN piEnviaEmailFinanc.
      
        FOR EACH comissao-fat
            where comissao-fat.cod-estabel    = nota-fiscal.cod-estabel
              AND comissao-fat.serie          = nota-fiscal.serie
              AND comissao-fat.nr-nota-fis    = nota-fiscal.nr-nota-fis 
              AND comissao-fat.id-tipo-inform = 1 EXCLUSIVE-LOCK:
            DELETE comissao-fat.
        END.
         
        IF nota-fiscal.nr-pedcli = "" THEN DO:
            FOR EACH ped-fiscal EXCLUSIVE-LOCK
                WHERE ped-fiscal.cod-estabel  = nota-fiscal.cod-estabel    
                  AND ped-fiscal.serie        = nota-fiscal.serie         
                  AND ped-fiscal.nr-nota-fis  = nota-fiscal.nr-nota-fis
                  AND ped-fiscal.cod-emitente = nota-fiscal.cod-emitente:

                ASSIGN ped-fiscal.motivo      = ped-fiscal.motivo + " Nota Cancelada: " + nota-fiscal.nr-nota-fis + "/" + nota-fiscal.serie.


            END.
        END.
        ELSE DO:
             FIND ped-venda
                  WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli
                    AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli EXCLUSIVE-LOCK NO-ERROR.
             IF AVAIL ped-venda THEN DO:
                 ASSIGN ped-venda.cod-priori = 99.
             END.
        END.

        /*
        /* SupplierCard - Cria uma pendància para que o cancelamento sej† enviado para a SupplierCard */
        ASSIGN c-nr-transacao = STRING(INT(nota-fiscal.cod-estabel), "9999") + STRING(INT(nota-fiscal.serie), "999") + STRING(INT(nota-fiscal.nr-nota-fis), "9999999").

        /* S¢ ir† criar uma pendància para a NF se ela foi enviada para a SupplierCard (existir alguma ocorrància para a NF) */

        IF  CAN-FIND(FIRST int-emitente-supcard-ocor NO-LOCK
                     WHERE int-emitente-supcard-ocor.num-transac = c-nr-transacao) THEN DO:

            FIND FIRST emitente NO-LOCK
                WHERE  emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.

            /* Verifica se a raiz do cnpj n∆o est† cadastrado como exceá∆o para envio */
            ASSIGN l-continua-pendencia = YES.
            IF LENGTH(TRIM(emitente.cgc)) = 14 THEN DO: /* Verifica se Ç PJ atravÇs da quantidade de digitos do cnpj */
                IF CAN-FIND(excecao_envio_sc NO-LOCK
                        WHERE excecao_envio_sc.raiz_cnpj = SUBSTRING(TRIM(emitente.cgc),1,8) 
                          AND excecao_envio_sc.lg_cancelamento = YES) THEN DO:
                    RUN utp/ut-msgs.p(INPUT "msg",
                                      INPUT 27979,
                                      INPUT "N∆o foi gerada pendància SupplierCard!~~"
                                          + "Cliente est† cadastrado para envio manual de pendàncias para o SupplierCard.").
                    ASSIGN l-continua-pendencia = NO.
                END.
            END.

            IF l-continua-pendencia = YES THEN DO:
                CREATE int-pendencias-supcard.
                ASSIGN int-pendencias-supcard.dat-criacao     = TODAY
                       int-pendencias-supcard.cod-usuar       = c-seg-usuario
                       int-pendencias-supcard.identific       = 03 /* Cancelamento Total de Compra */
                       int-pendencias-supcard.cnpj-cliente    = IF AVAIL emitente THEN emitente.cgc ELSE ""
                       int-pendencias-supcard.cod-estab       = nota-fiscal.cod-estabel
                       int-pendencias-supcard.cod-espec-docto = "DM"
                       int-pendencias-supcard.cod-ser-docto   = nota-fiscal.serie
                       int-pendencias-supcard.cod-tit-acr     = nota-fiscal.nr-nota-fis
                       int-pendencias-supcard.cod-parcela     = "01".
            END.
        END.
        ELSE DO:
            FOR EACH  int-nfs-supcard EXCLUSIVE-LOCK
                WHERE int-nfs-supcard.cod-estabel = nota-fiscal.cod-estabel
                AND   int-nfs-supcard.serie       = nota-fiscal.serie
                AND   int-nfs-supcard.nr-nota-fis = nota-fiscal.nr-nota-fis:
                DELETE int-nfs-supcard.
            END.
        END.*/
    /* SupplierCard - FIM */
        FIND int-cond-pagto
             WHERE int-cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag
             NO-LOCK NO-ERROR.
        IF AVAIL int-cond-pagto AND
           int-cond-pagto.transacao-com-cartao = YES THEN  DO:
            ASSIGN l-achou-usuario = NO.

            for each ponto-programa
                 where ponto-programa.nome-programa = "ft2200"
                   AND ponto-programa.ponto         = 1,
                  EACH conteudo-programa NO-LOCK
                 WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

                IF conteudo-programa.conteudo = v_cod_usuar_corren THEN DO:
                   ASSIGN l-achou-usuario = YES.
                END.
            END.
            IF l-achou-usuario = YES THEN DO:
                RUN piEnviaEmailCartaoIntelbras.
            END.
        END.

        FIND natur-oper
            WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao 
            NO-LOCK NO-ERROR.
        IF AVAIL natur-oper AND
           natur-oper.tipo = 2 THEN DO:
            IF CAN-find(FIRST cont-emit no-lock
                where cont-emit.cod-emitente = nota-fiscal.cod-emitente 
                  and (cont-emit.nome        BEGINS 'NFE'
                   or cont-emit.nome         BEGINS 'NF-e')) THEN DO:
               ASSIGN c-email-destino = "".
               FOR each cont-emit no-lock
                    where cont-emit.cod-emitente = nota-fiscal.cod-emitente 
                      and (cont-emit.nome        BEGINS 'NFE'
                       or cont-emit.nome         BEGINS 'NF-e'):
                   IF c-email-destino = "" THEN
                      ASSIGN c-email-destino = trim(cont-emit.e-mail).
                   ELSE
                      ASSIGN c-email-destino = trim(c-email-destino) + "," + trim(cont-emit.e-mail).
               END.
               RUN piEnviaEmailGeral.
            END.
            ELSE DO:
                find first emitente no-lock
                     where emitente.cod-emitente = nota-fiscal.cod-emitente no-error.       
                ASSIGN c-email-destino = emitente.e-mail.
                RUN piEnviaEmailGeral.
            END.
        END.


        IF AVAIL natur-oper
           AND   natur-oper.especie = "NFT" THEN DO:
            FIND estabelec
                 WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel
                 NO-LOCK NO-ERROR.
            FIND docum-est
                WHERE docum-est.cod-emitente = estabelec.cod-emitente
                  AND docum-est.serie-docto  = nota-fiscal.serie
                  AND docum-est.nro-docto    = nota-fiscal.nr-nota-fis
                  AND docum-est.nat-operacao = natur-oper.nat-comp
                NO-LOCK NO-ERROR.


            IF AVAIL docum-est AND
               docum-est.CE-atual = NO THEN DO:
                RUN inbo/boin090.p PERSISTENT SET h-boin090.    
                RUN openQueryStatic IN h-boin090 (INPUT "Main":U).
                RUN goToKey2 IN h-boin090 (INPUT docum-est.serie, 
                                           INPUT docum-est.nro-docto,
                                           INPUT docum-est.cod-emitente, 
                                           INPUT docum-est.nat-operacao).
                run emptyRowErrors in h-boin090.
                run deleteRecord in h-boin090.
                run getRowErrors in h-boin090 (output table RowErrors).
                DELETE PROCEDURE h-boin090.

                if  can-find(first RowErrors
                    where RowErrors.ErrorType <> "INTERNAL":U) then do:
                    FOR EACH rowErrors:
                        RUN utp/ut-msgs.p(INPUT "msg",
                                             INPUT 27979,
                                             INPUT rowErrors.Errordescription).

                    END.
                end.
                ELSE
                    PUT "Documento Eliminado DO RE1001 "
                        estabelec.cod-emitente    " "
                        nota-fiscal.serie         " "
                        nota-fiscal.nr-nota-fis   " "
                        nota-fiscal.nat-operacao    SKIP.


            END.
            ELSE IF AVAIL DOCUM-EST AND
                    DOCUM-EST.CE-ATUAL = YES THEN
                    RUN utp/ut-msgs.p(INPUT "msg",
                         INPUT 27979,
                         INPUT "Documento atualizado NO recebimento, n∆o Ç permitido o cancelamento, entrar em contato com grupo.fiscal").
        END.

        IF CAN-FIND(FIRST int-ped-item-astec
                    WHERE int-ped-item-astec.cod-estabel = nota-fiscal.cod-estabel
                      AND int-ped-item-astec.serie       = nota-fiscal.serie
                      AND int-ped-item-astec.nr-nota-fis = nota-fiscal.nr-nota-fis) THEN DO:

            RUN esp/crm/escrm001api.p PERSISTENT SET h-escrm001api.

            RUN IntegraNFCanceladaASTEC IN h-escrm001api (INPUT nota-fiscal.cod-estabel,
                                                          INPUT nota-fiscal.serie,
                                                          INPUT nota-fiscal.nr-nota-fis).

            DELETE PROCEDURE h-escrm001api.

            ASSIGN h-escrm001api = ?.

            RUN esapi/esapi018.p PERSISTENT SET h-esapi018.

            RUN cancelarNotaFiscal IN h-esapi018 (INPUT nota-fiscal.cod-estabel,
                                                  INPUT nota-fiscal.serie,
                                                  INPUT nota-fiscal.nr-nota-fis).

            DELETE PROCEDURE h-esapi018.

            ASSIGN h-esapi018 = ?.
        END.

        /* Tratamento WMS - Desatualiza  */
        RUN esp/wmp/eswmpapi006.p( INPUT nota-fiscal.cod-estabel, OUTPUT l-wms-estab-ativo).
        IF  l-wms-estab-ativo THEN DO:
            ASSIGN log-erro-wms = NO.

            IF NOT VALID-HANDLE(h-eswmpapi004) THEN
                RUN esp/wmp/eswmpapi004.p PERSISTENT SET h-eswmpapi004.

            FOR EACH fat-ser-lote OF nota-fiscal NO-LOCK,
                FIRST deposito OF fat-ser-lote WHERE
                    deposito.log-gera-wms = YES NO-LOCK:
                
                RUN piDesatualizaWMS IN h-eswmpapi004 (INPUT  ROWID(nota-fiscal),
                                                       OUTPUT TABLE RowErrors).
                ASSIGN log-erro-wms = CAN-FIND(FIRST RowErrors) AND RETURN-VALUE <> "OK".
                LEAVE.
            END.

            DELETE PROCEDURE h-eswmpapi004.
            ASSIGN h-eswmpapi004 = ?.

            /* grava data do cancelamento da NF na tabela de integraá∆o */
            FOR EACH integra-mft-wms-notas EXCLUSIVE-LOCK
                WHERE integra-mft-wms-notas.cod-estabel = nota-fiscal.cod-estabel
                  AND integra-mft-wms-notas.serie       = nota-fiscal.serie
                  AND integra-mft-wms-notas.nr-nota-fis = nota-fiscal.nr-nota-fis:

                ASSIGN integra-mft-wms-notas.dt-cancel = nota-fiscal.dt-cancela.
                
            END.
            RELEASE integra-mft-wms-notas. 

        END. 
    END.
END.
            


PROCEDURE piEnviaEmailCartaoIntelbras:
    DEFINE VARIABLE cDestinatarioEmail   AS CHARACTER  NO-UNDO INITIAL ''.
    DEFINE VARIABLE cMensagem            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vArqMail             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
    DEF VAR i-nr-pedido LIKE ped-fiscal.nr-pedido NO-UNDO.


    FOR EACH tt-mail.
        DELETE tt-mail.
    END.
    
    
    RUN esp/es0018p.p (INPUT "ft2200rp", /* Nome do programa */
                       INPUT 2,        /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    for each tt-prog-ponto:
        assign cDestinatarioEmail = cDestinatarioEmail + ENTRY(1, tt-prog-ponto.conteudo,";") + ";" .
    END.
    
    
    find first ped-fiscal no-lock where
         ped-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis no-error.
    if avail ped-fiscal then
         assign i-nr-pedido = ped-fiscal.nr-pedido.
    else assign i-nr-pedido = 0.

    ASSIGN cMensagem =  "Nota Fiscal Cancelada - TRANSACAO COM CARTAO" +                               CHR(10) + 
                        "   Serie: "     + nota-fiscal.serie           + CHR(10) + 
                        " Cliente: "     + string(nota-fiscal.cod-emitente)    + CHR(10) + 
                        "  Numero: "     + nota-fiscal.nr-nota-fis     + CHR(10) + 
                        "Natureza: "     + nota-fiscal.nat-operacao    + CHR(10) +
                        "  Pedido: "     + nota-fiscal.nr-pedcli       + CHR(10) +
                        "  Motivo: "     + nota-fiscal.desc-cancela    + CHR(10).

    ASSIGN vArqMail = SESSION:TEMP-DIRECTORY + "EnvMailCancNF.txt".
    OUTPUT STREAM arq-email TO VALUE(vArqMail).
    PUT STREAM arq-email cMensagem FORMAT 'x(2000)'.
    OUTPUT STREAM arq-email CLOSE.

    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = cDestinatarioEmail
           tt-mail.Assunto       = "Nota Fiscal Cancelada - TRANSACAO COM CARTAO : " + 
                                    nota-fiscal.serie + "/" +  
                                    string(nota-fiscal.nr-nota-fis)
           tt-mail.Mensagem      = cMensagem
           tt-mail.Arquivo       = vArqMail.
    ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".

    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END PROCEDURE.
PROCEDURE pi-calcula-chave:
    FIND natur-oper WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.

    FOR FIRST param-nf-estab NO-LOCK
        WHERE param-nf-estab.cod-estabel = nota-fiscal.cod-estabel:
    END.
    
    
    find natur-oper no-lock where
        natur-oper.nat-operacao = nota-fiscal.nat-operacao no-error.
        
    assign c-serie-nfe = nota-fiscal.serie.
    
    
    for first emitente no-lock
        where emitente.cod-emitente = nota-fiscal.cod-emitente:
    end.
     
    if nota-fiscal.serie = "" then
       assign c-serie-nfe = "000".
    else do:
        if length(c-serie-nfe) < 3 then do:
            assign c-serie-nfe = if length(c-serie-nfe) = 1 then
                                     "00" + c-serie-nfe
                                 else "0" + c-serie-nfe.
        end.
        else
            if length(c-serie-nfe) > 3 then
               assign c-serie-nfe = substring(c-serie-nfe,1,3).
    end.
    
    
    if length(nota-fiscal.nr-nota-fis) < 9 then do:
        assign c-nota-nfe = string(int(nota-fiscal.nr-nota-fis),"999999999").
    end.
    else
        if length(nota-fiscal.nr-nota-fis) = 9 then
            assign c-nota-nfe = nota-fiscal.nr-nota-fis.
        else
            assign c-nota-nfe = substring(nota-fiscal.nr-nota-fis,1,9).
    
    find b-estab-nfe no-lock where
         b-estab-nfe.cod-estabel = nota-fiscal.cod-estabel no-error.
    if not available b-estab-nfe then
        return "NOK":U.

    find unid-feder no-lock where
         unid-feder.pais   = b-estab-nfe.pais   and
         unid-feder.estado = b-estab-nfe.estado no-error.
    
    assign c-chave-nfe = (if avail unid-feder then unid-feder.cod-uf-ibge else "00") +
                         substring(string(year(nota-fiscal.dt-emis-nota),"9999"),3,2)     +
                         string(month(nota-fiscal.dt-emis-nota),"99")                     +
                         (if length(b-estab-nfe.cgc) = 9 then "000" + b-estab-nfe.cgc else b-estab-nfe.cgc) +
                         (if avail natur-oper and natur-oper.cod-model-nf-eletro <> "" then natur-oper.cod-model-nf-eletro /*natur-oper.cod-model-nf-eletro*/ else "00") +
                         c-serie-nfe +
                         c-nota-nfe  +
                         STRING(nota-fiscal.idi-forma-emis-nf-eletro, "9") +
                         STRING(RANDOM(1,99999999),"99999999").
                                                  
    
    assign i-mult-nfe = 2.
    do i-count-nfe = length(c-chave-nfe) to 1 by -1:
        assign i-soma-mod-nfe = i-soma-mod-nfe + (int(substring(c-chave-nfe,i-count-nfe,1)) * i-mult-nfe).
    
        assign i-mult-nfe = i-mult-nfe + 1.
        if i-mult-nfe = 10 then
            assign i-mult-nfe = 2.
    end.
    
    if i-soma-mod-nfe MODULO 11 = 0 or
       i-soma-mod-nfe MODULO 11 = 1 then
        assign i-dig-ver-nfe = 0.
    else
        assign i-dig-ver-nfe = 11 - (i-soma-mod-nfe MODULO 11).
        
    assign c-chave-nfe = c-chave-nfe + string(i-dig-ver-nfe).
        
END PROCEDURE.

PROCEDURE piEnviaEmailGeral:

    DEFINE VARIABLE cMensagem            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vArqMail             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
    DEF VAR i-nr-pedido LIKE ped-fiscal.nr-pedido NO-UNDO.
    DEFINE VARIABLE c-dir  AS CHARACTER   NO-UNDO.
    
    
    FOR EACH tt-mail.
        DELETE tt-mail.
    END.

  
    ASSIGN c-dir = ''.
    IF OPSYS = "UNIX" THEN DO:
        for first ponto-programa
              where ponto-programa.nome-programa = "Colaboracao":U
                AND ponto-programa.ponto         = 1,
               EACH conteudo-programa NO-LOCK
              WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                AND conteudo-programa.sequencia    = int(nota-fiscal.cod-estabel):
             assign c-dir = ENTRY(1,conteudo-programa.conteudo).
        END.
    END.
    ELSE IF OPSYS = "WIN32" THEN DO:
        FOR EACH param-gener WHERE param-gener.cod-chave-1 = "param-geral-tc" NO-LOCK:
         IF param-gener.cod-param = "dir-doctos-lidos" THEN
           ASSIGN c-dir = param-gener.cod-valor.
        END.
    END.

    IF SEARCH(c-dir + '~\' + trim(nota-fiscal.cod-chave-aces-nf-eletro) + '.xml') <> ? THEN
        ASSIGN vArqMail   = c-dir + '~\' + trim(nota-fiscal.cod-chave-aces-nf-eletro) + '.xml'.

    ASSIGN cMensagem =  "A Nfe n." + string(nota-fiscal.nr-nota-fis) +
                        " sÇrie " + nota-fiscal.serie +
                        " com a chave de acesso n." +   trim(nota-fiscal.cod-chave-aces-nf-eletro) +
                        " foi cancelada com o protocolo " + trim(nota-fiscal.cod-protoc) +
                        " dia " + string(TODAY) +
                        " as " + STRING(TIME,"HH:MM:SS") +
                        ".".
    
/*     ASSIGN vArqMail = SESSION:TEMP-DIRECTORY + "EnvMailCancNF.txt" + vArqMail. */
/*     OUTPUT STREAM arq-email TO VALUE(vArqMail).                                */
/*     PUT STREAM arq-email cMensagem FORMAT 'x(2000)'.                           */
/*     OUTPUT STREAM arq-email CLOSE.                                             */
    
    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = c-email-destino
           tt-mail.Assunto       = "Nota Fiscal Cancelada " + 
                                    nota-fiscal.serie + "/" +  
                                    string(nota-fiscal.nr-nota-fis)
           tt-mail.Mensagem      = cMensagem
           tt-mail.Arquivo       = vArqMail.
    ASSIGN tt-mail.Remetente = "nfesaida@intelbras.com.br".
    
    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END PROCEDURE.

PROCEDURE piEnviaEmailFinanc:
    DEFINE VARIABLE pCodUsuario AS CHAR NO-UNDO.

    DEFINE VARIABLE cDestinatarioEmail   AS CHARACTER  NO-UNDO INITIAL ''.
    DEFINE VARIABLE cMensagem            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vArqMail             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
    
    ASSIGN cDestinatarioEmail = "tesouraria@intelbras.com.br;grupo.tributario@intelbras.com.br".

    FOR EACH tt-mail.
        DELETE tt-mail.
    END.
    
    FIND emitente
         WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
         NO-LOCK NO-ERROR.

    ASSIGN cMensagem = "Foi cancelada a NF de devoluá∆o N. " + STRING(nota-fiscal.nr-nota-fis) + 
                       ", fornecedor " + string(nota-fiscal.cod-emitente) + " - " + emitente.nome-emit +  CHR(10) + CHR(10) +
                       "Valor Mercadoria : " + STRING(nota-fiscal.vl-mercad) + CHR(10) + 
                       "     Valor Total : " + STRING(nota-fiscal.vl-tot-nota) + CHR(10) + CHR(10) .

    ASSIGN cMensagem   = cMensagem + 
                             "Item    Descricao                                       Qt Nota Origem" + CHR(10) +
                             "------- ------------------------------------ ------------- -----------" + CHR(10).

    for each it-nota-fisc of nota-fiscal,
        first item fields(it-codigo desc-item) no-lock 
        where item.it-codigo = it-nota-fisc.it-codigo:
        ASSIGN cMensagem = cMensagem +
                           string(it-nota-fisc.it-codigo,"x(07)")  + ' ' +
                           string(item.desc-item,"X(36)")          + ' ' +
                           string(it-nota-fisc.qt-faturada[1],">>>>,>>9.9999") + " " +
                           it-nota-fisc.nr-docum +  CHR(10).
    end.
    
    ASSIGN vArqMail = SESSION:TEMP-DIRECTORY + "EnvMailNF.txt".
    OUTPUT STREAM arq-email TO VALUE(vArqMail).
    PUT STREAM arq-email cMensagem FORMAT 'x(2000)'.
    OUTPUT STREAM arq-email CLOSE.

    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = cDestinatarioEmail
           tt-mail.Assunto       = "Cancelamento Nota Fiscal de Devoluá∆o"
           tt-mail.Mensagem      = cMensagem
           tt-mail.Arquivo       = vArqMail.

    ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".

    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    
    IF  OPSYS <> "UNIX":U THEN DO:
        FOR EACH tt-erro:
            MESSAGE tt-erro.mensagem VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.
END PROCEDURE.
