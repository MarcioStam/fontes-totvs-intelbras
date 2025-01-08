{include/i-prgvrs.i ESUTP008 2.04.00.000}
/***********************************************************************
**  Programa..: ESP\REP\ESUTP008RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: JULHO/2008 - Desenvolvimento
**  Descricao.: Relat¢rio Comunicaá‰es - Faturas
**  Vers∆o....: 001 01/07/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/utp/esutp008tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
DEFINE TEMP-TABLE tt-faturas NO-UNDO
    FIELD mes-ref    LIKE fatura-equipamentos.mes-ref
    FIELD fornecedor LIKE fatura-equipamentos.fornecedor
    FIELD nome-fornec AS CHARACTER FORMAT "x(40)"
    FIELD val-fatura LIKE fatura-equipamentos.val-fatura
    FIELD percentual AS DECIMAL
    INDEX primario mes-ref fornecedor .

DEFINE TEMP-TABLE tt-series-linhas NO-UNDO
    FIELD sequencia AS INTEGER
    FIELD nome      AS CHARACTER
    FIELD valor-ini AS CHARACTER
    FIELD valor-fim AS CHARACTER.

DEFINE TEMP-TABLE tt-series-colunas NO-UNDO
    FIELD sequencia AS INTEGER
    FIELD nome      AS CHARACTER
    FIELD valor-ini AS CHARACTER
    FIELD valor-fim AS CHARACTER.

/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

DEFINE VARIABLE de-valor    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-desc-tipo AS CHARACTER   NO-UNDO.
DEF VAR h-acomp      as handle no-undo.

DEFINE VARIABLE chExcel2  AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE chWBook2  AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE chWSheet2 AS COMPONENT-HANDLE NO-UNDO.

DEFINE VARIABLE i-cont   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-linha  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-coluna AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-selecao-graf AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-fornec AS CHARACTER   NO-UNDO.

DEFINE VARIABLE de-total AS DECIMAL EXTENT 4    NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Relat¢rio Comunicaá‰es"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESUTP008"
       c-versao       = "2.04"
       c-revisao      = "001".

FOR EACH tt-faturas:
    DELETE tt-faturas.
END.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    
    ASSIGN c-desc-tipo = IF tt-param.tipo = 1 THEN " - Relatorio Periodo" ELSE " - Relatorio Comparativo 3 meses".

    PUT UNFORMATTED 
        "Per°odo:"            AT 01
        tt-param.periodo      AT 10
        "Tipo:"               AT 01
        STRING(tt-param.tipo) AT 07
        c-desc-tipo           AT 08.

    RUN pi-carrega-dados.
    IF tt-param.tipo = 1 THEN
        RUN pi-gera-periodo.
    ELSE 
        RUN pi-gera-comparativo.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE pi-carrega-dados:
    DEFINE VARIABLE c-periodo-ini  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-periodo-meio AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-periodo-fim  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-fornecedor   AS INTEGER     NO-UNDO.

    RUN pi-inicializar in h-acomp (input "Carregando Informaá‰es...").

    IF tt-param.tipo = 1 THEN
        ASSIGN c-periodo-ini = tt-param.periodo
               c-periodo-fim = tt-param.periodo.
    ELSE DO:
        ASSIGN c-periodo-fim = tt-param.periodo.

        IF INT(SUBSTRING(tt-param.periodo,5,2)) - 2 <= 0 THEN DO:
           ASSIGN c-periodo-ini  = STRING(INT(SUBSTRING(tt-param.periodo,1,4)) - 1,"9999") + STRING(12 + INT(SUBSTRING(tt-param.periodo,5,2)) - 2,"99")
                  c-periodo-meio = SUBSTRING(tt-param.periodo,1,4) + "01".
        END.
        ELSE DO:
            ASSIGN c-periodo-ini  = STRING(SUBSTRING(tt-param.periodo,1,4),"9999")  +  STRING(INT(SUBSTRING(tt-param.periodo,5,2)) - 2,"99")
                   c-periodo-meio = STRING(SUBSTRING(tt-param.periodo,1,4),"9999")  +  STRING(INT(SUBSTRING(tt-param.periodo,5,2)) - 1,"99").
        END.
    END.

    DEFINE VARIABLE de-valor AS DECIMAL     NO-UNDO.

    ASSIGN de-valor = 0.
    FOR EACH fatura-equipamentos 
       WHERE fatura-equipamentos.mes-ref     >= c-periodo-ini
         AND fatura-equipamentos.mes-ref     <= c-periodo-fim
        BREAK BY fatura-equipamentos.mes-ref
              BY fatura-equipamentos.fornecedor:

        ASSIGN de-valor = de-valor + fatura-equipamentos.val-fatura.

        ACCUMULATE fatura-equipamentos.val-fatura (TOTAL BY fatura-equipamentos.fornecedor).
        IF LAST-OF(fatura-equipamentos.fornecedor) THEN DO:
            ASSIGN i-fornecedor = IF fatura-equipamentos.fornecedor > 3 OR 
                                     fatura-equipamentos.fornecedor = 0 THEN 4 
                                  ELSE fatura-equipamentos.fornecedor.

            IF i-fornecedor = 4 THEN /*outros*/
                ASSIGN c-nome-fornec = "Outros".
            ELSE DO:
                FIND FIRST fornec-equipamentos NO-LOCK
                     WHERE fornec-equipamentos.fornecedor = i-fornecedor NO-ERROR.
                IF AVAIL fornec-equipamentos THEN
                    ASSIGN c-nome-fornec = fornec-equipamentos.nome.
                ELSE
                    ASSIGN c-nome-fornec = "N∆o Cadastrado".
            END.

            FIND FIRST tt-faturas NO-LOCK
                 WHERE tt-faturas.mes-ref = fatura-equipamentos.mes-ref 
                   AND tt-faturas.fornecedor = i-fornecedor NO-ERROR.
            IF NOT AVAIL tt-faturas THEN DO:
                CREATE tt-faturas.
                ASSIGN tt-faturas.mes-ref    = fatura-equipamentos.mes-ref 
                       tt-faturas.fornecedor = i-fornecedor
                       tt-faturas.nome-fornec = c-nome-fornec.
            END.
            ASSIGN tt-faturas.val-fatura = tt-faturas.val-fatura + (ACCUM TOTAL BY fatura-equipamentos.fornecedor fatura-equipamentos.val-fatura).

            IF tt-param.tipo = 2 THEN DO:
                IF NOT CAN-FIND(FIRST tt-faturas NO-LOCK
                                WHERE tt-faturas.mes-ref = c-periodo-ini 
                                  AND tt-faturas.fornecedor = i-fornecedor) THEN DO:
                    CREATE tt-faturas.
                    ASSIGN tt-faturas.mes-ref    = c-periodo-ini
                           tt-faturas.fornecedor = i-fornecedor
                           tt-faturas.nome-fornec = c-nome-fornec.
                END.
                IF NOT CAN-FIND(FIRST tt-faturas NO-LOCK
                                WHERE tt-faturas.mes-ref = c-periodo-meio 
                                  AND tt-faturas.fornecedor = i-fornecedor) THEN DO:
                    CREATE tt-faturas.
                    ASSIGN tt-faturas.mes-ref    = c-periodo-meio
                           tt-faturas.fornecedor = i-fornecedor
                           tt-faturas.nome-fornec = c-nome-fornec.
                END.
                IF NOT CAN-FIND(FIRST tt-faturas NO-LOCK
                                WHERE tt-faturas.mes-ref = c-periodo-fim
                                  AND tt-faturas.fornecedor = i-fornecedor) THEN DO:
                    CREATE tt-faturas.
                    ASSIGN tt-faturas.mes-ref    = c-periodo-fim
                           tt-faturas.fornecedor = i-fornecedor
                           tt-faturas.nome-fornec = c-nome-fornec.
                END.
            END.
        END.

        IF LAST-OF(fatura-equipamentos.mes-ref) THEN DO:
            FOR EACH tt-faturas
               WHERE tt-faturas.mes-ref = fatura-equipamentos.mes-ref:
                ASSIGN tt-faturas.percentual = (tt-faturas.val-fatura / de-valor) * 100.            
            END.
            ASSIGN de-valor = 0.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-gera-periodo:

    RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio Per°odo...").

    CREATE "Excel.Application" chExcel2.

    ASSIGN chExcel2:ScreenUpdating = YES
           chExcel2:VISIBLE        = NO.

    assign /*chExcel2:SheetsInNewWorkbook = 1*/
           chWBook2 = chExcel2:WorkBooks:Add().

    assign chWSheet2                            = chWBook2:Sheets:Item(1)
           chWSheet2:Name                       = "Telefonia "
           chWBook2:Windows(1):DisplayGridLines = YES.

    chWSheet2:Activate().

    ASSIGN i-linha = 1
           chWSheet2:Cells(i-linha, 1 ):Value = "Operadoras"
           chWSheet2:Cells(i-linha, 2 ):Value = "Valor"
           chWSheet2:Cells(i-linha, 3 ):Value = "Percentual"
           i-linha = i-linha + 1.

    FOR EACH tt-faturas:


        ASSIGN chWSheet2:Cells(i-linha, 1 ):Value = tt-faturas.nome-fornec
               chWSheet2:Cells(i-linha, 2 ):Value = tt-faturas.val-fatura
               chWSheet2:Cells(i-linha, 2 ):NumberFormat = "#.##0,00"
               chWSheet2:Cells(i-linha, 3 ):Value = tt-faturas.percentual
               chWSheet2:Cells(i-linha, 3 ):NumberFormat = "##0,00"
               i-linha = i-linha + 1.
    END.

    chWSheet2 = chWBook2:Sheets:Item(1).
    chWSheet2:Activate().
    ASSIGN c-selecao-graf = "A1:C" + STRING(i-linha - 1).
    chWSheet2:Range(c-selecao-graf):SELECT.
    chWSheet2:ChartObjects:Add(10,80,400,300):Activate. 
    chExcel2:ActiveChart:ChartWizard(chWSheet2:Range(c-selecao-graf), 3, 1, 2, 1, 1, TRUE, "Perfil das operadoras na Intelbras", "" , ""). 
    chExcel2:ActiveChart:SetSourceData(chWSheet2:Range(c-selecao-graf), 2).
    
    /*chExcel2:ActiveChart:ChartTitle:Font:Size = 12.*/
    chExcel2:ActiveChart:ChartType = 70.
    chExcel2:ActiveChart:Legend:Position = -4107.
    chExcel2:ActiveChart:HasLegend = FALSE.

    chExcel2:ActiveChart:SeriesCollection(1):HasDataLabels   = TRUE. 
    chExcel2:ActiveChart:SeriesCollection(1):DataLabels:ShowLegendKey   = FALSE. 
    chExcel2:ActiveChart:SeriesCollection(1):DataLabels:Type = 5.
    chExcel2:ActiveChart:SeriesCollection(1):XValues = chWSheet2:Range("A2:B" + STRING(i-linha - 1)).

    chExcel2:ActiveChart:SeriesCollection(1):DataLabels:Font:FontStyle = "Negrito".
    chExcel2:ActiveChart:SeriesCollection(1):DataLabels:Shadow = True.
    chExcel2:ActiveChart:SeriesCollection(1):DataLabels:Border:LineStyle = 1.

    chExcel2:ActiveChart:PlotArea:SELECT.
    chExcel2:ActiveChart:PlotArea:Interior:ColorIndex = -4142.
    chExcel2:ActiveChart:PlotArea:Border:LineStyle = -4142.
    
    chExcel2:ActiveChart:PlotArea:Width = 285.
    chExcel2:ActiveChart:PlotArea:Height = 115.
    chExcel2:ActiveChart:PlotArea:Left = 54.
    chExcel2:ActiveChart:PlotArea:Top = 93.

    ASSIGN chExcel2:VISIBLE        = YES.
    /*chExcel2:Quit().*/

    IF VALID-HANDLE(chWSheet2) THEN
        RELEASE OBJECT chWSheet2.

    IF VALID-HANDLE(chWBook2) THEN
        RELEASE OBJECT chWBook2.

    IF VALID-HANDLE(chExcel2) THEN
        RELEASE OBJECT chExcel2.

