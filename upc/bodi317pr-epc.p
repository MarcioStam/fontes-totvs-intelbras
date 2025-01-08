{include/i-epc200.i1}  /* definicao tt-epc */
{cdp/cd0666.i}         /* tt-erro */
{esapi/esapi002tt.i}   /* tt-item */
DEFINE TEMP-TABLE tt-AtuErro NO-UNDO LIKE tt-erro.

DEFINE BUFFER bsaldo-estoq FOR saldo-estoq.
DEFINE BUFFER bwt-fat-ser-lote FOR wt-fat-ser-lote.

DEF INPUT PARAMETER c-evento AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

DEFINE VARIABLE r-rowid        AS ROWID      NO-UNDO.
DEFINE VARIABLE vQtAlocar      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cReturn        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vNrOrdem       AS INTEGER    NO-UNDO.
DEFINE VARIABLE vMsgErro       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vQtTransferida AS INTEGER    NO-UNDO.
DEFINE VARIABLE h-bodi317pr    AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-ok           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE vConversao     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE c-cod-depos    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE da-dt-base-st  AS DATE        NO-UNDO.
DEFINE VARIABLE de-valor-st    AS DECIMAL     NO-UNDO.
DEF VAR d-totalItens AS DEC     NO-UNDO.
DEF VAR d-aliq-ipi   AS DECIMAL NO-UNDO.

/* Vari†vel utilizada no programa UPC "bodi317im1br-upc" */
DEFINE NEW GLOBAL SHARED VARIABLE   g-row-wt-docto-bodi317pr    AS ROWID                NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE   g-codigo-orig-bodi317sd     AS INTEGER.
DEFINE NEW GLOBAL SHARED TEMP-TABLE tt-PedSaldoShared           NO-UNDO LIKE ped-saldo.
DEFINE NEW GLOBAL SHARED VARIABLE   wh-cod-depos-FT4002         AS WIDGET-HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE   v_cod-deposESPDP006         LIKE deposito.cod-depos NO-UNDO.

IF c-evento = "aftercalculaPrecos" THEN DO:
    
    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = "aftercalculaPrecos"
          AND tt-epc.cod-parameter = "table-rowid",
        FIRST wt-docto
        WHERE rowid(wt-docto) = TO-ROWID(tt-epc.val-parameter)
              NO-LOCK,
        FIRST wt-it-docto OF wt-docto 
              EXCLUSIVE-LOCK:
        ASSIGN wt-it-docto.vl-frete     = wt-docto.vl-frete-inf
               wt-it-docto.vl-despes-it = wt-docto.vl-frete-inf.
         
        IF wt-docto.serie = "r4" THEN DO:
            wt-docto.vl-taxa-exp  = ROUND(wt-docto.vl-taxa-exp,2).
        END.
    END.
END.


/*Aprovaá∆o de pedidos com itens abaixo do m°nimo*/
IF  c-evento = "AtualizaDadosItemNota" THEN DO:

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = "AtualizaDadosItemNota"
          AND tt-epc.cod-parameter = "Rowid_wt-it-docto":
    END.
    IF  AVAIL tt-epc THEN DO:

          FIND FIRST wt-it-docto NO-LOCK
              WHERE rowid(wt-it-docto) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
          IF  AVAIL wt-it-docto THEN DO:

              FIND FIRST wt-docto WHERE
                   wt-docto.seq-wt-docto = wt-it-docto.seq-wt-docto NO-LOCK NO-ERROR.

            /* Verifica se o item est† bloqueado ou reprovado por n∆o atender ao valor m°nimo */
            IF CAN-FIND(FIRST int-ped-item NO-LOCK
                            WHERE int-ped-item.nome-abrev   = wt-docto.nome-abrev
                              AND int-ped-item.nr-pedcli    = wt-it-docto.nr-pedcli
                              AND int-ped-item.nr-sequencia = wt-it-docto.nr-sequencia
                              AND int-ped-item.it-codigo    = wt-it-docto.it-codigo
                              AND int-ped-item.cod-refer    = wt-it-docto.cod-refer
                              AND (int-ped-item.ind-status-preco = 1 OR int-ped-item.ind-status-preco = 3)) THEN DO:

                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "AtualizaDadosItemNota"
                       tt-epc.cod-parameter = "EliminaSeqItem"
                       tt-epc.val-parameter = "YES".
            END.

          END.
    END.
END.
    
