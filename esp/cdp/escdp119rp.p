/********************************************************************************
*      Programa .....: escdp119rp.p                                             *
*      Data .........: 16 de agosto de 2022                                     *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur°cio C.                                              *
*      Objetivo .....: Consistància de Extens‰es de Bens Patrimoniais           *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL   MOTIVO                            *
*      1.00.00.000  16/08/2022  Mauricio C.   Desenvolvimento                   *
********************************************************************************/
{include/i-prgvrs.i escdp119rp 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escdp119rp ESP}
&ENDIF

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    field dat_aquis_ini    as date
    field dat_aquis_fim    as date
    field cod_cta_ini      as char
    field cod_cta_fim      as char
    field num_bem_ini      as inte
    field num_bem_fim      as inte
    field num_seq_bem_ini  as inte
    field num_seq_bem_fim  as inte
    field cod_estab_ini    as char
    field cod_estab_fim    as char
    field cod_ccusto_ini   as char
    field cod_ccusto_fim   as char
    field cod_plano_ccusto as char
    field sem-cad          as logi
    field cad-incompl      as logi
    field cad-compl        as logi
    field so-inconsist     as logi
    field exporta          as logi
    field diretorio        as char.

define temp-table tt-raw-digita
    field raw-digita    as raw.

define temp-table tt_int_bem_pat_gm no-undo like int_bem_pat_gm
    index id is primary num_id_bem_pat
                        gm-codigo.

/*  Recebimento de parametros --- */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

find current tt-param no-error.    

/***** VARIµVEIS *****/
{include/i-rpvar.i}
{utp/ut-glob.i}

def var h-acomp       as handle no-undo.
def var i-cont        as inte   no-undo.
def var lg-compl      as logi   no-undo.
def var lg-ccusto-ok  as logi   no-undo.
def var lg-inconsis   as logi   no-undo.
def var c-inconsis    as char   no-undo.
def var c-cc-consider as char   no-undo.
def var c-gm-aux      as char   no-undo.
def var c-lista       as char   no-undo.

def stream st-export.

/***** FRAMES *****/
form bem_pat.cod_cta_pat        format "x(18)"      column-label "Conta Patrimonial"
     bem_pat.cod_estab          format "x(5)"       column-label "Estab"
     bem_pat.dat_aquis_bem_pat  format "99/99/99"   column-label "Dt Aquis"
     bem_pat.num_bem_pat        format ">>>>>>>>9"  column-label "Bem"
     bem_pat.num_seq_bem_pat    format ">>>>9"      column-label "Seq Bem"
     bem_pat.des_bem_pat        format "x(35)"      column-label "Descriá∆o Bem Pat"
     int_bem_pat.molde          format "Sim/N∆o"    column-label "Molde"
     int_bem_pat.equipamento    format "x(16)"      column-label "Equipamento"
     int_bem_pat.hr_manut       format ">>>>9.99"   column-label "Hrs Manut"
     int_bem_pat.potencia       format ">>>>>9.99"  column-label "Potància kW"
     lg-compl                   format "Sim/N∆o"    column-label "Completo"
     c-inconsis                 format "x(9)"       column-label "Inconsist"
     c-cc-consider              format "x(9)"       column-label "CCusto Refer"
     bem_pat.cod_ccusto_respons format "x(11)"      column-label "CCusto Responsab"
     aloc_bem.cod_ccusto        format "x(11)"      column-label "Ccusto Alocaá‰es"
     c-gm-aux                   format "x(50)"      column-label "Grupos M†quina"
     with width 250 down no-box stream-io frame f-dados.

find first param-global no-lock no-error.

assign c-programa     = "ESCDP119":U
       c-versao       = "1.00.00":U
       c-revisao      = "000":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "Consistància de Extens‰es de Bens Patrimoniais"
       c-sistema      = "ESP".

