/*----------------------------------------------------------------*/
/*  Programa..: esp/esb/esesbapi007-solicita.p                    */
/*  Objetivo..: Api Controle de Solicitaá‰es via Portal           */
/*  Autor.....: Roger Marcelino Bruhn                             */
/*  Data......: 08/08/2014                                        */
/*----------------------------------------------------------------*/

DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

{esp/esb/esesbapi007-solicita.i}

{esapi/esapi015tt.i}
{method/dbotterr.i}

{esp/esb/in/msg0093.i}

{esp/es0018.i}
{esp/esb/esesbapi005.i} /* Definiá∆o da tt-central */ 

{esp/esb/esesbapi004-benef.i} /* Temp-table tt-beneficio */

/*Temp-tables com os dados do faturamento/devoluá‰es*/
{esp/esb/esesbapi002.i} /* tt-canal; tt-fat-mensal; tt-fat-mensal-det */
{esp/esb/in/msg9999.i }
{esp/esb/in/msg0152.i1} /*msg0152*/
{esp/esb/in/msg0152.i } /*msg0152-ProdutoSolicitacaoItem*/
{esp/esb/out/msg0160.i} /*msg0160r-FormaPagamentoItem*/

{esp/esb/in/msg0152.i3} /*tt-erro*/
{esp/esb/esesbapi010-saldo.i1}
{esp/esb/esesb007-solicita.i1} 

DEF TEMP-TABLE tt-erro-cancela LIKE tt-erro.
DEF TEMP-TABLE tt-erro-apb     LIKE tt-erro.
DEF TEMP-TABLE tt-erro-saldo   LIKE tt-erro.

DEFINE TEMP-TABLE tt-erro-pedido NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEF TEMP-TABLE tt-erro-benef NO-UNDO LIKE tt-erro.

DEF BUFFER b-int-solicitacao      FOR int-solicitacao.
DEF BUFFER b-int-solicitacao-item FOR int-solicitacao-item.
DEF BUFFER b-tabela-pai-xml       FOR msg0152.
DEF BUFFER b-tabela-filho-xml     FOR msg0152-ProdutoSolicitacaoItem.
DEF BUFFER b-solicitacao-aberta   FOR int-solicitacao.

DEF TEMP-TABLE tt-erro-canal LIKE tt-erro.

DEFINE VARIABLE i-tipo-beneficio      AS INTEGER NO-UNDO.
DEFINE VARIABLE bo-ped-venda-can      AS HANDLE  NO-UNDO.
DEFINE VARIABLE c-erro                AS CHAR FORMAT "X(1000)" NO-UNDO.
DEFINE VARIABLE l-cancelando          AS LOG INIT NO.
DEFINE VARIABLE h-cancela             AS HANDLE NO-UNDO.

DEF BUFFER b-solicitacao-analise FOR int-solicitacao.
DEF BUFFER b_histor_clien        FOR histor_clien.

/* PROCEDURE PRINCIPAL */
PROCEDURE pi-cria-atualiza-solicitacao:

    DEF INPUT  PARAM p-programa-msg AS CHAR FORMAT "X(7)".
    DEF INPUT  PARAM TABLE FOR b-tabela-pai-xml.
    DEF INPUT  PARAM TABLE FOR b-tabela-filho-xml.
    DEF OUTPUT PARAM TABLE FOR tt-saldo.
    DEF OUTPUT PARAM TABLE FOR tt-erro.
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.
  
    DEF VAR l-atendido-total AS LOG INIT YES NO-UNDO.

    /* VERIFICA SE RETORNOU CORRETAMENTE A SOLICITAÄ«O CONSTANTE NO XML */
    FIND FIRST b-tabela-pai-xml NO-ERROR.

    IF  NOT AVAIL b-tabela-pai-xml THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT 'N∆o foi enviado registro de solicitaá∆o.'   ,
                                            INPUT "").
        RETURN "NOK".
    END.

    IF  LENGTH(b-tabela-pai-xml.DescricaoSolicitacao) > 3000 THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "Descriá∆o da solicitaá∆o n∆o pode ultrapassar 3000 caracteres." ,
                                            INPUT "Descriá∆o da solicitaá∆o n∆o pode ultrapassar 3000 caracteres." ).

        RETURN "NOK".

    END.

    IF  CAN-FIND (FIRST int-solicitacao                                 
                    WHERE int-solicitacao.CodigoSolicitacaoBeneficio    = b-tabela-pai-xml.CodigoSolicitacaoBeneficio
                      AND int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 /*Paga*/
                  ) THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "Solicitaá∆o j† foi PAGA no EMS." ,
                                            INPUT "N∆o foi poss°vel executar a aá∆o requerida." ).

        RETURN "NOK".
    END.

    /******* Devido ao problema do CRM enviar 2 vezes a solicitaá∆o quando o usu†rio clica 2 vezes em enviar -  chamado 53084 *******/
    IF  CAN-FIND (FIRST int-solicitacao                                 
                    WHERE int-solicitacao.CodigoSolicitacaoBeneficio    = b-tabela-pai-xml.CodigoSolicitacaoBeneficio
                      AND int-solicitacao.SituacaoSolicitacaoBeneficio = 993520003 /* Pendente */) 
    AND b-tabela-pai-xml.SituacaoSolicitacaoBeneficio = 993520003 THEN DO:
        ASSIGN p-ok = YES.
        RETURN "OK".
    END.
    IF  CAN-FIND (FIRST int-solicitacao                                 
                    WHERE int-solicitacao.CodigoSolicitacaoBeneficio   = b-tabela-pai-xml.CodigoSolicitacaoBeneficio
                      AND int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006 /* Cancelada */)
    AND b-tabela-pai-xml.SituacaoSolicitacaoBeneficio = 993520006 THEN DO:
        ASSIGN p-ok = YES.
        RETURN "OK".
    END.
    /********************************************************************************************************************************/


    IF  b-tabela-pai-xml.SituacaoSolicitacaoBeneficio = 993520004 THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "Solicitaá∆o n∆o pode ser Paga via CRM" ,
                                            INPUT "N∆o foi poss°vel executar a aá∆o requerida." ).

        RETURN "NOK".
    END.

    IF OPSYS = "UNIX" THEN log-manager:write-message("0").

    IF OPSYS = "UNIX" THEN log-manager:write-message("0.1").
    IF  b-tabela-pai-xml.BeneficioCodigo <> 04 /* STOCK BACKUP     */  
    AND b-tabela-pai-xml.BeneficioCodigo <> 08 /* PRICE PROTECTION */ 
    AND b-tabela-pai-xml.BeneficioCodigo <> 15 /* SHOW ROOM        */ 
    AND b-tabela-pai-xml.BeneficioCodigo <> 21 /* VMC              */
    AND b-tabela-pai-xml.BeneficioCodigo <> 22 /* STOCK ROTATION   */
    AND b-tabela-pai-xml.BeneficioCodigo <> 37 /* RABATE           */
    AND b-tabela-pai-xml.BeneficioCodigo <> 66 /* RABATE-P‡S       */ THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT 'Tipo de Benef°cio n∆o pode ser solicitado para o ERP.'   ,
                                            INPUT "").
        RETURN "NOK".
    END.

    IF OPSYS = "UNIX" THEN log-manager:write-message("0.2").
    ASSIGN i-tipo-beneficio = b-tabela-pai-xml.BeneficioCodigo
           l-cancelando     = IF b-tabela-pai-xml.SituacaoSolicitacaoBeneficio = 993520006 THEN YES ELSE NO.

    /*-------------------------------*/
    /*   Validaá∆o e Cancelamento    */
    /*-------------------------------*/
    IF  l-cancelando THEN DO:
        IF OPSYS = "UNIX" THEN log-manager:write-message("l-cancelando 0: " + string(l-cancelando)).
        IF  NOT VALID-HANDLE(h-cancela) THEN
            RUN esp/esb/esesbapi007-cancela.p PERSISTENT SET h-cancela.
        
        DEF VAR l-ok-aux AS LOG INIT NO NO-UNDO.
        RUN pi-valida-cancelamento IN h-cancela (INPUT b-tabela-pai-xml.CodigoSolicitacaoBeneficio,
                                                 OUTPUT TABLE tt-erro-cancela,
                                                 OUTPUT l-ok-aux).
        IF OPSYS = "UNIX" THEN log-manager:write-message("depois pi-valida-cancelamento p-ok: " + string(p-ok)).
        IF  RETURN-VALUE <> "OK" OR NOT l-ok-aux THEN DO:
            FOR EACH tt-erro-cancela:
                RUN pi-cria-erro (INPUT tt-erro-cancela.codigo,
                                  INPUT tt-erro-cancela.mensagem,
                                  INPUT tt-erro-cancela.ajuda).
            END.
            IF  VALID-HANDLE(h-cancela) THEN DO:
                DELETE PROCEDURE h-cancela.
                ASSIGN h-cancela = ?.
            END.

            RETURN "NOK".
        END.

        IF OPSYS = "UNIX" THEN log-manager:write-message("l-cancelando 01: " + string(l-cancelando)).
        /*--------------------------------*/
        /*       EFETUA CANCELAMENTO      */
        /*--------------------------------*/
        IF OPSYS = "UNIX" THEN log-manager:write-message("logo depois p-ok: " + string(p-ok)).
        RUN pi-cancela IN h-cancela (INPUT b-tabela-pai-xml.CodigoSolicitacaoBeneficio,         
                                     INPUT b-tabela-pai-xml.DescartarVerba,
                                     INPUT b-tabela-pai-xml.DescricaoSolicitacao, /*Descriáao atualizada do usu†rio que efetuou o cancelamento*/ 
                                     OUTPUT TABLE tt-erro-cancela,                              
                                     OUTPUT p-ok).                                              
        IF OPSYS = "UNIX" THEN log-manager:write-message("depois pi-cancela p-ok: " + string(p-ok)).
        IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
            FOR EACH tt-erro-cancela:
                RUN pi-cria-erro (INPUT tt-erro-cancela.codigo,
                                  INPUT tt-erro-cancela.mensagem,
                                  INPUT tt-erro-cancela.ajuda).
            END.
            IF  VALID-HANDLE(h-cancela) THEN DO:
                DELETE PROCEDURE h-cancela.
                ASSIGN h-cancela = ?.
            END.
            ASSIGN p-ok = NO.
            RETURN "NOK".
        END.
        ELSE
            IF  VALID-HANDLE(h-cancela) THEN DO:
                DELETE PROCEDURE h-cancela.
                ASSIGN h-cancela = ?.
            END.

        RUN esp/esb/esesbapi010-saldo.p (INPUT ?,
                                         INPUT ?,
                                         INPUT ?,
                                         INPUT ?,
                                         INPUT ?,
                                         INPUT ?,
                                         INPUT b-tabela-pai-xml.CodigoSolicitacaoBeneficio,
                                         OUTPUT p-ok,
                                         OUTPUT TABLE tt-saldo,
                                         OUTPUT TABLE tt-erro-saldo).

        ASSIGN p-ok = YES.
        RETURN "OK".
    END.
                             
     IF OPSYS = "UNIX" THEN log-manager:write-message("passou pelo cancelando").

    /* BUSCAR MENSAGEM DE FORMA DE PAGAMENTO */
    EMPTY TEMP-TABLE tt-erro.
    RUN pi-carrega-forma-pagamento-CRM.

    IF OPSYS = "UNIX" THEN log-manager:write-message("0.3: " + RETURN-VALUE).
    /* VALIDAR FORMA DE PAGAMENTO, PELA DESCRIÄ«O. N«O DEVERµ NUNCA SER ALTERADO O NOME DA FORMA DE PAGAMENTO NO CRM, SEM AVISO PRêVIO AO EMS PARA MUDANÄA DO PROGRAMA */
    RUN pi-valida-forma-pagto.

    IF OPSYS = "UNIX" THEN log-manager:write-message("0.4: " + RETURN-VALUE).
    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    /* VALIDA INFORMAÄÂES PERTINENTES AO CANAL, PARA PERMITIR MOVIMENTAÄÂES */
    RUN pi-valida-canal (b-tabela-pai-xml.CodigoConta).
    IF OPSYS = "UNIX" THEN log-manager:write-message("0.5: " + RETURN-VALUE).
    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    EMPTY TEMP-TABLE tt-erro.

    /* VALIDAR A SOLICITAÄ«O */
    RUN pi-valida-solicitacao (OUTPUT p-ok).
    IF OPSYS = "UNIX" THEN log-manager:write-message("0.6: " + RETURN-VALUE).
    IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN
        RETURN "NOK".

    /*-------------------------------------------------------------------------------------*/
    /*                              TRANSACIONA CRIAÄ«O/ALTERAÄ«O                          */
    /*-------------------------------------------------------------------------------------*/
    DEF VAR i-time-transaction AS INTEGER NO-UNDO.
    
    blk-principal:
    DO TRANSACTION
    ON ERROR UNDO blk-principal,LEAVE blk-principal
    ON STOP  UNDO blk-principal,LEAVE blk-principal:

        IF OPSYS = "UNIX" THEN log-manager:write-message("1").

        /* Monitora tempo de resposta do totvs para o CRM. Caso maior que 100 segundos */
        /* n∆o dever† efetivar a transaá∆o, para garantir a integridade da integraá∆o.  */
        ETIME(TRUE).

        /*-----------------------------------------------------*/
        /*                  SOLICITAÄ«O NORMAL                 */
        /*-----------------------------------------------------*/
        IF  NOT b-tabela-pai-xml.SolicitacaoAjuste THEN DO:
            
            RUN pi-cria-solicitacao-NORMAL (INPUT  p-programa-msg,
                                            OUTPUT p-ok).

            IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
                UNDO blk-principal , RETURN "NOK".                     
            END.
        END.

        IF OPSYS = "UNIX" THEN log-manager:write-message("2").
        /*-----------------------------------------------------*/
        /*              SOLICITAÄ«O AJUSTE DE SALDO            */
        /*-----------------------------------------------------*/
        IF  b-tabela-pai-xml.SolicitacaoAjuste THEN DO:
            
            RUN pi-cria-solicitacao-AJUSTE (INPUT  p-programa-msg,
                                            OUTPUT p-ok) .
            
            IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
                UNDO blk-principal , RETURN "NOK".                     
            END.

        END.
        IF OPSYS = "UNIX" THEN log-manager:write-message("99").


        IF  (i-tipo-beneficio <> 15 AND i-tipo-beneficio <> 04) /* N«O RETORNA SALDO DE SHOW ROOM NEM BACKUP - N«O CONTROLA CONTA CORRENTE */
        AND AVAIL int-cc-benef THEN DO:

            RUN esp/esb/esesbapi010-saldo.p (INPUT int-cc-benef.canal,
                                             INPUT int-cc-benef.tipo-beneficio,
                                             INPUT int-cc-benef.unid-neg,
                                             INPUT int-cc-benef.dt-periodo-ini,
                                             INPUT int-cc-benef.dt-periodo-fim,
                                             INPUT ?,
                                             INPUT ?,
                                             OUTPUT p-ok,
                                             OUTPUT TABLE tt-saldo,
                                             OUTPUT TABLE tt-erro-saldo).

            FIND FIRST tt-saldo NO-ERROR.
            IF  (AVAIL tt-saldo AND tt-saldo.verbaDisponivel < 0) 
            OR  NOT AVAIL tt-saldo THEN DO:
                 RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                     INPUT "Saldo Negativo na conta, n∆o Ç poss°vel incluir a solicitaá∆o." , 
                                                     INPUT "Saldo ficaria negativo em: " +  (IF AVAIL tt-saldo THEN STRING(tt-saldo.verbaDisponivel, ">>>,>>>,>>9.9999") ELSE "0,0000")). 
                 UNDO blk-principal , RETURN "NOK". 
            END.


        END.

        ASSIGN i-time-transaction = ETIME.

        IF  (i-time-transaction  / 1000) > 100 THEN DO:  /* Limite de 1,40 minuto para a transaáao, devido a problemas de time out CRM*/
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "Tempo de processamento no ERP excedido: " + STRING((i-time-transaction  / 1000), ">>>9.99") + " segundo(s)." , 
                                                INPUT "O tempo de processamento ultrapassou o limite acordado para a integraá∆o. Por favor, tente novamente em alguns instantes."). 
           UNDO blk-principal , RETURN "NOK". 

        END.

    END. /* TRANSAÄ«O */

