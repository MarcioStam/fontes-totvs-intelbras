/* include de controle de vers∆o */
{include/i-prgvrs.i ESAQP015RP 1.00.00.000}

/* prÇprocessador para ativar ou n∆o a sa°da para RTF */
&global-define RTF no

/* definiá∆o das temp-tables para recebimento de parÉmetros */
{esp/aqp/esaqp015tt.i}

/* recebimento de parÉmetros */
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

FUNCTION fn-turno RETURNS CHAR
    (p-campo AS INT) FORWARD.

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
define variable i-linha-total           as int                           no-undo.
define variable v_lotes_revisados       as int                           no-undo.
DEFINE VARIABLE v_lotes_bloqueados      AS INTEGER                       NO-UNDO.
define variable v_prod_test             as int                           no-undo.
define variable v_prod_lote             as int                           no-undo.
define variable v_prod_lote_revis       as int                           no-undo.
DEFINE VARIABLE v_prod_lote_bloq        AS INTEGER                       NO-UNDO.
define variable v_qtd_testados          as int                           no-undo.
define variable v_tot_lotes_revisados   as int                           no-undo.
DEFINE VARIABLE v_tot_lotes_bloqueados  AS INTEGER                       NO-UNDO.
define variable v_tot_prod_test         as int                           no-undo.
define variable v_tot_prod_lote         as int                           no-undo.
define variable v_tot_prod_lote_revis   as int                           no-undo.
DEFINE VARIABLE v_tot_prod_lote_bloq    AS INTEGER                       NO-UNDO.
define variable v_tot_qtd_testados      as int                           no-undo.
DEFINE VARIABLE v_tot_double_sample    AS INTEGER                       NO-UNDO.

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


DEFINE TEMP-TABLE tt-saida
    FIELD it-codigo             AS CHAR
    FIELD desc-item             AS CHAR
    FIELD qtd-lotes-testados    AS INT
    FIELD qtd-lotes-revisados   AS INT
    FIELD qtd-prod-testados     AS INT
    FIELD qtd-prod-lote         AS INT
    FIELD qtd-prod-revisados    AS INT
    FIELD qtd-lotes-bloqueados  AS INTEGER
    FIELD qtd-prod-bloqueados   AS INTEGER
    FIELD qtd-double-sample     AS INTEGER
    FIELD cod-unid-negoc        LIKE auditoria-geral.cod-unid-negoc
    FIELD cod-segmento          LIKE fam-com-item.descricao
    FIELD i-turno               AS INTEGER
    FIELD sigla                 AS CHAR
    INDEX ITEM it-codigo.

/* executando de forma persistente o utilit†rio de acompanhamento */
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Processando Dados").

if tt-param.destino = 3 or
   tt-param.destino = 1 then
    assign v_des_destino = string(session:temp-directory + "ESAQP015" + string (time) + ".csv").
else
    assign v_des_destino = string(tt-param.arquivo).

output to value(v_des_destino).
output close.

run pi-cria-planilha.

assign i-linha = 5.

EMPTY TEMP-TABLE tt-saida.

