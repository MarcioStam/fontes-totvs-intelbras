/* include de controle de vers∆o */
{include/i-prgvrs.i ESAQP019RP 1.00.00.000}

/* prÇprocessador para ativar ou n∆o a sa°da para RTF */
&global-define RTF no

/* definiá∆o das temp-tables para recebimento de parÉmetros */
{esp/aqp/esaqp019tt.i}

/* recebimento de parÉmetros */
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/**************************** Variaveis ****************************************/
define variable chExcel                 as component-handle              no-undo.
define variable chChart                 as component-handle              no-undo.
define variable chArquivo               as component-handle              no-undo.
define variable chPlanilha              as component-handle              no-undo.
define variable c-path-excel            as character format "x(256)"     no-undo.
define variable i-acomp                 as int                           no-undo.
define variable h-acomp                 as handle                        no-undo.
define variable v_des_destino           as char      format "x(30)"      no-undo.
define variable i-cont                  as int                           no-undo.
define variable v_des_produto           as char      format "x(40)"      no-undo.
define variable v_des_lin_prod          as char      format "x(40)"      no-undo.
define variable v_des_tipo_lote         as char      format "x(40)"      no-undo.
define variable v_des_unid_neg          as char      format "x(40)"      no-undo.
define variable i-linha                 as int                           no-undo.
define variable i-linha-final           as int                           no-undo.
define variable i-coluna                as int                           no-undo.
define variable i-coluna-final          as int                           no-undo.
define variable i-qtd-amostra           as int                           no-undo.
define variable i-tipos-lotes           as int                           no-undo.
define variable v_des_coluna            as char initial "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z" no-undo.
define variable c-mes                   as char initial "JANEIRO,FEVEREIRO,MARÄO,ABRIL,MAIO,JUNHO,JULHO,AGOSTO,SETEMBRO,OUTUBRO,NOVEMBRO,DEZEMBRO" no-undo.
define variable v_mes                   as char                          no-undo.

/**************************** Temp-tables *************************************/
define temp-table tt-registros
    field mes         as int
    field ano         as int
    field tipo-lote   as int
    field qt-amostras as int.

/***********Variaveis Utilizdas pelo Excel*************************************/
&scoped-define xlContinuous      1
&scoped-define xlRight       -4152
&scoped-define xlLeft        -4131
&scoped-define xlTop         -4160
&scoped-define xlBottom      -4107
&scoped-define xlEdgeLeft        7
&scoped-define xlContinuous      1
&scoped-define xlEdgeTop         8
&scoped-define xlEdgeBottom      9
&scoped-define xlEdgeRight      10
&scoped-define xlNormal      -4143
&scoped-define xlCenter      -4108
&scoped-define xlJustify     -4130
&scoped-define xlAbove           0
&scoped-define xlLine            4
&scoped-define xlBar             2
&scoped-define xlBarClustered   57
&scoped-define xlPie             5 
&scoped-define xlLocationAsNewSheet 2
&scoped-define xlNone                   	-4142
&scoped-define xlLandscape                  	2
&scoped-define xlInsideVertical            	11
&scoped-define xlInsideHorizontal          	12
&scoped-define xlPaperA4                    	9
&scoped-define xlMedium                 	-4138
&scoped-define xlThin                       	2
&scoped-define xlBottom                 	-4107
&scoped-define xlDataLabelsShowValue  	2
&scoped-define xlDisplayGridlines           	1
&scoped-define xlIncrementLeft              	0
&scoped-define xlIncrementTop               	0
&scoped-define xlRadar                  	-4151
&scoped-define xlValue                      	2
&scoped-define xlDiamond                    	1
&scoped-define xlmsoTrue                    	1
&scoped-define msoFalse                     	0
&scoped-define xlMove                       	2
&scoped-define msoShapeRectangle        	1
&scoped-define msoTrue                     	-1
&scoped-define xlSourceAutoFilter       	3
&scoped-define xlXYScatter              	-4169
&scoped-define xlCategory                   	1
&scoped-define x1Primary                    	1
&scoped-define x1Secondary                  	2
&scoped-define msoGradientHorizontal  	1
&scoped-define xlAnd                        	1
&scoped-define xlNoSelection            	-4142
&scoped-define xlThick                      	4
&scoped-define xlLocationAsObject         	2
&scoped-define xlLocationAsNewSheet    	1
&scoped-define xlUpward                 	-4171
&scoped-define xlUnderlineStyleNone     	-4142
&scoped-define msoBringToFront        	0 