/*     IF  (i-tipo-beneficio <> 15 AND i-tipo-beneficio <> 04) /* N«O RETORNA SALDO DE SHOW ROOM NEM BACKUP - N«O CONTROLA CONTA CORRENTE */  */
/*     AND AVAIL int-cc-benef THEN DO:                                                                                                        */
/*                                                                                                                                            */
/*         RUN esp/esb/esesbapi010-saldo.p (INPUT int-cc-benef.canal,                                                                         */
/*                                          INPUT int-cc-benef.tipo-beneficio,                                                                */
/*                                          INPUT int-cc-benef.unid-neg,                                                                      */
/*                                          INPUT int-cc-benef.dt-periodo-ini,                                                                */
/*                                          INPUT int-cc-benef.dt-periodo-fim,                                                                */
/*                                          INPUT ?,                                                                                          */
/*                                          INPUT ?,                                                                                          */
/*                                          OUTPUT p-ok,                                                                                      */
/*                                          OUTPUT TABLE tt-saldo,                                                                            */
/*                                          OUTPUT TABLE tt-erro-saldo).                                                                      */
/*                                                                                                                                            */
/*     END.                                                                                                                                   */

    ASSIGN p-ok = YES.
    RETURN "OK".
END.


PROCEDURE pi-valida-solicitacao:
    
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    /* UNIDADE DE NEG‡CIO */
    FIND FIRST unid-negoc NO-LOCK
        WHERE unid-negoc.cod-unid-negoc = b-tabela-pai-xml.CodigoUnidadeNegocio NO-ERROR.

    IF  NOT AVAIL unid-negoc THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT 'Unidade de Neg¢cio inexistente' , 
                                            INPUT ""). 
        RETURN "NOK".
    END.

    FIND FIRST int-emitente NO-LOCK
        WHERE int-emitente.cod-guid = b-tabela-pai-xml.CodigoConta NO-ERROR.

    IF   NOT AVAIL int-emitente THEN DO:
         RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                             INPUT "Conta n∆o existe no EMS." , 
                                             INPUT "" ). 
         RETURN "NOK".
    END.

/*     if  (msg0160r-FormaPagamentoItem.NomeFormaPagamento = "Produto" or b-tabela-pai-xml.SolicitacaoAjuste)                */
/*     and  b-tabela-pai-xml.ValorAbater = 0 then                                                                            */
/*          assign b-tabela-pai-xml.ValorAbater = b-tabela-pai-xml.ValorSolicitado.                                          */
/*                                                                                                                           */
/*     IF  b-tabela-pai-xml.ValorSolicitado > b-tabela-pai-xml.ValorAbater                                                   */
/*     AND NOT b-tabela-pai-xml.SolicitacaoAjuste THEN DO:                                                                   */
/*         RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,                                                                  */
/*                                             INPUT "Valor Solicitado n∆o pode ser maior que o valor a Abater da Verba." ,  */
/*                                             INPUT "" ).                                                                   */
/*         RETURN "NOK".                                                                                                     */
/*     END.                                                                                                                  */
        
    if  (msg0160r-FormaPagamentoItem.NomeFormaPagamento = "Produto" or b-tabela-pai-xml.SolicitacaoAjuste)
    and  b-tabela-pai-xml.ValorAbater = 0 then
         assign b-tabela-pai-xml.ValorAbater = b-tabela-pai-xml.ValorAprovado.

    IF  b-tabela-pai-xml.ValorAprovado > b-tabela-pai-xml.ValorAbater 
    AND NOT b-tabela-pai-xml.SolicitacaoAjuste THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "Valor Aprovado n∆o pode ser maior que o valor a Abater da Verba." ,
                                            INPUT "" ).
        RETURN "NOK".
    END.

    /*-------------------------------------------*/
    /*      VALIDAÄÂES SOLICITAÄ«O NORMAIS       */
    /*-------------------------------------------*/
    IF  NOT b-tabela-pai-xml.SolicitacaoAjuste  THEN DO:
        RUN pi-valida-solicitacao-NORMAL (OUTPUT p-ok).
        IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN
            RETURN "NOK".
    END.
    
    /*-------------------------------------------*/
    /* VALIDAÄÂES SOLICITAÄ«O DE AJUSTE DE SALDO */
    /*-------------------------------------------*/
    IF  b-tabela-pai-xml.SolicitacaoAjuste  THEN DO:
        RUN pi-valida-solicitacao-AJUSTE (OUTPUT p-ok).
        IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
            RETURN "NOK".
        END.
    END.

    ASSIGN p-ok = YES.
    RETURN "OK".
END.

PROCEDURE pi-valida-solicitacao-ajuste:
    
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.
    DEF VAR de-disponivel AS DEC NO-UNDO.
    

    /* VALIDAÄ«O DE EXIST“NCIA DE SALDO NA CONTA CORRENTE. */
    FIND LAST int-cc-benef NO-LOCK
        WHERE int-cc-benef.tp-movto       = 2 /*DESPESA*/
          AND int-cc-benef.tipo-beneficio = i-tipo-beneficio
          AND int-cc-benef.unid-neg       = b-tabela-pai-xml.CodigoUnidadeNegocio
          AND int-cc-benef.canal          = int-emitente.cod-emitente
          AND int-cc-benef.id-status      = 1 NO-ERROR. /* ATIVO*/ 

     IF  AVAIL int-cc-benef THEN DO:

         /*-----------------------------------------------------------------------------------------------------*/
         /*                            V A L I D A R   S A L D O   D I S P O N ÷ V E L                          */
         /*-----------------------------------------------------------------------------------------------------*/
         RUN esp/esb/esesbapi010-saldo.p (INPUT int-cc-benef.canal,
                                          INPUT int-cc-benef.tipo-beneficio,
                                          INPUT int-cc-benef.unid-neg,
                                          INPUT int-cc-benef.dt-periodo-ini,
                                          INPUT int-cc-benef.dt-periodo-fim,
                                          INPUT ?,
                                          INPUT ?,
                                          OUTPUT p-ok,
                                          OUTPUT TABLE tt-saldo,
                                          OUTPUT TABLE tt-erro-saldo).

         IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
              FOR EACH tt-erro-saldo:
                 RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                     INPUT tt-erro.mensagem). 
             END.
             RETURN "NOK".
         END.

         FIND FIRST tt-saldo NO-ERROR.
         IF  AVAIL tt-saldo THEN
             ASSIGN de-disponivel = tt-saldo.verbaDisponivel.

         IF OPSYS = "UNIX" THEN log-manager:write-message("de-disponivel: " + string(de-disponivel, "->>>,>>>,>>9.9999") ).

         /* QUANDO O AJUSTE FOR NEGATIVO */
         IF  b-tabela-pai-xml.ValorAbater < 0 THEN DO:
             IF  (de-disponivel + b-tabela-pai-xml.ValorAbater) < 0 THEN DO:
                 RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                     INPUT "N∆o existe saldo suficiente na conta corrente para atender esta solicitaá∆o de ajuste", 
                                                     INPUT "Dispon°vel: " + STRING(de-disponivel, "->>>,>>>,>>9.9999") + CHR(10) +
                                                           "Ajuste enviado: " + STRING(b-tabela-pai-xml.ValorAbater, "->>>,>>>,>>9.9999")
                                                     ).
                 RETURN "NOK".
             END.
         END.
     END.
     ELSE /* n∆o existe conta corrente */
         IF  b-tabela-pai-xml.ValorAprovado <= 0 THEN DO:
             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                 INPUT "Valor de ajuste deve ser maior que zero para criaá∆o de nova conta corrente para o canal"  ,
                                                 INPUT "").
             RETURN "NOK".
         END.

     ASSIGN p-ok = YES.
     RETURN "OK".
END.


