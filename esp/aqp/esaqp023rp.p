/* include de controle de versÆo */
{include/i-prgvrs.i ESAQP023RP 1.00.00.000}

/* pr‚processador para ativar ou nÆo a sa¡da para RTF */
&global-define RTF no

/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{esp/aqp/esaqp023tt.i}

/* recebimento de parƒmetros */
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
define variable i-cont                  as int                           no-undo.
define variable i-acomp                 as int                           no-undo.
define variable h-acomp                 as handle                        no-undo.
define variable v_des_destino           as char      format "x(30)"      no-undo.
define variable v_des_procedimento      as char      format "x(40)"      no-undo.
define variable v_des_setor             as char      format "x(40)"      no-undo.
define variable v_des_unid_neg          as char      format "x(40)"      no-undo.
define variable v_des_componente        as char      format "x(40)"      no-undo.
define variable v_des_nconf             as char      format "x(40)"      no-undo.
define variable i-linha                 as int                           no-undo.
define variable i-setor-current         as int                           no-undo.

/**************************** Temp-tables *************************************/
define temp-table tt-unid-negoc
    field cod-unid-neg as char
    field qt-proc-nok  as int
    field qt-proc-ok   as int.

define temp-table tt-setor
    field nr-seq-setor as int
    field qt-proc-nok  as int
    field qt-proc-ok   as int.

define temp-table tt-nao-conformidades
    field nr-seq-nconf as int
    field qt-nconf     as int.

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

/* executando de forma persistente o utilit rio de acompanhamento */
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}
run pi-inicializar in h-acomp (input return-value).

if tt-param.destino = 3 or
   tt-param.destino = 1 then
    assign v_des_destino = string(session:temp-directory + "ESAQP016" + string (time) + ".xlsx").
else
    assign v_des_destino = string(tt-param.arquivo).

run pi-cria-planilha.

assign i-linha = 5.

/** L¢gica para impressÆo das informa‡äes **/
for each aud-procedimento no-lock
   where aud-procedimento.dt-auditoria   >= tt-param.dat-adic-ini
     and aud-procedimento.dt-auditoria   <= tt-param.dat-adic-fim
     and (if tt-param.des-auditor <> "" then aud-procedimento.des-auditor = tt-param.des-auditor else aud-procedimento.des-auditor <> "")
