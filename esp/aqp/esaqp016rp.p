/* include de controle de vers∆o */
{include/i-prgvrs.i ESAQP016RP 1.00.00.000}

/* prÇprocessador para ativar ou n∆o a sa°da para RTF */
&global-define RTF no

/* definiá∆o das temp-tables para recebimento de parÉmetros */
{esp/aqp/esaqp016tt.i}

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
define variable v_des_procedimento      as char      format "x(40)"      no-undo.
define variable v_des_setor             as char      format "x(40)"      no-undo.
define variable v_des_unid_neg          as char      format "x(40)"      no-undo.
define variable v_des_componente        as char      format "x(40)"      no-undo.
define variable i-linha                 as int                           no-undo.
define variable i-setor-current         as int                           no-undo.
define variable v_tot_auditorias        as int                           no-undo.
define variable v_tot_nconformid        as int                           no-undo.
define variable v_tot_geral_audit       as int                           no-undo.
define variable v_tot_geral_nconf       as int                           no-undo.

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
    assign v_des_destino = string(session:temp-directory + "ESAQP016" + string (time) + ".csv").
else
    assign v_des_destino = string(tt-param.arquivo).

output to value(v_des_destino).
output close.

run pi-cria-planilha.

assign i-linha = 5.

/** L¢gica para impress∆o das informaá‰es **/
for each aud-procedimento no-lock
   where aud-procedimento.dt-auditoria   >= tt-param.dat-adic-ini
     and aud-procedimento.dt-auditoria   <= tt-param.dat-adic-fim
     and (if tt-param.des-auditor <> "" then aud-procedimento.des-auditor = tt-param.des-auditor else aud-procedimento.des-auditor <> "")
