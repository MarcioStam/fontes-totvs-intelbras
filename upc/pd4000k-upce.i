PROCEDURE PiTransfereMaterial:
    DEFINE VARIABLE lAchouAE AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lAESaldo AS LOGICAL NO-UNDO.
    DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.
    def var c-cod-estabel as char no-undo.
    FOR EACH tt-erro: DELETE tt-erro. END.
    FOR EACH tt-item: DELETE tt-item. END.
    
    /*
    DEF INPUT PARAM pQtTransf LIKE saldo-estoq.qtidade-atu NO-UNDO.
    ASSIGN pQtTransf = pQtTransf * -1.
    */
/*     FOR FIRST param-estoq NO-LOCK: */
/*     END. */

    
    ASSIGN lAchouAE = NO.

    FOR EACH  ae-item USE-INDEX fifo 
        WHERE  ae-item.cod-estabel = c_cod_estab_usuar
        and    ae-item.it-codigo   = ped-ent.it-codigo 
        AND   (ae-item.cod-depos   = 'EXP')
        AND   NOT ae-item.situacao 
        AND   ae-item.localizacao <> "":

/*         IF ae-item.cod-estabel = "102"                     */
/*         AND   ae-item.localizacao = "LOCALIZAR" THEN NEXT. */

        ASSIGN lAchouAE = yes.

        FOR FIRST int-saldo-estoq NO-LOCK 
            WHERE int-saldo-estoq.cod-estabel  = ae-item.cod-estabel
            AND   int-saldo-estoq.cod-depos    = ae-item.cod-depos    
            AND   int-saldo-estoq.cod-localiz  = ae-item.localizacao
            AND   int-saldo-estoq.it-codigo    = ae-item.it-codigo:
        END.
        IF AVAIL int-saldo-estoq AND int-saldo-estoq.log-bloqueado THEN NEXT.

        /* Verifica se as AEs batem com o saldo de estoque */

        FIND FIRST bsaldo-estoq NO-LOCK 
            WHERE  bsaldo-estoq.it-codigo   = ae-item.it-codigo
            AND    bsaldo-estoq.cod-estabel = ae-item.cod-estabel
            AND    bsaldo-estoq.cod-depos   = ae-item.cod-depos  
            AND    bsaldo-estoq.cod-localiz = ae-item.localizacao NO-ERROR.
        IF AVAIL bsaldo-estoq THEN DO:

            IF (bsaldo-estoq.qtidade-atu  - 
                bsaldo-estoq.qt-alocada   - 
                bsaldo-estoq.qt-aloc-prod - 
                bsaldo-estoq.qt-aloc-ped) < ae-item.quantidade THEN DO:
                ASSIGN c-mensagem = "Item: " + bsaldo-estoq.it-codigo +
                                    " Estabelecimento: "  + bsaldo-estoq.cod-estabel +
                                    " Dep¢sito: " + ae-item.cod-depos +
                                    " Localiza‡Æo: " + ae-item.localizacao +
                                    " Quantidade AE: " + string(ae-item.quantidade) + 
                                    " Saldo cont bil: " + string(bsaldo-estoq.qtidade-atu  - bsaldo-estoq.qt-alocada   - bsaldo-estoq.qt-aloc-prod - bsaldo-estoq.qt-aloc-ped).
                ASSIGN lAESaldo = YES.
                LEAVE.                                        
            END.

        END.

        /* fim --------------------------------------------------*/                

        CREATE tt-item.
        ASSIGN tt-item.TipoTrans    = 2 /* 2 - Saida */
               tt-item.cod-estabel  = ae-item.cod-estabel
               tt-item.it-codigo    = ped-ent.it-codigo
               tt-item.cod-depos    = ae-item.cod-depos
               tt-item.quantidade   = ae-item.quantidade
               tt-item.serie        = ""
               tt-item.nro-docto    = ped-ent.nr-pedcli
               tt-item.cod-localiz  = ae-item.localizacao
               tt-item.lote         = ""
               tt-item.dt-vali-lote = ae-item.data-validade 
               tt-item.cod-refer    = ""
               c-cod-estabel        = tt-item.cod-estabel.
        LEAVE.
    END. /* FOR EACH  ae-item USE-INDEX fifo */

    IF  CAN-FIND(FIRST tt-item) THEN DO:
        CREATE tt-item.
        ASSIGN tt-item.TipoTrans    = 1 /* 1 - Entrada*/
               tt-item.cod-estabel  = c-cod-estabel
               tt-item.it-codigo    = ped-ent.it-codigo
               tt-item.cod-depos    = ae-item.cod-depos
               tt-item.quantidade   = ae-item.quantidade
               tt-item.serie        = ""
               tt-item.nro-docto    = ped-ent.nr-pedcli
               tt-item.cod-localiz  = ""
               tt-item.lote         = ""
               tt-item.dt-vali-lote = ?
               tt-item.cod-refer    = "".

        RUN esapi/esapi002.p (INPUT 2, /*Transferˆncia Entre Dep¢sitos e Cria Int-Saldo-Estoq*/
                              INPUT "ES-PD4000K",
                              INPUT  TABLE tt-item,
                              OUTPUT TABLE tt-erro).
        FOR EACH tt-erro.
            CREATE tt-AtuErro.
            BUFFER-COPY tt-erro TO tt-AtuErro.
        END.

        IF   NOT AVAIL tt-erro THEN
        DO:
            ASSIGN vQtTransferida = ae-item.quantidade.
            RUN PiCriaBaixa.
        END.
        ELSE ASSIGN cReturn = "NOK".

        IF cReturn <> "NOK" THEN
        DO:
            FOR FIRST bsaldo-estoq NO-LOCK 
                WHERE bsaldo-estoq.it-codigo   = saldo-estoq.it-codigo
                AND   bsaldo-estoq.cod-estabel = saldo-estoq.cod-estabel    
                AND  (bsaldo-estoq.cod-depos   = "EXP")
                AND   bsaldo-estoq.cod-localiz = "":
                IF (bsaldo-estoq.qtidade-atu - bsaldo-estoq.qt-alocada
                                            - bsaldo-estoq.qt-aloc-prod
                                            - bsaldo-estoq.qt-aloc-ped) <= (ped-ent.qt-pedida - ped-ent.qt-atendida) THEN
                DO:
                    CREATE tt-erro.
                    ASSIGN tt-erro.i-sequen = 1
                           tt-erro.cd-erro  = 17567
                           tt-erro.mensagem = "NÆo foi poss¡vel fazer FIFO de AE para o item: " + saldo-estoq.It-Codigo
                           cReturn          = "NOK".
                END.
            END.
        END.
    END.
    ELSE DO:
        IF lAESaldo THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 17567
                   tt-erro.mensagem = "Item " + ae-item.it-codigo + " possui AE sem saldo em estoque! Favor entrar em contato com Expedi‡Æo. " + c-mensagem
                   cReturn          = "NOK".        
            FOR EACH tt-erro.
                CREATE tt-AtuErro.
                BUFFER-COPY tt-erro TO tt-AtuErro.
            END.        
        END.
        ELSE DO:
            IF NOT lAchouAE THEN
            DO:
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = 17006
                       tt-erro.mensagem = "AE nÆo encontrado para o item " + ped-ent.it-codigo + "! Favor entrar em contato com Expedi‡Æo."
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
                                           int-saldo-estoq.it-codigo + " " + int-saldo-estoq.cod-depos + "! Favor entrar em contato com Expedi‡Æo."
                       cReturn          = "NOK".
                FOR EACH tt-erro.
                    CREATE tt-AtuErro.
                    BUFFER-COPY tt-erro TO tt-AtuErro.
                END.
            END.
        END.
    END.
    RELEASE int-saldo-estoq.
END.

PROCEDURE PiCriaBaixa:
   FIND FIRST ae-baixa NO-LOCK 
        WHERE ae-baixa.cod-estabel = c_cod_estab_usuar
        and   ae-baixa.nr-ae     = ae-item.nr-ae 
        AND   ae-baixa.sequencia = ae-item.sequencia NO-ERROR.

   IF NOT AVAIL ae-baixa THEN DO:
      CREATE ae-baixa.
      ASSIGN ae-baixa.cod-estabel = c_cod_estab_usuar
             ae-baixa.nr-ae       = ae-item.nr-ae 
             ae-baixa.sequencia   = ae-item.sequencia
             ae-baixa.localizacao = ae-item.localizacao.
   END.
   ASSIGN ae-item.situacao  = YES.

END PROCEDURE.