IF c-evento = "beforeGeraWtSaldoEstoqAutomatico" THEN DO:

    FOR EACH tt-epc 
        WHERE tt-epc.cod-event     = c-evento
        AND   tt-epc.cod-parameter = "rowid wt-it-docto" NO-LOCK:

        ASSIGN r-rowid = TO-ROWID(tt-epc.val-parameter).
        FIND wt-it-docto WHERE
            ROWID(wt-it-docto) = r-rowid NO-LOCK NO-ERROR.
        IF AVAIL wt-it-docto THEN DO:
            FIND wt-docto WHERE
                 wt-docto.seq-wt-docto = wt-it-docto.seq-wt-docto NO-LOCK NO-ERROR.

            /* rotina somente valida para os programas FT4002 e FT4003 */
            IF VALID-HANDLE(wh-cod-depos-FT4002) AND wh-cod-depos-FT4002:SCREEN-VALUE <> ? THEN
                ASSIGN c-cod-depos = wh-cod-depos-FT4002:SCREEN-VALUE. 
            ELSE DO:
                IF wt-docto.cod-estabel = '104' THEN DO:
                    ASSIGN c-cod-depos = "WEX" .
                END.
                ELSE DO:
                    IF wt-docto.nr-prog = 4002 THEN 
                        ASSIGN c-cod-depos = "EXP" .
                    ELSE ASSIGN c-cod-depos = "EXP".
                END.
            END.

            IF v_cod-deposESPDP006 <> '' THEN
                ASSIGN c-cod-depos = v_cod-deposESPDP006.

            IF  wt-docto.nr-prog = 4002 THEN DO:
                
                /* Verifica se o item est† bloqueado ou reprovado por n∆o atender ao valor m°nimo */
                IF NOT  CAN-FIND(FIRST int-ped-item NO-LOCK
                                WHERE int-ped-item.nome-abrev   = wt-docto.nome-abrev
                                  AND int-ped-item.nr-pedcli    = wt-it-docto.nr-pedcli
                                  AND int-ped-item.nr-sequencia = wt-it-docto.nr-sequencia
                                  AND int-ped-item.it-codigo    = wt-it-docto.it-codigo
                                  AND int-ped-item.cod-refer    = wt-it-docto.cod-refer
                                  AND (int-ped-item.ind-status-preco = 1 OR int-ped-item.ind-status-preco = 3))
                THEN
                    RUN pi-aloca.
                ELSE
                    RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17006, INPUT "Item " + wt-it-docto.it-codigo +
                                                                          ", Seq " + string(wt-it-docto.nr-sequencia) + " est† Bloqueado ou Reprovado por valor.").
            END.
            
        END.
    END. /* FOR EACH tt-epc  */

    FIND FIRST tt-epc
        WHERE tt-epc.cod-event     = c-evento
          AND tt-epc.cod-parameter = "standard_warehouse" EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL tt-epc THEN DO:

/*         MESSAGE 'AAA wh-cod-depos-FT4002:SCREEN-VALUE  ' wh-cod-depos-FT4002:SCREEN-VALUE SKIP */
/*                 'wt-it-docto.it-codigo ' wt-it-docto.it-codigo SKIP                            */
/*                 'tt-epc.val-parameter                  ' tt-epc.val-parameter                  */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                 */

        IF VALID-HANDLE(wh-cod-depos-FT4002) AND wh-cod-depos-FT4002:SCREEN-VALUE <> ? THEN
            ASSIGN tt-epc.val-parameter = wh-cod-depos-FT4002:SCREEN-VALUE. 
        ELSE DO:
            FIND wt-it-docto WHERE
                ROWID(wt-it-docto) = r-rowid NO-LOCK NO-ERROR.
            IF AVAIL wt-it-docto THEN DO:
                FIND wt-docto WHERE
                     wt-docto.seq-wt-docto = wt-it-docto.seq-wt-docto NO-LOCK NO-ERROR.
                /****************/
                IF AVAIL wt-docto THEN DO:

                    FIND FIRST tt-PedSaldoShared no-lock     
                        where tt-PedSaldoShared.nome-abrev    = wt-docto.nome-abrev       
                          and tt-PedSaldoShared.nr-pedcli     = wt-docto.nr-pedcli       
                          and tt-PedSaldoShared.it-codigo     = wt-it-docto.it-codigo       
                          and tt-PedSaldoShared.qt-aloc-ped   = wt-it-docto.quantidade[1] NO-ERROR.
                    IF AVAIL tt-PedSaldoShared THEN
                        ASSIGN tt-epc.val-parameter = tt-PedSaldoShared.cod-depos .
                END. /* IF AVAIL wt-docto THEN DO: */
                /****************/
            END.
        END. /* IF wh-cod-depos-FT4002 = ? THEN */

        IF v_cod-deposESPDP006 <> '' THEN
            ASSIGN tt-epc.val-parameter = v_cod-deposESPDP006. 