PROCEDURE pi-valida-solicitacao-NORMAL:

    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    DEF VAR de-disponivel                  AS DEC NO-UNDO.
    DEF VAR de-solicita-analise-ja-gravada LIKE int-solicitacao.ValorSolicitado.
    
    /* NUNCA PERMITIR RECEBER UMA SOLICITAÄ«O COM STATUS "PENDENTE", CASO ELA N«O EXISTA COMO "EM ANµLISE"*/
    IF  b-tabela-pai-xml.SituacaoSolicitacaoBeneficio = 993520003 
    AND i-tipo-beneficio <> 04
    AND i-tipo-beneficio <> 15 THEN DO:
        FIND FIRST b-solicitacao-analise NO-LOCK
           WHERE b-solicitacao-analise.CodigoSolicitacaoBeneficio = b-tabela-pai-xml.CodigoSolicitacaoBeneficio NO-ERROR.
        IF  NOT AVAIL b-solicitacao-analise THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "A solicitaá∆o n∆o existe com status 'Em An†lise' no ERP.", 
                                                INPUT "N∆o pode entrar diretamente para pagamento no ERP").
            RETURN "NOK".
        END.
    END.


    /* VALIDAÄ«O DE EXIST“NCIA DE SALDO NA CONTA CORRENTE. */
    IF  i-tipo-beneficio <> 04 /*Backup*/
    AND i-tipo-beneficio <> 15 /*ShowRoom*/ THEN DO:

        FIND LAST int-cc-benef NO-LOCK
            WHERE int-cc-benef.tp-movto       = 2 /*DESPESA*/
              AND int-cc-benef.tipo-beneficio = i-tipo-beneficio
              AND int-cc-benef.unid-neg       = b-tabela-pai-xml.CodigoUnidadeNegocio
              AND int-cc-benef.canal          = int-emitente.cod-emitente
              AND int-cc-benef.id-status      = 1 NO-ERROR. /* ATIVO*/ 
    
         IF  NOT AVAIL int-cc-benef THEN DO:
             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                 INPUT "N∆o existe conta corrente ativa para a solicitaá∆o" , 
                                                 INPUT "" ). 
             RETURN "NOK".
         END.
    END.
     
    /* VALIDA EXISTENCIA DE FILHOS QUANDO FOR PRODUTO */
    IF  msg0160r-FormaPagamentoItem.NomeFormaPagamento = "Produto" 
    AND b-tabela-pai-xml.SituacaoSolicitacaoBeneficio = 993520003 
    THEN DO:
        IF  NOT CAN-FIND(FIRST b-tabela-filho-xml) THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "N∆o foram enviados registros de itens para uma solicitaá∆o cuja forma De pagamento Ç Produto",
                                                INPUT "" ).
            RETURN "NOK".
        END.
    END.

    IF  i-tipo-beneficio <> 15 /*ShowRoom*/
    AND i-tipo-beneficio <> 4  /*Backup*/  THEN DO:
        /*-----------------------------------------------------------------------------------------------------*/
        /*                            V A L I D A R   S A L D O   D I S P O N ÷ V E L                          */
        /*-----------------------------------------------------------------------------------------------------*/
        RUN esp/esb/esesbapi010-saldo.p (INPUT int-cc-benef.canal,
                                         INPUT int-cc-benef.tipo-beneficio,
                                         INPUT int-cc-benef.unid-neg,
                                         INPUT int-cc-benef.dt-periodo-ini,
                                         INPUT int-cc-benef.dt-periodo-fim,
                                         INPUT ?,
                                         INPUT b-tabela-pai-xml.CodigoSolicitacaoBeneficio,
                                         OUTPUT p-ok,
                                         OUTPUT TABLE tt-saldo,
                                         OUTPUT TABLE tt-erro-saldo).

        IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
             FOR EACH tt-erro-saldo:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                    INPUT tt-erro.mensagem). 
            END.
            RETURN "NOK".
        END.

        FIND FIRST tt-saldo NO-ERROR.
        IF  AVAIL tt-saldo THEN
            ASSIGN de-disponivel = tt-saldo.verbaDisponivel.

        IF  b-tabela-pai-xml.SituacaoSolicitacaoBeneficio <> 993520003
        AND b-tabela-pai-xml.SituacaoSolicitacaoBeneficio <> 993520006 THEN DO:
            FIND FIRST b-solicitacao-analise NO-LOCK
               WHERE b-solicitacao-analise.CodigoSolicitacaoBeneficio = b-tabela-pai-xml.CodigoSolicitacaoBeneficio NO-ERROR.
            
            IF  AVAIL  b-solicitacao-analise 
            AND (    b-solicitacao-analise.SituacaoSolicitacaoBeneficio <> 993520003 
                 AND b-solicitacao-analise.SituacaoSolicitacaoBeneficio <> 993520004
                 AND b-solicitacao-analise.SituacaoSolicitacaoBeneficio <> 993520006) THEN DO:
                /* Pega o valor da solicitaá∆o que est† corrente j† gravado no banco */
                ASSIGN de-solicita-analise-ja-gravada = b-solicitacao-analise.ValorSolicitado.
            END.
            ELSE 
                ASSIGN de-solicita-analise-ja-gravada = 0.
    
            IF  (de-disponivel + de-solicita-analise-ja-gravada) < b-tabela-pai-xml.ValorAbater THEN DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                    INPUT "N∆o existe saldo suficiente na conta corrente para atender esta solicitaá∆o", 
                                                    INPUT "Aprovado.....................: " + STRING(b-tabela-pai-xml.ValorAbater) + CHR(10) +
                                                          "Dispon°vel...................: " + STRING(de-disponivel) + 
                                                          (IF de-solicita-analise-ja-gravada > 0 THEN (chr(10) + "Valor Solitaá∆o no Erp.......: " + STRING(de-solicita-analise-ja-gravada)) ELSE "")
                                                    ).
                RETURN "NOK".
            END.
        END.
    END.

     ASSIGN p-ok = YES.
     RETURN "OK".
END.
    

/*------------*/
/*   NORMAL   */
/*------------*/
PROCEDURE pi-cria-solicitacao-NORMAL:
    
    DEF  INPUT PARAM p-programa-msg AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-ok           AS LOG INIT NO NO-UNDO.
    
    DEF BUFFER b-int-cc-benef FOR int-cc-benef.

    /*-----------------------------------------------------------------------------------------------------------*/
    /*                                  GRAVAR  SOLICITAÄ«O  N O R M A L                                         */
    /*-----------------------------------------------------------------------------------------------------------*/
    {esp/esb/in/msg9999.i01     "b-int-solicitacao"
                                " FIND FIRST b-int-solicitacao 
                                    WHERE b-int-solicitacao.CodigoSolicitacaoBeneficio = b-tabela-pai-xml.CodigoSolicitacaoBeneficio EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                2  
                                5  }

    /* Verifica se o Registro existe e est† dispon°vel */
    
    IF  NOT l-reg-disponivel AND NOT l-locked THEN DO:
        
        /*-----------------------------*/
        /*  N O V O   R E G I S T R O  */
        /*-----------------------------*/
        RUN pi-Grava-Solicitacao (INPUT 1, /*Novo registro*/
                                  OUTPUT p-ok).

        IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN
            RETURN "NOK".
    END.
    ELSE DO:           
        IF  l-locked THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "Registro Solicitaá∆o em uso por outro Usu†rio. Tente novamente em alguns instantes." , 
                                                INPUT "").
            RETURN "NOK".
        END.
        ELSE DO: 
            /*---------------------------------------------*/
            /*  A L T E R A Ä « O   D E   R E G I S T R O  */
            /*---------------------------------------------*/
            IF  b-int-solicitacao.SituacaoSolicitacaoBeneficio = 993520003 THEN DO: /* Est† tentando alterar uma que j† est† como Pendente na base*/
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                    INPUT "Situaá∆o j† est† como <Pendente de Pagamento> no ERP, n∆o Ç permitida alteraá∆o da situaá∆o" ,
                                                    INPUT "O Status da Solicitaá∆o s¢ permite cancelamento.").
                RETURN "NOK".                
            END.
            ELSE DO:
                IF  b-int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004  THEN DO: /* Est† tentando alterar uma que j† est† como Pendente na base*/
                    RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                        INPUT "Solicitaá∆o j† est† paga no ERP, n∆o Ç permitida sua alteraá∆o " ,
                                                        INPUT "").
                    RETURN "NOK".                
                END.
                ELSE DO: /* Qualquer outra solicitacao que esteja criada no totvs */
                    RUN pi-ALTERA-solicitacao-Empenhada (OUTPUT p-ok).

                    IF OPSYS = "UNIX" THEN log-manager:write-message("Depois pi-ALTERA-solicitacao-Empenhada - p-ok: " + STRING(p-ok)).

                    IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN
                        RETURN "NOK".
                END.
            END.
        END.
    END.
                                                                                                   
    /* Cria ou Altera os Itens da Solicitacao */
    IF  msg0160r-FormaPagamentoItem.NomeFormaPagamento = "Produto" 
    AND NOT b-tabela-pai-xml.SolicitacaoAjuste THEN DO:

        RUN pi-GRAVA-Item-Solicitacao (OUTPUT p-ok). 

        IF OPSYS = "UNIX" THEN log-manager:write-message("apos  pi-GRAVA-Item-Solicitaca - p-ok: " + STRING(p-ok)).

        IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN
            RETURN "NOK".
    END.

    RELEASE b-int-solicitacao      NO-ERROR.
    RELEASE b-int-solicitacao-item NO-ERROR.
    RELEASE int-solicitacao        NO-ERROR.
    RELEASE int-solicitacao-item   NO-ERROR.
    
    ASSIGN p-ok = YES.
    RETURN "OK".
END.


