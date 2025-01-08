{include/i-prgvrs.i esccp044rp 2.00.00.001}

{esp/es0018.i}

DEFINE VARIABLE c-arquivo-csv  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp        AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-situacao     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-estado       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dt-entrada-fim AS CHAR        NO-UNDO.
DEFINE VARIABLE de-qtde-atu      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-depos          AS CHARACTER   NO-UNDO.

DEFINE STREAM str-excel.

DEFINE BUFFER empresa FOR mgcad.empresa.

define temp-table tt-param no-undo
    field destino             as integer
    field arquivo             as char format "x(35)"
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field classifica          as integer
    field desc-classifica     as char format "x(40)"
    field modelo-rtf          as char format "x(35)"
    field l-habilitaRtf       as LOG
    FIELD it-codigo-ini       LIKE ITEM.it-codigo
    FIELD it-codigo-fim       LIKE ITEM.it-codigo
    FIELD ativo               AS LOG
    FIELD obsoleto-aut        AS LOG
    FIELD obsoleto-todas      AS LOG
    FIELD totalmente-obsoleto AS LOG.
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "ESCCP044_" + STRING(TIME) + ".csv":U.

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
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
    
    PUT STREAM str-excel UNFORMATTED "Item;Descri‡Æo;Situa‡Æo;Cod Frabric;Descri‡Æo Fabric;PN do fabricante;Estado;Dt.Implant;Dt.Ultima Entr;Maior Saldo Estoq;Depos" SKIP.

    FOR EACH item-fabric NO-LOCK
       WHERE item-fabric.it-codigo >= tt-param.it-codigo-ini
         AND item-fabric.it-codigo <= tt-param.it-codigo-fim,
        FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = item-fabric.it-codigo
        BREAK BY item-fabric.it-codigo:

        ASSIGN c-depos           = ''
               de-qtde-atu       = 0
               c-dt-entrada-fim  = ''.

        FOR EACH recebimento USE-INDEX ITEM 
            WHERE recebimento.it-codigo = item-fabric.it-codigo
            BY recebimento.data-movto DESC:
            ASSIGN c-dt-entrada-fim = STRING(recebimento.data-movto,'99/99/9999').
            LEAVE.
        END.

        FOR EACH saldo-estoq NO-LOCK 
            WHERE saldo-estoq.it-codigo = item-fabric.it-codigo:
            IF de-qtde-atu < saldo-estoq.qtidade-atu THEN
               ASSIGN de-qtde-atu = saldo-estoq.qtidade-atu
                      c-depos     = saldo-estoq.cod-depos.
        END.

        /*Filtro Situa‡Æo*/
        IF  ITEM.cod-obsoleto = 1
        AND NOT tt-param.ativo THEN
            NEXT.

        IF  ITEM.cod-obsoleto = 2
        AND NOT tt-param.obsoleto-aut THEN
            NEXT.

        IF  ITEM.cod-obsoleto = 3
        AND NOT tt-param.obsoleto-todas THEN
            NEXT.

        IF  ITEM.cod-obsoleto = 4
        AND NOT tt-param.totalmente-obsoleto THEN
            NEXT.

        RUN pi-acompanhar IN h-acomp (INPUT "Item: " + item-fabric.it-codigo).

        ASSIGN c-estado = "Inativo".

        FIND FIRST fabricante NO-LOCK
             WHERE fabricante.cod-fabric = item-fabric.cod-fabric NO-ERROR.

        IF AVAIL fabricante THEN DO:
           /*Estado*/
           IF fabricante.ativo THEN
               ASSIGN c-estado = "Ativo".
           ELSE
               ASSIGN c-estado = "Inativo".
        END.

        /*Situa‡Æo*/
        IF ITEM.cod-obsoleto = 1 THEN
            ASSIGN c-situacao = "Ativo".
        ELSE IF ITEM.cod-obsoleto = 2 THEN
            ASSIGN c-situacao = "Obsoleto ordens autom ticas".
        ELSE IF ITEM.cod-obsoleto = 3 THEN
            ASSIGN c-situacao = "Obsoleto todas as ordens".
        ELSE IF ITEM.cod-obsoleto = 4 THEN
            ASSIGN c-situacao = "Totalmente Obsoleto".

        
        /*ImpressÆo*/
        PUT STREAM str-excel UNFORMATTED ITEM.it-codigo                          + ";" +
                                         REPLACE(ITEM.desc-item,";",",")         + ";" +
                                         c-situacao                              + ";" +
                                         REPLACE(STRING(item-fabric.cod-fabric),";",",") + ";" +
                                         REPLACE(fabricante.nome-abrev,";",",")  + ";" +
                                         REPLACE(item-fabric.it-fabric,";",",")  + ";" +
                                         c-estado                                + ";" + 
                                         STRING(ITEM.data-implant,'99/99/9999')  + ";" +
                                         STRING(c-dt-entrada-fim)                + ";" +
                                         STRING(de-qtde-atu)                     + ";" + 
                                         c-depos SKIP.
        
    END.
    
    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.