/*         MESSAGE 'BBB wh-cod-depos-FT4002:SCREEN-VALUE      ' wh-cod-depos-FT4002:SCREEN-VALUE SKIP */
/*                 'wt-it-docto.it-codigo ' wt-it-docto.it-codigo SKIP                                */
/*                 'tt-epc.val-parameter                  ' tt-epc.val-parameter                      */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                     */

    END. /* IF AVAIL tt-epc THEN DO: */

END. /* IF c-evento = "beforeGeraWtSaldoEstoqAutomatico" THEN DO: */
ELSE IF c-evento = "beforeCalculaWtDocto" THEN DO:

    FOR EACH tt-epc 
        WHERE tt-epc.cod-event     = c-evento
        AND   tt-epc.cod-parameter = "Table-Rowid" NO-LOCK:

        ASSIGN r-rowid = TO-ROWID(tt-epc.val-parameter).

        FIND FIRST wt-docto 
             WHERE ROWID(wt-docto) = r-rowid NO-LOCK NO-ERROR.

        IF  AVAIL wt-docto THEN 
            RUN pi-cria-sugestao.

        IF AVAIL wt-docto THEN DO:
            FOR FIRST ped-venda no-lock
                WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
                AND   ped-venda.nr-pedcli  = wt-docto.nr-pedcli,
                FIRST int-ped-venda
                WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                  AND int-ped-venda.cod-estabel = ped-venda.cod-estabel:

                IF int-ped-venda.ValorFrete <> 0 THEN DO:
                    ASSIGN wt-docto.vl-frete-inf = int-ped-venda.ValorFrete.
                END.
                ELSE DO:
                    IF int-ped-venda.vl-frete <> 0 THEN DO:
                        ASSIGN wt-docto.vl-frete-inf = int-ped-venda.vl-frete.
    
                      /*  ASSIGN d-aliq-ipi   = 0
                               d-totalItens = 0.
                        FOR EACH wt-it-docto NO-LOCK
                           WHERE wt-it-docto.seq-wt-docto  = wt-docto.seq-wt-docto
                             AND wt-it-docto.calcula:
                            FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = wt-it-docto.it-codigo NO-ERROR.
                            IF AVAIL ITEM AND ITEM.aliquota-ipi > 0 THEN
                                ASSIGN d-aliq-ipi = d-aliq-ipi + int-ped-venda.vl-frete * wt-it-docto.vl-preori * wt-it-docto.quantidade[1] * ITEM.aliquota-ipi.
                            ASSIGN d-totalItens = d-totalItens + (wt-it-docto.vl-preori * wt-it-docto.quantidade[1]).
                        END.
                        ASSIGN d-aliq-ipi = d-aliq-ipi / 100 / int-ped-venda.vl-frete / d-totalItens.
    
                        IF d-aliq-ipi = ? THEN
                            ASSIGN d-aliq-ipi = 0.
                        
                        IF ped-venda.estado <> "EX" THEN

                            ASSIGN wt-docto.vl-frete-inf = ROUND(int-ped-venda.vl-frete / (1 + d-aliq-ipi),2).
                        ELSE
                            ASSIGN wt-docto.vl-frete-inf = ROUND(int-ped-venda.vl-frete,2). */
                                                                                                             
                    END.
                END.
            END.
        END.    
    END.
END.
ELSE IF c-evento = "beforegeraDuplicatas" THEN DO:

        FOR EACH tt-epc 
            WHERE tt-epc.cod-event     = c-evento
            AND   tt-epc.cod-parameter = "Table-Rowid" NO-LOCK:

            ASSIGN r-rowid = TO-ROWID(tt-epc.val-parameter).

            FIND FIRST wt-docto 
                 WHERE ROWID(wt-docto) = r-rowid NO-LOCK NO-ERROR.

            IF  AVAIL wt-docto THEN DO:
                FIND ped-venda
                     WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
                       AND ped-venda.nr-pedcli  = wt-docto.nr-pedcli
                     NO-LOCK NO-ERROR.

                IF AVAIL ped-venda THEN DO:
                    FIND int-ped-venda
                         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                         NO-LOCK NO-ERROR.
                    IF AVAIL int-ped-venda THEN DO:
                        IF int-ped-venda.dt-negociacao <> ? and
                           int-ped-venda.dt-negociacao > wt-docto.dt-base-dup THEN 
                           ASSIGN wt-docto.dt-base-dup = int-ped-venda.dt-negociacao.
                        IF int-ped-venda.dias-negociacao <> 0 THEN
                           ASSIGN wt-docto.dt-base-dup = wt-docto.dt-base-dup + int-ped-venda.dias-negociacao.

                    END.
                END.
            END.
        END.