assign c-rodape = "iDBA - " 
                + c-sistema 
                + " - " 
                + c-programa
                + " - V:" 
                + c-versao
                + "."
                + c-revisao
       c-rodape = fill("-", 250 - length(c-rodape)) + c-rodape.

form header
     fill("-", 250) format "x(250)" skip
     c-empresa c-titulo-relat at 50
     "Folha:" at 240 page-number  at 246 format ">>>>9" skip
     fill("-", 230) format "x(228)" today format "99/99/9999"
     "-" string(time, "HH:MM:SS")
     with stream-io width 250 no-labels no-box page-top frame f-cabec.

form header
     c-rodape format "x(250)"
     with stream-io width 250 no-labels no-box page-bottom frame f-rodape.

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Processando...").

for first int_param_uep
    where int_param_uep.cod_empresa = v_cod_empres_usuar
          no-lock: end.

if tt-param.exporta
then do:
     output stream st-export to value(tt-param.diretorio) no-convert.
     put stream st-export unformatted
         "CONTA PATRIMONIAL;BEM PATRIMONIAL;SEQU“NCIA BEM;HORAS MANUTENÄ«O;POT“NCIA;MOLDE;EQUIPAMENTO;GRUPO DE MµQUINA"
         skip.
end. /* if tt-param.exporta */

