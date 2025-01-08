/***********************************************************************
**  Programa..: UPC\BODI159-EPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: EPC - BODI159-EPC ONDE:
**              001 - Limpar descontos na implantaá∆o do registro.  
**  Vers∆o....: 001 10/11/2004 - Marcio Chaves
**                  Desenvolvimento Programa
************************************************************************/
{include/i-epc200.i1}

def input param pIndEvent as char no-undo.
def input-output param table for tt-epc.

/* MESSAGE "bodi159-epc.p "  pIndEvent     */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.  */

DEFINE TEMP-TABLE tt-ped-venda NO-UNDO LIKE ped-venda
       FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-pedido-integra NO-UNDO
    FIELD r-rowid AS ROWID
    FIELD i-origem-inegr AS INT /*1 - Pedido, 2 - Faturamento, 3 - Atualiza saldo*/.

DEFINE VARIABLE raw-param          AS RAW NO-UNDO.
DEFINE VARIABLE v_log_nat_deps     AS LOG NO-UNDO.

DEFINE VARIABLE bo-ped-venda-upc-pd4000    AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-bodi159-upc  AS HANDLE     NO-UNDO.
DEFINE VARIABLE bo-ped-venda-cal    AS handle     NO-UNDO.
DEFINE VARIABLE h-cdapi704 AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-rua AS CHARACTER FORMAT "x(70)" NO-UNDO.
DEFINE VARIABLE c-nro  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp AS CHARACTER FORMAT "x(80)" NO-UNDO.

DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-program       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-transp   LIKE transporte.cod-trans        NO-UNDO.
DEFINE VARIABLE c-sigla-transp LIKE def-transportes.sigla-trans NO-UNDO.
DEF BUFFER b-emitente FOR emitente.

DEF BUFFER b-upc-ped-venda FOR  ped-venda.
DEF BUFFER bf-emitente     FOR  emitente.

DEF VAR rRaw AS RAW NO-UNDO.

DEF TEMP-TABLE rowerrors   NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence    AS INT
    FIELD errornumber      AS INT
    FIELD errordescription AS CHAR FORMAT "x(150)"
    FIELD errorparameters  AS CHAR
    FIELD errortype        AS CHAR
    FIELD errorhelp        AS CHAR FORMAT "x(150)"
    FIELD errorsubtype     AS CHAR.

DEFINE VARIABLE hShowMsg AS HANDLE     NO-UNDO.
DEF NEW GLOBAL SHARED VAR vLogLimpaDesc      AS LOGICAL       NO-UNDO.
DEF NEW GLOBAL SHARED VAR vLogLimpaDescItem  AS CHAR          NO-UNDO.
DEF NEW GLOBAL SHARED VAR vLogCopiaPedido    AS LOGICAL       NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-vl-frete-pd4000 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-troca-nf-pd4000 AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-data-negoc-pd4000         AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-dias-negoc-pd4000         AS WIDGET-HANDLE   NO-UNDO.

DEF NEW GLOBAL SHARED TEMP-TABLE tt-ped-copia-upc NO-UNDO
    FIELD nome-abrev   LIKE ped-venda.nome-abrev
    FIELD nr-pedcli    LIKE ped-venda.nr-pedcli
    FIELD cod-rota     LIKE ped-venda.cod-rota.

{utp/ut-glob.i}
{esp/es0018.i}
{esp/esb/esesb000.i}

