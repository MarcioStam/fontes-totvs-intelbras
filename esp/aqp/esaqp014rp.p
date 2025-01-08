/* include de controle de vers∆o */
{include/i-prgvrs.i ESAQP014RP 1.00.00.000}

/* prÇprocessador para ativar ou n∆o a sa°da para RTF */
&global-define RTF no

/* definiá∆o das temp-tables para recebimento de parÉmetros */
{esp/aqp/esaqp014tt.i}

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
define variable v_des_tipo_lote         as char      format "x(40)"      no-undo.
define variable v_des_unid_neg          as char      format "x(40)"      no-undo.
define variable v_des_componente        as char      format "x(40)"      no-undo.
define variable v_des_problema          as char      format "x(40)"      no-undo.
/*define variable v_linha_corrente        like item.nr-linha               no-undo.*/
define variable i-linha                 as int                           no-undo.
define variable i-linha-total           as int                           no-undo.
define variable v_tot_lotes_revisados   as int                           no-undo.
define variable v_tot_qtd_revisados     as int                           no-undo.

DEFINE TEMP-TABLE tt-auditoria-geral LIKE auditoria-geral.


/* executando de forma persistente o utilit†rio de acompanhamento */
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}
run pi-inicializar in h-acomp (input return-value).

if tt-param.destino = 3 or
   tt-param.destino = 1 then
    assign v_des_destino = string(session:temp-directory + "ESAQP014" + string (time) + ".xlsx").
else
    assign v_des_destino = string(tt-param.arquivo).

run pi-cria-planilha.

assign i-linha = 3.

EMPTY TEMP-TABLE tt-auditoria-geral.

/** L¢gica para impress∆o das informaá‰es **/
for each auditoria-geral no-lock
   where auditoria-geral.dt-amostragem   >= tt-param.dat-adic-ini
     and auditoria-geral.dt-amostragem   <= tt-param.dat-adic-fim
     and auditoria-geral.ind-amostragem   = 1
     and (auditoria-geral.log-revisado OR auditoria-geral.log-bloqueio),
     first item no-lock
     where item.it-codigo = auditoria-geral.it-codigo
     break by auditoria-geral.nr-linha:
    
    if tt-param.tip-lote <> 0 and 
       auditoria-geral.nr-seq-tipo-lote <> tt-param.tip-lote then
        next.

    IF tt-param.cod-estabel <> "" AND
       tt-param.cod-estabel <> auditoria-geral.cod-estabel THEN
        NEXT.

    if tt-param.it-codigo <> "" and /** C¢digo produto n∆o informado **/
       tt-param.it-codigo <> auditoria-geral.it-codigo then
        next.

    if tt-param.nr-linha <> 0  and /** Linha de produá∆o n∆o informada **/
       tt-param.nr-linha <> auditoria-geral.nr-linha then
        next.
    
    if tt-param.cod-uneg <> "" and
       auditoria-geral.cod-unid-negoc <> tt-param.cod-uneg then
        next.

    IF tt-param.tipo-lote = 1 AND  /** Somente Revisados **/
       NOT auditoria-geral.log-revisado THEN
        NEXT.

    IF tt-param.tipo-lote = 2 AND /** Somente Bloqueados **/
       NOT auditoria-geral.log-bloqueio THEN
        NEXT.

    IF  tt-param.auditor <> "" AND auditoria-geral.des-auditor <> tt-param.auditor THEN
        NEXT.


    CREATE tt-auditoria-geral.
    BUFFER-COPY auditoria-geral TO tt-auditoria-geral.

END.