/*------------*/
/*   AJUSTE   */
/*------------*/
PROCEDURE pi-cria-solicitacao-AJUSTE:
    DEF  INPUT PARAM p-programa-msg AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-ok           AS LOG INIT NO NO-UNDO.
    
    DEF VAR da-per-ini        AS DATE NO-UNDO.
    DEF VAR da-per-fim        AS DATE NO-UNDO.
    DEF VAR i-mes             AS INT  NO-UNDO.
    DEF VAR l-chama-api       AS LOG  INIT YES NO-UNDO.
    DEF VAR de-valor-apb      AS DEC  NO-UNDO.
    DEF VAR de-disponivel     AS DEC  NO-UNDO.

    DEF BUFFER b-cc FOR int-cc-benef.

    IF  AVAIL tt-saldo THEN
        ASSIGN de-disponivel = tt-saldo.VerbaDisponivel.

    IF OPSYS = "UNIX" THEN log-manager:write-message("4-" + string(AVAIL int-cc-benef) ).
    /* CASO N«O EXISTA A CONTA CORRENTE*/
    IF  NOT AVAIL int-cc-benef THEN DO:

        /* BUSCAR OS BENEF÷CIOS DO CANAL PARA CRIAÄ«O DA CONTA CORRENTE */
        RUN pi-busca-beneficios-canal (INPUT b-tabela-pai-xml.CodigoUnidadeNegocio,
                                       INPUT i-tipo-beneficio).


        IF  RETURN-VALUE <> "OK" THEN
            RETURN "NOK".

        IF OPSYS = "UNIX" THEN log-manager:write-message("5").

        FIND FIRST tt-beneficio  
             WHERE tt-beneficio.canal           = int-emitente.cod-emitente
               AND tt-beneficio.unid-neg        = b-tabela-pai-xml.CodigoUnidadeNegocio
               AND tt-beneficio.tipo-beneficio  = i-tipo-beneficio  NO-ERROR.
        IF  NOT AVAIL tt-beneficio THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "N∆o encontrado benef°cio para o canal para esta solicitacao, ou o mesmo n∆o encontra-se Ativo."  ,
                                                INPUT "").
            RETURN "NOK".
        END.

        IF OPSYS = "UNIX" THEN log-manager:write-message("6").
        RUN pi-retorna-periodo (INPUT  TODAY,
                                INPUT  i-tipo-beneficio,
                                INPUT  tt-beneficio.tipo-categoria,
                                OUTPUT da-per-ini,
                                OUTPUT da-per-fim).
        
        /* CRIA CONTA CORRENTE */
        FIND b-cc NO-LOCK
            WHERE b-cc.tp-movto = 2 /*Despesa*/
              AND b-cc.canal            = int-emitente.cod-emitente            
              AND b-cc.unid-neg         = b-tabela-pai-xml.CodigoUnidadeNegocio
              AND b-cc.tipo-beneficio   = tt-beneficio.tipo-beneficio          
              AND b-cc.dt-periodo-ini   = da-per-ini                           
              AND b-cc.dt-periodo-fim   = da-per-fim NO-ERROR.

        IF OPSYS = "UNIX" THEN log-manager:write-message("7").
        IF  AVAIL b-cc THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "J† existe conta corrente Ativa para:"  ,
                                                INPUT "Canal......: " + STRING(int-emitente.cod-emitente) + CHR(10) +
                                                      "Unidade....: " + b-tabela-pai-xml.CodigoUnidadeNegocio + CHR(10) + 
                                                      "Beneficio..: " + fn-retorna-nome-beneficio (tt-beneficio.tipo-beneficio) + CHR(10) +
                                                      "Per°odo Ini: " + string(da-per-ini) + CHR(10) + 
                                                      "Per°odo Fim: " + string(da-per-fim) + CHR(10) )              .
            RETURN "NOK".
        END.

        IF OPSYS = "UNIX" THEN log-manager:write-message("8   - b-tabela-pai-xml.ValorSolicitado: " + STRING(b-tabela-pai-xml.ValorSolicitado)).
        IF OPSYS = "UNIX" THEN log-manager:write-message("8   - b-tabela-pai-xml.ValorAprovado: " + STRING(b-tabela-pai-xml.ValorAprovado)).
        IF OPSYS = "UNIX" THEN log-manager:write-message("8.5 - b-tabela-pai-xml.ValorAbater: " + STRING(b-tabela-pai-xml.ValorAbater)).

        CREATE int-cc-benef.
        ASSIGN int-cc-benef.tp-movto             = 2 /* DESPESA */
               int-cc-benef.canal                = int-emitente.cod-emitente
               int-cc-benef.unid-neg             = b-tabela-pai-xml.CodigoUnidadeNegocio
               int-cc-benef.tipo-beneficio       = tt-beneficio.tipo-beneficio
               int-cc-benef.classificacao        = tt-beneficio.guid-class
               int-cc-benef.categoria            = tt-beneficio.tipo-categoria
               int-cc-benef.guid-canal           = tt-beneficio.guid-canal
               int-cc-benef.guid-beneficio       = tt-beneficio.guid-beneficio
               int-cc-benef.guid-beneficio-canal = tt-beneficio.guid-beneficio-canal
               int-cc-benef.dt-periodo-ini       = da-per-ini
               int-cc-benef.dt-periodo-fim       = da-per-fim
               int-cc-benef.VerbaAjustada        = b-tabela-pai-xml.ValorAprovado
               int-cc-benef.perc-benef           = tt-beneficio.perc-global
               int-cc-benef.dt-transacao         = TODAY
               int-cc-benef.dt-vencimento        = b-tabela-pai-xml.DataValidade
               int-cc-benef.id-status            = 1 /*CONTA CORRENTE ATIVA */
               int-cc-benef.usuario              = c-seg-usuario 
               int-cc-benef.vl-base-calc         = 0
               int-cc-benef.perc-custo           = tt-beneficio.perc-custo.

        IF OPSYS = "UNIX" THEN log-manager:write-message("int-cc-benef.VerbaAjustada: " + STRING(int-cc-benef.VerbaAjustada)).

     END.
     ELSE DO:
         FIND CURRENT int-cc-benef EXCLUSIVE-LOCK NO-ERROR.

         IF  NOT AVAIL int-cc-benef THEN DO:
             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                 INPUT "N∆o foi poss°vel alterar o saldo da conta corrente. N∆o dispon°vel"  ,
                                                 INPUT "").
             RETURN "NOK".
         END.

         /* APLICA O AJUSTE NO CAMPO VERBA AJUSTADA DA CONTA CORRENTE */
         ASSIGN int-cc-benef.VerbaAjustada = int-cc-benef.VerbaAjustada + b-tabela-pai-xml.ValorAprovado.
     END.

     FIND CURRENT int-cc-benef NO-LOCK NO-ERROR.
     /* N∆o fazer nada no AP caso o ajuste seja negativo e n∆o exista saldo mais no AP */
     FIND FIRST tit_ap NO-LOCK
         WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab
           AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.
    
     IF OPSYS = "UNIX" THEN log-manager:write-message("9: tit_ap: " + STRING(AVAIL tit_ap)).
      /* Se o ajustes estiver reduzindo o saldo mas o APB n∆o tiver mais saldo, n∆o deve nem chamar a api */
     IF   b-tabela-pai-xml.ValorAprovado < 0 
     AND  AVAIL tit_ap AND tit_ap.val_sdo_tit_ap = 0 THEN 
          ASSIGN l-chama-api = NO.

     IF OPSYS = "UNIX" THEN log-manager:write-message("b-tabela-pai-xml.ValorAprovado: " + STRING(b-tabela-pai-xml.ValorAprovado)).

     IF OPSYS = "UNIX" THEN log-manager:write-message("de-disponivel: " + STRING(de-disponivel)).

     ASSIGN de-valor-apb = b-tabela-pai-xml.ValorAprovado.

     /* se o saldo a zerar for menor que 0.00  ( Ex: 0.0024) n∆o Ç necess†rio abater do t°tulo */
     IF  de-valor-apb > 0 AND de-valor-apb < 0.01 THEN 
         ASSIGN l-chama-api = NO.

    IF  de-valor-apb < 0 AND de-valor-apb > -0.01 THEN 
         ASSIGN l-chama-api = NO.

    RUN esp/es0018p.p (INPUT "esbapi007-s", /* Nome do programa */
                       INPUT 1,            /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
    FIND FIRST tt-prog-ponto NO-ERROR.
    IF  AVAIL tt-prog-ponto THEN
        ASSIGN l-chama-api = LOGICAL(tt-prog-ponto.conteudo).

     /* ATUALIZAR O CONTAS A PAGAR */
     IF  int-cc-benef.tipo-beneficio <> 22 /* N∆o gerar t°tulo para Stock Rotation*/
     AND l-chama-api THEN DO: 
         DEF VAR h-esesb003-apb AS HANDLE NO-UNDO.

         IF OPSYS = "UNIX" THEN log-manager:write-message("10").
         IF  NOT VALID-HANDLE(h-esesb003-apb) THEN
             RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.

         RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT ROWID(int-cc-benef),
                                                        INPUT de-valor-apb,
                                                        INPUT NO,
                                                        INPUT TODAY,
                                                        INPUT int-cc-benef.dt-periodo-fim,
                                                        INPUT NO, /*n∆o Ç tratado como desconto em duplicata*/
                                                        INPUT TABLE tt-beneficio,
                                                        OUTPUT TABLE tt-erro-apb).
          IF  CAN-FIND (FIRST tt-erro-apb)
          OR  RETURN-VALUE <> "OK" THEN DO:
              DEF VAR l-erro AS LOG NO-UNDO.
              FOR EACH tt-erro-apb:
                  RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                      INPUT tt-erro-apb.mensagem,
                                                      INPUT tt-erro-apb.mensagem ).

                  IF OPSYS = "UNIX" THEN log-manager:write-message("11").
                  l-erro = YES.
              END.

              IF  NOT l-erro THEN DO:
                  RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                      INPUT "Retorno com erro, mas n∆o retornou descriá∆o do mesmo.",
                                                      INPUT "").


              END.

              IF  VALID-HANDLE(h-esesb003-apb) THEN
                  DELETE PROCEDURE h-esesb003-apb.
              IF OPSYS = "UNIX" THEN log-manager:write-message("12").
              RETURN "NOK".
          END.

          IF  VALID-HANDLE(h-esesb003-apb) THEN
              DELETE PROCEDURE h-esesb003-apb.
    END.

    /*-----------------------------------------------------------------------------------------------------------*/
    /*                                  GRAVAR  SOLICITAÄ«O  A J U S T E                                         */
    /*-----------------------------------------------------------------------------------------------------------*/
    {esp/esb/in/msg9999.i01     "b-int-solicitacao"
                                " FIND FIRST b-int-solicitacao
                                    WHERE b-int-solicitacao.CodigoSolicitacaoBeneficio = b-tabela-pai-xml.CodigoSolicitacaoBeneficio EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                2
                                5  }

    IF OPSYS = "UNIX" THEN log-manager:write-message("13").
    RUN pi-Grava-Solicitacao (INPUT  1, /*novo registro*/
                              OUTPUT p-ok).
    IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN
        RETURN "NOK".


    /* MUDA SITUAÄ«O PARA  P A G A  */
    ASSIGN b-int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004
           b-int-solicitacao.log-enviada                  = YES.   

    FIND CURRENT b-int-solicitacao NO-ERROR.

    ASSIGN p-ok = YES.
    RETURN "OK".

END.


