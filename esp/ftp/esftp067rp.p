 
{esp/es0018.i}

DEFINE VARIABLE c-arquivo-csv  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp        AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-prev-entrega AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-prev-entrega AS DATE        NO-UNDO.
DEFINE VARIABLE c-cod-transp   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-transp  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-emit    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mod-frete    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-obs          AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-nota-fiscal FOR nota-fiscal.

DEFINE STREAM str-excel.

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
    FIELD dt-emis-nota-ini  AS DATE
    FIELD dt-emis-nota-fim  AS DATE.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esftp067_" + STRING(TIME) + ".csv":U.

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
    
    PUT STREAM str-excel UNFORMATTED "Estabelecimento;Nota;Serie;C¢d. Emit.;Nome Emitente;UF;Cidade;DT EmissÆo;DT Embarque;DT PrevisÆo de Entrega;Pedido;C¢d. Transp;Transportadora;Modalidade de frete;Observa‡Æo do pedido;" SKIP.

    FOR EACH nota-fiscal NO-LOCK
       WHERE nota-fiscal.dt-emis-nota >= tt-param.dt-emis-nota-ini
         AND nota-fiscal.dt-emis-nota <= tt-param.dt-emis-nota-fim
         AND nota-fiscal.dt-cancel     = ?
         AND nota-fiscal.emite-duplic  = YES:

        FIND FIRST transporte NO-LOCK
             WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.

        FIND FIRST int-transporte NO-LOCK
             WHERE int-transporte.cod-transp = transporte.cod-transp NO-ERROR.

        IF  AVAIL int-transporte 
        AND int-transporte.ind-cons-dt-entrega THEN DO:
            IF nota-fiscal.dt-entr-cli = ? THEN DO:
                IF nota-fiscal.dt-embarque <> ? THEN DO:
                    FIND FIRST b-nota-fiscal OF nota-fiscal EXCLUSIVE-LOCK.
                    ASSIGN b-nota-fiscal.dt-entr-cli = nota-fiscal.dt-embarque.
                    RELEASE b-nota-fiscal.
                END.
                ELSE DO:
                    /*verificar esta regra*/
                    IF nota-fiscal.dt-emis-nota < TODAY - 10 THEN DO:
                        FIND FIRST b-nota-fiscal OF nota-fiscal EXCLUSIVE-LOCK.
                        ASSIGN b-nota-fiscal.dt-entr-cli = nota-fiscal.dt-emis-nota.
                        RELEASE b-nota-fiscal.
                    END.
                END.
            END.
        END.
        ELSE DO:
            IF nota-fiscal.dt-entr-cli = ? THEN DO:
                FIND FIRST int-nota-fiscal NO-LOCK
                     WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel   
                       AND int-nota-fiscal.serie       = nota-fiscal.serie         
                       AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.

                FIND FIRST emitente NO-LOCK
                     WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

                FIND FIRST ped-venda NO-LOCK
                     WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.

               FIND FIRST modalid-frete NO-LOCK
                    WHERE modalid-frete.cod-modalid-frete = SUBSTRING(ped-venda.char-2,109,8) NO-ERROR.

                ASSIGN c-prev-entrega = IF AVAIL int-nota-fiscal THEN SUBSTRING(int-nota-fiscal.char-1,50,10) ELSE ""
                       d-prev-entrega = date(c-prev-entrega)
                       c-cod-transp   = IF AVAIL transporte      THEN STRING(transporte.cod-transp)           ELSE ""
                       c-nome-transp  = IF AVAIL transporte      THEN transporte.nome                         ELSE ""
                       c-nome-emit    = IF AVAIL emitente        THEN emitente.nome-emit                      ELSE ""
                       c-mod-frete    = IF AVAIL modalid-frete   THEN modalid-frete.des-modalid-frete         ELSE ""   
                       c-obs          = IF AVAIL ped-venda       THEN ped-venda.observacoes                   ELSE ""
                       c-obs          = REPLACE(c-obs,CHR(10)," ")
                       c-obs          = REPLACE(c-obs,CHR(11)," ")
                       c-obs          = REPLACE(c-obs,CHR(12)," ")
                       c-obs          = REPLACE(c-obs,CHR(13)," ").

                PUT STREAM str-excel UNFORMATTED IF nota-fiscal.cod-estabel  <> ? THEN STRING(nota-fiscal.cod-estabel )  + ";"  ELSE ";"
                                                 IF nota-fiscal.nr-nota-fis  <> ? THEN STRING(nota-fiscal.nr-nota-fis )  + ";"  ELSE ";"
                                                 IF nota-fiscal.serie        <> ? THEN STRING(nota-fiscal.serie       )  + ";"  ELSE ";"   
                                                 IF nota-fiscal.cod-emitente <> ? THEN STRING(nota-fiscal.cod-emitente)  + ";"  ELSE ";"   
                                                 IF c-nome-emit              <> ? THEN STRING(c-nome-emit             )  + ";"  ELSE ";"   
                                                 IF nota-fiscal.estado       <> ? THEN STRING(nota-fiscal.estado      )  + ";"  ELSE ";"   
                                                 IF nota-fiscal.cidade       <> ? THEN STRING(nota-fiscal.cidade      )  + ";"  ELSE ";"
                                                 IF nota-fiscal.dt-emis-nota <> ? THEN STRING(nota-fiscal.dt-emis-nota,"99/99/9999")  + ";"  ELSE ";"
                                                 IF nota-fiscal.dt-embarque  <> ? THEN STRING(nota-fiscal.dt-embarque ,"99/99/9999")  + ";"  ELSE ";"
                                                 IF d-prev-entrega           <> ? THEN STRING(d-prev-entrega          ,"99/99/9999")  + ";"  ELSE ";"
                                                 IF nota-fiscal.nr-pedcli    <> ? THEN STRING(nota-fiscal.nr-pedcli   )  + ";"  ELSE ";"  
                                                 IF c-cod-transp             <> ? THEN STRING(c-cod-transp            )  + ";"  ELSE ";"
                                                 IF c-nome-transp            <> ? THEN STRING(c-nome-transp           )  + ";"  ELSE ";"
                                                 IF c-mod-frete              <> ? THEN STRING(c-mod-frete             )  + ";"  ELSE ";"
                                                 IF c-obs                    <> ? THEN STRING(c-obs                   )  + ";"  ELSE ";" .
                PUT STREAM str-excel SKIP.

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
