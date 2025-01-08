{include/i-prgvrs.i escep084rpa 2.00.00.000}
{esp/esb/esesb000.i}
{esp/wso/out/wso0002.i}
{esp/es0018.i}

DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.

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
    FIELD sku              AS CHAR
    FIELD quantidade       AS DEC 
    FIELD estabelecimento  AS CHAR
    FIELD deposito         AS CHAR
    FIELD unidadeMedida    AS CHAR
    FIELD tabela           AS CHAR.
    
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
{cdp/cd0666.i} /*tt-erro*/
{esp/pdp/espdp006fn.i}

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.

DO ON STOP UNDO, LEAVE:

    FIND FIRST tt-param NO-ERROR.

    CREATE ttEstoque.
    ASSIGN ttEstoque.sku             = tt-param.sku            
           ttEstoque.quantidade      = tt-param.quantidade     
           ttEstoque.estabelecimento = tt-param.estabelecimento
           ttEstoque.deposito        = tt-param.deposito       
           ttEstoque.unidadeMedida   = tt-param.unidadeMedida  
           ttEstoque.tabela          = tt-param.tabela.

    RUN esp/wso/out/wso0002.p (INPUT "v1/produto/estoque",
                               INPUT TABLE ttEstoque).


    DO ON STOP UNDO, LEAVE:
        ASSIGN c-arquivo-csv = "escep084rpa-" + ttEstoque.sku + ".csv":U.
    
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

    OUTPUT TO VALUE(c-arq-excel) APPEND.
    PUT UNFORMATTED STRING(TODAY)          ";"
                    STRING(TIME,"HH:MM:SS") ";"
                    ttEstoque.sku          ";"
                    ttEstoque.quantidade   ";" SKIP.
    OUTPUT CLOSE.

    RETURN "OK".   
END.

RETURN "OK".
