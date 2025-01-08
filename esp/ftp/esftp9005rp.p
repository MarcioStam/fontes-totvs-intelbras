DEFINE VARIABLE h-bodi317sd             AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi317ef             AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi317in             AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi317pr             AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi317im1bra         AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi317va             AS HANDLE    NO-UNDO.
DEFINE VARIABLE i-seq-wt-docto          AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-seq-wt-it-docto       AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-proc-ok               AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lFirst                  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-linha                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ultimo-metodo-exec    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arquivo-saida         AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)"
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf       AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf    AS LOG 
    FIELD arquivo-importa  AS CHAR
    FIELD atualiza-nota    AS LOG.

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita      AS RAW.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{utp/ut-glob.i}
{method/dbotterr.i}

DEFINE TEMP-TABLE tt-erros LIKE RowErrors.
DEFINE TEMP-TABLE tt-wt-fat-ser-lote LIKE wt-fat-ser-lote.
    
DEFINE TEMP-TABLE tt-doc-gerado NO-UNDO
    FIELD seq-wt-docto AS INT.

DEFINE TEMP-TABLE tt-notas-geradas NO-UNDO
    FIELD rw-nota-fiscal AS   ROWID
    FIELD nr-nota        LIKE nota-fiscal.nr-nota-fis
    FIELD seq-wt-docto   LIKE wt-docto.seq-wt-docto.

DEFINE TEMP-TABLE tt-wt-docto NO-UNDO
    FIELD usuario         LIKE wt-docto.usuario           
    FIELD cod-estabel     LIKE nota-fiscal.cod-estabel    
    FIELD serie           LIKE nota-fiscal.serie 
    FIELD cod-emitente    LIKE emitente.cod-emitente
    FIELD nome-abrev      LIKE emitente.nome-abrev        
    FIELD dt-emis-nota    LIKE nota-fiscal.dt-emis-nota   
    FIELD nat-operacao    LIKE nota-fiscal.nat-operacao   
    FIELD cod-canal-venda LIKE nota-fiscal.cod-canal-venda
    FIELD no-ab-reppri    LIKE wt-docto.no-ab-reppri    
    FIELD cod-cond-pag    LIKE wt-docto.cod-cond-pag
    FIELD dt-prvenc       LIKE wt-docto.dt-prvenc
    FIELD cod-rota        LIKE wt-docto.cod-rota
    FIELD nome-transp     LIKE wt-docto.nome-transp
    FIELD contrato        AS CHAR
    FIELD observ-nota     LIKE wt-docto.observ-nota
    FIELD cidade          LIKE wt-docto.cidade
    FIELD estado          LIKE wt-docto.estado
    INDEX ch-wt-docto
          cod-estabel   
          serie
          cod-emitente.

DEFINE TEMP-TABLE tt-wt-it-docto NO-UNDO
    FIELD cod-estabel     LIKE nota-fiscal.cod-estabel    
    FIELD serie           LIKE nota-fiscal.serie 
    FIELD cod-emitente    LIKE emitente.cod-emitente
    FIELD nr-sequencia    LIKE ped-item.nr-sequencia
    FIELD it-codigo       LIKE ped-item.it-codigo   
    FIELD cod-refer       LIKE ped-item.cod-refer   
    FIELD nat-operacao    LIKE ped-item.nat-operacao
    FIELD quantidade      AS DEC
    FIELD vl-preori-ped   LIKE wt-it-docto.vl-preori-ped
    FIELD cod-depos       LIKE wt-fat-ser-lot.cod-depos
    INDEX ch-wt-it-docto
          cod-estabel   
          serie
          cod-emitente
          it-codigo
          nr-sequencia.

DEFINE BUFFER b-tt-wt-it-docto FOR tt-wt-it-docto.

IF tt-param.arquivo <> "" THEN
    ASSIGN c-arquivo-saida = tt-param.arquivo.
ELSE
    ASSIGN c-arquivo-saida = SESSION:TEMP-DIRECTORY + "LogImportacaoesftp9005.lst".

OUTPUT TO VALUE(c-arquivo-saida).