PROCEDURE pi-gera-pedido-venda:

    DEF  INPUT PARAM p-emitente          AS INTEGER  NO-UNDO.
    DEF  INPUT PARAM p-CodigoSolicitacao AS CHAR     NO-UNDO.
    DEF  INPUT PARAM p-atendente         AS INTEGER  NO-UNDO.
    DEF  INPUT PARAM p-estabel           AS INTEGER  NO-UNDO.
    DEF  INPUT PARAM p-cond-pagto        AS INTEGER  NO-UNDO.
    DEF  INPUT PARAM p-beneficio         AS INTEGER  NO-UNDO.
    DEF  INPUT PARAM p-guid-canal        AS CHAR     NO-UNDO.
    DEF  INPUT PARAM p-supervisor        AS CHAR     NO-UNDO.
    DEF  INPUT PARAM p-unid-neg          AS CHAR     NO-UNDO.
    DEF  INPUT PARAM p-revenda           AS LOG      NO-UNDO.
    DEF OUTPUT PARAM p-ok                AS LOG INIT NO NO-UNDO.

    DEFINE VARIABLE raw-param      AS RAW.
    DEF BUFFER b-item-solicitacao-ped FOR int-solicitacao-item.

    DEF VAR i-seq         AS INTEGER NO-UNDO.
    DEF VAR i-origem AS INTEGER NO-UNDO.

    IF (     p-beneficio = 04  /* STOCK BACKUP     */ 
         OR  p-beneficio = 15) /* SHOW ROOM        */ 
    THEN 
        ASSIGN i-origem = 12. /* Faturamento */
    ELSE 
        ASSIGN i-origem = 9.  /* Bonificaá∆o */

    empty temp-table msg0093.
    empty temp-table item-pedido.   
    empty temp-table tt-erro-pedido.
    empty temp-table msg0093r.      
    empty temp-table pedidor.       
    empty temp-table Itensr.        
    empty temp-table item-pedidor.
    
    /* Criaá∆o hist¢rico */
    FIND emitente EXCLUSIVE-LOCK
        WHERE emitente.cod-emitente = p-emitente NO-ERROR.

    /*--------------------------------------------------------------------------- S E   F O R   R E V E N D A -------------------------------------------------------------------------*/
    IF OPSYS = "UNIX" THEN log-manager:write-message("p-emitente: " + string(p-emitente)).
    IF  AVAIL emitente AND p-revenda THEN DO:

        IF OPSYS = "UNIX" THEN log-manager:write-message("emitente.ind-cre-cli: " + string(emitente.ind-cre-cli)).

        IF  emitente.ind-cre-cli = 4 THEN DO:
            ASSIGN emitente.ind-cre-cli = 1
                   emitente.lim-credito = 0
                   emitente.dt-lim-cred = DATE(01, 01, 1990)
                   emitente.observacoes = emitente.observacoes + " - Data da liberaá∆o => " + STRING(TODAY) + ". Cadastro liberado para compra de BACKUP/SHOW ROOM via Intelbras clube. ".

            FIND FIRST emscad.cliente NO-LOCK
                    WHERE emscad.cliente.cdn_cliente = emitente.cod-emitente NO-ERROR.
            CREATE histor_clien. 
            ASSIGN histor_clien.cod_empresa = emscad.cliente.cod_empresa
                   histor_clien.cdn_cliente = emscad.cliente.cdn_cliente.
    
            FIND LAST b_histor_clien NO-LOCK 
                WHERE b_histor_clien.cod_empresa = histor_clien.cod_empresa
                  AND b_histor_clien.cdn_cliente = histor_clien.cdn_cliente NO-ERROR.
            IF  AVAIL b_histor_clien THEN 
                ASSIGN histor_clien.num_seq_histor_clien = b_histor_clien.num_seq_histor_clien + 1.
            ELSE 
                ASSIGN histor_clien.num_seq_histor_clien = 1.
            /*emitente.ind-cre-cli:SCREEN-VALUE IN FRAME default-frame*/
            ASSIGN histor_clien.des_abrev_histor_clien = "Hist. Autom†tico Solicit. Benef°cio"
                   histor_clien.des_histor_clien       = "An†lise de CrÇdito alterado em " + STRING(TODAY, "99/99/9999") + " pelo usu†rio "  + c-seg-usuario + " :" + CHR(10) +
                                                         "Data Limite de CrÇdito de: "     + string(emitente.dt-lim-cred, "99/99/9999") + CHR(10) +
                                                         "Indicador de CrÇdito de: Normal" + CHR(10) +
                                                         "Limite de CrÇdito de: 0".         
    
            IF OPSYS = "UNIX" THEN log-manager:write-message("histor_clien.des_histor_clien: " + string(histor_clien.des_histor_clien)).    
        END.

        /**Gera ocorrància suply Card*/
        DEF BUFFER b-emit-cnpj FOR emitente.
        FIND FIRST b-emit-cnpj NO-LOCK
            WHERE b-emit-cnpj.nome-abrev = emitente.nome-abrev NO-ERROR.

        IF  AVAIL b-emit-cnpj THEN DO:
            /* Valida se o cliente (raiz CNPJ) ja possui cartao Intelbras Clube ou ocorrencia pendente*/
            IF  NOT CAN-FIND(FIRST int-emitente-supcard NO-LOCK
                             WHERE int-emitente-supcard.raiz-cnpj = SUBSTRING(b-emit-cnpj.cgc,1,8)) 
            AND NOT CAN-FIND(FIRST int-pendencias-supcard NO-LOCK
                             WHERE int-pendencias-supcard.cnpj-cliente = b-emit-cnpj.cgc
                               AND int-pendencias-supcard.identific    = 98              /* Solicitacao de Novo Cliente */
                               AND int-pendencias-supcard.dat-envio    = ?)
            THEN DO:

                RUN esp/es0018p.p (INPUT "esacr003", /* Nome do programa */
                                   INPUT 4,         /* Ponto do programa */
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

                 FIND FIRST tt-prog-ponto NO-ERROR.
                 IF OPSYS = "UNIX" THEN log-manager:write-message("b-emit-cnpj.cgc: " + string( b-emit-cnpj.cgc )) . 

                 CREATE int-pendencias-supcard.
                 ASSIGN int-pendencias-supcard.cod-usuar           = c-seg-usuario
                        int-pendencias-supcard.cnpj-cliente        = b-emit-cnpj.cgc 
                        int-pendencias-supcard.dat-criacao         = TODAY
                        int-pendencias-supcard.identific           = 98  /* Solicitacao de Novo Cliente */
                        int-pendencias-supcard.log-manual          = YES
                        int-pendencias-supcard.log-emergencial     = NO
                        int-pendencias-supcard.tipo-bloqueio       = ?
                        int-pendencias-supcard.val-limite-sugerido = IF  AVAIL tt-prog-ponto THEN dec(tt-prog-ponto.conteudo) ELSE 0. /* Parametrizar um ponto no ES0018, ser† informado 49mil */.

                 IF OPSYS = "UNIX" THEN log-manager:write-message("int-pendencias-supcard.val-limite-sugerido: " + string(int-pendencias-supcard.val-limite-sugerido)) .

            END.
        END.
    END.
    /*--------------------------------------------------------------------- F I M   B L O C O  R E V E N D A -------------------------------------------------------------------------*/

    IF OPSYS = "UNIX" THEN log-manager:write-message("p-cond-pagto: " + string(p-cond-pagto)).
    CREATE msg0093.
    ASSIGN msg0093.nat-operacao         = "610100"
           msg0093.NumeroPedido         = ""
           msg0093.NumeroPedidoCliente  = ""
           msg0093.PedidoOriginal       = ""
           msg0093.Representante        = 4000
           msg0093.CodigoClienteCRM     = p-guid-canal
           msg0093.TipoObjetoCliente    = ""
           msg0093.Atendente            = p-atendente
           msg0093.Estabelecimento      = STRING(p-estabel)  
           msg0093.CondicaoPagamento    = p-cond-pagto /*3*/ 
           msg0093.CondicaoEspecial     = IF  (p-beneficio = 15 OR p-beneficio = 04) THEN /*Uso/Consumo*/
                                              " Produto(s) adquirido(s) para Uso/Consumo."
                                          ELSE
                                              ""
           msg0093.Observacao           = "Pedido gerado via Solicitaá∆o de Benef°cio de " + fn-retorna-nome-beneficio(i-tipo-beneficio) + ", em " + STRING(TODAY,"99/99/9999") + "."
           msg0093.FaturamentoParcial   = YES
           msg0093.Vendor               = NO
           msg0093.DiasBaseVendor       = 0
           msg0093.TaxaClienteVendor    = 0
           msg0093.DataEmissao          = TODAY
           msg0093.DataEntrega          = TODAY
           msg0093.DataNegociacao       = ?
           msg0093.DiasNegociacao       = ?
           msg0093.CodigoSupervisorEMS  = p-supervisor
           msg0093.Situacao             = 2 /* 1-cotaá∆o; 2 Efetivado */
           msg0093.origem               = i-origem
           msg0093.cod-unid-neg         = p-unid-neg
           msg0093.tp-beneficio         = p-beneficio
           msg0093.TipoUsuarioCriacao   = 993520002
           msg0093.NomeUsuarioCriacao   = "Solicitaá∆o de Benef°cio".

    /* Criar os Itens do Pedido */
    FOR EACH b-item-solicitacao-ped NO-LOCK
        WHERE b-item-solicitacao-ped.CodigoSolicitacaoBeneficio = p-CodigoSolicitacao
          AND b-item-solicitacao-ped.CodigoEstabelecimento      = p-estabel:
        CREATE item-pedido.
        ASSIGN item-pedido.acao             = ""
               item-pedido.ChaveIntegracao  = ""
               item-pedido.Produto          = b-item-solicitacao-ped.CodigoProduto
               item-pedido.Sequencia        = i-seq + 10
               item-pedido.QuantidadePedida = b-item-solicitacao-ped.QuantidadeAprovada
               item-pedido.PrecoOriginal    = b-item-solicitacao-ped.ValorUnitarioAprovado.
    END.

    /* CANAL DE VENDA ESESB016 */
    IF  p-beneficio <> 04 AND p-beneficio <> 15 THEN DO:
        FIND FIRST int-param-canal-benef NO-LOCK
            WHERE int-param-canal-benef.cod-unid-negoc  = p-unid-neg
              AND int-param-canal-benef.tp-beneficio    = p-beneficio NO-ERROR.
    
        IF  NOT AVAIL int-param-canal-benef THEN DO:
    
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "ParÉmetro Benef°cio X Canal de Venda inexistente. Para corrigir, cadastre uma regra no programa esesb016 para a Unidade " 
                                                       + p-unid-neg + " e Benef°cio " + fn-retorna-nome-beneficio(p-beneficio) ,
                                                INPUT "" ).
            RETURN "NOK".
        END.
        ELSE
            ASSIGN msg0093.canal-venda = int-param-canal-benef.cod-canal-venda.
    END.
    /* Criaá∆o Pedido */
    RUN esp/esb/in/msg0093a.p (INPUT  TABLE msg0093,
                               INPUT  TABLE item-pedido,
                               OUTPUT TABLE tt-erro-pedido,
                               OUTPUT TABLE msg0093r,
                               OUTPUT TABLE pedidor,
                               OUTPUT TABLE Itensr,
                               OUTPUT TABLE item-pedidor).
    
    IF  RETURN-VALUE = "NOK" 
    OR  CAN-FIND (FIRST tt-erro-pedido) THEN DO:
        DEF VAR l-erro AS LOGICAL NO-UNDO.
        FOR EACH tt-erro-pedido:
            CREATE tt-erro.
            ASSIGN tt-erro.codigo   = 17006
                   tt-erro.mensagem = tt-erro-pedido.mensagem
                   tt-erro.ajuda    = ""
                   l-erro = YES.

        END.
        IF  NOT l-erro THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.codigo   = 17006
                   tt-erro.mensagem = "Erro n∆o identificado. Pedido de venda para solicitaá∆o n∆o foi criado."
                   tt-erro.ajuda    = ""
                   l-erro = YES.
        END.

        RETURN "NOK".
    END.

    FIND FIRST pedidor NO-ERROR.
    
    IF  NOT AVAIL pedidor THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.codigo   = 17006
               tt-erro.mensagem = "(1) N∆o foi poss°vel gravar o pedido de venda para a solicitaá∆o"
               tt-erro.ajuda    = "Solicitaá∆o n∆o efetivada no ERP".
        RETURN "NOK".
    END.

    FIND FIRST ped-venda NO-LOCK
        WHERE ped-venda.nr-pedido = int(pedidor.numeroPedido) NO-ERROR.

    IF  NOT AVAIL ped-venda THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.codigo   = 17006
               tt-erro.mensagem = "(2) N∆o foi poss°vel gravar o pedido de venda para a solicitaá∆o"
               tt-erro.ajuda    = "Solicitaá∆o n∆o efetivada no ERP".
        RETURN "NOK".
    END.


    /* VINCULAR PEDIDO DE VENDA ∑ SOLICITAÄ«O */
    FOR EACH b-item-solicitacao-ped EXCLUSIVE-LOCK
        WHERE b-item-solicitacao-ped.CodigoSolicitacaoBeneficio = p-CodigoSolicitacao
          AND b-item-solicitacao-ped.CodigoEstabelecimento      = p-estabel :
              
         ASSIGN b-item-solicitacao-ped.nome-abrev = ped-venda.nome-abrev
                b-item-solicitacao-ped.nr-pedcli  = ped-venda.nr-pedcli.
    END.
    
    RUN esp/es0018p.p (INPUT "msg0091", /* Nome do programa */
                       INPUT 1,         /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

     FIND FIRST tt-prog-ponto 
          WHERE tt-prog-ponto.conteudo = "online" NO-ERROR.
    
    IF AVAIL tt-prog-ponto THEN DO:
        /*ENVIAR O PEDIDO CRIADO PARA CRM, ATUALIZANDO O C‡DIGO DA SOLICITAÄ«O DO BENEFICIO*/
        RAW-TRANSFER ped-venda TO raw-param.
    
        RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */
                                INPUT        raw-param, /* Tupla do registro */
                                OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
    
    
        IF  NOT CAN-FIND (FIRST resultado WHERE resultado.sucesso)  THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.codigo   = 17006
                   tt-erro.mensagem = "N∆o foi poss°vel atualizar o C¢digo da Solicitaá∆o de Benef°cio no pedido."
                   tt-erro.ajuda    = "Solicitaá∆o n∆o efetivada no ERP, visto que n∆o foi poss°vel atualizar o c¢digo da solicitaá∆o de benef°cio no pedido ao enviar para o CRM".
            RETURN "NOK".
        END.
    END.
    ELSE DO:
        FIND FIRST int-ped-venda EXCLUSIVE-LOCK
             WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    
        IF NOT AVAIL int-ped-venda THEN DO:
            CREATE int-ped-venda.
            ASSIGN int-ped-venda.nr-pedido   = ped-venda.nr-pedido.
        END.

        ASSIGN int-ped-venda.cod-estabel = ped-venda.cod-estabel.
        OVERLAY(int-ped-venda.char-1,76,1) = "1".

        FIND CURRENT int-ped-venda NO-LOCK.
    END.

    RELEASE b-item-solicitacao-ped.

    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.

    IF AVAIL int-ped-venda THEN
        ASSIGN OVERLAY(int-ped-venda.char-1,100,100) = "Solicitaá∆o de Benef°cio"                  
               OVERLAY(int-ped-venda.char-1,201,10)  = "993520002".

    FIND CURRENT int-ped-venda NO-LOCK.
    RELEASE int-ped-venda.
    
    ASSIGN p-ok = YES.
    RETURN "OK".
END.


/*-------------------------------------------------------------------*/
/*        B U S C A R   B E N E F ÷ C I O S   D O   C A N A L        */
/*-------------------------------------------------------------------*/
PROCEDURE pi-busca-beneficios-canal:

    DEF INPUT PARAM p-unid-neg       AS CHAR NO-UNDO.
    DEF INPUT PARAM p-tipo-beneficio AS INT NO-UNDO.
    /*------------------------------------------------------------------------------*/
    /*  API QUE RETORA OS BENEF÷CIOS DO CANAL, COM OS %(s) PARA PROVIS«O E CµLCULO  */
    /*------------------------------------------------------------------------------*/

    IF  CAN-FIND (FIRST tt-beneficio) THEN
        RETURN "OK".

    CREATE tt-canal.
    ASSIGN tt-canal.canal      = int-emitente.cod-emitente
           tt-canal.guid-canal = int-emitente.cod-guid
           tt-canal.guid-class = int-emitente.guid-class.

    EMPTY TEMP-TABLE tt-erro-benef.
    EMPTY TEMP-TABLE tt-beneficio.

    RUN esp/esb/esesbapi004-benef.p (INPUT  YES,  /* N∆o Ç provis∆o, logo buscar stock rotation */ 
                                     INPUT  YES,  /* Buscar msg0111 com o % global de cada benef°cio   */
                                     INPUT  YES,  /* Buscar msg0142, parÉmetros financeiros e provis∆o */
                                     INPUT  p-unid-neg,       /* (?) para buscar todas as unidades, ou informar uma unidade espec°fica */
                                     INPUT  p-tipo-beneficio, /* (?) para buscar todas beneficios, ou informar um benef°cio espec°fico */ 
                                     INPUT  TABLE tt-canal,
                                     OUTPUT TABLE tt-erro-benef,
                                     OUTPUT TABLE tt-beneficio).
    IF  RETURN-VALUE <> "OK" 
    OR  CAN-FIND (FIRST tt-erro-benef) THEN DO:
        FOR EACH tt-erro-benef:
            CREATE tt-erro.
            BUFFER-COPY tt-erro-benef TO tt-erro.
        END.
        RETURN "NOK".
    END.
    
    RETURN "OK".
END.

PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.

PROCEDURE pi-carrega-forma-pagamento-CRM:
        
    EMPTY TEMP-TABLE  msg0160r-FormaPagamentoItem. 
    EMPTY TEMP-TABLE  resultado. 
    
    FOR EACH int-forma-pagto NO-LOCK:
        CREATE msg0160r-FormaPagamentoItem.
        ASSIGN msg0160r-FormaPagamentoItem.CodigoFormaPagamento = int-forma-pagto.guid-forma-pagto
               msg0160r-FormaPagamentoItem.NomeFormaPagamento   = int-forma-pagto.desc-forma-pagto.
    END.

    IF  NOT CAN-FIND(FIRST msg0160r-FormaPagamentoItem ) THEN DO:

        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "N∆ existem formas de pagamento cadastradas no programa esesb012" ,
                                            INPUT "" ).
        RETURN "NOK".
    END.

    RETURN "OK".

END.

PROCEDURE pi-valida-canal:

    DEF INPUT PARAM p-guid-canal AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE tt-erro-canal.

    /* CONTA */
    FIND FIRST int-emitente NO-LOCK
        WHERE int-emitente.cod-guid = p-guid-canal NO-ERROR.
    
    IF  NOT AVAIL int-emitente THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "Canal inexistente" , 
                                            INPUT "" ).
        RETURN "NOK".
    END.

    /* EFETUA VALIDAÄÂES EM RELAÄ«O A APURAÄ«O DE BENEF÷CIOS CENTRAL OU POR FILIAL                  */
    /* VALIDA TAMBêM TODAS AS INFORMAÄÂES NECESSµRIAS PARA QUE O CANAL ESTEJA OK PARA MOVIMENTAÄÂES */
    RUN esp/esb/esesbapi005.p (INPUT string(int-emitente.cod-emitente),
                               OUTPUT TABLE tt-central,
                               OUTPUT TABLE tt-erro-canal).

    FIND FIRST tt-erro-canal NO-ERROR.

    IF  RETURN-VALUE <> "OK"
    OR AVAIL tt-erro-canal THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT tt-erro-canal.mensagem  , 
                                            INPUT tt-erro-canal.ajuda ).
        RETURN "NOK".
    END.
        
    FIND FIRST tt-central 
        WHERE tt-central.canal-central = int-emitente.cod-emitente NO-ERROR.

    /* VERIFICA SE O CANAL ê CENTRALIZADO, LOGO N«O PERMITE GERAR SOLICITAÄÂES PARA ELE */
    IF  NOT AVAIL tt-central THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "Este canal apura benef°cios de forma centralizada."   , 
                                            INPUT "A geraá∆o dos benef°cios s¢ pode ser processada para a Matriz.").
        RETURN "NOK".
    END.    

    RETURN "OK".