/* executando de forma persistente o utilit†rio de acompanhamento */
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}
run pi-inicializar in h-acomp (input return-value).

if tt-param.destino = 3 or
   tt-param.destino = 1 then
    assign v_des_destino = string(session:temp-directory + "ESAQP019" + string (time) + ".xlsx").
else
    assign v_des_destino = string(tt-param.arquivo).


run pi-cria-planilha.

/** Cria Temp-table com valores mensais**/
for each auditoria-geral no-lock
   where auditoria-geral.log-revisado
     and auditoria-geral.dt-amostragem   >= tt-param.dat-adic-ini
     and auditoria-geral.dt-amostragem   <= tt-param.dat-adic-fim
break by auditoria-geral.dt-amostragem:

    IF tt-param.cod-estabel <> "" AND
       tt-param.cod-estabel <> auditoria-geral.cod-estabel THEN
        NEXT.

    if tt-param.tip-lote <> 0 and 
       auditoria-geral.nr-seq-tipo-lote <> tt-param.tip-lote then
        next.

    if tt-param.it-codigo <> "" and /** C¢digo produto n∆o informado **/
       tt-param.it-codigo <> auditoria-geral.it-codigo then
        next.

    if tt-param.nr-linha <> 0  and /** Linha de produá∆o n∆o informada **/
       tt-param.nr-linha <> auditoria-geral.nr-linha then
        next.
    
    if tt-param.cod-uneg <> "" and
       auditoria-geral.cod-unid-negoc <> tt-param.cod-uneg then
        next.
    
    assign i-acomp = i-acomp + 1.
        
    run pi-acompanhar in h-acomp (input string(i-acomp)).

    find first tt-registros exclusive-lock
         where tt-registros.mes = month(auditoria-geral.dt-amostragem)
           and tt-registros.ano = year(auditoria-geral.dt-amostragem)
           and tt-registros.tipo-lote = auditoria-geral.nr-seq-tipo-lote no-error.
    if not avail tt-registros then do:
        create tt-registros.
        assign tt-registros.mes = month(auditoria-geral.dt-amostragem)
               tt-registros.ano = year(auditoria-geral.dt-amostragem)
               tt-registros.tipo-lote = auditoria-geral.nr-seq-tipo-lote. 
    end.

    assign tt-registros.qt-amostras = tt-registros.qt-amostras + 1.
end.

run pi-imprime-registros.

