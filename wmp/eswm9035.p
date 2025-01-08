/********************************************************************************
*******************************************************************************/
{include/i-prgvrs.i ESWM9035 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i eswm9035 MWM}
&ENDIF

/******************************************************************************
******************************************************************************/
{method/dbotterr.i}
{cdp/cd0666.i}

DEF TEMP-TABLE tt-gera-transf NO-UNDO
    FIELD l-considera   AS CHAR FORMAT "x(01)" LABEL "Retorna Roteiro?"
    FIELD cod-estabel   LIKE ficha-cq.cod-estabel
    FIELD nr-ficha      LIKE ficha-cq.nr-ficha
    FIELD it-codigo     LIKE ficha-cq.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    FIELD dt-fabricacao AS DATE FORMAT "99/99/9999" LABEL "DT Fabrica‡Æo"
    FIELD quantidade    LIKE ficha-cq.qt-original
    FIELD dep-saida     LIKE ficha-cq.cod-depos
    FIELD loc-saida     LIKE ficha-cq.cod-localiz
    FIELD cod-refer     LIKE ficha-cq.cod-refer
    FIELD lote          LIKE ficha-cq.lote
    FIELD dep-entrada   LIKE saldo-estoq.cod-depos
    FIELD loc-entrada   LIKE saldo-estoq.cod-localiz
    FIELD dt-trans      LIKE movto-estoq.dt-trans
    FIELD nro-docto     LIKE movto-estoq.nro-docto   
    FIELD serie-docto   LIKE movto-estoq.serie-docto
    FIELD narrativa     LIKE ficha-cq.narrativa
    FIELD cod-emitente  LIKE ficha-cq.cod-emitente
    FIELD cod-rej       LIKE cod-rejeicao.codigo-rejei
    FIELD nat-operacao  LIKE ficha-cq.nat-operacao
    FIELD obs           LIKE ficha-cq.narrativa
    FIELD ct-codigo     AS CHAR
    FIELD sc-codigo     AS CHAR. 

DEF INPUT-OUTPUT PARAM TABLE FOR tt-gera-transf.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

DEF VAR c-cod-local-wms AS CHAR NO-UNDO.

DEF VAR h-bosc047               AS HANDLE  NO-UNDO.
DEF VAR h-bosc048               AS HANDLE  NO-UNDO.

DEFINE VARIABLE i-itens-gerados AS INTEGER   NO-UNDO.
define variable nr-seq          as integer   no-undo.

{cdp/cdcfgmat.i}
{wmp/wm9000.i} /* ttWm-Docto, ttWm-docto-itens, ttwm-etiqueta */

DEF BUFFER b-ttWm-docto-itens FOR ttWm-docto-itens.

RUN scbo/bosc047.p PERSISTENT SET h-bosc047.
RUN scbo/bosc048.p PERSISTENT SET h-bosc048.

ASSIGN i-itens-gerados = 0.