for each int_param_cta_uep no-lock
   where int_param_cta_uep.cod_empresa  = v_cod_empres_usuar
     and int_param_cta_uep.cod_cta_pat >= tt-param.cod_cta_ini
     and int_param_cta_uep.cod_cta_pat <= tt-param.cod_cta_fim,
    each bem_pat use-index bempat_dat_aquis no-lock
   where bem_pat.cod_empresa        = int_param_cta_uep.cod_empresa
     and bem_pat.cod_cta_pat        = int_param_cta_uep.cod_cta_pat
     and bem_pat.cod_estab         >= tt-param.cod_estab_ini
     and bem_pat.cod_estab         <= tt-param.cod_estab_fim
     and bem_pat.dat_aquis_bem_pat >= tt-param.dat_aquis_ini
     and bem_pat.dat_aquis_bem_pat <= tt-param.dat_aquis_fim
     and bem_pat.num_bem_pat       >= tt-param.num_bem_ini
     and bem_pat.num_bem_pat       <= tt-param.num_bem_fim
     and bem_pat.num_seq_bem_pat   >= tt-param.num_seq_bem_ini
     and bem_pat.num_seq_bem_pat   <= tt-param.num_seq_bem_fim:
    assign i-cont        = i-cont + 1
           lg-compl      = no
           lg-ccusto-ok  = no
           c-gm-aux      = ""
           c-inconsis    = ""
           c-cc-consider = "Nenhum".

    if i-cont mod 15 = 0
    then run pi-acompanhar in h-acomp (input bem_pat.cod_cta_pat + " - " + string(bem_pat.dat_aquis_bem_pat)).

    /***** In°cio de validaá‰es e filtragens *****/
    if not can-find(first aloc_bem where
                          aloc_bem.num_id_bem_pat = bem_pat.num_id_bem_pat
                          no-lock)
    then if  bem_pat.cod_plano_ccusto    = tt-param.cod_plano_ccusto
         and bem_pat.cod_ccusto_respons >= tt-param.cod_ccusto_ini
         and bem_pat.cod_ccusto_respons <= tt-param.cod_ccusto_fim
         then.
         else next.
    else if not can-find(first aloc_bem where
                               aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
                           and aloc_bem.cod_empresa      = bem_pat.cod_empresa
                           and aloc_bem.cod_plano_ccusto = tt-param.cod_plano_ccusto
                           and aloc_bem.cod_ccusto      >= tt-param.cod_ccusto_ini
                           and aloc_bem.cod_ccusto      <= tt-param.cod_ccusto_fim
                               no-lock)
         then next.

    if not can-find(first aloc_bem where
                          aloc_bem.num_id_bem_pat = bem_pat.num_id_bem_pat
                          no-lock)
    then if  bem_pat.cod_plano_ccusto    = int_param_uep.cod_plano_ccusto
         and bem_pat.cod_ccusto_respons >= int_param_uep.cod_ccusto_ini
         and bem_pat.cod_ccusto_respons <= int_param_uep.cod_ccusto_fim
         then assign lg-ccusto-ok  = yes
                     c-cc-consider = "Responsab".
         else.
    else if can-find(first aloc_bem where
                           aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
                       and aloc_bem.cod_empresa      = bem_pat.cod_empresa
                       and aloc_bem.cod_plano_ccusto = int_param_uep.cod_plano_ccusto
                       and aloc_bem.cod_ccusto      >= int_param_uep.cod_ccusto_ini
                       and aloc_bem.cod_ccusto      <= int_param_uep.cod_ccusto_fim
                           no-lock)
         then assign lg-ccusto-ok  = yes
                     c-cc-consider = "Alocaá‰es".

    for first int_bem_pat use-index ch-id 
        where int_bem_pat.num_id_bem_pat = bem_pat.num_id_bem_pat
              no-lock: end.

    if not avail int_bem_pat
    then if not lg-ccusto-ok
         or not tt-param.sem-cad
         or bem_pat.val_perc_bxa >= 100
         then next.
         else.
    else do:
         if  not int_bem_pat.molde
         and not can-find(first int_bem_pat_gm where 
                                int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat
                                no-lock)
         then if tt-param.cad-incompl
              then do:
                   assign c-inconsis = "Sim-1".
        
                   if index(c-lista,"1") = 0
                   then assign c-lista = c-lista + "1".
              end.
              else next.
         else if int_bem_pat.molde
              then if can-find(first int_bem_pat_gm where 
                                     int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat
                                     no-lock)
                   then if tt-param.cad-incompl
                        then do:
                             assign c-inconsis = "Sim-2".
         
                             if index(c-lista,"2") = 0
                             then assign c-lista = c-lista + "2".
                        end.
                        else next.
                   else if  int_bem_pat.equipamento         <> ""
                        and length(int_bem_pat.equipamento) <= 10
                        and can-find(first ferr-prod where
                                           ferr-prod.cod-ferr-prod = int_bem_pat.equipamento
                                       and ferr-prod.char-1        = "Ferramenta"
                                           no-lock)
                        then assign lg-compl = yes.
                        else if tt-param.cad-incompl
                             then do:
                                  assign c-inconsis = "Sim-8".
                
                                  if index(c-lista,"8") = 0
                                  then assign c-lista = c-lista + "8".
                             end.
                             else next.
              else assign lg-compl = yes.

         for each int_bem_pat_gm no-lock
            where int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat:
             if not can-find(first grup-maquina where
                                   grup-maquina.gm-codigo = int_bem_pat_gm.gm-codigo
                                   no-lock)
             then if index(c-inconsis,"3") > 0
                  then.
                  else do:
                       if c-inconsis <> ""
                       then assign c-inconsis = c-inconsis + "3".
                       else assign c-inconsis = "Sim-3".

                       if index(c-lista,"3") = 0
                       then assign c-lista = c-lista + "3".
                  end.
             else do:
                  for first gm-estab
                      where gm-estab.gm-codigo   = int_bem_pat_gm.gm-codigo
                        and gm-estab.cod-estabel = bem_pat.cod_estab
                            no-lock: end.
        
                  if  avail gm-estab
                  and gm-estab.cc-codigo >= int_param_uep.cod_ccusto_ini
                  and gm-estab.cc-codigo <= int_param_uep.cod_ccusto_fim
                  then if can-find(first aloc_bem where
                                         aloc_bem.num_id_bem_pat   = int_bem_pat.num_id_bem_pat
                                     and aloc_bem.cod_empresa      = int_bem_pat.cod_empresa
                                     and aloc_bem.cod_plano_ccusto = int_param_uep.cod_plano_ccusto
                                     and aloc_bem.cod_ccusto       = gm-estab.cc-codigo
                                         no-lock)
                       or (not can-find(first aloc_bem where
                                              aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
                                              no-lock)
                       and bem_pat.cod_plano_ccusto   = int_param_uep.cod_plano_ccusto
                       and bem_pat.cod_ccusto_respons = gm-estab.cc-codigo)
                       then.
                       else if index(c-inconsis,"5") > 0
                            then.
                            else do:
                                 if c-inconsis <> ""
                                 then assign c-inconsis = c-inconsis + "5".
                                 else assign c-inconsis = "Sim-5".
        
                                 if index(c-lista,"5") = 0
                                 then assign c-lista = c-lista + "5".
                            end. /* else do */
                  else if index(c-inconsis,"4") > 0
                       then.
                       else do:
                            if c-inconsis <> ""
                            then assign c-inconsis = c-inconsis + "4".
                            else assign c-inconsis = "Sim-4".

                            if index(c-lista,"4") = 0
                            then assign c-lista = c-lista + "4".
                       end.
             end. /* else do */

             if index(c-gm-aux,"e outros") > 0
             then next.
             else if length(c-gm-aux) + length(int_bem_pat_gm.gm-codigo) > 40
                  then do:
                       assign c-gm-aux = c-gm-aux + "e outros".
                       next.
                  end.

             assign c-gm-aux = c-gm-aux 
                             + int_bem_pat_gm.gm-codigo
                             + ", ".

             create tt_int_bem_pat_gm.
             buffer-copy int_bem_pat_gm to tt_int_bem_pat_gm.
         end. /* for each int_bem_pat_gm */
    end. /* else do */

    if c-inconsis <> ""
    then assign lg-compl = no.

    if  not lg-compl
    and lg-ccusto-ok
    then if not avail int_bem_pat
         then do:
              if c-inconsis <> ""
              then assign c-inconsis = c-inconsis + "7".
              else assign c-inconsis = "Sim-7".
    
              if index(c-lista,"7") = 0
              then assign c-lista = c-lista + "7".
         end. /* if not avail int_bem_pat */
         else do:
              if c-inconsis <> ""
              then assign c-inconsis = c-inconsis + "6".
              else assign c-inconsis = "Sim-6".
    
              if index(c-lista,"6") = 0
              then assign c-lista = c-lista + "6".
         end. /* else do */
    else /* n∆o deve entrar no if abaixo */
         if  lg-compl
         and not lg-ccusto-ok
         then do:
              if c-inconsis <> ""
              then assign c-inconsis = c-inconsis + "9".
              else assign c-inconsis = "Sim-9".
        
              if index(c-lista,"9") = 0
              then assign c-lista = c-lista + "9".
         end.

    if c-inconsis <> "" 
    then assign lg-inconsis = yes.
    else if tt-param.so-inconsis
         then next.

    if  lg-compl
    and not tt-param.cad-compl
    then next.

    find current tt_int_bem_pat_gm no-error.
    /***** Fim de validaá‰es e filtragens *****/

    if  tt-param.exporta
    and bem_pat.val_perc_bxa < 100
    then do:
         put stream st-export unformatted
             bem_pat.cod_cta_pat ";"
             bem_pat.num_bem_pat ";"
             bem_pat.num_seq_bem_pat ";".

         if avail int_bem_pat
         then put stream st-export unformatted
                  int_bem_pat.hr_manut ";"
                  int_bem_pat.potencia ";"
                  int_bem_pat.molde.
         else put stream st-export unformatted
                  ";;".

         put stream st-export 
             ";;"
             skip.
    end. /* if tt-param.exporta */

    assign c-gm-aux = trim(c-gm-aux)
           c-gm-aux = trim(c-gm-aux,",").

    disp bem_pat.cod_cta_pat
         bem_pat.cod_estab
         bem_pat.dat_aquis_bem_pat
         bem_pat.num_bem_pat
         bem_pat.num_seq_bem_pat
         bem_pat.des_bem_pat
         int_bem_pat.molde       when avail int_bem_pat
         int_bem_pat.equipamento when avail int_bem_pat
         int_bem_pat.hr_manut    when avail int_bem_pat
         int_bem_pat.potencia    when avail int_bem_pat
         lg-compl
         c-inconsis
         c-cc-consider
         bem_pat.cod_ccusto_respons
         with frame f-dados.

    if not can-find(first aloc_bem where
                          aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
                      and aloc_bem.cod_empresa      = bem_pat.cod_empresa
                      and aloc_bem.cod_plano_ccusto = tt-param.cod_plano_ccusto
                      and aloc_bem.cod_ccusto      >= tt-param.cod_ccusto_ini
                      and aloc_bem.cod_ccusto      <= tt-param.cod_ccusto_fim
                          no-lock)
    then do:
         disp c-gm-aux 
              with frame f-dados.
         down with frame f-dados.
         next.
    end.

    for each aloc_bem no-lock
       where aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
         and aloc_bem.cod_empresa      = bem_pat.cod_empresa
         and aloc_bem.cod_plano_ccusto = tt-param.cod_plano_ccusto
         and aloc_bem.cod_ccusto      >= tt-param.cod_ccusto_ini
         and aloc_bem.cod_ccusto      <= tt-param.cod_ccusto_fim:
        disp aloc_bem.cod_ccusto
             c-gm-aux
             with frame f-dados.
        down with frame f-dados.

        assign c-gm-aux = "".
    end. /* for each aloc_bem */      