break by aud-procedimento.nr-seq-setor:

    if first-of(aud-procedimento.nr-seq-setor) then do:
        if (v_tot_auditorias > 0  or
            v_tot_nconformid > 0) and
            tt-param.tip-relat = 2 then do: /*** Verifica se est∆o com valor, para impress∆o dos totais da linha anterior **/
            
            assign i-linha = i-linha + 1.
            find first aq-setor no-lock
                 where aq-setor.nr-seq-setor = aud-procedimento.nr-seq-setor no-error.
            if avail aq-setor then
                assign v_des_setor = aq-setor.des-setor.
            else
                assign v_des_setor = "".
            
            chExcel:Range("A" + string(i-linha)):select.
            chExcel:selection:value = aud-procedimento.nr-seq-setor.
            
            chExcel:Range("B" + string(i-linha)):select.
            chExcel:selection:value = v_des_setor.
            
            chExcel:Range("C" + string(i-linha)):select.
            chExcel:selection:value = v_tot_auditorias.

            chExcel:Range("D" + string(i-linha)):select.
            chExcel:selection:value = v_tot_nconformid.
            
            assign v_tot_geral_audit = v_tot_geral_audit + v_tot_auditorias
                   v_tot_geral_nconf = v_tot_geral_nconf + v_tot_nconformid.
                   

        end.
        assign i-setor-current = aud-procedimento.nr-seq-setor.
    end.

    if tt-param.nr-procedimento <> 0 and /** C¢digo procedimento informado **/ 
       tt-param.nr-procedimento <> aud-procedimento.nr-seq-procedimento then
        next.

    if tt-param.nr-setor <> 0 and /** C¢digo setor informado **/
       tt-param.nr-setor <> aud-procedimento.nr-seq-setor then
        next.
    
    if tt-param.cod-uneg <> "" and /** C¢digo unidade de Neg¢cio informada **/
       aud-procedimento.cod-unid-negoc <> tt-param.cod-uneg then
        next.
    
    if first-of(aud-procedimento.nr-seq-setor) or 
       aud-procedimento.nr-seq-setor = i-setor-current then
        assign i-setor-current       = 0
               v_tot_auditorias      = 0.
    
    assign i-acomp          = i-acomp + 1
           v_tot_auditorias = v_tot_auditorias + 1.
        
    run pi-acompanhar in h-acomp (input string(i-acomp)).

    if tt-param.tip-relat = 1 then do:

        assign i-linha = i-linha + 1.

        find first aq-procedimento no-lock
             where aq-procedimento.nr-seq-procedimento = aud-procedimento.nr-seq-procedimento no-error.
        if avail aq-procedimento then
            assign v_des_procedimento = aq-procedimento.des-procedimento.
        else
            assign v_des_procedimento = "".

        find first aq-setor no-lock
             where aq-setor.nr-seq-setor = aud-procedimento.nr-seq-setor no-error.
        if avail aq-setor then
            assign v_des_setor = aq-setor.des-setor.
        else
            assign v_des_setor = "".


        chExcel:Range("A" + string(i-linha)):select.        
        chExcel:selection:value = v_des_procedimento.

        chExcel:Range("B" + string(i-linha)):select.        
        chExcel:selection:value = aud-procedimento.des-auditor.

        chExcel:Range("C" + string(i-linha)):select.        
        chExcel:selection:value = aud-procedimento.dt-auditoria.

        chExcel:Range("D" + string(i-linha)):select.        
        chExcel:selection:value = aud-procedimento.cod-unid-negoc.

        if aud-procedimento.log-aud-proced then do:
            chExcel:Range("E" + string(i-linha)):select.        
            chExcel:selection:value = "OK".
        end.
        else do:
            chExcel:Range("E" + string(i-linha)):select.        
            chExcel:selection:value = "NOK".
        end.

        chExcel:Range("F" + string(i-linha)):select.        
        chExcel:selection:value = v_des_setor.

    end.


    for each nc-aud-procedimento no-lock
       where nc-aud-procedimento.nr-seq-aud-proced = aud-procedimento.nr-seq-aud-proced
    break by nc-aud-procedimento.nr-seq-aud-proced:
        if tt-param.tip-relat = 1 then do:

            find first aq-nao-confor no-lock
                 where aq-nao-confor.nr-seq-nconfor = nc-aud-procedimento.nr-seq-nconfor no-error.

            chExcel:Range("G" + string(i-linha)):select.        
            chExcel:selection:value = nc-aud-procedimento.nr-cartao.
            
            chExcel:Range("H" + string(i-linha)):select.        
            chExcel:selection:value = aq-nao-confor.des-nao-confor.
            
            chExcel:Range("I" + string(i-linha)):select.        
            chExcel:selection:value = nc-aud-procedimento.descricao.

            assign i-linha = i-linha + 1.

            if last-of(nc-aud-procedimento.nr-seq-aud-proced) then
                assign i-linha = i-linha - 1.
        end.
        assign v_tot_nconformid = v_tot_nconformid + 1.
    end.

    if last-of(aud-procedimento.nr-seq-setor) and
       tt-param.tip-relat = 2 then do:

        assign i-linha = i-linha + 1.

        find first aq-setor no-lock
             where aq-setor.nr-seq-setor = aud-procedimento.nr-seq-setor no-error.
        if avail aq-setor then
            assign v_des_setor = aq-setor.des-setor.
        else
            assign v_des_setor = "".
        
        chExcel:Range("A" + string(i-linha)):select.
        chExcel:selection:value = aud-procedimento.nr-seq-setor.
        
        chExcel:Range("B" + string(i-linha)):select.
        chExcel:selection:value = v_des_setor.
        
        chExcel:Range("C" + string(i-linha)):select.
        chExcel:selection:value = v_tot_auditorias.

        chExcel:Range("D" + string(i-linha)):select.
        chExcel:selection:value = v_tot_nconformid. 
        
        assign v_tot_geral_audit = v_tot_geral_audit + v_tot_auditorias
               v_tot_geral_nconf = v_tot_geral_nconf + v_tot_nconformid
               v_tot_auditorias  = 0  
               v_tot_nconformid  = 0.
    end.
end.