/** L¢gica para impress∆o das informaá‰es **/
for each auditoria-geral no-lock
   where auditoria-geral.dt-amostragem   >= tt-param.dat-adic-ini
     and auditoria-geral.dt-amostragem   <= tt-param.dat-adic-fim
     AND auditoria-geral.cod-turno       >= tt-param.i-turno-ini 
     AND auditoria-geral.cod-turno       <= tt-param.i-turno-fim 
     AND auditoria-geral.sigla           >= tt-param.sigla-ini 
     AND auditoria-geral.sigla           <= tt-param.sigla-fim
     /*AND auditoria-geral.ind-amostragem = 1*/ , /* Di†gia */   /* Foi colocado este filtro pois ao gerar uma Reinspeá∆o ou Acompanhamento duplicava os valores no relat¢rio, conforme Cleusa e Adriana da Qualidade */
     first item no-lock
     where item.it-codigo = auditoria-geral.it-codigo
     break by auditoria-geral.it-codigo:

    IF auditoria-geral.log-bloqueio <> tt-param.log-bloqueado THEN NEXT.

    IF tt-param.lotes-diarios-revisados = NO AND auditoria-geral.ind-amostragem = 1 THEN NEXT.
    IF tt-param.lotes-reinspecionados   = NO AND auditoria-geral.ind-amostragem = 2 THEN NEXT.
    
    if tt-param.tip-lote <> 0 and 
       auditoria-geral.nr-seq-tipo-lote <> tt-param.tip-lote then
        next.

    IF tt-param.cod-estabel <> "" AND
       tt-param.cod-estabel <> auditoria-geral.cod-estabel THEN
        NEXT.

    if tt-param.it-codigo <> "" and /** C¢digo produto n∆o informado **/
       tt-param.it-codigo <> auditoria-geral.it-codigo then
        next.

    if tt-param.nr-linha <> 0 and /** Linha de produá∆o n∆o informada **/
       tt-param.nr-linha <> auditoria-geral.nr-linha then
        next.

    if tt-param.cod-uneg <> "" and
       auditoria-geral.cod-unid-negoc <> tt-param.cod-uneg then
        next.

    IF  tt-param.auditor <> "" AND auditoria-geral.des-auditor <> tt-param.auditor THEN
        NEXT.

    run pi-acompanhar in h-acomp (input "Item: " + auditoria-geral.it-codigo).

    FOR FIRST tt-saida
        WHERE tt-saida.it-codigo = auditoria-geral.it-codigo:
    END.

    IF NOT AVAIL tt-saida THEN DO:

        CREATE tt-saida.
        ASSIGN tt-saida.it-codigo            = auditoria-geral.it-codigo
               tt-saida.desc-item            = ITEM.desc-item
               tt-saida.qtd-lotes-testados   = 0
               tt-saida.qtd-lotes-revisados  = 0
               tt-saida.qtd-prod-testados    = 0
               tt-saida.qtd-prod-lote        = 0
               tt-saida.qtd-prod-revisados   = 0
               tt-saida.qtd-lotes-bloqueados = 0
               tt-saida.qtd-prod-bloqueados  = 0
               tt-saida.qtd-double-sample    = 0.

    END.

    ASSIGN tt-saida.qtd-lotes-testados   = tt-saida.qtd-lotes-testados  + 1
           tt-saida.qtd-prod-testados    = tt-saida.qtd-prod-testados   + auditoria-geral.qt-apar-test
           tt-saida.qtd-prod-lote        = tt-saida.qtd-prod-lote       + auditoria-geral.qt-prod-lote
           tt-saida.cod-unid-negoc       = trim(auditoria-geral.cod-unid-negoc)
           tt-saida.i-turno              = auditoria-geral.cod-turno
           tt-saida.sigla                = auditoria-geral.sigla.

/*     IF auditoria-geral.log-revisado THEN */
    FIND FIRST auditoria-visual OF auditoria-geral NO-LOCK
         WHERE auditoria-visual.log-revisao = YES NO-ERROR.
    IF AVAIL auditoria-visual THEN
        ASSIGN tt-saida.qtd-lotes-revisados  = tt-saida.qtd-lotes-revisados + 1
               tt-saida.qtd-prod-revisados   = tt-saida.qtd-prod-revisados  + auditoria-geral.qtd-prod-revis.

    IF auditoria-geral.log-bloqueio THEN
        ASSIGN tt-saida.qtd-lotes-bloqueados = tt-saida.qtd-lotes-bloqueados + 1
               tt-saida.qtd-prod-bloqueados  = tt-saida.qtd-prod-bloqueados + auditoria-geral.qtd-prod-bloq.

    IF  auditoria-geral.log-double-sample THEN
        tt-saida.qtd-double-sample = tt-saida.qtd-double-sample + 1.
    
    FIND FIRST fam-comerc NO-LOCK
         WHERE fam-comerc.fm-cod-com = item.fm-cod-com NO-ERROR.

    IF  AVAIL fam-comerc THEN DO:
        FIND FIRST fam-com-item NO-LOCK
             WHERE fam-com-item.unidade  = SUBSTRING(fam-comerc.fm-cod-com,1,2)
               AND fam-com-item.segmento = SUBSTRING(fam-comerc.fm-cod-com,3,2)
               AND fam-com-item.familia1 = "" NO-ERROR.
        IF AVAIL fam-com-item THEN 
            ASSIGN tt-saida.cod-segmento = fam-com-item.descricao.
    END.