END.
ELSE IF c-evento = "beforeCalculaResumoEmbarque" 
     THEN DO:
         FOR EACH tt-epc 
            WHERE tt-epc.cod-event     = c-evento
              AND tt-epc.cod-parameter = "Table-Rowid",
            FIRST wt-docto 
            WHERE ROWID(wt-docto)  = TO-ROWID(tt-epc.val-parameter)
              AND wt-docto.nr-prog = 4001
                  EXCLUSIVE-LOCK,
            FIRST ped-venda
            WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
              AND ped-venda.nr-pedcli  = wt-docto.nr-pedcli     
                  NO-LOCK,
            FIRST int-ped-venda
            WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
              AND int-ped-venda.cod-estabel = ped-venda.cod-estabel
                  NO-LOCK:

            ASSIGN vConversao = 1.

            IF ped-venda.mo-codigo > 0 
            THEN DO:
                FOR FIRST cotacao
                    WHERE cotacao.mo-codigo   = ped-venda.mo-codigo
                      AND cotacao.ano-periodo = string(year(TODAY)) + string(month(TODAY),"99")
                      AND cotacao.cotacao[int(day(TODAY))] <> 0
                          NO-LOCK:
                    ASSIGN vConversao = cotacao.cotacao[int(day(TODAY))].
                END.

                ASSIGN wt-docto.nr-volumes       = int-ped-venda.nr-volumes
                       wt-docto.vl-frete-inf     = int-ped-venda.vl-frete   
                       wt-docto.vl-seguro-inf    = int-ped-venda.vl-seguro   
                       wt-docto.vl-embalagem-inf = int-ped-venda.vl-embalagem.

                IF wt-docto.observ-nota <> "" 
                THEN ASSIGN wt-docto.observ-nota = wt-docto.observ-nota + chr(13) + int-ped-venda.observ-nota.
                ELSE ASSIGN wt-docto.observ-nota = int-ped-venda.observ-nota.
            END.
        END.
END.


IF  c-evento = "beforeEfetuaQuebraWtDocto" THEN DO:

    FOR EACH tt-epc 
       WHERE tt-epc.cod-event     = c-evento
         AND tt-epc.cod-parameter = "Table-Rowid",
       FIRST wt-docto 
       WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter)
             NO-LOCK,
        EACH wt-it-docto 
       WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto 
             EXCLUSIVE-LOCK:

        FOR FIRST loc-entr 
            WHERE loc-entr.cod-entrega = wt-it-docto.cod-entrega
              AND loc-entr.nome-abrev  = wt-docto.nome-abrev
                  NO-LOCK,
            FIRST int-unid-feder
            WHERE int-unid-feder.pais   = loc-entr.pais
              AND int-unid-feder.estado = loc-entr.estado
              AND int-unid-feder.quebra-nota-protoc-icms
                  NO-LOCK,
            FIRST estabelec
            WHERE estabelec.cod-estabel = wt-docto.cod-estabel 
                  NO-LOCK,
            FIRST natur-oper
            WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao 
              AND natur-oper.subs-trib
                  NO-LOCK,
            FIRST int-item-uf
            WHERE int-item-uf.it-codigo       = wt-it-docto.it-codigo
              AND int-item-uf.cod-estado-orig = estabelec.estado
              AND int-item-uf.estado          = loc-entr.estado
              AND int-item-uf.protocolo       <> ""
                  NO-LOCK:
            ASSIGN wt-it-docto.cod-entrega = int-item-uf.protocolo.
        END.

        IF wt-docto.cod-estabel = "101" 
        THEN DO:
            FOR FIRST ITEM
                WHERE ITEM.it-codigo    = wt-it-docto.it-codigo 
                  AND ITEM.cod-servico <> 0
                      NO-LOCK:
                ASSIGN wt-it-docto.cod-entrega = string(ITEM.cod-servico).
            END.
        END.
    END.
END.

IF  c-evento = "AfterEfetuaQuebraWtDocto" 
THEN DO:
    FOR EACH tt-epc 
       WHERE tt-epc.cod-event     = c-evento
         AND tt-epc.cod-parameter = "Table-Rowid",
       FIRST wt-docto
       WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter)
             NO-LOCK,
        EACH wt-it-docto 
       WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto 
             EXCLUSIVE-LOCK:
        ASSIGN wt-it-docto.cod-entrega = wt-docto.cod-entrega.
    END.
END.

