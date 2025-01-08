{include/i-prgvrs.i espdp096rpa 2.00.00.000}
{esp/esb/esesb000.i}
{esp/wso/out/wso0001.i}
{esp/es0018.i}
{utp/ut-glob.i}
{cdp/cd0666.i} /*tt-erro*/
{esp/pdp/espdp006fn.i}
{btb/btb912zb.i}

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
    FIELD it-codigo        LIKE preco-item.it-codigo.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEFINE VARIABLE h-acomp       AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-arquivo-csv AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-tb-preco    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-sales       AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cont        AS INTEGER   NO-UNDO.

DEFINE BUFFER bItemTabelaPreco FOR ItemTabelaPreco.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar in h-acomp (input "Integrando ...").

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "Vtex-preco":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR EACH tt-prog-ponto:
    IF CAN-FIND(FIRST tb-preco
                WHERE tb-preco.nr-tabpre = entry(1,tt-prog-ponto.conteudo,";")) THEN DO:
        IF c-tb-preco = "" THEN
            ASSIGN c-tb-preco = entry(1,tt-prog-ponto.conteudo,";")
                   c-sales    = entry(2,tt-prog-ponto.conteudo,";").
        ELSE
            ASSIGN c-tb-preco = c-tb-preco + "," + entry(1,tt-prog-ponto.conteudo,";")
                   c-sales    = c-sales    + "," + entry(2,tt-prog-ponto.conteudo,";").
    END.
END.

DO ON STOP UNDO, LEAVE:
    
    CREATE ttPreco.
    ASSIGN ttPreco.CodigoProduto = tt-param.it-codigo.

    IF VALID-HANDLE(h-acomp) THEN
        run pi-acompanhar in h-acomp (input 'Item: ' + tt-param.it-codigo).
    
    DO i-cont = 1 TO NUM-ENTRIES(c-tb-preco,","):

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT 'Item: ' + tt-param.it-codigo + ' Tb Pre‡o: ' + STRING(ENTRY(i-cont,c-tb-preco,","))).
    
        FOR EACH preco-item NO-LOCK
           WHERE preco-item.nr-tabpre = ENTRY(i-cont,c-tb-preco,",")
             AND preco-item.it-codigo = tt-param.it-codigo
             AND preco-item.situacao  = 1:
    
            CREATE ItemTabelaPreco.
            ASSIGN ItemTabelaPreco.TabelaPreco          = TRIM(ENTRY(i-cont,c-sales,","))
                   ItemTabelaPreco.Quantidade           = preco-item.quant-min
                   ItemTabelaPreco.ValorUnitario        = preco-item.preco-venda    
                   ItemTabelaPreco.ValorTotalSemImposto = preco-item.preco-fob  
                   ItemTabelaPreco.PercentualDesconto   = preco-item.desco-quant
                   ItemTabelaPreco.InicioValidade       = preco-item.dt-inival
                   ItemTabelaPreco.FimValidade          = DATETIME-TZ(STRING(date(12/31/9998),"99-99-9999") + " " +  "23:59:00-3:00").

            IF CAN-FIND (FIRST tt-prog-ponto
                         WHERE entry(1,tt-prog-ponto.conteudo,";") = ENTRY(i-cont,c-tb-preco,",")
                           AND entry(4,tt-prog-ponto.conteudo,";") <> "") THEN DO:
                FIND FIRST tt-prog-ponto WHERE entry(1,tt-prog-ponto.conteudo, ";") = ENTRY(i-cont,c-tb-preco,",") NO-LOCK NO-ERROR.

                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT 'Item: ' + tt-param.it-codigo + ' Tb Pre‡o: ' + STRING(ENTRY(4,tt-prog-ponto.conteudo,";"))).
    
                IF entry(4,tt-prog-ponto.conteudo,";") <> "" THEN DO:
                    CREATE bItemTabelaPreco.
                    BUFFER-COPY ItemTabelaPreco EXCEPT TabelaPreco TO bItemTabelaPreco.
                    ASSIGN bItemTabelaPreco.TabelaPreco = TRIM(ENTRY(5,tt-prog-ponto.conteudo,";")).
                END.
            END.
        END.
    END.
            
    IF CAN-FIND(FIRST ItemTabelaPreco) THEN
        RUN esp/wso/out/wso0001.p (INPUT "v1/produto/preco",
                                   INPUT TABLE ttPreco,
                                   INPUT TABLE ItemTabelaPreco).

    RETURN "OK".

END.

IF VALID-HANDLE(h-acomp) THEN
    run pi-finalizar in h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK".
