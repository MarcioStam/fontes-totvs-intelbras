
DEF PARAM BUFFER b-wt-fat-ser-lote     FOR wt-fat-ser-lote.
/*DEF PARAM BUFFER b-old-nota-fiscal  FOR movdis.nota-fiscal.
  */
DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-simula-ft4003         AS LOG               NO-UNDO.

ASSIGN l-erro = NO.
    
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

    IF  (NOT PROGRAM-NAME(1)  MATCHES "*efetivanota*" OR PROGRAM-NAME(1) = ?) AND
        (NOT PROGRAM-NAME(2)  MATCHES "*efetivanota*" OR PROGRAM-NAME(2) = ?) AND 
        (NOT PROGRAM-NAME(3)  MATCHES "*efetivanota*" OR PROGRAM-NAME(3) = ?) AND 
        (NOT PROGRAM-NAME(4)  MATCHES "*efetivanota*" OR PROGRAM-NAME(4) = ?) AND 
        (NOT PROGRAM-NAME(5)  MATCHES "*efetivanota*" OR PROGRAM-NAME(5) = ?) AND 
        (NOT PROGRAM-NAME(6)  MATCHES "*efetivanota*" OR PROGRAM-NAME(6) = ?) AND 
        (NOT PROGRAM-NAME(7)  MATCHES "*efetivanota*" OR PROGRAM-NAME(7) = ?) AND 
        (NOT PROGRAM-NAME(8)  MATCHES "*efetivanota*" OR PROGRAM-NAME(8) = ?) AND 
        (NOT PROGRAM-NAME(9)  MATCHES "*efetivanota*" OR PROGRAM-NAME(9) = ?) AND 
        (NOT PROGRAM-NAME(10) MATCHES "*efetivanota*" OR PROGRAM-NAME(10) = ?) AND 
        (NOT PROGRAM-NAME(11) MATCHES "*efetivanota*" OR PROGRAM-NAME(11) = ?) THEN DO:

        IF AVAIL b-wt-fat-ser-lote THEN DO:
            
            /*IF  b-wt-fat-ser-lote.cod-depos <> 'EXP' THEN NEXT.*/
            FIND FIRST wt-docto WHERE wt-docto.seq-wt-docto = b-wt-fat-ser-lote.seq-wt-docto NO-LOCK NO-ERROR.
            IF AVAIL wt-docto 
            THEN DO:
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
                    (NOT PROGRAM-NAME(11) MATCHES "*esftp009*" OR PROGRAM-NAME(11) = ?) AND
                     NOT l-simula-ft4003 /* tratativa para n∆o desalocar itens regra na upc ft4003 */
                THEN DO:
                    RUN pi-desaloca  (INPUT wt-docto.cod-estabel,
                                      INPUT b-wt-fat-ser-lote.it-codigo,
                                      INPUT b-wt-fat-ser-lote.cod-depos,
                                      INPUT b-wt-fat-ser-lote.cod-localiz,
                                      INPUT b-wt-fat-ser-lote.quantidade[1],
                                      INPUT b-wt-fat-ser-lote.lote).
                END.
            END.
            IF l-erro = YES THEN DO:
                RETURN "NOK".
            END.
        END.
    END.
END.


PROCEDURE pi-desaloca:
   DEFINE INPUT PARAMETER c-cod-estabel AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER c-item         AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER c-cod-depos    AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER c-cod-localiz  AS CHARACTER   NO-UNDO.
   DEFINE INPUT PARAMETER de-qtde        AS DECIMAL     NO-UNDO.
   DEFINE INPUT PARAMETER p-c-lote       AS CHARACTER  NO-UNDO.

   FIND FIRST deposito 
       WHERE deposito.cod-depos = c-cod-depos NO-LOCK NO-ERROR.
   IF AVAIL deposito THEN DO:
       IF deposito.log-gera-wms  = YES THEN
           ASSIGN c-cod-localiz = ''.
   END.

   FIND FIRST ITEM WHERE ITEM.it-codigo = c-item NO-LOCK NO-ERROR.
   IF AVAIL ITEM AND ITEM.baixa-estoq AND ITEM.tipo-contr <> 4 THEN DO:

       FIND FIRST saldo-estoq
            WHERE saldo-estoq.it-codigo   = c-item
              AND saldo-estoq.cod-estabel = c-cod-estabel
              AND saldo-estoq.cod-depos   = c-cod-depos
              AND saldo-estoq.cod-localiz = c-cod-localiz 
              AND saldo-estoq.lote        = p-c-lote no-lock NO-ERROR.
        IF AVAIL saldo-estoq THEN DO:

           if saldo-estoq.qt-alocada < dec(de-qtde) then do:
              IF OPSYS <> 'UNIX' THEN
                  message "Quantidade Alocada: " saldo-estoq.qt-alocada " Menor que Quantidade: " de-qtde " do item: " c-item view-as alert-box.
              ELSE
                  PUT "Quantidade Alocada: " saldo-estoq.qt-alocada " Menor que Quantidade: " de-qtde " do item: " c-item.

              ASSIGN l-erro = YES.
              RETURN "NOK".
           end.

           find current saldo-estoq exclusive-lock no-error.
               assign saldo-estoq.qt-alocada = saldo-estoq.qt-alocada - de-qtde.
               release saldo-estoq.
        END. /* IF AVAIL saldo-estoq THEN DO: */
        
        ELSE DO:

            IF OPSYS <> 'UNIX' THEN
                message "Saldo em Estoque n∆o Encontrado para item: " c-item view-as alert-box.
            ELSE
                PUT "Saldo em Estoque n∆o Encontrado para item: " c-item.
              ASSIGN l-erro = YES.
              RETURN "NOK".

        END. /* IF NOT AVAIL saldo-estoq THEN DO: */

   END. /* IF AVAIL ITEM AND ITEM.baixa-estoq AND ITEM.tipo-contr <> 4 THEN DO: */

END PROCEDURE.