FOR EACH tt-gera-transf NO-LOCK
   WHERE tt-gera-transf.l-considera  = "*".

     FIND FIRST deposito NO-LOCK
          WHERE deposito.cod-depos = tt-gera-transf.dep-ent NO-ERROR.
                
      IF deposito.log-gera-wms = YES THEN DO: /** Deposito WMS? **/

        FIND FIRST ficha-cq NO-LOCK 
             WHERE ficha-cq.nr-ficha = tt-gera-transf.nr-ficha NO-ERROR.
        
        FOR FIRST wm-local NO-LOCK
            WHERE wm-local.cod-estabel  = tt-gera-transf.cod-estabel
              AND wm-local.cod-deposito = tt-gera-transf.dep-ent:

                ASSIGN c-cod-local-wms = "".
                run getLocalDepositoEstab in h-bosc047 (INPUT  tt-gera-transf.cod-estabel,  
                                                        INPUT  tt-gera-transf.dep-ent,     
                                                        OUTPUT c-cod-local-wms).  
                IF  c-cod-local-wms = ""
                OR  c-cod-local-wms = ? THEN
                RUN getLocalDeposito IN h-bosc048 (INPUT  tt-gera-transf.cod-estabel,
                                                   INPUT  tt-gera-transf.dep-ent,
                                                   OUTPUT c-cod-local-wms).

                CREATE ttWm-docto-itens.
                ASSIGN ttWm-docto-itens.cod-estabel           = tt-gera-transf.cod-estabel
                       ttWm-docto-itens.cod-local             = c-cod-local-wms
                       ttWm-docto-itens.id-docto              = ?
                       ttWm-docto-itens.num-docto             = tt-gera-transf.nro-docto
                       ttWm-docto-itens.cod-cliente           = 0
                       ttWm-docto-itens.cdn-emitente          = tt-gera-transf.cod-emitente
                       ttWm-docto-itens.cod-item              = tt-gera-transf.it-codigo
                       ttWm-docto-itens.cod-refer             = tt-gera-transf.cod-refer
                       ttWm-docto-itens.cod-lote              = tt-gera-transf.lote
                       ttWm-docto-itens.dt-validade-lote      = tt-gera-transf.dt-fabricacao
                       ttWm-docto-itens.cod-doca              = 0
                       ttWm-docto-itens.qtd-item              = tt-gera-transf.quantidade
                       ttWm-docto-itens.num-seq-item-ped      = 0
                       ttWm-docto-itens.nr-pedcli             = ""
                       ttWm-docto-itens.nome-abrev            = ""
                       ttWm-docto-itens.cdd-embarq            = 0
                       ttWm-docto-itens.nr-resumo             = 0
                       ttWm-docto-itens.nr-pedido             = 0
                       ttWm-docto-itens.qtd-peso-pedida       = 0
                       ttWm-docto-itens.log-ped-sob-encomenda = NO
                       ttWm-docto-itens.log-lifo-ped-exp      = NO
                       ttWm-docto-itens.log-pedido-exp        = NO
                       ttWm-docto-itens.gera-sugestao         = YES
                       ttWm-docto-itens.alteracao             = NO
                       ttWm-docto-itens.num-seq-item          = 0
                       ttWm-docto-itens.num-seq-orig          = ficha-cq.op-seq
                       ttWm-docto-itens.dt-atualizacao        = tt-gera-transf.dt-trans.

                ASSIGN i-itens-gerados = i-itens-gerados + 1.

            END. /* for each  */

            IF  i-itens-gerados > 0 THEN DO:

                FOR EACH ttWm-docto-itens BREAK BY ttWm-docto-itens.cod-estabel
                                                BY ttWm-docto-itens.cod-local:

                    /* Executa uma vez por local */
                    IF  LAST-OF(ttWm-docto-itens.cod-estabel)
                    OR  LAST-OF(ttWM-docto-itens.cod-local) THEN DO:

                        /* cria ttWm-docto e verifica se o documento jÿ foi atualizado no wms */
                        RUN pi-atualiza-wms.
                        IF RETURN-VALUE = "NOK":U THEN DO:
                           RETURN "NOK":U.
                        END.
                    END.
                END.

                /* Cria o documento no WMS */
                RUN pi-cria-docto-wms.

                IF RETURN-VALUE = "NOK":U THEN DO:
                           RETURN "NOK":U.
                END.

            END.

      END.

END.

RETURN "OK":U.