IF SEARCH(tt-param.arquivo-importa) = ? THEN DO:
    PUT "Arquivo de importaá∆o nao encontrado!!!".
    OUTPUT CLOSE.

    IF tt-param.destino = 3 THEN DO:
        RUN WinExec (INPUT "Notepad.exe":U + CHR(32) + c-arquivo-saida,
                     INPUT 1).
    END.

    RETURN "NOK".
END.

RUN dibo/bodi317sd.p PERSISTENT SET h-bodi317sd.
RUN dibo/bodi317ef.p PERSISTENT SET h-bodi317ef.
RUN dibo/bodi317in.p PERSISTENT SET h-bodi317in.
RUN inicializaBOS IN h-bodi317in(OUTPUT h-bodi317pr,
                                 OUTPUT h-bodi317sd,
                                 OUTPUT h-bodi317im1bra,
                                 OUTPUT h-bodi317va).

RUN pi-carrega-dados.

criaNota:
DO ON ERROR UNDO:
    
    FOR EACH tt-wt-docto:
    
        RUN inicializaAcompanhamento IN h-bodi317sd.   
    
        FIND FIRST ser-estab NO-LOCK 
             WHERE ser-estab.cod-estabel = tt-wt-docto.cod-estabel
               AND ser-estab.serie       = tt-wt-docto.serie NO-ERROR.
    
        RUN criaWtDocto IN h-bodi317sd(INPUT tt-wt-docto.usuario,
                                       INPUT tt-wt-docto.cod-estabel,
                                       INPUT tt-wt-docto.serie,
                                       INPUT "1",  /*nr-nota-fis*/
                                       INPUT tt-wt-docto.nome-abrev,
                                       INPUT ?,    /*nr-pedcli*/
                                       INPUT 1,    /*ind-tip-nota*/
                                       INPUT 2003, /*nr-resumo*/
                                       INPUT ser-estab.dt-ult-fat,
                                       INPUT 0,    /*nr-embarque*/
                                       INPUT tt-wt-docto.nat-operacao,
                                       INPUT tt-wt-docto.cod-canal-venda,
                                       OUTPUT i-seq-wt-docto,
                                       OUTPUT l-proc-ok).

        IF l-proc-ok THEN DO:
            CREATE tt-doc-gerado.
            ASSIGN tt-doc-gerado.seq-wt-docto = i-seq-wt-docto.
        END.
    
        RUN devolveErrosbodi317sd  IN h-bodi317sd (OUTPUT c-ultimo-metodo-exec,
                                                   OUTPUT TABLE RowErrors).
        RUN emptyRowErrors         IN h-bodi317sd.
    
        FOR EACH RowErrors
            WHERE RowErrors.ErrorSubType = "ERROR":
            CREATE tt-erros.
            BUFFER-COPY RowErrors TO tt-erros.
        END.
        
        FOR FIRST wt-docto EXCLUSIVE-LOCK 
             WHERE wt-docto.seq-wt-docto = i-seq-wt-docto:
    
            ASSIGN wt-docto.no-ab-reppri = tt-wt-docto.no-ab-reppri
                   wt-docto.cod-cond-pag = tt-wt-docto.cod-cond-pag
                   wt-docto.dt-prvenc    = tt-wt-docto.dt-prvenc
                   wt-docto.cod-rota     = tt-wt-docto.cod-rota
                   wt-docto.nome-transp  = tt-wt-docto.nome-transp
                   wt-docto.observ-nota  = tt-wt-docto.observ-nota
                   wt-docto.cidade       = tt-wt-docto.cidade
                   wt-docto.estado       = tt-wt-docto.estado
                   wt-docto.ind-lib-nota = YES
                   wt-docto.nr-prog      = 4003.
        END.

        FIND FIRST usuar-nat-operacao NO-LOCK
            WHERE usuar-nat-operacao.cod-usuario = v_cod_usuar_corren
              AND wt-docto.nat-operacao BEGINS usuar-nat-operacao.nat-operacao NO-ERROR.
        IF NOT AVAIL usuar-nat-operacao THEN DO:
            FIND FIRST usuar-nat-operacao NO-LOCK
                WHERE usuar-nat-operacao.cod-usuario = v_cod_usuar_corren
                  AND usuar-nat-operacao.nat-operacao = "*" NO-ERROR.
            IF NOT AVAIL usuar-nat-operacao THEN DO:
                 CREATE tt-erros.
                 ASSIGN tt-erros.ErrorDescription = "Usu†rio: " + v_cod_usuar_corren + " sem permiss∆o para utilizar a natureza de operaá∆o: " + wt-docto.nat-operacao.
            END.
        END.

        foreach:
        FOR EACH tt-wt-it-docto 
            WHERE tt-wt-it-docto.cod-estabel = tt-wt-docto.cod-estabel 
              AND tt-wt-it-docto.serie = tt-wt-docto.serie      
              AND tt-wt-it-docto.cod-emitente = tt-wt-docto.cod-emitente:

            FIND FIRST item  NO-LOCK 
                WHERE ITEM.it-codigo = tt-wt-it-docto.it-codigo NO-ERROR.
            
            IF AVAIL ITEM 
                AND item.baixa-estoq 
                AND item.tipo-contr <> 4 THEN DO:

                FIND FIRST saldo-estoq NO-LOCK
                     WHERE saldo-estoq.it-codigo   = tt-wt-it-docto.it-codigo 
                       AND saldo-estoq.cod-estabel = tt-wt-docto.cod-estabel
                       AND saldo-estoq.cod-depos   = tt-wt-it-docto.cod-depos
                       AND saldo-estoq.cod-localiz = "" NO-ERROR.
                IF (saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-ped - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-alocada) < tt-wt-it-docto.quantidade THEN DO:
                    CREATE tt-erros.
                    ASSIGN tt-erros.ErrorDescription = "Quantidade a ser Alocada : " + string(tt-wt-it-docto.quantidade) +
                                                       " Maior que Quantidade disponivel: " +
                                                       STRING(saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-ped - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-alocada) +
                                                       " do item: " + tt-wt-it-docto.it-codigo + " Deposito: " + tt-wt-it-docto.cod-depos.
                    RUN finalizaAcompanhamento IN h-bodi317sd. 
                    NEXT foreach.
                END.
            END.
            
            RUN criaWtItDocto IN h-bodi317sd (INPUT  ?,                            /* rowid de origem      */
                                              INPUT  "",                           /* tabela de origem     */
                                              INPUT  tt-wt-it-docto.nr-sequencia,  /* n£mero da sequencia  */
                                              INPUT  tt-wt-it-docto.it-codigo,     /* c¢digo do item       */
                                              INPUT  "",                           /* c¢digo da referància */
                                              INPUT  tt-wt-it-docto.nat-operacao,  /* natureza de operacao */
                                              OUTPUT i-seq-wt-it-docto,            /* chave do reg criado  */
                                              OUTPUT l-proc-ok).                   /* tratamento de erro   */
    
            RUN finalizaAcompanhamento IN h-bodi317sd. 
            RUN devolveErrosbodi317sd  IN h-bodi317sd (OUTPUT c-ultimo-metodo-exec,
                                                       OUTPUT TABLE RowErrors).
            RUN emptyRowErrors         IN h-bodi317sd.
        
            FOR EACH RowErrors
                WHERE RowErrors.ErrorSubType = "ERROR":
                CREATE tt-erros.
                BUFFER-COPY RowErrors TO tt-erros.
            END.
    
            FOR FIRST wt-it-docto EXCLUSIVE-LOCK
                WHERE wt-it-docto.seq-wt-docto    = wt-docto.seq-wt-docto
                  AND wt-it-docto.seq-wt-it-docto = i-seq-wt-it-docto:
    
                ASSIGN wt-it-docto.quantidade    = tt-wt-it-docto.quantidade
                       wt-it-docto.quantidade[1] = tt-wt-it-docto.quantidade
                       wt-it-docto.vl-preori-ped = tt-wt-it-docto.vl-preori-ped
                       wt-it-docto.calcula       = yes.
            END.
    
            RUN localizaWtDocto       IN h-bodi317pr(INPUT  wt-docto.seq-wt-docto,
                                                     OUTPUT l-proc-ok).
    
            RUN localizaWtItDocto     IN h-bodi317pr(INPUT  wt-docto.seq-wt-docto,
                                                     INPUT  wt-it-docto.seq-wt-it-docto,
                                                     OUTPUT l-proc-ok).
        
            RUN localizaWtItImposto   IN h-bodi317pr(INPUT  wt-docto.seq-wt-docto,
                                                     INPUT  wt-it-docto.seq-wt-it-docto,
                                                     OUTPUT l-proc-ok).
            RUN atualizaDadosItemNota IN h-bodi317pr(OUTPUT l-proc-ok).
            
            RUN devolveErrosbodi317pr IN h-bodi317pr(OUTPUT c-ultimo-metodo-exec,
                                                     OUTPUT TABLE RowErrors).
            RUN emptyRowErrors        IN h-bodi317pr.

            IF  wt-it-docto.peso-liq-it < 0.0001 THEN DO:
                CREATE tt-erros.
                ASSIGN tt-erros.ErrorDescription = "Peso liquido deve ser maior ou igual a 0.0001".
            END.

            IF  wt-it-docto.peso-liq-it < 0.0001 THEN DO:
                CREATE tt-erros.
                ASSIGN tt-erros.ErrorDescription = "Peso liquido deve ser maior ou igual a 0.0001".
            END.

            IF  wt-it-docto.peso-bruto-it  < 0.0001 THEN DO:
                CREATE tt-erros.
                ASSIGN tt-erros.ErrorDescription = "Peso bruto deve ser maior ou igual a 0.0001".
            END.
           
            FOR EACH RowErrors
                WHERE RowErrors.ErrorSubType = "ERROR":
                CREATE tt-erros.
                BUFFER-COPY RowErrors TO tt-erros.
            END.
            
            FIND FIRST wt-fat-ser-lote EXCLUSIVE-LOCK
                WHERE wt-fat-ser-lote.seq-wt-docto    = wt-docto.seq-wt-docto
                  AND wt-fat-ser-lote.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto NO-ERROR.
    
            IF AVAIL wt-fat-ser-lote THEN DO:
                BUFFER-COPY wt-fat-ser-lote TO tt-wt-fat-ser-lote.
                DELETE wt-fat-ser-lote.
    
                RUN validaCamposWtFatSerLote IN h-bodi317va(INPUT  wt-it-docto.seq-wt-docto,
                                                            INPUT  wt-it-docto.seq-wt-it-docto,
                                                            INPUT  wt-it-docto.it-codigo,
                                                            INPUT  wt-it-docto.quantidade[1],
                                                            INPUT  tt-wt-it-docto.cod-depos,
                                                            INPUT  "",
                                                            INPUT  tt-wt-fat-ser-lote.lote,
                                                            INPUT  tt-wt-fat-ser-lote.dt-vali-lote,
                                                            INPUT  tt-wt-fat-ser-lote.quantidade[1],
                                                            INPUT  YES, /* Yes: Inc. / No: Alt. */
                                                            OUTPUT l-proc-ok).
    
                RUN devolveErrosbodi317va IN h-bodi317va(OUTPUT c-ultimo-metodo-exec,
                                                         OUTPUT TABLE RowErrors).
    
                RUN emptyRowErrors        IN h-bodi317va.
           
                FOR EACH RowErrors
                    WHERE RowErrors.ErrorSubType = "ERROR":
                    CREATE tt-erros.
                    BUFFER-COPY RowErrors TO tt-erros.
                END.       
                
                RUN criaAlteraWtFatSerLote IN h-bodi317sd (INPUT  YES, /* Yes: Inc. / No: Alt. */
                                                           INPUT  wt-it-docto.seq-wt-docto,
                                                           INPUT  wt-it-docto.seq-wt-it-docto,
                                                           INPUT  wt-it-docto.it-codigo,
                                                           INPUT  tt-wt-it-docto.cod-depos,
                                                           INPUT  "",
                                                           INPUT  tt-wt-fat-ser-lote.lote,
                                                           INPUT  tt-wt-fat-ser-lote.quantidade[1],
                                                           INPUT  tt-wt-fat-ser-lote.quantidade[1],
                                                           INPUT  tt-wt-fat-ser-lote.dt-vali-lote,
                                                           OUTPUT l-proc-ok).

                RUN devolveErrosbodi317sd IN h-bodi317sd(OUTPUT c-ultimo-metodo-exec,
                                                         OUTPUT TABLE RowErrors).
    
                RUN emptyRowErrors        IN h-bodi317sd.
           
                FOR EACH RowErrors
                    WHERE RowErrors.ErrorSubType = "ERROR":
                    CREATE tt-erros.
                    BUFFER-COPY RowErrors TO tt-erros.
                END.
            END.
        END.
          
        RUN setaValidaExp         IN h-bodi317va(INPUT YES).
        RUN confirmaCalculo       IN h-bodi317pr(INPUT  wt-docto.seq-wt-docto,
                                                 OUTPUT l-proc-ok).
    
        RUN devolveErrosbodi317pr IN h-bodi317pr (OUTPUT c-ultimo-metodo-exec,
                                                  OUTPUT TABLE RowErrors).
        RUN emptyRowErrors        IN h-bodi317pr.
    
        FOR EACH RowErrors
            WHERE RowErrors.ErrorSubType = "ERROR":
            CREATE tt-erros.
            BUFFER-COPY RowErrors TO tt-erros.
        END.
    
        IF tt-param.atualiza-nota 
        AND NOT CAN-FIND (FIRST tt-erros) THEN DO:
        
            RUN inicializaAcompanhamento IN h-bodi317ef.
            RUN efetivaNota IN h-bodi317ef(INPUT wt-docto.seq-wt-docto,
                                           INPUT YES,
                                           OUTPUT l-proc-ok).
    
            RUN devolveErrosbodi317ef IN h-bodi317ef (OUTPUT c-ultimo-metodo-exec,
                                                      OUTPUT TABLE RowErrors).
            RUN emptyRowErrors        IN h-bodi317ef.
        
            FOR EACH RowErrors
                WHERE RowErrors.ErrorSubType = "ERROR":
                CREATE tt-erros.
                BUFFER-COPY RowErrors TO tt-erros.
            END.
        
            RUN finalizaAcompanhamento IN h-bodi317ef.
        
            RUN buscaTtNotasGeradas IN h-bodi317ef (OUTPUT l-proc-ok,
                                                    OUTPUT TABLE tt-notas-geradas).
        END.
    END.
    

    IF CAN-FIND (FIRST tt-erros) THEN DO:
        FOR EACH tt-erros:
            PUT UNFORMATTED "Erro: " string(tt-erros.ErrorNumber) + " - " + tt-erros.ErrorDescription + "  " +  tt-erros.ErrorHelp SKIP.
        END.                                 
    END.
    ELSE DO:
        IF tt-param.atualiza-nota 
        AND NOT CAN-FIND (FIRST tt-erros) THEN DO:
            FOR EACH tt-notas-geradas:
                FIND FIRST nota-fiscal NO-LOCK
                    WHERE ROWID(nota-fiscal) = rw-nota-fiscal NO-ERROR.
        
                PUT UNFORMATTED "Nota gerada: " nota-fiscal.nr-nota-fis + " Serie: " + nota-fiscal.serie + " Estabelecimento: " + nota-fiscal.cod-estabel SKIP. 
            END.
        END.
        ELSE DO:
            FOR EACH tt-doc-gerado:
                PUT UNFORMATTED "Documento gerado: " tt-doc-gerado.seq-wt-docto SKIP.
            END.
        END.
    END.
    OUTPUT CLOSE.

    IF tt-param.destino = 3 THEN DO:
        RUN WinExec (INPUT "Notepad.exe":U + CHR(32) + c-arquivo-saida,
                     INPUT 1).
    END.

    IF CAN-FIND (FIRST tt-erros) THEN
        UNDO criaNota, LEAVE criaNota.
