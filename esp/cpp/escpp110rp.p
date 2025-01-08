/***********************************************************************
**  Programa..: esp/cpp/escpp110rp.p
**  Autor.....: Nicolas Martinez
**  Data......: Setembro/2020 - Desenvolvimento
**  Descricao.: Relatorio itens por homologa‡Æo Anatel
**  Versao....: 001 21/09/2020
**                  Desenvolvimento Programa
************************************************************************/

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
    FIELD it-codigo-ini    AS CHAR
    FIELD it-codigo-fim    AS CHAR
    FIELD homolog-ini      AS CHAR
    FIELD homolog-fim      AS CHAR.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "escpp110_" + STRING(TIME) + ".csv":U.

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

    PUT  STREAM str-excel UNFORMATTED  "Item;Descri‡Æo;Homologa‡Æo;Data Venc Homologa‡Æo" SKIP.

    FOR EACH int-item WHERE
             int-item.it-codigo >= tt-param.it-codigo-ini AND
             int-item.it-codigo <= tt-param.it-codigo-fim
             NO-LOCK,
        EACH item-ean WHERE
             item-ean.it-codigo = int-item.it-codigo   AND
             item-ean.homolog  >= tt-param.homolog-ini AND
             item-ean.homolog  <= tt-param.homolog-fim
             NO-LOCK.

        RUN pi-acompanhar in h-acomp (input "Imprimindo Item: " + STRING(int-item.it-codigo)).

        FIND FIRST ITEM WHERE
                   ITEM.it-codigo = int-item.it-codigo
                   NO-LOCK NO-ERROR.

        IF NOT AVAIL ITEM THEN NEXT.

        PUT STREAM str-excel UNFORMATTED int-item.it-codigo           + ";" +
                                         ITEM.desc-item               + ";" +
                                         //IF AVAIL item-ean THEN item-ean.homolog ELSE "" + ";" +
                                         item-ean.homolog             + ";" +
                                         IF int-item.dt-venc-homologacao = ? THEN "" ELSE  string(int-item.dt-venc-homologacao)
                                         SKIP.

    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK".   
END.
