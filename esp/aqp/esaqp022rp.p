/* include de controle de vers∆o */
{include/i-prgvrs.i ESAQP022RP 1.00.00.000}

/* prÇprocessador para ativar ou n∆o a sa°da para RTF */
&global-define RTF no

/* definiá∆o das temp-tables para recebimento de parÉmetros */
{esp/aqp/esaqp022tt.i}

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
define variable i-cont                  as int       initial 1           no-undo.
define variable v_des_seq_comp          as char      format "x(40)"      no-undo.
define variable v_des_produto           as char      format "x(40)"      no-undo.
define variable v_des_lin_prod          as char      format "x(40)"      no-undo.
define variable v_des_tipo_lote         as char      format "x(40)"      no-undo.
define variable v_des_unid_neg          as char      format "x(40)"      no-undo.
define variable i-linha                 as int                           no-undo.

/**************************** Temp-tables *************************************/
define temp-table tt-registros
    field nr-seq-componente  as int
    field qt-amostras  as int.

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
&scoped-define xl3DBarClustered 60
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
    assign v_des_destino = string(session:temp-directory + "ESAQP022" + string (time) + ".xlsx").
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
        auditoria-geral.cod-estabel <> tt-param.cod-estabel THEN
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
    for each auditoria-visual
       where auditoria-visual.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria:
        find first tt-registros exclusive-lock
             where tt-registros.nr-seq-componente = auditoria-visual.nr-seq-comp no-error.
        if not avail tt-registros then do:
            create tt-registros.
            assign tt-registros.nr-seq-componente = auditoria-visual.nr-seq-comp. 
        end.

        assign tt-registros.qt-amostras = tt-registros.qt-amostras + 1.

    end.
end.

run pi-imprime-registros.

procedure pi-cria-planilha:

    create "Excel.Application":U chExcel connect no-error.
    if error-status:error then 
        create "Excel.Application":U chExcel.
    
    assign chArquivo  = chExcel:Workbooks:Add().
           chPlanilha = chArquivo:Sheets:Item(1).
   

    chExcel:Range("A1:J1"):select.
    chExcel:selection:MergeCells = true.
    chExcel:selection:value = "NÈMERO DE COMPONENTES ENVOLVIDOS POR ORIGEM".
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
               AND lin-prod.nr-linha    = tt-param.nr-linha no-error.
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
    chExcel:selection:value = "Componente".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    chExcel:selection:Interior:ColorIndex = 15.

    chExcel:Range("B5"):select.
    chExcel:selection:value = "Total".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    chExcel:selection:Interior:ColorIndex = 15.
    
    assign i-linha = 5.
    for each tt-registros:
        assign i-linha = i-linha + 1.

        find first aq-comp-prod no-lock
             where aq-comp-prod.nr-seq-comp = tt-registros.nr-seq-componente no-error.
        if avail aq-comp-prod then
            assign v_des_seq_comp = aq-comp-prod.des-componente.
        else
            assign v_des_seq_comp = "".

        chExcel:Range("A" + string(i-linha)):select.
        chExcel:selection:value = v_des_seq_comp.
        
        chExcel:Range("B" + string(i-linha)):select.
        chExcel:selection:value = tt-registros.qt-amostras.
    end.

    chExcel:Range("A5:B" + string(i-linha)):select.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
    if i-linha > 5 then
        run pi-cria-grafico.
    
end procedure.

procedure pi-cria-grafico:
    /*** Criar grafico ***/
    chPlanilha:range("A10:" + "L30"):select.
    chChart = chPlanilha:ChartObjects:Add(10,150,460,300):Activate().
    chExcel:ActiveChart:ChartWizard(chPlanilha:Range("Plan1!$B$6:$D$6"), 3, 1, 2, 1, 1, TRUE, "" , "" , "").
    chExcel:ActiveChart:SetSourceData(chPlanilha:Range("Plan1!$A$6:$A$" + string(i-linha)), 1).

    if tt-param.tip-grafico = 2 then
        chExcel:ActiveChart:ChartType = {&xl3DBarClustered}.

    chExcel:ActiveChart:HasTitle = True.
    chExcel:ActiveChart:ChartTitle:Characters:Text = "NÈMERO DE COMPONENTES ENVOLVIDOS POR ORIGEM".
    chExcel:ActiveChart:ChartTitle:Select.
    chExcel:ActiveChart:ChartTitle:Font:Size = 12.
    chExcel:ActiveChart:Legend:Position = {&xlBottom}.
    chExcel:ActiveChart:HasLegend = TRUE.

    assign v_des_seq_comp = chPlanilha:Range("A6"):value.
    
    chExcel:ActiveChart:SeriesCollection(1):XValues = "Plan1!$A$6:$A$" + string(i-linha).
    chExcel:ActiveChart:SeriesCollection(1):name    = v_des_seq_comp.
    chExcel:ActiveChart:SeriesCollection(1):Values  = "Plan1!$B$6:$B$" + string(i-linha).
   
    do i-cont = 1 to chExcel:ActiveChart:SeriesCollection(1):Points:count:
        chExcel:ActiveChart:SeriesCollection(1):Points(i-cont):HasDataLabel = true.
        chExcel:ActiveChart:SeriesCollection(1):Points(i-cont):Fill:ForeColor:SchemeColor = random(3,50).
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
