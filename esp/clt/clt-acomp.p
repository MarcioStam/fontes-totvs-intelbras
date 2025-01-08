{include/i-prgvrs.i clt-acomp 2.00.00.000e}
/*****************************************************************************
**     Programa: clt-acomp.P
**     Data....: Abril/2013
**     Objetivo: Acompanhamento de Execu‡Æo (Programa Persistente)
*****************************************************************************/
{include/i_fcldef.i}
{include/i-win.i}
{include/i-epc200.i clt-acomp}
{utp/ut-gerdoc.i}

def stream s-acomp.

define variable h-video         as handle    no-undo.
define variable c-video         as character no-undo.
define variable c-temp          as character no-undo.
define variable c-status-acomp  as character no-undo init "OK".
define variable l-video         as logical   no-undo init no.
define variable l-initial       as logical   no-undo init no.
define variable i-segs-ini      as integer   no-undo.
define variable i-segs-fim      as integer   no-undo.
define variable d-data-ini-exec as date      no-undo.
define variable c-label         as character format "x(20)"             view-as text    size 15 by 0.75.
define variable c-conteudo      as character format "x(35)" init "MMMM" view-as fill-in size 35 by 0.88.
define variable c-conteudo-ant  as character format "x(45)".
define variable i-cont          as integer   no-undo.
define variable c-prog          as character no-undo.

define new global shared variable iTempoIni               as integer   no-undo.
define new global shared variable iBase                   as integer   no-undo. 
define new global shared variable i-num-ped-exec-rpw      as integer   no-undo.
define new global shared variable c-mp-controle-aux       as character no-undo.
define new global shared variable c-dir-spool-servid-exec as character no-undo.
define new global shared variable v_cod_arq_gerdoc        as character no-undo.
define new global shared variable v_cod_prog_gerdoc       as character no-undo.

Def Buffer b_ped_exec For ped_exec.

def rectangle rt-001 size 37 by 1.8 edge-pixels 2.

def button bt-cancelar label "&Cancelar" size 15 by 1.

def frame f-video
    with no-labels three-d no-box bgcolor 8 size 28 by 2.4 at row 3.6 col 6.4.

def frame f-acomp                                          
    rt-001      at row 1.5 col 2
    c-label     at row 1.2 col 3
    c-conteudo  at row 2   col 3
    bt-cancelar at row 3.5 col 12.5 
    with no-labels three-d 
    view-as dialog-box SIZE-CHAR 40 by 5 bgcolor 8.
{include/i_fclfrm.i f-video f-acomp}

on  choose of bt-cancelar in frame f-acomp do:
    assign c-status-acomp = "NOK".
    if  i-num-ped-exec-rpw           = 0
    and index(proversion,"webspeed") = 0
    and session:remote               = no 
    and session:batch-mode           = no then do:
        hide stream s-acomp frame f-acomp no-pause.
        
        if  l-video = yes then do:
            if  valid-handle(h-video) then do:
                run CloseVideo in h-video (input frame f-video:hWnd).
                delete procedure h-video.
            end. /* if  valid-handle(h-video) */
        end. /* if  l-video = yes then */
        stop.     
    end. /* if  i-num-ped-exec-rpw = 0 */
end. /* on  choose of bt-cancelar */

if  i-num-ped-exec-rpw           = 0 
and index(proversion,"webspeed") = 0
and session:remote               = no 
and session:batch-mode           = no then do:
    {utp/ut-liter.i Processando * C}
    assign c-label:screen-value in frame f-acomp = return-value.
    {utp/ut-liter.i Cancelar * C}
    assign bt-cancelar:label in frame f-acomp = "&" + trim(return-value).
end.

