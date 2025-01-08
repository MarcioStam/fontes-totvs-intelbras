/* include de controle de vers∆o */
{include/i-prgvrs.i ESAQP017RP 1.00.00.000}

/* prÇprocessador para ativar ou n∆o a sa°da para RTF */
&global-define RTF no

/* definiá∆o das temp-tables para recebimento de parÉmetros */
{esp/aqp/esaqp017tt.i}

/* recebimento de parÉmetros */
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/**************************** Variaveis ****************************************/
define variable chExcel                 as component-handle              no-undo.
define variable chArquivo               as component-handle              no-undo.
define variable chPlanilha              as component-handle              no-undo.
define variable c-path-excel            as character format "x(256)"     no-undo.
define variable i-acomp                 as int                           no-undo.
define variable h-acomp                 as handle                        no-undo.
define variable v_des_destino           as char      format "x(30)"      no-undo.
define variable i-cont                  as int                           no-undo.
define variable v_des_orig_prob         as char      format "x(40)"      no-undo.
define variable v_des_produto           as char      format "x(40)"      no-undo.
define variable v_des_lin_prod          as char      format "x(40)"      no-undo.
define variable v_des_estab             as char      format "x(40)"      no-undo.
define variable v_des_tipo_lote         as char      format "x(40)"      no-undo.
define variable v_des_unid_neg          as char      format "x(40)"      no-undo.
define variable v_des_componente        as char      format "x(40)"      no-undo.
define variable v_des_problema          as char      format "x(40)"      no-undo.
define variable v_it_corrente           like item.it-codigo              no-undo.
define variable i-linha                 as int                           no-undo.
define variable i-linha-total           as int                           no-undo.
define variable v_linha_corrente        as int                           no-undo.
define variable v_tot_testados          as int                           no-undo.
define variable v_ponderacao            as dec                           no-undo.
define variable v_tot_pond_linha        as dec                           no-undo.
define variable v_indice_unit           as dec                           no-undo.
define variable v_indice_mil            as dec                           no-undo.
define variable v_tot_testados_geral    as dec                           no-undo.
define variable v_tot_ponderac_geral    as dec                           no-undo.
define variable v_tot_indicuni_geral    as dec                           no-undo.
define variable v_tot_indicmil_geral    as dec                           no-undo.

/*********** Temp-tables ***************/
define temp-table tt-produtos
    field it-codigo like auditoria-geral.it-codigo
    field qt-produto as int.

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

/* executando de forma persistente o utilit†rio de acompanhamento */
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}
run pi-inicializar in h-acomp (input return-value).

if tt-param.destino = 3 or
   tt-param.destino = 1 then
    assign v_des_destino = string(session:temp-directory + "ESAQP017" + string (time) + ".csv").
else
    assign v_des_destino = string(tt-param.arquivo).

output to value(v_des_destino).
output close.

run pi-cria-planilha.

assign i-linha = 6.

