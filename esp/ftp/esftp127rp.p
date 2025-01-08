{esp/es0018.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-aux        AS DATE        NO-UNDO.

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
    FIELD cod-estabel-ini  LIKE nota-fiscal.cod-estabel
    FIELD cod-estabel-fim  LIKE nota-fiscal.cod-estabel
    FIELD dt-emis-ini      LIKE nota-fiscal.dt-emis
    FIELD dt-emis-fim      LIKE nota-fiscal.dt-emis.

def temp-table tt-item
    field dt-mes        as date
    field it-codigo like item.it-codigo
    field cod-estabel   like nota-fiscal.cod-estabel
    field qtd-fat      as integer
    field qtd-retorno  as integer.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "ESFTP127_" + STRING(TIME) + ".csv":U.

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

    PUT  STREAM str-excel UNFORMATTED  "Periodo; Estab.;Produto;Descri‡Æo;Qtd. Faturada;" SKIP.
    
    
    FOR EACH nota-fiscal NO-LOCK
       WHERE nota-fiscal.dt-emis >= tt-param.dt-emis-ini
         AND nota-fiscal.dt-emis <= tt-param.dt-emis-fim
         AND nota-fiscal.dt-cancel = ?
         AND nota-fiscal.idi-sit-nf-eletro = 3 : /* autorizadas */
         
        RUN pi-acompanhar in h-acomp (INPUT "Lendo notas: " + STRING(nota-fiscal.dt-emis,"99/99/9999")).

        ASSIGN dt-aux = DATE(MONTH(nota-fiscal.dt-emis),01,YEAR(nota-fiscal.dt-emis)) + 33
               dt-aux = DATE(MONTH(dt-aux),01,YEAR(dt-aux)) - 1.

        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
               AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
              
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-pedido  = ped-venda.nr-pedcli
               AND ord-prod.nome-abrev = ped-venda.nome-abrev NO-ERROR.

        IF AVAIL ord-prod THEN DO:      
            FOR EACH reservas NO-LOCK
               WHERE reservas.nr-ord-prod = ord-prod.nr-ord-prod:
               
                FIND FIRST tt-item  
                     WHERE tt-item.dt-mes      = dt-aux
                       AND tt-item.cod-estabel = nota-fiscal.cod-estabel
                       AND tt-item.it-codigo   = reservas.it-codigo NO-ERROR.
            
                IF NOT AVAIL tt-item THEN DO:
                   CREATE tt-item.
                   ASSIGN tt-item.dt-mes      = dt-aux
                          tt-item.cod-estabel = nota-fiscal.cod-estabel
                          tt-item.it-codigo   = reservas.it-codigo.
                END.
                ASSIGN tt-item.qtd-fat = tt-item.qtd-fat + reservas.quant-requis.
            END.
        END.
    END.
             
    FOR EACH tt-item:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = tt-item.it-codigo NO-ERROR.

        PUT  STREAM str-excel UNFORMATTED STRING(tt-item.dt-mes      ) + ";" +
                                          STRING(tt-item.cod-estabel ) + ";" +
                                          STRING(tt-item.it-codigo   ) + ";" +
                                          STRING(ITEM.desc-item      ) + ";" +
                                          STRING(tt-item.qtd-fat     ) skip.
    END.         

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.