IF  c-evento = "beforeAtualizaDadosItemNota":U THEN DO:
    /* Grava o Rowid da wt-docto que ser† utilizado no programa UPC
       "bodi317im1br-upc.p" */
    FIND FIRST tt-epc NO-LOCK
        WHERE  tt-epc.cod-event     = c-evento
        AND    tt-epc.cod-parameter = "Rowid_WtDocto" NO-ERROR.
    ASSIGN g-row-wt-docto-bodi317pr = IF AVAIL tt-epc THEN TO-ROWID(tt-epc.val-parameter) ELSE ?.
END.

IF  c-evento = "beforeCriaDuplicatas":U THEN DO:

    FIND FIRST tt-epc NO-LOCK
        WHERE  tt-epc.cod-event     = c-evento
        AND    tt-epc.cod-parameter = "vl-icms-sub" NO-ERROR.
    IF AVAIL tt-epc THEN DO:
        ASSIGN de-valor-st =  dec(tt-epc.val-parameter).
    END.
    ELSE
        ASSIGN de-valor-st =  0.

    IF de-valor-st > 0 THEN DO:

        FIND FIRST tt-epc NO-LOCK
            WHERE  tt-epc.cod-event     = c-evento
            AND    tt-epc.cod-parameter = "rowid_wt-docto" NO-ERROR.
        IF AVAIL tt-epc THEN DO:
            FIND wt-docto
                WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.
            IF AVAIL wt-docto THEN DO:
                ASSIGN da-dt-base-st = wt-docto.dt-base-dup.
                FIND parcela-st
                     WHERE parcela-st.cod-emitente = wt-docto.cod-emitente NO-LOCK NO-ERROR.

                FIND cond-pagto
                     WHERE cond-pagto.cod-cond-pag = wt-docto.cod-cond-pag NO-LOCK NO-ERROR.

                FIND FIRST int-cond-pagto NO-LOCK
                    WHERE  int-cond-pagto.cod-cond-pag = wt-docto.cod-cond-pag NO-ERROR.
                IF AVAIL parcela-st AND 
                   parcela-st.prazo-st > 0 THEN DO:
                    FIND ped-venda
                         WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
                           AND ped-venda.nr-pedcli  = wt-docto.nr-pedcli
                         NO-LOCK NO-ERROR.
 
                    IF  AVAILABLE int-cond-pagto and
                        AVAILABLE cond-pagto THEN DO:
                    
                        IF SUBSTRING(int-cond-pagto.char-1, 4, 1) <> "S":U and
                           cond-pagto.prazos[1] > parcela-st.prazo-st THEN DO:

        
                            IF AVAIL ped-venda THEN DO:
                                FIND int-ped-venda
                                     WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                                     NO-LOCK NO-ERROR.
                                IF AVAIL int-ped-venda THEN DO:
        
                                    IF int-ped-venda.dt-negociacao <> ? and
                                       int-ped-venda.dt-negociacao > wt-docto.dt-base-dup THEN 
                                       ASSIGN da-dt-base-st = int-ped-venda.dt-negociacao.
        
                                    IF int-ped-venda.dias-negociacao <> 0 THEN
                                       ASSIGN da-dt-base-st = da-dt-base-st + int-ped-venda.dias-negociacao.
        
                                END.
                            END.
                            
                            CREATE tt-epc.
                            ASSIGN tt-epc.cod-event     = "beforeCriaDuplicatas"
                                   tt-epc.cod-parameter = "Param_ICMSST"
                                   tt-epc.val-parameter = "YES;1;YES;" + STRING(da-dt-base-st + parcela-st.prazo-st).
                        END.
                        ELSE DO:
                            IF SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:
                                
                                CREATE tt-epc.
                                ASSIGN tt-epc.cod-event     = "beforeCriaDuplicatas"
                                       tt-epc.cod-parameter = "Param_ICMSST"
                                       tt-epc.val-parameter = "NO;1;NO;?".

                            END.
                        END.
                    END.
                    ELSE DO:
                        FIND FIRST cond-ped
                             WHERE cond-ped.nr-pedido = ped-venda.nr-pedido
                            NO-LOCK NO-ERROR.

                        IF AVAIL cond-ped AND
                           cond-ped.nr-dias-venc > parcela-st.prazo-st THEN DO:
                            CREATE tt-epc.
                            ASSIGN tt-epc.cod-event     = "beforeCriaDuplicatas"
                                   tt-epc.cod-parameter = "Param_ICMSST"
                                   tt-epc.val-parameter = "YES;1;YES;" + STRING(da-dt-base-st + parcela-st.prazo-st).
                        END.
                        ELSE DO:
                            CREATE tt-epc.
                            ASSIGN tt-epc.cod-event     = "beforeCriaDuplicatas"
                                   tt-epc.cod-parameter = "Param_ICMSST"
                                   tt-epc.val-parameter = "NO;1;NO;?".
                        END.
    
                    END.
                END.    
                ELSE DO:
                    IF AVAIL int-cond-pagto AND
                       SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:
                        
                            CREATE tt-epc.
                            ASSIGN tt-epc.cod-event     = "beforeCriaDuplicatas"
                                   tt-epc.cod-parameter = "Param_ICMSST"
                                   tt-epc.val-parameter = "NO;1;NO;?".
                    END.
                END.
            END.
        END.
    END.