procedure pi-inicializar:
    def input param c-titulo     as character no-undo.

    if  i-num-ped-exec-rpw = 0 then do:
        if  index(proversion,"webspeed") = 0
        and session:remote               = no 
        and session:batch-mode           = no then do:
            output stream s-acomp to terminal.

            run utp/ut-liter.p (input replace(c-titulo, " ", "_"), input "*", input "R").
            assign frame f-acomp:title = return-value.

            run utp/ut-liter.p (input "Inicializa‡Æo...", input "*", input "R").
            assign c-conteudo = return-value
                   iTempoIni  = TIME.

            pause 0 before-hide.
            view stream s-acomp frame f-acomp.
            disp stream s-acomp c-conteudo with frame f-acomp.
            assign bt-cancelar:sensitive in frame f-acomp = yes.
            apply "entry" to bt-cancelar in frame f-acomp.
            
            if  l-video = yes then do:
                run utp/ut-utils.p persistent set h-video.
                assign frame f-video:frame = frame f-acomp:handle
                       frame f-acomp:width = 40
                       frame f-acomp:height = 7.8 
                       rt-001:width in frame f-acomp = 37
                       rt-001:height in frame f-acomp = 4.6
                       bt-cancelar:row in frame f-acomp = 6.3
                       bt-cancelar:col in frame f-acomp = 17.5.
                view stream s-acomp frame f-video.
                run OpenVideo in h-video (input c-video, input frame f-video:hWnd ).
            end. /* if  l-video = yes then */
        end. /* if  index(proversion,"webspeed") */
    end. /* if  i-num-ped-exec-rpw = 0 then */
    else do transaction:
        find ped_exec exclusive-lock 
            where ped_exec.num_ped_exec = i-num-ped-exec-rpw no-error.
        if  avail ped_exec then do:
            assign ped_exec.dat_ult_atualiz_servid_exec = today
                   ped_exec.hra_ult_atualiz_servid_exec = replace(string(time,"hh:mm:ss"),":","")
                   ped_exec.cod_ult_obj_procesdo        = substring(c-conteudo,1,32).
            if  c-mp-controle-aux <> ""  then do:
                /*if  ped_exec.des_inf_aplic <> ""  then
                    if  num-entries(ped_exec.des_inf_aplic,"/") < 2  then 
                        assign ped_exec.des_inf_aplic = substring(ped_exec.des_inf_aplic + " / " + c-mp-controle-aux,1,100).
                    else do:
                        assign i-cont = LENGTH(entry(1,ped_exec.des_inf_aplic,"/")).
                        if i-cont < 100 then
                            assign entry(2,ped_exec.des_inf_aplic,"/") = substring(" " + c-mp-controle-aux,1,100 - i-cont).
                    end.
                else 
                    assign ped_exec.des_inf_aplic = substring(c-mp-controle-aux,1,100).*/
            end. /* if  c-mp-controle-aux <> "" */
        end. /* if  avail ped_exec then */
    end. /* else do transaction: */
end. /* procedure pi-inicializar: */

procedure pi-acompanhar:
    def input param c-par-conteudo as character no-undo.

    assign c-conteudo = c-par-conteudo.

    if  i-num-ped-exec-rpw = 0 then do:
        if  index(proversion,"webspeed") = 0
        and session:remote               = no 
        and session:batch-mode           = no then do:
            if  c-conteudo-ant <> c-conteudo then do:
                IF  (TIME >= (iTempoIni + iBase) OR iBase = ?) THEN DO:
                     DISP STREAM s-acomp c-conteudo WITH FRAME f-acomp.
                     ASSIGN iTempoIni = TIME.
                end. /* IF  (TIME >= */
                assign c-conteudo-ant = c-conteudo.
            end. /* if  c-conteudo-ant <> c-conteudo */
	    end. /* if  index(proversion */
    end. /* if  i-num-ped-exec-rpw = 0 then */
    else do:
        if  l-initial = no then do:
            assign l-initial  = yes
                   i-segs-fim = time - 60
                   d-data-ini-exec = today.
        end. /* if  l-initial = no then */
        assign i-segs-ini = time.

        if  today <> d-data-ini-exec then do:
            assign i-segs-fim = time
                   d-data-ini-exec = today.
        end. /* if  today <> d-data-ini-exec */

        if  (i-segs-ini - i-segs-fim) >= 60 then do:
            do  transaction:
                find ped_exec exclusive-lock 
                    where ped_exec.num_ped_exec = i-num-ped-exec-rpw no-error.
                if  avail ped_exec then do:
                    assign ped_exec.dat_ult_atualiz_servid_exec = today
                           ped_exec.hra_ult_atualiz_servid_exec = replace(string(time,"hh:mm:ss"),":","")
                           ped_exec.cod_ult_obj_procesdo        = substring(c-conteudo,1,32)
                           i-segs-fim                           = time.
                    if  c-mp-controle-aux <> "" then do: 
                        /*if  ped_exec.des_inf_aplic <> ""  then
                            if  num-entries(ped_exec.des_inf_aplic,"/") < 2  then 
                                assign ped_exec.des_inf_aplic = substring(ped_exec.des_inf_aplic + " / " + c-mp-controle-aux,1,100).
                            ELSE DO:
                                ASSIGN i-cont = LENGTH(entry(1,ped_exec.des_inf_aplic,"/")).
                                IF i-cont < 100 THEN assign entry(2,ped_exec.des_inf_aplic,"/") = substring(" " + c-mp-controle-aux,1,100 - i-cont). 
                            end. /* ELSE DO: */
                        else 
                            assign ped_exec.des_inf_aplic = substring(c-mp-controle-aux,1,100).*/
                    end. /* if  c-mp-controle-aux <> "" then */
                end. /* if  avail ped_exec then */
            end. /* do  transaction: */
        end. /* if  (i-segs-ini - i-segs-fim) >= 60 then */
    end. /* else do: */
    if  session:batch-mode           = no 
    and index(proversion,"webspeed") = 0
    and session:remote               = no then process events.