/*Validar o campo tp-pedido, que passa a guardar o c¢digo do atentente  */
IF pIndEvent = "AfterValidateRecord":U  THEN DO:

    IF  VALID-HANDLE(wh-vl-frete-pd4000) AND
        VALID-HANDLE(wh-troca-nf-pd4000) THEN DO:
        ASSIGN i-cont    = 1
               c-program = "":U.

        REPEAT:
            IF PROGRAM-NAME(i-cont) = ? OR PROGRAM-NAME(i-cont) = "":U THEN
                LEAVE.
            IF INDEX(PROGRAM-NAME(i-cont), "pd4000":U) <> 0 THEN DO:
                ASSIGN c-program = PROGRAM-NAME(i-cont).
                LEAVE.
            END.
            ASSIGN i-cont = i-cont + 1.
        END. /* REPEAT: */

        IF INDEX(c-program, "pd4000":U) <> 0 THEN DO:
            FIND FIRST tt-epc
                WHERE tt-epc.cod-event     = pIndEvent
                  AND tt-epc.cod-parameter = "Object-Handle":U NO-LOCK NO-ERROR.

            IF AVAILABLE tt-epc AND
               VALID-HANDLE(WIDGET-HANDLE(tt-epc.val-parameter)) THEN DO:

                ASSIGN h-bodi159-upc = WIDGET-HANDLE(tt-epc.val-parameter).

                RUN getRecord IN h-bodi159-upc (OUTPUT TABLE tt-ped-venda).

                FIND FIRST tt-ped-venda NO-LOCK NO-ERROR.
                    
                /*Aqui*/                                                                         
                FIND FIRST int-cond-pagto NO-LOCK
                     WHERE int-cond-pagto.cod-cond-pag = tt-ped-venda.cod-cond-pag NO-ERROR.
                
                IF  AVAIL int-cond-pagto
                AND NOT int-cond-pagto.ativa THEN DO:
                    RUN _insertErrorManual IN h-bodi159-upc (INPUT 99999,
                                                             INPUT "EMS",
                                                             INPUT "ERROR",
                                                             INPUT "Condiá∆o de pagamento inativa!",
                                                             INPUT "Condiá∆o de pagamento inativa!",
                                                             INPUT "").
                END.

                FIND FIRST atendente NO-LOCK
                    WHERE atendente.cd-oper = int(tt-ped-venda.tp-pedido) NO-ERROR.

                IF  NOT AVAIL atendente THEN DO:

                    RUN _insertErrorManual IN h-bodi159-upc (INPUT 99999,
                                                             INPUT "EMS",
                                                             INPUT "ERROR",
                                                             INPUT "C¢digo do Atendente inv†lido",
                                                             INPUT "O C¢digo do Atendente no campo Tipo Pedido, Ç inv†lido",
                                                             INPUT "").
                END.
                FIND emitente
                    WHERE emitente.nome-abrev = tt-ped-venda.nome-abrev NO-LOCK NO-ERROR.
                IF AVAIL emitente THEN DO:
                    FIND b-emitente
                        WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-LOCK NO-ERROR.
                    IF NOT AVAIL b-emitente THEN DO:
                       RUN _insertErrorManual IN h-bodi159-upc (INPUT 99999,
                                                               INPUT "EMS",
                                                               INPUT "ERROR",
                                                               INPUT "Matriz DO Cliente nao encontrada NO cadastro, verifique NO CRM e corrija o cadastro",
                                                               INPUT "Matriz DO Cliente nao encontrada NO cadastro, verifique NO CRM e corrija o cadastro",
                                                               INPUT "").
                    END.
                END.


                DELETE tt-ped-venda.
            END.
        END.
    END.

END.

IF pIndEvent = "AfterUpdateRecord":U THEN DO:

    IF  VALID-HANDLE(wh-vl-frete-pd4000) AND
        VALID-HANDLE(wh-troca-nf-pd4000) THEN DO:
        ASSIGN i-cont    = 1
               c-program = "":U.

        REPEAT:
            IF PROGRAM-NAME(i-cont) = ? OR PROGRAM-NAME(i-cont) = "":U THEN
                LEAVE.
            IF INDEX(PROGRAM-NAME(i-cont), "pd4000":U) <> 0 THEN DO:
                ASSIGN c-program = PROGRAM-NAME(i-cont).
                LEAVE.
            END.
            ASSIGN i-cont = i-cont + 1.
        END. /* REPEAT: */
            
        IF INDEX(c-program, "pd4000":U) <> 0 THEN DO:
            FIND FIRST tt-epc
                WHERE tt-epc.cod-event     = pIndEvent
                  AND tt-epc.cod-parameter = "Object-Handle":U NO-LOCK NO-ERROR.

            IF AVAILABLE tt-epc AND
               VALID-HANDLE(WIDGET-HANDLE(tt-epc.val-parameter)) THEN DO:

                ASSIGN h-bodi159-upc = WIDGET-HANDLE(tt-epc.val-parameter).

                RUN getRecord IN h-bodi159-upc (OUTPUT TABLE tt-ped-venda).

                FIND FIRST tt-ped-venda EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL  tt-ped-venda THEN DO:
                    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                        WHERE  int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
                    IF  AVAIL  int-ped-venda THEN DO:
                        ASSIGN int-ped-venda.vl-frete               = DECIMAL(wh-vl-frete-pd4000:SCREEN-VALUE)
                               OVERLAY(int-ped-venda.char-1, 11, 1) = IF wh-troca-nf-pd4000:SCREEN-VALUE = "YES":U THEN "S":U ELSE "N":U.

                        IF  VALID-HANDLE(wh-data-negoc-pd4000) AND
                            VALID-HANDLE(wh-dias-negoc-pd4000) THEN
                            ASSIGN int-ped-venda.dt-negociacao   = DATE(wh-data-negoc-pd4000:SCREEN-VALUE)
                                   int-ped-venda.dias-negociacao = INT(wh-dias-negoc-pd4000:SCREEN-VALUE).
                    END. /* IF AVAIL int-ped-venda THEN DO: */
                    RELEASE int-ped-venda.
                END. /* IF AVAILABLE tt-ped-venda THEN DO: */
            END. /* IF AVAILABLE tt-epc AND VALID-HANDLE(WIDGET-HANDLE(tt-epc.val-parameter)) THEN DO: */
        END. /* IF INDEX(c-program, "pd4000":U) <> 0 THEN DO: */
    END. /* IF VALID-HANDLE(wh-vl-frete-pd4000) THEN DO: */
