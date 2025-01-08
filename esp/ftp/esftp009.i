/** Programa: esftp009.w                                        **/
/** Objetivo: Programa criado para evitar estouro de procedure. **/
/** PROCEDURE piCriaWt-itens :                                  **/

    DEFINE VARIABLE iSeqWtDocto         AS INTEGER      NO-UNDO.
    DEFINE VARIABLE iSeqWtItDocto       AS INTEGER      NO-UNDO.

    DEFINE VARIABLE l-procedimento-ok   AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE ultprocesso         AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE i-seq               AS INTEGER      NO-UNDO INITIAL 0.
    DEFINE VARIABLE h-acomp             AS HANDLE       NO-UNDO.
    DEFINE VARIABLE l-erro              AS LOGICAL     NO-UNDO.

    
    FIND FIRST wt-docto WHERE
        wt-docto.seq-wt-docto = i-seq-wt-docto EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE wt-docto THEN DO:
        RUN utp/ut-msgs.p ('show', 17006, 'PrÇ-c†lculo n∆o selecionado.~~Deve ser selecionado um prÇ-calculo de Nota Fiscal para atribuiá∆o de itens').
        RETURN 'NOK'.
    END.
    ELSE 
        IF l-aloca-estoque THEN DO:
            ASSIGN wt-docto.ind-lib-nota = YES.
        END.

    FIND FIRST ped-fiscal EXCLUSIVE-LOCK
        WHERE  ped-fiscal.nr-pedido = int(c-nr-solicitacao:SCREEN-VALUE IN FRAME fpage0) NO-ERROR.
    IF  NOT AVAIL ped-fiscal THEN DO:
        RUN utp/ut-msgs.p ('show', 17006, 'esftp009.i - Solicitacao nao encontrada').
        RETURN "NOK":U.
    END.
    IF LOCKED ped-fiscal THEN DO:
        RUN utp/ut-msgs.p ('show', 17006, 'Registro Alocado por Outro usuario').
        RETURN 'NOK'.
    END.

    IF  ped-fiscal.situacao <> 2 THEN DO:
        RUN utp/ut-msgs.p ('show', 17006, 'Pedido nao esta com situacao a Relacionar').
        RETURN 'NOK'.
    END.

    IF ped-fiscal.cod-estabel <> wt-docto.cod-estabel THEN DO:
        RUN utp/ut-msgs.p ('show', 17006, 'Estabelecimento do Pedido de Nota fiscal diferente do PrÇ-calculo, favor Revisar').
        RETURN 'NOK'.
    END.

    
    IF ped-fiscal.nat-oper = 18 AND
       CAN-FIND(FIRST it-ped-fiscal WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido AND it-ped-fiscal.it-codigo = "TERC") THEN DO:
        FIND natur-oper
            WHERE natur-oper.nat-operacao = wt-docto.nat-operacao
            NO-LOCK NO-ERROR.
        IF AVAIL natur-oper THEN DO:
            IF NOT natur-oper.terceiros THEN DO:
                MESSAGE "Natureza de operaá∆o informada n∆o esta parametrizada como operaá∆o com terceiros, divergente com a natureza informada no pedido e item TERC" SKIP
                        "Utilize o bot∆o Ger IT"
                       VIEW-AS ALERT-BOX.

            END.
            ELSE DO:
                 MESSAGE "Natureza de operaá∆o informada  esta parametrizada como operaá∆o com terceiros, divergente com a natureza informada no pedido e item TERC" SKIP
                        "Utilize o bot∆o Ger IT"
                       VIEW-AS ALERT-BOX.
            END.
        END.
    END.

    ASSIGN i-seq = 0.
    FOR EACH tt-saldo: DELETE tt-saldo. END.
    ASSIGN de-qtde = 0
           de-qtde-se = 0
           de-qtde-br = 0.
    IF NOT l-aloca-estoque THEN DO:
        RUN piVerificaSaldo.
    END.

    FIND FIRST tt-saldo NO-LOCK NO-ERROR.
    IF AVAIL tt-saldo THEN DO:
        RUN esp/ftp/esftp009a.w (INPUT TABLE tt-saldo,
                                 INPUT ped-fiscal.nr-pedido).
    END.
    ELSE DO:
        IF  NOT VALID-HANDLE(h-acomp) THEN
            RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    
        RUN pi-inicializar IN h-acomp (INPUT "Criando Itens").

        FIND FIRST natur-oper WHERE
                   natur-oper.nat-operacao = wt-docto.nat-operacao NO-LOCK NO-ERROR.

        IF natur-oper.emite-dup THEN DO:
            FIND FIRST emitente WHERE
                       emitente.cod-emitente = wt-docto.cod-emitente NO-LOCK NO-ERROR.

            FIND FIRST repres WHERE
                       repres.cod-rep = emitente.cod-rep NO-LOCK NO-ERROR.


            /* Retirado por solicitaá∆o do Claudiney em 14/01/2005
            IF NOT AVAILABLE repres OR
              (NOT repres.nome-ab-reg BEGINS "2" AND
               NOT repres.nome-ab-reg BEGINS "3" AND
               NOT repres.nome-ab-reg BEGINS "7") THEN DO:
                RUN utp/ut-msgs.p ('show', 17006, 'Representante sem Unidade de Neg¢cio~~Este representante nao pertence a nenhuma unidade de negocio.').
                RETURN 'NOK'.
            END.
            */ 
        END.

        FIND FIRST emitente NO-LOCK
            WHERE  emitente.nome-abrev = wt-docto.nome-abrev NO-ERROR.
        IF  NOT AVAIL emitente THEN
            RETURN "NOK":U.


        ASSIGN iSeqWtDocto = wt-docto.seq-wt-docto.

        FIND FIRST transporte NO-LOCK WHERE
                   transporte.cod-transp = ped-fiscal.cod-transp NO-ERROR.

        IF NOT AVAILABLE transporte THEN
            RETURN 'NOK'.
        
        /*Inicializa as BOs a serem utilizadas*/
        RUN dibo/bodi317in.p    PERSISTENT SET h-bodi317in.

        RUN inicializaBOS   IN h-bodi317in(OUTPUT h-bodi317pr,      /*Necess†ria Ö h-bodi317sd*/
                                           OUTPUT h-bodi317sd,      /*Inicializaá‰es das tabelas da NF*/
                                           OUTPUT h-bodi317im1br,   /*Necess†ria Ö h-bodi317sd*/
                                           OUTPUT h-bodi317va).     /*Necess†ria Ö h-bodi317sd*/

        RUN emptyRowErrorsBodi317sd IN h-bodi317sd.
        RUN setaHandlesBOS IN h-bodi317sd (h-bodi317pr, h-bodi317sd, h-bodi317im1br, h-bodi317va).

        /*Wt-docto*/
        RUN dibo/bodi317.p      PERSISTENT SET h-bodi317.       /*Wt-docto*/
        RUN openQueryStatic IN h-bodi317 ('default').

        RUN gotoKey         IN h-bodi317 (iSeqWtDocto).
        RUN getRecord       IN h-bodi317 (OUTPUT TABLE ttWt-docto).

        FIND FIRST ttWt-docto.

        RUN emptyRowErrors IN h-bodi317.

        EMPTY TEMP-TABLE tt-itens-devol.

        /*
        cria-nf:
        DO ON ERROR UNDO, RETURN 'NOK':
        */
        ASSIGN l-erro = NO.
        cria-nf:
        DO TRANS ON ENDKEY UNDO cria-nf, LEAVE cria-nf 
                 ON ERROR  UNDO cria-nf, LEAVE cria-nf:

            RUN pi-acompanhar IN h-acomp (INPUT "Atualizando Documento").

            /* Atribuiá∆o de valores para capa da Nota Fiscal */
            ASSIGN ttWt-docto.nome-transp       = transporte.nome-abrev
                   ttWt-docto.observ-nota       = ped-fiscal.observacao[1] + 
                                                  ped-fiscal.observacao[2] +
                                                  ped-fiscal.observacao[3] +
                                                  ped-fiscal.observacao[4] +
                                                  ped-fiscal.observacao[5] + IF substring(ped-fiscal.char-1,65,20) <> "" THEN " Receptor Mercadoria: " + substring(ped-fiscal.char-1,65,20) ELSE ""
                   ttWt-docto.nr-volumes        = trim(string(ped-fiscal.nr-volumes,">>>>>9"))
                   ttWt-docto.num-romaneio      = ped-fiscal.nr-pedido   
                   ttWt-docto.cod-canal-venda   = ped-fiscal.canal-vendas
                   ttWt-docto.ind-tp-frete      = (IF ped-fiscal.frete /*CIF*/ THEN 1 ELSE 2)
                   OVERLAY(ttWt-docto.char-2,101,2) = i-fin-nfe:SCREEN-VALUE IN FRAME fpage0.
                   //overlay(ttWt-docto.char-1,158,8) =  IF ped-fiscal.frete /*CIF*/ THEN "0" ELSE "1".

            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "esftp012a":U,
                               INPUT 2,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).
            
            FOR FIRST tt-prog-ponto
                WHERE int(tt-prog-ponto.conteudo) = ped-fiscal.cod-transp:
                    ASSIGN overlay(ttWt-docto.char-1,158,8) = IF ped-fiscal.frete /*CIF*/ THEN "3" ELSE "4".
            END.
                
            IF NOT AVAIL tt-prog-ponto THEN
                ASSIGN overlay(ttWt-docto.char-1,158,8) =  IF ped-fiscal.frete /*CIF*/ THEN "0" ELSE "1".

            RUN setRecord    IN h-bodi317 (TABLE ttWt-docto).
            RUN updateRecord IN h-bodi317.
            IF RETURN-VALUE = 'NOK' THEN DO:
                RUN getRowErrors IN h-bodi317 (OUTPUT TABLE RowErrors).
                IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = 'Error') THEN DO:
                    IF  VALID-HANDLE(h-acomp) THEN
                        RUN pi-finalizar IN h-acomp.

                    RUN finalizaHandles        IN THIS-PROCEDURE.
                    RUN exibeRowErrors         IN THIS-PROCEDURE.
                    ASSIGN l-erro = YES.
                    UNDO cria-nf, LEAVE cria-nf .
                END.
            END.

            FIND FIRST int-wt-docto NO-LOCK
                WHERE int-wt-docto.seq-wt-docto = wt-docto.seq-wt-docto NO-ERROR.
            IF  NOT AVAIL int-wt-docto THEN
                CREATE int-wt-docto.

            ASSIGN int-wt-docto.seq-wt-docto = wt-docto.seq-wt-docto
                   int-wt-docto.finalidade   = g-finalidade-esftp009
                   g-finalidade-esftp009     = "".

            IF NOT wt-docto.nat-operacao BEGINS "631" AND
               NOT wt-docto.nat-operacao BEGINS "695" AND
               NOT wt-docto.nat-operacao BEGINS "531" AND
               NOT wt-docto.nat-operacao BEGINS "595" AND
               NOT wt-docto.nat-operacao BEGINS "532" AND
               NOT wt-docto.nat-operacao BEGINS "632" THEN DO:

                /*Wt-it-docto*/

                FIND LAST wt-it-docto NO-LOCK OF wt-docto NO-ERROR.
                IF AVAILABLE wt-it-docto THEN
                    ASSIGN i-seq = wt-it-docto.seq-wt-it-docto.
                ELSE
                    ASSIGN i-seq = 0.

                FOR EACH it-ped-fiscal OF ped-fiscal NO-LOCK,
                    FIRST ITEM NO-LOCK WHERE
                          ITEM.it-codigo = it-ped-fiscal.it-codigo
                    BY it-ped-fiscal.seq /*ON ERROR UNDO cria-nf, RETURN 'NOK'*/:

                    RUN pi-acompanhar IN h-acomp (INPUT "Item: " + item.it-codigo).

                    /* Quando for uma Transferància do Estabel '104' para o '101',
                       e o Item n∆o Baixa Estoque, vai para o pr¢ximo */
                    IF  wt-docto.cod-estabel   = "104"  AND
                        emitente.cod-emitente  = 103748 AND
                        natur-oper.especie-doc = "NFT"  AND
                        NOT ITEM.baixa-estoq            THEN
                        NEXT.

                    IF ped-fiscal.nat-oper = 18 AND
                       CAN-FIND(FIRST it-ped-fiscal WHERE it-ped-fiscal.nr-pedido = ped-fiscal.nr-pedido AND it-ped-fiscal.it-codigo = "TERC") THEN DO:
  
                                NEXT.
                            
                    END.

                    FIND FIRST item-uni-estab WHERE item-uni-estab.cod-estabel = "101" AND 
                                                    item-uni-estab.it-codigo = it-ped-fiscal.it-codigo NO-LOCK NO-ERROR.
                    IF AVAIL item-uni-estab THEN DO:
                        FIND FIRST bitem-uni-estab WHERE bitem-uni-estab.cod-estabel = "104" AND 
                                                         bitem-uni-estab.it-codigo = it-ped-fiscal.it-codigo NO-ERROR.
                        IF NOT AVAIL bitem-uni-estab THEN DO:
                            CREATE bitem-uni-estab.
                            BUFFER-COPY item-uni-estab EXCEPT cod-estabel TO bitem-uni-estab.
                            ASSIGN bitem-uni-estab.cod-estabel = "104".
                        END.
                    
                    END.

                    ASSIGN i-seq = i-seq + 10.

                    RUN localizaWtDocto IN h-bodi317sd (INPUT  iSeqWtDocto, OUTPUT l-procedimento-ok).

                    IF  SUBSTRING(it-ped-fiscal.char-1,61,18) <> "" /* Significa que estˇ inclu≠ndo um item pelo FT4004 e nío pelo botío gerar */
                        AND natur-oper.terceiros
                        AND natur-oper.tp-oper-terc <> 1
                        AND natur-oper.tp-oper-terc <> 3 
                        AND natur-oper.tp-oper-terc <> 7 THEN DO: /* Drawback */

                        /* MENSAGEM: 15528 - Natureza de operaªío invˇlida para inclusío */

                        IF NOT VALID-HANDLE(h-bodi317in) THEN
                            RUN dibo/bodi317in.p PERSISTENT SET h-bodi317in.
                        IF NOT VALID-HANDLE(h-bodi317sd) THEN
                            RUN dibo/bodi317sd.p PERSISTENT SET h-bodi317sd.
                        IF NOT VALID-HANDLE(h-boin404te) THEN
                            RUN inbo/boin404te.p PERSISTENT SET h-boin404te.
    
                        FOR FIRST saldo-terc 
                            WHERE ROWID(saldo-terc) = TO-ROWID(SUBSTRING(it-ped-fiscal.char-1,61,18)) NO-LOCK:
                        END.
                        FOR EACH tt-it-terc-nf:
                            DELETE tt-it-terc-nf.
                        END.

                        IF  NOT AVAIL saldo-terc THEN DO:
                            RUN utp/ut-msgs.p ('show', 17006, 'N∆o foi encontrado Saldo em Poder de Terceiro.~~N∆o foi poss°vel gerar o item da nota, pois n∆o foi encontrado o relacionamento do saldo em poder de terceiros').
                            ASSIGN l-erro = YES.
                            UNDO cria-nf, LEAVE cria-nf.
                        END.

                        CREATE tt-it-terc-nf.
                        ASSIGN tt-it-terc-nf.rw-saldo-terc     = ROWID(saldo-terc)
                               tt-it-terc-nf.sequencia         = saldo-terc.sequencia
                               tt-it-terc-nf.it-codigo         = saldo-terc.it-codigo
                               tt-it-terc-nf.cod-refer         = saldo-terc.cod-refer
                               tt-it-terc-nf.desc-nar          = IF ITEM.tipo-contr = 4 /* D˝bito Direto */
                                                                 THEN SUBSTR(ITEM.narrativa,1,60)
                                                                 ELSE ITEM.desc-item
                               tt-it-terc-nf.quantidade        = it-ped-fiscal.qtde
                               tt-it-terc-nf.qt-alocada        = it-ped-fiscal.qtde
                               tt-it-terc-nf.qt-disponivel     = it-ped-fiscal.qtde
                               tt-it-terc-nf.qt-disponivel-inf = it-ped-fiscal.qtde
                               tt-it-terc-nf.preco-total       = it-ped-fiscal.vl-unit
                               tt-it-terc-nf.preco-total-inf   = it-ped-fiscal.vl-unit
                               tt-it-terc-nf.selecionado       = YES.

                        RUN emptyRowErrors                    IN h-bodi317in.
                        RUN setaHandleBoin404te               IN h-bodi317sd(INPUT h-boin404te).
                        RUN geraWtItDoctoPartindoDoTtItTercNf IN h-bodi317sd(INPUT  wt-docto.seq-wt-docto,
                                                                             INPUT  10,
                                                                             INPUT  10,
                                                                             INPUT  TABLE tt-it-terc-nf,
                                                                             OUTPUT l-proc-ok-aux).
                        RUN devolveErrosbodi317sd             IN h-bodi317sd(OUTPUT c-ultimo-metodo-exec,
                                                                             OUTPUT TABLE RowErrors).

                        if l-aloca-estoque  and
                           item.baixa-estoq and
                           item.tipo-contr <> 4 then do:
        
                            /*Alocaá∆o por lote*/
                            IF item.tipo-con-est = 3 THEN DO:
                                IF NOT CAN-FIND (FIRST int-saldo-aloc-lote
                                                 WHERE int-saldo-aloc-lote.nr-pedido = it-ped-fiscal.nr-pedido
                                                   AND int-saldo-aloc-lote.it-codigo = it-ped-fiscal.it-codigo
                                                   AND int-saldo-aloc-lote.seq       = it-ped-fiscal.seq) THEN DO:

                                   MESSAGE "Alocaá∆o de estoque n∆o encontrada!" skip
                                           it-ped-fiscal.nr-pedido         skip
                                           it-ped-fiscal.it-codigo         skip
                                           it-ped-fiscal.seq        view-as alert-box.
                                   ASSIGN l-erro = YES.
                                   UNDO cria-nf, LEAVE cria-nf.
                                END.

                                FOR EACH wt-fat-ser-lote
                                   WHERE wt-fat-ser-lote.seq-wt-docto    = iSeqWtDocto
                                     AND wt-fat-ser-lote.seq-wt-it-docto = iSeqWtItDocto exclusive-lock:
                                    DELETE wt-fat-ser-lote.
                                END.

                                FOR EACH int-saldo-aloc-lote NO-LOCK
                                   WHERE int-saldo-aloc-lote.nr-pedido = it-ped-fiscal.nr-pedido
                                     AND int-saldo-aloc-lote.it-codigo = it-ped-fiscal.it-codigo
                                     AND int-saldo-aloc-lote.seq       = it-ped-fiscal.seq:

                                   FIND FIRST saldo-estoq NO-LOCK
                                        WHERE saldo-estoq.it-codigo   = int-saldo-aloc-lote.it-codigo
                                          AND saldo-estoq.cod-estabel = ped-fiscal.cod-estabel
                                          AND saldo-estoq.cod-localiz = int-saldo-aloc-lote.cod-localiz
                                          AND saldo-estoq.cod-depos   = int-saldo-aloc-lote.cod-depos
                                          AND saldo-estoq.lote        = int-saldo-aloc-lote.lote NO-ERROR.

                                   IF NOT AVAIL saldo-estoq THEN DO:
                                       message "Alocaá∆o de estoque n∆o encontrada!! " skip
                                                int-saldo-aloc-lote.nr-pedido          skip
                                                int-saldo-aloc-lote.it-codigo          skip
                                                int-saldo-aloc-lote.seq        view-as alert-box.
                                       ASSIGN l-erro = YES.
                                       UNDO cria-nf, LEAVE cria-nf.
                                   END.

                                   CREATE wt-fat-ser-lote.
                                   ASSIGN wt-fat-ser-lote.seq-wt-docto    = iSeqWtDocto
                                          wt-fat-ser-lote.seq-wt-it-docto = iSeqWtItDocto
                                          wt-fat-ser-lote.it-codigo       = int-saldo-aloc-lote.it-codigo
                                          wt-fat-ser-lote.cod-depos       = int-saldo-aloc-lote.cod-depos
                                          wt-fat-ser-lote.cod-localiz     = int-saldo-aloc-lote.cod-localiz
                                          wt-fat-ser-lote.lote            = int-saldo-aloc-lote.lote
                                          wt-fat-ser-lote.dt-vali-lote    = saldo-estoq.dt-vali-lote
                                          wt-fat-ser-lote.char-1          = ""
                                          wt-fat-ser-lote.quantidade[1]   = int-saldo-aloc-lote.qtidade-atu
                                          wt-fat-ser-lote.log-1           = YES.

                                   FIND FIRST wt-fat-ser-lote
                                        WHERE wt-fat-ser-lote.seq-wt-docto    = iSeqWtDocto
                                          AND wt-fat-ser-lote.seq-wt-it-docto = iSeqWtItDocto
                                          AND wt-fat-ser-lote.it-codigo       = it-ped-fiscal.it-codigo
                                          AND wt-fat-ser-lote.cod-depos       = it-ped-fiscal.cod-depos
                                          AND wt-fat-ser-lote.cod-localiz     = it-ped-fiscal.cod-localizacao
                                          AND wt-fat-ser-lote.lote            = int-saldo-aloc-lote.lote no-lock no-error.
                                   RELEASE wt-fat-ser-lote.                
                                END.
                            END.
                            ELSE DO:
                                find first saldo-estoq 
                                     where saldo-estoq.cod-estabel = ped-fiscal.cod-estabel
                                       and saldo-estoq.it-codigo   = it-ped-fiscal.it-codigo
                                       and saldo-estoq.cod-depos   = it-ped-fiscal.cod-depos
                                       and saldo-estoq.cod-local   = it-ped-fiscal.cod-localizacao no-lock no-error.  
                                if not avail saldo-estoq then do:
                                   message "Saldo Estoque nao encontrado " skip
                                            v_cod_estab_usuar    skip
                                            saldo-estoq.it-codigo          skip
                                            saldo-estoq.cod-depos          skip
                                            saldo-estoq.cod-localiz        view-as alert-box.
                                   ASSIGN l-erro = YES.
                                   UNDO cria-nf, LEAVE cria-nf.
                                end.
                                for each wt-fat-ser-lote
                                    where wt-fat-ser-lote.seq-wt-docto    = iSeqWtDocto
                                      and wt-fat-ser-lote.seq-wt-it-docto = iSeqWtItDocto exclusive-lock:
                                    delete wt-fat-ser-lote.
                                end.
                                create wt-fat-ser-lote.
                                assign wt-fat-ser-lote.seq-wt-docto    = iSeqWtDocto
                                       wt-fat-ser-lote.seq-wt-it-docto = iSeqWtItDocto
                                       wt-fat-ser-lote.it-codigo       = it-ped-fiscal.it-codigo
                                       wt-fat-ser-lote.cod-depos       = it-ped-fiscal.cod-depos
                                       wt-fat-ser-lote.cod-localiz     = it-ped-fiscal.cod-localizacao
                                       wt-fat-ser-lote.dt-vali-lote    = saldo-estoq.dt-vali-lote
                                       wt-fat-ser-lote.char-1          = ""
                                       wt-fat-ser-lote.quantidade[1]   = it-ped-fiscal.qtde
                                       wt-fat-ser-lote.log-1           = yes.
                                find first wt-fat-ser-lote
                                     where wt-fat-ser-lote.seq-wt-docto    = iSeqWtDocto
                                       and wt-fat-ser-lote.seq-wt-it-docto = iSeqWtItDocto
                                       and wt-fat-ser-lote.it-codigo       = it-ped-fiscal.it-codigo
                                       and wt-fat-ser-lote.cod-depos       = it-ped-fiscal.cod-depos
                                       and wt-fat-ser-lote.cod-localiz     = it-ped-fiscal.cod-localizacao no-lock no-error.
                                release wt-fat-ser-lote.                
                            END.
                        end.
    
                        RUN getRowErrors IN h-bodi317 (OUTPUT TABLE RowErrors).
                        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = 'Error') THEN DO:
                            IF  VALID-HANDLE(h-acomp) THEN
                                RUN pi-finalizar IN h-acomp.

                            RUN finalizaHandles        IN THIS-PROCEDURE.
                            RUN exibeRowErrors         IN THIS-PROCEDURE.
                            ASSIGN l-erro = YES.
                            UNDO cria-nf, LEAVE cria-nf.
                        END.
                    END.
                    ELSE DO:
                        /** Quando utilizado o botao "Ger It" no programa ESFTP012, armazena chave da tabela "item-doc-est" (nota devolucao) 
                            nos campos abaixo, neste caso o processo ser† igual ao "Ger It" do FT4003.
                            Serie-docto  = substr(it-ped-fiscal.char-1,19,5) 
                            Nro-docto    = substr(it-ped-fiscal.char-1,24,16)
                            Cod-emitente = substr(it-ped-fiscal.char-1,40,9) 
                            Nat-operacao = substr(it-ped-fiscal.char-1,49,6) 
                            Sequencia    = substr(it-ped-fiscal.char-1,55,5) 
                        **/
                                                              

                        IF  SUBSTR(it-ped-fiscal.char-1,19,5)  <> "" AND
                            SUBSTR(it-ped-fiscal.char-1,24,16) <> "" AND 
                            SUBSTR(it-ped-fiscal.char-1,40,9)  <> "" AND 
                            SUBSTR(it-ped-fiscal.char-1,49,6)  <> "" AND 
                            SUBSTR(it-ped-fiscal.char-1,55,5)  <> "" THEN DO:
                            
                            /** Cria tt 'tt-itens-devol' apartir dos itens criados no ESFTP012.
                                Apos a criacao de todos os itens, cria todas as 'WT-IT-DOCTO'. **/
                            RUN geraItensDevolucaoTtItensDevol (INPUT  SUBSTRING(it-ped-fiscal.char-1,19,5),         /* Serie-docto  */ 
                                                                INPUT  SUBSTRING(it-ped-fiscal.char-1,24,16),        /* Nro-docto    */ 
                                                                INPUT  INT(SUBSTRING(it-ped-fiscal.char-1,40,9)),    /* Cod-emitente */ 
                                                                INPUT  SUBSTRING(it-ped-fiscal.char-1,49,6),         /* Nat-operacao */ 
                                                                INPUT  INT(SUBSTRING(it-ped-fiscal.char-1,55,5)),    /* Sequencia    */ 
                                                                INPUT  it-ped-fiscal.qtde,
                                                                OUTPUT l-proc-ok-aux).

                            IF NOT CAN-FIND(FIRST tt-itens-devol) THEN DO:
                               RUN finalizaHandles        IN THIS-PROCEDURE.
                               ASSIGN l-erro = YES.
                               UNDO cria-nf, LEAVE cria-nf.
                            END.   
                        END.
                        ELSE DO:
                            RUN criaWtItDocto IN h-bodi317sd (?,
                                                              '',
                                                              i-seq,
                                                              it-ped-fiscal.it-codigo,
                                                              '',
                                                              wt-docto.nat-oper,
                                                              OUTPUT iSeqWtItDocto,
                                                              OUTPUT l-procedimento-ok).

                            IF NOT l-procedimento-ok THEN DO:
                               RUN devolveErrosBodi317sd IN h-bodi317sd (OUTPUT ultprocesso, OUTPUT TABLE RowErrors).
                               IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = 'Error') THEN DO:
                                   IF  VALID-HANDLE(h-acomp) THEN
                                       RUN pi-finalizar IN h-acomp.

                                  RUN finalizaHandles IN THIS-PROCEDURE.
                                  RUN exibeRowErrors  IN THIS-PROCEDURE.
                                  ASSIGN l-erro = YES.
                                  UNDO cria-nf, LEAVE cria-nf.
                               END.
                            END.

                            /*Para naturezas de transferància utiliza o £ltimo custo mÇdio calculado*/
                            IF ped-fiscal.nat-oper = 4 THEN DO:
                                FIND FIRST item-estab NO-LOCK
                                     WHERE item-estab.cod-estabel = ped-fiscal.cod-estabel
                                       AND item-estab.it-codigo   = it-ped-fiscal.it-codigo NO-ERROR.
                                IF AVAIL item-estab THEN DO:
                                    FIND CURRENT it-ped-fiscal EXCLUSIVE-LOCK.
                                    ASSIGN it-ped-fiscal.vl-uni = item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1].
                                    FIND CURRENT it-ped-fiscal NO-LOCK.
                                END.

                                IF it-ped-fiscal.vl-uni = 0 THEN DO:
                                    FOR LAST preco-item NO-LOCK
                                       WHERE preco-item.it-codigo  = it-ped-fiscal.it-codigo
                                         AND preco-item.nr-tabpre  = "Minimo"
                                         AND preco-item.situacao   = 1
                                         AND preco-item.dt-inival <= TODAY:
                                        FIND CURRENT it-ped-fiscal EXCLUSIVE-LOCK.
                                        ASSIGN it-ped-fiscal.vl-uni = preco-item.preco-venda.
                                        FIND CURRENT it-ped-fiscal NO-LOCK.
                                    END.
                                END.
                            END.
                            /* Grava informaá‰es gerais para o item da nota */
                            RUN gravaInfGeraisWtItDocto in h-bodi317sd (INPUT iSeqWtDocto,
                                                                        INPUT iSeqWtItDocto,
                                                                        INPUT it-ped-fiscal.qtde,
                                                                        INPUT it-ped-fiscal.vl-uni,
                                                                        INPUT 0,
                                                                        INPUT 0).                    

                            IF NOT VALID-HANDLE (h-bodi321) THEN
                                RUN dibo/bodi321.p PERSISTENT SET h-bodi321.       /*Wt-it-docto*/

                            RUN openQueryStatic IN h-bodi321 ('default').
                            RUN gotoKey         IN h-bodi321 (iSeqWtDocto, iSeqWtItDocto).
                            RUN getRecord       IN h-bodi321 (OUTPUT TABLE ttWt-It-docto).

                            FIND FIRST ttWt-It-docto.