END.


RUN pi-inicializar IN h-acomp (INPUT "Imprimindo Dados").

FOR EACH tt-saida:

    run pi-acompanhar in h-acomp (input "Item: " + tt-saida.it-codigo).

    ASSIGN i-linha = i-linha + 1.

    chExcel:Range("A" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.it-codigo.
                                                        
    chExcel:Range("B" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.desc-item.            
                                                        
    chExcel:Range("C" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.qtd-lotes-testados.       
                                                        
    chExcel:Range("D" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.qtd-lotes-revisados.    

    chExcel:Range("E" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.qtd-lotes-bloqueados.

    chExcel:Range("F" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.qtd-prod-testados.          
                                                        
    chExcel:Range("G" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.qtd-prod-lote.          
                                                        
    chExcel:Range("H" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.qtd-prod-revisados.   
    
    chExcel:Range("I" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.qtd-prod-bloqueados.   

    chExcel:Range("J" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.qtd-double-sample.   

    chExcel:Range("K" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.cod-unid-negoc.   

    chExcel:Range("L" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.cod-segmento.   

    chExcel:Range("M" + string(i-linha)):select.        
    chExcel:selection:value = fn-turno(tt-saida.i-turno).   

    chExcel:Range("N" + string(i-linha)):select.        
    chExcel:selection:value = tt-saida.sigla.   

    assign v_tot_qtd_testados     = v_tot_qtd_testados     + tt-saida.qtd-lotes-testados   
           v_tot_lotes_revisados  = v_tot_lotes_revisados  + tt-saida.qtd-lotes-revisados
           v_tot_lotes_bloqueados = v_tot_lotes_bloqueados + tt-saida.qtd-lotes-bloqueados
           v_tot_prod_test        = v_tot_prod_test        + tt-saida.qtd-prod-testados     
           v_tot_prod_lote        = v_tot_prod_lote        + tt-saida.qtd-prod-lote      
           v_tot_prod_lote_revis  = v_tot_prod_lote_revis  + tt-saida.qtd-prod-revisados
           v_tot_prod_lote_bloq   = v_tot_prod_lote_bloq   + tt-saida.qtd-prod-bloqueados
           v_tot_double_sample    = v_tot_double_sample    + tt-saida.qtd-double-sample.

END.


assign i-linha = i-linha + 1.

chExcel:Range("A" + string(i-linha) + ":B" + string(i-linha)):select.     
chExcel:selection:MergeCells = true.
chExcel:selection:value = "Total:".
chExcel:selection:Font:Bold           = True.
chExcel:selection:Interior:ColorIndex = 20.
chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
chExcel:selection:HorizontalAlignment = {&xlRight}.
                                                    
chExcel:Range("C" + string(i-linha)):select.        
chExcel:selection:value = v_tot_qtd_testados.       
                                                    
chExcel:Range("D" + string(i-linha)):select.        
chExcel:selection:value = v_tot_lotes_revisados.    

chExcel:Range("E" + string(i-linha)):select.        
chExcel:selection:value = v_tot_lotes_bloqueados.

chExcel:Range("F" + string(i-linha)):select.        
chExcel:selection:value = v_tot_prod_test.          
                                                    
chExcel:Range("G" + string(i-linha)):select.        
chExcel:selection:value = v_tot_prod_lote.          
                                                    
chExcel:Range("H" + string(i-linha)):select.        
chExcel:selection:value = v_tot_prod_lote_revis.

chExcel:Range("I" + string(i-linha)):select.        
chExcel:selection:value = v_tot_prod_lote_bloq.

chExcel:Range("J" + string(i-linha)):select.        
chExcel:selection:value = v_tot_double_sample.


procedure pi-cria-planilha:

    create "Excel.Application":U chExcel connect no-error.
    if error-status:error then 
        create "Excel.Application":U chExcel.
    
    assign chArquivo  = chExcel:Workbooks:Open(v_des_destino).
           chPlanilha = chArquivo:Sheets:Item(1).

    chPlanilha:SaveAs(replace(v_des_destino, ".csv", ".xlsx"),"51",,,,,) no-error.
    os-delete silent value(v_des_destino).
                                                                                   
    chExcel:Range("A1"):select.
    chExcel:selection:value = "Linha Produá∆o".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
    if tt-param.nr-linha = 0 then
        assign v_des_lin_prod = "Todas".
    else do:
        find first lin-prod no-lock
             where lin-prod.cod-estabel = tt-param.cod-estabel
               AND lin-prod.nr-linha    = tt-param.nr-linha no-error.
        if avail lin-prod then
            assign v_des_lin_prod = lin-prod.descricao.
        else
            assign v_des_lin_prod = "".
    end.
    
    chExcel:Range("B1"):select.
    chExcel:selection:value = tt-param.nr-linha.
    
    chExcel:Range("C1"):select.
    chExcel:selection:value = v_des_lin_prod.
    
    chExcel:Range("A2"):select.
    chExcel:selection:value = "Per°odo".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    chExcel:Range("A3"):select.
    chExcel:selection:value = "Unidade de Neg¢cio".
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
    
    chExcel:Range("D3"):select.
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

    chExcel:Range("E3"):select.
    chExcel:selection:value = IF tt-param.auditor <> "" THEN tt-param.auditor ELSE "Todos".


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
    
    chExcel:Range("B3"):select.
    chExcel:selection:value = v_des_unid_neg.

    
    chExcel:Range("A5"):select.
    chExcel:selection:value = "Produto".
    
    chExcel:Range("B5"):select.
    chExcel:selection:value = "Descriá∆o".
    
    chExcel:Range("C5"):select.
    chExcel:selection:value = "Qtd Lotes Testados".
    
    chExcel:Range("D5"):select.
    chExcel:selection:value = "Qtd Lotes Recusados".

    chExcel:Range("E5"):select.
    chExcel:selection:value = "Qtd Lotes Bloqueados".

    chExcel:Range("F5"):select.
    chExcel:selection:value = "Qtd Produtos Testados".
    
    chExcel:Range("G5"):select.
    chExcel:selection:value = "Qtd Produtos no Lote".
    
    chExcel:Range("H5"):select.
    chExcel:selection:value = "Qtd Produtos Revisados".

    chExcel:Range("I5"):select.
    chExcel:selection:value = "Qtd Produtos Bloqueados".

    chExcel:Range("J5"):select.
    chExcel:selection:value = "Qtd Lotes Testados (DS)".

    chExcel:Range("K5"):select.
    chExcel:selection:value = "Unidade de Neg¢cios".

    chExcel:Range("L5"):select.
    chExcel:selection:value = "Segmento".
    
    chExcel:Range("M5"):select.
    chExcel:selection:value = "Turno".

    chExcel:Range("N5"):select.
    chExcel:selection:value = "CÇlula".

    chExcel:Range("A5:N5"):select.
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.


end procedure.

chExcel:Columns('A:J'):EntireColumn:Autofit NO-ERROR.

chPlanilha:Activate().

/*chArquivo:Save.*/

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

FUNCTION fn-turno RETURNS CHAR
    ( pTurno as int ) :

    CASE pTurno:
        WHEN 0 THEN RETURN "Geral".
        WHEN 1 THEN RETURN "1ß Turno".
        WHEN 2 THEN RETURN "2ß Turno".
        WHEN 3 THEN RETURN "3ß Turno".
    END CASE.

END FUNCTION.

return "OK":U.