/*** Impriss∆o dos totais ***/
if tt-param.tip-relat = 2 then do:
    assign i-linha = i-linha + 1.
    
    chExcel:Range("A" + string(i-linha) + ":B" + string(i-linha)):select.     
    chExcel:selection:MergeCells = true.
    chExcel:selection:value = "Total:".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    chExcel:selection:HorizontalAlignment = {&xlRight}.
                                                        
    chExcel:Range("C" + string(i-linha)):select.        
    chExcel:selection:value = v_tot_geral_audit.       
                                                        
    chExcel:Range("D" + string(i-linha)):select.        
    chExcel:selection:value = v_tot_geral_nconf.
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
    chExcel:selection:value = "Procedimento".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
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
    chExcel:selection:value = "Setor".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    if tt-param.nr-setor = 0 then do:
        assign v_des_setor = "Todos".
        chExcel:Range("B3"):select.
        chExcel:selection:value = v_des_setor.
    end.
    else do:
        find first aq-setor no-lock
             where aq-setor.nr-seq-setor = tt-param.nr-setor no-error.
        if avail aq-setor then
            assign v_des_setor = aq-setor.des-setor.
        else
            assign v_des_setor = "".

        chExcel:Range("B3"):select.
        chExcel:selection:value = tt-param.nr-setor.
        
        chExcel:Range("C3"):select.
        chExcel:selection:value = v_des_setor.
    end.

    chExcel:Range("D1"):select.
    chExcel:selection:value = "Unidade de Neg¢cio".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    if tt-param.cod-uneg = "" then do:
        assign v_des_unid_neg = "Todas".
        chExcel:Range("E1"):select.
        chExcel:selection:value = v_des_unid_neg.
    end.
    else do:
        find first unid-negoc no-lock
             where unid-negoc.cod-unid-negoc = tt-param.cod-uneg no-error.
        if avail unid-negoc then
            assign v_des_unid_neg = unid-negoc.des-unid-negoc.
        else 
            assign v_des_unid_neg = "".

        chExcel:Range("E1"):select.
        chExcel:selection:value = tt-param.cod-uneg.

        chExcel:Range("F1"):select.
        chExcel:selection:value = v_des_unid_neg.
    end.
    
    chExcel:Range("D2"):select.
    chExcel:selection:value = "Auditor".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
    if tt-param.des-auditor = "" then do:
        chExcel:Range("E2"):select.
        chExcel:selection:value = "Todos".
    end.
    else do:
        chExcel:Range("E2"):select.
        chExcel:selection:value = tt-param.des-auditor.
    end.
    

    if tt-param.tip-relat = 1 then do: /*** Detalhado ***/
        chExcel:Range("A5"):select.
        chExcel:selection:value = "Procedimento".
        
        chExcel:Range("B5"):select.
        chExcel:selection:value = "Auditor".
        
        chExcel:Range("C5"):select.
        chExcel:selection:value = "Data".
        
        chExcel:Range("D5"):select.
        chExcel:selection:value = "Unidade Neg¢cio".
        
        chExcel:Range("E5"):select.
        chExcel:selection:value = "Estado".
        
        chExcel:Range("F5"):select.
        chExcel:selection:value = "Setor".

        chExcel:Range("G5"):select.
        chExcel:selection:value = "N£mero Cart∆o".

        chExcel:Range("H5"):select.
        chExcel:selection:value = "N∆o Conformidade".

        chExcel:Range("I5"):select.
        chExcel:selection:value = "Observaá∆o".

        chExcel:Range("A5:I5"):select.
        chExcel:selection:Font:Bold           = True.
        chExcel:selection:Interior:ColorIndex = 20.
        chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    end.
    else do: /*** Resumido ***/

        chExcel:Range("A5"):select.
        chExcel:selection:value = "Setor".

        chExcel:Range("B5"):select.
        chExcel:selection:value = "Descriá∆o".

        chExcel:Range("C5"):select.
        chExcel:selection:value = "Qtd Auditoria".

        chExcel:Range("D5"):select.
        chExcel:selection:value = "Qtd N∆o Conformes".

        chExcel:Range("A5:D5"):select.
        chExcel:selection:Font:Bold           = True.
        chExcel:selection:Interior:ColorIndex = 20.
        chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

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