END.

DELETE PROCEDURE h-bodi317sd.      
DELETE PROCEDURE h-bodi317ef.    
DELETE PROCEDURE h-bodi317in.    
DELETE PROCEDURE h-bodi317pr.    
DELETE PROCEDURE h-bodi317im1bra.
DELETE PROCEDURE h-bodi317va. 

PROCEDURE pi-carrega-dados:
    INPUT FROM VALUE(tt-param.arquivo-importa).
    ASSIGN lFirst = YES.
    REPEAT:
        IMPORT UNFORMATTED c-linha.

        /*Ignora linha do albel*/
        IF lFirst THEN DO:
            ASSIGN lFirst = NO.
            NEXT.
        END.

        IF NOT CAN-FIND (FIRST tt-wt-docto
                         WHERE tt-wt-docto.cod-estabel  = ENTRY(1,c-linha,";")
                           AND tt-wt-docto.serie        = ENTRY(2,c-linha,";")
                           AND tt-wt-docto.cod-emitente = INT(ENTRY(3,c-linha,";"))) THEN DO:
    
            CREATE tt-wt-docto.
            ASSIGN tt-wt-docto.cod-estabel     = ENTRY(1,c-linha,";")
                   tt-wt-docto.serie           = ENTRY(2,c-linha,";")
                   tt-wt-docto.cod-emitente    = INT(ENTRY(3,c-linha,";"))
                   tt-wt-docto.dt-emis-nota    = TODAY
                   tt-wt-docto.nat-operacao    = ENTRY(4,c-linha,";")
                   tt-wt-docto.cod-canal-venda = INT(ENTRY(5,c-linha,";"))
                   tt-wt-docto.no-ab-reppri    = ENTRY(6,c-linha,";")
                   tt-wt-docto.cod-cond-pag    = INT(ENTRY(7,c-linha,";"))
                   tt-wt-docto.dt-prvenc       = DATE(ENTRY(8,c-linha,";"))
                   tt-wt-docto.cod-rota        = ENTRY(9,c-linha,";")
                   tt-wt-docto.nome-transp     = ENTRY(10,c-linha,";")
                   tt-wt-docto.contrato        = "Contrato: " + ENTRY(11,c-linha,";")
                   tt-wt-docto.observ-nota     = tt-wt-docto.contrato + ". " + ENTRY(12,c-linha,";")
                   tt-wt-docto.cidade          = ENTRY(16,c-linha,";")
                   tt-wt-docto.estado          = ENTRY(17,c-linha,";").
    
            FIND FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = tt-wt-docto.cod-emitente NO-ERROR.

            FIND FIRST repres NO-LOCK
                WHERE repres.cod-rep = int(tt-wt-docto.no-ab-reppri) NO-ERROR.

            FIND FIRST transporte NO-LOCK
                WHERE transporte.cod-transp = int(tt-wt-docto.nome-transp) NO-ERROR.

            ASSIGN tt-wt-docto.nome-abrev   = emitente.nome-abrev WHEN AVAIL emitente
                   tt-wt-docto.nome-transp  = transporte.nome-abrev WHEN AVAIL transporte
                   tt-wt-docto.no-ab-reppri = repres.nome-abrev.
        END.

        CREATE tt-wt-it-docto.
        ASSIGN tt-wt-it-docto.cod-estabel   = ENTRY(1,c-linha,";")
               tt-wt-it-docto.serie         = ENTRY(2,c-linha,";")
               tt-wt-it-docto.cod-emitente  = INT(ENTRY(3,c-linha,";"))
               tt-wt-it-docto.nat-operacao  = ENTRY(4,c-linha,";")
               tt-wt-it-docto.it-codigo     = ENTRY(13,c-linha,";")
               tt-wt-it-docto.quantidade    = DEC(ENTRY(14,c-linha,";"))
               tt-wt-it-docto.vl-preori-ped = DEC(ENTRY(15,c-linha,";"))
               tt-wt-it-docto.cod-depos     = ENTRY(18,c-linha,";").

        FIND LAST b-tt-wt-it-docto
            WHERE b-tt-wt-it-docto.cod-estabel  = tt-wt-it-docto.cod-estabel  
              AND b-tt-wt-it-docto.serie        = tt-wt-it-docto.serie        
              AND b-tt-wt-it-docto.cod-emitente = tt-wt-it-docto.cod-emitente NO-ERROR.
        
        IF NOT AVAIL b-tt-wt-it-docto THEN
            ASSIGN tt-wt-it-docto.nr-sequencia = 10.
        ELSE 
            ASSIGN tt-wt-it-docto.nr-sequencia = b-tt-wt-it-docto.nr-sequencia + 10.
    END.
    INPUT CLOSE.
END.

/*--- Procedure Externa  ---*/
PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.
