DEFINE VARIABLE i AS INTEGER     NO-UNDO.
DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)"
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD it-codigo-ini    AS CHAR
    FIELD it-codigo-fim    AS CHAR.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD it-codigo         AS CHARACTER FORMAT "x(16)"
    INDEX id it-codigo.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE STREAM str-excel.

{utp/ut-glob.i}
{esp/es0018.i}

DEFINE VARIABLE h-acomp        AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-excel        AS CHARACTER NO-UNDO.
DEFINE VARIABLE es-codigo-desc LIKE ITEM.desc-item.

DEFINE BUFFER b-estrutura  FOR estrutura.
DEFINE BUFFER b2-estrutura FOR estrutura.
DEFINE BUFFER b-item       FOR ITEM.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.
      
FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX" THEN DO:
    RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                       INPUT 1,           /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR FIRST tt-prog-ponto NO-LOCK:
        ASSIGN c-excel = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".
        OS-CREATE-DIR VALUE(c-excel).
        ASSIGN c-excel = c-excel + "esenp031-" + STRING(TIME,"99999") + ".csv".
    END.
END.
ELSE DO:
    RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR FIRST tt-prog-ponto NO-LOCK:
        ASSIGN c-excel = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".
        OS-CREATE-DIR VALUE(c-excel).
        ASSIGN c-excel = c-excel + "esenp031-" + STRING(TIME,"99999") + ".csv".
    END.
END. 

OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET "iso8859-1".

/*Main*/
PUT STREAM str-excel UNFORMATTED  "Componente;Des Componente;Produto;Des Produto;Garantia;Venda;EPV(104);DPV(104);SAL(104);WEX(104);WEX(103);EXP(105);Sit Produto" SKIP.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Gerando Relat¢rio."). 

RUN piMontaRelat.

RUN pi-finalizar IN h-acomp.

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START excel VALUE(c-excel).
END.
/******/

PROCEDURE piMontaRelat:
    
    IF CAN-FIND (FIRST tt-digita) THEN DO:
        FOR EACH tt-digita:
            FOR EACH estrutura NO-LOCK
               WHERE estrutura.es-codigo     = tt-digita.it-codigo
                 AND estrutura.data-inicio  <= TODAY
                 AND estrutura.data-termino >= TODAY:

                IF AVAIL estrutura THEN DO:
                    IF CAN-FIND (FIRST b-estrutura NO-LOCK
                                 WHERE b-estrutura.es-codigo = estrutura.it-codigo
                                   AND b-estrutura.data-inicio  <= TODAY
                                   AND b-estrutura.data-termino >= TODAY) THEN DO:
                        RUN pi-sobe-estrutura (INPUT estrutura.it-codigo).
                    END.
                    ELSE DO: 
                        FIND FIRST b-estrutura OF estrutura NO-LOCK NO-ERROR.
                        IF AVAIL b-estrutura THEN
                            RUN pi-imprime.
                    END.
                END.
            END.

            FOR EACH estrut-astec NO-LOCK
               WHERE estrut-astec.es-codigo = tt-digita.it-codigo:

                RUN pi-imprime-astec.
            END.
        END.
    END.
    ELSE DO:
        FOR EACH estrutura NO-LOCK
           WHERE estrutura.es-codigo >= tt-param.it-codigo-ini
             AND estrutura.es-codigo <= tt-param.it-codigo-fim
             AND estrutura.data-inicio  <= TODAY
             AND estrutura.data-termino >= TODAY :
            
            IF CAN-FIND (FIRST b-estrutura NO-LOCK
                         WHERE b-estrutura.es-codigo = estrutura.it-codigo
                           AND b-estrutura.data-inicio  <= TODAY
                           AND b-estrutura.data-termino >= TODAY) THEN DO:
                RUN pi-sobe-estrutura (INPUT estrutura.it-codigo).
            END.
            ELSE DO:
                FIND FIRST b-estrutura OF estrutura NO-LOCK NO-ERROR.
                IF AVAIL b-estrutura THEN
                    RUN pi-imprime.
            END.
        END.

        FOR EACH estrut-astec NO-LOCK
           WHERE estrut-astec.es-codigo >= tt-param.it-codigo-ini
             AND estrut-astec.es-codigo <= tt-param.it-codigo-fim:

            RUN pi-imprime-astec.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-sobe-estrutura:
    DEFINE INPUT PARAM p-it-codigo AS CHAR.

    FOR EACH b-estrutura NO-LOCK
       WHERE b-estrutura.es-codigo = p-it-codigo
         AND b-estrutura.data-inicio  <= TODAY
         AND b-estrutura.data-termino >= TODAY:

        IF NOT CAN-FIND(FIRST b2-estrutura
                        WHERE b2-estrutura.es-codigo = b-estrutura.it-codigo
                          AND b2-estrutura.data-inicio  <= TODAY
                          AND b2-estrutura.data-termino >= TODAY) THEN DO:
            RUN pi-imprime.
        END.
        ELSE DO:
            RUN pi-sobe-estrutura (INPUT b-estrutura.it-codigo).
        END.
    END.