break by aud-procedimento.nr-seq-setor:
    
    if tt-param.nr-procedimento <> 0 and /** C¢digo procedimento informado **/ 
       tt-param.nr-procedimento <> aud-procedimento.nr-seq-procedimento then
        next.

    if tt-param.nr-setor <> 0 and /** C¢digo setor informado **/
       tt-param.nr-setor <> aud-procedimento.nr-seq-setor then
        next.
    
    assign i-acomp = i-acomp + 1.
        
    run pi-acompanhar in h-acomp (input string(i-acomp)).

    case tt-param.tip-proced:
        when 1 then do:
            find first tt-unid-negoc exclusive-lock
                 where tt-unid-negoc.cod-unid-neg = aud-procedimento.cod-unid-negoc no-error.
            if not avail tt-unid-negoc then do:
                create tt-unid-negoc.
                assign tt-unid-negoc.cod-unid-neg = aud-procedimento.cod-unid-negoc.
            end.

            if can-find(first nc-aud-procedimento 
                        where nc-aud-procedimento.nr-seq-aud-proced = aud-procedimento.nr-seq-aud-proced) then
                assign tt-unid-negoc.qt-proc-nok = tt-unid-negoc.qt-proc-nok + 1.
            
            assign tt-unid-negoc.qt-proc-ok = tt-unid-negoc.qt-proc-ok + 1.

        end.
        when 2 then do:
            find first tt-setor exclusive-lock
                 where tt-setor.nr-seq-setor = aud-procedimento.nr-seq-setor no-error.
            if not avail tt-setor then do:
                create tt-setor.
                assign tt-setor.nr-seq-setor = aud-procedimento.nr-seq-setor.
            end.

            if can-find(first nc-aud-procedimento 
                        where nc-aud-procedimento.nr-seq-aud-proced = aud-procedimento.nr-seq-aud-proced) then
                assign tt-setor.qt-proc-nok = tt-setor.qt-proc-nok + 1.
            
            assign tt-setor.qt-proc-ok = tt-setor.qt-proc-ok + 1.

        end.
        when 3 then do:
            for each nc-aud-procedimento 
               where nc-aud-procedimento.nr-seq-aud-proced = aud-procedimento.nr-seq-aud-proced:
                find first tt-nao-conformidades exclusive-lock
                     where tt-nao-conformidades.nr-seq-nconf = nc-aud-procedimento.nr-seq-nconfor no-error.
                if not avail tt-nao-conformidades then do:
                    create tt-nao-conformidades.
                    assign tt-nao-conformidades.nr-seq-nconf = nc-aud-procedimento.nr-seq-nconfor.
                end.

                assign tt-nao-conformidades.qt-nconf = tt-nao-conformidades.qt-nconf + 1.
            end.
        end.
    end case.
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
    chExcel:selection:value = "PROCEDIMENTOS AUDITADOS".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    chExcel:selection:HorizontalAlignment = {&xlCenter}.

    chExcel:Range("A2"):select.
    chExcel:selection:value = "Procedimento:".
    chExcel:selection:Font:Bold           = True.

    if tt-param.nr-procedimento = 0 then do:
        assign v_des_procedimento = "Todos".
        chExcel:Range("B2"):select.
        chExcel:selection:value = v_des_procedimento.
    end.
    else do:
        find first aq-procedimento no-lock
             where aq-procedimento.nr-seq-procedimento = tt-param.nr-procedimento no-error.
        if avail aq-procedimento then
            assign v_des_procedimento = aq-procedimento.des-procedimento.
        else
            assign v_des_procedimento = "".

        chExcel:Range("B2"):select.
        chExcel:selection:value = tt-param.nr-procedimento.
        
        chExcel:Range("C2"):select.
        chExcel:selection:value = v_des_procedimento.
    end.
    
    chExcel:Range("A3"):select.
    chExcel:selection:value = "Auditor:".
    chExcel:selection:Font:Bold           = True.
    
    if tt-param.des-auditor = "" then do:
        chExcel:Range("B3"):select.
        chExcel:selection:value = "Todos".
    end.
    else do:
        chExcel:Range("B3"):select.
        chExcel:selection:value = tt-param.des-auditor.
    end.

    chExcel:Range("D2"):select.
    chExcel:selection:value = "Per¡odo:".
    chExcel:selection:Font:Bold           = True.

    chExcel:Range("E2"):select.
    chExcel:selection:value = string(tt-param.dat-adic-ini) + " |<>| " + string(tt-param.dat-adic-fim).
    
    chExcel:Range("D3"):select.
    chExcel:selection:value = "Setor:".
    chExcel:selection:Font:Bold           = True.
    
    
    if tt-param.nr-setor = 0 then do:
        assign v_des_setor = "Todos".
        chExcel:Range("E3"):select.
        chExcel:selection:value = v_des_setor.
    end.
    else do:
        find first aq-setor no-lock
             where aq-setor.nr-seq-setor = tt-param.nr-setor no-error.
        if avail aq-setor then
            assign v_des_setor = aq-setor.des-setor.
        else
            assign v_des_setor = "".

        chExcel:Range("E3"):select.
        chExcel:selection:value = tt-param.nr-setor.
        
        chExcel:Range("F3"):select.
        chExcel:selection:value = v_des_setor.
    end.
end procedure.