END.


IF  c-evento = "AtualizaDadosItemNota" THEN DO:
    /* Zera o valor da vari†vel */
    ASSIGN g-row-wt-docto-bodi317pr = ?.

END.

/*******  FIM DO PROGRAMA -> PROCEDURES INTERNAS *******/

PROCEDURE pi-aloca:
    /*** logica transferencia retirada do ESPDP006 - pi-aloca */

    FOR EACH tt-item: DELETE tt-item. END. 
    FOR EACH tt-erro: DELETE tt-erro. END. 

    ASSIGN cReturn = "".

    BLOCO:
    DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
        ASSIGN vQtAlocar = wt-it-docto.quantidade[1].

        /* Reporte */
        FIND FIRST item-uni-estab 
             WHERE item-uni-estab.cod-estabel = wt-docto.cod-estabel
               AND item-uni-estab.it-codigo   = wt-it-docto.it-codigo
               AND item-uni-estab.nr-linha    = 20
                   NO-LOCK NO-ERROR.
        IF AVAIL item-uni-estab 
        THEN DO:
            FIND FIRST saldo-estoq  
                 WHERE saldo-estoq.cod-estabel = wt-docto.cod-estabel
                   AND saldo-estoq.it-codigo   = wt-it-docto.it-codigo
                   AND saldo-estoq.cod-refer   = wt-it-docto.cod-refer
                   AND saldo-estoq.cod-depos   = c-cod-depos
                   AND saldo-estoq.cod-localiz = "" 
                       NO-LOCK NO-ERROR.
            IF NOT AVAIL saldo-estoq OR 
                (saldo-estoq.qtidade-atu - 
                 (saldo-estoq.qt-alocada  + 
                  saldo-estoq.qt-aloc-ped +  
                  saldo-estoq.qt-aloc-prod)) < vQtAlocar 
            THEN DO:
                ASSIGN vNrOrdem = 0
                       vMsgErro = "".

                RUN esp\pdp\espdp006b.p(INPUT wt-docto.cod-estabel,
                                        INPUT ROWID(wt-it-docto),
                                        INPUT vQtAlocar,
                                        INPUT c-cod-depos,
                                        INPUT "",
                                        OUTPUT vNrOrdem,
                                        OUTPUT vMsgErro).

                IF vMsgErro <> "" AND vMsgErro <> "OK" 
                THEN DO:
                    IF vMsgErro = "NOK" THEN DO:
                        ASSIGN cReturn = "NOK".
                        UNDO, LEAVE Bloco.
                    END.
                    ELSE DO:
                        ASSIGN cReturn = "NOK".                
                        UNDO, LEAVE Bloco.                
                    END.
                END.
            END.
        END.
        ELSE 
        DO  WHILE vQtAlocar > 0:
            FIND FIRST saldo-estoq  
                 WHERE saldo-estoq.cod-estabel = wt-docto.cod-estabel
                 AND   saldo-estoq.it-codigo   = wt-it-docto.it-codigo
                 AND   saldo-estoq.cod-refer   = wt-it-docto.cod-refer
                 AND   saldo-estoq.cod-depos   = c-cod-depos
                 AND   saldo-estoq.cod-localiz = ""
                 AND  (saldo-estoq.qtidade-atu - 
                       (saldo-estoq.qt-alocada  + 
                        saldo-estoq.qt-aloc-ped +  
                        saldo-estoq.qt-aloc-prod)) >= wt-it-docto.quantidade[1] 
                       NO-LOCK NO-ERROR.
            IF  NOT AVAIL saldo-estoq THEN DO:
                RUN piTransfereMaterial. 
            END.
            ELSE LEAVE.

            IF NOT CAN-FIND(FIRST tt-erro) THEN
                 ASSIGN vQtAlocar = vQtAlocar - vQtTransferida.
            ELSE ASSIGN vQtAlocar = 0.
        END.
        IF  CAN-FIND(FIRST tt-erro) THEN
        DO:
            ASSIGN cReturn = "NOK" .
            UNDO, LEAVE Bloco.
        END.
    END.

    IF CAN-FIND(FIRST tt-erro) THEN
        RETURN "ERRO".