end. /* for each bem_pat */

if tt-param.exporta
then output stream st-export close.

if lg-inconsis
then do:
     put unformatted                            skip(2)
         fill("-",95)                           skip
         "INCONSIST“NCIAS FORAM IDENTIFICADAS"  skip(1)
         "C¢digo da Inconsistància - Descriá∆o" skip.

     if index(c-lista,"1") > 0
     then put unformatted
         "1 - Molde desmarcado, e sem Gr M†quina cadastrado" skip.

     if index(c-lista,"2") > 0
     then put unformatted
         "2 - Molde marcado, e com Gr M†quina cadastrado" skip.

     if index(c-lista,"3") > 0
     then put unformatted
         "3 - Gr M†quina eliminado" skip.

     if index(c-lista,"4") > 0
     then put unformatted
         "4 - Centro de Custo do Gr. M†quina x Estabelecimento fora do intervalo " int_param_uep.cod_ccusto_ini "-" int_param_uep.cod_ccusto_fim skip.

     if index(c-lista,"5") > 0
     then put unformatted
         "5 - Centro de Custo do GM x Estab n∆o pertence ao Bem" skip.

     if index(c-lista,"6") > 0
     then put unformatted
         "6 - Cadastro Incompleto de um Bem que possui Centro de Custo dentro do intervalo " int_param_uep.cod_ccusto_ini "-" int_param_uep.cod_ccusto_fim skip.

     if index(c-lista,"7") > 0
     then put unformatted
         "7 - Cadastro n∆o realizado de um Bem que possui Centro de Custo dentro do intervalo " int_param_uep.cod_ccusto_ini "-" int_param_uep.cod_ccusto_fim skip.

     if index(c-lista,"8") > 0
     then put unformatted
         "8 - Equipamento inconsistente (em branco, n∆o cadastrado, n∆o cadastrado como Ferramenta, ou muito extenso para arquivo UEP)" skip.

     if index(c-lista,"9") > 0
     then put unformatted
         "9 - Cadastro Completo com nenhum Centro de Custo dentro do intervalo " int_param_uep.cod_ccusto_ini "-" int_param_uep.cod_ccusto_fim skip.
end. /* if lg-inconsis */

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

return "OK":U.

/******************** PROCEDURES ********************/