END.
      
IF pIndEvent = "AfterCreateRecord" OR pIndEvent = "AfterUpdateRecord" THEN DO:
     FIND tt-epc
         WHERE tt-epc.cod-event = pIndEvent
         AND   tt-epc.cod-parameter = "Object-Handle" NO-LOCK NO-ERROR.

     IF AVAIL tt-epc and
        VALID-HANDLE(WIDGET-HANDLE(tt-epc.val-parameter)) THEN
        ASSIGN h-bodi159-upc = WIDGET-HANDLE(tt-epc.val-parameter).
    
    FIND FIRST tt-epc
        WHERE tt-epc.cod-event     = pIndEvent
        AND   tt-epc.cod-parameter = "Table-Rowid"
    NO-LOCK NO-ERROR.

    IF AVAIL tt-epc  THEN DO:
        FIND b-upc-ped-venda
            WHERE ROWID(b-upc-ped-venda) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.

        IF  AVAIL b-upc-ped-venda THEN DO:

            FIND natur-oper
                 WHERE natur-oper.nat-operacao = b-upc-ped-venda.nat-operacao
                 NO-LOCK NO-ERROR.
            FIND emitente 
                 WHERE emitente.cod-emitente = b-upc-ped-venda.cod-emitente
                 NO-LOCK NO-ERROR.

            FIND int-emitente 
                 WHERE int-emitente.cod-emitente = b-upc-ped-venda.cod-emitente
                 NO-LOCK NO-ERROR.

            IF NOT AVAIL INT-emitente  THEN DO:
                RUN _insertErrorManual IN h-bodi159-upc (INPUT 99999,
                                                        INPUT "EMS",
                                                        INPUT "ERROR",
                                                        INPUT "Extens∆o do Emitente Inexistente",
                                                        INPUT "Extens∆o do Emitente Inexistente",
                                                        INPUT "").
                RETURN.
            END.
            ELSE DO:
                IF AVAIL emitente THEN DO:

                   IF  int-emitente.dispositivo-legal <> "" AND
                       int-emitente.dt-vcto-concessao < TODAY THEN DO:
                       RUN _insertErrorManual IN h-bodi159-upc (INPUT 99999,
                                                                INPUT "EMS",
                                                                INPUT "ERROR",
                                                                INPUT "Cliente " + string(b-upc-ped-venda.cod-emitente) + " com data de Concess∆o RS Vencida " + STRING(int-emitente.dt-vcto-concessao) + " - Entre em contato com Controladoria",
                                                                INPUT "Cliente " + string(b-upc-ped-venda.cod-emitente) + " com data de Concess∆o RS Vencida " + STRING(int-emitente.dt-vcto-concessao) + " - Entre em contato com Controladoria",
                                                                INPUT "").
                       RETURN.
                   END.
                   IF emitente.cod-gr-cli <> 8 AND
                       emitente.cod-gr-cli <> 9 and
                       emitente.cod-gr-cli <> 10 and
                       emitente.cod-gr-cli <> 15 and
                       emitente.cod-gr-cli <> 16 THEN DO:
                        IF int-emitente.id-ativo = NO AND
                           natur-oper.emite-duplic = YES THEN DO:
                            RUN _insertErrorManual IN h-bodi159-upc (INPUT 99999,
                                                                    INPUT "EMS",
                                                                    INPUT "ERROR",
                                                                    INPUT "Cliente n∆o esta ativo, n∆o Ç possivel implantar ou efetivar pedidos",
                                                                    INPUT "Cliente n∆o esta ativo, n∆o Ç possivel implantar ou efetivar pedidos",
                                                                    INPUT "").
                            RETURN.
                       END.
                   END.
                   RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
                   RUN pi-trata-endereco IN h-cdapi704 (INPUT  emitente.endereco,
                                                        OUTPUT c-rua, 
                                                        OUTPUT c-nro, 
                                                        OUTPUT c-comp).
                   DELETE PROCEDURE h-cdapi704.
                   IF c-nro = "" THEN DO:
                       RUN _insertErrorManual IN h-bodi159-upc (INPUT 99999,
                                                               INPUT "EMS",
                                                               INPUT "ERROR",
                                                               INPUT "Cliente com endereáo sem numero, favor informar o numero no endereáo do cliente",
                                                               INPUT "Cliente com endereáo sem numero, favor informar o numero no endereáo do cliente",
                                                               INPUT "").
                       RETURN.
                   END.
               END.
            END.
            IF b-upc-ped-venda.nat-operacao = "593311" OR
               b-upc-ped-venda.nat-operacao = "693311"  THEN DO:
                FIND iss-cidad
                     WHERE iss-cidad.nom-cidade = b-upc-ped-venda.cidade
                       AND iss-cidad.cod-estado = b-upc-ped-venda.estado
                       AND iss-cidad.cod-pais   = "Brasil"
                     NO-LOCK NO-ERROR.
                IF NOT AVAIL iss-cidad THEN DO:
                    RUN _insertErrorManual IN h-bodi159-upc (INPUT 99999,
                                                            INPUT "EMS",
                                                            INPUT "ERROR",
                                                            INPUT "CIDADE DO CLIENTE N«O ESTA CADASTRADA NO CD0441. MOTIVO : RETENÄAO DO ISS NA EMISSAO DA NF",
                                                            INPUT "CIDADE DO CLIENTE N«O ESTA CADASTRADA NO CD0441. MOTIVO : RETENÄAO DO ISS NA EMISSAO DA NF",
                                                            INPUT "").
                    RETURN.
                END.
            END.
            IF b-upc-ped-venda.nat-operacao BEGINS "7" THEN DO:

                FOR FIRST rota NO-LOCK
                        WHERE rota.cod-rota = b-upc-ped-venda.cod-rota:
                END.
                IF NOT AVAIL rota THEN DO:
                    RUN _insertErrorManual IN h-bodi159-upc (INPUT 99999,
                                        INPUT "EMS",
                                        INPUT "ERROR",
                                        INPUT "ROTA NAO ENCONTRADA",
                                        INPUT "ROTA NAO ENCONTRADA",
                                        INPUT "").
                    RETURN.
                END.
                FIND unid-feder
                     WHERE unid-feder.pais =  "Brasil"
                       AND unid-feder.estado   = substring(rota.roteiro,1,2)
                     NO-LOCK NO-ERROR.
                IF NOT AVAIL unid-feder THEN DO:
                    RUN _insertErrorManual IN h-bodi159-upc (INPUT 99999,
                                        INPUT "EMS",
                                        INPUT "ERROR",
                                        INPUT "PARA EXPORTACAO ê OBRIGATORIO A INFORMACAO DO ESTADO DO EMBARQUE NA ROTA DO PEDIDO",
                                        INPUT "INFORME UMA ROTA INDICADA PARA EXPORTACAO EM QUE NO ROTEIRO AS DUAS PRIMEIRAS POSIÄÂES SEJA O ESTADO DE EMBARQUE. O PROGRAMA DE CADASTRO DE ROTAS ê O CD0706",
                                        INPUT "").
                    RETURN.
                END.
                
            END.
            /* Verifica se a Transportadora Ç a mesma sugerida pelo programa ESCDP042
               se for informa o campo com Sigla da Transportadora */                       
            
            FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                 WHERE int-ped-venda.nr-pedido = b-upc-ped-venda.nr-pedido NO-ERROR.
            RUN esp/crm/escrm107.p (INPUT b-upc-ped-venda.cod-estabel,
                                    INPUT STRING(b-upc-ped-venda.cod-emitente),
                                    INPUT b-upc-ped-venda.cidade,
                                    INPUT b-upc-ped-venda.estado,
                                    INPUT INT(SUBSTRING(int-ped-venda.char-1,16,3)),
                                    INPUT b-upc-ped-venda.cep,
                                    OUTPUT c-cod-transp,
                                    OUTPUT c-sigla-transp).

            IF c-cod-transp <> ? THEN DO:
                FOR FIRST transporte 
                    WHERE transporte.nome-abrev = b-upc-ped-venda.nome-transp NO-LOCK:

                    IF transporte.cod-transp = c-cod-transp THEN DO:
                        IF AVAIL int-ped-venda THEN
                            ASSIGN OVERLAY(int-ped-venda.char-1,20,5) = c-sigla-transp.
                        RELEASE int-ped-venda.
                    END.
                END.
            END.
        END.
    END.