END PROCEDURE.

PROCEDURE PiTransfereMaterial:
    DEFINE VARIABLE lAchouAE AS LOGICAL NO-UNDO.
    FOR EACH tt-erro: DELETE tt-erro. END.
    FOR EACH tt-item: DELETE tt-item. END.

    ASSIGN lAchouAE = NO.

    FOR EACH  ae-item USE-INDEX fifo 
        WHERE ae-item.cod-estabel = wt-docto.cod-estabel
        and   ae-item.it-codigo   = wt-it-docto.it-codigo 
        AND   ae-item.cod-depos   = c-cod-depos
        AND   NOT ae-item.situacao 
        AND   ae-item.localizacao <> ""
              EXCLUSIVE-LOCK:

        ASSIGN lAchouAE = yes.

        FIND FIRST int-saldo-estoq  
             WHERE int-saldo-estoq.cod-estabel  = ae-item.cod-estabel
               AND int-saldo-estoq.cod-depos    = ae-item.cod-depos    
               AND int-saldo-estoq.cod-localiz  = ae-item.localizacao
               AND int-saldo-estoq.it-codigo    = ae-item.it-codigo
                   NO-LOCK NO-ERROR.
        IF AVAIL int-saldo-estoq AND int-saldo-estoq.log-bloqueado THEN NEXT.

        CREATE tt-item.
        ASSIGN tt-item.TipoTrans    = 2 /* 2 - Saida */
               tt-item.cod-estabel  = wt-docto.cod-estabel
               tt-item.it-codigo    = wt-it-docto.it-codigo
               tt-item.cod-depos    = ae-item.cod-depos
               tt-item.quantidade   = ae-item.quantidade
               tt-item.serie        = ""
               tt-item.nro-docto    = wt-it-docto.nr-pedcli /* quando for ft4003, este campo podera ser branco */
               tt-item.cod-localiz  = ae-item.localizacao
               tt-item.lote         = ""
               tt-item.dt-vali-lote = ae-item.data-validade 
               tt-item.cod-refer    = "".
        LEAVE.
    END.

    IF  CAN-FIND(FIRST tt-item) THEN
    DO: 
        CREATE tt-item.
        ASSIGN tt-item.TipoTrans    = 1 /* 1 - Entrada*/
               tt-item.cod-estabel  = wt-docto.cod-estabel
               tt-item.it-codigo    = wt-it-docto.it-codigo
               tt-item.cod-depos    = ae-item.cod-depos
               tt-item.quantidade   = ae-item.quantidade
               tt-item.serie        = ""
               tt-item.nro-docto    = wt-it-docto.nr-pedcli /* quando for ft4003, este campo podera ser branco */
               tt-item.cod-localiz  = ""
               tt-item.lote         = ""
               tt-item.dt-vali-lote = ?
               tt-item.cod-refer    = "".

        RUN esapi\esapi002.p (INPUT 2, /*Transferància Entre Dep¢sitos e Cria Int-Saldo-Estoq*/
                              INPUT "ES-PD4000K",
                              INPUT  TABLE tt-item,
                              OUTPUT TABLE tt-erro).
        FOR EACH tt-erro.
            CREATE tt-AtuErro.
            BUFFER-COPY tt-erro TO tt-AtuErro.
        END.

        IF NOT AVAIL tt-erro THEN
        DO: 
            ASSIGN vQtTransferida = ae-item.quantidade.
            RUN PiCriaBaixa.
        END.
        ELSE ASSIGN cReturn = "NOK".

        IF cReturn <> "NOK" THEN
        DO:
            FOR FIRST bsaldo-estoq
                WHERE bsaldo-estoq.it-codigo   = saldo-estoq.it-codigo
                  AND bsaldo-estoq.cod-estabel = saldo-estoq.cod-estabel    
                  AND bsaldo-estoq.cod-depos   = c-cod-depos
                  AND bsaldo-estoq.cod-localiz = ""
                      NO-LOCK:
                IF (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada
                                            - saldo-estoq.qt-aloc-prod
                                            - saldo-estoq.qt-aloc-ped) <= wt-it-docto.quantidade[1] 
                THEN DO:
                    CREATE tt-erro.
                    ASSIGN tt-erro.i-sequen = 1
                           tt-erro.cd-erro  = 17567
                           tt-erro.mensagem = "N∆o foi poss°vel fazer FIFO de AE para o item: " + saldo-estoq.It-Codigo
                           cReturn          = "NOK".
                END.
            END.
        END.
    END.
    ELSE DO:
        IF NOT lAchouAE THEN
        DO:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "AE n∆o encontrado para o item " + wt-it-docto.it-codigo + "! Favor entrar em contato com Expediá∆o."
                   cReturn          = "NOK".
            FOR EACH tt-erro.
                CREATE tt-AtuErro.
                BUFFER-COPY tt-erro TO tt-AtuErro.
            END.
        END.
        ELSE IF AVAIL int-saldo-estoq AND int-saldo-estoq.log-bloqueado THEN 
        DO:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Item sem Saldo em estoque ou bloqueado para o item " + 
                                       wt-it-docto.it-codigo + "! Favor entrar em contato com Expediá∆o."
                   cReturn          = "NOK".
            FOR EACH tt-erro.
                CREATE tt-AtuErro.
                BUFFER-COPY tt-erro TO tt-AtuErro.
            END.
        END.
    END.
