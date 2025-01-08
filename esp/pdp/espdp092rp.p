{method/dbotterr.i}
{esp/es0018.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-bodi159cal  AS HANDLE      NO-UNDO.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD msg-erro AS CHAR.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG.

define temp-table tt-digita no-undo
    FIELD nr-pedido LIKE ped-venda.nr-pedido
    FIELD cod-transp LIKE transporte.cod-transp.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

for each tt-raw-digita NO-LOCK:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "ESPDP092_" + STRING(TIME) + ".csv":U.

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


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    IF  NOT VALID-HANDLE(h-bodi159cal) THEN
        RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

    PUT  STREAM str-excel UNFORMATTED  "Pedido;Transportadora" SKIP.
    
    FOR EACH tt-digita:
        FIND FIRST ped-venda EXCLUSIVE-LOCK
             WHERE ped-venda.nr-pedido = tt-digita.nr-pedido NO-ERROR.

        IF AVAIL ped-venda THEN DO:
            FIND FIRST transporte NO-LOCK
                 WHERE transporte.cod-transp = tt-digita.cod-transp NO-ERROR.

            IF AVAIL transporte THEN DO:
                ASSIGN ped-venda.nome-transp = transporte.nome-abrev.

/*                 RUN completeOrder IN h-bodi159cal (INPUT ROWID(ped-venda),  */
/*                                                    OUTPUT TABLE RowErrors). */
/*                                                                             */
/*                 IF CAN-FIND (FIRST RowErrors                                */
/*                      WHERE RowErrors.ErrorType   <> "INTERNAL":U            */
/*                        AND RowErrors.ErrorSubType = "Error") THEN DO:       */
/*                                                                             */
/*                     FOR EACH RowErrors:                                     */
/*                         RUN pi-erro (INPUT RowErrors.errordescription).     */
/*                     END.                                                    */
/*                     NEXT.                                                   */
/*                 END.                                                        */
                PUT  STREAM str-excel UNFORMATTED string(ped-venda.nr-pedido) + ";" + ped-venda.nome-transp SKIP.
            END.
            ELSE DO:
                RUN pi-erro (INPUT "Transportadora " + string(tt-digita.cod-transp) + " n∆o encontrada.").
            END.

        END.
        ELSE DO:
            RUN pi-erro (INPUT "Pedido " + string(tt-digita.nr-pedido) + " n∆o encontrado.").
        END.
    END.

    IF CAN-FIND (FIRST tt-erro) THEN DO:

        PUT  STREAM str-excel SKIP (2).

        PUT  STREAM str-excel UNFORMATTED  "Erros:" SKIP.
    
        FOR EACH tt-erro:
            PUT  STREAM str-excel UNFORMATTED tt-erro.msg-erro SKIP.
        END.
    END.

    IF  VALID-HANDLE(h-bodi159cal) THEN
        DELETE PROCEDURE h-bodi159cal.

    ASSIGN h-bodi159cal = ?.
    
    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.

    CREATE tt-erro.
    ASSIGN tt-erro.msg-erro = c-erro.
END PROCEDURE.