END.


PROCEDURE pi-retorna-periodo:
    
    DEF INPUT  PARAM p-data           AS DATE.
    DEF INPUT  PARAM p-tipo-beneficio AS INTEGER NO-UNDO.
    DEF INPUT  PARAM p-categoria      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-per-ini       AS DATE NO-UNDO.
    DEF OUTPUT PARAM p-per-fim       AS DATE NO-UNDO.
    
    DEF VAR i-mes AS INTEGER NO-UNDO.
    DEF VAR i-ano AS INTEGER NO-UNDO.

    /* SHOW ROOM E BACKUP N«O CONTROLAM CONTA CORRENTE. NO CASO DO PRICE, A CONTA S‡ EXISTE PARA ATUALIZAR AP */
    IF p-tipo-beneficio = 15 
    OR p-tipo-beneficio = 4   THEN DO:
        ASSIGN p-per-ini = TODAY
               p-per-fim = TODAY.
        RETURN "OK".
    END.

    
    IF  p-tipo-beneficio  = 21 
    AND (p-categoria = "PRATA" OR p-categoria = "BRONZE") THEN DO:
         CASE month(p-data):
             WHEN 1  OR WHEN 2  OR WHEN 3  THEN ASSIGN p-per-ini   = DATE(10,01,YEAR(p-data) - 1)  
                                                       p-per-fim   = DATE(12,31,YEAR(p-data) - 1).
             WHEN 4  OR WHEN 5  OR WHEN 6  THEN ASSIGN p-per-ini   = DATE(01,01,YEAR(p-data))  
                                                       p-per-fim   = DATE(09,30,YEAR(p-data)). 
             WHEN 7  OR WHEN 8  OR WHEN 9  THEN ASSIGN p-per-ini   = DATE(01,01,YEAR(p-data))  
                                                       p-per-fim   = DATE(09,30,YEAR(p-data)).
             WHEN 10 OR WHEN 11 OR WHEN 12 THEN ASSIGN p-per-ini   = DATE(01,01,YEAR(p-data))  
                                                       p-per-fim   = DATE(09,30,YEAR(p-data)).  
         END CASE.
     END.
     ELSE DO:
         /* REBATE, REBATE P‡S-VENDA E PRICE PROTECTION */
         IF  i-tipo-beneficio = 66 OR i-tipo-beneficio = 37 OR i-tipo-beneficio = 08 THEN DO:
         
             CASE month(p-data):
                 WHEN 1  OR WHEN 2  OR WHEN 3  THEN ASSIGN p-per-ini   = DATE(10,01,YEAR(p-data) - 1)
                                                           p-per-fim   = DATE(12,31,YEAR(p-data) - 1).
                 WHEN 4  OR WHEN 5  OR WHEN 6  THEN ASSIGN p-per-ini   = DATE(01,01,YEAR(p-data))
                                                           p-per-fim   = DATE(03,31,YEAR(p-data)).
                 WHEN 7  OR WHEN 8  OR WHEN 9  THEN ASSIGN p-per-ini   = DATE(04,01,YEAR(p-data))   
                                                           p-per-fim   = DATE(06,30,YEAR(p-data)). 
                 WHEN 10 OR WHEN 11 OR WHEN 12 THEN ASSIGN p-per-ini   = DATE(07,01,YEAR(p-data))   
                                                           p-per-fim   = DATE(09,30,YEAR(p-data)). 
             END CASE.
         END.

         /* VMC Distribuidores e Stock Rotation */
         IF  i-tipo-beneficio = 22 
         OR  (i-tipo-beneficio = 21 AND  (p-categoria = "DISTRIBUIDOR" OR p-categoria = "OURO" OR p-categoria = "REVENDA SOLUCOES" OR p-categoria = "PROVEDORES" OR p-categoria = "ESPECIALIZADA INCENDIO" OR p-categoria = "ATACADO DISTRIBUIDOR")) THEN DO:
         
             CASE month(p-data):
                 WHEN 1  OR WHEN 2  OR WHEN 3  THEN ASSIGN p-per-ini   = DATE(10,01,YEAR(p-data) - 1)
                                                           p-per-fim   = DATE(12,31,YEAR(p-data) - 1).

                 WHEN 4  OR WHEN 5  OR WHEN 6  THEN ASSIGN p-per-ini   = DATE(01,01,YEAR(p-data))
                                                           p-per-fim   = DATE(03,31,YEAR(p-data)).

                 WHEN 7  OR WHEN 8  OR WHEN 9  THEN ASSIGN p-per-ini   = DATE(04,01,YEAR(p-data))   
                                                           p-per-fim   = DATE(06,30,YEAR(p-data)). 

                 WHEN 10 OR WHEN 11 OR WHEN 12 THEN ASSIGN p-per-ini   = DATE(07,01,YEAR(p-data))   
                                                           p-per-fim   = DATE(09,30,YEAR(p-data)). 
             END CASE.
         END.
     END.
END.

PROCEDURE pi-valida-forma-pagto:

    /* SE EXISTIR CONTA, VERIFICA SE EXISTE SALDO */

    FIND FIRST msg0160r-FormaPagamentoItem
        WHERE msg0160r-FormaPagamentoItem.CodigoFormaPagamento = b-tabela-pai-xml.CodigoFormaPagamento NO-ERROR.

    IF  NOT AVAIL msg0160r-FormaPagamentoItem THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "MSG0160-LISTAR_FORMA_PAGAMENTO_BENEFICIO. N∆o encontrada FORMA de pagamento: " + int-solicitacao.CodigoFormaPagamento ,
                                            INPUT "" ).
        RETURN "NOK".
    END.

    /* NOMENCLATURA POSS÷VEL PARA FORMA DE PAGAMENTO */
    /* "Desconto em Duplicata" ; "Dinheiro"; Produto */
    IF  msg0160r-FormaPagamentoItem.NomeFormaPagamento <> "Desconto em Duplicata"
    AND msg0160r-FormaPagamentoItem.NomeFormaPagamento <> "Dinheiro"
    AND msg0160r-FormaPagamentoItem.NomeFormaPagamento <> "Produto" THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                            INPUT "MSG0160-LISTAR_FORMA_PAGAMENTO_BENEFICIO. Nomenclatura n∆o tratada no programa: " + msg0160r-FormaPagamentoItem.NomeFormaPagamento,
                                            INPUT "" ).
        RETURN "NOK".
    END.

    RETURN "OK".
END.

PROCEDURE pi-ALTERA-solicitacao-Empenhada:
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    /* Alterar a situaá∆o para PENTENTE */
    RUN pi-Grava-Solicitacao (INPUT 2, /*Alteraá∆o registro*/
                              OUTPUT p-ok).

    IF OPSYS = "UNIX" THEN log-manager:write-message("pi-ALTERA-solicitacao-Empenhada - p-ok: " + STRING(p-ok)).
    IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN
        RETURN "NOK".

    ASSIGN p-ok = YES.
    RETURN "OK".
END.