FOR EACH tt-auditoria-geral,
    FIRST ITEM
    WHERE ITEM.it-codigo = tt-auditoria-geral.it-codigo
    BREAK BY tt-auditoria-geral.nr-linha:

    /*
    if first-of(tt-auditoria-geral.nr-linha) then do:

        if v_tot_qtd_revisados   > 0 or
           v_tot_lotes_revisados > 0 then do: /*** Verifica se est∆o com valor, para impress∆o dos totais da linha anterior **/
            chExcel:Range("D" + string(i-linha-total)):select.
            chExcel:selection:value = v_tot_qtd_revisados.

            chExcel:Range("F" + string(i-linha-total)):select.
            chExcel:selection:value = v_tot_lotes_revisados.

        end.
        assign v_linha_corrente = tt-auditoria-geral.nr-linha.

    end.
    */

    if first-of(tt-auditoria-geral.nr-linha) /*or 
       tt-auditoria-geral.nr-linha = v_linha_corrente*/ then do:

        assign i-linha               = i-linha + 1
               i-linha-total         = i-linha
               i-linha               = i-linha + 1
               /*v_linha_corrente      = ?*/
               v_tot_lotes_revisados  = 0
               v_tot_qtd_revisados    = 0.

        chExcel:Range("A" + string(i-linha-total)):select.
        chExcel:selection:value = "Linha".
        chExcel:selection:Font:Bold           = True.
        chExcel:selection:Interior:ColorIndex = 20.
        chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
        
        find first lin-prod no-lock
             where lin-prod.cod-estabel = tt-auditoria-geral.cod-estabel
               AND lin-prod.nr-linha    = tt-auditoria-geral.nr-linha no-error.
        if avail lin-prod then do:
            chExcel:Range("B" + string(i-linha-total)):select.
            chExcel:selection:value = string(tt-auditoria-geral.nr-linha) + " - " + lin-prod.descricao.
        end.
        
        chExcel:Range("C" + string(i-linha-total)):select.
        chExcel:selection:value = "Total:".
        chExcel:selection:Font:Bold           = True.
        chExcel:selection:Interior:ColorIndex = 20.
        chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
        
        chExcel:Range("E" + string(i-linha-total)):select.
        chExcel:selection:value = "Lotes Revisados:".
        chExcel:selection:Font:Bold           = True.
        chExcel:selection:Interior:ColorIndex = 20.
        chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

        chExcel:Range("A" + string(i-linha)):select.
        chExcel:selection:value = "Produto".
        
        chExcel:Range("B" + string(i-linha)):select.
        chExcel:selection:value = "Descriá∆o".
        
        chExcel:Range("C" + string(i-linha)):select.
        chExcel:selection:value = "Data Amostragem".
        
        chExcel:Range("D" + string(i-linha)):select.
        chExcel:selection:value = "Qtd Revisada".

        chExcel:Range("E" + string(i-linha)):select.
        chExcel:selection:value = "Qtd Bloqueada".
        
        chExcel:Range("F" + string(i-linha)):select.
        chExcel:selection:value = "Problema".
        
        chExcel:Range("G" + string(i-linha)):select.
        chExcel:selection:value = "Linha Detectou".
        
        chExcel:Range("H" + string(i-linha)):select.
        chExcel:selection:value = "Nr Cart∆o".
        
        chExcel:Range("I" + string(i-linha)):select.
        chExcel:selection:value = "Origem".
        
        chExcel:Range("J" + string(i-linha)):select.
        chExcel:selection:value = "Componente".

        chExcel:Range("K" + string(i-linha)):select.
        chExcel:selection:value = "Descriá∆o".
        
        
        chExcel:Range("A" + string(i-linha) + ":J" + string(i-linha)):select.
        chExcel:selection:Font:Bold           = True.
        chExcel:selection:Interior:ColorIndex = 20.
        chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    end.

    assign i-acomp                = i-acomp + 1
           /*i-linha                = i-linha + 1*/
           v_tot_lotes_revisados  = v_tot_lotes_revisados + 1
           v_tot_qtd_revisados    = v_tot_qtd_revisados + tt-auditoria-geral.qt-prod-lote. 
        
    run pi-acompanhar in h-acomp (input string(i-acomp)).
    
    for each auditoria-visual no-lock
       where auditoria-visual.nr-seq-auditoria = tt-auditoria-geral.nr-seq-auditoria
    break by auditoria-visual.nr-seq-auditoria:

        

        find first aq-origem-prob no-lock
             where aq-origem-prob.nr-seq-orig-prob = auditoria-visual.nr-seq-orig-prob no-error.
        if avail aq-origem-prob then
            assign v_des_orig_prob = aq-origem-prob.des-orig-prob.
        else
            assign v_des_orig_prob = "".

        find first aq-comp-prod no-lock
             where aq-comp-prod.nr-seq-comp = auditoria-visual.nr-seq-comp no-error.
        if avail aq-comp-prod then
            assign v_des_componente = aq-comp-prod.des-componente.
        else
            assign v_des_componente = "".

        assign v_des_produto = item.desc-item
               i-linha       = i-linha + 1.
        
        if first-of(auditoria-visual.nr-seq-auditoria) then do:
            chExcel:Range("A" + string(i-linha)):select.
            chExcel:selection:value = tt-auditoria-geral.it-codigo.
            
            chExcel:Range("B" + string(i-linha)):select.
            chExcel:selection:value = v_des_produto.
            
            chExcel:Range("C" + string(i-linha)):select.
            chExcel:selection:value = tt-auditoria-geral.dt-amostragem.
            
            chExcel:Range("D" + string(i-linha)):select.
            chExcel:selection:value = tt-auditoria-geral.qt-prod-lote.

            chExcel:Range("E" + string(i-linha)):select.
            chExcel:selection:value = tt-auditoria-geral.qtd-prod-bloq.
        end.

        find first aq-problema no-lock
             where aq-problema.nr-seq-problema = auditoria-visual.nr-seq-problema no-error.
        if avail aq-problema then
            assign v_des_problema = aq-problema.des-problema.
        else
            assign v_des_problema = "".

        chExcel:Range("F" + string(i-linha)):select.
        chExcel:selection:value = v_des_problema.
        
        if auditoria-visual.ind-problema = 1 then do:
            chExcel:Range("G" + string(i-linha)):select.
            chExcel:selection:value = "Sim". 
        end.
        else do:
            chExcel:Range("G" + string(i-linha)):select.
            chExcel:selection:value = "N∆o". 

        end.

        chExcel:Range("H" + string(i-linha)):select.
        chExcel:selection:value = auditoria-visual.nr-cartao .

        chExcel:Range("I" + string(i-linha)):select.
        chExcel:selection:value = v_des_orig_prob.

        chExcel:Range("J" + string(i-linha)):select.
        chExcel:selection:value = auditoria-visual.nr-seq-comp.

        chExcel:Range("K" + string(i-linha)):select.
        chExcel:selection:value = v_des_componente.

        
       
    end.

    if last-of(tt-auditoria-geral.nr-linha) then do:
        chExcel:Range("D" + string(i-linha-total)):select.
        chExcel:selection:value = v_tot_qtd_revisados.

        chExcel:Range("F" + string(i-linha-total)):select.
        chExcel:selection:value = v_tot_lotes_revisados.

        assign v_tot_lotes_revisados = 0
               v_tot_qtd_revisados   = 0.
    end.
