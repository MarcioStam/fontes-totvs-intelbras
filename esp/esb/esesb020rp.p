{include/i-prgvrs.i esesb020rp 2.04.00.001}
 
{include/i-rpvar.i}
{esapi/esapi023.i}     /*ttItem*/
{cdp/cd0666.i}         /*tt-erro*/
{esp/esb/in/msg0244.i}

DEFINE TEMP-TABLE tt-raw-digita
   FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-erro-ns  LIKE tt-erro.
DEFINE TEMP-TABLE tt-erro-mac LIKE tt-erro.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE NEW SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.

DEFINE VARIABLE cMensagem AS CHARACTER NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE ItensConsulta.
    RAW-TRANSFER tt-raw-digita.raw-digita TO ItensConsulta.
END.

IF tt-param.gera-ns THEN DO:
    RUN piGeraSN.

    IF RETURN-VALUE <> "OK" THEN DO:
        FOR EACH tt-erro:
            CREATE tt-erro-ns.
            BUFFER-COPY tt-erro TO tt-erro-ns.
        END.
    END.
END.

IF tt-param.gera-mac THEN DO:
    EMPTY TEMP-TABLE tt-erro.

    RUN piGeraMac.

    IF RETURN-VALUE <> "OK" THEN DO:
        FOR EACH tt-erro:
            CREATE tt-erro-mac.
            BUFFER-COPY tt-erro TO tt-erro-mac.
        END. 
    END.
END.

ASSIGN cMensagem = "msg0251".
IF SEARCH('esp/esb/out/' + cMensagem + '.p') <> ? OR SEARCH('esp/esb/out/' + cMensagem + '.r') <> ? THEN DO:
    RUN VALUE('esp/esb/out/' + cMensagem + '.p') (INPUT tt-param.num-pedido,
                                                  INPUT tt-param.gera-ns,
                                                  INPUT tt-param.gera-mac,
                                                  INPUT TABLE ItensConsulta,
                                                  INPUT TABLE tt-erro-ns,
                                                  INPUT TABLE tt-erro-mac,
                                                  INPUT TABLE tt-lista-ns,
                                                  INPUT TABLE tt-mac-address).
    IF ERROR-STATUS:ERROR THEN 
        RETURN ERROR.
END.

FUNCTION fnRetornaQtdeNS RETURNS INTEGER
    (INPUT i-pedido AS INTEGER,
     INPUT c-item   AS CHARACTER):

    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

    FOR EACH num-serie
        WHERE num-serie.num-pedido = i-pedido
        AND   num-serie.it-codigo  = c-item NO-LOCK:

        ASSIGN i-cont = i-cont + 1.
    END.

    RETURN i-cont.
END FUNCTION.

FUNCTION fnRetornaQtdeMac RETURNS INTEGER
    (INPUT i-pedido AS INTEGER,
     INPUT c-item   AS CHARACTER):

    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

    FOR EACH mac-address NO-LOCK
        WHERE mac-address.num-pedido = i-pedido
        AND   mac-address.it-codigo  = c-item
        AND   mac-address.impresso   = TRUE:

        ASSIGN i-cont = i-cont + 1.
    END.

    RETURN i-cont.
END FUNCTION.

PROCEDURE piGeraSN:
    DEFINE VARIABLE h-esapi016 AS HANDLE  NO-UNDO.
    DEFINE VARIABLE lgeraNS    AS LOGICAL NO-UNDO.
    DEFINE VARIABLE d-qtde     AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-ns-gera  AS INTEGER NO-UNDO.

    RUN esapi/esapi016.p PERSISTENT SET h-esapi016.
    
    FIND FIRST ItensConsulta NO-ERROR.

    FOR FIRST pedido-compr FIELDS(num-pedido)
        WHERE pedido-compr.num-pedido = tt-param.num-pedido NO-LOCK:

        itens: FOR EACH ordem-compra FIELDS(it-codigo qt-solic)
            WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK BREAK BY ordem-compra.it-codigo:
    
            EMPTY TEMP-TABLE tt-lista-ns NO-ERROR.
            
            ACCUMULATE ordem-compra.qt-solic (TOTAL BY ordem-compra.it-codigo).

            IF LAST-OF(ordem-compra.it-codigo) THEN DO:
                ASSIGN lgeraNS = YES.
                IF AVAIL ItensConsulta THEN DO:
                    IF NOT CAN-FIND(FIRST ItensConsulta
                                    WHERE ItensConsulta.CodigoProduto = ordem-compra.it-codigo) THEN
                        ASSIGN lgeraNS = NO.
                END.
                
                IF lgeraNS THEN DO:
                    ASSIGN d-qtde = (ACCUM TOTAL BY ordem-compra.it-codigo ordem-compra.qt-solic) -
                                    fnRetornaQtdeNS(INPUT pedido-compr.num-pedido,
                                                    INPUT ordem-compra.it-codigo).

                    IF d-qtde < 0 THEN
                        ASSIGN d-qtde = 0.

                    IF d-qtde = 0 THEN DO:
                        CREATE tt-erro.
                        ASSIGN tt-erro.cd-erro = 17006
                               tt-erro.mensagem = "NS j† foi gerado para o pedido.".
                        DELETE PROCEDURE h-esapi016.
                        RETURN "NOK":U.
                    END.

                    RUN piGeraNS IN h-esapi016 (INPUT ordem-compra.it-codigo,
                                                INPUT 1,  /* Colocado um modelo com tipo 1 - N£mero de SÇrie para gerar os N£meros de SÇrie */
                                                INPUT "",
                                                INPUT d-qtde,
                                                INPUT 0,
                                                INPUT pedido-compr.num-pedido,
                                                INPUT "",
                                                INPUT 3,
                                                INPUT NO,  /* Tratamento ASTEC */
                                                INPUT "",
                                                INPUT "",
                                                OUTPUT TABLE tt-lista-ns).
                    
                    IF  RETURN-VALUE <> "OK":U THEN DO:
                        EMPTY TEMP-TABLE tt-erro NO-ERROR.
                        RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).
                        DELETE PROCEDURE h-esapi016.
                        RETURN "NOK":U.
                    END. /* IF  RETURN-VALUE <> "OK":U THEN DO: */
                    /*ELSE DO:
                        FOR EACH tt-lista-ns:
                            CREATE MSG_SN_R1.
                            ASSIGN MSG_SN_R1.CodigoProduto = ordem-compra.it-codigo
                                   MSG_SN_R1.SerialNumber  = tt-lista-ns.num-serie.
                        END.
                    END.*/
                END.
            END.
        END.
    END. /* FOR EACH ttItem WHERE ttitem.marcado */

    DELETE PROCEDURE h-esapi016.

    IF NOT AVAIL pedido-compr THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro = 17006
               tt-erro.mensagem = "Pedido de compra n∆o cadastrado.".
        RETURN "NOK".
    END.    
    
    RETURN "OK".

