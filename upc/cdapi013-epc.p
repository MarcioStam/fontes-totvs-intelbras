/* PROGRAMA DE UPC PARA AVALIACAO DE CREDITO DE PEDIDOS */

{esp/es0018.i}
{include/i-epc200.i1}  /* definicao tt-epc */

DEF INPUT PARAMETER c-evento AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

DEFINE VARIABLE r-rowid AS ROWID      NO-UNDO.

IF c-evento = "call-Upc-Verify-ped-item" THEN DO:
     FIND FIRST tt-epc WHERE 
            tt-epc.cod-event     = "call-Upc-Verify-ped-item" AND 
            tt-epc.cod-parameter = "return" AND 
            tt-epc.val-parameter = STRING("NO")  NO-ERROR.
     IF AVAIL tt-epc THEN
         ASSIGN tt-epc.val-parameter = STRING("yes").
END.

IF   c-evento = "Verify-ped-item" THEN DO:
     FIND FIRST tt-epc WHERE 
           tt-epc.cod-event     = "Verify-ped-item" AND 
           tt-epc.cod-parameter = "ped-item rowid" NO-LOCK NO-ERROR.
     IF  AVAIL tt-epc THEN DO:
         FIND ped-item
             WHERE ROWID(ped-item) = TO-ROWID(tt-epc.val-parameter) 
             NO-LOCK NO-ERROR.
         IF AVAIL ped-item  THEN DO:
             FIND ped-venda OF ped-item NO-LOCK NO-ERROR.
             IF AVAIL ped-venda THEN DO:

                IF  ped-venda.cod-sit-aval <> 3 /* Aprovado */ OR
                    ped-venda.cod-priori = 44                           THEN RUN pi-cria-retorno.

                FIND cond-pagto NO-LOCK
                   WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.
                IF AVAIL cond-pagto
                AND cond-pagto.cod-cond-pag <> 502
                AND cond-pagto.cod-vencto    = 2                        THEN RUN pi-cria-retorno.
                
                IF AVAIL cond-pagto THEN DO:
                    FIND int-cond-pagto OF cond-pagto NO-LOCK NO-ERROR.
                    IF  AVAIL int-cond-pagto
                    AND SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U  THEN RUN pi-cria-retorno.

                END.
             END.
         END.
     END.
END.

IF c-evento = "COMPLEMENTARY_EVALUATION" THEN DO:
    FIND FIRST tt-epc WHERE
        tt-epc.cod-event = "COMPLEMENTARY_EVALUATION" AND
        tt-epc.cod-parameter = "ped-venda rowid"
    NO-LOCK NO-ERROR.

    IF AVAIL tt-epc THEN DO:
        ASSIGN r-rowid = TO-ROWID(tt-epc.val-parameter).

        FIND ped-venda WHERE
            ROWID(ped-venda) = r-rowid NO-LOCK NO-ERROR.

        IF AVAIL ped-venda THEN DO:
            
            FIND cond-pagto WHERE 
                cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag
            NO-LOCK NO-ERROR.

            IF AVAIL cond-pagto
            AND cond-pagto.cod-vencto = 2 THEN DO:  /* a vista */

                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "Credit-Evaluation" 
                       tt-epc.cod-parameter = "error"
                       tt-epc.val-parameter = "PEDIDO POSSUI CONDI€ÇO DE PAGAMENTO · VISTA".
            END.
            ELSE DO:
                IF AVAIL cond-pagto THEN DO:
                    
                    FIND int-cond-pagto
                         WHERE int-cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag
                         NO-LOCK NO-ERROR.
                    
                    IF  AVAIL int-cond-pagto and
                        (substring(int-cond-pagto.char-1,5,1) = "N" OR 
                         substring(int-cond-pagto.char-1,5,1) = "") THEN DO:

                        
                        CREATE tt-epc.
                        ASSIGN tt-epc.cod-event     = "Credit-Evaluation" 
                               tt-epc.cod-parameter = "error"
                               tt-epc.val-parameter = "PEDIDO COM COND.PAGTO NAO PERMITE AVALIA€ÇO AUTOMATICA".

                    END.

                END.
            END.
        END.
    END.
