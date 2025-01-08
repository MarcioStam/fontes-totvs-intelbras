/********************************************************************************
 ** UPC........: wdi159.p - UPC WRITE reg-inf-compl    
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de pedidos de venda para a Base Oracle
 ********************************************************************************/
DEFINE BUFFER usuar_mestre FOR usuar_mestre.

DEF PARAM BUFFER b-inf-compl        FOR inf-compl.
DEF PARAM BUFFER b-old-inf-compl    FOR inf-compl.
DEF NEW GLOBAL SHARED var v_cod_usuar_corren AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-item              AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-estab             AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-fci               AS LOGICAL     NO-UNDO.

ASSIGN l-item   = NO
       l-estab  = NO
       l-fci    = NO.

IF PROGRAM-NAME(1)  MATCHES "*FT0918*" OR 
   PROGRAM-NAME(2)  MATCHES "*FT0918*" OR
   PROGRAM-NAME(3)  MATCHES "*FT0918*" OR
   PROGRAM-NAME(4)  MATCHES "*FT0918*" OR
   PROGRAM-NAME(5)  MATCHES "*FT0918*" OR
   PROGRAM-NAME(6)  MATCHES "*FT0918*" OR
   PROGRAM-NAME(7)  MATCHES "*FT0918*" OR
   PROGRAM-NAME(8)  MATCHES "*FT0918*" OR
   PROGRAM-NAME(9)  MATCHES "*FT0918*" OR
   PROGRAM-NAME(10) MATCHES "*FT0918*" OR
   PROGRAM-NAME(11) MATCHES "*FT0918*" THEN DO:
    
    IF (NUM-ENTRIES(TRIM(b-inf-compl.cod-indice),CHR(2))) = 3 THEN DO:
        
        IF  b-old-inf-compl.cdn-identif = 0
        AND b-old-inf-compl.cod-indice  = ''
        AND b-old-inf-compl.num-campo   = 0 THEN DO:

            FOR FIRST reg-inf-compl NO-LOCK
                WHERE reg-inf-compl.cod-tab-inform   = "FCI":U
                AND   reg-inf-compl.cod-campo-inform = "FCI":U,
                EACH  inf-compl NO-LOCK
                WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif:

                IF (NUM-ENTRIES(TRIM(inf-compl.cod-indice),CHR(2))) = 3 THEN DO:

                    IF  NUM-ENTRIES(TRIM(inf-compl.cod-indice),CHR(2))      >= 2
                    AND NUM-ENTRIES(TRIM(b-inf-compl.cod-indice),CHR(2))    >= 2
                    AND ENTRY(2,TRIM(inf-compl.cod-indice),CHR(2))           = ENTRY(2,TRIM(b-inf-compl.cod-indice),CHR(2)) THEN DO:
                        IF  NUM-ENTRIES(TRIM(inf-compl.cod-indice),CHR(2))      >= 1
                        AND NUM-ENTRIES(TRIM(b-inf-compl.cod-indice),CHR(2))    >= 1
                        AND ENTRY(1,TRIM(inf-compl.cod-indice),CHR(2))           = ENTRY(1,TRIM(b-inf-compl.cod-indice),CHR(2)) THEN DO:
                            ASSIGN l-estab = YES.
                        END.

                        FIND FIRST ITEM NO-LOCK
                             WHERE ITEM.it-codigo =  ENTRY(2,TRIM(inf-compl.cod-indice),CHR(2)) NO-ERROR.

                        ASSIGN l-item = YES.
                    END.

                    IF inf-compl.cod-livre-1 <> '' THEN DO:
                        IF  l-item                = YES 
                        AND l-estab               = YES 
                        AND inf-compl.cod-livre-1 = b-inf-compl.cod-livre-1 THEN
                            ASSIGN l-fci = YES.
                    END. /* IF inf-compl.cod-livre-1 <> '' THEN DO: */

                END.
                IF l-item = YES AND l-estab = YES AND l-fci = YES THEN LEAVE.
            END.

            IF l-item = YES AND l-estab = YES AND l-fci = YES THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                                   INPUT 17006, 
                                   INPUT "FCI Invalida!~~Ja existe esta FCI para este estabelecimento/item.").
                ASSIGN ERROR-STATUS:ERROR = YES.
                RETURN 'nok'.
            END. /* IF l-item = YES AND l-estab = YES THEN DO: */

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo =  ENTRY(2,TRIM(inf-compl.cod-indice),CHR(2)) NO-ERROR.

            
            IF  b-inf-compl.cod-livre-1 <> '' THEN DO:
                FIND FIRST int-item NO-LOCK
                     WHERE int-item.it-codigo = entry(2,b-inf-compl.cod-indice,CHR(2)) NO-ERROR.

                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = int-item.it-codigo NO-ERROR.

                IF  AVAIL int-item
                AND int-item.nr-ped-energia <> "" THEN DO:

                    FIND FIRST int-ped-venda NO-LOCK
                         WHERE int-ped-venda.nr-pedido  = int(int-item.nr-ped-energia) NO-ERROR.

                    IF  AVAIL int-ped-venda
                    AND int-ped-venda.ind-status-solar = 2 THEN DO:
                        FIND CURRENT ITEM EXCLUSIVE-LOCK.
                        ASSIGN ITEM.ind-item-fat = YES.
                        FIND CURRENT ITEM NO-LOCK.
                    END.
                END.
            END.
            

        END.
    END. /* IF (NUM-ENTRIES(TRIM(b-inf-compl.cod-indice),CHR(2))) = 3 THEN DO: */

END. /* FT0918 */

RETURN 'ok'.

    



