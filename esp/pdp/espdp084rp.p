{esp/es0018.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-evento  AS CHARACTER   NO-UNDO.

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
    FIELD dt-prev-ini       LIKE ped-venda.dt-prev
    FIELD dt-prev-fim       LIKE ped-venda.dt-prev
    FIELD cod-emitente-ini  LIKE ped-venda.cod-emitente
    FIELD cod-emitente-fim  LIKE ped-venda.cod-emitente
    FIELD it-codigo-ini     LIKE ped-item.it-codigo
    FIELD it-codigo-fim     LIKE ped-item.it-codigo
    FIELD cod-priori-ini    LIKE ped-venda.cod-priori
    FIELD cod-priori-fim    LIKE ped-venda.cod-priori
    FIELD dat-historico-ini AS DATE
    FIELD dat-historico-fim AS DATE
    FIELD alt-qtd           AS LOG
    FIELD cancel-item       AS LOG
    FIELD itens-eliminados  AS LOG
    FIELD alt-dt-entrega    AS LOG.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "ESPDP084_" + STRING(TIME) + ".csv":U.

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

    PUT STREAM str-excel UNFORMATTED "Estab.;Pedido;Cod. Cliente;Cliente;Atendente;Repres;Nome Repres;Sit. Ped.;Dat Implant;Prev Fat.;Dat. Hist.;Seq Hist.;Item;Segmento;Desc Item;Qtd. Ant.;Qtd Atu.;Dt Entrega;Evento;Usuario Alter" SKIP.

    FOR EACH int-historico-evento NO-LOCK USE-INDEX id-item
        WHERE int-historico-evento.it-codigo           >= tt-param.it-codigo-ini
          AND int-historico-evento.it-codigo           <= tt-param.it-codigo-fim
          AND date(int-historico-evento.dat-historico) >= date(tt-param.dat-historico-ini)
          AND date(int-historico-evento.dat-historico) <= date(tt-param.dat-historico-fim)
         /* AND int-historico-evento.cod-estabel  >= tt-param.cod-estabel-ini   
          AND int-historico-evento.cod-estabel  <= tt-param.cod-estabel-fim   
          AND int-historico-evento.cod-emitente >= tt-param.cod-emitente-ini
          AND int-historico-evento.cod-emitente <= tt-param.cod-emitente-fim */ :

        IF int-historico-evento.cod-estabel  > tt-param.cod-estabel-fim
        OR int-historico-evento.cod-estabel  < tt-param.cod-estabel-ini THEN NEXT.

        IF int-historico-evento.cod-emitente > tt-param.cod-emitente-fim
        OR int-historico-evento.cod-emitente < tt-param.cod-emitente-ini THEN NEXT.

        RUN pi-acompanhar in h-acomp (input string(int-historico-evento.nr-sequencia) + " " + int-historico-evento.it-codigo + " " + STRING(DATE(int-historico-evento.dat-historico))).
          
        FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = int-historico-evento.cod-emitente NO-ERROR.

        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nome-abrev = emitente.nome-abrev
               AND ped-venda.nr-pedcli  = int-historico-evento.nr-pedcli NO-ERROR.

        FIND FIRST repres NO-LOCK
             WHERE repres.nome-abrev = ped-venda.no-ab-reppri NO-ERROR.

        IF AVAIL ped-venda THEN DO:

            IF  int-historico-evento.cod-evento <> 10
            AND int-historico-evento.cod-evento <> 7
            AND int-historico-evento.cod-evento <> 5
            AND int-historico-evento.cod-evento <> 11 THEN
                NEXT.

            IF ped-venda.tp-pedido > tt-param.tp-pedido-fim 
            OR ped-venda.tp-pedido < tt-param.tp-pedido-ini  THEN
                NEXT.

            IF ped-venda.dt-entrega > tt-param.dt-prev-fim 
            OR ped-venda.dt-entrega < tt-param.dt-prev-ini  THEN
                NEXT.

            IF ped-venda.cod-priori > tt-param.cod-priori-fim 
            OR ped-venda.cod-priori < tt-param.cod-priori-ini  THEN
                NEXT.

            IF  NOT tt-param.alt-qtd
            AND int-historico-evento.cod-evento = 10 THEN 
                NEXT.

            IF  NOT tt-param.cancel-item 
            AND int-historico-evento.cod-evento = 5 THEN  
                NEXT.

            IF  NOT tt-param.itens-eliminados 
            AND int-historico-evento.cod-evento = 7 THEN  
                NEXT.

            IF NOT tt-param.alt-dt-entrega
            AND int-historico-evento.cod-evento = 11 THEN
                NEXT.

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = int-historico-evento.it-codigo NO-ERROR.

            IF int-historico-evento.cod-evento = 10 THEN
                ASSIGN c-cod-evento = "Altera‡Æo de quantidade".
                 
            IF int-historico-evento.cod-evento = 5 THEN
                ASSIGN c-cod-evento = "Cancelamento de Item". 
            
            IF int-historico-evento.cod-evento = 7 THEN 
                ASSIGN c-cod-evento = "Itens eliminados do pedido".

            IF int-historico-evento.cod-evento = 11 THEN 
                ASSIGN c-cod-evento = "Alteracao data entrega do item" .

            PUT STREAM str-excel UNFORMATTED int-historico-evento.cod-estabel ";"
                                             int-historico-evento.nr-pedcli   ";"
                                             ped-venda.cod-emitente           ";"
                                             ped-venda.nome-abrev             ";"
                                             ped-venda.cod-priori             ";"
                                             repres.cod-rep                   ";"
                                             ped-venda.no-ab-reppri           ";"
                                             {diinc/i03di149.i 04 ped-venda.cod-sit-ped} ";"
                                             ped-venda.dt-implant             ";"
                                             ped-venda.dt-entrega                ";"
                                             DATE(int-historico-evento.dat-historico) ";"
                                             int-historico-evento.nr-sequencia ";"
                                             int-historico-evento.it-codigo    ";"
                                             substring(item.fm-cod-com,1,4)    ";"
                                             ITEM.desc-item                    ";"
                                             int-historico-evento.qt-anterior  ";"
                                             int-historico-evento.qtd-pedida   ";"
                                             int-historico-evento.dat-1        ";"
                                             c-cod-evento                      ";" 
                                             int-historico-evento.cod-usuario  SKIP.
        END.  
    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.