/** L¢gica para impress∆o das informaá‰es **/
for each auditoria-geral no-lock
   where auditoria-geral.dt-amostragem   >= tt-param.dat-adic-ini
     and auditoria-geral.dt-amostragem   <= tt-param.dat-adic-fim
     break by auditoria-geral.nr-linha
           by auditoria-geral.it-codigo:

    if first-of(auditoria-geral.nr-linha) then do:
        if v_tot_testados   > 0 or
           v_tot_pond_linha > 0 or
           v_indice_unit    > 0 or
           v_indice_mil     > 0 then do: /*** Verifica se est∆o com valor, para impress∆o dos totais da linha anterior **/

            chExcel:Range("D" + string(i-linha-total)):select.
            chExcel:selection:value = v_tot_testados.
            
            assign i-linha        = i-linha + 1
                   v_indice_unit  = v_tot_pond_linha / v_tot_testados
                   v_indice_mil   = v_indice_unit * 1000.
            
            chExcel:Range("E" + string(i-linha)):select.
            chExcel:selection:value = "Ponderaá∆o:".
            chExcel:selection:Font:Bold           = True.
            chExcel:selection:Interior:ColorIndex = 20.
            chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
            
            chExcel:Range("F" + string(i-linha)):select.
            chExcel:selection:value = v_tot_pond_linha.
            
            chExcel:Range("G" + string(i-linha)):select.
            chExcel:selection:value = "Indice Unit†rio:".
            chExcel:selection:Font:Bold           = True.
            chExcel:selection:Interior:ColorIndex = 20.
            chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
            
            chExcel:Range("H" + string(i-linha)):select.
            chExcel:selection:value = v_indice_unit.
            
            chExcel:Range("I" + string(i-linha)):select.
            chExcel:selection:value = "Indice por Mil:".
            chExcel:selection:Font:Bold           = True.
            chExcel:selection:Interior:ColorIndex = 20.
            chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
            
            chExcel:Range("J" + string(i-linha)):select.
            chExcel:selection:value = v_indice_mil.
            
            assign v_tot_testados_geral = v_tot_testados_geral + v_tot_testados
                   v_tot_ponderac_geral = v_tot_ponderac_geral + v_tot_pond_linha
                   v_tot_indicuni_geral = v_tot_indicuni_geral + v_indice_unit
                   v_tot_indicmil_geral = v_tot_indicmil_geral + v_indice_mil
                   v_tot_testados       = 0
                   v_tot_pond_linha     = 0
                   v_indice_unit        = 0
                   v_indice_mil         = 0.

        end.
        assign v_linha_corrente = auditoria-geral.nr-linha.
    end.

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

    IF tt-param.nr-orig-prob <> 0 THEN DO:
        IF NOT CAN-FIND (FIRST auditoria-visual 
                         WHERE auditoria-visual.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria
                           AND auditoria-visual.nr-seq-orig-prob = tt-param.nr-orig-prob) THEN
            NEXT.
    END.

    if first-of(auditoria-geral.nr-linha) or 
       auditoria-geral.nr-linha = v_linha_corrente then do:

        assign i-linha-total         = i-linha
               i-linha               = i-linha + 1
               v_linha_corrente      = ?
               v_tot_testados        = 0.

        chExcel:Range("A" + string(i-linha-total)):select.
        chExcel:selection:value = "Linha Produá∆o".
        chExcel:selection:Font:Bold           = True.
        chExcel:selection:Interior:ColorIndex = 20.
        chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
        
        find first lin-prod no-lock
             where lin-prod.cod-estabel = auditoria-geral.cod-estabel
               AND lin-prod.nr-linha = auditoria-geral.nr-linha no-error.
        if avail lin-prod then do:
            chExcel:Range("B" + string(i-linha-total)):select.
            chExcel:selection:value = string(auditoria-geral.nr-linha) + lin-prod.descricao.
        end.
        
        chExcel:Range("C" + string(i-linha-total)):select.
        chExcel:selection:value = "Total Testado:".
        chExcel:selection:Font:Bold           = True.
        chExcel:selection:Interior:ColorIndex = 20.
        chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

        chExcel:Range("A" + string(i-linha)):select.
        chExcel:selection:value = "Produto".
        
        chExcel:Range("B" + string(i-linha)):select.
        chExcel:selection:value = "Descriá∆o".
        
        chExcel:Range("C" + string(i-linha)):select.
        chExcel:selection:value = "Problema".
        
        chExcel:Range("D" + string(i-linha)):select.
        chExcel:selection:value = "Origem".
        
        chExcel:Range("E" + string(i-linha)):select.
        chExcel:selection:value = "Cart∆o".
        
        chExcel:Range("F" + string(i-linha)):select.
        chExcel:selection:value = "Causa".
        
        chExcel:Range("G" + string(i-linha)):select.
        chExcel:selection:value = "Data Problema".
        
        chExcel:Range("H" + string(i-linha)):select.
        chExcel:selection:value = "Peso".

        chExcel:Range("I" + string(i-linha)):select.
        chExcel:selection:value = "Qtd".
        
        chExcel:Range("J" + string(i-linha)):select.
        chExcel:selection:value = "Pond.".
        
        
        chExcel:Range("A" + string(i-linha) + ":J" + string(i-linha)):select.
        chExcel:selection:Font:Bold           = True.
        chExcel:selection:Interior:ColorIndex = 20.
        chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    end.

    assign i-acomp = i-acomp + 1. 
        
    run pi-acompanhar in h-acomp (input string(i-acomp)).
    
    for each auditoria-visual no-lock
       where auditoria-visual.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria
         and (if tt-param.nr-orig-prob <> 0 then
              auditoria-visual.nr-seq-orig-prob = tt-param.nr-orig-prob else auditoria-visual.nr-seq-orig-prob > 0):
        
        find first item no-lock where item.it-codigo = auditoria-geral.it-codigo no-error.

        assign v_des_produto  = if avail item then item.desc-item else ""
               v_tot_testados = v_tot_testados + 1
               i-linha        = i-linha + 1.

        find first aq-problema no-lock
             where aq-problema.nr-seq-problema = auditoria-visual.nr-seq-problema no-error.
        if avail aq-problema then
            assign v_des_problema = aq-problema.des-problema.
        else
            assign v_des_problema = "".

        find first aq-categoria no-lock
             where aq-categoria.nr-seq-categoria = auditoria-visual.nr-seq-categoria no-error.

        find first tt-produtos exclusive-lock
             where tt-produtos.it-codigo = auditoria-geral.it-codigo no-error.
        if not avail tt-produtos then do:
            create tt-produtos.
            assign tt-produtos.it-codigo = auditoria-geral.it-codigo.
        end.

        find first aq-origem-prob no-lock
             where aq-origem-prob.nr-seq-orig-prob = auditoria-visual.nr-seq-orig-prob no-error.
        if avail aq-origem-prob then
            assign v_des_orig_prob = aq-origem-prob.des-orig-prob.
        else
            assign v_des_orig_prob = "".

        assign tt-produtos.qt-produto = tt-produtos.qt-produto + 1.

        chExcel:Range("A" + string(i-linha)):select.
        chExcel:selection:value = auditoria-geral.it-codigo.

        chExcel:Range("B" + string(i-linha)):select.
        chExcel:selection:value = v_des_produto.

        chExcel:Range("C" + string(i-linha)):select.
        chExcel:selection:value = v_des_problema.

        chExcel:Range("D" + string(i-linha)):select.
        chExcel:selection:value = v_des_orig_prob.

        chExcel:Range("E" + string(i-linha)):select.
        chExcel:selection:value = auditoria-visual.nr-cartao.
        
        chExcel:Range("F" + string(i-linha)):select.
        chExcel:selection:value = auditoria-visual.obs-causa.
        
        chExcel:Range("G" + string(i-linha)):select.
        chExcel:selection:value = auditoria-geral.dt-amostragem .

        chExcel:Range("H" + string(i-linha)):select.
        chExcel:selection:value = aq-categoria.peso.

        chExcel:Range("I" + string(i-linha)):select.
        chExcel:selection:value = auditoria-visual.qt-problema.

        assign v_ponderacao = aq-categoria.peso * auditoria-visual.qt-problema.

        chExcel:Range("J" + string(i-linha)):select.
        chExcel:selection:value = v_ponderacao.

        assign v_tot_pond_linha = v_tot_pond_linha + v_ponderacao.
       
    end.
    
    if last-of(auditoria-geral.nr-linha) then do:
        chExcel:Range("D" + string(i-linha-total)):select.
        chExcel:selection:value = v_tot_testados.

        assign i-linha        = i-linha + 1
               v_indice_unit  = v_tot_pond_linha / v_tot_testados
               v_indice_mil   = v_indice_unit * 1000.

        chExcel:Range("E" + string(i-linha)):select.
        chExcel:selection:value = "Ponderaá∆o:".
        chExcel:selection:Font:Bold           = True.
        chExcel:selection:Interior:ColorIndex = 20.
        chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

        chExcel:Range("F" + string(i-linha)):select.
        chExcel:selection:value = v_tot_pond_linha.

        chExcel:Range("G" + string(i-linha)):select.
        chExcel:selection:value = "Indice Unit†rio:".
        chExcel:selection:Font:Bold           = True.
        chExcel:selection:Interior:ColorIndex = 20.
        chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
       
        chExcel:Range("H" + string(i-linha)):select.
        chExcel:selection:value = v_indice_unit.

        chExcel:Range("I" + string(i-linha)):select.
        chExcel:selection:value = "Indice por Mil:".
        chExcel:selection:Font:Bold           = True.
        chExcel:selection:Interior:ColorIndex = 20.
        chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

        chExcel:Range("J" + string(i-linha)):select.
        chExcel:selection:value = v_indice_mil.

        assign v_tot_testados_geral = v_tot_testados_geral + v_tot_testados
               v_tot_ponderac_geral = v_tot_ponderac_geral + v_tot_pond_linha
               v_tot_indicuni_geral = v_tot_indicuni_geral + v_indice_unit
               v_tot_indicmil_geral = v_tot_indicmil_geral + v_indice_mil
               v_tot_testados       = 0
               v_tot_pond_linha     = 0
               v_indice_unit        = 0
               v_indice_mil         = 0.
    end.
