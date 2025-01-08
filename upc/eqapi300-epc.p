DEFINE VARIABLE vDeSaldo AS DECIMAL     NO-UNDO.
{include/i-epc200.i1}
{utp/ut-glob.i}

DEFINE INPUT        PARAM pIndEvent AS CHARACTER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEFINE VARIABLE l-achou-item-baixa-estoque AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-api                      AS HANDLE      NO-UNDO.
DEFINE VARIABLE r-rowid                    AS ROWID       NO-UNDO.

DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-program       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-qtd-a-alocar AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-qtd-aux      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-qtd-aux-2    AS DECIMAL     NO-UNDO.

DEFINE VARIABLE c-arq-log AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-esapi018 AS HANDLE      NO-UNDO.

DEFINE TEMP-TABLE tt-it-pre-fat NO-UNDO
    FIELD nr-embarque  as INTEGER
    FIELD nr-resumo    as INTEGER
    FIELD nome-abrev   as CHARACTER
    FIELD nr-pedcli    as CHARACTER
    FIELD nr-sequencia as INTEGER
    FIELD it-codigo    as CHARACTER
    FIELD qt-a-alocar  as DECIMAL
    FIELD i-sequen     as INTEGER
    FIELD nr-entrega   as INTEGER
    INDEX ch-it-pre-fat IS PRIMARY
        nr-embarque
        nr-resumo
        nome-abrev
        nr-pedcli
        nr-sequencia
        it-codigo
        nr-entrega.

{cdp/cd0667.i}
    {method/dbotterr.i}  /* defini‡Æo da RowErrors */
    
DEFINE BUFFER b-it-pre-fat    FOR it-pre-fat.
DEFINE BUFFER b-item          FOR item.
DEFINE BUFFER b-prod-composto FOR prod-composto.


IF pIndEvent = "BEGIN_PI-DESALOCA-SALDO-MAN":U THEN DO:

    FIND FIRST tt-epc
        WHERE tt-epc.cod-event     = pIndEvent
          AND tt-epc.cod-parameter = "ROWID_it-dep-fat":U NO-LOCK NO-ERROR.

    IF AVAILABLE tt-epc THEN DO:
        FIND FIRST it-dep-fat
            WHERE ROWID(it-dep-fat) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.
        FIND FIRST tt-epc
                WHERE tt-epc.cod-event     = pIndEvent
                  AND tt-epc.cod-parameter = "Value_of_de-qt-baixa-estoque-upc":U NO-LOCK NO-ERROR.
        IF CAN-FIND(FIRST int-ped-item-astec
                WHERE int-ped-item-astec.nome-abrev   = it-dep-fat.nome-abrev
                  AND int-ped-item-astec.nr-pedcli    = it-dep-fat.nr-pedcli
                  AND int-ped-item-astec.nr-sequencia = it-dep-fat.nr-sequencia
                  AND int-ped-item-astec.it-codigo    = it-dep-fat.it-codigo) THEN DO:
            IF  NOT VALID-HANDLE(h-esapi018)                  OR
                h-esapi018:TYPE      <> "PROCEDURE":U         OR
               (h-esapi018:FILE-NAME <> "esapi/esapi018.p":U  AND
                h-esapi018:FILE-NAME <> "esapi/esapi018.r":U) THEN
                RUN esapi/esapi018.p PERSISTENT SET h-esapi018.
    
            IF VALID-HANDLE(h-esapi018) THEN DO:
                RUN alocarDesalocarPedItemAstec IN h-esapi018 (INPUT it-dep-fat.nome-abrev,
                                                               INPUT it-dep-fat.nr-pedcli,
                                                               INPUT it-dep-fat.nr-sequencia,
                                                               INPUT it-dep-fat.it-codigo,
                                                               INPUT 2,
                                                               INPUT DEC(tt-epc.val-parameter)).
    
                IF RETURN-VALUE = "NOK":U THEN
                    RUN getRowErrors IN h-esapi018 (OUTPUT TABLE RowErrors).
            END.
    
            IF VALID-HANDLE(h-esapi018) THEN
                RUN destroy IN h-esapi018.
        END.
    END.
END.