END.

PROCEDURE PiCriaBaixa:
   FIND FIRST ae-baixa NO-LOCK 
        WHERE ae-baixa.cod-estabel = ae-item.cod-estabel
        and   ae-baixa.nr-ae       = ae-item.nr-ae 
        AND   ae-baixa.sequencia   = ae-item.sequencia NO-ERROR.

   IF NOT AVAIL ae-baixa THEN DO:
      CREATE ae-baixa.
      ASSIGN ae-baixa.cod-estabel = ae-item.cod-estabel
             ae-baixa.nr-ae       = ae-item.nr-ae 
             ae-baixa.sequencia   = ae-item.sequencia
             ae-baixa.localizacao = ae-item.localizacao.
   END.
   ASSIGN ae-item.situacao  = YES.

   RELEASE ae-baixa.
   RELEASE ae-item.
END PROCEDURE.

PROCEDURE pi-cria-sugestao:

    /* Nova l¢gica - Medeiros e Claudiney */
    FOR EACH  wt-it-docto NO-LOCK
        WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto:

        FOR EACH wt-fat-ser-lote EXCLUSIVE-LOCK
            WHERE wt-fat-ser-lote.seq-wt-docto = wt-it-docto.seq-wt-docto AND
                  wt-fat-ser-lote.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto AND
                  wt-fat-ser-lote.cod-depos = c-cod-depos AND
                  wt-fat-ser-lote.cod-localiz <> "":

           FIND FIRST bwt-fat-ser-lote EXCLUSIVE-LOCK 
                WHERE bwt-fat-ser-lote.seq-wt-docto = wt-fat-ser-lote.seq-wt-docto AND
                      bwt-fat-ser-lote.seq-wt-it-docto = wt-fat-ser-lote.seq-wt-it-docto AND
                      bwt-fat-ser-lote.it-codigo = wt-fat-ser-lote.it-codigo AND
                      bwt-fat-ser-lote.cod-depos = wt-fat-ser-lote.cod-depos AND 
                      bwt-fat-ser-lote.cod-localiz = "" NO-ERROR.

            IF NOT AVAIL bwt-fat-ser-lote THEN DO:
                CREATE bwt-fat-ser-lote.
                ASSIGN bwt-fat-ser-lote.seq-wt-docto    = wt-it-docto.seq-wt-docto
                       bwt-fat-ser-lote.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
                       bwt-fat-ser-lote.it-codigo       = wt-it-docto.it-codigo
                       bwt-fat-ser-lote.cod-refer       = wt-it-docto.cod-refer
                       bwt-fat-ser-lote.cod-depos       = c-cod-depos
                       bwt-fat-ser-lote.cod-localiz     = ""
                       bwt-fat-ser-lote.lote            = ""
                       bwt-fat-ser-lote.dt-vali-lote    = ?
                       bwt-fat-ser-lote.log-2           = NO /* Controlar a inclus∆o do lote via FT4050 */
                       bwt-fat-ser-lote.quantidade[1]   = wt-it-docto.quantidade[1]
                       bwt-fat-ser-lote.qtd-contada[1]  = wt-fat-ser-lote.quantidade[1].
            END.
            ELSE DO:
                ASSIGN bwt-fat-ser-lote.quantidade[1]   = bwt-fat-ser-lote.quantidade[1] + wt-fat-ser-lote.quantidade[1]
                       bwt-fat-ser-lote.qtd-contada[1]  = bwt-fat-ser-lote.qtd-contada[1] + wt-fat-ser-lote.quantidade[1].
            END.
    
            DELETE wt-fat-ser-lote.
        END.

    
        &if  "{&ems_dbtype}" <> "progress":U &then
           validate wt-fat-ser-lote.               
        &endif. 
    END.
END.