end. /* procedure pi-acompanhar: */

procedure pi-finalizar:

    if  i-num-ped-exec-rpw           = 0
    and index(proversion,"webspeed") = 0
      and session:remote               = no 
      and session:batch-mode           = no then do: 
        hide stream s-acomp frame f-acomp no-pause.
        output stream s-acomp close.
        if  l-video = yes then do:
            if  valid-handle(h-video) then do:
                run CloseVideo in h-video (input frame f-video:hWnd).
                delete procedure h-video.
            end.
        end.
    end.

    IF index(PROVERSION,"WebSpeed":U) <> 0 then do:
        if  VALID-HANDLE(hpApi)
        AND hpApi:type = "procedure":U
        AND hpApi:FILE-NAME = "utp/ut-win.p" THEN
            delete procedure hpApi.
        if VALID-HANDLE(hpWinFunc)
        AND hpWinFunc:type = "procedure":U
        AND hpWinFunc:FILE-NAME = "utp/ut-func.p" THEN
            delete procedure hpWinFunc.
    end.

    delete procedure this-procedure.

    if v_log_integr_gerdoc = yes
    and v_cod_arq_gerdoc <> ?
    and v_cod_arq_gerdoc <> "" then Do:

        ASSIGN c-prog = "".

        ver_prog:
        REPEAT i-cont = 1 TO 20:
            ASSIGN c-prog = REPLACE(SUBSTRING(PROGRAM-NAME(i-cont),INDEX(PROGRAM-NAME(i-cont)," ") + 1),CHR(92),"/").
            blk_1:
            REPEAT:
                IF INDEX(c-prog,"/") > 0 THEN
                    ASSIGN c-prog = SUBSTRING(c-prog,INDEX(c-prog,"/") + 1).
                ELSE DO:
                    IF NUM-ENTRIES(c-prog,".") > 1
                    THEN
                        ASSIGN c-prog = ENTRY(1,c-prog,".").
                    LEAVE blk_1.
                end.
            end.
            IF c-prog = v_cod_prog_gerdoc THEN
                LEAVE ver_prog.
        end.
        
        IF OPSYS = "win32" 
        AND i-num-ped-exec-rpw = 0
        AND index(proversion,"webspeed") = 0
        and session:remote               = NO
        AND c-prog = v_cod_prog_gerdoc 
        AND v_cod_prog_gerdoc <> ? THEN DO: 
            for each tt-epc where tt-epc.cod-event = "Integr. GerDoc".
                delete tt-epc.
            end.
            {include/i-epc200.i2 &CodEvent='"Integr. GerDoc"'
                               &CodParameter='"v_cod_arq_gerdoc"'
                               &ValueParameter="v_cod_arq_gerdoc"}

            {include/i-epc200.i2 &CodEvent='"Integr. GerDoc"'
                              &CodParameter='"v_cod_prog_gerdoc"'
                              &ValueParameter="v_cod_prog_gerdoc"}

            {include/i-epc201.i "Integr. GerDoc"}
            ASSIGN v_cod_arq_gerdoc  = ?
                   v_cod_prog_gerdoc = ?.
        end.
        
        If  i-num-ped-exec-rpw <> 0 Then Do:
            Find b_ped_exec 
                Where b_ped_exec.num_ped_exec = i-num-ped-exec-rpw No-lock No-error.
            If  Avail b_ped_exec Then Do:
                Find ped_exec_param
                Where ped_exec_param.num_ped_exec = b_ped_exec.num_ped_exec No-lock No-error.
                If  Avail ped_exec_param
                And ped_exec_param.cod_dwb_output = 'Arquivo':U Then Do:
                    Assign v_cod_arq_gerdoc  = c-dir-spool-servid-exec + "~/" + ped_exec_param.nom_dwb_printer
                           v_cod_prog_gerdoc = b_ped_exec.cod_prog_dtsul.
                   for each tt-epc where tt-epc.cod-event = "Integr. GerDoc":U.
                       delete tt-epc.
                   end.
                   {include/i-epc200.i2 &CodEvent='"Integr. GerDoc"'
                                      &CodParameter='"v_cod_arq_gerdoc"'
                                      &ValueParameter="v_cod_arq_gerdoc"}

                   {include/i-epc200.i2 &CodEvent='"Integr. GerDoc"'
                                     &CodParameter='"v_cod_prog_gerdoc"'
                                     &ValueParameter="v_cod_prog_gerdoc"}

                   {include/i-epc201.i "Integr. GerDoc"}
                   ASSIGN v_cod_arq_gerdoc  = ?
                          v_cod_prog_gerdoc = ?.
                end.
            end.
        end.
    end.

    If  i-num-ped-exec-rpw <> 0 Then Do:
        do  transaction:                
            find ped_exec exclusive-lock 
                where ped_exec.num_ped_exec = i-num-ped-exec-rpw no-error.
                if  avail ped_exec then do:
                    assign ped_exec.dat_ult_atualiz_servid_exec = today
                           ped_exec.hra_ult_atualiz_servid_exec = replace(string(time,"hh:mm:ss"),":","")
                           ped_exec.cod_ult_obj_procesdo        = substring(c-conteudo,1,32)
                           i-segs-fim                           = time.
                    if  c-mp-controle-aux <> "" then do: 
                        /*if  ped_exec.des_inf_aplic <> ""  then
                            if  num-entries(ped_exec.des_inf_aplic,"/") < 2  then 
                                assign ped_exec.des_inf_aplic = substring(ped_exec.des_inf_aplic + " / " + c-mp-controle-aux,1,100).
                            ELSE DO:
                                ASSIGN i-cont = LENGTH(entry(1,ped_exec.des_inf_aplic,"/")).
                                IF i-cont < 100 THEN
                                    assign entry(2,ped_exec.des_inf_aplic,"/") = substring(" " + c-mp-controle-aux,1,100 - i-cont).
                            end.
                        else assign ped_exec.des_inf_aplic = substring(c-mp-controle-aux,1,100).*/
                    end.                                                       
                end.
        end.
    end.