procedure pi-cria-planilha:

    create "Excel.Application":U chExcel connect no-error.
    if error-status:error then 
        create "Excel.Application":U chExcel.
    
    assign chArquivo  = chExcel:Workbooks:add().
           chPlanilha = chArquivo:Sheets:Item(1).

    chExcel:Range("A1:J1"):select.
    chExcel:selection:MergeCells = true.
    chExcel:selection:value = "EVOLUÄ«O DOS LOTES REVISADOS POR M“S".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    chExcel:selection:HorizontalAlignment = {&xlCenter}.

    chExcel:Range("A2"):select.
    chExcel:selection:value = "Tipo Lote:".
    chExcel:selection:Font:Bold           = True.

    if tt-param.tip-lote = 0 then do:
        assign v_des_tipo_lote = "Todos".
        chExcel:Range("B2"):select.
        chExcel:selection:value = v_des_tipo_lote.
    end.
    else do:
        find first aq-tipo-lote NO-LOCK
             where aq-tipo-lote.nr-seq-tipo-lote = tt-param.tip-lote no-error.
        if avail aq-tipo-lote then
            assign v_des_tipo_lote = aq-tipo-lote.des-lote.
        else
            assign v_des_tipo_lote = "".

        chExcel:Range("B2"):select.
        chExcel:selection:value = tt-param.tip-lote.

        chExcel:Range("C2"):select.
        chExcel:selection:value = v_des_tipo_lote.
    end.
    
    chExcel:Range("A3"):select.
    chExcel:selection:value = "Situaá∆o dos Lotes:".
    chExcel:selection:Font:Bold           = True.

    chExcel:Range("B3"):select.
    chExcel:selection:value = "Revisados".

    chExcel:Range("D2"):select.
    chExcel:selection:value = "Per°odo:".
    chExcel:selection:Font:Bold           = True.

    chExcel:Range("E2"):select.
    chExcel:selection:value = string(tt-param.dat-adic-ini) + " |<>| " + string(tt-param.dat-adic-fim).
    
    chExcel:Range("D3"):select.
    chExcel:selection:value = "Tipo Produto:".
    chExcel:selection:Font:Bold           = True.
    
    
    if tt-param.nr-linha = 0 then do:
        assign v_des_lin_prod = "Todas".
        chExcel:Range("E3"):select.
        chExcel:selection:value = v_des_lin_prod.
    end.
    else do:
        find first lin-prod no-lock
             where lin-prod.cod-estabel = tt-param.cod-estabel
               AND lin-prod.nr-linha = tt-param.nr-linha no-error.
        if avail lin-prod then
            assign v_des_lin_prod = lin-prod.descricao.
        else
            assign v_des_lin_prod = "".

        chExcel:Range("E3"):select.
        chExcel:selection:value = tt-param.nr-linha.
        
        chExcel:Range("F3"):select.
        chExcel:selection:value = v_des_lin_prod.
    end.
    

    chExcel:Range("H2"):select.
    chExcel:selection:value = "Produto:".
    chExcel:selection:Font:Bold           = True.

    if tt-param.it-codigo = "" then do:
        assign v_des_produto = "Todos".
        chExcel:Range("I2"):select.
        chExcel:selection:value = v_des_produto.
    end.
    else do:
        find first item no-lock
            where item.it-codigo = tt-param.it-codigo no-error.
        if avail item then
          assign v_des_produto = item.desc-item.
        
        chExcel:Range("I2"):select.
        chExcel:selection:value = tt-param.it-codigo.

        chExcel:Range("J2"):select.
        chExcel:selection:value = v_des_produto.
    end.
    
    chExcel:Range("H3"):select.
    chExcel:selection:value = "Unidade de Neg¢cio".
    chExcel:selection:Font:Bold           = True.

    if tt-param.cod-uneg = "" then do:
        assign v_des_unid_neg = "Todas".
        chExcel:Range("I3"):select.
        chExcel:selection:value = v_des_unid_neg.
    end.
    else do:
        find first unid-negoc no-lock
             where unid-negoc.cod-unid-negoc = tt-param.cod-uneg no-error.
        if avail unid-negoc then
            assign v_des_unid_neg = unid-negoc.des-unid-negoc.

        chExcel:Range("I3"):select.
        chExcel:selection:value = tt-param.cod-uneg.

        chExcel:Range("J3"):select.
        chExcel:selection:value = v_des_unid_neg.
    end.
end procedure.

procedure pi-imprime-registros:
    
    chExcel:Range("A5"):select.
    chExcel:selection:value = "Màs".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    chExcel:selection:Interior:ColorIndex = 15.

    assign i-linha  = 6
           i-linha-final = 7
           i-coluna = 1
           i-coluna-final = 2.

    for each tt-registros 
    break by tt-registros.tipo-lote
          by tt-registros.mes:

        if first-of(tt-registros.tipo-lote) then do:
            assign i-coluna = i-coluna + 1
                   i-linha  = 6.

            find first aq-tipo-lote NO-LOCK
                 where aq-tipo-lote.nr-seq-tipo-lote = tt-registros.tipo-lote no-error.
            if avail aq-tipo-lote then
                assign v_des_tipo_lote = aq-tipo-lote.des-lote.
            else
                assign v_des_tipo_lote = "".

            chExcel:Range(entry(i-coluna, v_des_coluna, ",") + "6"):select.
            chExcel:selection:value = v_des_tipo_lote.

            if i-coluna > i-coluna-final then
                assign i-coluna-final = i-coluna.

        end.

        assign i-linha = i-linha + 1.
        
        chExcel:Range("A" + string(i-linha)):select.
        chExcel:selection:value = entry(tt-registros.mes, c-mes, ",").
        
        do i-cont = 2 to i-coluna-final:
            chExcel:Range(entry(i-cont, v_des_coluna, ",") + string(i-linha)):select.
            if i-cont = i-coluna then
                chExcel:selection:value = tt-registros.qt-amostras.
            else
                if chExcel:selection:value = ? then
                    chExcel:selection:value = 0.
        end.

        if last-of(tt-registros.tipo-lote) then
            if i-linha > i-linha-final then
                assign i-linha-final = i-linha.
    end.

    chExcel:Range(entry(i-coluna-final, v_des_coluna, ",") + string(i-linha-final)):select.
    if chExcel:selection:value = ? then
        chExcel:selection:value = 0.

    chExcel:Range("B5:" + entry(i-coluna, v_des_coluna, ",") + "5"):select.
    chExcel:selection:MergeCells = true.
    chExcel:selection:value = "Lotes".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    chExcel:selection:Interior:ColorIndex = 15.

    chExcel:Range("A6:" + entry(i-coluna, v_des_coluna, ",") + string(i-linha-final)):select.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    run pi-cria-grafico.
    