IF pIndEvent = "VALIDAR_IT_PRE_FAT":U THEN DO:

    ASSIGN i-cont    = 1
           c-program = "":U.

    REPEAT:
        IF PROGRAM-NAME(i-cont) = ? OR PROGRAM-NAME(i-cont) = "":U THEN
            LEAVE.
        IF INDEX(PROGRAM-NAME(i-cont), "ft3000b":U) <> 0 THEN DO:
            ASSIGN c-program = PROGRAM-NAME(i-cont).
            LEAVE.
        END.
        ASSIGN i-cont = i-cont + 1.
    END.
            
    IF INDEX(c-program, "ft3000b":U) <> 0 THEN DO:
        FIND FIRST tt-epc
            WHERE tt-epc.cod-event     = pIndEvent
              AND tt-epc.cod-parameter = "it-pre-fat rowid":U NO-LOCK NO-ERROR.
    
        IF AVAILABLE tt-epc THEN DO:
            FIND FIRST it-pre-fat
                WHERE ROWID(it-pre-fat) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.
    
            IF AVAILABLE it-pre-fat THEN DO:
                FIND FIRST tt-epc
                    WHERE tt-epc.cod-event     = pIndEvent
                      AND tt-epc.cod-parameter = "value_qt-a-alocar":U NO-LOCK NO-ERROR.

                IF AVAILABLE tt-epc                  AND
                   DECIMAL(tt-epc.val-parameter) < 0 THEN DO:

                    ASSIGN de-qtd-a-alocar = DECIMAL(tt-epc.val-parameter) * -1.
                    
                    FIND FIRST ped-ent
                        WHERE ped-ent.nome-abrev   = it-pre-fat.nome-abrev
                          AND ped-ent.nr-pedcli    = it-pre-fat.nr-pedcli
                          AND ped-ent.nr-sequencia = it-pre-fat.nr-sequencia
                          AND ped-ent.it-codigo    = it-pre-fat.it-codigo
                          AND ped-ent.cod-refer    = it-pre-fat.cod-refer
                          AND ped-ent.nr-entrega   = it-pre-fat.nr-entrega EXCLUSIVE-LOCK NO-ERROR.

                    IF AVAILABLE ped-ent THEN DO:
                        FIND FIRST ped-venda
                            WHERE ped-venda.nome-abrev = it-pre-fat.nome-abrev
                              AND ped-venda.nr-pedcli  = it-pre-fat.nr-pedcli NO-LOCK NO-ERROR.

                        IF AVAILABLE ped-venda THEN DO:

                            FIND FIRST ped-item OF ped-venda
                                WHERE ped-item.it-codigo    = it-pre-fat.it-codigo
                                  AND ped-item.nr-sequencia = it-pre-fat.nr-sequencia EXCLUSIVE-LOCK NO-ERROR.

                            bl-it-dep-fat:
                            FOR EACH it-dep-fat
                                WHERE it-dep-fat.cdd-embarq  = it-pre-fat.cdd-embarq
                                  AND it-dep-fat.nr-resumo    = it-pre-fat.nr-resumo
                                  AND it-dep-fat.nome-abrev   = it-pre-fat.nome-abrev
                                  AND it-dep-fat.nr-pedcli    = it-pre-fat.nr-pedcli
                                  AND it-dep-fat.cod-estabel  = ped-venda.cod-estabel
                                  AND it-dep-fat.nr-sequencia = it-pre-fat.nr-sequencia
                                  AND it-dep-fat.it-codigo    = it-pre-fat.it-codigo
                                  AND it-dep-fat.cod-refer    = it-pre-fat.cod-refer
                                  AND it-dep-fat.nr-entrega   = it-pre-fat.nr-entrega NO-LOCK:

                                FIND FIRST saldo-estoq
                                    WHERE saldo-estoq.cod-depos   = it-dep-fat.cod-depos
                                      AND saldo-estoq.cod-estabel = it-dep-fat.cod-estabel
                                      AND saldo-estoq.cod-localiz = it-dep-fat.cod-localiz
                                      AND saldo-estoq.lote        = it-dep-fat.nr-serlote
                                      AND saldo-estoq.it-codigo   = it-pre-fat.it-codigo
                                      AND saldo-estoq.cod-refer   = it-pre-fat.cod-refer EXCLUSIVE-LOCK NO-ERROR.

                                IF AVAILABLE saldo-estoq THEN DO:
                                    IF de-qtd-a-alocar > 0 THEN DO:
                                        IF de-qtd-a-alocar >= saldo-estoq.qt-alocada THEN
                                            ASSIGN de-qtd-aux = saldo-estoq.qt-alocada.
                                        ELSE
                                            ASSIGN de-qtd-aux = de-qtd-a-alocar.

                                        ASSIGN de-qtd-a-alocar = de-qtd-a-alocar - de-qtd-aux
                                               de-qtd-aux-2    = (saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada + saldo-estoq.qt-aloc-ped + saldo-estoq.qt-aloc-prod)).

                                        FIND FIRST ped-saldo
                                            WHERE ped-saldo.cod-depos   = saldo-estoq.cod-depos
                                              AND ped-saldo.cod-estabel = saldo-estoq.cod-estabel
                                              AND ped-saldo.cod-localiz = saldo-estoq.cod-localiz
                                              AND ped-saldo.lote        = saldo-estoq.lote
                                              AND ped-saldo.nome-abrev  = ped-ent.nome-abrev
                                              AND ped-saldo.nr-pedcli   = ped-ent.nr-pedcli
                                              AND ped-saldo.nr-seq-item = ped-ent.nr-sequencia
                                              AND ped-saldo.it-codigo   = ped-ent.it-codigo
                                              AND ped-saldo.cod-refer   = ped-ent.cod-refer
                                              AND ped-saldo.nr-entrega  = ped-ent.nr-entrega EXCLUSIVE-LOCK NO-ERROR.

                                        IF NOT AVAILABLE(ped-saldo) THEN DO:
                                            CREATE ped-saldo.
                                            ASSIGN ped-saldo.cod-depos   = saldo-estoq.cod-depo
                                                   ped-saldo.cod-estabel = saldo-estoq.cod-estabel
                                                   ped-saldo.cod-localiz = saldo-estoq.cod-localiz
                                                   ped-saldo.lote        = saldo-estoq.lote
                                                   ped-saldo.nome-abrev  = ped-ent.nome-abrev
                                                   ped-saldo.nr-pedcli   = ped-ent.nr-pedcli
                                                   ped-saldo.nr-seq-item = ped-ent.nr-sequencia
                                                   ped-saldo.it-codigo   = ped-ent.it-codigo
                                                   ped-saldo.cod-refer   = ped-ent.cod-refer
                                                   ped-saldo.nr-entrega  = ped-ent.nr-entrega.
                                        END.
                                            
                                        IF de-qtd-aux-2 >= de-qtd-aux THEN
                                            ASSIGN saldo-estoq.qt-aloc-ped = saldo-estoq.qt-aloc-ped + de-qtd-aux
                                                   ped-item.qt-log-aloca   = ped-item.qt-log-aloca   + de-qtd-aux
                                                   ped-ent.qt-log-aloca    = ped-ent.qt-log-aloca    + de-qtd-aux
                                                   ped-saldo.qt-aloc-ped   = ped-saldo.qt-aloc-ped   + de-qtd-aux.
                                        ELSE
                                            ASSIGN saldo-estoq.qt-aloc-ped = saldo-estoq.qt-aloc-ped + (IF de-qtd-aux-2 < 0 THEN 0 ELSE de-qtd-aux-2)
                                                   ped-item.qt-log-aloca   = ped-item.qt-log-aloca   + (IF de-qtd-aux-2 < 0 THEN 0 ELSE de-qtd-aux-2)
                                                   ped-ent.qt-log-aloca    = ped-ent.qt-log-aloca    + (IF de-qtd-aux-2 < 0 THEN 0 ELSE de-qtd-aux-2)
                                                   ped-saldo.qt-aloc-ped   = ped-saldo.qt-aloc-ped   + (IF de-qtd-aux-2 < 0 THEN 0 ELSE de-qtd-aux-2).                                        
                                    END.
                                    ELSE LEAVE bl-it-dep-fat.
                                END.

                                release saldo-estoq.
                            END. /* FOR EACH it-dep-fat */

                        END. /* IF AVAILABLE ped-venda THEN DO: */

                    END. /* IF AVAILABLE ped-ent THEN DO: */

                END. /* IF AVAILABLE tt-epc                  AND
                        DECIMAL(tt-epc.val-parameter) < 0 THEN DO: */

            END. /* IF AVAILABLE it-pre-fat THEN DO: */
        END.
    END. /* IF INDEX(c-program, "ft3000b":U) <> 0 THEN DO: */
