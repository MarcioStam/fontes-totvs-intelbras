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
    FIELD cod-estabel-ini  AS CHAR
    FIELD cod-local-ini    AS CHAR
    FIELD periodo-ini      AS DATE
    FIELD periodo-fim      AS DATE
    FIELD it-codigo-ini    AS CHAR
    FIELD it-codigo-fim    AS CHAR.

DEF TEMP-TABLE ttResumoItem NO-UNDO
         FIELD id-box            LIKE  wm-box-saldo.id-box
         FIELD ind-status-box    LIKE  wm-box-saldo.ind-status-box
         FIELD ind-status-saldo  LIKE  wm-box-saldo.ind-status-saldo
         FIELD cod-embalagem     LIKE  wm-box-saldo.cod-embalagem
         FIELD qtd-item          LIKE  wm-box-saldo.qtd-item COLUMN-LABEL  "Qtd Item Atual"
         FIELD qtd-item-alocad   LIKE  wms-box-sdo-alocad.qtd-alocad
         FIELD qtd-item-liberado LIKE  wm-box-saldo.qtd-item COLUMN-LABEL "Qtd Item Liberada"
         FIELD RowNum           AS INTEGER
         FIELD r-RowId          AS ROWID
         INDEX w-res01 id-box   
                       cod-embalagem 
                       qtd-item
                       ind-status-saldo.

DEFINE VARIABLE c-dir-saida      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-qt-entrada     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-qt-saida       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-qtd-item       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-qtde-atual     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE da-data-trans    AS DATE        NO-UNDO.
DEFINE VARIABLE h-bosc035        AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-trans          AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "eswmp016_" + STRING(TIME) + ".csv":U.

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

    ASSIGN c-trans = {ininc/i01in218.i 03}.

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
    
    RUN scbo/bosc035.p PERSISTENT SET h-bosc035.
    PUT STREAM str-excel UNFORMATTED "Estabelecimento:;" +  tt-param.cod-estabel-ini SKIP.
    PUT STREAM str-excel UNFORMATTED "Local:;" +  tt-param.cod-local-ini SKIP.
    PUT STREAM str-excel UNFORMATTED "Per¡odo:;" +  STRING(tt-param.periodo-ini) + " at‚ " + STRING(tt-param.periodo-fim) SKIP(1).

    PUT STREAM str-excel UNFORMATTED "Item;Descri‡Æo;Qtde Entrada Per¡odo;Qtde Sa¡da Per¡odo;Curva ABC;Qtde Estoque;Dt Ult Movimenta‡Æo;" SKIP.
    
    FOR EACH wm-item NO-LOCK
       WHERE wm-item.cod-item >= tt-param.it-codigo-ini
         AND wm-item.cod-item <= tt-param.it-codigo-fim:
       
        RUN pi-acompanhar in h-acomp (input wm-item.cod-item).

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = wm-item.cod-item NO-ERROR.

        PUT STREAM str-excel UNFORMATTED wm-item.cod-item + ";".
        PUT STREAM str-excel UNFORMATTED ITEM.desc-item + ";".

        ASSIGN d-qt-entrada = 0
               d-qt-saida   = 0.

        FOR EACH movto-estoq NO-LOCK
           WHERE movto-estoq.cod-estabel = tt-param.cod-estabel-ini
             AND movto-estoq.it-codigo   = wm-item.cod-item
             AND movto-estoq.cod-depos   = tt-param.cod-local-ini
             AND movto-estoq.dt-trans   >= tt-param.periodo-ini
             AND movto-estoq.dt-trans   <= tt-param.periodo-fim:

            IF ENTRY(movto-estoq.tipo-trans,c-trans) = "Entrada"  THEN
                ASSIGN d-qt-entrada = d-qt-entrada + movto-estoq.quantidade.
            ELSE 
                ASSIGN d-qt-saida = d-qt-saida + movto-estoq.quantidade.
        END.

        PUT STREAM str-excel UNFORMATTED STRING(d-qt-entrada) + ";".
        PUT STREAM str-excel UNFORMATTED STRING(d-qt-saida) + ";".
        PUT STREAM str-excel UNFORMATTED {scinc/i09sc044.i 04 wm-item.idi-classif-abc} + ";".
        
        RUN getOcupacaoItem IN h-bosc035 (INPUT tt-param.cod-estabel-ini,
                                          INPUT tt-param.cod-local-ini,
                                          INPUT "0",
                                          INPUT wm-item.cod-item,
                                          INPUT "",
                                          INPUT wm-item.cod-lote,
                                          OUTPUT d-qtde-atual,
                                          OUTPUT TABLE ttResumoItem).

        ASSIGN d-qtd-item = 0.
        FOR EACH ttResumoItem:
            ASSIGN d-qtd-item = d-qtd-item + ttResumoItem.qtd-item.
        END.

        PUT STREAM str-excel UNFORMATTED STRING(d-qtd-item) + ";".

        ASSIGN da-data-trans = ?.
        FOR EACH wm-box-saldo NO-LOCK
           WHERE wm-box-saldo.cod-estabel       = tt-param.cod-estabel-ini
             AND wm-box-saldo.cod-local         = tt-param.cod-local-ini
             AND wm-box-saldo.cod-item          = wm-item.cod-item
             AND wm-box-saldo.cod-cliente       = 0
             AND wm-box-saldo.cod-refer         = ""
             AND wm-box-saldo.cod-lote          = ""
             AND wm-box-saldo.qtd-item          > wm-box-saldo.qtd-item-bloq
             AND wm-box-saldo.ind-status-saldo  = 3 /* liberado */,
           FIRST wm-box NO-LOCK
           WHERE wm-box.cod-estabel       = wm-box-saldo.cod-estabel
             AND wm-box.cod-local         = wm-box-saldo.cod-local
             AND wm-box.id-box            = wm-box-saldo.id-box,
           FIRST wm-tipo-box /* normal */ NO-LOCK
           WHERE (wm-tipo-box.ind-status-box = 1 OR wm-tipo-box.ind-status-box  = 2) 
             AND wm-tipo-box.cdn-tipo-box = wm-box.cdn-tipo-box,                    
           FIRST wm-item-embalagem-local NO-LOCK
           WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
             AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local 
             AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
             AND wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem
              BY wm-box-saldo.dt-transacao    
              BY wm-box-saldo.cod-cliente
              BY wm-box-saldo.cod-estabel
              BY wm-box-saldo.cod-local
              BY wm-box-saldo.cod-item
              BY wm-box-saldo.cod-refer
              BY wm-box-saldo.cod-lote
              BY wm-box-saldo.ind-status-saldo
              BY wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq
              BY wm-box.cod-bloco            
              BY wm-box.cod-rua              
              BY wm-box.cod-coluna           
              BY wm-box.cod-nivel   
              BY wm-item-embalagem-local.qtd-volume.

            ASSIGN da-data-trans = wm-box-saldo.dt-transacao.
            LEAVE.
        END.

        PUT STREAM str-excel UNFORMATTED STRING(da-data-trans) + ";" SKIP.

    END.

    DELETE PROCEDURE h-bosc035.
    ASSIGN h-bosc035 = ?.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.