END PROCEDURE.

PROCEDURE piGeraMac:
    DEFINE VARIABLE h-api023   AS HANDLE    NO-UNDO.
    DEFINE VARIABLE i-emitente AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-nome     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-email    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-macgera  AS INTEGER   NO-UNDO.

    RUN esapi/esapi023.p PERSISTENT SET h-api023.

    RUN piValidaPedidoComp IN h-api023(INPUT tt-param.num-pedido,
                                       OUTPUT i-emitente,
                                       OUTPUT c-nome,
                                       OUTPUT c-email,
                                       OUTPUT TABLE tt-erro).

    IF CAN-FIND(FIRST tt-erro) THEN DO:
        IF VALID-HANDLE(h-api023) THEN
            DELETE PROCEDURE h-api023.
        RETURN "NOK".
    END.

    FIND FIRST ItensConsulta NO-ERROR.

    FOR FIRST pedido-compr FIELDS(num-pedido)
        WHERE pedido-compr.num-pedido = tt-param.num-pedido NO-LOCK:

        itens: FOR EACH ordem-compra
            WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK:

            IF AVAIL ItensConsulta THEN DO:
                IF NOT CAN-FIND(FIRST ItensConsulta
                                WHERE ItensConsulta.CodigoProduto = ordem-compra.it-codigo) THEN
                    NEXT itens.
            END.

            FIND FIRST ttItem
                WHERE ttItem.num-pedido = pedido-compr.num-pedido
                AND   ttItem.it-codigo  = ordem-compra.it-codigo NO-ERROR.

            IF NOT AVAIL ttItem THEN DO:
                CREATE ttItem.
                ASSIGN ttItem.num-pedido = pedido-compr.num-pedido
                       ttItem.it-codigo  = ordem-compra.it-codigo
                       ttitem.marcado    = YES
                       ttitem.gerado-mac = fnRetornaQtdeMac(INPUT pedido-compr.num-pedido,
                                                            INPUT ordem-compra.it-codigo).
            END.

            ASSIGN ttItem.qt-pedido  = ttItem.qt-pedido + ordem-compra.qt-solic
                   i-macgera         = i-macgera + (ttItem.qt-pedido - ttitem.gerado-mac).

            FOR FIRST int-item-fornec FIELDS(buffer-mac)
                WHERE int-item-fornec.it-codigo    = ordem-compra.it-codigo
                AND   int-item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK:
            
                ASSIGN ttItem.buffer-mac = int-item-fornec.buffer-mac.
            END.
        END.
    END.

    IF i-macgera <= 0 THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro = 17006
               tt-erro.mensagem = "Mac address j† foi gerado para o pedido.".

        IF VALID-HANDLE(h-api023) THEN
            DELETE PROCEDURE h-api023.
        RETURN "NOK".
    END.

    /*RUN piExecGeraMac IN h-api023 (INPUT  NO,
                                   INPUT  0,
                                   INPUT  TABLE ttItem,
                                   OUTPUT TABLE tt-mac-address,
                                   OUTPUT TABLE tt-erro).*/

    RUN piPreMac IN h-api023 (INPUT  TABLE ttItem,
                              OUTPUT TABLE tt-mac-address,
                              OUTPUT TABLE tt-erro).
    
    IF RETURN-VALUE <> "OK" THEN DO:
        IF VALID-HANDLE(h-api023) THEN
            DELETE PROCEDURE h-api023.
        RETURN "NOK".
    END.
    
    RUN piGeraMac IN h-api023 (INPUT tt-param.num-pedido,
                               INPUT-OUTPUT TABLE tt-mac-address,
                               INPUT-OUTPUT TABLE tt-erro).

    IF VALID-HANDLE(h-api023) THEN
        DELETE PROCEDURE h-api023.

    IF CAN-FIND(FIRST tt-erro) THEN
        RETURN "NOK".

    IF NOT CAN-FIND(FIRST tt-mac-address) THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro = 17006
               tt-erro.mensagem = "Mac address n∆o foi gerado.".
        RETURN "NOK".
    END.

    /*FOR EACH tt-mac-address BY tt-mac-address.seq:
        CREATE MSG_Mac_R1.
        ASSIGN MSG_Mac_R1.CodigoProduto = tt-mac-address.it-codigo
               MSG_Mac_R1.MacAddress    = tt-mac-address.mac.
    END.*/

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.