end.

assign i-linha = i-linha + 2.

chExcel:Range("B" + string(i-linha) + ":C" + string(i-linha)):select.     
chExcel:selection:MergeCells = true.
chExcel:selection:value = "Resumo".
chExcel:selection:Font:Bold           = True.
chExcel:selection:Interior:ColorIndex = 20.
chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
chExcel:selection:HorizontalAlignment = {&xlCenter}.

assign i-linha = i-linha + 1.
                                                    
chExcel:Range("B" + string(i-linha)):select.        
chExcel:selection:value = "Total Problemas Encontrados:".
chExcel:selection:Font:Bold           = True.
chExcel:selection:Interior:ColorIndex = 20.
chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

chExcel:Range("C" + string(i-linha)):select.        
chExcel:selection:value = v_tot_testados_geral. 

assign i-linha = i-linha + 1.
                                                    
chExcel:Range("B" + string(i-linha)):select.        
chExcel:selection:value = "Ponderaá∆o:".    
chExcel:selection:Font:Bold           = True.
chExcel:selection:Interior:ColorIndex = 20.
chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
                                                    
chExcel:Range("C" + string(i-linha)):select.        
chExcel:selection:value = v_tot_ponderac_geral.          
                                                    
assign i-linha = i-linha + 1.
                                                    