END PROCEDURE.

PROCEDURE pi-gera-comparativo:

    RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio Comparativo...").

    CREATE "Excel.Application" chExcel2.

    ASSIGN chExcel2:ScreenUpdating = YES
           chExcel2:VISIBLE        = NO.

    assign /*chExcel2:SheetsInNewWorkbook = 1*/
           chWBook2 = chExcel2:WorkBooks:Add().

    assign chWSheet2                            = chWBook2:Sheets:Item(1)
           chWSheet2:Name                       = "Telefonia "
           chWBook2:Windows(1):DisplayGridLines = YES.

    chWSheet2:Activate().

    ASSIGN i-coluna = 0
           i-cont   = 0
           de-total = 0.

    FOR EACH tt-faturas:
        ASSIGN de-total[tt-faturas.fornecedor] = de-total[tt-faturas.fornecedor] + tt-faturas.val-fatura.
    END.

    FOR EACH tt-faturas 
        BREAK BY tt-faturas.mes-ref
              BY tt-faturas.fornecedor:

        

        IF FIRST-OF(tt-faturas.mes-ref) THEN DO:
            ASSIGN i-cont = i-cont + 1.

            ASSIGN i-linha  = 1
                   i-coluna = i-coluna + 1
                   chWSheet2:Cells(i-linha, 1):Value = "Operadoras"
                   chWSheet2:Cells(i-linha, i-coluna + 1):Value = tt-faturas.mes-ref
                   chWSheet2:Cells(i-linha, i-coluna + 4):Value = tt-faturas.mes-ref
                   chWSheet2:Cells(i-linha, 9):Value            = "Total"
                   chWSheet2:Cells(i-linha, i-coluna + 9):Value = tt-faturas.mes-ref
                   i-linha  = 2.
        END.

        ASSIGN chWSheet2:Cells(i-linha, 1):Value = tt-faturas.nome-fornec
               chWSheet2:Cells(i-linha, i-coluna + 1 ):Value = tt-faturas.val-fatura
               chWSheet2:Cells(i-linha, i-coluna + 1 ):NumberFormat = "#.##0,00"
               chWSheet2:Cells(i-linha, i-coluna + 4 ):Value = tt-faturas.percentual
               chWSheet2:Cells(i-linha, i-coluna + 4 ):NumberFormat = "##0,00"
               chWSheet2:Cells(i-linha, 9):Value = de-total[tt-faturas.fornecedor]
               chWSheet2:Cells(i-linha, 9):NumberFormat = "#.##0,00"
               chWSheet2:Cells(i-linha, i-coluna + 9 ):Value = tt-faturas.val-fatura / de-total[tt-faturas.fornecedor] * 100
               chWSheet2:Cells(i-linha, i-coluna + 9 ):NumberFormat = "##0,00"
               i-linha = i-linha + 1.

        ACCUMULATE tt-faturas.val-fatura (TOTAL BY tt-faturas.mes-ref).

        IF LAST-OF(tt-faturas.mes-ref) THEN DO:
            ASSIGN chWSheet2:Cells(i-linha, 1):Value = "Total"
                   chWSheet2:Cells(i-linha, i-coluna + 1 ):Value = (ACCUM TOTAL BY tt-faturas.mes-ref tt-faturas.val-fatura)
                   chWSheet2:Cells(i-linha, i-coluna + 1 ):NumberFormat = "#.##0,00".
        END.
    END.

    RUN pi-graf-linhas-val.
    RUN pi-graf-colunas-val.
    RUN pi-graf-linhas-perc.
    RUN pi-graf-colunas-perc.
    
    ASSIGN chExcel2:VISIBLE        = YES.
    /*chExcel2:Quit().*/

    IF VALID-HANDLE(chWSheet2) THEN
        RELEASE OBJECT chWSheet2.

    IF VALID-HANDLE(chWBook2) THEN
        RELEASE OBJECT chWBook2.

    IF VALID-HANDLE(chExcel2) THEN
        RELEASE OBJECT chExcel2.