/*                             FIND FIRST unid-neg-canal-venda NO-LOCK                                                 */
/*                                 WHERE unid-neg-canal-venda.cod-canal-venda = ped-fiscal.canal-vendas NO-ERROR.      */
/*                                                                                                                     */
/*                             IF AVAIL unid-neg-canal-venda THEN DO:                                                  */
/*                                 FIND FIRST unid_negoc NO-LOCK                                                  */
/*                                     WHERE unid_negoc.cdn_unid_negoc = unid-neg-canal-venda.cdn_unid_negoc NO-ERROR. */
/*                             END.                                                                                    */

                            find FIRST cc_uni_estab no-lock
                                 where cc_uni_estab.cod_ccusto     = ped-fiscal.sc-codigo
                                   and cc_uni_estab.cod_estab      = ped-fiscal.cod-estabel no-error.
                            if  avail cc_uni_estab THEN DO:
                                FIND FIRST unid_negoc NO-LOCK                                                 
                                    WHERE unid_negoc.cod_unid_negoc = cc_uni_estab.cod_unid_negoc NO-ERROR.
                            END. /* if  avail cc_uni_estab THEN DO: */

                            ASSIGN ttWt-It-docto.narrativa       = it-ped-fiscal.narrativa. 

                            IF  it-ped-fiscal.nr-patrimonio > 0 THEN 
                                ASSIGN ttWt-It-docto.narrativa = ttWt-It-docto.narrativa + " - NR. Patrimìnio: " + string(it-ped-fiscal.nr-patrimonio).

                            ASSIGN ttwt-it-docto.quantidade[2]   = it-ped-fiscal.qtde
                                   ttwt-it-docto.un[2]           = ITEM.un
                                   ttwt-it-docto.peso-bru-it-inf = it-ped-fiscal.qtde * it-ped-fiscal.peso-bru-item
                                   ttwt-it-docto.peso-liq-it-inf = it-ped-fiscal.qtde * it-ped-fiscal.peso-liq-item
                                   ttwt-it-docto.peso-liq-it     = ttwt-it-docto.peso-liq-it-inf
                                   ttwt-it-docto.peso-bruto-it   = ttwt-it-docto.peso-bru-it-inf
                                   ttwt-it-docto.cod-unid-negoc  = IF AVAIL unid_negoc THEN unid_negoc.cod_unid_negoc ELSE "".

                            IF SUBSTRING(it-ped-fiscal.char-1,11,8) <> "" THEN
                                ASSIGN ttwt-it-docto.class-fiscal    = SUBSTRING(it-ped-fiscal.char-1,11,8).  
                            ELSE
                                ASSIGN ttwt-it-docto.class-fiscal    = ITEM.class-fiscal.  
                          
                            RUN setRecord    IN h-bodi321 (TABLE ttWt-It-docto).
                            RUN updateRecord IN h-bodi321.
                            

                            IF RETURN-VALUE = 'NOK' THEN DO:
                               RUN getRowErrors IN h-bodi321 (OUTPUT TABLE RowErrors).
                               IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = 'Error') THEN DO:
                                   IF  VALID-HANDLE(h-acomp) THEN
                                       RUN pi-finalizar IN h-acomp.

                                  RUN finalizaHandles        IN THIS-PROCEDURE.
                                  RUN exibeRowErrors         IN THIS-PROCEDURE.
                                  ASSIGN l-erro = YES.
                                  UNDO cria-nf, LEAVE cria-nf.
                               END.
                            END.

                            /* Limpar a tabela de erros em todas as BOS */
                            RUN emptyRowErrors          IN h-bodi317in.

                            /* Disp. registro WT-DOCTO, WT-IT-DOCTO e WT-IT-IMPOSTO na bodi317pr */
                            RUN localizaWtDocto         IN h-bodi317pr(INPUT iSeqWtDocto, OUTPUT l-procedimento-ok).
                            RUN localizaWtItDocto       IN h-bodi317pr(INPUT iSeqWtDocto, INPUT  iSeqWtItDocto, OUTPUT l-procedimento-ok).
                            RUN localizaWtItImposto     IN h-bodi317pr(INPUT iSeqWtDocto, INPUT  iSeqWtItDocto, OUTPUT l-procedimento-ok).


                            FIND FIRST wt-it-imposto
                                 WHERE wt-it-imposto.seq-wt-docto = iSeqWtDocto
                                   AND wt-it-imposto.seq-wt-it-docto = iSeqWtItDocto
                                 EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAIL wt-it-imposto THEN 
                                ASSIGN wt-it-imposto.aliquota-ipi    = it-ped-fiscal.aliquota-ipi.

                            /* Atualiza dados calculados do item */
                            RUN atualizaDadosItemNota   IN h-bodi317pr(OUTPUT l-procedimento-ok).

                            FOR EACH wt-it-docto
                                WHERE wt-it-docto.seq-wt-docto = iseqwtdocto
                                  AND wt-it-docto.seq-wt-it-docto = iseqwtitdocto EXCLUSIVE-LOCK:
                                ASSIGN wt-it-docto.peso-bru-it-inf = it-ped-fiscal.qtde * it-ped-fiscal.peso-bru-item
                                       wt-it-docto.peso-liq-it-inf = it-ped-fiscal.qtde * it-ped-fiscal.peso-liq-item
                                       wt-it-docto.peso-liq-it     = 0
                                       wt-it-docto.peso-bruto-it   = 0.
                            END.

                            /* Valida informaªÑes do item */
                            RUN validaItemDaNota        IN h-bodi317va(INPUT iSeqWtDocto, INPUT iSeqWtItDocto, OUTPUT l-procedimento-ok).

                            IF NOT l-procedimento-ok THEN DO:
                               RUN devolveErrosBodi317va IN h-bodi317va (OUTPUT ultprocesso, OUTPUT TABLE RowErrors).
                               IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = 'Error') THEN DO:
                                   IF  VALID-HANDLE(h-acomp) THEN
                                       RUN pi-finalizar IN h-acomp.

                                  RUN finalizaHandles        IN THIS-PROCEDURE.
                                  RUN exibeRowErrors         IN THIS-PROCEDURE.
                                  ASSIGN l-erro = YES.
                                  UNDO cria-nf, LEAVE cria-nf.
                               END.
                            END.

                            if l-aloca-estoque  and
                               item.baixa-estoq and
                               item.tipo-contr <> 4 then do:

                                /*Alocaá∆o por lote*/
                                IF item.tipo-con-est = 3 THEN DO:
                                    IF NOT CAN-FIND (FIRST int-saldo-aloc-lote
                                                     WHERE int-saldo-aloc-lote.nr-pedido = it-ped-fiscal.nr-pedido
                                                       AND int-saldo-aloc-lote.it-codigo = it-ped-fiscal.it-codigo
                                                       AND int-saldo-aloc-lote.seq       = it-ped-fiscal.seq) THEN DO:
    
                                       MESSAGE "Alocaá∆o de estoque n∆o encontrada!!! " skip
                                               it-ped-fiscal.nr-pedido         skip
                                               it-ped-fiscal.it-codigo         skip
                                               it-ped-fiscal.seq        view-as alert-box.
                                       ASSIGN l-erro = YES.
                                       UNDO cria-nf, LEAVE cria-nf.
                                    END.
    
                                    FOR EACH wt-fat-ser-lote
                                       WHERE wt-fat-ser-lote.seq-wt-docto    = iSeqWtDocto
                                         AND wt-fat-ser-lote.seq-wt-it-docto = iSeqWtItDocto exclusive-lock:
                                        DELETE wt-fat-ser-lote.
                                    END.
    
                                    FOR EACH int-saldo-aloc-lote NO-LOCK
                                       WHERE int-saldo-aloc-lote.nr-pedido = it-ped-fiscal.nr-pedido
                                         AND int-saldo-aloc-lote.it-codigo = it-ped-fiscal.it-codigo
                                         AND int-saldo-aloc-lote.seq       = it-ped-fiscal.seq:
    
                                       FIND FIRST saldo-estoq NO-LOCK
                                            WHERE saldo-estoq.it-codigo   = int-saldo-aloc-lote.it-codigo
                                              AND saldo-estoq.cod-estabel = ped-fiscal.cod-estabel
                                              AND saldo-estoq.cod-localiz = int-saldo-aloc-lote.cod-localiz
                                              AND saldo-estoq.cod-depos   = int-saldo-aloc-lote.cod-depos
                                              AND saldo-estoq.lote        = int-saldo-aloc-lote.lote NO-ERROR.
    
                                       IF NOT AVAIL saldo-estoq THEN DO:
                                           message "Alocaá∆o de estoque n∆o encontrada. " skip
                                                    int-saldo-aloc-lote.nr-pedido          skip
                                                    int-saldo-aloc-lote.it-codigo          skip
                                                    int-saldo-aloc-lote.seq        view-as alert-box.
                                           ASSIGN l-erro = YES.
                                           UNDO cria-nf, LEAVE cria-nf.
                                       END.
    
                                       CREATE wt-fat-ser-lote.
                                       ASSIGN wt-fat-ser-lote.seq-wt-docto    = iSeqWtDocto
                                              wt-fat-ser-lote.seq-wt-it-docto = iSeqWtItDocto
                                              wt-fat-ser-lote.it-codigo       = int-saldo-aloc-lote.it-codigo
                                              wt-fat-ser-lote.cod-depos       = int-saldo-aloc-lote.cod-depos
                                              wt-fat-ser-lote.cod-localiz     = int-saldo-aloc-lote.cod-localiz
                                              wt-fat-ser-lote.lote            = int-saldo-aloc-lote.lote
                                              wt-fat-ser-lote.dt-vali-lote    = saldo-estoq.dt-vali-lote
                                              wt-fat-ser-lote.char-1          = ""
                                              wt-fat-ser-lote.quantidade[1]   = int-saldo-aloc-lote.qtidade-atu
                                              wt-fat-ser-lote.log-1           = YES.
    
                                       FIND FIRST wt-fat-ser-lote
                                            WHERE wt-fat-ser-lote.seq-wt-docto    = iSeqWtDocto
                                              AND wt-fat-ser-lote.seq-wt-it-docto = iSeqWtItDocto
                                              AND wt-fat-ser-lote.it-codigo       = it-ped-fiscal.it-codigo
                                              AND wt-fat-ser-lote.cod-depos       = it-ped-fiscal.cod-depos
                                              AND wt-fat-ser-lote.cod-localiz     = it-ped-fiscal.cod-localizacao
                                              AND wt-fat-ser-lote.lote            = int-saldo-aloc-lote.lote no-lock no-error.
                                       RELEASE wt-fat-ser-lote.                
                                    END.
                                END.
                                ELSE DO:
                                    find first saldo-estoq 
                                         where saldo-estoq.cod-estabel = ped-fiscal.cod-estabel
                                           and saldo-estoq.it-codigo   = it-ped-fiscal.it-codigo
                                           and saldo-estoq.cod-depos   = it-ped-fiscal.cod-depos
                                           and saldo-estoq.cod-localiz = it-ped-fiscal.cod-localizacao no-lock no-error.  
                                    if not avail saldo-estoq then do:
                                       message "Saldo Estoque nao encontrado " skip
                                                v_cod_estab_usuar skip
                                                saldo-estoq.it-codigo  skip
                                                saldo-estoq.cod-depos                         
                                                saldo-estoq.cod-localiz
                                               view-as alert-box.     
                                       ASSIGN l-erro = YES.
                                       UNDO cria-nf, LEAVE cria-nf.
                                    end.
    
                                    for each wt-fat-ser-lote
                                       where wt-fat-ser-lote.seq-wt-docto    = iSeqWtDocto
                                         and wt-fat-ser-lote.seq-wt-it-docto = iSeqWtItDocto exclusive-lock:
    
                                        delete wt-fat-ser-lote.
                                    end.
    
                                    create wt-fat-ser-lote.
                                    assign wt-fat-ser-lote.seq-wt-docto    = iSeqWtDocto
                                           wt-fat-ser-lote.seq-wt-it-docto = iSeqWtItDocto
                                           wt-fat-ser-lote.it-codigo       = it-ped-fiscal.it-codigo
                                           wt-fat-ser-lote.cod-depos       = it-ped-fiscal.cod-depos
                                           wt-fat-ser-lote.cod-localiz     = it-ped-fiscal.cod-localizacao
                                           wt-fat-ser-lote.dt-vali-lote    = saldo-estoq.dt-vali-lote
                                           wt-fat-ser-lote.char-1          = ""
                                           wt-fat-ser-lote.quantidade[1]   = it-ped-fiscal.qtde
                                           wt-fat-ser-lote.log-1           = yes.
                                    find first wt-fat-ser-lote
                                         where wt-fat-ser-lote.seq-wt-docto    = iSeqWtDocto
                                          and  wt-fat-ser-lote.seq-wt-it-docto = iSeqWtItDocto
                                          and  wt-fat-ser-lote.it-codigo       = it-ped-fiscal.it-codigo
                                          and  wt-fat-ser-lote.cod-depos       = it-ped-fiscal.cod-depos
                                          AND  wt-fat-ser-lote.cod-localiz     = it-ped-fiscal.cod-localizacao no-lock no-error.
                                    release wt-fat-ser-lote.
                                END.
                            end.
                        END. /* else do */
                    END.
                END. /* for each it-ped-fiscal*/
                 IF AVAIL emitente
                    AND emitente.contrib-icms = YES  
                    AND wt-docto.nat-operacao BEGINS "6" THEN DO:
                    FOR EACH wt-it-docto
                        WHERE wt-it-docto.seq-wt-docto = iseqwtdocto no-LOCK,
                        FIRST ITEM
                        WHERE ITEM.it-codigo = wt-it-docto.it-codigo NO-LOCK:
                        IF (ITEM.codigo-orig = 1
                           OR  ITEM.codigo-orig = 2
                           OR  ITEM.codigo-orig = 3
                           OR  ITEM.codigo-orig = 8) THEN DO:

                           FOR EACH wt-it-imposto OF wt-it-docto NO-LOCK
                               WHERE wt-it-imposto.aliquota-icm <> 4:

                              CREATE RowErrors.
                              ASSIGN rowerrors.errornumber = 9999
                                     rowerrors.errortype   = "EMS"
                                     rowerrors.ERRORsubtype = "ERROR"
                                     rowerrors.errordescription = "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo
                                     rowerrors.errorhelp = "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo.
                           END.
                       END.
                    END.

                   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = 'Error') THEN DO:
                       IF  VALID-HANDLE(h-acomp) THEN
                           RUN pi-finalizar IN h-acomp.

                      RUN finalizaHandles        IN THIS-PROCEDURE.
                      RUN exibeRowErrors         IN THIS-PROCEDURE.
                      ASSIGN l-erro = YES.
                      UNDO cria-nf, LEAVE cria-nf.
                   END.

                END.
             /** Caso utilizado o botao "Ger It" do ESFTP012 para criaáao dos itens. 
                    Logica abaixo criaá∆o da 'Wt-it-docto' conforme bot∆o "Ger It" do FT4003. **/
                IF CAN-FIND (FIRST tt-itens-devol) THEN DO:

                    RUN emptyRowErrors IN h-bodi317in.
                    RUN geraWtItDoctoPartindoDoTtItensDevol IN h-bodi317sd(INPUT  iSeqWtDocto,
                                                                           INPUT  TABLE tt-itens-devol,
                                                                           OUTPUT l-proc-ok-aux).
                    IF NOT l-proc-ok-aux THEN DO:
                       RUN devolveErrosBodi317sd IN h-bodi317sd (OUTPUT ultprocesso, OUTPUT TABLE RowErrors).
                       IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = 'Error') THEN DO:
                           IF  VALID-HANDLE(h-acomp) THEN
                               RUN pi-finalizar IN h-acomp.

                          RUN finalizaHandles        IN THIS-PROCEDURE.
                          RUN exibeRowErrors         IN THIS-PROCEDURE.
                          ASSIGN l-erro = YES.
                          UNDO cria-nf, LEAVE cria-nf.
                       END.
                    END.
                    ELSE DO:
                        RUN dibo/bodi515.p PERSISTENT SET h-bodi515.
                        RUN openQueryStatic IN h-bodi515 (INPUT "Main":U).
                        RUN inbo/boin368.p PERSISTENT SET h_boin368.
                        RUN inbo/boin176.p PERSISTENT SET h_boin176.

                        FOR EACH tt-itens-devol
                            BREAK BY tt-itens-devol.serie-docto
                                  BY tt-itens-devol.nro-docto
                                  BY tt-itens-devol.cod-emitente:

                            IF  VALID-HANDLE(h_boin368) AND 
                                VALID-HANDLE(h_boin176) AND 
                                tt-itens-devol.selecionado THEN DO:

                                RUN openQueryStatic IN h_boin176 ('main').
                                RUN GoToKey IN h_boin176 (INPUT tt-itens-devol.serie-docto,
                                                          INPUT tt-itens-devol.nro-docto,
                                                          INPUT tt-itens-devol.cod-emitente,
                                                          INPUT tt-itens-devol.nat-operacao,
                                                          INPUT tt-itens-devol.sequencia).

                                RUN getLogField IN h_boin176 (INPUT "log-1",
                                                              OUTPUT l-fifo) .

                                IF l-fifo THEN DO:
                                    RUN OpenQueryStatic IN h_boin368 ('Main').
                                    RUN SetConstraintOfItemDocEst IN h_boin368 (INPUT tt-itens-devol.cod-emitente,
                                                                                INPUT tt-itens-devol.serie-docto,
                                                                                INPUT tt-itens-devol.nro-docto,
                                                                                INPUT tt-itens-devol.nat-operacao,
                                                                                INPUT tt-itens-devol.sequencia).
                                    RUN EmptyQtdADevolver     IN h_boin368.
                                    RUN AtualizaRatOrdensFifo IN h_boin368 (INPUT tt-itens-devol.qt-a-devolver-inf).
                                END.
                            END.


                            IF LAST-OF(tt-itens-devol.cod-emitente) THEN DO:
                                RUN goToKeyDoctoRef IN h-bodi515 (INPUT wt-docto.cod-estabel,
                                                                  INPUT wt-docto.serie,
                                                                  INPUT STRING(wt-docto.seq-wt-docto),
                                                                  INPUT wt-docto.cod-emitente,
                                                                  INPUT wt-docto.nat-operacao,
                                                                  INPUT 3,
                                                                  INPUT tt-itens-devol.serie-docto,
                                                                  INPUT tt-itens-devol.nro-docto,
                                                                  INPUT tt-itens-devol.cod-emitente).

                                IF RETURN-VALUE = "NOK":U THEN DO:
                                    EMPTY TEMP-TABLE tt-nota-fisc-adc.

                                    CREATE tt-nota-fisc-adc.
                                    ASSIGN tt-nota-fisc-adc.cod-estab                = wt-docto.cod-estabel
                                           tt-nota-fisc-adc.cod-serie                = wt-docto.serie     
                                           tt-nota-fisc-adc.cod-nota-fisc            = STRING(wt-docto.seq-wt-docto)
                                           tt-nota-fisc-adc.cdn-emitente             = wt-docto.cod-emitente
                                           tt-nota-fisc-adc.cod-natur-operac         = wt-docto.nat-operacao 
                                           tt-nota-fisc-adc.idi-tip-dado             = 3
                                           tt-nota-fisc-adc.cod-docto-referado       = tt-itens-devol.nro-docto
                                           tt-nota-fisc-adc.cod-ser-docto-referado   = tt-itens-devol.serie-docto
                                           tt-nota-fisc-adc.cdn-emit-docto-referado  = tt-itens-devol.cod-emitente.

                                    FIND FIRST natur-oper NO-LOCK
                                         WHERE natur-oper.nat-operacao = wt-docto.nat-operacao NO-ERROR.

                                    /*RUN pi-buscaModelo IN h-bodi515 (INPUT "FT4011",
                                                                     INPUT wt-docto.cod-estabel,
                                                                     INPUT wt-docto.serie,
                                                                     INPUT wt-docto.nr-nota,
                                                                     INPUT wt-docto.cod-emitente,
                                                                     INPUT wt-docto.nat-operacao,
                                                                     OUTPUT c-modelo).*/

                                    FIND FIRST doc-fiscal NO-LOCK
                                         WHERE doc-fiscal.serie        = tt-itens-devol.serie-docto  
                                           AND doc-fiscal.nr-doc-fis   = tt-itens-devol.nro-docto    
                                           AND doc-fiscal.cod-emitente = tt-itens-devol.cod-emitente 
                                           AND doc-fiscal.nat-operacao = tt-itens-devol.nat-operacao NO-ERROR.

                                    ASSIGN tt-nota-fisc-adc.cod-model-docto-referado  = IF AVAIL natur-oper THEN natur-oper.cod-model-nf-eletro ELSE ""
                                           tt-nota-fisc-adc.idi-tip-docto-referado    = 1
                                           OVERLAY(tt-nota-fisc-adc.cod-livre-2,1,60) = IF AVAIL doc-fiscal THEN doc-fiscal.cod-chave-aces-nf-eletro ELSE "".

                                    FOR FIRST docum-est
                                        WHERE docum-est.serie-docto  = tt-itens-devol.serie-docto
                                          AND docum-est.nro-docto    = tt-itens-devol.nro-docto
                                          AND docum-est.cod-emitente = tt-itens-devol.cod-emitente 
                                          AND docum-est.nat-operacao = tt-itens-devol.nat-operacao NO-LOCK:

                                        ASSIGN tt-nota-fisc-adc.dat-docto-referado = docum-est.dt-emissao
                                               ttWt-docto.observ-nota = ttWt-docto.observ-nota + " Devoluá∆o ref NF: " + docum-est.nro-docto + " de " + STRING(docum-est.dt-emis,"99/99/9999") + ". Chave de acesso: " + docum-est.cod-chave-aces-nf-eletro.

                                        RUN setRecord    IN h-bodi317 (TABLE ttWt-docto).
                                        RUN updateRecord IN h-bodi317.
                                        IF RETURN-VALUE = 'NOK' THEN DO:
                                            RUN getRowErrors IN h-bodi317 (OUTPUT TABLE RowErrors).
                                            IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = 'Error') THEN DO:
                                                IF  VALID-HANDLE(h-acomp) THEN
                                                    RUN pi-finalizar IN h-acomp.
                            
                                                RUN finalizaHandles        IN THIS-PROCEDURE.
                                                RUN exibeRowErrors         IN THIS-PROCEDURE.
                                                ASSIGN l-erro = YES.
                                                UNDO cria-nf, LEAVE cria-nf .
                                            END.
                                        END.

                                        IF SUBSTRING(tt-nota-fisc-adc.cod-livre-2,1,60) = "" THEN
                                            OVERLAY(tt-nota-fisc-adc.cod-livre-2,1,60) = docum-est.cod-chave-aces-nf-eletro. 

                                        FOR FIRST natur-oper
                                            WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK:
                                            ASSIGN tt-nota-fisc-adc.idi-tip-emit-referado  = IF natur-oper.int-1 = 1 THEN 1 ELSE 2.
                                        END.
                                    END.

                                    FOR FIRST nota-fiscal NO-LOCK
                                        WHERE nota-fiscal.serie        = tt-itens-devol.serie-docto 
                                          AND nota-fiscal.nr-nota-fis  = tt-itens-devol.nro-docto   
                                          AND nota-fiscal.cod-emitente = tt-itens-devol.cod-emitente
                                          AND nota-fiscal.nat-operacao = tt-itens-devol.nat-operacao:

                                        IF SUBSTRING(tt-nota-fisc-adc.cod-livre-2,1,60) = "" THEN
                                            OVERLAY(tt-nota-fisc-adc.cod-livre-2,1,60) = nota-fiscal.cod-chave-aces-nf-eletro.
                                    END.

                                    RUN setRecord      IN h-bodi515 (INPUT TABLE tt-nota-fisc-adc).
                                    RUN emptyRowErrors IN h-bodi515.
                                    IF RETURN-VALUE = "OK":U THEN
                                    RUN createRecord   IN h-bodi515.
                                    RUN getRowErrors   IN h-bodi515 (OUTPUT TABLE RowErrors).

                                    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = 'Error') THEN DO:
                                        IF  VALID-HANDLE(h-acomp) THEN
                                            RUN pi-finalizar IN h-acomp.

                                        RUN finalizaHandles        IN THIS-PROCEDURE.
                                        RUN exibeRowErrors         IN THIS-PROCEDURE.

                                        IF  VALID-HANDLE(h-bodi515) THEN DO:
                                            RUN destroy IN h-bodi515.
                                            DELETE OBJECT h-bodi515 NO-ERROR.
                                        END.

                                        IF  VALID-HANDLE(h_boin368) THEN DO:
                                            RUN destroy IN h_boin368.
                                            DELETE OBJECT h_boin368 NO-ERROR.
                                        END.

                                        IF  VALID-HANDLE(h_boin176) THEN DO:
                                            RUN destroy IN h_boin176.
                                            DELETE OBJECT h_boin176 NO-ERROR.
                                        END.
                                        ASSIGN l-erro = YES.
                                        UNDO cria-nf, LEAVE cria-nf.
                                    END.
                                END.
                            END.
                        END.

                        FOR EACH it-ped-fiscal OF ped-fiscal NO-LOCK
                            BY it-ped-fiscal.seq:

                            FOR EACH wt-it-docto
                                WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto
                                  AND wt-it-docto.it-codigo = it-ped-fiscal.it-codigo NO-LOCK:
                            
                                /*Alocaá∆o por lote*/
                                IF item.tipo-con-est = 3 THEN DO:
                                    IF NOT CAN-FIND (FIRST int-saldo-aloc-lote
                                                     WHERE int-saldo-aloc-lote.nr-pedido = it-ped-fiscal.nr-pedido
                                                       AND int-saldo-aloc-lote.it-codigo = it-ped-fiscal.it-codigo
                                                       AND int-saldo-aloc-lote.seq       = it-ped-fiscal.seq) THEN DO:
    
                                       MESSAGE "Alocaá∆o de estoque n∆o encontrada!" skip
                                               it-ped-fiscal.nr-pedido         skip
                                               it-ped-fiscal.it-codigo         skip
                                               it-ped-fiscal.seq        view-as alert-box.
                                       ASSIGN l-erro = YES.
                                       UNDO cria-nf, LEAVE cria-nf.
                                    END.
    
                                    FOR EACH wt-fat-ser-lote
                                       WHERE wt-fat-ser-lote.seq-wt-docto    = wt-it-docto.seq-wt-docto
                                         AND wt-fat-ser-lote.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto exclusive-lock:

                                        DELETE wt-fat-ser-lote.
                                    END.
    
                                    FOR EACH int-saldo-aloc-lote NO-LOCK
                                       WHERE int-saldo-aloc-lote.nr-pedido = it-ped-fiscal.nr-pedido
                                         AND int-saldo-aloc-lote.it-codigo = it-ped-fiscal.it-codigo
                                         AND int-saldo-aloc-lote.seq       = it-ped-fiscal.seq:
    
                                       FIND FIRST saldo-estoq NO-LOCK
                                            WHERE saldo-estoq.it-codigo   = int-saldo-aloc-lote.it-codigo
                                              AND saldo-estoq.cod-estabel = ped-fiscal.cod-estabel
                                              AND saldo-estoq.cod-localiz = int-saldo-aloc-lote.cod-localiz
                                              AND saldo-estoq.cod-depos   = int-saldo-aloc-lote.cod-depos
                                              AND saldo-estoq.lote        = int-saldo-aloc-lote.lote NO-ERROR.
    
                                       IF NOT AVAIL saldo-estoq THEN DO:
                                           message "Alocaá∆o de estoque n∆o encontrada!! " skip
                                                    int-saldo-aloc-lote.nr-pedido          skip
                                                    int-saldo-aloc-lote.it-codigo          skip
                                                    int-saldo-aloc-lote.seq        view-as alert-box.
                                           ASSIGN l-erro = YES.
                                           UNDO cria-nf, LEAVE cria-nf.
                                       END.
    
                                       CREATE wt-fat-ser-lote.
                                       ASSIGN wt-fat-ser-lote.seq-wt-docto    = wt-docto.seq-wt-docto
                                              wt-fat-ser-lote.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
                                              wt-fat-ser-lote.it-codigo       = int-saldo-aloc-lote.it-codigo
                                              wt-fat-ser-lote.cod-depos       = int-saldo-aloc-lote.cod-depos
                                              wt-fat-ser-lote.cod-localiz     = int-saldo-aloc-lote.cod-localiz
                                              wt-fat-ser-lote.lote            = int-saldo-aloc-lote.lote
                                              wt-fat-ser-lote.dt-vali-lote    = saldo-estoq.dt-vali-lote
                                              wt-fat-ser-lote.char-1          = ""
                                              wt-fat-ser-lote.quantidade[1]   = int-saldo-aloc-lote.qtidade-atu
                                              wt-fat-ser-lote.log-1           = YES.
    
                                       FIND FIRST wt-fat-ser-lote
                                            WHERE wt-fat-ser-lote.seq-wt-docto    = wt-docto.seq-wt-docto 
                                              AND wt-fat-ser-lote.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
                                              AND wt-fat-ser-lote.it-codigo       = it-ped-fiscal.it-codigo
                                              AND wt-fat-ser-lote.cod-depos       = it-ped-fiscal.cod-depos
                                              AND wt-fat-ser-lote.cod-localiz     = it-ped-fiscal.cod-localizacao
                                              AND wt-fat-ser-lote.lote            = int-saldo-aloc-lote.lote no-lock no-error.
                                       RELEASE wt-fat-ser-lote.                
                                    END.
                                END.
                                ELSE DO:
                                    find first saldo-estoq 
                                         where saldo-estoq.cod-estabel = ped-fiscal.cod-estabel
                                           and saldo-estoq.it-codigo   = it-ped-fiscal.it-codigo
                                           and saldo-estoq.cod-depos   = it-ped-fiscal.cod-depos
                                           and saldo-estoq.cod-localiz = it-ped-fiscal.cod-localizacao no-lock no-error.  
                                    if not avail saldo-estoq then do:
                                       message "Saldo Estoque nao encontrado " skip
                                                v_cod_estab_usuar skip
                                                saldo-estoq.it-codigo  skip
                                                saldo-estoq.cod-depos                         
                                                saldo-estoq.cod-localiz
                                               view-as alert-box.     
                                       ASSIGN l-erro = YES.
                                       UNDO cria-nf, LEAVE cria-nf.
                                    end.
    
                                    for each wt-fat-ser-lote
                                       where wt-fat-ser-lote.seq-wt-docto    = wt-docto.seq-wt-docto
                                         and wt-fat-ser-lote.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto exclusive-lock:
    
                                        delete wt-fat-ser-lote.
                                    end.
    
                                    create wt-fat-ser-lote.
                                    assign wt-fat-ser-lote.seq-wt-docto    = wt-docto.seq-wt-docto
                                           wt-fat-ser-lote.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
                                           wt-fat-ser-lote.it-codigo       = it-ped-fiscal.it-codigo
                                           wt-fat-ser-lote.cod-depos       = it-ped-fiscal.cod-depos
                                           wt-fat-ser-lote.cod-localiz     = it-ped-fiscal.cod-localizacao
                                           wt-fat-ser-lote.dt-vali-lote    = saldo-estoq.dt-vali-lote
                                           wt-fat-ser-lote.char-1          = ""
                                           wt-fat-ser-lote.quantidade[1]   = it-ped-fiscal.qtde
                                           wt-fat-ser-lote.log-1           = yes.
                                    find first wt-fat-ser-lote
                                         where wt-fat-ser-lote.seq-wt-docto    = wt-docto.seq-wt-docto      
                                          and  wt-fat-ser-lote.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
                                          and  wt-fat-ser-lote.it-codigo       = it-ped-fiscal.it-codigo
                                          and  wt-fat-ser-lote.cod-depos       = it-ped-fiscal.cod-depos
                                          AND  wt-fat-ser-lote.cod-localiz     = it-ped-fiscal.cod-localizacao no-lock no-error.
                                    release wt-fat-ser-lote.
                                END.
                             END.
                        END.

                        IF  VALID-HANDLE(h-bodi515) THEN DO:
                            RUN destroy IN h-bodi515.
                            DELETE OBJECT h-bodi515 NO-ERROR.
                        END.

                        IF  VALID-HANDLE(h_boin368) THEN DO:
                            RUN destroy IN h_boin368.
                            DELETE OBJECT h_boin368 NO-ERROR.
                        END.

                        IF  VALID-HANDLE(h_boin176) THEN DO:
                            RUN destroy IN h_boin176.
                            DELETE OBJECT h_boin176 NO-ERROR.
                        END.

                        FOR EACH tt-itens-devol:
                            DELETE tt-itens-devol.
                        END.
                    END.
                END.
            END. /*naturezas validas*/

            FIND CURRENT ped-fiscal EXCLUSIVE-LOCK.
            IF NOT AVAIL ped-fiscal THEN DO:
               message "Registro Alocado Por Outro Usuario, ou indisponivel" view-as alert-box.     
               undo, return.
            END.
            ASSIGN ped-fiscal.situacao     = 3
                   ped-fiscal.seq-wt-docto = wt-docto.seq-wt-docto.
            FIND CURRENT ped-fiscal NO-LOCK.

        END. /*transacao*/

        RUN finalizaHandles        IN THIS-PROCEDURE.

        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.

        IF l-erro THEN DO:
            ASSIGN p-ok = NO.
            RETURN "NOK".
        END.
        ELSE DO:
            ASSIGN p-ok = YES.
            RETURN "OK".
        END.

   END.

   RETURN 'OK'.