chExcel:Range("B" + string(i-linha)):select.        
chExcel:selection:value = "÷ndice Unit†rio:".  
chExcel:selection:Font:Bold           = True.
chExcel:selection:Interior:ColorIndex = 20.
chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
                                                    
chExcel:Range("C" + string(i-linha)):select.        
chExcel:selection:value = v_tot_indicuni_geral.   

assign i-linha = i-linha + 1.
                                                    
chExcel:Range("B" + string(i-linha)):select.        
chExcel:selection:value = "÷ndice por Mil:".    
chExcel:selection:Font:Bold           = True.
chExcel:selection:Interior:ColorIndex = 20.
chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
                                                    
chExcel:Range("C" + string(i-linha)):select.        
chExcel:selection:value = v_tot_indicmil_geral.   

/*** Total de produtos testados ***/
if avail tt-produtos then do:
    assign i-linha = i-linha + 2.
    chExcel:Range("A" + string(i-linha) + ":C" + string(i-linha)):select.     
    chExcel:selection:MergeCells = true.
    chExcel:selection:value = "Total de Produtos Testados".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    chExcel:selection:HorizontalAlignment = {&xlCenter}.
    
    assign i-linha = i-linha + 1.
    
    chExcel:Range("A" + string(i-linha) + ":B" + string(i-linha)):select.   
    chExcel:selection:MergeCells = true.
    chExcel:selection:value = "Produto".    
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
    chExcel:Range("C" + string(i-linha)):select.        
    chExcel:selection:value = "Total".    
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
    assign i-linha = i-linha + 1.
    
    for each tt-produtos:
        find first item no-lock
            where item.it-codigo = tt-produtos.it-codigo no-error.
        if avail item then
          assign v_des_produto = item.desc-item.

        chExcel:Range("A" + string(i-linha)):select.        
        chExcel:selection:value = tt-produtos.it-codigo.

        chExcel:Range("B" + string(i-linha)):select.        
        chExcel:selection:value = v_des_produto. 

        chExcel:Range("C" + string(i-linha)):select.        
        chExcel:selection:value = tt-produtos.qt-produto. 
    end.
end.

