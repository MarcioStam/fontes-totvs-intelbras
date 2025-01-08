/* ----------------------------------------------------------------------------
   Programa..: esp\cpp\escpp058a.p
   Objetivo..: Ler registros para controle do kanban eletronico. 
   Data......: 25/10/2011 - Hoepers: desenvolvimento
---------------------------------------------------------------------------- */
{esp/cpp/escpp058.i}
{utp/ut-glob.i}
/*****************************************************************************/

PROCEDURE pi-carrega-dados:

    DEF INPUT  PARAM TABLE FOR tt-param.
    DEF OUTPUT PARAM TABLE FOR tt-produzir.

    FIND FIRST tt-param NO-LOCK NO-ERROR.

    EMPTY TEMP-TABLE tt-produzir.
    EMPTY TEMP-TABLE tt-saldo.

    IF  tt-param.log-liberado = NO
    THEN DO:
        FOR EACH  int-kanban-eletronico NO-LOCK
            WHERE int-kanban-eletronico.cod-estabel       = "101"
              AND int-kanban-eletronico.log-liberado      = NO
              AND int-kanban-eletronico.log-dispon-kanban = YES:
            RUN pi-cria-tt-produzir.
        END.
    END.
    ELSE DO:
        bloco-liberado:
        FOR EACH  int-kanban-eletronico NO-LOCK
            WHERE int-kanban-eletronico.cod-estabel  = "101"
              AND int-kanban-eletronico.log-liberado = YES:

            IF  int-kanban-eletronico.dat-liberac < tt-param.dat-corte
            THEN
                NEXT bloco-liberado.

            RUN pi-cria-tt-produzir.
        END.
    END.

    IF  tt-param.log-estoque = YES
    THEN DO:
        FOR EACH tt-saldo NO-LOCK:

            FIND FIRST tt-produzir EXCLUSIVE-LOCK
                WHERE  tt-produzir.it-codigo = tt-saldo.it-codigo NO-ERROR.

            IF  AVAIL tt-produzir
            THEN DO:
                ASSIGN tt-produzir.qtd-transito = tt-produzir.qtd-transito + tt-saldo.qtd-transito.

                IF  tt-saldo.cod-estabel = "101"
                THEN DO:
                    ASSIGN tt-produzir.qtd-sdo-total = tt-produzir.qtd-sdo-total + tt-saldo.qtd-transito.

                    IF  tt-saldo.cod-depos   = "ACA"
                    THEN
                        ASSIGN tt-produzir.qtd-aca-101   = tt-produzir.qtd-aca-101   + tt-saldo.qtd-saldo
                               tt-produzir.qtd-dispon    = tt-produzir.qtd-dispon    + tt-saldo.qtd-saldo
                               tt-produzir.qtd-alocada   = tt-produzir.qtd-alocada   + tt-saldo.qtd-alocada
                               tt-produzir.qtd-sdo-total = tt-produzir.qtd-sdo-total + tt-saldo.qtd-alocada + tt-saldo.qtd-saldo.
                END.

                IF  tt-saldo.cod-estabel = "104"
                THEN DO:
                    ASSIGN tt-produzir.qtd-sdo-total = tt-produzir.qtd-sdo-total + tt-saldo.qtd-transito.
                    IF  tt-saldo.cod-depos   = "ACA"
                    THEN
                        ASSIGN tt-produzir.qtd-aca-104   = tt-produzir.qtd-aca-104   + tt-saldo.qtd-saldo
                               tt-produzir.qtd-dispon    = tt-produzir.qtd-dispon    + tt-saldo.qtd-saldo
                               tt-produzir.qtd-alocada   = tt-produzir.qtd-alocada   + tt-saldo.qtd-alocada
                               tt-produzir.qtd-sdo-total = tt-produzir.qtd-sdo-total + tt-saldo.qtd-alocada + tt-saldo.qtd-saldo.

                    IF  tt-saldo.cod-depos = "WEX"
                    OR  tt-saldo.cod-depos = "EXP"
                    THEN
                        ASSIGN tt-produzir.qtd-exp-104   = tt-produzir.qtd-aca-104   + tt-saldo.qtd-saldo
                               tt-produzir.qtd-dispon    = tt-produzir.qtd-dispon    + tt-saldo.qtd-saldo
                               tt-produzir.qtd-alocada   = tt-produzir.qtd-alocada   + tt-saldo.qtd-alocada
                               tt-produzir.qtd-sdo-total = tt-produzir.qtd-sdo-total + tt-saldo.qtd-alocada + tt-saldo.qtd-saldo.

                    IF  tt-saldo.cod-depos = "BLO"
                    THEN
                        ASSIGN tt-produzir.qtd-blo-104   = tt-produzir.qtd-blo-104   + tt-saldo.qtd-saldo
                               tt-produzir.qtd-dispon    = tt-produzir.qtd-dispon    + tt-saldo.qtd-saldo
                               tt-produzir.qtd-alocada   = tt-produzir.qtd-alocada   + tt-saldo.qtd-alocada
                               tt-produzir.qtd-sdo-total = tt-produzir.qtd-sdo-total + tt-saldo.qtd-alocada + tt-saldo.qtd-saldo.
                END. /* IF  tt-saldo.cod-estabel = "104" */
            END. /* IF  AVAIL tt-produzir */
        END. /* FOR EACH tt-saldo NO-LOCK: */
    END. /* IF  tt-param.log-estoque = YES */
    RETURN "ok".
