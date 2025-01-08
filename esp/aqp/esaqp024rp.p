/* include de controle de versÆo */
{include/i-prgvrs.i ESAQP024RP 1.00.00.000}

/* pr‚processador para ativar ou nÆo a sa¡da para RTF */
&global-define RTF no

/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{esp/aqp/esaqp024tt.i}

/* recebimento de parƒmetros */
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
define variable v_des_estabel           as char      format "x(40)"      no-undo.
define variable i-linha                 as int                           no-undo.
define variable v_tot_com_inspec        as int                           no-undo.
define variable v_tot_sem_inspec        as int                           no-undo.

/* executando de forma persistente o utilit rio de acompanhamento */
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}
run pi-inicializar in h-acomp (input return-value).

if tt-param.destino = 3 or
   tt-param.destino = 1 then
    assign v_des_destino = string(session:temp-directory + "ESAQP014" + string (time) + ".xlsx").
else
    assign v_des_destino = string(tt-param.arquivo).

run pi-cria-planilha.

assign i-linha          = 4
       v_tot_sem_inspec = 0
       v_tot_com_inspec = 0.  

for each ficha-cq no-lock
   where ficha-cq.nr-ficha     >= tt-param.nr-ficha-ini
     and ficha-cq.nr-ficha     <= tt-param.nr-ficha-fim
     and ficha-cq.cod-estabel  >= tt-param.cod-estabel-ini
     and ficha-cq.cod-estabel  <= tt-param.cod-estabel-fim
     and ficha-cq.it-codigo    >= tt-param.it-codigo-ini
     and ficha-cq.it-codigo    <= tt-param.it-codigo-fim
     and ficha-cq.cod-emitente >= tt-param.cod-emitente-ini
     and ficha-cq.cod-emitente <= tt-param.cod-emitente-fim
     and ficha-cq.dt-ficha     >= tt-param.dt-ficha-ini
     and ficha-cq.dt-ficha     <= tt-param.dt-ficha-fim
break by ficha-cq.cod-emitente
      by ficha-cq.nr-ficha:
    assign i-linha = i-linha + 1
           i-acomp = i-acomp + 1.
        
    run pi-acompanhar in h-acomp (input string(i-acomp)).

    chExcel:Range("A" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.cod-estabel.

    chExcel:Range("B" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.dt-ficha.

    chExcel:Range("C" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.nr-ficha.

    chExcel:Range("D" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.serie-docto.

    chExcel:Range("E" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.nro-docto.

    chExcel:Range("F" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.nat-operacao.

    chExcel:Range("G" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.cod-emitente.

    chExcel:Range("H" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.qt-original.

    chExcel:Range("I" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.qt-aprovada.

    chExcel:Range("J" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.qt-rejeitada.

    chExcel:Range("K" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.qt-consumida.

    chExcel:Range("L" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.dt-inspecao.

    chExcel:Range("M" + string(i-linha)):select.
    chExcel:selection:value = ficha-cq.cod-resp.

    chExcel:Range("N" + string(i-linha)):select.
    chExcel:selection:value = trim(ficha-cq.narrativa).

    if ficha-cq.narrativa = "" then
        assign v_tot_sem_inspec = v_tot_sem_inspec + 1.
    else
        assign v_tot_com_inspec = v_tot_com_inspec + 1.

end.  

chExcel:Range("B1"):select.
chExcel:selection:value = v_tot_com_inspec.

chExcel:Range("B2"):select.
chExcel:selection:value = v_tot_sem_inspec.

procedure pi-cria-planilha:

    create "Excel.Application":U chExcel connect no-error.
    if error-status:error then 
        create "Excel.Application":U chExcel.
    
    assign chArquivo  = chExcel:Workbooks:Add().
           chPlanilha = chArquivo:Sheets:Item(1).
    
    chPlanilha:SaveAs(v_des_destino, {&xlNormal}, "", "", False, False, False).
    
    chExcel:Range("A1"):select.
    chExcel:selection:value = "Total com Inspe‡Æo".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.
    
    chExcel:Range("A2"):select.
    chExcel:selection:value = "Total sem Inspe‡Æo".
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

    
    chExcel:Range("A4"):select.
    chExcel:selection:value = "Estabelecimento".

    chExcel:Range("B4"):select.
    chExcel:selection:value = "Data".

    chExcel:Range("C4"):select.
    chExcel:selection:value = "Roteiro".

    chExcel:Range("D4"):select.
    chExcel:selection:value = "S‚rie".

    chExcel:Range("E4"):select.
    chExcel:selection:value = "Documento".

    chExcel:Range("F4"):select.
    chExcel:selection:value = "Nat Opera‡Æo".

    chExcel:Range("G4"):select.
    chExcel:selection:value = "Emitente".

    chExcel:Range("H4"):select.
    chExcel:selection:value = "Qtd Original".

    chExcel:Range("I4"):select.
    chExcel:selection:value = "Qtd Aprovada".

    chExcel:Range("J4"):select.
    chExcel:selection:value = "Qtd Rejeitada".

    chExcel:Range("K4"):select.
    chExcel:selection:value = "Qtd Consumida".

    chExcel:Range("L4"):select.
    chExcel:selection:value = "Data Inspe‡Æo".

    chExcel:Range("M4"):select.
    chExcel:selection:value = "Respons vel".

    chExcel:Range("N4"):select.
    chExcel:selection:value = "Narrativa".

    chExcel:Range("A4:N4"):select.
    chExcel:selection:Font:Bold           = True.
    chExcel:selection:Interior:ColorIndex = 20.
    chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

end procedure.

chExcel:Columns('A:N'):EntireColumn:Autofit NO-ERROR.

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
