/* include de controle de vers∆o */
{include/i-prgvrs.i ESAQP018RP 1.00.00.000}

/* prÇprocessador para ativar ou n∆o a sa°da para RTF */
&global-define RTF no

/* definiá∆o das temp-tables para recebimento de parÉmetros */
{esp/aqp/esaqp018tt.i}

{upc/btb910za-upc.i} /* Definiá∆o da vari†vel New Global Shared "v_cod_estab_usuar" */

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
define variable v_it_corrente           like item.it-codigo              no-undo.
define variable i-linha                 as int                           no-undo.
DEFINE VARIABLE v_des_problema          AS CHAR      FORMAT "x(40)"      NO-UNDO.

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
    assign v_des_destino = string(session:temp-directory + "ESAQP018" + string (time) + ".csv").
else
    assign v_des_destino = string(tt-param.arquivo).

output to value(v_des_destino).
output close.

run pi-cria-planilha.

assign i-linha = 5.

/** L¢gica para impress∆o das informaá‰es **/
for each auditoria-geral no-lock
   where auditoria-geral.dt-amostragem   >= tt-param.dat-adic-ini
     and auditoria-geral.dt-amostragem   <= tt-param.dat-adic-fim,
     first item no-lock
     where item.it-codigo = auditoria-geral.it-codigo
     break by auditoria-geral.it-codigo:

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
    
    for each auditoria-visual no-lock
       where auditoria-visual.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria
         and (if tt-param.nr-orig-prob <> 0 then
              auditoria-visual.nr-seq-orig-prob = tt-param.nr-orig-prob else auditoria-visual.nr-seq-orig-prob > 0):

        assign i-linha = i-linha + 1.

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
        
        find first aq-problema no-lock
             where aq-problema.nr-seq-problema = auditoria-visual.nr-seq-problema no-error.
        if avail aq-problema then
            assign v_des_problema = aq-problema.des-problema.
        else
            assign v_des_problema = "".

        chExcel:Range("A" + string(i-linha)):select.
        chExcel:selection:value = auditoria-geral.it-codigo.

        chExcel:Range("B" + string(i-linha)):select.
        chExcel:selection:value = item.desc-item.

        chExcel:Range("C" + string(i-linha)):select.
        chExcel:selection:value = string(auditoria-visual.nr-seq-problema) + "-" + v_des_problema.

        chExcel:Range("D" + string(i-linha)):select.
        chExcel:selection:value = auditoria-visual.qt-problema.

        chExcel:Range("E" + string(i-linha)):select.
        chExcel:selection:value = v_des_orig_prob.

        chExcel:Range("F" + string(i-linha)):select.
        chExcel:selection:value = string(auditoria-visual.nr-seq-comp) + "-" + v_des_componente.

        chExcel:Range("G" + string(i-linha)):select.
        chExcel:selection:value = replace( replace(auditoria-visual.obs-causa, CHR(10), " "), CHR(13), "").
                                                                                 
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
    chExcel:selection:value = "Per°odo".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    chExcel:Range("B1"):select.
    chExcel:selection:value = string(tt-param.dat-adic-ini) + " |<>| " + string(tt-param.dat-adic-fim).
    
    chExcel:Range("A2"):select.
    chExcel:selection:value = "Tipo Produto".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
    
    if tt-param.nr-linha = 0 then do:
        assign v_des_lin_prod = "Todas".
        chExcel:Range("B2"):select.
        chExcel:selection:value = v_des_lin_prod.
    end.
    else do:
        find first lin-prod no-lock
             where lin-prod.cod-estabel = v_cod_estab_usuar
               AND lin-prod.nr-linha = tt-param.nr-linha no-error.
        if avail lin-prod then
            assign v_des_lin_prod = lin-prod.descricao.
        else
            assign v_des_lin_prod = "".

        chExcel:Range("B2"):select.
        chExcel:selection:value = tt-param.nr-linha.
        
        chExcel:Range("C2"):select.
        chExcel:selection:value = v_des_lin_prod.
    end.

    chExcel:Range("A3"):select.
    chExcel:selection:value = "Tipo Lote".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    if tt-param.tip-lote = 0 then do:
        assign v_des_tipo_lote = "Todos".
        chExcel:Range("B3"):select.
        chExcel:selection:value = v_des_tipo_lote.
    end.
    else do:
        find first aq-tipo-lote NO-LOCK
             where aq-tipo-lote.nr-seq-tipo-lote = tt-param.tip-lote no-error.
        if avail aq-tipo-lote then
            assign v_des_tipo_lote = aq-tipo-lote.des-lote.
        else
            assign v_des_tipo_lote = "".

        chExcel:Range("B3"):select.
        chExcel:selection:value = tt-param.tip-lote.

        chExcel:Range("C3"):select.
        chExcel:selection:value = v_des_tipo_lote.

    end.

    chExcel:Range("D1"):select.
    chExcel:selection:value = "Produto".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    if tt-param.it-codigo = "" then do:
        assign v_des_produto = "Todos".
        chExcel:Range("E1"):select.
        chExcel:selection:value = v_des_produto.
    end.
    else do:
        find first item no-lock
            where item.it-codigo = tt-param.it-codigo no-error.
        if avail item then
          assign v_des_produto = item.desc-item.
        
        chExcel:Range("E1"):select.
        chExcel:selection:value = tt-param.it-codigo.

        chExcel:Range("F1"):select.
        chExcel:selection:value = v_des_produto.
    end.
    
    chExcel:Range("D2"):select.
    chExcel:selection:value = "Origem".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    if tt-param.nr-orig-prob = 0 then do:
        assign v_des_orig_prob = "Todas".
        chExcel:Range("E2"):select.
        chExcel:selection:value = v_des_orig_prob.
    end.
    else do:
        find first aq-origem-prob no-lock
             where aq-origem-prob.nr-seq-orig-prob = tt-param.nr-orig-prob no-error.
        if avail aq-origem-prob then
            assign v_des_orig_prob = aq-origem-prob.des-orig-prob.
        else
            assign v_des_orig_prob = "".

        chExcel:Range("E2"):select.
        chExcel:selection:value = tt-param.nr-orig-prob.

        chExcel:Range("F2"):select.
        chExcel:selection:value = v_des_orig_prob.
    end.

    chExcel:Range("D3"):select.
    chExcel:selection:value = "Unidade de Neg¢cio".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    

    if tt-param.cod-uneg = "" then do:
        assign v_des_unid_neg = "Todas".
        chExcel:Range("E3"):select.
        chExcel:selection:value = v_des_unid_neg.
    end.
    else do:
        find first unid-negoc no-lock
             where unid-negoc.cod-unid-negoc = tt-param.cod-uneg no-error.
        if avail unid-negoc then
            assign v_des_unid_neg = unid-negoc.des-unid-negoc.

        chExcel:Range("E3"):select.
        chExcel:selection:value = tt-param.cod-uneg.

        chExcel:Range("F3"):select.
        chExcel:selection:value = v_des_unid_neg.
    end.

    
    chExcel:Range("A5"):select.
    chExcel:selection:value = "Produto".
    
    chExcel:Range("B5"):select.
    chExcel:selection:value = "Descriá∆o".
    
    chExcel:Range("C5"):select.
    chExcel:selection:value = "Problema".
    
    chExcel:Range("D5"):select.
    chExcel:selection:value = "Nr. Ocorrància".
    
    chExcel:Range("E5"):select.
    chExcel:selection:value = "Origem".
    
    chExcel:Range("F5"):select.
    chExcel:selection:value = "Componente".

    chExcel:Range("G5"):select.
    chExcel:selection:value = "Causa".
    
    chExcel:Range("A5:G5"):select.
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.


end procedure.

chExcel:Columns('A:G'):EntireColumn:Autofit NO-ERROR.

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
