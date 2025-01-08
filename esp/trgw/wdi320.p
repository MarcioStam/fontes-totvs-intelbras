/********************************************************************************
 ** UPC........: wdi157.p - UPC TRIGGER WRITE PED-REPRE
 ** Data.......: Dezembro / 2004
 ** Objetivo...: Altera o valor da comiss∆o do representante conforme tabela
                 espec°fica do Magnus
 ** Autor......: Robson Jeorge Moser Gestech
 ** Vers∆o.....: 001                 
 ********************************************************************************/

DEF PARAM BUFFER b-wt-fat-ser-lote      FOR wt-fat-ser-lote.
DEF PARAM BUFFER b-old-wt-fat-ser-lote  FOR wt-fat-ser-lote.

DEFINE BUFFER b-wt-fat-ser-lote2  FOR wt-fat-ser-lote.
DEFINE BUFFER b-saldo-estoq       FOR saldo-estoq.

DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-depos-FT4002    AS WIDGET-HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-pedcli-ft4002UPC AS WIDGET-HANDLE        NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-quantidade-ft4004     AS WIDGET-HANDLE NO-UNDO.  
DEFINE NEW GLOBAL SHARED VARIABLE v_cod-deposESPDP006    LIKE deposito.cod-depos NO-UNDO.

DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.

DEF VAR p-qtd-total       LIKE wm-saldo-estoque.qtd-atual      NO-UNDO.
DEF VAR p-qtd-disp        LIKE wm-saldo-estoque.qtd-atual      NO-UNDO.
DEF VAR p-qtd-bloq        LIKE wm-saldo-estoque.qtd-atual      NO-UNDO.
DEF VAR p-qtd-totFat      LIKE b-wt-fat-ser-lote.quantidade[1] NO-UNDO.
DEF VAR l-wms-estab-ativo AS LOGICAL                           NO-UNDO.

DEF TEMP-TABLE tt-usuarios-reserva NO-UNDO
    FIELD usuario AS CHAR.

{esp/es0018.i}
{cdp/cd0666.i}         /* Definicao da temp-table de erros */
{esp/pdp/espdp006fn.i} /* fnEstoque */