END.
       
CASE pIndEvent:
    WHEN "AfterCreateRecord" THEN
    DO:
        FOR EACH  tt-epc
            WHERE tt-epc.cod-event     = pIndEvent
            AND   tt-epc.cod-parameter = "Table-Rowid":
               RUN piLimpaDescontos.
        END.
    END.
    WHEN "BeforeDeleteRecord" THEN
    DO:

        FOR EACH  tt-epc
            WHERE tt-epc.cod-event     = pIndEvent
            AND   tt-epc.cod-parameter = "Table-Rowid":
            FOR FIRST b-upc-ped-venda NO-LOCK
                WHERE ROWID(b-upc-ped-venda) = TO-ROWID(tt-epc.val-parameter):
            END.

            /*Integraá∆o cancelamento de pedido DEPS*/
            CREATE tt-pedido-integra.
            ASSIGN tt-pedido-integra.r-rowid = ROWID(b-upc-ped-venda)
                   tt-pedido-integra.i-origem-inegr = 4.

            RAW-TRANSFER tt-pedido-integra TO raw-param.  

            FIND FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente = b-upc-ped-venda.cod-emitente NO-ERROR.

            IF  AVAIL int-emitente THEN DO:
                ASSIGN v_log_nat_deps = YES.

                EMPTY TEMP-TABLE tt-prog-ponto.
                RUN esp/es0018p.p (INPUT "dps-nat-oper",
                                   INPUT 1,
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

                IF  CAN-FIND (FIRST tt-prog-ponto
                                 WHERE tt-prog-ponto.conteudo = string(b-upc-ped-venda.nat-operacao)) THEN
                    ASSIGN v_log_nat_deps = NO.

                EMPTY TEMP-TABLE tt-prog-ponto.
                RUN esp/es0018p.p (INPUT "dps-canal-vd",
                                   INPUT 1,
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

                IF  CAN-FIND (FIRST tt-prog-ponto
                                 WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:

                    IF  v_log_nat_deps = yes /* garantia */ THEN DO:
                        RUN esp/trgw/wdi154a.p (INPUT raw-param,
                                                INPUT 'msg0310',
                                                OUTPUT TABLE resultado).

                        IF  RETURN-VALUE <> "OK" THEN DO:
                            /*FIND FIRST resultado.

                            RUN setInterrompeCalculo IN hbodi317ef (INPUT YES).
                            RUN _insertErrorManual IN hbodi317ef (INPUT 0,
                                                                  INPUT "EMS",
                                                                  INPUT "ERROR",
                                                                  INPUT v_desc_bloq,
                                                                  INPUT resultado.mensagem,
                                                                  INPUT "").

                            RETURN "NOK".*/
                        END.
                    END.
                END.
            END.

/*             IF b-upc-ped-venda.cod-estabel = "102" THEN DO:                                                                                  */
/*                                                                                                                                        */
/*                 RUN _insertErrorManual IN bo-ped-venda (INPUT 99999,                                                                   */
/*                                                         INPUT "EMS",                                                                   */
/*                                                         INPUT "ERROR",                                                                 */
/*                                                         INPUT "Pedido Estabelecimento 102 n∆o Ç permitido Eliminaá∆o - (bodi159-epc)", */
/*                                                         INPUT "Pedido Estabelecimento 102 n∆o Ç permitido Eliminaá∆o - (bodi159-epc)", */
/*                                                         INPUT "").                                                                     */
/*                 RETURN "NOK":U.                                                                                                        */
/*                                                                                                                                        */
/*             END.                                                                                                                       */
/*             FOR EACH nota-entr-saida                                                  */
/*                 where nota-entr-saida.nr-pedido = b-upc-ped-venda.nr-pedido EXCLUSIVE-LOCK: */
/*                 DELETE nota-entr-saida.                                               */
/*             END.                                                                      */
        END.
    END.
    WHEN "AfterValidateRecord" THEN DO:
        FIND FIRST tt-epc NO-LOCK
            WHERE  tt-epc.cod-event = pIndEvent
            AND    tt-epc.cod-parameter = "Object-Handle" NO-ERROR.
        IF  AVAIL  tt-epc THEN
            ASSIGN h-bodi159-upc = WIDGET-HANDLE(tt-epc.val-parameter).

        FIND FIRST tt-epc NO-LOCK
            WHERE  tt-epc.cod-event     = pIndEvent
            AND    tt-epc.cod-parameter = "Table-Rowid" NO-ERROR.
        IF  AVAIL  tt-epc THEN DO:
            FIND FIRST ped-venda NO-LOCK
                WHERE  ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
            IF  AVAIL  ped-venda THEN DO:
                /* Valida se o Pedido est† sendo transferido de um estabelecimento para outro (esftp079) */
                IF  CAN-FIND(FIRST ped-transf NO-LOCK
                             WHERE ped-transf.nome-abrev = ped-venda.nome-abrev
                             AND   ped-transf.nr-pedcli  = ped-venda.nr-pedcli) THEN DO:
                    RUN _insertErrorManual IN h-bodi159-upc (INPUT 99999,
                                                             INPUT "EMS",
                                                             INPUT "ERROR",
                                                             INPUT "Pedido em processo de Transferància. Aguarde o processo finalizar para alterar o pedido.",
                                                             INPUT "O pedido n∆o pode ser alterado pois est† em processo de Transferància entre Estabelecimentos!",
                                                             INPUT "").


                END.
                FIND int-cond-pagto
                    WHERE int-cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.

                IF AVAIL int-cond-pagto and
                   SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:
                     FIND int-ped-venda
                         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                         NO-LOCK NO-ERROR.
                     IF AVAIL int-ped-venda AND
                        (int-ped-venda.dt-negociacao <> ? OR
                         int-ped-venda.dias-negociacao <> 0) THEN DO:
                            RUN _insertErrorManual IN h-bodi159-upc (INPUT 99999,
                                                                     INPUT "EMS",
                                                                     INPUT "ERROR",
                                                                     INPUT "Pedido com condicao de pagamento de Cartao Intelbras Club nao Ç permitido dias de negociacao e data negociacao informado",
                                                                     INPUT "Pedido com condicao de pagamento de Cartao Intelbras Club nao Ç permitido dias de negociacao e data negociacao informado!",
                                                                     INPUT "").
                     END.

                END.
            END.
        END.
    END.
END CASE.

/* PROCEDURE piCalculaPedido: */
/*     DEFINE INPUT PARAM pRowid AS ROWID NO-UNDO. */
/*    */
/*     if not valid-handle(bo-ped-venda-cal) or */
/*        bo-ped-venda-cal:type <> "PROCEDURE":U or */
/*        bo-ped-venda-cal:file-name <> "dibo/bodi159cal.p" then */
/*         run dibo/bodi159cal.p persistent set bo-ped-venda-cal. */
/*    */
/*     IF VALID-HANDLE(bo-ped-venda-cal) THEN */
/*     DO: */
/*         RUN calculateOrder in bo-ped-venda-cal(input pRowid). */
/*         DELETE PROCEDURE bo-ped-venda-cal. */
/*     END. */
/*    */
/* END PROCEDURE. */

PROCEDURE piLimpaDescontos:
    FOR FIRST b-upc-ped-venda NO-LOCK
        WHERE ROWID(b-upc-ped-venda) = TO-ROWID(tt-epc.val-parameter): 

        IF NOT VALID-HANDLE(bo-ped-venda-upc-pd4000)        OR 
           bo-ped-venda-upc-pd4000:TYPE <> "PROCEDURE":U   OR 
           bo-ped-venda-upc-pd4000:FILE-NAME <> "dibo/bodi159.p" THEN 

           RUN dibo/bodi159.p PERSISTENT SET bo-ped-venda-upc-pd4000.

/*         IF  NOT vLogLimpaDesc THEN */
/*             RUN utp/ut-msgs.p (input "SHOW", */
/*                                input 27100, */
/*                                input "ParÉmetro Limpa Descontos n∆o foi selecionado. Deseja manter os descontos padr∆o do EMS?" + "~~" + */
/*                                      "Caso deseja limpar os descontos normalmente, basta selecionar N«O."). */
/*         IF  RETURN-VALUE = "YES" OR NOT vLogLimpaDesc THEN */
/*              ASSIGN vLogLimpaDescItem = "NO". */
/*         ELSE ASSIGN vLogLimpaDescItem = "YES" */
/*                     vLogLimpaDesc     = YES. */


        /*
        001 - Limpa Informaá‰es de descontos calculados no pedido de venda.
        */
        RUN EmptyRowErrors     IN bo-ped-venda-upc-pd4000.
        RUN setConstraintRowid IN bo-ped-venda-upc-pd4000 (INPUT ROWID(b-upc-ped-venda)).
        RUN openQueryStatic    IN bo-ped-venda-upc-pd4000 (INPUT "Rowid":U).
        RUN getRecord          IN bo-ped-venda-upc-pd4000 (OUTPUT TABLE tt-ped-venda).
        FOR FIRST tt-ped-venda. END.
/*         IF vLogLimpaDesc OR RETURN-VALUE = "NO" THEN */
/*         DO: */
/*             ASSIGN tt-ped-venda.des-pct-desconto-inform    = "" */
/*                    tt-ped-venda.perc-desco1                = 0 */
/*                    tt-ped-venda.perc-desco2                = 0 */
/*                    tt-ped-venda.val-pct-desconto-valor     = 0 */
/*                    tt-ped-venda.val-pct-desconto-total     = 0 */
/*                    tt-ped-venda.val-pct-desconto-tab-preco = 0 */
/*                    tt-ped-venda.val-desconto-total         = 0. */
/*         end. */
        
        find int-emitente
             where int-emitente.cod-emitente = tt-ped-venda.cod-emitente no-lock no-error.
        if avail int-emitente then do:
           assign tt-ped-venda.observacoes = tt-ped-venda.observacoes + " " + int-emitente.observacao-ped.
        end.

       
        RUN setRecord           IN bo-ped-venda-upc-pd4000 (INPUT TABLE tt-ped-venda).
        RUN UpdateRecord        IN bo-ped-venda-upc-pd4000.
        RUN getRowErrors        IN bo-ped-venda-upc-pd4000 (OUTPUT TABLE RowErrors). 
        
/*         FOR EACH RowErrors: */
/*    */
/*             /* na copia de pedidos vendor, ao fazer o update os dados de */
/*                vendor ainda n∆o foram copiado e o sistema estava retornando a */
/*                mensagem abaixo. por isso o motivo da eliminaá∆o do erro. */ */
/*    */
/*             IF  RowErrors.ErrorNumber = 18790 */
/*             AND RowErrors.ErrorDescription = "Informaá‰es para vendor n∆o encontradas." THEN */
/*                 DELETE RowErrors. */
/*         END. */
/*    */
/*         IF  CAN-FIND(FIRST RowErrors */
/*                      WHERE RowErrors.ErrorType <> "INTERNAL":U) then do: */
/*             {method/showmessage.i1} */
/*             {method/showmessage.i2 &Modal=YES} */
/*         END. */

        IF  VALID-HANDLE(bo-ped-venda-upc-pd4000) THEN DO:
            RUN destroyBO IN bo-ped-venda-upc-pd4000.
            RUN destroy   IN bo-ped-venda-upc-pd4000.
            IF  VALID-HANDLE(bo-ped-venda-upc-pd4000) THEN DELETE PROCEDURE bo-ped-venda-upc-pd4000.
        END.
        IF  VALID-HANDLE(bo-ped-venda-upc-pd4000) THEN DELETE PROCEDURE bo-ped-venda-upc-pd4000.
        
/*      RUN piCalculaPedido(INPUT ROWID(ped-venda)). */

    END. /* FOR FIRST b-upc-ped-venda
     NO-LOCK */
    /* CHAVES em 08/03/2005 para resolver problema PROWIN32 */
    IF  VALID-HANDLE(bo-ped-venda-upc-pd4000) THEN DO:
        RUN destroyBO IN bo-ped-venda-upc-pd4000.
        RUN destroy   IN bo-ped-venda-upc-pd4000.
    END.
    IF  VALID-HANDLE(bo-ped-venda-upc-pd4000) THEN DELETE PROCEDURE bo-ped-venda-upc-pd4000.
END PROCEDURE.

