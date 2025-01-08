{esp/wso/in/wso0003.i}

DEFINE VARIABLE l-erro                      AS LOGICAL      NO-UNDO.

PROCEDURE pi-evento:

    DEFINE INPUT        PARAMETER c-evento AS CHAR NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttPessoaFisica.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttPessoaJuridica.    
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttTelefone.          
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttEmail.             
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttEndereco.         
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttDocumento.         
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttPedido.           
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttCondicaoPagamento. 
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttItem.             
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-emitente.         
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-ped-venda.        
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-ped-item.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttErro.

    DEFINE VARIABLE i-seq-contato     AS INT         NO-UNDO.
    DEFINE VARIABLE h-bodi159cal      AS HANDLE      NO-UNDO.

    IF c-evento = "aposCriaTTPedVenda" THEN DO:
        FOR FIRST tt-ped-venda:
            FOR EACH tt-ped-item OF tt-ped-venda:
                ASSIGN tt-ped-item.nat-operacao = "500011".
            END.
            ASSIGN tt-ped-venda.cod-cond-pag = 553
                   tt-ped-venda.nat-operacao = "500011".
        END.
    END.

    IF c-evento = "aposAtualizaPessoa" THEN DO:

        FIND FIRST tt-emitente NO-ERROR.
        IF AVAIL tt-emitente THEN DO:

            IF NOT CAN-FIND(FIRST cont-emit NO-LOCK
                            WHERE cont-emit.cod-emitente = tt-emitente.cod-emitente
                              AND cont-emit.int-1        = 2
                              AND cont-emit.nome         = "NFE"
                              AND cont-emit.e-mail       = tt-emitente.e-mail + ",sistema@prediotec.com.br,financeiro@prediotech.com.br") THEN DO:
    
                FIND FIRST cont-emit NO-LOCK
                     WHERE cont-emit.cod-emitente = tt-emitente.cod-emitente
                       AND cont-emit.int-1        = 2 NO-ERROR.
                IF NOT AVAIL cont-emit THEN DO:
                    ASSIGN i-seq-contato = 10.
                    FOR LAST cont-emit NO-LOCK 
                       WHERE cont-emit.cod-emitente = tt-emitente.cod-emitente 
                          BY cont-emit.sequencia:
                        ASSIGN i-seq-contato = cont-emit.sequencia + 10.
                    END.
                    
                    CREATE cont-emit.
                    ASSIGN cont-emit.cod-emitente = tt-emitente.cod-emitente
                           cont-emit.sequencia    = i-seq-contato
                           cont-emit.identific    = 1
                           cont-emit.int-1        = 2.
                END.
                FIND CURRENT cont-emit EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN cont-emit.nome   = "NFE"
                       cont-emit.e-mail = tt-emitente.e-mail + ",sistema@prediotec.com.br,financeiro@prediotech.com.br".
                FIND CURRENT cont-emit NO-LOCK NO-ERROR.
                RELEASE cont-emit.
                    
            END.
        END.
    END.

    RETURN "OK".

END.

RETURN "OK".