END.


PROCEDURE pi-cria-tt-produzir:

    FOR FIRST item-uni-estab NO-LOCK
        WHERE item-uni-estab.it-codigo   = int-kanban-eletronico.it-codigo
          AND item-uni-estab.cod-estabel = "101".

        IF  item-uni-estab.cod-unid-neg <> "sec" AND
            item-uni-estab.cod-unid-neg <> "net" AND
            item-uni-estab.cod-unid-neg <> "ter" AND 
            item-uni-estab.cod-unid-neg <> "aut" AND
            item-uni-estab.cod-unid-neg <> "fir" AND
            item-uni-estab.cod-unid-neg <> "ace"
        THEN
            RETURN.

        IF  tt-param.log-isec           = NO AND
            item-uni-estab.cod-unid-neg = "sec"
        THEN
            RETURN.

        IF  tt-param.log-inet           = NO AND
            item-uni-estab.cod-unid-neg = "net"
        THEN
            RETURN.

        IF  tt-param.log-icon           = NO AND
            item-uni-estab.cod-unid-neg = "ter"
        THEN
            RETURN.

        IF  tt-param.log-aut         = NO AND
            item-uni-estab.cod-unid-neg = "aut"
        THEN
            RETURN.

        IF  tt-param.log-fir         = NO AND
            item-uni-estab.cod-unid-neg = "fir"
        THEN
            RETURN.

        IF  tt-param.log-ace         = NO AND
            item-uni-estab.cod-unid-neg = "ace"
        THEN
            RETURN.

    END.

    CREATE tt-produzir.
    ASSIGN tt-produzir.cod-estabel    = int-kanban-eletronico.cod-estabel
           tt-produzir.it-codigo      = int-kanban-eletronico.it-codigo
           tt-produzir.num-seq-kanban = int-kanban-eletronico.num-seq-kanban
           tt-produzir.qtd-produzir   = int-kanban-eletronico.qtd-produzir
           tt-produzir.dat-liberac    = int-kanban-eletronico.dat-liberac
           tt-produzir.cod-usuar      = int-kanban-eletronico.cod-usuar-liberac
           tt-produzir.dat-estorno    = int-kanban-eletronico.dat-estorno
           tt-produzir.cod-usuar-est  = int-kanban-eletronico.cod-usuar-estorno
           tt-produzir.cod_unid_neg   = item-uni-estab.cod-unid-neg.

    FIND ITEM NO-LOCK
        WHERE ITEM.it-codigo = int-kanban-eletronico.it-codigo NO-ERROR.

    IF  AVAIL ITEM
    THEN
        ASSIGN tt-produzir.desc-item = ITEM.desc-item.

    FIND int-item-uni-estab NO-LOCK
        WHERE int-item-uni-estab.cod-estabel = "101"
          AND int-item-uni-estab.it-codigo   = int-kanban-eletronico.it-codigo NO-ERROR.

    IF  AVAIL int-item-uni-estab
    THEN
        ASSIGN tt-produzir.qtd-lote-mult = int-item-uni-estab.qtd-lote-multiplo
               tt-produzir.qtd-estoq-max = int-item-uni-estab.qtd-estoq-max
               tt-produzir.qtd-cartao    = INT(tt-produzir.qtd-produzir / int-item-uni-estab.qtd-lote-multiplo).

    IF  tt-param.log-estoque = YES
    THEN
        RUN esp/cpp/escpp058a.p (INPUT no, /* limpar temp-table saldo */
                                 INPUT no, /* atualizar base */
                                 INPUT tt-produzir.it-codigo,
                                 INPUT 0,    /* quantidade faturada */
                                 INPUT-OUTPUT TABLE tt-saldo).
    RETURN "ok".