IF  PROGRAM-NAME(1)  MATCHES "*ft4003*" OR
    PROGRAM-NAME(2)  MATCHES "*ft4003*" OR
    PROGRAM-NAME(3)  MATCHES "*ft4003*" OR
    PROGRAM-NAME(4)  MATCHES "*ft4003*" OR
    PROGRAM-NAME(5)  MATCHES "*ft4003*" OR
    PROGRAM-NAME(6)  MATCHES "*ft4003*" OR
    PROGRAM-NAME(7)  MATCHES "*ft4003*" OR
    PROGRAM-NAME(8)  MATCHES "*ft4003*" OR
    PROGRAM-NAME(9)  MATCHES "*ft4003*" OR
    PROGRAM-NAME(10) MATCHES "*ft4003*" OR
    PROGRAM-NAME(11) MATCHES "*ft4003*" OR

    PROGRAM-NAME(1)  MATCHES "*ft4012*" OR 
    PROGRAM-NAME(2)  MATCHES "*ft4012*" OR 
    PROGRAM-NAME(3)  MATCHES "*ft4012*" OR 
    PROGRAM-NAME(4)  MATCHES "*ft4012*" OR 
    PROGRAM-NAME(5)  MATCHES "*ft4012*" OR 
    PROGRAM-NAME(6)  MATCHES "*ft4012*" OR 
    PROGRAM-NAME(7)  MATCHES "*ft4012*" OR 
    PROGRAM-NAME(8)  MATCHES "*ft4012*" OR 
    PROGRAM-NAME(9)  MATCHES "*ft4012*" OR 
    PROGRAM-NAME(10) MATCHES "*ft4012*" OR 
    PROGRAM-NAME(11) MATCHES "*ft4012*" OR 
    
    PROGRAM-NAME(1)  MATCHES "*esftp9005*" OR
    PROGRAM-NAME(2)  MATCHES "*esftp9005*" OR
    PROGRAM-NAME(3)  MATCHES "*esftp9005*" OR
    PROGRAM-NAME(4)  MATCHES "*esftp9005*" OR
    PROGRAM-NAME(5)  MATCHES "*esftp9005*" OR
    PROGRAM-NAME(6)  MATCHES "*esftp9005*" OR
    PROGRAM-NAME(7)  MATCHES "*esftp9005*" OR
    PROGRAM-NAME(8)  MATCHES "*esftp9005*" OR
    PROGRAM-NAME(9)  MATCHES "*esftp9005*" OR
    PROGRAM-NAME(10) MATCHES "*esftp9005*" OR
    PROGRAM-NAME(11) MATCHES "*esftp9005*" OR

    PROGRAM-NAME(1)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(2)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(3)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(4)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(5)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(6)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(7)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(8)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(9)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(10) MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(11) MATCHES "*esftp016rp*" OR

    PROGRAM-NAME(1)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(2)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(3)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(4)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(5)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(6)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(7)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(8)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(9)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(10) MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(11) MATCHES "*espdp006rp*" OR

    PROGRAM-NAME(1)  MATCHES "*espdp094rp*" OR
    PROGRAM-NAME(2)  MATCHES "*espdp094rp*" OR
    PROGRAM-NAME(3)  MATCHES "*espdp094rp*" OR
    PROGRAM-NAME(4)  MATCHES "*espdp094rp*" OR
    PROGRAM-NAME(5)  MATCHES "*espdp094rp*" OR
    PROGRAM-NAME(6)  MATCHES "*espdp094rp*" OR
    PROGRAM-NAME(7)  MATCHES "*espdp094rp*" OR
    PROGRAM-NAME(8)  MATCHES "*espdp094rp*" OR
    PROGRAM-NAME(9)  MATCHES "*espdp094rp*" OR
    PROGRAM-NAME(10) MATCHES "*espdp094rp*" OR
    PROGRAM-NAME(11) MATCHES "*espdp094rp*" OR

    PROGRAM-NAME(1)  MATCHES "*ft4011*" OR
    PROGRAM-NAME(2)  MATCHES "*ft4011*" OR
    PROGRAM-NAME(3)  MATCHES "*ft4011*" OR
    PROGRAM-NAME(4)  MATCHES "*ft4011*" OR
    PROGRAM-NAME(5)  MATCHES "*ft4011*" OR
    PROGRAM-NAME(6)  MATCHES "*ft4011*" OR
    PROGRAM-NAME(7)  MATCHES "*ft4011*" OR
    PROGRAM-NAME(8)  MATCHES "*ft4011*" OR
    PROGRAM-NAME(9)  MATCHES "*ft4011*" OR
    PROGRAM-NAME(10) MATCHES "*ft4011*" OR
    PROGRAM-NAME(11) MATCHES "*ft4011*" OR
    
    PROGRAM-NAME(1)  MATCHES "*ft4002*" OR        
    PROGRAM-NAME(2)  MATCHES "*ft4002*" OR    
    PROGRAM-NAME(3)  MATCHES "*ft4002*" OR    
    PROGRAM-NAME(4)  MATCHES "*ft4002*" OR    
    PROGRAM-NAME(5)  MATCHES "*ft4002*" OR    
    PROGRAM-NAME(6)  MATCHES "*ft4002*" OR    
    PROGRAM-NAME(7)  MATCHES "*ft4002*" OR    
    PROGRAM-NAME(8)  MATCHES "*ft4002*" OR    
    PROGRAM-NAME(9)  MATCHES "*ft4002*" OR    
    PROGRAM-NAME(10) MATCHES "*ft4002*" OR    
    PROGRAM-NAME(11) MATCHES "*ft4002*" THEN DO:

    ASSIGN l-erro = NO.

    FIND FIRST wt-docto NO-LOCK 
         WHERE wt-docto.seq-wt-docto = b-wt-fat-ser-lote.seq-wt-docto NO-ERROR.
    /*
    IDBA Bruno --> M2403-017 Trava faturamento dep¢sito EXP
    IF  VALID-HANDLE(wh-cod-depos-FT4002) 
    AND wh-cod-depos-FT4002:SCREEN-VALUE = 'EXP' 
    AND TODAY >= 06/15/2016 THEN DO:

        IF AVAIL wt-docto THEN DO:

            RUN esp/wmp/eswmpapi006.p( INPUT wt-docto.cod-estabel, OUTPUT l-wms-estab-ativo).
            IF  l-wms-estab-ativo THEN DO:
                IF OPSYS <> 'UNIX' THEN
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 17006,
                                       INPUT "Alocacao Bloqueada para o deposito EXP!~~Deposito bloqueado devido a implantacao do WMS!").
                ELSE
                    PUT "Alocacao Bloqueada para o deposito EXP!~~Deposito bloqueado devido a implantacao do WMS!" SKIP.
                ASSIGN l-erro = YES.
                RETURN "NOK".
            END. /* IF wt-docto.cod-estabel = '104' THEN DO: */
        END. /* IF AVAIL wt-docto THEN DO: */
    END.
    */

    IF v_cod-deposESPDP006 <> '' THEN DO:

        IF AVAIL wt-docto THEN DO:

            FIND FIRST wt-it-docto NO-LOCK 
                 WHERE wt-it-docto.seq-wt-docto    = wt-docto.seq-wt-docto
                   AND wt-it-docto.seq-wt-it-docto = b-wt-fat-ser-lote.seq-wt-it-docto NO-ERROR.

            IF AVAIL wt-it-docto THEN DO:
                
                IF b-wt-fat-ser-lote.cod-depos <> v_cod-deposESPDP006 THEN DO:

                    FIND FIRST b-wt-fat-ser-lote2 EXCLUSIVE-LOCK 
                         WHERE b-wt-fat-ser-lote2.seq-wt-docto    = wt-docto.seq-wt-docto
                           AND b-wt-fat-ser-lote2.seq-wt-it-docto = b-wt-fat-ser-lote.seq-wt-it-docto
                           AND b-wt-fat-ser-lote2.it-codigo       = wt-it-docto.it-codigo
                           AND b-wt-fat-ser-lote2.cod-depos       = v_cod-deposESPDP006 NO-ERROR.

                    IF AVAIL b-wt-fat-ser-lote2 THEN DO:
                        DELETE b-wt-fat-ser-lote2.
                        ASSIGN b-wt-fat-ser-lote.cod-depos     = v_cod-deposESPDP006
                               b-wt-fat-ser-lote.quantidade[1] = wt-it-docto.quantidade[1].
                    END.
                    ELSE DO:
                        ASSIGN b-wt-fat-ser-lote.cod-depos     = v_cod-deposESPDP006
                               b-wt-fat-ser-lote.quantidade[1] = wt-it-docto.quantidade[1].
                    END.
                END. /* IF b-wt-fat-ser-lote.cod-depos <> v_cod-deposESPDP006 THEN DO: */
                ELSE
                    ASSIGN b-wt-fat-ser-lote.quantidade[1] = wt-it-docto.quantidade[1].

                IF b-wt-fat-ser-lote.cod-locali <> '' THEN DO:

                    FIND FIRST deposito NO-LOCK 
                         WHERE deposito.cod-depos = b-wt-fat-ser-lote.cod-depos NO-ERROR.

                    IF AVAIL deposito THEN DO:
                        IF deposito.log-gera-wms  = YES THEN DO:

                            FIND FIRST b-wt-fat-ser-lote2 EXCLUSIVE-LOCK 
                                 WHERE b-wt-fat-ser-lote2.seq-wt-docto     = wt-docto.seq-wt-docto
                                   AND b-wt-fat-ser-lote2.seq-wt-it-docto  = b-wt-fat-ser-lote.seq-wt-it-docto
                                   AND b-wt-fat-ser-lote2.it-codigo        = wt-it-docto.it-codigo
                                   AND b-wt-fat-ser-lote2.cod-depos        = v_cod-deposESPDP006 
                                   AND b-wt-fat-ser-lote2.cod-locali      <> b-wt-fat-ser-lote.cod-locali NO-ERROR.

                            IF AVAIL b-wt-fat-ser-lote2 THEN DO:
                                DELETE b-wt-fat-ser-lote2.

                                ASSIGN b-wt-fat-ser-lote.cod-depos     = v_cod-deposESPDP006
                                       b-wt-fat-ser-lote.quantidade[1] = wt-it-docto.quantidade[1]
                                       b-wt-fat-ser-lote.cod-locali    = ''.
                            END.
                            ELSE DO:
                                ASSIGN b-wt-fat-ser-lote.cod-locali    = '' .
                            END.
                        END. /* IF deposito.log-gera-wms  = YES THEN DO: */
                    END. /* IF AVAIL deposito THEN DO: */
                END. /* IF b-wt-fat-ser-lote.cod-locali <> '' THEN DO: */                
            END. /* IF AVAIL wt-it-docto THEN DO: */
        END. /* IF AVAIL wt-docto THEN DO: */
    END. /* IF v_cod-deposESPDP006 <> '' THEN DO: */

    IF  PROGRAM-NAME(1)  MATCHES "*ft4002*" OR        
        PROGRAM-NAME(2)  MATCHES "*ft4002*" OR    
        PROGRAM-NAME(3)  MATCHES "*ft4002*" OR    
        PROGRAM-NAME(4)  MATCHES "*ft4002*" OR    
        PROGRAM-NAME(5)  MATCHES "*ft4002*" OR    
        PROGRAM-NAME(6)  MATCHES "*ft4002*" OR    
        PROGRAM-NAME(7)  MATCHES "*ft4002*" OR    
        PROGRAM-NAME(8)  MATCHES "*ft4002*" OR    
        PROGRAM-NAME(9)  MATCHES "*ft4002*" OR    
        PROGRAM-NAME(10) MATCHES "*ft4002*" OR    
        PROGRAM-NAME(11) MATCHES "*ft4002*" THEN DO:

        IF  VALID-HANDLE(wh-cod-depos-FT4002) 
        AND VALID-HANDLE(wh-nr-pedcli-ft4002UPC) THEN DO:

            FIND FIRST wt-docto NO-LOCK 
                 WHERE wt-docto.seq-wt-docto = b-wt-fat-ser-lote.seq-wt-docto
                   AND wt-docto.nr-pedcli    = wh-nr-pedcli-ft4002UPC:SCREEN-VALUE NO-ERROR.

            IF AVAIL wt-docto THEN DO:

                FIND FIRST wt-it-docto NO-LOCK 
                     WHERE wt-it-docto.seq-wt-docto    = wt-docto.seq-wt-docto
                       AND wt-it-docto.seq-wt-it-docto = b-wt-fat-ser-lote.seq-wt-it-docto NO-ERROR.

                IF AVAIL wt-it-docto THEN DO:

                    IF b-wt-fat-ser-lote.cod-depos <> wh-cod-depos-FT4002:SCREEN-VALUE THEN DO:

                        FIND FIRST b-wt-fat-ser-lote2 EXCLUSIVE-LOCK 
                             WHERE b-wt-fat-ser-lote2.seq-wt-docto    = wt-docto.seq-wt-docto
                               AND b-wt-fat-ser-lote2.seq-wt-it-docto = b-wt-fat-ser-lote.seq-wt-it-docto
                               AND b-wt-fat-ser-lote2.it-codigo       = wt-it-docto.it-codigo
                               AND b-wt-fat-ser-lote2.cod-depos       = wh-cod-depos-FT4002:SCREEN-VALUE NO-ERROR.

                        IF AVAIL b-wt-fat-ser-lote2 THEN DO:
                            DELETE b-wt-fat-ser-lote2.
                            ASSIGN b-wt-fat-ser-lote.cod-depos     = wh-cod-depos-FT4002:SCREEN-VALUE
                                   b-wt-fat-ser-lote.quantidade[1] = IF  VALID-HANDLE (wh-quantidade-ft4004) 
                                                                     AND DEC(wh-quantidade-ft4004:SCREEN-VALUE) <> 0 THEN 
                                                                         DEC(wh-quantidade-ft4004:SCREEN-VALUE)
                                                                     ELSE wt-it-docto.quantidade[1].
                        END.
                        ELSE DO:
                            ASSIGN b-wt-fat-ser-lote.cod-depos     = wh-cod-depos-FT4002:SCREEN-VALUE
                                   b-wt-fat-ser-lote.quantidade[1] = IF  VALID-HANDLE (wh-quantidade-ft4004) 
                                                                     AND DEC(wh-quantidade-ft4004:SCREEN-VALUE) <> 0 THEN 
                                                                         DEC(wh-quantidade-ft4004:SCREEN-VALUE)
                                                                     ELSE wt-it-docto.quantidade[1].
                        END.
                    END.
                    ELSE
                        ASSIGN b-wt-fat-ser-lote.quantidade[1] = IF  VALID-HANDLE (wh-quantidade-ft4004) 
                                                                 AND DEC(wh-quantidade-ft4004:SCREEN-VALUE) <> 0 THEN 
                                                                     DEC(wh-quantidade-ft4004:SCREEN-VALUE)
                                                                 ELSE wt-it-docto.quantidade[1].

                    IF b-wt-fat-ser-lote.cod-locali <> '' THEN DO:

                        FIND FIRST deposito NO-LOCK 
                             WHERE deposito.cod-depos = b-wt-fat-ser-lote.cod-depos NO-ERROR.

                        IF AVAIL deposito THEN DO:
                            IF deposito.log-gera-wms  = YES THEN DO:
                                FIND FIRST b-wt-fat-ser-lote2 EXCLUSIVE-LOCK 
                                     WHERE b-wt-fat-ser-lote2.seq-wt-docto     = wt-docto.seq-wt-docto
                                       AND b-wt-fat-ser-lote2.seq-wt-it-docto  = b-wt-fat-ser-lote.seq-wt-it-docto
                                       AND b-wt-fat-ser-lote2.it-codigo        = wt-it-docto.it-codigo
                                       AND b-wt-fat-ser-lote2.cod-depos        = wh-cod-depos-FT4002:SCREEN-VALUE 
                                       AND b-wt-fat-ser-lote2.cod-locali      <> b-wt-fat-ser-lote.cod-locali NO-ERROR.

                                IF AVAIL b-wt-fat-ser-lote2 THEN DO:
                                    DELETE b-wt-fat-ser-lote2.

                                    ASSIGN b-wt-fat-ser-lote.cod-depos     = wh-cod-depos-FT4002:SCREEN-VALUE
                                           b-wt-fat-ser-lote.quantidade[1] = IF  VALID-HANDLE (wh-quantidade-ft4004) 
                                                                             AND DEC(wh-quantidade-ft4004:SCREEN-VALUE) <> 0 THEN 
                                                                                 DEC(wh-quantidade-ft4004:SCREEN-VALUE)
                                                                             ELSE wt-it-docto.quantidade[1]
                                           b-wt-fat-ser-lote.cod-locali    = ''.
                                END.
                                ELSE DO:
                                    ASSIGN b-wt-fat-ser-lote.cod-locali    = '' .
                                END.
                            END. /* IF deposito.log-gera-wms  = YES THEN DO: */
                        END. /* IF AVAIL deposito THEN DO: */
                    END. /* IF b-wt-fat-ser-lote.cod-locali <> '' THEN DO: */
                END. /* IF AVAIL wt-it-docto THEN DO: */
            END. /* IF AVAIL wt-docto THEN DO: */
        END. /* IF  VALID-HANDLE(wh-cod-depos-FT4002) AND VALID-HANDLE(wh-nr-pedcli-ft4002UPC) THEN DO: */
    END. /* FT4002 */


    /******* Verifica se o item est† bloqueado ou reprovado por n∆o atender ao valor m°nimo   *******/
    /******* Neste caso, n∆o deve alocar ...o bloqueio e a mensagem de erro est∆ono no Ft4002 *******/
    FIND FIRST wt-docto NO-LOCK
         WHERE wt-docto.seq-wt-docto = b-wt-fat-ser-lote.seq-wt-docto NO-ERROR.

    FIND FIRST wt-it-docto NO-LOCK
         WHERE wt-it-docto.seq-wt-docto    = wt-docto.seq-wt-docto
           AND wt-it-docto.seq-wt-it-docto = b-wt-fat-ser-lote.seq-wt-it-docto NO-ERROR.

    IF  CAN-FIND(FIRST int-ped-item NO-LOCK
                 WHERE int-ped-item.nome-abrev   = wt-docto.nome-abrev
                   AND int-ped-item.nr-pedcli    = wt-it-docto.nr-pedcli
                   AND int-ped-item.nr-sequencia = wt-it-docto.nr-sequencia
                   AND int-ped-item.it-codigo    = wt-it-docto.it-codigo
                   AND int-ped-item.cod-refer    = wt-it-docto.cod-refer
                   AND (int-ped-item.ind-status-preco = 1 OR int-ped-item.ind-status-preco = 3)) THEN
        RETURN "OK".
    /************************************************************************************************/
    IF  (NOT PROGRAM-NAME(1)  MATCHES "*esftp009*" OR PROGRAM-NAME(1)  = ?) AND
        (NOT PROGRAM-NAME(2)  MATCHES "*esftp009*" OR PROGRAM-NAME(2)  = ?) AND 
        (NOT PROGRAM-NAME(3)  MATCHES "*esftp009*" OR PROGRAM-NAME(3)  = ?) AND 
        (NOT PROGRAM-NAME(4)  MATCHES "*esftp009*" OR PROGRAM-NAME(4)  = ?) AND 
        (NOT PROGRAM-NAME(5)  MATCHES "*esftp009*" OR PROGRAM-NAME(5)  = ?) AND 
        (NOT PROGRAM-NAME(6)  MATCHES "*esftp009*" OR PROGRAM-NAME(6)  = ?) AND /* QUANDO PARTIU DESTE PROGRAMA ê PORQUE JA FOI ALOCADO NO ESFTP012 */
        (NOT PROGRAM-NAME(7)  MATCHES "*esftp009*" OR PROGRAM-NAME(7)  = ?) AND 
        (NOT PROGRAM-NAME(8)  MATCHES "*esftp009*" OR PROGRAM-NAME(8)  = ?) AND 
        (NOT PROGRAM-NAME(9)  MATCHES "*esftp009*" OR PROGRAM-NAME(9)  = ?) AND 
        (NOT PROGRAM-NAME(10) MATCHES "*esftp009*" OR PROGRAM-NAME(10) = ?) AND 
        (NOT PROGRAM-NAME(11) MATCHES "*esftp009*" OR PROGRAM-NAME(11) = ?) THEN DO:

        IF b-wt-fat-ser-lote.cod-depos     = 'EXP' THEN
            ASSIGN b-wt-fat-ser-lote.cod-locali = ''.

        IF  NOT AVAIL b-old-wt-fat-ser-lote 
        AND AVAIL b-wt-fat-ser-lote THEN DO:

            FIND FIRST wt-docto NO-LOCK 
                 WHERE wt-docto.seq-wt-docto = b-wt-fat-ser-lote.seq-wt-docto NO-ERROR.

            FIND FIRST natur-oper NO-LOCK 
                 WHERE natur-oper.nat-operacao = wt-docto.nat-operacao NO-ERROR.

            IF  AVAIL natur-oper 
            AND natur-oper.baixa-estoq = YES THEN DO:

                RUN pi-aloca  (INPUT wt-docto.cod-estabel,
                               INPUT b-wt-fat-ser-lote.it-codigo,
                               INPUT b-wt-fat-ser-lote.cod-depos,
                               INPUT b-wt-fat-ser-lote.cod-localiz,
                               INPUT b-wt-fat-ser-lote.quantidade[1],
                               INPUT b-wt-fat-ser-lote.lote).
            END.
        END.
        ELSE DO:

             IF AVAIL b-old-wt-fat-ser-lote and
                AVAIL b-wt-fat-ser-lote THEN DO:

                 FIND FIRST wt-docto NO-LOCK 
                      WHERE wt-docto.seq-wt-docto = b-wt-fat-ser-lote.seq-wt-docto NO-ERROR.

                 FIND FIRST natur-oper NO-LOCK 
                      WHERE natur-oper.nat-operacao  = wt-docto.nat-operacao NO-ERROR.

                 IF AVAIL natur-oper AND natur-oper.baixa-estoq = YES THEN


                     IF b-wt-fat-ser-lote.quantidade[1] > b-old-wt-fat-ser-lote.quantidade[1] THEN DO:

                         RUN pi-aloca  (INPUT wt-docto.cod-estabel,
                                        INPUT b-wt-fat-ser-lote.it-codigo,
                                        INPUT b-wt-fat-ser-lote.cod-depos,
                                        INPUT b-wt-fat-ser-lote.cod-localiz,
                                        INPUT b-wt-fat-ser-lote.quantidade[1] - b-old-wt-fat-ser-lote.quantidade[1],
                                        INPUT b-wt-fat-ser-lote.lote).
                     END.
                     ELSE DO: 
                         RUN pi-desaloca  (INPUT wt-docto.cod-estabel,
                                           INPUT b-wt-fat-ser-lote.it-codigo,
                                           INPUT b-wt-fat-ser-lote.cod-depos,
                                           INPUT b-wt-fat-ser-lote.cod-localiz,
                                           INPUT b-old-wt-fat-ser-lote.quantidade[1] - b-wt-fat-ser-lote.quantidade[1],
                                           INPUT b-wt-fat-ser-lote.lote).
                     END.
                 IF l-erro = YES THEN DO:
                    RETURN "NOK".
                 END.
             END.
        END.
        IF l-erro = YES THEN DO:
           RETURN "NOK".
        END.
    END.