END PROCEDURE.

PROCEDURE pi-graf-linhas-val:
    FOR EACH tt-series-linhas:
        DELETE tt-series-linhas.
    END.

    CREATE tt-series-linhas.
    ASSIGN tt-series-linhas.sequencia = 1
           tt-series-linhas.nome      = "A2"
           tt-series-linhas.valor-ini = "B2"
           tt-series-linhas.valor-fim = "D2".

    CREATE tt-series-linhas.
    ASSIGN i-cont = i-cont + 1
           tt-series-linhas.sequencia = 2
           tt-series-linhas.nome      = "A3"
           tt-series-linhas.valor-ini = "B3"
           tt-series-linhas.valor-fim = "D3".

    CREATE tt-series-linhas.
    ASSIGN i-cont = i-cont + 1
           tt-series-linhas.sequencia = 3
           tt-series-linhas.nome      = "A4"
           tt-series-linhas.valor-ini = "B4"
           tt-series-linhas.valor-fim = "D4".

    CREATE tt-series-linhas.
    ASSIGN i-cont = i-cont + 1
           tt-series-linhas.sequencia = 4
           tt-series-linhas.nome      = "A5"
           tt-series-linhas.valor-ini = "B5"
           tt-series-linhas.valor-fim = "D5".

    chWSheet2 = chWBook2:Sheets:Item(1).
    chWSheet2:Activate().
    chWSheet2:Range("A2:A5"):SELECT.
    
    chWSheet2:ChartObjects:Add(10,80,400,300):Activate. 
    chExcel2:ActiveChart:ChartWizard(chWSheet2:Range("A2:A5"), 3, 1, 2, 1, 1, TRUE, "Comparativo R$ (Operadoras/Meses)", "Meses" , "Valor"). 
    chExcel2:ActiveChart:SetSourceData(chWSheet2:Range("A2:A5"), 2).
    
    /*chExcel2:ActiveChart:ChartTitle:Font:Size = 12.*/
    chExcel2:ActiveChart:ChartType = 54.
    chExcel2:ActiveChart:Legend:Position = -4107.
    chExcel2:ActiveChart:HasLegend = TRUE.

    chExcel2:ActiveChart:Elevation      = 15.
    chExcel2:ActiveChart:Perspective    = 30.
    chExcel2:ActiveChart:Rotation       = 20.
    chExcel2:ActiveChart:RightAngleAxes = True.
    chExcel2:ActiveChart:HeightPercent  = 100.
    chExcel2:ActiveChart:AutoScaling    = True.

    ASSIGN i-cont = 1.
    FOR EACH tt-series-linhas BREAK BY tt-series-linhas.sequencia:
        ASSIGN chExcel2:ActiveChart:SeriesCollection(i-cont):Name    = chWSheet2:Range(tt-series-linhas.nome):VALUE NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            chExcel2:ActiveChart:SeriesCollection:NewSeries.

        chExcel2:ActiveChart:SeriesCollection(i-cont):Name    = chWSheet2:Range(tt-series-linhas.nome):VALUE.
        chExcel2:ActiveChart:SeriesCollection(i-cont):Values  = chWSheet2:Range(tt-series-linhas.valor-ini + ":" + tt-series-linhas.valor-fim).
        chExcel2:ActiveChart:SeriesCollection(i-cont):XValues = chWSheet2:Range("B1:D1").

        chExcel2:ActiveChart:SeriesCollection(i-cont):HasDataLabels = TRUE. 
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:ShowLegendKey = FALSE.
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:Type = 2.
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:font:size = 7.
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:font:background = 3.

        ASSIGN i-cont = i-cont + 1.
    END.