END.

IF pIndEvent = "BEGIN_PI-ALOCA-SALDO-MAN" THEN DO:
    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = "BEGIN_PI-ALOCA-SALDO-MAN"
        AND   tt-epc.cod-parameter = "ROWID_ped-ent":
       find FIRST ped-ent NO-LOCK
            WHERE rowid(ped-ent) = TO-ROWID(tt-epc.val-parameter) no-error.
       FIND FIRST ped-venda
            WHERE ped-venda.nome-abrev = ped-ent.nome-abrev
              AND ped-venda.nr-pedcli  = ped-ent.nr-pedcli NO-LOCK NO-ERROR.
        if avail ped-ent then
           assign vDeSaldo = ped-ent.qt-log-aloca.
    END.

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = "BEGIN_PI-ALOCA-SALDO-MAN"
        AND   tt-epc.cod-parameter = "Value_of_de-saldo":
       if ped-venda.cod-estab <> '601' and
          ped-venda.cod-estab <> '602' then
          ASSIGN tt-epc.val-parameter = STRING(vDeSaldo).
    END.
END.

IF pIndEvent = "END_PI-ENCERRA-EMBARQUE" THEN DO:
    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = "END_PI-ENCERRA-EMBARQUE"
          AND tt-epc.cod-parameter = "numero-embarque":

        IF OPSYS = "UNIX" THEN
            ASSIGN c-arq-log = REPLACE(SESSION:TEMP-DIRECTORY, "~\":U, "/":U) + "/":U + c-seg-usuario.
        ELSE DO:
            FIND FIRST usuar_mestre
                WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.
    
            IF AVAILABLE usuar_mestre             AND
               usuar_mestre.nom_dir_spool <> "":U THEN DO:
                ASSIGN c-arq-log = REPLACE(usuar_mestre.nom_dir_spool, "~\":U, "/":U) + "/":U.
    
                IF usuar_mestre.nom_subdir_spool <> "":U THEN
                    ASSIGN c-arq-log = c-arq-log + REPLACE(usuar_mestre.nom_subdir_spool, "~\":U, "/":U) + "/":U.
            END.
            ELSE
                ASSIGN c-arq-log = REPLACE(SESSION:TEMP-DIRECTORY, "~\":U, "/":U) + "/":U.
        END.

        ASSIGN c-arq-log = c-arq-log + "/log-eqapi300-epc.txt":U.

        OUTPUT TO VALUE(c-arq-log) APPEND CONVERT TARGET "iso8859-1":U.
        PUT UNFORMATTED SKIP(2) FILL("-":U, 132) SKIP(1)
                        "In¡cio Log - Embarque: ":U + tt-epc.val-parameter + " - Data: ":U + STRING(TODAY, "99/99/9999":U) + " - Hora: ":U + STRING(TIME, "hh:mm:ss":U) SKIP(1)
                        "1- IT-PRE-FAT: ":U SKIP.
        FOR EACH it-pre-fat
            WHERE it-pre-fat.cdd-embarq = INTEGER(tt-epc.val-parameter) NO-LOCK:
            DISP it-pre-fat.nr-pedcli
                 it-pre-fat.nome-abrev
                 it-pre-fat.nr-sequencia
                 it-pre-fat.it-codigo
                 it-pre-fat.qt-faturada
                 it-pre-fat.qt-alocada
                 it-pre-fat.qt-transfer
                 it-pre-fat.qt-rejeita.
        END.
        OUTPUT CLOSE.
        
        FOR EACH  it-pre-fat EXCLUSIVE-LOCK
            WHERE it-pre-fat.cdd-embarq = INT(tt-epc.val-parameter):

            FIND ITEM
                WHERE ITEM.it-codigo = it-pre-fat.it-codigo NO-LOCK NO-ERROR.

            FIND FIRST prod-composto
                WHERE prod-composto.it-codigo-filho = it-pre-fat.it-codigo NO-LOCK NO-ERROR.


            OUTPUT TO VALUE(c-arq-log) APPEND CONVERT TARGET "iso8859-1":U.
            PUT UNFORMATTED SKIP(2) "1- Antes no prod-composto: ":U SKIP
                            "Filho: ":U it-pre-fat.it-codigo SKIP
                            
                            "Baixa Estoque = " ITEM.baixa-estoq   SKIP
                            "Achou Produto composto " AVAILABLE prod-composto
                SKIP(2).
            OUTPUT CLOSE. 


            IF AVAILABLE prod-composto THEN DO:
                RUN eqp/eqapi300 PERSISTENT SET h-api.

                IF ITEM.baixa-estoq = YES THEN
                    NEXT.
                ELSE DO:
                    OUTPUT TO VALUE(c-arq-log) APPEND CONVERT TARGET "iso8859-1":U.
                    PUT UNFORMATTED SKIP(2) "2- Entrou no prod-composto: ":U SKIP
                                    "Filho: ":U prod-composto.it-codigo-filho SKIP
                                    "Pai: ":U prod-composto.it-codigo-pai SKIP(2).
                    OUTPUT CLOSE. 

                    ASSIGN l-achou-item-baixa-estoque = NO.
                    FOR  EACH prod-composto
                        WHERE prod-composto.it-codigo-filho        =  it-pre-fat.it-codigo NO-LOCK,
                         EACH b-it-pre-fat NO-LOCK
                        WHERE b-it-pre-fat.cdd-embarq             =  it-pre-fat.cdd-embarq
                          AND b-it-pre-fat.nome-abrev              =  it-pre-fat.nome-abrev
                          AND b-it-pre-fat.nr-pedcli               =  it-pre-fat.nr-pedcli,
                        FIRST b-item NO-LOCK
                        WHERE b-item.it-codigo                     =  b-it-pre-fat.it-codigo
                          AND b-item.baixa-estoq                   =  YES,
                         EACH b-prod-composto NO-LOCK
                        WHERE b-prod-composto.it-codigo-filho      =  b-it-pre-fat.it-codigo
                          AND b-prod-composto.it-codigo-pai        =  prod-composto.it-codigo-pai:
    
                        ASSIGN l-achou-item-baixa-estoque = YES.

                        for each tt-it-pre-fat:
                           delete tt-it-pre-fat.
                        end.
                        
                        create tt-it-pre-fat.
                        buffer-copy it-pre-fat to tt-it-pre-fat.

                        OUTPUT TO VALUE(c-arq-log) APPEND CONVERT TARGET "iso8859-1":U.
                        PUT UNFORMATTED SKIP(2) "3- Baixa Estoque: ":U SKIP
                                                "Item Pre Fat: ":U it-pre-fat.it-codigo SKIP
                                                "Filho: ":U prod-composto.it-codigo-filho SKIP
                                                "Quantidade Filho no Composto: " prod-composto.qt-filho SKIP
                                                "Qt Alocada Filho: " it-pre-fat.qt-alocada SKIP
                                                "Qt a Alocar Filho: " ((b-it-pre-fat.qt-alocada * prod-composto.qt-filho) - it-pre-fat.qt-alocada) SKIP
                                                "Item Baixa estoque: ":U b-it-pre-fat.it-codigo SKIP
                                                "Qt Alocada Baixa Estoque: " b-it-pre-fat.qt-alocada SKIP
                                                "Pai: ":U prod-composto.it-codigo-pai SKIP.
                        OUTPUT CLOSE.
                                                
                        assign tt-it-pre-fat.qt-a-alocar =  (b-it-pre-fat.qt-alocada * prod-composto.qt-filho) - it-pre-fat.qt-alocada 
                               tt-it-pre-fat.i-sequen    = 1
                               tt-it-pre-fat.nr-embarque = it-pre-fat.cdd-embarq.
                        
                        run pi-recebe-tt-it-pre-fat in h-api (input table tt-it-pre-fat).
                        run pi-trata-tt-it-pre-fat  in h-api (input yes).
                        run pi-devolve-tt-erro      in h-api (output table tt-erro).
                        
                        if  can-find(first tt-erro) then do:
                           FOR EACH tt-erro:
                               MESSAGE tt-erro.cd-erro SKIP "Erro na correcao quantidade produto composto " tt-erro.mensagem
                                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
                           END.
                           return 'NOK'.
                        end.
                        LEAVE. /* se ja encontrou nao precisa continuar procurando */
                    END.

                    IF l-achou-item-baixa-estoque = NO THEN DO:
                        for each tt-it-pre-fat:
                           delete tt-it-pre-fat.
                        end.
                        
                        create tt-it-pre-fat.
                        buffer-copy it-pre-fat to tt-it-pre-fat.

                        OUTPUT TO VALUE(c-arq-log) APPEND CONVERT TARGET "iso8859-1":U.
                        PUT UNFORMATTED SKIP(2) "4- NÆo Baixa Estoque":U SKIP
                                                "Item Pre Fat: ":U it-pre-fat.it-codigo SKIP
                                                
                                                "Qt Alocada: ":U it-pre-fat.qt-alocada SKIP
                                                "Qt a Alocar: ":U it-pre-fat.qt-alocada * -1 SKIP.
                        OUTPUT CLOSE.
                        
                        assign tt-it-pre-fat.qt-a-alocar =  it-pre-fat.qt-alocada * -1
                               tt-it-pre-fat.i-sequen    = 1
                               tt-it-pre-fat.nr-embarque = it-pre-fat.cdd-embarq.
                        
                        run pi-recebe-tt-it-pre-fat in h-api (input table tt-it-pre-fat).
                        run pi-trata-tt-it-pre-fat  in h-api (input yes).
                        run pi-devolve-tt-erro      in h-api (output table tt-erro).
                        
                        if  can-find(first tt-erro) then do:
                           FOR EACH tt-erro:
                               MESSAGE tt-erro.cd-erro SKIP "Erro na correcao quantidade produto composto " tt-erro.mensagem
                                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
                           END.
                           return 'NOK'.
                        end.

                    END.
                END.
                DELETE PROCEDURE h-api.
            END.
        END.
    END.
END.

RETURN "OK":U.
