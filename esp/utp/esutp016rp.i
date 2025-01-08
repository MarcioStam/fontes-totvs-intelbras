    IF FIRST-OF(tarifador.ramal) THEN DO:
        
        run pi-acompanhar in h-acomp (INPUT "Telefonia: " + tarifador.ramal).
        CREATE tt-sintetico.
        ASSIGN tt-sintetico.ramal = tarifador.ramal.

        FIND FIRST equipamentos NO-LOCK
             WHERE equipamentos.equipamento = tarifador.ramal NO-ERROR.
        IF NOT AVAIL equipamentos  THEN
            FIND FIRST equipamentos NO-LOCK
                 WHERE equipamentos.equipamento = "483281" + tarifador.ramal NO-ERROR.
        IF AVAIL equipamentos THEN DO:
            ASSIGN tt-sintetico.nome = equipamentos.descricao.

            FOR EACH cc-equipamentos OF equipamentos NO-LOCK:
                run prgint\utb\utb742za.py persistent set h_api_ccusto.
    
                EMPTY TEMP-TABLE tt_log_erro.
                run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,       /* EMPRESA EMS2 */
                                                           input  "",                        /* CODIGO DO PLANO CCUSTO */
                                                           input  cc-equipamentos.cc-codigo, /* CCUSTO */
                                                           input  today,                     /* DATA DE TRANSACAO */
                                                           output v_des_titulo_ccusto,       /* DESCRICAO DO CCUSTO */
                                                           output table tt_log_erro).        /* ERROS */
                delete object h_api_ccusto.

                IF tt-sintetico.cc-codigo = "" THEN
                    ASSIGN tt-sintetico.cc-codigo = cc-equipamentos.cc-codigo + v_des_titulo_ccusto.
                ELSE 
                    ASSIGN tt-sintetico.cc-codigo = tt-sintetico.cc-codigo + "," + cc-equipamentos.cc-codigo + v_des_titulo_ccusto.
            END.
        END.
    END.

    IF tt-param.i-relat = 1 THEN DO:
        ASSIGN tt-sintetico.qtde        = tt-sintetico.qtde       + 1
               tt-sintetico.valor       = tt-sintetico.valor      + tarifador.valor.

        IF tarifador.avaliado THEN
            ASSIGN tt-sintetico.qtde-aval   = tt-sintetico.qtde-aval  + 1
                   tt-sintetico.valor-aval  = tt-sintetico.valor-aval + tarifador.valor.
        ELSE
            ASSIGN tt-sintetico.qtde-pend   = tt-sintetico.qtde-pend  + 1
                   tt-sintetico.valor-pend  = tt-sintetico.valor-pend + tarifador.valor.
    END.
    ELSE DO:
        CREATE tt-analitico.
        BUFFER-COPY tarifador TO tt-analitico.

        /*Ele marca valor da tabela sintetico no primeiro registro do ramal - ‚ obrigat¢rio fazer quebra por ramal*/
        ASSIGN tt-analitico.nome      = tt-sintetico.nome
               tt-analitico.cc-codigo = tt-sintetico.cc-codigo.
    END.