END PROCEDURE.

PROCEDURE pi-graf-colunas-val:
    FOR EACH tt-series-colunas:
        DELETE tt-series-colunas.
    END.

    CREATE tt-series-colunas.
    ASSIGN tt-series-colunas.sequencia = 1
           tt-series-colunas.nome      = "B1"
           tt-series-colunas.valor-ini = "B2"
           tt-series-colunas.valor-fim = "B5".

    CREATE tt-series-colunas.
    ASSIGN i-cont = i-cont + 1
           tt-series-colunas.sequencia = 2
           tt-series-colunas.nome      = "C1"
           tt-series-colunas.valor-ini = "C2"
           tt-series-colunas.valor-fim = "C5".

    CREATE tt-series-colunas.
    ASSIGN i-cont = i-cont + 1
           tt-series-colunas.sequencia = 3
           tt-series-colunas.nome      = "D1"
           tt-series-colunas.valor-ini = "D2"
           tt-series-colunas.valor-fim = "D5".

    chWSheet2 = chWBook2:Sheets:Item(1).
    chWSheet2:Activate().
    chWSheet2:Range("B1:D1"):SELECT.
    
    chWSheet2:ChartObjects:Add(420,80,400,300):Activate. 
    chExcel2:ActiveChart:ChartWizard(chWSheet2:Range("B1:D1"), 3, 1, 2, 1, 1, TRUE, "Comparativo R$ (Meses/Operadoras)", "Operadoras" , "Valor"). 
    chExcel2:ActiveChart:SetSourceData(chWSheet2:Range("B1:D1"), 1).
    
    /*chExcel2:ActiveChart:ChartTitle:Font:Size = 12.*/
    chExcel2:ActiveChart:ChartType = 54.
    chExcel2:ActiveChart:Legend:Position = -4107.
    chExcel2:ActiveChart:HasLegend = TRUE.

    chExcel2:ActiveChart:Elevation      = 15.
    chExcel2:ActiveChart:Perspective    = 30.
    chExcel2:ActiveChart:Rotation       = 20.
    chExcel2:ActiveChart:RightAngleAxes = True.
    chExcel2:ActiveChart:HeightPercent  = 100.
    chExcel2:ActiveChart:AutoScaling    = True.

    ASSIGN i-cont = 1.
    FOR EACH tt-series-colunas BREAK BY tt-series-colunas.sequencia:
        ASSIGN chExcel2:ActiveChart:SeriesCollection(i-cont):Name    = chWSheet2:Range(tt-series-colunas.nome):VALUE NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            chExcel2:ActiveChart:SeriesCollection:NewSeries.

        chExcel2:ActiveChart:SeriesCollection(i-cont):Name    = chWSheet2:Range(tt-series-colunas.nome):VALUE.
        chExcel2:ActiveChart:SeriesCollection(i-cont):Values  = chWSheet2:Range(tt-series-colunas.valor-ini + ":" + tt-series-colunas.valor-fim).
        chExcel2:ActiveChart:SeriesCollection(i-cont):XValues = chWSheet2:Range("A2:A5").

        chExcel2:ActiveChart:SeriesCollection(i-cont):HasDataLabels = TRUE. 
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:ShowLegendKey = FALSE.
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:Type = 2.
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:font:size = 7.
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:font:background = 3.
        
        ASSIGN i-cont = i-cont + 1.
    END.