END PROCEDURE.

PROCEDURE pi-imprime:

    RUN pi-acompanhar IN h-acomp (INPUT "Componente " + estrutura.es-codigo). 
    
    FIND FIRST altern-astec NO-LOCK
         WHERE altern-astec.it-altern = b-estrutura.it-codigo NO-ERROR.

    IF AVAIL altern-astec THEN DO:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = estrutura.es-codigo NO-ERROR.
    
        FIND FIRST b-item NO-LOCK
             WHERE b-item.it-codigo = altern-astec.it-codigo NO-ERROR.

        PUT STREAM str-excel UNFORMATTED estrutura.es-codigo + ";".
        PUT STREAM str-excel UNFORMATTED ITEM.desc-item + ";".
        PUT STREAM str-excel UNFORMATTED altern-astec.it-codigo + ";".
        PUT STREAM str-excel UNFORMATTED b-item.desc-item + ";".
        PUT STREAM str-excel UNFORMATTED IF AVAIL int-estrutura THEN STRING(int-estrutura.garantia) + ";" ELSE ";".
        PUT STREAM str-excel UNFORMATTED IF AVAIL int-estrutura THEN 
                                             IF int-estrutura.venda THEN 
                                                 "Sim" + ";"
                                             ELSE 
                                                 "NÆo" + ";"
                                         ELSE ";".
    
        RUN pi-imprime-saldo (INPUT "104",
                              INPUT "EPV",
                              INPUT b-estrutura.it-codigo).
    
        RUN pi-imprime-saldo (INPUT "104",
                              INPUT "DPV",
                              INPUT b-estrutura.it-codigo).
    
        RUN pi-imprime-saldo (INPUT "104",
                              INPUT "SAL",
                              INPUT b-estrutura.it-codigo).
    
        RUN pi-imprime-saldo (INPUT "104",
                              INPUT "WEX",
                              INPUT b-estrutura.it-codigo).
    
        RUN pi-imprime-saldo (INPUT "103",
                              INPUT "WEX",
                              INPUT b-estrutura.it-codigo).
    
        RUN pi-imprime-saldo (INPUT "105",
                              INPUT "EXP",
                              INPUT b-estrutura.it-codigo).
    
        PUT STREAM str-excel UNFORMATTED STRING({ininc/i17in172.i 04 b-item.cod-obsoleto},"x(30)") + ";".

        PUT STREAM str-excel SKIP.
    END.
    ELSE DO:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = estrutura.es-codigo NO-ERROR.
    
        FIND FIRST b-item NO-LOCK
             WHERE b-item.it-codigo = b-estrutura.it-codigo NO-ERROR.

        PUT STREAM str-excel UNFORMATTED estrutura.es-codigo + ";".
        PUT STREAM str-excel UNFORMATTED ITEM.desc-item + ";".
        PUT STREAM str-excel UNFORMATTED b-estrutura.it-codigo + ";".
        PUT STREAM str-excel UNFORMATTED b-item.desc-item + ";".
        PUT STREAM str-excel UNFORMATTED IF AVAIL int-estrutura THEN STRING(int-estrutura.garantia) + ";" ELSE ";".
        PUT STREAM str-excel UNFORMATTED IF AVAIL int-estrutura THEN 
                                             IF int-estrutura.venda THEN 
                                                 "Sim" + ";"
                                             ELSE 
                                                 "NÆo" + ";"
                                         ELSE ";".
    
        RUN pi-imprime-saldo (INPUT "104",
                              INPUT "EPV",
                              INPUT b-estrutura.it-codigo).
    
        RUN pi-imprime-saldo (INPUT "104",
                              INPUT "DPV",
                              INPUT b-estrutura.it-codigo).
    
        RUN pi-imprime-saldo (INPUT "104",
                              INPUT "SAL",
                              INPUT b-estrutura.it-codigo).
    
        RUN pi-imprime-saldo (INPUT "104",
                              INPUT "WEX",
                              INPUT b-estrutura.it-codigo).
    
        RUN pi-imprime-saldo (INPUT "103",
                              INPUT "WEX",
                              INPUT b-estrutura.it-codigo).
    
        RUN pi-imprime-saldo (INPUT "105",
                              INPUT "EXP",
                              INPUT b-estrutura.it-codigo).
    
        PUT STREAM str-excel UNFORMATTED STRING({ininc/i17in172.i 04 b-item.cod-obsoleto},"x(30)") + ";".

        PUT STREAM str-excel SKIP.
    END.
    