end.             

procedure pi-cria-planilha:

    create "Excel.Application":U chExcel connect no-error.
    if error-status:error then 
        create "Excel.Application":U chExcel.
    
    assign chArquivo  = chExcel:Workbooks:Add().
           chPlanilha = chArquivo:Sheets:Item(1).
    
    chPlanilha:SaveAs(v_des_destino, {&xlNormal}, "", "", False, False, False).
    
    chExcel:Range("A1"):select.
    chExcel:selection:value = "Linha Produá∆o".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
    if tt-param.nr-linha = 0 then do:
        assign v_des_lin_prod = "Todas".
        chExcel:Range("B1"):select.
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

        chExcel:Range("B1"):select.
        chExcel:selection:value = tt-param.nr-linha.
        
        chExcel:Range("C1"):select.
        chExcel:selection:value = v_des_lin_prod.
    end.
    
    chExcel:Range("A2"):select.
    chExcel:selection:value = "Per°odo".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
    chExcel:Range("B2"):select.
    chExcel:selection:value = string(tt-param.dat-adic-ini) + " |<>| " + string(tt-param.dat-adic-fim).

    chExcel:Range("D1"):select.
    chExcel:selection:value = "Tipo Lote".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
    chExcel:Range("D2"):select.
    chExcel:selection:value = "Tipo Produto".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    chExcel:Range("G1"):select.
    chExcel:selection:value = "Unidade de Neg¢cio".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
    chExcel:Range("G2"):select.
    chExcel:selection:value = "Auditor".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    if tt-param.tip-lote = 0 then do:
        assign v_des_tipo_lote = "Todos".
        chExcel:Range("E1"):select.
        chExcel:selection:value = v_des_tipo_lote.
    end.
    else do:
        find first aq-tipo-lote NO-LOCK
             where aq-tipo-lote.nr-seq-tipo-lote = tt-param.tip-lote no-error.
        if avail aq-tipo-lote then
            assign v_des_tipo_lote = aq-tipo-lote.des-lote.
        else
            assign v_des_tipo_lote = "".

        chExcel:Range("E1"):select.
        chExcel:selection:value = tt-param.tip-lote.

        chExcel:Range("F1"):select.
        chExcel:selection:value = v_des_tipo_lote.

    end.


    if tt-param.it-codigo = "" then
        assign v_des_produto = "Todos".
    else do:
        find first item no-lock
            where item.it-codigo = tt-param.it-codigo no-error.
        if avail item then
          assign v_des_produto = item.desc-item.
    end.

    chExcel:Range("E2"):select.
    chExcel:selection:value = v_des_produto.

    if tt-param.cod-uneg = "" then
        assign v_des_unid_neg = "Todas".
    else do:
        find first unid-negoc no-lock
             where unid-negoc.cod-unid-negoc = tt-param.cod-uneg no-error.
        if avail unid-negoc then
            assign v_des_unid_neg = unid-negoc.des-unid-negoc.
    end.
    
    chExcel:Range("H1"):select.
    chExcel:selection:value = v_des_unid_neg.

    chExcel:Range("H2"):select.
    chExcel:selection:value = IF tt-param.auditor <> "" THEN tt-param.auditor ELSE "Todos".


end procedure.

chExcel:Columns('A:L'):EntireColumn:Autofit NO-ERROR.

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