END PROCEDURE.

PROCEDURE pi-graf-linhas-perc:
    FOR EACH tt-series-linhas:
        DELETE tt-series-linhas.
    END.

    CREATE tt-series-linhas.
    ASSIGN tt-series-linhas.sequencia = 1
           tt-series-linhas.nome      = "A2"
           tt-series-linhas.valor-ini = "E2"
           tt-series-linhas.valor-fim = "G2".

    CREATE tt-series-linhas.
    ASSIGN i-cont = i-cont + 1
           tt-series-linhas.sequencia = 2
           tt-series-linhas.nome      = "A3"
           tt-series-linhas.valor-ini = "E3"
           tt-series-linhas.valor-fim = "G3".

    CREATE tt-series-linhas.
    ASSIGN i-cont = i-cont + 1
           tt-series-linhas.sequencia = 3
           tt-series-linhas.nome      = "A4"
           tt-series-linhas.valor-ini = "E4"
           tt-series-linhas.valor-fim = "G4".

    CREATE tt-series-linhas.
    ASSIGN i-cont = i-cont + 1
           tt-series-linhas.sequencia = 4
           tt-series-linhas.nome      = "A5"
           tt-series-linhas.valor-ini = "E5"
           tt-series-linhas.valor-fim = "G5".

    chWSheet2 = chWBook2:Sheets:Item(1).
    chWSheet2:Activate().
    chWSheet2:Range("A2:A5"):SELECT.
    
    chWSheet2:ChartObjects:Add(10,400,400,300):Activate. 
    chExcel2:ActiveChart:ChartWizard(chWSheet2:Range("A2:A5"), 3, 1, 2, 1, 1, TRUE, "Comparativo % (Operadoras/Meses)", "Meses" , "Percentual"). 
    chExcel2:ActiveChart:SetSourceData(chWSheet2:Range("A2:A5"), 2).
    
    /*chExcel2:ActiveChart:ChartTitle:Font:Size = 12.*/
    chExcel2:ActiveChart:ChartType = 54.
    chExcel2:ActiveChart:Legend:Position = -4107.
    chExcel2:ActiveChart:HasLegend = TRUE.

    chExcel2:ActiveChart:Elevation      = 15.
    chExcel2:ActiveChart:Perspective    = 30.
    chExcel2:ActiveChart:Rotation       = 20.
    chExcel2:ActiveChart:RightAngleAxes = True.
    chExcel2:ActiveChart:HeightPercent  = 100.
    chExcel2:ActiveChart:AutoScaling    = True.

    ASSIGN i-cont = 1.
    FOR EACH tt-series-linhas BREAK BY tt-series-linhas.sequencia:
        ASSIGN chExcel2:ActiveChart:SeriesCollection(i-cont):Name    = chWSheet2:Range(tt-series-linhas.nome):VALUE NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            chExcel2:ActiveChart:SeriesCollection:NewSeries.

        chExcel2:ActiveChart:SeriesCollection(i-cont):Name    = chWSheet2:Range(tt-series-linhas.nome):VALUE.
        chExcel2:ActiveChart:SeriesCollection(i-cont):Values  = chWSheet2:Range(tt-series-linhas.valor-ini + ":" + tt-series-linhas.valor-fim).
        chExcel2:ActiveChart:SeriesCollection(i-cont):XValues = chWSheet2:Range("E1:G1").

        chExcel2:ActiveChart:SeriesCollection(i-cont):HasDataLabels = TRUE. 
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:ShowLegendKey = FALSE.
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:Type = 2.
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:font:size = 7.
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:font:background = 3.

        ASSIGN i-cont = i-cont + 1.
    END.
