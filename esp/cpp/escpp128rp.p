/***********************************************************************
**  Programa..: esp/cpp/escpp128rp.p
**  Autor.....: Isac Abrahao
**  Data......: Fevereiro/2021 - Desenvolvimento
**  Descricao.: Impressao Cameras Testadas e Gravadas 
**  Versao....: 001 07/02/2023
**                  Desenvolvimento Programa
************************************************************************/
{esp/es0018.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-saida-csv   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arquivo-saida AS CHARACTER   NO-UNDO.


DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)"
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf       AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf    AS LOG
    FIELD n-serie-ini      AS CHAR 
    FIELD n-serie-fim      AS CHAR 
    FIELD data-imp-ini     AS DATE
    FIELD data-imp-fim     AS DATE
    FIELD data-reimp-ini   AS DATE
    FIELD data-reimp-fim   AS DATE
    FIELD item-ini         AS CHAR
    FIELD item-fim         AS CHAR.


DEFINE VARIABLE c-dir-saida AS CHARACTER NO-UNDO.

DEFINE VARIABLE dt-geracao AS DATE NO-UNDO.
DEFINE VARIABLE hr-geracao AS CHAR NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-saida-csv = "escpp128_"   + REPLACE(STRING(TODAY,'99/99/9999'),'/','') + REPLACE(STRING(TIME,'HH:MM'),':','') + ".csv":U.

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
        ASSIGN c-arquivo-saida = c-dir-saida + TRIM(c-arquivo-saida-csv).
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
        ASSIGN c-arquivo-saida = c-dir-saida + TRIM(c-arquivo-saida-csv).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").
    
    OUTPUT STREAM str-excel TO VALUE(c-arquivo-saida) NO-CONVERT.
    PUT    STREAM str-excel UNFORMATTED  "SN;Produto;Descricao;Firmware Gravado?;Data Teste;Data Geracao;Hora Geracao;Data Imp;Hora Imp;Data Reimpr;Hora Reimpr;Num Reimp;PO" SKIP.

    
    /* Inicio */
    FOR EACH num-serie-firmware NO-LOCK 
        WHERE num-serie-firmware.n-serie   >= tt-param.n-serie-ini     
          AND num-serie-firmware.n-serie   <= tt-param.n-serie-fim
          AND num-serie-firmware.data-imp  >= tt-param.data-imp-ini 
          AND num-serie-firmware.data-imp  <= tt-param.data-imp-fim, 
        FIRST num-serie NO-LOCK 
        WHERE num-serie.n-serie = num-serie-firmware.n-serie
          AND num-serie.it-codigo >= tt-param.item-ini
          AND num-serie.it-codigo <= tt-param.item-fim,
        FIRST ITEM NO-LOCK 
        WHERE ITEM.it-codigo = num-serie.it-codigo: 

        ASSIGN dt-geracao = DATE(num-serie.data)
               hr-geracao = SUBSTRING(ENTRY(2,STRING(num-serie.data),' '),1,5).

        /*
        IF dt-geracao < tt-param.data-imp-ini OR
           dt-geracao > tt-param.data-imp-fim THEN NEXT.*/

        RUN pi-acompanhar in h-acomp (input "SN: " + STRING(num-serie-firmware.n-serie)).

         
        PUT  STREAM str-excel UNFORMATTED
             num-serie-firmware.n-serie     ';' 
             num-serie.it-codigo            ';'
             ITEM.desc-item                 ';'
             num-serie-firmware.log-1       ';' //Firmware
             num-serie-firmware.char-1      ';' //Data Teste
             dt-geracao                     ';'
             hr-geracao                     ';'
             num-serie-firmware.data-imp    ';' 
             num-serie-firmware.hora-imp    ';'
             num-serie-firmware.data-reimp  ';'
             num-serie-firmware.hora-reimp  ';' 
             num-serie-firmware.int-1       ';' //Num Reimp
             num-serie.num-pedido SKIP.
    END.                      

    OUTPUT STREAM str-excel CLOSE.
    
    RUN pi-finalizar IN h-acomp.
    
    IF NOT OPSYS = "unix" THEN DO:
       DOS SILENT START excel VALUE(c-arquivo-saida).
    END.
    
    RETURN "OK".   
END.
