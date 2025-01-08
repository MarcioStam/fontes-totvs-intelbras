{include/i-prgvrs.i esftp213rp 2.00.00.001}
{esp/es0018.i}
{esp/imp/esimp000.i1} /*tt-emb*/
{method/dbotterr.i}
{utp/ut-glob.i}

DEFINE BUFFER b-historico-embarque FOR historico-embarque. /*Ponto de Entrega (Despacho)*/
DEFINE BUFFER b-ordem-compra       FOR ordem-compra.
DEFINE BUFFER b1-historico-embarque FOR historico-embarque.

DEFINE VARIABLE c-arquivo-csv    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp          AS HANDLE      NO-UNDO.
DEFINE VARIABLE dt-ini           AS DATE        NO-UNDO.
DEFINE VARIABLE dt-fim           AS DATE        NO-UNDO.
DEFINE VARIABLE d-dt-entrega     AS DATE        NO-UNDO.
DEFINE VARIABLE d-dt-entrega-aux AS DATE        NO-UNDO.
DEFINE VARIABLE l-achou          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v-embarque       LIKE embarque-imp.embarque     NO-UNDO.

DEFINE VARIABLE h-bocx225 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx404 AS HANDLE      NO-UNDO.
DEFINE VARIABLE r-rowid   AS ROWID       NO-UNDO.
DEFINE VARIABLE l-integra-di AS LOGICAL     NO-UNDO.

DEFINE STREAM str-excel.
DEFINE BUFFER empresa FOR emscad.empresa.

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
    FIELD num-pedido   LIKE ordem-compra.num-pedido
    FIELD numero-ordem LIKE ordem-compra.numero-ordem
    FIELD parcela      LIKE prazo-compra.parcela
    FIELD data         AS DATE COLUMN-LABEL "Data"
    FIELD nf           AS CHAR COLUMN-LABEL "NF"
    FIELD acao         AS CHAR.
   
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esccp002_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.

DO ON STOP UNDO, LEAVE:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Integrando ...").

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

    RUN pi-executa.

    PUT STREAM str-excel UNFORMATTED "Pedido;Ordem Compra;Parcela;A‡Æo;" SKIP.

    FOR EACH tt-digita:
        PUT STREAM str-excel UNFORMATTED STRING(tt-digita.num-pedido) + ";". 
        PUT STREAM str-excel UNFORMATTED STRING(tt-digita.numero-ordem)  + ";".
        PUT STREAM str-excel UNFORMATTED STRING(tt-digita.parcela)  + ";".
        PUT STREAM str-excel UNFORMATTED STRING(tt-digita.acao) ";" SKIP.
    END.
    
    OUTPUT STREAM str-excel CLOSE.
    
    RUN pi-finalizar IN h-acomp.
    
    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.

PROCEDURE pi-executa:
    
    blk_dig:
    FOR EACH tt-digita:

        RUN pi-acompanhar in h-acomp (input "Processando Ordem: " + string(tt-digita.numero-ordem)).

        RUN pi-altera-parcela(INPUT tt-digita.numero-ordem,
                              INPUT tt-digita.parcela,
                              INPUT tt-digita.data,
                              INPUT tt-digita.nf).
    END.
END.

PROCEDURE pi-altera-parcela:
    DEFINE INPUT PARAM p-numero-ordem LIKE ordens-embarque.numero-ordem.
    DEFINE INPUT PARAM p-parcela      LIKE ordens-embarque.parcela.
    DEFINE INPUT PARAM p-data-entrega LIKE prazo-compra.data-entrega.
    DEFINE INPUT PARAM p-nf           AS CHAR.


    /*Busca a ordem das parcelas*/
    FIND FIRST ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = p-numero-ordem NO-ERROR.
    
    FIND FIRST prazo-compra EXCLUSIVE-LOCK USE-INDEX ordem
         WHERE prazo-compra.numero-ordem = p-numero-ordem
           AND prazo-compra.parcela      = p-parcela NO-ERROR.

    IF  AVAIL prazo-compra THEN DO:
        IF prazo-compra.data-entrega <> p-data-entrega THEN DO:
            ASSIGN tt-digita.acao = "Alterado data de " + STRING(data-entrega) + " para " + STRING(p-data-entrega) + ".".
        
            ASSIGN prazo-compra.data-entrega-ant = prazo-compra.data-entrega
                   prazo-compra.data-entrega     = p-data-entrega.
            
            CREATE alt-ped.
            ASSIGN alt-ped.num-pedido   = ordem-compra.num-pedido
                   alt-ped.numero-ordem = ordem-compra.numero-ordem
                   alt-ped.parcela      = prazo-compra.parcela
                   alt-ped.data         = TODAY
                   alt-ped.hora         = STRING(time,"hh:mm:ss")
                   alt-ped.usuario      = c-seg-usuario
                   alt-ped.data-entrega = prazo-compra.data-entrega
                   alt-ped.observacao   = c-seg-usuario + ": " + "Alterado data de entrega esccp002. "
                   alt-ped.quantidade   = prazo-compra.quantidade
                   alt-ped.cod-cond-pag = ?. 
        END.

        IF p-nf <> "" THEN DO:
           FIND FIRST int-prazo-compra EXCLUSIVE-LOCK
                WHERE int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                  AND int-prazo-compra.parcela      = prazo-compra.parcela NO-ERROR.
           IF NOT AVAIL int-prazo-compra THEN DO:
              CREATE int-prazo-compra.
              ASSIGN int-prazo-compra.numero-ordem = prazo-compra.numero-ordem
                     int-prazo-compra.parcela      = prazo-compra.parcela.
           END.
           ASSIGN int-prazo-compra.nro-docto = p-nf.
           ASSIGN tt-digita.acao = "Incluido nr da NF " + STRING(p-nf) + ".".
           FIND CURRENT int-prazo-compra NO-LOCK NO-ERROR.
        END.
        
    END.

    FIND CURRENT prazo-compra NO-LOCK NO-ERROR.

    RETURN "OK".

END PROCEDURE.