END PROCEDURE.

PROCEDURE pi-atualizar-kanban:
    DEF INPUT        PARAM p-log-estorno AS  LOG NO-UNDO.
    DEF INPUT        PARAM p-cod-usuar   AS CHAR NO-UNDO.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-produzir.

    FOR EACH  tt-produzir EXCLUSIVE-LOCK
        WHERE tt-produzir.log-liberar = "X":

        FIND int-kanban-eletronico EXCLUSIVE-LOCK
            WHERE int-kanban-eletronico.cod-estabel    = tt-produzir.cod-estabel
              AND int-kanban-eletronico.it-codigo      = tt-produzir.it-codigo
              AND int-kanban-eletronico.num-seq-kanban = tt-produzir.num-seq-kanban NO-ERROR.

        IF  AVAIL int-kanban-eletronico
        THEN DO:
            IF  p-log-estorno = YES
            THEN DO:
                ASSIGN tt-produzir.log-liberar                 = ""
                       int-kanban-eletronico.log-liberado      = NO
                       int-kanban-eletronico.log-dispon-kanban = YES
                       int-kanban-eletronico.cod-usuar-estorno = p-cod-usuar
                       int-kanban-eletronico.dat-estorno       = TODAY.
            END.
            ELSE DO:
                ASSIGN int-kanban-eletronico.log-liberado      = YES
                       int-kanban-eletronico.log-dispon-kanban = NO
                       int-kanban-eletronico.cod-usuar-liberac = p-cod-usuar
                       int-kanban-eletronico.dat-liberac       = TODAY.
                DELETE tt-produzir.
            END.
        END. /* IF  AVAIL int-kanban-eletronico */
    END. /* FOR EACH  tt-produzir EXCLUSIVE-LOCK */

    RETURN "ok".

END PROCEDURE.


PROCEDURE pi-busca-usuar-estorno:

    DEF OUTPUT PARAM TABLE FOR tt-usuar-estorno.

    EMPTY TEMP-TABLE tt-usuar-estorno.

    for first ponto-programa
        where ponto-programa.nome-programa = "escpp058"
          AND ponto-programa.ponto         = 5,
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            
        IF  conteudo-programa.conteudo <> ""
        THEN DO:
            CREATE tt-usuar-estorno.
            ASSIGN tt-usuar-estorno.cod-usuario = conteudo-programa.conteudo.
        END.
    end.  

    RETURN "ok".
END PROCEDURE.
