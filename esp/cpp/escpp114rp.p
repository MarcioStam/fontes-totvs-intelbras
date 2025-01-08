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
DEFINE VARIABLE c-integracao-item   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE c-resultado         AS CHARACTER  NO-UNDO.

DEFINE TEMP-TABLE tt-param no-undo
       FIELD destino          AS INTEGER
       FIELD arquivo          AS CHAR FORMAT "x(35)"
       FIELD usuario          AS CHAR FORMAT "x(12)"
       FIELD data-exec        AS DATE
       FIELD hora-exec        AS INTEGER
       FIELD classifica       AS INTEGER
       FIELD desc-classifica  AS CHAR FORMAT "x(40)"
       FIELD modelo-rtf       AS CHAR FORMAT "x(35)"
       FIELD l-habilitaRtf    AS LOG.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-item-csv = "escpp114_item_" + REPLACE(STRING(TODAY,'99/99/9999'),'/','') + REPLACE(STRING(TIME,'HH:MM'),':','') + ".csv":U.
    
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
        ASSIGN c-integracao-item = c-dir-saida + TRIM(c-arquivo-item-csv).
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
        ASSIGN c-integracao-item = c-dir-saida + TRIM(c-arquivo-item-csv).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    OUTPUT STREAM str-excel TO value(c-integracao-item) NO-CONVERT.

    PUT STREAM str-excel UNFORMATTED  "Item;Descricao;Resultado" SKIP.

    FOR EACH ITEM NO-LOCK
        WHERE ITEM.data-implant >= TODAY - 90
        AND ITEM.compr-fabr = 2 :

        RUN pi-acompanhar in h-acomp (INPUT "Integracao Item: " + STRING(ITEM.it-codigo)).

        RUN esapi\esapi026.p (INPUT ITEM.it-codigo,OUTPUT c-resultado). 
        RUN esapi\esapi029.p (INPUT ITEM.it-codigo,OUTPUT c-resultado). 

        PUT STREAM str-excel UNFORMATTED ITEM.it-codigo + ";" +
                                         ITEM.desc-item + ";" +
                                         c-resultado 
                                         SKIP.
    END.

    RUN pi-finalizar IN h-acomp.

    OUTPUT STREAM str-excel CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-integracao-item).
    END.

    RETURN "OK".   
END.