procedure pi-imprime-registros:

    case tt-param.tip-proced:
        when 1 then do:
            chExcel:Range("A5"):select.
            chExcel:selection:value = "Unidade de Neg¢cio".
            chExcel:selection:Font:Bold           = True.
            chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
            chExcel:selection:Interior:ColorIndex = 15.
            
            chExcel:Range("B5"):select.
            chExcel:selection:value = "Auditorias".
            chExcel:selection:Font:Bold           = True.
            chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
            chExcel:selection:Interior:ColorIndex = 15.

            chExcel:Range("C5"):select.
            chExcel:selection:value = "Com NÆo Conformidades".
            chExcel:selection:Font:Bold           = True.
            chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
            chExcel:selection:Interior:ColorIndex = 15.

            for each tt-unid-negoc:
                
                assign i-linha = i-linha + 1.
                find first unid-negoc no-lock
                     where unid-negoc.cod-unid-negoc = tt-unid-negoc.cod-unid-neg no-error.
                if avail unid-negoc then
                    assign v_des_unid_neg = unid-negoc.des-unid-negoc.
                else 
                    assign v_des_unid_neg = "".

                chExcel:Range("A" + string(i-linha)):select.
                chExcel:selection:value = v_des_unid_neg.

                chExcel:Range("B" + string(i-linha)):select.
                chExcel:selection:value = tt-unid-negoc.qt-proc-ok.

                chExcel:Range("C" + string(i-linha)):select.
                chExcel:selection:value = tt-unid-negoc.qt-proc-nok.
                
            end.
        end.
        when 2 then do:
            chExcel:Range("A5"):select.
            chExcel:selection:value = "Setor".
            chExcel:selection:Font:Bold           = True.
            chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
            chExcel:selection:Interior:ColorIndex = 15.
            
            chExcel:Range("B5"):select.
            chExcel:selection:value = "Auditorias".
            chExcel:selection:Font:Bold           = True.
            chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
            chExcel:selection:Interior:ColorIndex = 15.

            chExcel:Range("C5"):select.
            chExcel:selection:value = "Com NÆo Conformidades".
            chExcel:selection:Font:Bold           = True.
            chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
            chExcel:selection:Interior:ColorIndex = 15.

            for each tt-setor:
                assign i-linha = i-linha + 1.
                find first aq-setor no-lock
                     where aq-setor.nr-seq-setor = tt-setor.nr-seq-setor no-error.
                if avail aq-setor then
                    assign v_des_setor = aq-setor.des-setor.
                else
                    assign v_des_setor = "".

                chExcel:Range("A" + string(i-linha)):select.
                chExcel:selection:value = v_des_setor.

                chExcel:Range("B" + string(i-linha)):select.
                chExcel:selection:value = tt-setor.qt-proc-ok.

                chExcel:Range("C" + string(i-linha)):select.
                chExcel:selection:value = tt-setor.qt-proc-nok.

                
            end.
        end.
        when 3 then do:
            chExcel:Range("A5"):select.
            chExcel:selection:value = "NÆo Conformidade".
            chExcel:selection:Font:Bold           = True.
            chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
            chExcel:selection:Interior:ColorIndex = 15.
            
            chExcel:Range("B5"):select.
            chExcel:selection:value = "Total".
            chExcel:selection:Font:Bold           = True.
            chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
            chExcel:selection:Interior:ColorIndex = 15.

            for each tt-nao-conformidades:
                assign i-linha = i-linha + 1.
                find first aq-nao-confor no-lock
                     where aq-nao-confor.nr-seq-nconfor = tt-nao-conformidades.nr-seq-nconf no-error.
                if avail aq-nao-confor then
                    assign v_des_nconf = aq-nao-confor.des-nao-confor.
                else
                    assign v_des_nconf = "".

                chExcel:Range("A" + string(i-linha)):select.
                chExcel:selection:value = v_des_nconf.

                chExcel:Range("B" + string(i-linha)):select.
                chExcel:selection:value = tt-nao-conformidades.qt-nconf.
            end.
        end.
    end case.
    
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
    
    chExcel:ActiveChart:ChartTitle:Select.
    chExcel:ActiveChart:ChartTitle:Font:Size = 12.

    case tt-param.tip-proced:
        when 1 then
            chExcel:ActiveChart:ChartTitle:Characters:Text = "Auditorias de Procedimentos por Unidade de Neg¢cio".
        when 2 then
            chExcel:ActiveChart:ChartTitle:Characters:Text = "Auditorias de Procedimentos por Setor".
        when 3 then
            chExcel:ActiveChart:ChartTitle:Characters:Text = "Auditorias de Procedimentos por NÆo conformidade".
    end case.

    chExcel:ActiveChart:Legend:Position = {&xlBottom}.
    chExcel:ActiveChart:HasLegend = TRUE.
    
    if tt-param.tip-proced <> 3 then do:
        chExcel:ActiveChart:SeriesCollection(1):XValues = "Plan1!$A$6:$A$" + string(i-linha).
        chExcel:ActiveChart:SeriesCollection(1):name    = "Quantidade Auditada".
        chExcel:ActiveChart:SeriesCollection(1):Values  = "Plan1!$B$6:$B$" + string(i-linha).
        do i-cont = 1 to chExcel:ActiveChart:SeriesCollection(1):Points:count:
            chExcel:ActiveChart:SeriesCollection(1):Points(i-cont):HasDataLabel = true.
        end.
        
        chExcel:ActiveChart:SeriesCollection:NewSeries().
        chExcel:ActiveChart:SeriesCollection(2):name    = "Com NÆo Conformidade".
        chExcel:ActiveChart:SeriesCollection(2):Values  = "Plan1!$C$6:$C$" + string(i-linha).
        do i-cont = 1 to chExcel:ActiveChart:SeriesCollection(2):Points:count:
            chExcel:ActiveChart:SeriesCollection(2):Points(i-cont):HasDataLabel = true.
        end.
    end.
    else do:
        chExcel:ActiveChart:SeriesCollection(1):XValues = "Plan1!$A$6:$A$" + string(i-linha).
        chExcel:ActiveChart:SeriesCollection(1):name    = v_des_nconf.
        chExcel:ActiveChart:SeriesCollection(1):Values  = "Plan1!$B$6:$B$" + string(i-linha).
        
        do i-cont = 1 to chExcel:ActiveChart:SeriesCollection(1):Points:count:
            chExcel:ActiveChart:SeriesCollection(1):Points(i-cont):HasDataLabel = true.
            chExcel:ActiveChart:SeriesCollection(1):Points(i-cont):Fill:ForeColor:SchemeColor = random(3,50).
        end.

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
    /* Quando tt-param.destino = 3 ("Terminal"), ao final da execuîÒo do programa, serÙ mostrado o arquivo em Excel. */
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