END.
IF c-evento = "Credit-Evaluation" THEN DO:
    FIND FIRST tt-epc WHERE
        tt-epc.cod-event = "Credit-Evaluation" AND
        tt-epc.cod-parameter = "ped-venda"
    NO-LOCK NO-ERROR.

    IF AVAIL tt-epc THEN DO:
        ASSIGN r-rowid = TO-ROWID(tt-epc.val-parameter).

        FIND ped-venda WHERE
            ROWID(ped-venda) = r-rowid NO-LOCK NO-ERROR.

        IF AVAIL ped-venda THEN DO:
            IF index(ped-venda.desc-bloq-cr,"=>") <> 0 and
                ped-venda.cod-sit-aval = 4 THEN DO:

                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "Credit-Evaluation" 
                       tt-epc.cod-parameter = "RETURN"
                       tt-epc.val-parameter = "YES".

            END.
            ELSE DO:
                
                FIND FIRST int-emitente NO-LOCK
                     WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

                RUN esp/es0018p.p (INPUT "dps-canal-vd", /* Nome do programa */
                                   INPUT 1,              /* Ponto do programa */
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.
            
                IF  NOT CAN-FIND (FIRST tt-prog-ponto
                                  WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:
                        FIND cond-pagto 
                       WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.
                        
                        IF AVAIL cond-pagto AND cond-pagto.cod-vencto = 2 THEN DO:  /* a vista */
                            CREATE tt-epc.
                            ASSIGN tt-epc.cod-event     = "Credit-Evaluation" 
                                   tt-epc.cod-parameter = "ped-venda-sit"
                                   tt-epc.val-parameter = "PEDIDO POSSUI CONDI€ÇO DE PAGAMENTO · VISTA".
                        END.
                        ELSE DO:
                            FIND int-cond-pagto
                           WHERE int-cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-LOCK NO-ERROR.
             
                            IF  AVAIL int-cond-pagto and
                                (substring(int-cond-pagto.char-1,5,1) = "N" OR 
                                 substring(int-cond-pagto.char-1,5,1) = "") THEN DO:
                                CREATE tt-epc.
                                ASSIGN tt-epc.cod-event     = "Credit-Evaluation" 
                                       tt-epc.cod-parameter = "RETURN"
                                       tt-epc.val-parameter = "YES".
                            END.
                        END.
                    END.
                ELSE DO:
                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "Credit-Evaluation" 
                           tt-epc.cod-parameter = "RETURN"
                           tt-epc.val-parameter = "YES".
                END.
            END.
        END.
    END.
END.

IF c-evento = "End-Credit-Evaluation" THEN DO:
    FIND FIRST tt-epc WHERE
        tt-epc.cod-event = "End-Credit-Evaluation" AND
        tt-epc.cod-parameter = "rowid ped-venda"
        NO-LOCK NO-ERROR.
    
    IF AVAIL tt-epc THEN DO:
        ASSIGN r-rowid = TO-ROWID(tt-epc.val-parameter).
    
        FIND ped-venda WHERE
            ROWID(ped-venda) = r-rowid EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:

            FIND natur-oper
                 WHERE natur-oper.nat-operacao = ped-venda.nat-operacao
                 NO-LOCK NO-ERROR.
            IF AVAIL natur-oper AND
               natur-oper.emite-duplic = NO THEN DO:
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "End-Credit-Evaluation" 
                       tt-epc.cod-parameter = "ped-venda-sit".
                ASSIGN  ped-venda.cod-sit-aval = 3       
                        ped-venda.user-aprov   = "Sistema"
                        ped-venda.quem-aprovou = "Sistema"
                        ped-venda.dt-apr-cred  = TODAY
                        ped-venda.desc-bloq-cr = "Natureza de Opera‡Æo NÆo Emite Duplicata".


            END.

            IF CAN-FIND(FIRST int-pedido-vtex NO-LOCK
                        WHERE int-pedido-vtex.nr-pedcli = ped-venda.nr-pedcli) THEN DO:
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "End-Credit-Evaluation" 
                       tt-epc.cod-parameter = "ped-venda-sit".
                ASSIGN  ped-venda.cod-sit-aval = 3       
                        ped-venda.user-aprov   = "Sistema"
                        ped-venda.quem-aprovou = "Sistema"
                        ped-venda.dt-apr-cred  = TODAY
                        ped-venda.desc-bloq-cr = "Pedido j  est  pago.".

            END.
        END.
    END.
END.

PROCEDURE pi-cria-retorno:
       CREATE tt-epc.
       ASSIGN tt-epc.cod-event     = "Verify-ped-item"  
              tt-epc.cod-parameter = "Error" NO-ERROR.
END PROCEDURE.