END.

PROCEDURE pi-aloca:
   DEFINE INPUT PARAMETER c-cod-estabel  AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER c-item         AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER c-cod-depos    AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER c-cod-localiz  AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER de-qtde        AS DECIMAL     NO-UNDO.
   DEFINE INPUT PARAMETER p-c-lote       AS CHAR        NO-UNDO.

   DEFINE VARIABLE d-qtde-reservas-ast AS DECIMAL     NO-UNDO.
   DEFINE VARIABLE c-usuar-reservas    AS CHARACTER   NO-UNDO.

   FIND FIRST deposito NO-LOCK 
        WHERE deposito.cod-depos    = c-cod-depos
          AND deposito.log-gera-wms = YES NO-ERROR.

   IF AVAIL deposito THEN 
       ASSIGN c-cod-localiz = ''.
   
   FIND FIRST ITEM NO-LOCK 
        WHERE ITEM.it-codigo = c-item NO-ERROR.

   IF  AVAIL item AND item.baixa-estoq AND item.tipo-contr <> 4 THEN DO:

       FIND FIRST ped-venda NO-LOCK
            WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
              AND ped-venda.nr-pedcli  = wt-docto.nr-pedcli NO-ERROR.

       FIND FIRST int-ped-venda2 NO-LOCK
            WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
              AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

       EMPTY TEMP-TABLE tt-prog-ponto.
       EMPTY TEMP-TABLE tt-usuarios-reserva.
       RUN esp/es0018p.p (INPUT "wsO0003":U, INPUT 2, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
       FIND FIRST tt-prog-ponto NO-ERROR.
       IF  AVAIL tt-prog-ponto THEN DO:
           FOR EACH tt-prog-ponto:
               CREATE tt-usuarios-reserva.
               ASSIGN tt-usuarios-reserva.usuario = tt-prog-ponto.conteudo.
           END.
       END.

       FOR EACH reservas-ast
           WHERE reservas-ast.cod-depos    = c-cod-depos
           AND   reservas-ast.it-codigo    = c-item
           AND   reservas-ast.cod-estabel  = c-cod-estabel
           AND   reservas-ast.dt-reserva   <= TODAY NO-LOCK:

           IF reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY THEN DO:

               IF  AVAIL int-ped-venda2
               AND int-ped-venda2.PedidoeCommerce <> "" THEN DO:
                   /*Caso existam reservas mas os usu†rio reservam para VTEX*/
                   IF  CAN-FIND(FIRST tt-usuarios-reserva
                                WHERE tt-usuarios-reserva.usuario = reservas-ast.cd-usuario) THEN
                       NEXT.
               END.

               ASSIGN d-qtde-reservas-ast = d-qtde-reservas-ast + reservas-ast.qt-reserva
                      c-usuar-reservas    = c-usuar-reservas + (IF c-usuar-reservas = "" THEN "" ELSE ", ") + reservas-ast.cd-usuario.
           END.
       END.

       IF d-qtde-reservas-ast > 0 THEN DO:
           IF fnEstoque(c-cod-estabel,c-item, c-cod-depos, "*", NO) < (d-qtde-reservas-ast + de-qtde) THEN DO:
               IF OPSYS <> 'UNIX' THEN
                   RUN utp/ut-msgs.p (INPUT "SHOW",
                                      INPUT 17006,
                                      INPUT "H† reservas de saldo~~Entrar em contato com a pessoa que fez a reserva: " + c-usuar-reservas + "! ITEM: " + c-item + " Dep." + c-cod-depos + " Estab. " + c-cod-estabel + ".").
               ELSE
                   PUT "H† reservas de saldo. Entrar em contato com a pessoa que fez a reserva: " + c-usuar-reservas + "! ITEM: " + c-item + " Dep." + c-cod-depos + " Estab. " + c-cod-estabel + ".".

               RETURN "NOK".
           END.
       END.
        
        /* tratativa para estabelecimento Decio alocar no deposito PRO */
       EMPTY TEMP-TABLE tt-prog-ponto.
       RUN esp/es0018p.p (INPUT "wdi320":U, INPUT 1, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).
       FIND FIRST tt-prog-ponto NO-ERROR.
       IF  AVAIL tt-prog-ponto THEN DO:
                IF c-cod-estabel BEGINS "6" 
                    AND c-cod-depos = ENTRY(1,tt-prog-ponto.conteudo,";") THEN
                    ASSIGN c-cod-depos = ENTRY(2,tt-prog-ponto.conteudo,";").
       END.

       FIND FIRST b-saldo-estoq no-lock
            WHERE b-saldo-estoq.it-codigo   = c-item
              AND b-saldo-estoq.cod-estabel = c-cod-estabel
              AND b-saldo-estoq.cod-depos   = c-cod-depos
              AND b-saldo-estoq.cod-localiz = c-cod-localiz
              AND b-saldo-estoq.lote        = p-c-lote NO-ERROR.

        IF AVAIL b-saldo-estoq THEN DO:
            
            IF  b-wt-fat-ser-lote.cod-depos <> 'ACA' 
            AND b-wt-fat-ser-lote.cod-depos <> 'ALM'  THEN DO:
              
                IF b-saldo-estoq.cod-estabel BEGINS "6" THEN DO:
                    IF b-wt-fat-ser-lote.cod-depos = ENTRY(1,tt-prog-ponto.conteudo,";") THEN
                        ASSIGN b-wt-fat-ser-lote.cod-depos = b-saldo-estoq.cod-depos.
                END.
                
                IF fnEstoque(c-cod-estabel, c-item, c-cod-depos, "", NO) < DEC(de-qtde) THEN DO:
                    IF OPSYS <> 'UNIX' THEN
                        MESSAGE "A Quantidade a ser Alocada : " de-qtde " Maior que Quantidade disponivel: " fnEstoque(c-cod-estabel, c-item, c-cod-depos, "", NO) " do item: " c-item " Deposito: "  c-cod-depos " - " c-cod-localiz VIEW-AS ALERT-BOX.
                    ELSE
                        PUT "B Quantidade a ser Alocada : " de-qtde " Maior que Quantidade disponivel: " fnEstoque(c-cod-estabel, c-item, c-cod-depos, "",NO) " do item: " c-item " Deposito: "  c-cod-depos " - " c-cod-localiz SKIP.
                  ASSIGN l-erro = YES.
                  RETURN "NOK".
               end.
            END.

            /*Aloca Saldo*/
            find current b-saldo-estoq exclusive-lock no-error.
            ASSIGN b-saldo-estoq.qt-alocada = b-saldo-estoq.qt-alocada + de-qtde.
            release b-saldo-estoq.
                
            FIND FIRST wt-fat-ser-lote EXCLUSIVE-LOCK 
                 WHERE ROWID(wt-fat-ser-lote) = ROWID(b-wt-fat-ser-lote) NO-ERROR.

            IF AVAIL wt-fat-ser-lote THEN
               ASSIGN wt-fat-ser-lote.log-1 = YES.
            
            FIND FIRST wt-docto EXCLUSIVE-LOCK 
                 WHERE wt-docto.seq-wt-docto = wt-fat-ser-lote.seq-wt-docto NO-ERROR.
            
            IF AVAIL wt-docto THEN
                ASSIGN wt-docto.ind-lib-nota = YES.
        END.
        ELSE DO:
            IF  b-wt-fat-ser-lote.cod-depos <> 'ACA'
            AND b-wt-fat-ser-lote.cod-depos <> 'ALM' THEN DO:

                IF OPSYS <> 'UNIX' THEN
                  MESSAGE "Saldo em Estoque n∆o encontrado para item: " c-item " Deposito: "  c-cod-depos " - " c-cod-localiz " - Pedido " wt-docto.nr-pedcli VIEW-AS ALERT-BOX.
                ELSE
                    PUT "Saldo em Estoque n∆o encontrado para item: " c-item " Deposito: "  c-cod-depos " - " c-cod-localiz " - Pedido " wt-docto.nr-pedcli SKIP. 

                ASSIGN l-erro = YES.
                RETURN "NOK".
            END.
        END.

        FIND CURRENT b-saldo-estoq NO-LOCK NO-ERROR.
        RELEASE b-saldo-estoq.

        /*marcio*/
        FIND CURRENT b-wt-fat-ser-lote NO-LOCK NO-ERROR.
        FIND CURRENT wt-fat-ser-lote NO-LOCK NO-ERROR.
   END.


END PROCEDURE.

PROCEDURE pi-desaloca:
   DEFINE INPUT PARAMETER c-cod-estabel AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER c-item         AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER c-cod-depos    AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER c-cod-localiz  AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER de-qtde        AS DECIMAL     NO-UNDO.
   DEFINE INPUT PARAMETER p-c-lote       AS CHAR        NO-UNDO.

   FIND FIRST deposito NO-LOCK 
        WHERE deposito.cod-depos    = c-cod-depos
          AND deposito.log-gera-wms = YES NO-ERROR.

   IF AVAIL deposito THEN 
       ASSIGN c-cod-localiz = ''.

   FIND FIRST ITEM NO-LOCK 
        WHERE ITEM.it-codigo = c-item NO-ERROR.

   IF  AVAIL ITEM 
   AND ITEM.baixa-estoq 
   AND ITEM.tipo-contr <> 4 THEN DO:

       FIND FIRST saldo-estoq NO-LOCK 
            WHERE saldo-estoq.it-codigo   = c-item
              AND saldo-estoq.cod-estabel = c-cod-estabel
              AND saldo-estoq.cod-depos   = c-cod-depos
              AND saldo-estoq.cod-localiz = c-cod-localiz 
              AND saldo-estoq.lote        = p-c-lote NO-ERROR.

       IF AVAIL saldo-estoq THEN DO:
           IF saldo-estoq.qt-alocada < DEC(de-qtde) THEN DO:
               IF OPSYS <> 'UNIX' THEN
                   MESSAGE "Quantidade Alocada: " saldo-estoq.qt-alocada " Menor que Quantidade: " de-qtde " do item: " c-item  " Deposito: "  c-cod-depos " - " c-cod-localiz  VIEW-AS ALERT-BOX.
               ELSE
                   PUT "Quantidade Alocada: " saldo-estoq.qt-alocada " Menor que Quantidade: " de-qtde " do item: " c-item  " Deposito: "  c-cod-depos " - " c-cod-localiz SKIP.

               ASSIGN l-erro = YES.
               RETURN "NOK".
           END.

           FIND CURRENT saldo-estoq EXCLUSIVE-LOCK NO-ERROR.

           ASSIGN saldo-estoq.qt-alocada = saldo-estoq.qt-alocada - de-qtde.

           FIND CURRENT saldo-estoq NO-LOCK NO-ERROR.
           RELEASE saldo-estoq.
       END.
       ELSE DO:
           IF OPSYS <> 'UNIX' THEN
               MESSAGE "Saldo em Estoque n∆o Encontrado para item: " c-item " Deposito: "  c-cod-depos " - " c-cod-localiz  VIEW-AS ALERT-BOX.
           ELSE
               PUT "Saldo em Estoque n∆o Encontrado para item: " c-item " Deposito: "  c-cod-depos " - " c-cod-localiz SKIP.
    
           ASSIGN l-erro = YES.
           RETURN "NOK".
       END.
   END.

END PROCEDURE.