END PROCEDURE.

PROCEDURE pi-graf-colunas-perc:
    FOR EACH tt-series-colunas:
        DELETE tt-series-colunas.
    END.

    CREATE tt-series-colunas.
    ASSIGN tt-series-colunas.sequencia = 1
           tt-series-colunas.nome      = "J1"
           tt-series-colunas.valor-ini = "J2"
           tt-series-colunas.valor-fim = "J5".

    CREATE tt-series-colunas.
    ASSIGN i-cont = i-cont + 1
           tt-series-colunas.sequencia = 2
           tt-series-colunas.nome      = "K1"
           tt-series-colunas.valor-ini = "K2"
           tt-series-colunas.valor-fim = "K5".

    CREATE tt-series-colunas.
    ASSIGN i-cont = i-cont + 1
           tt-series-colunas.sequencia = 3
           tt-series-colunas.nome      = "L1"
           tt-series-colunas.valor-ini = "L2"
           tt-series-colunas.valor-fim = "L5".

    chWSheet2 = chWBook2:Sheets:Item(1).
    chWSheet2:Activate().
    chWSheet2:Range("J1:L1"):SELECT.
    
    chWSheet2:ChartObjects:Add(420,400,400,300):Activate. 
    chExcel2:ActiveChart:ChartWizard(chWSheet2:Range("J1:L1"), 3, 1, 2, 1, 1, TRUE, "Comparativo % (Meses/Operadoras)", "Operadoras" , "Percentual"). 
    chExcel2:ActiveChart:SetSourceData(chWSheet2:Range("J1:L1"), 1).
    
    /*chExcel2:ActiveChart:ChartTitle:Font:Size = 12.*/
    chExcel2:ActiveChart:ChartType = 54.
    chExcel2:ActiveChart:Legend:Position = -4107.
    chExcel2:ActiveChart:HasLegend = TRUE.

    chExcel2:ActiveChart:Elevation      = 15.
    chExcel2:ActiveChart:Perspective    = 30.
    chExcel2:ActiveChart:Rotation       = 20.
    chExcel2:ActiveChart:RightAngleAxes = True.
    chExcel2:ActiveChart:HeightPercent  = 100.
    chExcel2:ActiveChart:AutoScaling    = True.

    ASSIGN i-cont = 1.
    FOR EACH tt-series-colunas BREAK BY tt-series-colunas.sequencia:
        ASSIGN chExcel2:ActiveChart:SeriesCollection(i-cont):Name    = chWSheet2:Range(tt-series-colunas.nome):VALUE NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            chExcel2:ActiveChart:SeriesCollection:NewSeries.

        chExcel2:ActiveChart:SeriesCollection(i-cont):Name    = chWSheet2:Range(tt-series-colunas.nome):VALUE.
        chExcel2:ActiveChart:SeriesCollection(i-cont):Values  = chWSheet2:Range(tt-series-colunas.valor-ini + ":" + tt-series-colunas.valor-fim).
        chExcel2:ActiveChart:SeriesCollection(i-cont):XValues = chWSheet2:Range("A2:A5").

        chExcel2:ActiveChart:SeriesCollection(i-cont):HasDataLabels = TRUE. 
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:ShowLegendKey = FALSE.
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:Type = 2.
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:font:size = 7.
        chExcel2:ActiveChart:SeriesCollection(i-cont):DataLabels:font:background = 3.
        
        ASSIGN i-cont = i-cont + 1.
    END.
END PROCEDURE.