END PROCEDURE.

PROCEDURE pi-imprime-astec:

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = estrut-astec.es-codigo NO-ERROR.

    FIND FIRST b-item NO-LOCK
         WHERE b-item.it-codigo = estrut-astec.it-codigo NO-ERROR.

    RUN pi-acompanhar IN h-acomp (INPUT "Componente Astec " + estrut-astec.es-codigo). 

    FIND FIRST int-estrutura NO-LOCK
         WHERE int-estrutura.it-codigo = estrut-astec.it-codigo
           AND int-estrutura.sequencia = estrut-astec.sequencia
           AND int-estrutura.es-codigo = estrut-astec.es-codigo NO-ERROR.
    
    PUT STREAM str-excel UNFORMATTED estrut-astec.es-codigo + ";".
    PUT STREAM str-excel UNFORMATTED ITEM.desc-item + ";".
    PUT STREAM str-excel UNFORMATTED estrut-astec.it-codigo + ";".
    PUT STREAM str-excel UNFORMATTED b-item.desc-item + ";".
    PUT STREAM str-excel UNFORMATTED IF AVAIL int-estrutura THEN STRING(int-estrutura.garantia) + ";" ELSE ";".
    PUT STREAM str-excel UNFORMATTED IF AVAIL int-estrutura THEN 
                                         IF int-estrutura.venda THEN 
                                             "Sim" + ";"
                                         ELSE 
                                             "NÆo" + ";"
                                     ELSE ";".

    RUN pi-imprime-saldo (INPUT "104",
                          INPUT "EPV",
                          INPUT estrut-astec.it-codigo).

    RUN pi-imprime-saldo (INPUT "104",
                          INPUT "DPV",
                          INPUT estrut-astec.it-codigo).

    RUN pi-imprime-saldo (INPUT "104",
                          INPUT "SAL",
                          INPUT estrut-astec.it-codigo).

    RUN pi-imprime-saldo (INPUT "104",
                          INPUT "WEX",
                          INPUT estrut-astec.it-codigo).

    RUN pi-imprime-saldo (INPUT "103",
                          INPUT "WEX",
                          INPUT estrut-astec.it-codigo).

    RUN pi-imprime-saldo (INPUT "105",
                          INPUT "EXP",
                          INPUT estrut-astec.it-codigo).

    PUT STREAM str-excel UNFORMATTED STRING({ininc/i17in172.i 04 b-item.cod-obsoleto},"x(30)") + ";".

    PUT STREAM str-excel SKIP.

    /*FOR EACH altern-astec NO-LOCK
       WHERE altern-astec.it-codigo = estrut-astec.it-codigo:

        FOR EACH b2-estrutura NO-LOCK
           WHERE b2-estrutura.it-codigo     = altern-astec.it-altern
             AND b2-estrutura.es-codigo     = estrut-astec.es-codigo
             AND b2-estrutura.data-inicio  <= TODAY 
             AND b2-estrutura.data-termino >= TODAY:

            ASSIGN i = i + 1.

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = b2-estrutura.es-codigo NO-ERROR.

            FIND FIRST b-item NO-LOCK
                 WHERE b-item.it-codigo = altern-astec.it-altern NO-ERROR.

            RUN pi-acompanhar IN h-acomp (INPUT "Componente Astec " + estrut-astec.es-codigo). 
        
            FIND FIRST int-estrutura NO-LOCK
                 WHERE int-estrutura.it-codigo = b2-estrutura.it-codigo
                   AND int-estrutura.sequencia = b2-estrutura.sequencia
                   AND int-estrutura.es-codigo = b2-estrutura.es-codigo NO-ERROR.
            
            PUT STREAM str-excel UNFORMATTED b2-estrutura.es-codigo + ";".
            PUT STREAM str-excel UNFORMATTED ITEM.desc-item + ";".
            PUT STREAM str-excel UNFORMATTED altern-astec.it-altern + ";".
            PUT STREAM str-excel UNFORMATTED b-item.desc-item + ";".
            PUT STREAM str-excel UNFORMATTED IF AVAIL int-estrutura THEN STRING(int-estrutura.garantia) + ";" ELSE ";".
            PUT STREAM str-excel UNFORMATTED IF AVAIL int-estrutura THEN 
                                                 IF int-estrutura.venda THEN 
                                                     "Sim" + ";"
                                                 ELSE 
                                                     "NÆo" + ";"
                                             ELSE ";".

            RUN pi-imprime-saldo (INPUT "104",
                                  INPUT "EPV",
                                  INPUT altern-astec.it-altern).
        
            RUN pi-imprime-saldo (INPUT "104",
                                  INPUT "DPV",
                                  INPUT altern-astec.it-altern).
        
            RUN pi-imprime-saldo (INPUT "104",
                                  INPUT "SAL",
                                  INPUT altern-astec.it-altern).
        
            RUN pi-imprime-saldo (INPUT "104",
                                  INPUT "WEX",
                                  INPUT altern-astec.it-altern).
        
            RUN pi-imprime-saldo (INPUT "103",
                                  INPUT "WEX",
                                  INPUT altern-astec.it-altern).
        
            RUN pi-imprime-saldo (INPUT "105",
                                  INPUT "EXP",
                                  INPUT altern-astec.it-altern).
        
            PUT STREAM str-excel SKIP.
        END.
    END.*/
    