PROCEDURE pi-atualiza-wms:

    CREATE ttWm-docto.
    ASSIGN ttWm-docto.cod-estabel      = tt-gera-transf.cod-estabel
           ttWm-docto.cod-local        = ttWm-docto-itens.cod-local
           ttWm-docto.num-docto        = tt-gera-transf.nro-docto
           ttWm-docto.num-docto-origem = STRING(tt-gera-transf.serie-docto,"x(5)")
                                       + STRING(tt-gera-transf.nro-docto,"x(16)")
                                       + STRING(tt-gera-transf.cod-emitente,">>>>>>>>9")
                                       + STRING(tt-gera-transf.nat-operacao)
                                       + STRING(tt-gera-transf.lote,"x(20)")
           ttWm-docto.ind-tipo-trans   = 1
           ttWm-docto.ind-origem-docto = 6
           ttWm-docto.id-carga         = 0
           ttWm-docto.cod-depos        = "".

    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-dat-atz-movto-est-wms" AND funcao.ativo = YES) THEN
        ASSIGN ttWm-docto.log-dat-atualiz-movto-estoq = YES.
    ELSE
        ASSIGN ttWm-docto.log-dat-atualiz-movto-estoq = NO.

    FIND FIRST wm-docto 
         WHERE wm-docto.cod-estabel      = tt-gera-transf.cod-estabel  AND
               wm-docto.cod-local        = ttWm-docto-itens.cod-local  AND
               wm-docto.ind-origem-docto = 6                           AND
               wm-docto.num-docto-origem = ttWm-docto.num-docto-origem NO-LOCK NO-ERROR.

    ASSIGN ttWm-docto.alteracao = AVAIL wm-docto
           ttWm-docto.id-docto  = IF AVAIL wm-docto THEN
                                     wm-docto.id-docto
                                  ELSE ?.
  
    IF  AVAIL wm-docto AND ttWm-docto-itens.alteracao = YES THEN DO:

        ASSIGN nr-seq = 0.
        FOR EACH RowErrors :
            IF  RowErrors.errorsequence > nr-seq THEN
                ASSIGN nr-seq = RowErrors.ErrorSequence. 
        END.        
        ASSIGN nr-seq = nr-seq + 1.

        CREATE RowErrors.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "documento_no_WMS_para_a_nota" *}
        ASSIGN RowErrors.ErrorSequence    = nr-seq
               RowErrors.ErrorNumber      = 15560
               RowErrors.ErrorDescription = RETURN-VALUE + " " + tt-gera-transf.nro-docto
               RowErrors.ErrorType        = "EMS":U
               RowErrors.ErrorSubType     = "Error":U.

        /* Elimina os registros do documento que jÿ estÿ no WMS. */
        FOR EACH b-ttWm-docto-itens
            WHERE b-ttWm-docto-itens.cod-estabel = ttWm-docto.cod-estabel
              AND b-ttWm-docto-itens.cod-local   = ttWm-docto.cod-local
              AND b-ttWm-docto-itens.num-docto   = ttWm-docto.num-docto:
            DELETE b-ttWm-docto-itens.
        END.

        DELETE ttWm-docto.

        FOR EACH RowErrors NO-LOCK.

             create tt-erro.
             assign tt-erro.i-sequen = RowErrors.ErrorSequence
                    tt-erro.cd-erro  = RowErrors.ErrorNumber
                    tt-erro.mensagem = RowErrors.ErrorDescription.

             RETURN "NOK":U.

        END. 

        RETURN "OK":U.

    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-docto-wms:

    /* Atualiza o id-docto de todos os registros. */
    FOR EACH ttWm-docto:
        FOR EACH b-ttWm-docto-itens
        WHERE b-ttWm-docto-itens.cod-estabel = ttWm-docto.cod-estabel
          AND b-ttWm-docto-itens.cod-local   = ttWm-docto.cod-local
          AND b-ttWm-docto-itens.num-docto   = ttWm-docto.num-docto:

            ASSIGN b-ttWm-docto-itens.id-docto = ttWm-docto.id-docto.
        END.
    END.

    RUN wmp/wm9000.p (INPUT-OUTPUT TABLE ttWm-docto,
                      INPUT-OUTPUT TABLE ttWm-docto-itens,
                      INPUT-OUTPUT TABLE TTWM-ETIQUETA,
                      OUTPUT TABLE RowErrors).
 
    FOR EACH ttWm-docto:
        DELETE ttWm-docto.
    END.
    FOR EACH ttWm-docto-itens:
        DELETE ttWm-docto-itens.
    END.

    FOR EACH RowErrors NO-LOCK.

        create tt-erro.
        assign tt-erro.i-sequen = RowErrors.ErrorSequence
               tt-erro.cd-erro  = RowErrors.ErrorNumber
               tt-erro.mensagem = RowErrors.ErrorDescription.

        RETURN "NOK":U.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* fim do programa */
