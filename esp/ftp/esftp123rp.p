{esp/es0018.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD cod-estab-ini   LIKE sdo-fatur-antecip.cod-estabel
    FIELD cod-estab-fim   LIKE sdo-fatur-antecip.cod-estabel
    FIELD serie-ini       LIKE sdo-fatur-antecip.serie
    FIELD serie-fim       LIKE sdo-fatur-antecip.serie
    FIELD nr-nota-fis-ini LIKE sdo-fatur-antecip.nr-nota-fis
    FIELD nr-nota-fis-fim LIKE sdo-fatur-antecip.nr-nota-fis
    FIELD nat-operacao-ini LIKE sdo-fatur-antecip.nat-operacao
    FIELD nat-operacao-fim LIKE sdo-fatur-antecip.nat-operacao
    FIELD cod-emitente-ini LIKE sdo-fatur-antecip.cod-emitente
    FIELD cod-emitente-fim LIKE sdo-fatur-antecip.cod-emitente
    FIELD it-codigo-ini LIKE sdo-fatur-antecip.it-codigo
    FIELD it-codigo-fim LIKE sdo-fatur-antecip.it-codigo
    FIELD dt-emis-ini LIKE nota-fiscal.dt-emis
    FIELD dt-emis-fim LIKE nota-fiscal.dt-emis
    FIELD analit-sintet AS INT
    FIELD saldo-zerado AS LOG.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esftp123_" + STRING(TIME) + ".csv":U.

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

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.


    
    PUT  STREAM str-excel UNFORMATTED  "Cod. Estabel;Serie;Nr. Nota;Cod. Emitente;Nome Abrev.;Nat. Operacao;Item;Dt. Saldo;Qtd. Saldo;".

    IF tt-param.analit-sintet = 2 THEN 
        PUT STREAM str-excel  UNFORMATTED "Qtd. Movto.;Dt. Movto.; Tp. Movto.;Det. Trans.;Estab.;Serie;Nr. Nota;Nat.Operacao;".

    PUT STREAM str-excel SKIP.

    FOR EACH sdo-fatur-antecip NO-LOCK
        WHERE sdo-fatur-antecip.cod-estabel  >= tt-param.cod-estab-ini
          AND sdo-fatur-antecip.cod-estabel  <= tt-param.cod-estab-fim
          AND sdo-fatur-antecip.serie        >= tt-param.serie-ini
          AND sdo-fatur-antecip.serie        <= tt-param.serie-fim
          AND sdo-fatur-antecip.nr-nota-fis  >= tt-param.nr-nota-fis-ini
          AND sdo-fatur-antecip.nr-nota-fis  <= tt-param.nr-nota-fis-fim
          AND sdo-fatur-antecip.nat-operacao >= tt-param.nat-operacao-ini
          AND sdo-fatur-antecip.nat-operacao <= tt-param.nat-operacao-fim
          AND sdo-fatur-antecip.cod-emitente >= tt-param.cod-emitente-ini
          AND sdo-fatur-antecip.cod-emitente <= tt-param.cod-emitente-fim
          AND sdo-fatur-antecip.it-codigo    >= tt-param.it-codigo-ini
          AND sdo-fatur-antecip.it-codigo    <= tt-param.it-codigo-fim:

        RUN pi-acompanhar IN h-acomp (INPUT sdo-fatur-antecip.nr-nota-fis + "/" + sdo-fatur-antecip.serie).

        FIND FIRST nota-fiscal NO-LOCK
             WHERE nota-fiscal.cod-estabel = sdo-fatur-antecip.cod-estabel
               AND nota-fiscal.serie       = sdo-fatur-antecip.serie
               AND nota-fiscal.nr-nota-fis = sdo-fatur-antecip.nr-nota-fis NO-ERROR.

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = sdo-fatur-antecip.cod-emitente NO-ERROR.
        
        IF nota-fiscal.dt-emis < tt-param.dt-emis-ini OR nota-fiscal.dt-emis > tt-param.dt-emis-fim THEN
            NEXT.

        IF  NOT tt-param.saldo-zerado 
        AND sdo-fatur-antecip.qtd-saldo = 0 THEN
            NEXT.
                                                              
        IF tt-param.analit-sintet = 1 THEN DO:
            PUT STREAM str-excel UNFORMATTED sdo-fatur-antecip.cod-estabel          + ";" + 
                                             sdo-fatur-antecip.serie                + ";" +
                                             sdo-fatur-antecip.nr-nota-fis          + ";" +
                                             STRING(sdo-fatur-antecip.cod-emitente) + ";" +
                                             emitente.nome-abrev                    + ";" +
                                             sdo-fatur-antecip.nat-operacao         + ";" +
                                             sdo-fatur-antecip.it-codigo            + ";" +
                                             STRING(sdo-fatur-antecip.dt-atualiza)  + ";" +
                                             STRING(sdo-fatur-antecip.qtd-saldo) SKIP.
        END.
        ELSE DO:
            FOR EACH movto-fatur-antecip NO-LOCK
               WHERE movto-fatur-antecip.num-id-sdo = sdo-fatur-antecip.num-id-sdo:

                PUT STREAM str-excel  UNFORMATTED  sdo-fatur-antecip.cod-estabel          + ";" + 
                                                   sdo-fatur-antecip.serie                + ";" +
                                                   sdo-fatur-antecip.nr-nota-fis          + ";" +
                                                   STRING(sdo-fatur-antecip.cod-emitente) + ";" +
                                                   emitente.nome-abrev                    + ";" +
                                                   sdo-fatur-antecip.nat-operacao         + ";" +
                                                   sdo-fatur-antecip.it-codigo            + ";" +
                                                   STRING(sdo-fatur-antecip.dt-atualiza)  + ";" +
                                                   STRING(sdo-fatur-antecip.qtd-saldo)  + ";" +
                                                   STRING(movto-fatur-antecip.qtd-movto) + ";" + 
                                                   STRING(movto-fatur-antecip.dt-movto)  + ";" +
                                                   {diinc/i01di580.i 04 movto-fatur-antecip.tp-movto}     + ";" +
                                                   {diinc/i02di580.i 04 movto-fatur-antecip.idi-det-trans} + ";" +
                                                   movto-fatur-antecip.cod-estabel + ";" +
                                                   movto-fatur-antecip.serie       + ";" +
                                                   movto-fatur-antecip.nr-nota-fis + ";" +
                                                   movto-fatur-antecip.nat-operacao SKIP.
            END.
        END.
    END.
    

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.