end procedure.

procedure pi-cria-grafico:
    /*** Criar grafico ***/
    chPlanilha:range("A" + string(i-linha + 3) + ":L" + string(i-linha + 20)):select.
    chChart = chPlanilha:ChartObjects:Add(10,150,460,300):Activate().
    chExcel:ActiveChart:ChartWizard(chPlanilha:Range("Plan1!$B$6:$D$6"), 3, 1, 2, 1, 1, TRUE, "" , "" , ""). 
    chExcel:ActiveChart:SetSourceData(chPlanilha:Range("Plan1!$B$6:$D$6"), 1).

    if tt-param.tip-grafico = 1 then
        chExcel:ActiveChart:ChartType = {&xlLine}.

    chExcel:ActiveChart:HasTitle = True.
    chExcel:ActiveChart:ChartTitle:Characters:Text = "EVOLUÄ«O DOS LOTES REVISADOS POR M“S".
    chExcel:ActiveChart:ChartTitle:Select.
    chExcel:ActiveChart:ChartTitle:Font:Size = 12.
    chExcel:ActiveChart:Legend:Position = {&xlBottom}.
    chExcel:ActiveChart:HasLegend = TRUE. 

    assign i-coluna = i-coluna - 1.
    chExcel:ActiveChart:SeriesCollection(1):XValues = "Plan1!A7:A" + string(i-linha-final).

    do i-tipos-lotes = 1 to i-coluna:
        chExcel:ActiveChart:SeriesCollection(i-tipos-lotes):Name = chPlanilha:Range("Plan1!" + entry(i-tipos-lotes + 1, v_des_coluna, ",") + "6"):value.
        chExcel:ActiveChart:SeriesCollection(i-tipos-lotes):Values = "Plan1!" + entry(i-tipos-lotes + 1, v_des_coluna, ",") + "7:" + entry(i-tipos-lotes + 1, v_des_coluna, ",") + string(i-linha-final).
        do i-cont = 1 to chExcel:ActiveChart:SeriesCollection(i-tipos-lotes):Points:count:
            chExcel:ActiveChart:SeriesCollection(i-tipos-lotes):Points(i-cont):HasDataLabel = true.
        end.
        if i-tipos-lotes < i-coluna then
            chExcel:ActiveChart:SeriesCollection:NewSeries().
    end.

end procedure.

chExcel:Columns('A:J'):EntireColumn:Autofit NO-ERROR.

chPlanilha:Activate().

chArquivo:Save.

case tt-param.destino:
    when 1 then do:
        chExcel:visible = true.
    end.
    when 2 then do: 
        assign tt-param.arquivo = REPLACE(tt-param.arquivo,"/","~\")
               v_des_destino    = string(tt-param.arquivo).

        if search(v_des_destino) <> ? then 
            os-delete silent value(v_des_destino) .

        IF ENTRY(NUM-ENTRIES(v_des_destino, "."), v_des_destino, ".") = "xls" THEN
            chPlanilha:SaveAs(v_des_destino, "56",,,,,) NO-ERROR.
        ELSE IF ENTRY(NUM-ENTRIES(v_des_destino, "."), v_des_destino, ".") = "xlsx" THEN
            chPlanilha:SaveAs(v_des_destino,,,,,,) NO-ERROR.

        /*chArquivo:SaveAs(v_des_destino, {&xlNormal}, "", "", False, False, False).*/
        chArquivo:Close().
        chExcel:Quit().
    end.
    /* Quando tt-param.destino = 3 ("Terminal"), ao final da execuÓ“o do programa, serŸ mostrado o arquivo em Excel. */
    when 3 then do:
        chExcel:visible = true.
    end.
end case.

release object chExcel.
release object chArquivo.
release object chPlanilha  no-error.

assign chPlanilha = ?
       chArquivo  = ?
       chExcel    = ?.

/*fechamento do output do relat¢rio*/
run pi-finalizar in h-acomp.
return "OK":U.
