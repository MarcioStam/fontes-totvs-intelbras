{esp/es0018.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-csv     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp           AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-data            AS DATE        NO-UNDO.
DEFINE VARIABLE c-nat-oper        AS CHAR        NO-UNDO.
DEFINE VARIABLE l-tem-st          AS LOG         NO-UNDO.
DEFINE VARIABLE l-ipi-diferente   AS LOG         NO-UNDO.
DEFINE VARIABLE l-natur-diferente AS LOG         NO-UNDO.
DEFINE VARIABLE l-ped-loja        AS LOG         NO-UNDO.

DEFINE BUFFER b-emitente FOR emitente.

define temp-table RowErrors no-undo
       field ErrorSequence    as integer
       field ErrorNumber      as integer
       field ErrorDescription as character format "x(150)"
       field ErrorParameters  as character
       field ErrorType        as character
       field ErrorHelp        as character format "x(150)"
       field ErrorSubtype     as character.

DEFINE TEMP-TABLE tt-pedido NO-UNDO
       FIELD nr-pedcli LIKE ped-venda.nr-pedcli
       FIELD l-loja      AS LOG.

define temp-table tt-param no-undo
    field destino           as integer
    field arquivo           as char format "x(35)"
    field usuario           as char format "x(12)"
    field data-exec         as date
    field hora-exec         as integer
    field classifica        as integer
    field desc-classifica   as char format "x(40)"
    field modelo-rtf        as char format "x(35)"
    field l-habilitaRtf     as LOG
    FIELD cod-estabel-ini   LIKE ped-venda.cod-estabel
    FIELD cod-estabel-fim   LIKE ped-venda.cod-estabel
    FIELD tp-pedido-ini     LIKE ped-venda.tp-pedido
    FIELD tp-pedido-fim     LIKE ped-venda.tp-pedido
    FIELD dt-implant-ini    LIKE ped-venda.dt-implant
    FIELD dt-implant-fim    LIKE ped-venda.dt-implant
    FIELD cod-emitente-ini  LIKE ped-venda.cod-emitente
    FIELD cod-emitente-fim  LIKE ped-venda.cod-emitente
    FIELD it-codigo-ini     LIKE ped-item.it-codigo
    FIELD it-codigo-fim     LIKE ped-item.it-codigo
    FIELD cod-nat-oper-ini  LIKE ped-venda.nat-operacao
    FIELD cod-nat-oper-fim  LIKE ped-venda.nat-operacao
    FIELD cod-uf-ini          AS CHAR
    FIELD cod-uf-fim          AS CHAR
    FIELD nr-pedcli-ini     LIKE ped-venda.nr-pedido
    FIELD nr-pedcli-fim     LIKE ped-venda.nr-pedido
    FIELD l-relatorio         AS LOG.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "ESPDP102_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.

EMPTY TEMP-TABLE tt-pedido.

DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

    PUT STREAM str-excel UNFORMATTED "Dt Implant;Pedido;Estab;UF;Cliente;Atendente;Item;Nat Oper;Nat Novo;IPI Atual; IPI Novo;Retem Icms;Retem Icms Novo;Loja?;Prior" SKIP
        .
    //DO d-data = tt-param.dt-implant-ini TO tt-param.dt-implant-fim:
    
        FOR EACH ped-venda NO-LOCK USE-INDEX ch-implant
           WHERE ped-venda.dt-implant   >= tt-param.dt-implant-ini
             AND ped-venda.dt-implant   <= tt-param.dt-implant-fim
             AND ped-venda.cod-emitente >= tt-param.cod-emitente-ini
             AND ped-venda.cod-emitente <= tt-param.cod-emitente-fim
             AND ped-venda.tp-pedido    >= tt-param.tp-pedido-ini
             AND ped-venda.tp-pedido    <= tt-param.tp-pedido-fim 
             AND ped-venda.cod-estabel  >= tt-param.cod-estabel-ini
             AND ped-venda.cod-estabel  <= tt-param.cod-estabel-fim 
             AND ped-venda.nr-pedido    >= tt-param.nr-pedcli-ini
             AND ped-venda.nr-pedido    <= tt-param.nr-pedcli-fim
             AND ped-venda.estado       >= tt-param.cod-uf-ini
             AND ped-venda.estado       <= tt-param.cod-uf-fim
             AND ped-venda.cod-sit-ped  < 3 : 

             IF ped-venda.cod-estab = "101" THEN NEXT.

            /* IF (ped-venda.cod-emitente < tt-param.cod-emitente-ini OR
                 ped-venda.cod-emitente > tt-param.cod-emitente-fim) THEN NEXT.

             IF (ped-venda.tp-pedido < tt-param.tp-pedido-ini OR
                 ped-venda.tp-pedido > tt-param.tp-pedido-fim) THEN NEXT.

             IF (ped-venda.cod-estabel < tt-param.cod-estabel-ini OR
                 ped-venda.cod-estabel > tt-param.cod-estabel-fim) THEN NEXT.

             IF (ped-venda.nr-pedcli  < tt-param.nr-pedcli-ini OR
                 ped-venda.nr-pedcli  > tt-param.nr-pedcli-fim) THEN NEXT.

             IF (ped-venda.estado  < tt-param.cod-uf-ini OR
                 ped-venda.estado  > tt-param.cod-uf-fim) THEN NEXT. */
                    
             RUN pi-acompanhar in h-acomp (input string(ped-venda.dt-implant) + " " + string(ped-venda.nr-pedido) + " " + STRING(ped-venda.tp-pedido)).

             ASSIGN l-ped-loja = NO.
             IF ped-venda.tp-pedido = "21" OR
                ped-venda.tp-pedido = "22" OR
                ped-venda.tp-pedido = "23" OR
                ped-venda.tp-pedido = "24" THEN DO:

                 ASSIGN l-ped-loja = YES.
             END. 
                  
            FOR EACH ped-item OF ped-venda NO-LOCK
               WHERE (ped-item.cod-sit-item < 3
                  OR  ped-item.cod-sit-item = 5):

                 IF (ped-item.it-codigo < tt-param.it-codigo-ini OR
                     ped-item.it-codigo > tt-param.it-codigo-fim) THEN NEXT.

                 IF (ped-item.nat-oper  < tt-param.cod-nat-oper-ini OR
                     ped-item.nat-oper  > tt-param.cod-nat-oper-fim) THEN NEXT.

                FIND FIRST natur-oper NO-LOCK
                     WHERE natur-oper.nat-oper = ped-item.nat-operacao NO-ERROR.
                IF NOT AVAIL natur-oper THEN NEXT.

                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = ped-item.it-codigo NO-ERROR.
                IF AVAIL ITEM THEN DO:

                    ASSIGN l-ipi-diferente   = NO
                           l-natur-diferente = NO.

                    IF ped-item.aliquota-ipi <> ITEM.aliquota-ipi THEN DO: //atualizar pedido com IPI diferente do cadastro
                        ASSIGN l-ipi-diferente = YES.                        
                    END.

                    RUN pi-verifica-Nat(INPUT ped-item.nat-operacao,
                                       OUTPUT l-tem-ST).

                    IF c-nat-oper <> ped-item.nat-operacao OR (l-tem-ST <> ped-item.ind-icm-ret) THEN DO: //verifica se mudou a natureza devido a regras tributarias
                        ASSIGN l-natur-diferente = YES.
                    END.

                    IF l-ipi-diferente OR l-natur-diferente THEN DO: //somente atualiza pedido se uma das condicoes for alterada

                        PUT STREAM str-excel UNFORMATTED ped-venda.dt-implant   ";"
                                                         ped-venda.nr-pedido    ";"
                                                         ped-venda.cod-estabel  ";"
                                                         ped-venda.estado       ";"
                                                         ped-venda.cod-emitente ";"
                                                         ped-venda.tp-pedido    ";"
                                                         ped-item.it-codigo     ";"
                                                         ped-item.nat-oper      ";"
                                                         c-nat-oper             ";" 
                                                         ped-item.aliquota-ipi  ";" 
                                                         item.aliquota-ipi      ";"
                                                         ped-item.ind-icm-ret   ";"
                                                         l-tem-ST               ";"
                                                         l-ped-loja             ";"
                                                         ped-venda.cod-prior    SKIP.

                        IF NOT tt-param.l-relatorio THEN DO:

                            FIND CURRENT ped-item EXCLUSIVE-LOCK NO-ERROR.
                        
                            IF l-ipi-diferente THEN DO:
                                ASSIGN ped-item.aliquota-ipi = ITEM.aliquota-ipi.
                        
                                if item.ind-ipi-dife and item.tipo-contr = 4 THEN DO:
                                    IF (substr(ped-item.char-2,01,08) <> "" AND
                                        substr(ped-item.char-2,01,08) <> replace(ITEM.class-fiscal,",","")) THEN
                                        ASSIGN OVERLAY(ped-item.char-2,01,08) = replace(ITEM.class-fiscal,",",""). 
                                END.
                            END.
                        
                            IF l-natur-diferente THEN DO:
                                ASSIGN ped-item.nat-oper    = c-nat-oper
                                       ped-item.ind-icm-ret = l-tem-ST.
                            END.
                            FIND CURRENT ped-item NO-LOCK NO-ERROR.

                            FIND FIRST tt-pedido 
                                 WHERE tt-pedido.nr-pedcli = ped-venda.nr-pedcli NO-ERROR.
                            IF NOT AVAIL tt-pedido THEN DO:
                                CREATE tt-pedido.
                                ASSIGN tt-pedido.nr-pedcli  = ped-venda.nr-pedcli
                                       tt-pedido.l-loja     = l-ped-loja.
                            END. 
                        END. //somente relatorio

                    END. //ipi diferente, natureza diferente 
                END. //avail item
            END. //for each ped-item
        END. //for each ped-venda
    //END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

   // RETURN "OK".   
END.

IF CAN-FIND(FIRST tt-pedido) THEN DO:
   FOR EACH tt-pedido:

        IF tt-pedido.l-loja THEN DO: //pedidos da loja roda o recalculo
            RUN pi-atualiza-pedido-loja(INPUT tt-pedido.nr-pedcli).
           // RUN esp/api/recalculo-pedido.p (input tt-pedido.nr-pedido).
        END.
        ELSE DO:
            FIND FIRST ped-venda EXCLUSIVE-LOCK
                 WHERE ped-venda.nr-pedcli = tt-pedido.nr-pedcli NO-ERROR.
            IF AVAIL ped-venda THEN DO:
                ASSIGN ped-venda.completo = NO.
                FIND CURRENT ped-venda NO-LOCK NO-ERROR.

                IF NOT ped-venda.completo THEN
                   RUN pi-completa-pedido.
            END. 
            
        END.
    END.
END.


PROCEDURE pi-verifica-Nat:
    DEFINE INPUT  PARAM pNatOper AS CHAR    NO-UNDO.
    DEFINE OUTPUT PARAM p-ST AS LOG INIT NO NO-UNDO.
    //DEFINE OUTPUT PARAM pNat AS CHAR NO-UNDO.

    DEFINE VAR h-boes505          AS HANDLE NO-UNDO.
    DEFINE VAR l-return           AS LOG    NO-UNDO. 
    DEFINE VAR l-consumidor-final AS LOG    NO-UNDO.
    DEFINE VAR l-valida           AS LOG    NO-UNDO.

    DEFINE BUFFER b-natureza FOR natur-oper.

    ASSIGN l-valida = YES.

    IF ped-venda.cod-des-merc = 1 THEN
        ASSIGN l-consumidor-final = NO.
    ELSE
        ASSIGN l-consumidor-final = YES.

    FIND FIRST b-emitente NO-LOCK
         WHERE b-emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

    FIND FIRST unid-feder NO-LOCK
         WHERE unid-feder.pais   = b-emitente.pais
           AND unid-feder.estado = b-emitente.estado NO-ERROR.
    FIND estabelec
        WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.

    
    IF  b-emitente.natureza <> 3 
    AND b-emitente.contrib-icms = NO
    AND (b-emitente.ins-estadual = ""
    OR   b-emitente.ins-estadual = "ISENTO"
    OR   b-emitente.ins-estadual = "ISENTA") THEN
        ASSIGN l-consumidor-final = YES.
    
        IF  natur-oper.cod-mensagem    = 11  OR
            natur-oper.cod-mensagem    = 31  OR
            natur-oper.cod-mensagem    = 70  OR
            natur-oper.cod-mensagem    = 83  OR
            natur-oper.cod-mensagem    = 120 OR
            natur-oper.cod-mensagem    = 816 OR
            natur-oper.cod-mensagem    = 819 OR
            natur-oper.cod-mensagem    = 834 OR
            natur-oper.cod-mensagem    = 906 OR
            natur-oper.log-oper-triang = YES OR
            natur-oper.nat-operacao BEGINS "8" OR //Natureza de servico/locacao
            natur-oper.tipo            = 3 THEN /* Venda de ativo imobilizado */
            	ASSIGN l-valida = NO.
        ELSE
            IF natur-oper.emite-duplic = YES THEN
                ASSIGN l-valida = YES.
            ELSE
                ASSIGN l-valida = NO.
      
      IF ped-venda.cod-estabel = "105" THEN DO: 
          EMPTY TEMP-TABLE tt-prog-ponto.
        /* FIND emitente
             WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR. */

         IF AVAIL b-emitente AND b-emitente.estado <> "RS" THEN DO: //entreposto M2107-068
            RUN esp/es0018p.p (INPUT "espdp079",
                               INPUT 2,
                               INPUT 0,
                               INPUT "", 
                               OUTPUT TABLE tt-prog-ponto).
          
            IF CAN-FIND (FIRST tt-prog-ponto
                         WHERE tt-prog-ponto.conteudo = pNatOper)  THEN
                ASSIGN l-valida = NO.

         END.
      END.
      IF ped-venda.cod-estabel BEGINS "6" THEN DO: //Natureza Decio
          EMPTY TEMP-TABLE tt-prog-ponto.
          RUN esp/es0018p.p (INPUT "espdp079",
                             INPUT 4,
                             INPUT 0,
                             INPUT "", 
                             OUTPUT TABLE tt-prog-ponto).

          IF CAN-FIND (FIRST tt-prog-ponto
                       WHERE tt-prog-ponto.conteudo = pNatOper)  THEN
              ASSIGN l-valida = NO.
      END.    

     IF l-valida THEN DO:
        RUN esbo/boes505.p PERSISTENT SET h-boes505.
        
        RUN defineNatOperacao IN h-boes505 (INPUT ped-venda.cod-estabel,
                                            INPUT ped-venda.cod-emitente,
                                            INPUT ped-venda.cod-entrega,
                                            INPUT ITEM.it-codigo,
                                            INPUT l-consumidor-final,
                                            OUTPUT c-nat-oper,
                                            OUTPUT l-return).
        DELETE PROCEDURE h-boes505. 
     END.
     ELSE
         ASSIGN c-nat-oper = pNatOper.

         
     IF b-emitente.contrib-icms AND AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO:
         
           FIND FIRST item-uf NO-LOCK
                WHERE ITEM-uf.it-codigo       = ITEM.it-codigo
                  AND item-uf.cod-estado-orig = estabelec.estado
                  AND item-uf.estado          = b-emitente.estado NO-ERROR.
           FIND FIRST dist-emitente OF b-emitente NO-LOCK NO-ERROR.

           FIND FIRST b-natureza
                WHERE b-natureza.nat-operacao = c-nat-oper NO-LOCK NO-ERROR.
           IF AVAIL b-natureza THEN DO:
               if  b-natureza.subs-trib AND
                  AVAIL item-uf AND AVAIL dist-emitente AND dist-emitente.nr-tb-pauta = ""
                  AND b-emitente.insc-subs-trib = "" THEN  DO:

                  ASSIGN p-ST = YES.
               END.
           END. /* IF AVAIL natur-oper THEN DO: */
           ELSE
               NEXT.
         
          // ASSIGN pNat = c-nat-oper.
    
     END. /* IF emitente.contrib-icms AND AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO: */

END PROCEDURE.


PROCEDURE pi-completa-pedido:

    DEFINE VARIABLE h-bodi159cal      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-erro            AS LOGICAL     NO-UNDO.

    /************************/
    /* COMPLETANDO O PEDIDO */
    /************************/
    EMPTY TEMP-TABLE RowErrors.
    RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.
    RUN completeOrder in h-bodi159cal (INPUT ROWID(ped-venda),
                                      OUTPUT TABLE RowErrors).
  
    FOR EACH RowErrors NO-LOCK
       WHERE RowErrors.ErrorNumber <> 8259 /** cr‚dito nÆo aprovado **/
         AND RowErrors.ErrorSubType = 'Error':
        
       RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", STRING(RowErrors.errorNumber), RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).
       ASSIGN l-erro = YES.
    END.
     
    IF  VALID-HANDLE(h-bodi159cal) AND h-bodi159cal:file-name = 'dibo/bodi159com.p' AND h-bodi159cal:type = 'procedure' THEN
        RUN destroyBO IN  h-bodi159cal.
    IF  VALID-HANDLE(h-bodi159cal) THEN DO:
        DELETE PROCEDURE h-bodi159cal.
        ASSIGN h-bodi159cal = ?.
    END.

END PROCEDURE.

PROCEDURE pi-atualiza-pedido-loja:

    DEFINE INPUT PARAM pPedido LIKE ped-venda.nr-pedcli.

    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedcli = pPedido
           AND (ped-venda.cod-sit-ped = 1
             OR ped-venda.cod-sit-ped = 2
             OR ped-venda.cod-sit-ped = 5) NO-ERROR.
    IF NOT AVAIL ped-venda THEN NEXT.

    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    IF AVAILABLE (int-ped-venda) THEN DO:
        FIND FIRST int-pedido-vtex EXCLUSIVE-LOCK
             WHERE int-pedido-vtex.nr-pedcli    = ped-venda.nr-pedcli NO-ERROR.
        IF AVAIL int-pedido-vtex THEN
            ASSIGN int-ped-venda.vl-frete = int-pedido-vtex.vl-tot-frete.
    
        FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK:

            FOR FIRST int-ped-item-vtex NO-LOCK
                WHERE int-ped-item-vtex.nr-pedido = int-pedido-vtex.nr-pedido
                  AND int-ped-item-vtex.it-codigo = ped-item.it-codigo:
                ASSIGN ped-item.vl-pretab        = int-ped-item-vtex.vl-preco-item
                       ped-item.vl-preori        = int-ped-item-vtex.vl-preco-item
                       ped-item.vl-preuni        = int-ped-item-vtex.vl-preco-item
                       ped-item.vl-preori-un-fat = int-ped-item-vtex.vl-preco-item.
            END.
        END.
        RUN esp/api/recalculo-pedido.p (INPUT ped-venda.nr-pedido).
    END.

END PROCEDURE.