procedure pi-cria-planilha:

    create "Excel.Application":U chExcel connect no-error.
    if error-status:error then 
        create "Excel.Application":U chExcel.
    
    assign chArquivo  = chExcel:Workbooks:Open(v_des_destino).
           chPlanilha = chArquivo:Sheets:Item(1).

    chPlanilha:SaveAs(replace(v_des_destino, ".csv", ".xlsx"),"51",,,,,) no-error.
    os-delete silent value(v_des_destino).
    
    chExcel:Range("A1"):select.
    chExcel:selection:value = "Problemas encontrados - pontuaá∆o".

    chExcel:Range("A2"):select.
    chExcel:selection:value = "Per°odo".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    chExcel:Range("B2"):select.
    chExcel:selection:value = string(tt-param.dat-adic-ini) + " |<>| " + string(tt-param.dat-adic-fim).
    
    chExcel:Range("A3"):select.
    chExcel:selection:value = "Tipo Produto".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
    
    if tt-param.nr-linha = 0 then do:
        assign v_des_lin_prod = "Todas".
        chExcel:Range("B3"):select.
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

        chExcel:Range("B3"):select.
        chExcel:selection:value = tt-param.nr-linha.
        
        chExcel:Range("C3"):select.
        chExcel:selection:value = v_des_lin_prod.
    end.

    if tt-param.cod-estabel = "" then do:
        assign v_des_estab = "Todos".
        chExcel:Range("H2"):select.
        chExcel:selection:value = v_des_lin_prod.
    end.
    else do:
        chExcel:Range("H2"):select.
        chExcel:selection:value = tt-param.cod-estabel.
    end.

    chExcel:Range("A4"):select.
    chExcel:selection:value = "Tipo Lote".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    if tt-param.tip-lote = 0 then do:
        assign v_des_tipo_lote = "Todos".
        chExcel:Range("B4"):select.
        chExcel:selection:value = v_des_tipo_lote.
    end.
    else do:
        find first aq-tipo-lote NO-LOCK
             where aq-tipo-lote.nr-seq-tipo-lote = tt-param.tip-lote no-error.
        if avail aq-tipo-lote then
            assign v_des_tipo_lote = aq-tipo-lote.des-lote.
        else
            assign v_des_tipo_lote = "".

        chExcel:Range("B4"):select.
        chExcel:selection:value = tt-param.tip-lote.

        chExcel:Range("C4"):select.
        chExcel:selection:value = v_des_tipo_lote.

    end.

    chExcel:Range("D2"):select.
    chExcel:selection:value = "Produto".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    if tt-param.it-codigo = "" then do:
        assign v_des_produto = "Todos".
        chExcel:Range("E2"):select.
        chExcel:selection:value = v_des_produto.
    end.
    else do:
        find first item no-lock
            where item.it-codigo = tt-param.it-codigo no-error.
        if avail item then
          assign v_des_produto = item.desc-item.
        
        chExcel:Range("E2"):select.
        chExcel:selection:value = tt-param.it-codigo.

        chExcel:Range("F2"):select.
        chExcel:selection:value = v_des_produto.
    end.
    
    chExcel:Range("D3"):select.
    chExcel:selection:value = "Origem".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.


    chExcel:Range("G2"):select.
    chExcel:selection:value = "Estabelecimento".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    if tt-param.nr-orig-prob = 0 then do:
        assign v_des_orig_prob = "Todas".
        chExcel:Range("E3"):select.
        chExcel:selection:value = v_des_orig_prob.
    end.
    else do:
        find first aq-origem-prob no-lock
             where aq-origem-prob.nr-seq-orig-prob = tt-param.nr-orig-prob no-error.
        if avail aq-origem-prob then
            assign v_des_orig_prob = aq-origem-prob.des-orig-prob.
        else
            assign v_des_orig_prob = "".

        chExcel:Range("E3"):select.
        chExcel:selection:value = tt-param.nr-orig-prob.

        chExcel:Range("F3"):select.
        chExcel:selection:value = v_des_orig_prob.
    end.

    chExcel:Range("D4"):select.
    chExcel:selection:value = "Unidade de Neg¢cio".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    

    if tt-param.cod-uneg = "" then do:
        assign v_des_unid_neg = "Todas".
        chExcel:Range("E4"):select.
        chExcel:selection:value = v_des_unid_neg.
    end.
    else do:
        find first unid-negoc no-lock
             where unid-negoc.cod-unid-negoc = tt-param.cod-uneg no-error.
        if avail unid-negoc then
            assign v_des_unid_neg = unid-negoc.des-unid-negoc.

        chExcel:Range("E4"):select.
        chExcel:selection:value = tt-param.cod-uneg.

        chExcel:Range("F4"):select.
        chExcel:selection:value = v_des_unid_neg.
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
        chArquivo:SaveAs(v_des_destino, {&xlNormal}, "", "", False, False, False).
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