end.

procedure pi-seta-tipo:
    def input param p-tipo as int no-undo.

    if  i-num-ped-exec-rpw           = 0 
    and index(proversion,"webspeed") = 0
    and session:remote               = no
    and session:batch-mode           = no then do:
        if  p-tipo < 1 or p-tipo > 6 then 
            run utp/ut-msgs.p (input "show", input 8363, input "").
        assign c-temp  = search("image/export1.avi")
               c-temp  = substring(c-temp, 1, r-index(replace(c-temp, "~\", "~/"), "~/") - 1)
               c-video = replace(c-temp + "~/export" + string(p-tipo) + "~.avi", "~\", "~/").
        if  search(c-video) <> ? THEN assign l-video = yes.
    end.  
end.

procedure pi-habilita-cancela:
    if  i-num-ped-exec-rpw           = 0
    and index(proversion,"webspeed") = 0
    and session:remote               = no 
    and session:batch-mode           = no then do:
        enable bt-cancelar with frame f-acomp.
    end.  
end.

procedure pi-desabilita-cancela:
    if  i-num-ped-exec-rpw           = 0
    and index(proversion,"webspeed") = 0
    and session:remote               = no 
    and session:batch-mode           = no then do: 
        disable bt-cancelar with frame f-acomp.
    end.  
end.

procedure pi-retorna-status:
    def output parameter c-status as character no-undo.

    assign c-status = c-status-acomp.
end.    

procedure pi-seta-titulo:
    def input parameter c-titulo as character no-undo.

    if  i-num-ped-exec-rpw           = 0
    and index(proversion,"webspeed") = 0 
    and session:remote               = no 
    and session:batch-mode           = no then do:
        run utp/ut-liter.p (input replace(c-titulo, " ", "_"), input "*", input "R").
        assign frame f-acomp:title = return-value.
    end.  
end.

/* fim */