PROCEDURE pi-Grava-Solicitacao:

     DEF INPUT  PARAM p-novo           AS INTEGER NO-UNDO.
     DEF OUTPUT PARAM p-ok             AS LOG INIT NO NO-UNDO.
     DEF VAR da-per-ini                AS DATE NO-UNDO.
     DEF VAR da-per-fim                AS DATE NO-UNDO.
     DEF VAR de-verba-cancelar-tri-ant LIKE b-int-solicitacao.ValorSolicitado NO-UNDO.
     DEF VAR da-dt-periodo-fim-origem AS DATE NO-UNDO.

     IF  p-novo = 1 THEN /* Novo Registro */
         CREATE b-int-solicitacao.   
         
     /*Alteraá∆o*/
     RUN pi-retorna-data   (INPUT b-tabela-pai-xml.TrimestreCompetencia,
                            OUTPUT da-dt-periodo-fim-origem).

     IF OPSYS = "UNIX" THEN log-manager:write-message("p-novo: " + STRING(p-novo)).
     IF OPSYS = "UNIX" THEN log-manager:write-message("da-dt-periodo-fim-origem: " + STRING(da-dt-periodo-fim-origem)).
     IF OPSYS = "UNIX" THEN log-manager:write-message("b-int-solicitacao.dt-periodo-fim: " + STRING(b-int-solicitacao.dt-periodo-fim)).
     IF OPSYS = "UNIX" THEN log-manager:write-message("b-int-solicitacao.ValorSolicitado: " + STRING(b-int-solicitacao.ValorSolicitado)).
     IF OPSYS = "UNIX" THEN log-manager:write-message("b-tabela-pai-xml.ValorAbater: " + STRING(b-tabela-pai-xml.ValorAbater)).
     IF  p-novo = 2  
     AND da-dt-periodo-fim-origem  <> b-int-solicitacao.dt-periodo-fim
     AND b-tabela-pai-xml.ValorAbater < b-int-solicitacao.ValorSolicitado    THEN 
         ASSIGN de-verba-cancelar-tri-ant = b-int-solicitacao.ValorSolicitado - b-tabela-pai-xml.ValorAbater.
     ELSE 
         ASSIGN de-verba-cancelar-tri-ant = 0.

     IF OPSYS = "UNIX" THEN log-manager:write-message("de-verba-cancelar-tri-ant: " + STRING(de-verba-cancelar-tri-ant)).

     ASSIGN b-int-solicitacao.CodigoSolicitacaoBeneficio       = b-tabela-pai-xml.CodigoSolicitacaoBeneficio                 
            b-int-solicitacao.NomeSolicitacaoBeneficio         = b-tabela-pai-xml.NomeSolicitacaoBeneficio                   
            b-int-solicitacao.CodigoTipoSolicitacao            = b-tabela-pai-xml.CodigoTipoSolicitacao                      
            b-int-solicitacao.CodigoBeneficio                  = b-tabela-pai-xml.CodigoBeneficio                            
            b-int-solicitacao.CodigoBeneficioCanal             = b-tabela-pai-xml.CodigoBeneficioCanal                       
            b-int-solicitacao.CodigoUnidadeNegocio             = b-tabela-pai-xml.CodigoUnidadeNegocio                       
            b-int-solicitacao.CodigoConta                      = b-tabela-pai-xml.CodigoConta       
            b-int-solicitacao.ValorSolicitado                  = b-tabela-pai-xml.ValorAbater 
            b-int-solicitacao.ValorSolicitadoOrigemCRM         = b-tabela-pai-xml.ValorSolicitado 
            b-int-solicitacao.DescricaoSolicitacao             = b-tabela-pai-xml.DescricaoSolicitacao                       
            b-int-solicitacao.SolicitacaoIrregular             = b-tabela-pai-xml.SolicitacaoIrregular                       
            b-int-solicitacao.DescricaoSituacaoIrregular       = b-tabela-pai-xml.DescricaoSituacaoIrregular                 
            b-int-solicitacao.CodigoFormaPagamento             = b-tabela-pai-xml.CodigoFormaPagamento                       
            b-int-solicitacao.SituacaoSolicitacaoBeneficio     = b-tabela-pai-xml.SituacaoSolicitacaoBeneficio               
            b-int-solicitacao.RazaoStatusSolicitacaoBeneficio  = b-tabela-pai-xml.RazaoStatusSolicitacaoBeneficio            
            b-int-solicitacao.situacao                         = b-tabela-pai-xml.situacao                                   
            b-int-solicitacao.Proprietario                     = b-tabela-pai-xml.Proprietario                               
            b-int-solicitacao.TipoProprietario                 = b-tabela-pai-xml.TipoProprietario.
     
     ASSIGN                                                                                                                
            b-int-solicitacao.CodigoAssistente                 = b-tabela-pai-xml.CodigoAssistente                          
            b-int-solicitacao.CodigoSupervisorEMS              = b-tabela-pai-xml.CodigoSupervisorEMS                        
            b-int-solicitacao.CodigoFilial                     = b-tabela-pai-xml.CodigoFilial                               
            b-int-solicitacao.StatusPagamento                  = b-tabela-pai-xml.StatusPagamento  
            b-int-solicitacao.DataCriacao                      = b-tabela-pai-xml.DataCriacao             
            b-int-solicitacao.DataValidade                     = b-tabela-pai-xml.DataValidade            
            b-int-solicitacao.CodigoCondicaoPagamento          = b-tabela-pai-xml.CodigoCondicaoPagamento 
            b-int-solicitacao.DescartarVerba                   = b-tabela-pai-xml.DescartarVerba          
            b-int-solicitacao.TrimestreCompetencia             = b-tabela-pai-xml.TrimestreCompetencia    
            b-int-solicitacao.FormaCancelamento                = b-tabela-pai-xml.FormaCancelamento       
            b-int-solicitacao.dt-trans                         = b-tabela-pai-xml.DataCriacao                                             
            b-int-solicitacao.desc-forma-pagto                 = msg0160r-FormaPagamentoItem.NomeFormaPagamento              
            b-int-solicitacao.cod-emitente                     = int-emitente.cod-emitente                                   
            b-int-solicitacao.Ajuste                           = b-tabela-pai-xml.SolicitacaoAjuste   /* INDICA SE ê AJUSTE OU NORMAL */                       
            b-int-solicitacao.ValorAbaterOriginalCRM           = b-tabela-pai-xml.ValorAbater
            b-int-solicitacao.ValorAbater                      = b-tabela-pai-xml.ValorAprovado /*a invers∆o dos campos Ç necess†ria por causa do VMC. */
            b-int-solicitacao.ValorAprovado                    = b-tabela-pai-xml.ValorAprovado
            b-int-solicitacao.tipo-beneficio                   = i-tipo-beneficio
            b-int-solicitacao.hora-trans                       = STRING(TIME, "HH:MM:SS")
            b-int-solicitacao.int-1                            = IF  fn-grupo-distribuidores (int-emitente.cod-emitente) THEN 0 ELSE 1 /* 1 indica que Ç revenda */.
   
     IF  i-tipo-beneficio = 21 THEN DO:
         IF  b-tabela-pai-xml.SolicitacaoAjuste THEN
             ASSIGN b-int-solicitacao.CodigoAcaoSubsidiadaVMC = "Ajuste"
                    b-int-solicitacao.DataPrevistaRetornoAcao = TODAY
                    b-int-solicitacao.ValorAcao               = 0.
         ELSE
             ASSIGN b-int-solicitacao.CodigoAcaoSubsidiadaVMC = b-tabela-pai-xml.CodigoAcaoSubsidiadaVMC                     
                    b-int-solicitacao.DataPrevistaRetornoAcao = b-tabela-pai-xml.DataPrevistaRetornoAcao                     
                    b-int-solicitacao.ValorAcao               = b-tabela-pai-xml.ValorAcao.                              
         
     END.
     ELSE
         ASSIGN b-int-solicitacao.DataPrevistaRetornoAcao = 01/01/0001
                b-int-solicitacao.CodigoAcaoSubsidiadaVMC = "."
                b-int-solicitacao.ValorAcao               = 0.

     /* Campo apenas alimentado no price protection */
     IF  i-tipo-beneficio = 08 THEN 
         ASSIGN b-int-solicitacao.StatusCalculoPriceProtection = b-tabela-pai-xml.StatusCalculoPriceProtection.

     IF i-tipo-beneficio = 15 
     OR i-tipo-beneficio = 04  THEN DO:
         IF OPSYS = "UNIX" THEN log-manager:write-message("14.1").
         /* BUSCAR OS BENEF÷CIOS DO CANAL PARA CRIAÄ«O DA CONTA CORRENTE */
         RUN pi-busca-beneficios-canal (INPUT b-tabela-pai-xml.CodigoUnidadeNegocio,
                                        INPUT i-tipo-beneficio).
   
         IF OPSYS = "UNIX" THEN log-manager:write-message("14.2").
         FIND FIRST tt-beneficio  
              WHERE tt-beneficio.canal           = int-emitente.cod-emitente
                AND tt-beneficio.unid-neg        = b-tabela-pai-xml.CodigoUnidadeNegocio
                AND tt-beneficio.tipo-beneficio  = i-tipo-beneficio  NO-ERROR.
         IF  NOT AVAIL tt-beneficio THEN DO:
             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                 INPUT "N∆o encontrado benef°cio para o canal para esta solicitacao, ou o mesmo n∆o encontra-se Ativo."  ,
                                                 INPUT "").
             RETURN "NOK".
         END.
     
         RUN pi-retorna-periodo (INPUT  TODAY,
                                 INPUT  i-tipo-beneficio,
                                 INPUT  tt-beneficio.tipo-categoria,
                                 OUTPUT da-per-ini,
                                 OUTPUT da-per-fim).
         IF OPSYS = "UNIX" THEN log-manager:write-message("14.2").
     END.
     
   
     /*--------------------------------------------------------------------------------------------------------*/
     /*            PRICE PROTECTION - CRIAR CONTA CORRENTE "FICT÷CIA", MAS QUE CONTROLA SALDO  A P B           */
     /*--------------------------------------------------------------------------------------------------------*/
     IF OPSYS = "UNIX" THEN log-manager:write-message("15.0").
   
     FIND LAST int-cc-benef NO-LOCK
         WHERE int-cc-benef.tp-movto       = 2 /*DESPESA*/
           AND int-cc-benef.tipo-beneficio = i-tipo-beneficio
           AND int-cc-benef.unid-neg       = b-tabela-pai-xml.CodigoUnidadeNegocio
           AND int-cc-benef.canal          = int-emitente.cod-emitente
           AND int-cc-benef.id-status      = 1 NO-ERROR. /* ATIVO*/ 
   
     IF OPSYS = "UNIX" THEN log-manager:write-message("AVAIL int-cc-benef: " + STRING(AVAIL int-cc-benef)).
     IF  AVAIL int-cc-benef THEN
         /* Para Price Protection */
         ASSIGN b-int-solicitacao.dt-periodo-ini = int-cc-benef.dt-periodo-ini                                                   
                b-int-solicitacao.dt-periodo-fim = int-cc-benef.dt-periodo-fim.
     ELSE 
         /* Para os outros tipos de solicitacao */
         ASSIGN b-int-solicitacao.dt-periodo-ini = da-per-ini                                                   
                b-int-solicitacao.dt-periodo-fim = da-per-fim. 
         
     /* Posiciona o registro para na procedure chamadora retornar a tt-saldo a partir da conta corrente */
     FIND FIRST int-cc-benef NO-LOCK
         WHERE int-cc-benef.canal          = b-int-solicitacao.cod-emitente
           AND int-cc-benef.unid-neg       = b-int-solicitacao.CodigoUnidadeNegocio
           AND int-cc-benef.tipo-beneficio = i-tipo-beneficio
           AND int-cc-benef.dt-periodo-ini = b-int-solicitacao.dt-periodo-ini
           AND int-cc-benef.dt-periodo-ini = b-int-solicitacao.dt-periodo-ini
           AND int-cc-benef.tp-movto       = 2 /*despesa*/ NO-ERROR.
           
     IF OPSYS = "UNIX" THEN log-manager:write-message("17").
   
     /*Quando for STOCK ROTATION, e for uma alteraá∆o para Pendente...deve ser passada diretamente para PAGA.*/
     IF  i-tipo-beneficio = 22 AND b-tabela-pai-xml.SituacaoSolicitacaoBeneficio = 993520003 THEN DO:
     
         ASSIGN  b-int-solicitacao.SituacaoSolicitacaoBeneficio    = 993520004  /* Paga */ 
                 b-int-solicitacao.RazaoStatusSolicitacaoBeneficio = 993520004  /* REEMBOLSADO */
                 b-int-solicitacao.StatusPagamento                 = 993520002
                 /*b-int-solicitacao.log-enviada                     = YES*/.
   
         DEF VAR de-tod-pago AS DEC NO-UNDO.
         FOR EACH int-solicitacao-item EXCLUSIVE-LOCK
             WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = b-tabela-pai-xml.CodigoSolicitacaoBeneficio:
                 ASSIGN int-solicitacao-item.ValorPago = int-solicitacao-item.ValorTotalAprovado
                        de-tod-pago = de-tod-pago +  int-solicitacao-item.ValorPago.
         END.
   
         ASSIGN b-int-solicitacao.ValorPago = de-tod-pago.
     
     END.
   
     /* Verifica as Ç uma solicitacao do trimestre anterior que foi alterada para menor */
     IF  de-verba-cancelar-tri-ant > 0 THEN DO:
         RUN pi-cancelar-verba-solicitacao-trimestre-ant (INPUT de-verba-cancelar-tri-ant,
                                                          OUTPUT p-ok).
         IF  NOT p-ok OR  RETURN-VALUE <> "OK" THEN 
             RETURN "NOK".   
     END.

     IF OPSYS = "UNIX" THEN log-manager:write-message("b-int-solicitacao.SituacaoSolicitacaoBeneficio    : " + string( b-int-solicitacao.SituacaoSolicitacaoBeneficio   )) . 
     IF OPSYS = "UNIX" THEN log-manager:write-message("b-int-solicitacao.RazaoStatusSolicitacaoBeneficio : " + string( b-int-solicitacao.RazaoStatusSolicitacaoBeneficio)) . 
     IF OPSYS = "UNIX" THEN log-manager:write-message("b-int-solicitacao.StatusPagamento                 : " + string( b-int-solicitacao.StatusPagamento                )) . 
     IF OPSYS = "UNIX" THEN log-manager:write-message("b-int-solicitacao.log-enviada                     : " + string( b-int-solicitacao.log-enviada                    )) .
   
     ASSIGN p-ok = YES.
     RETURN "OK".

END.

