/***********************************************************************
**  Programa..: esp/cpp/escpp114rp.p
**  Autor.....: Isac Abahao
**  Data......: Junho/2021 - Desenvolvimento
**  Descricao.: Integracao Item Datasul x MES
**  Versao....: 001 24/06/2021
**                  Desenvolvimento Programa
************************************************************************/
{esp/es0018.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-item-csv AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-acomp             AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-arq-item-uf       AS CHARACTER  NO-UNDO.

DEFINE VARIABLE c-resultado         AS CHARACTER  NO-UNDO.

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
    FIELD uf-origem-ini    AS CHAR
    FIELD uf-origem-fim    AS CHAR
    FIELD uf-destino-ini   AS CHAR  
    FIELD uf-destino-fim   AS CHAR  
    FIELD item-ini         AS CHAR
    FIELD item-fim         AS CHAR
    FIELD classif-ini      AS CHAR
    FIELD classif-fim      AS CHAR.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-item-csv = "escdp096_" + REPLACE(STRING(TODAY,'99/99/9999'),'/','') + REPLACE(STRING(TIME,'HH:MM'),':','') + ".csv":U.
    
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
        ASSIGN c-arq-item-uf = c-dir-saida + TRIM(c-arquivo-item-csv).
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
        ASSIGN c-arq-item-uf = c-dir-saida + TRIM(c-arquivo-item-csv).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    OUTPUT STREAM str-excel TO value(c-arq-item-uf) NO-CONVERT.

    PUT STREAM str-excel UNFORMATTED  "UF Orig;UF Dest;Item;Descricao;NCM;Aliq ICMS" SKIP.

    FOR EACH relacto-item-uf-aliq NO-LOCK
        WHERE relacto-item-uf-aliq.cod-item    >= tt-param.item-ini 
          AND relacto-item-uf-aliq.cod-item    <= tt-param.item-fim
          AND relacto-item-uf-aliq.cod-uf-orig >= tt-param.uf-origem-ini
          AND relacto-item-uf-aliq.cod-uf-orig <= tt-param.uf-origem-fim
          AND relacto-item-uf-aliq.cod-uf-dest >= tt-param.uf-destino-ini
          AND relacto-item-uf-aliq.cod-uf-dest <= tt-param.uf-destino-fim,
        FIRST ITEM NO-LOCK
              WHERE ITEM.it-codigo  = relacto-item-uf-aliq.cod-item
                AND ITEM.class-fisc >= tt-param.classif-ini 
                AND ITEM.class-fisc <= tt-param.classif-fim:

        RUN pi-acompanhar in h-acomp (INPUT "UF Orig / UF Dest / Item: " + STRING(ITEM.it-codigo) + ' / ' + 
                                             relacto-item-uf-aliq.cod-uf-orig + ' / ' + 
                                             relacto-item-uf-aliq.cod-uf-dest).

        PUT STREAM str-excel UNFORMATTED 
            relacto-item-uf-aliq.cod-uf-orig + ";" +
            relacto-item-uf-aliq.cod-uf-dest + ";" +
            relacto-item-uf-aliq.cod-item    + ";" +
            ITEM.desc-item                   + ";" +
            ITEM.class-fisc                  + ";" +
            STRING(relacto-item-uf-aliq.val-aliq) SKIP.


        /*
        PUT STREAM str-excel UNFORMATTED ITEM.it-codigo + ";" +
                                         ITEM.desc-item + ";" +
                                         c-resultado 
                                         SKIP.*/
    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
       DOS SILENT START excel VALUE(c-arq-item-uf).
    END.

    RETURN "OK".   
END.