END PROCEDURE.

PROCEDURE pi-imprime-saldo:
    DEFINE INPUT PARAM p-cod-estabel LIKE saldo-estoq.cod-estabel.
    DEFINE INPUT PARAM p-cod-depos   LIKE saldo-estoq.cod-depos.
    DEFINE INPUT PARAM p-it-codigo   LIKE saldo-estoq.it-codigo.

    DEFINE VARIABLE de-saldo AS DECIMAL     NO-UNDO.

    ASSIGN de-saldo = 0.
    FOR EACH saldo-estoq NO-LOCK
       WHERE saldo-estoq.cod-estabel = p-cod-estabel
         AND saldo-estoq.cod-depos   = p-cod-depos
         AND saldo-estoq.it-codigo   = p-it-codigo:
        ASSIGN de-saldo = de-saldo + (saldo-estoq.qtidade-atu  - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped  - saldo-estoq.qt-alocada).
    END.
    
    FIND FIRST deposito NO-LOCK
         WHERE deposito.cod-depos = p-cod-depos NO-ERROR.

    IF  AVAIL deposito
    AND deposito.log-gera-wms = YES THEN DO:
        FOR EACH int-wms-nf-atualiz NO-LOCK
           WHERE int-wms-nf-atualiz.cod-estabel = p-cod-estabel
             AND int-wms-nf-atualiz.cod-depos   = p-cod-depos
             AND int-wms-nf-atualiz.it-codigo   = p-it-codigo:
            ASSIGN de-saldo = de-saldo - int-wms-nf-atualiz.qt-baixada.
        END.
    END.

    PUT STREAM str-excel UNFORMATTED STRING(de-saldo) + ";".

END PROCEDURE.

OUTPUT STREAM str-excel CLOSE.