PROCEDURE pi-GRAVA-Item-Solicitacao:
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.
    /*-----------------------------------------------------------------------------------------------------------*/
    /*                                     GRAVAR OS ITENS DA SOLICITAÄ«O                                        */
    /*                Obs: s¢ grava os itens, quando situaá∆o recebida no xml for PENDENTE OU CRIADA             */
    /*-----------------------------------------------------------------------------------------------------------*/
    IF  b-int-solicitacao.SituacaoSolicitacaoBeneficio = 993520004 /* PAGA      */ 
    OR  b-int-solicitacao.SituacaoSolicitacaoBeneficio = 993520006 /* CANCELADA */ THEN DO:
        ASSIGN p-ok = YES.
        RETURN "OK".
    END.
    /* Remove os itens da solicitacao */
    FOR EACH int-solicitacao-item EXCLUSIVE-LOCK
        WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = b-tabela-pai-xml.CodigoSolicitacaoBeneficio:
        DELETE int-solicitacao-item.
    END.

    /* Recria os itens */
    FOR EACH b-tabela-filho-xml
        WHERE b-tabela-filho-xml.CodigoSolicitacaoBeneficio = b-tabela-pai-xml.CodigoSolicitacaoBeneficio
          AND b-tabela-filho-xml.Situacao = 0 /* ITENS ATIVOS */
         BREAK BY b-tabela-filho-xml.CodigoSolicitacaoBeneficio
               BY b-tabela-filho-xml.CodigoEstabelecimento:

        /* VERIFICAR LOOK DE REGISTRO, CONTROLA INCLUSIVE ALGUMAS TENTATIVAS RECORRENTES DE LIBERAÄ«O DO REGISTRO*/
        {esp/esb/in/msg9999.i01     "b-int-solicitacao-item"
                                    " FIND FIRST b-int-solicitacao-item 
                                        WHERE b-int-solicitacao-item.CodigoSolicitacaoBeneficio = b-tabela-filho-xml.CodigoSolicitacaoBeneficio 
                                          AND b-int-solicitacao-item.CodigoProdutoSolicitacao   = b-tabela-filho-xml.CodigoProdutoSolicitacao NO-LOCK NO-WAIT NO-ERROR. "
                                    2  
                                    5  }

        /* Verifica se o registro na existe */
        IF OPSYS = "UNIX" THEN log-manager:write-message("l-reg-disponivel: " + string(l-reg-disponivel) ).
        IF OPSYS = "UNIX" THEN log-manager:write-message("l-locked: " + string(l-locked) ).
        IF  NOT l-reg-disponivel AND NOT l-locked THEN DO:
            CREATE int-solicitacao-item.
            ASSIGN int-solicitacao-item.CodigoProdutoSolicitacao   = b-tabela-filho-xml.CodigoProdutoSolicitacao 
                   int-solicitacao-item.CodigoSolicitacaoBeneficio = b-tabela-filho-xml.CodigoSolicitacaoBeneficio      
                   int-solicitacao-item.CodigoProduto              = b-tabela-filho-xml.CodigoProduto                   
                   int-solicitacao-item.CodigoBeneficio            = b-tabela-filho-xml.CodigoBeneficio                 
                   int-solicitacao-item.ValorUnitario              = b-tabela-filho-xml.ValorUnitario                   
                   int-solicitacao-item.Quantidade                 = b-tabela-filho-xml.quantidade                      
                   int-solicitacao-item.ValorTotal                 = b-tabela-filho-xml.ValorTotal                      
                   int-solicitacao-item.ValorUnitarioAprovado      = b-tabela-filho-xml.ValorUnitarioAprovado           
                   int-solicitacao-item.QuantidadeAprovada         = b-tabela-filho-xml.QuantidadeAprovado              
                   int-solicitacao-item.ValorTotalAprovado         = b-tabela-filho-xml.ValorTotalAprovado              
                   int-solicitacao-item.ChaveIntegracaoNotaFiscal  = b-tabela-filho-xml.ChaveIntegracaoNotaFiscal       
                   int-solicitacao-item.Proprietario               = b-tabela-filho-xml.proprietario    
                   int-solicitacao-item.TipoProprietario           = b-tabela-filho-xml.TipoProprietario
                   int-solicitacao-item.Acao                       = b-tabela-filho-xml.Acao
                   int-solicitacao-item.CodigoEstabelecimento      = b-tabela-filho-xml.CodigoEstabelecimento
                   int-solicitacao-item.situacao                   = b-tabela-filho-xml.situacao
                   int-solicitacao-item.QuantidadeCancelada        = b-tabela-filho-xml.QuantidadeCancelada
                   int-solicitacao-item.ValorPago                  = b-tabela-filho-xml.ValorPago
                   int-solicitacao-item.ValorCancelado             = b-tabela-filho-xml.ValorCancelado.

            IF  i-tipo-beneficio = 08 THEN 
                ASSIGN int-solicitacao-item.QuantidadeAjustada = b-tabela-filho-xml.QuantidadeAjustada.
        END.
        
        /* SERµ GERADO UM PEDIDO PARA CADA ESTABELECIMENTO, CASO SEJA FORMA DE PAGAMENTO = "PRODUTO" */
        IF  LAST-OF (b-tabela-filho-xml.CodigoEstabelecimento) THEN DO:

            IF  b-tabela-pai-xml.SituacaoSolicitacaoBeneficio = 993520003 THEN DO:
                /*-----------------------------------------------------------------*/
                /*   GERAÄ«O PEDIDO DE VENDA SOMENTE QUANDO FOR  P E N D E N T E   */ 
                /*-----------------------------------------------------------------*/                
                RUN pi-gera-pedido-venda (INPUT b-int-solicitacao.cod-emitente, 
                                          INPUT b-tabela-pai-xml.CodigoSolicitacaoBeneficio,
                                          INPUT b-tabela-pai-xml.CodigoAssistente,
                                          INPUT b-tabela-filho-xml.CodigoEstabelecimento,
                                          INPUT b-tabela-pai-xml.CodigoCondicaoPagamento,
                                          INPUT b-tabela-pai-xml.BeneficioCodigo,
                                          INPUT b-tabela-pai-xml.CodigoConta,
                                          INPUT b-tabela-pai-xml.CodigoSupervisorEMS,
                                          INPUT b-tabela-pai-xml.CodigoUnidadeNegocio,
                                          INPUT (IF b-int-solicitacao.int-1 = 1 THEN YES ELSE NO),
                                          OUTPUT p-ok).
    
                IF  RETURN-VALUE <> "OK" 
                OR  NOT p-ok THEN DO:
                    RETURN "NOK".
                END.
            END.
        END.
    END.

    /* VALIDA EXISTENCIA DE FILHOS QUANDO FOR PRODUTO */
    IF  msg0160r-FormaPagamentoItem.NomeFormaPagamento = "Produto" 
    AND b-tabela-pai-xml.SituacaoSolicitacaoBeneficio = 993520003 
    THEN DO:
   
        /* VALIDAÄ«O ITEM X SOLICITAÄ«O */
        DEF VAR de-tot-filhos AS DEC NO-UNDO.
        FOR EACH b-tabela-filho-xml
           WHERE  b-tabela-filho-xml.CodigoSolicitacaoBeneficio = b-tabela-pai-xml.CodigoSolicitacaoBeneficio 
              AND b-tabela-filho-xml.Situacao = 0:
               ASSIGN de-tot-filhos = de-tot-filhos + b-tabela-filho-xml.ValorTotalAprovado.
        END.
        IF OPSYS = "UNIX" THEN log-manager:write-message("01 - de-tot-filhos" + string(de-tot-filhos) ).
        IF OPSYS = "UNIX" THEN log-manager:write-message("02 - b-tabela-pai-xml.ValorAbater " + string(b-tabela-pai-xml.ValorAbater ) ).
        IF  de-tot-filhos <> b-tabela-pai-xml.ValorAbater THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "Valor solicidado difere do valor total aprovado para os itens.", 
                                                INPUT "" ).
            
            RETURN "NOK".
        END.
    END.


    ASSIGN p-ok = YES.
    
    RETURN "OK".
END.


/*  C R I A R   C O N T A   C O R R E N T E   -   P R I C E   P R O T E C T I O N  */
PROCEDURE pi-Cria-Conta-Corrente-Price-Protection:
        
    DEF INPUT PARAM p-per-ini AS DATE NO-UNDO.
    DEF INPUT PARAM p-per-fim AS DATE NO-UNDO.
    DEF INPUT PARAM TABLE FOR tt-beneficio.
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    DEF VAR l-chama-api AS LOG INIT YES NO-UNDO.
    DEF VAR de-valor-apb AS DEC NO-UNDO.

    DEF BUFFER b-cc FOR int-cc-benef.

    /* CRIA CONTA CORRENTE */
    FIND b-cc EXCLUSIVE-LOCK
        WHERE b-cc.tp-movto = 2 /*Despesa*/
          AND b-cc.canal            = int-emitente.cod-emitente            
          AND b-cc.unid-neg         = b-tabela-pai-xml.CodigoUnidadeNegocio
          AND b-cc.tipo-beneficio   = tt-beneficio.tipo-beneficio          
          AND b-cc.dt-periodo-ini   = p-per-ini                           
          AND b-cc.dt-periodo-fim   = p-per-fim
          AND b-cc.id-status        = 1 NO-ERROR.

    IF  AVAIL b-cc THEN DO:
        ASSIGN b-cc.VerbaAjustada = b-cc.VerbaAjustada + b-int-solicitacao.ValorSolicitado /*b-tabela-pai-xml.ValorAprovado*/.

        IF OPSYS = "UNIX" THEN log-manager:write-message("b-cc.VerbaAjustada: " + STRING(b-cc.VerbaAjustada)) .
    END.
    ELSE DO:
        CREATE b-cc.
        ASSIGN b-cc.tp-movto             = 2 /* DESPESA */
               b-cc.canal                = int-emitente.cod-emitente
               b-cc.unid-neg             = b-tabela-pai-xml.CodigoUnidadeNegocio
               b-cc.tipo-beneficio       = tt-beneficio.tipo-beneficio
               b-cc.classificacao        = tt-beneficio.guid-class
               b-cc.categoria            = tt-beneficio.tipo-categoria
               b-cc.guid-canal           = tt-beneficio.guid-canal
               b-cc.guid-beneficio       = tt-beneficio.guid-beneficio
               b-cc.guid-beneficio-canal = tt-beneficio.guid-beneficio-canal
               b-cc.dt-periodo-ini       = p-per-ini
               b-cc.dt-periodo-fim       = p-per-fim
               b-cc.perc-benef           = tt-beneficio.perc-global
               b-cc.dt-transacao         = TODAY
               b-cc.dt-vencimento        = b-tabela-pai-xml.dataValidade
               b-cc.id-status            = 1 /*CONTA CORRENTE ATIVA */
               b-cc.usuario              = c-seg-usuario 
               b-cc.vl-base-calc         = 0
               b-cc.perc-custo           = tt-beneficio.perc-custo.
               b-cc.VerbaAjustada        = b-int-solicitacao.ValorSolicitado /*b-tabela-pai-xml.ValorAprovado*/.
    END.


    FIND CURRENT b-cc NO-LOCK NO-ERROR.

    ASSIGN de-valor-apb = b-tabela-pai-xml.ValorAprovado.

    /* ATUALIZAR O CONTAS A PAGAR */

    DEF VAR h-esesb003-apb AS HANDLE NO-UNDO.

    IF OPSYS = "UNIX" THEN log-manager:write-message("10 -> de-valor-apb: " + STRING(de-valor-apb)).
    IF  NOT VALID-HANDLE(h-esesb003-apb) THEN
        RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.

    RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT ROWID(b-cc),
                                                   INPUT de-valor-apb,
                                                   INPUT NO,
                                                   INPUT TODAY,
                                                   INPUT p-per-fim,
                                                   INPUT (IF  b-int-solicitacao.desc-forma-pagto = "Produto" THEN NO ELSE YES),
                                                   INPUT TABLE tt-beneficio,
                                                   OUTPUT TABLE tt-erro-apb).
    IF OPSYS = "UNIX" THEN log-manager:write-message("10.1").
    IF  CAN-FIND (FIRST tt-erro-apb)
    OR  RETURN-VALUE <> "OK" THEN DO:
        DEF VAR l-erro AS LOG NO-UNDO.
        FOR EACH tt-erro-apb:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT tt-erro-apb.mensagem,
                                                INPUT tt-erro-apb.mensagem ).

            IF OPSYS = "UNIX" THEN log-manager:write-message("11").
            l-erro = YES.
        END.

        IF  NOT l-erro THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                INPUT "Retorno com erro, mas n∆o retornou descriá∆o do mesmo.",
                                                INPUT "").


        END.

        IF  VALID-HANDLE(h-esesb003-apb) THEN
            DELETE PROCEDURE h-esesb003-apb.
        IF OPSYS = "UNIX" THEN log-manager:write-message("12").
        RETURN "NOK".
    END.

    IF  VALID-HANDLE(h-esesb003-apb) THEN
        DELETE PROCEDURE h-esesb003-apb.


    ASSIGN p-ok = YES.
    RETURN "OK".
END.


PROCEDURE pi-cancelar-verba-solicitacao-trimestre-ant:
     
    DEF INPUT  PARAM p-verba-canc-per-ant LIKE int-solicitacao.ValorSolicitado  NO-UNDO.
    DEF OUTPUT PARAM p-ok                 AS LOGICAL INIT NO.
    
    DEF VAR l-ok-aux AS LOG INIT NO NO-UNDO.

    IF  NOT VALID-HANDLE(h-cancela) THEN
        RUN esp/esb/esesbapi007-cancela.p PERSISTENT SET h-cancela.

    RUN pi-Descarta-Verba  IN h-cancela (INPUT  ROWID(b-int-solicitacao)              ,
                                         INPUT  b-int-solicitacao.cod-emitente        ,
                                         INPUT  b-int-solicitacao.CodigoUnidadeNegocio,
                                         INPUT  b-int-solicitacao.tipo-beneficio      ,
                                         INPUT  b-int-solicitacao.dt-periodo-ini      ,
                                         INPUT  b-int-solicitacao.dt-periodo-fim      ,
                                         INPUT  (int-cc-benef.perc-custo * p-verba-canc-per-ant) / 100,
                                         INPUT  p-verba-canc-per-ant,
                                         INPUT  YES, /*se Ç um desconto em duplicada*/
                                         OUTPUT TABLE tt-erro                      ,
                                         OUTPUT p-ok).

    IF OPSYS = "UNIX" THEN log-manager:write-message("pi-cancelar-verba-solicitacao-trimestre-ant -> p-ok: " + STRING(p-ok)).
    IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN
        RETURN "NOK".

    IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN DO:
        FOR EACH tt-erro-cancela:
            RUN pi-cria-erro (INPUT tt-erro-cancela.codigo,
                              INPUT tt-erro-cancela.mensagem,
                              INPUT tt-erro-cancela.ajuda).
        END.
        IF  VALID-HANDLE(h-cancela) THEN DO:
            DELETE PROCEDURE h-cancela.
            ASSIGN h-cancela = ?.
        END.
        ASSIGN p-ok = NO.
        RETURN "NOK".
    END.
    ELSE
        IF  VALID-HANDLE(h-cancela) THEN DO:
            DELETE PROCEDURE h-cancela.
            ASSIGN h-cancela = ?.
        END.

    RUN esp/esb/esesbapi010-saldo.p (INPUT ?,
                                     INPUT ?,
                                     INPUT ?,
                                     INPUT ?,
                                     INPUT ?,
                                     INPUT ?,
                                     INPUT b-tabela-pai-xml.CodigoSolicitacaoBeneficio,
                                     OUTPUT p-ok,
                                     OUTPUT TABLE tt-saldo,
                                     OUTPUT TABLE tt-erro-saldo).

    ASSIGN p-ok = YES.
    RETURN "OK".


END. 

PROCEDURE pi-RETORNA-DATA:

    DEF INPUT  PARAM p-competencia AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-data-fim-original AS DATE NO-UNDO.
    
    DEF VAR i-ano AS INTEGER NO-UNDO.

    ASSIGN i-ano = INTE( SUBSTR(p-competencia,1,4)).

    CASE SUBSTR(p-competencia,6,2):
        WHEN "T1" THEN p-data-fim-original = DATE(03,31,i-ano).
        WHEN "T2" THEN p-data-fim-original = DATE(06,30,i-ano).
        WHEN "T3" THEN p-data-fim-original = DATE(09,30,i-ano).
        WHEN "T4" THEN p-data-fim-original = DATE(12,31,i-ano).
    END CASE.
    
    RETURN "OK".
END.
