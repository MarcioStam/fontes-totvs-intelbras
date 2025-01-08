/********************************************************************************
*      Programa .....: escdp120rp.p                                             *
*      Data .........: 17 de agosto de 2022                                     *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur°cio C.                                              *
*      Objetivo .....: Importaá∆o Extens‰es Bens Patrimoniais                   *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL    MOTIVO                           *
*      1.00.00.000  17/08/2022  Mauricio C.    Desenvolvimento                  *
*      1.00.00.001              Mauricio C.                                     *
*      1.00.00.002              Mauricio C.                                     *
*      1.00.00.003  25/04/2023  Mauricio C.    Supress∆o integr. espec°fica MES *
********************************************************************************/
function fn-get-copy returns character (input c-file as character) forwards.
{include/i-prgvrs.i escdp120rp 1.00.00.003}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escdp120rp ESP}
&ENDIF

define temp-table tt-param
    field destino     as integer
    field arq-destino as char
    field arq-entrada as char
    field todos       as integer
    field usuario     as char
    field data-exec   as date
    field hora-exec   as integer
    field simulacao   as logical
    field salva-log   as logical.

define temp-table tt-raw-digita
    field raw-digita    as raw.

define temp-table tt_int_bem_pat no-undo like int_bem_pat
    field gm-codigo    as char
    field existe_bem   as logi
    field existe_gm    as logi
    field des_bem_pat  as char
    field cria_equipto as logi
    field linha        as inte
    field erro         as logi
    field mensagem     as char
    index id is primary erro
                        cod_cta_pat
                        num_bem_pat
                        num_seq_bem_pat
                        gm-codigo
                        linha
    index id2 cod_cta_pat
              num_bem_pat
              num_seq_bem_pat
              gm-codigo
    index id3 equipamento.

define temp-table tt-erro no-undo
    field linha    as inte
    field cod-erro as inte
    field bem      as inte
    field mensagem as char format "x(70)"
    index id is primary linha
                        cod-erro.

/*  Recebimento de parametros --- */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.
find current tt-param no-error.

/***** VARIµVEIS *****/
{include/i-rpvar.i}
{utp/ut-glob.i}

def var h-acomp      as handle no-undo.
def var h-escdp118b  as handle no-undo.
def var c-param-arq  as char   no-undo.
def var c-arq-copy   as char   no-undo.
def var i-cont       as inte   no-undo.
def var c-imp        as char   no-undo.
def var c-tp-aux     as char   no-undo.
def var lg-existe-gm as logi   no-undo.
def var lg-mes-pad   as logi   no-undo.
//def var lg-mes-esp   as logi   no-undo.
def var lg-cabec     as logi   no-undo.

def var c_cod_cta_pat     as char no-undo.
def var i_num_bem_pat     as inte no-undo.
def var i_num_seq_bem_pat as inte no-undo.
def var de_hr_manut       as deci no-undo.
def var de_potencia       as deci no-undo.
def var c_molde           as char no-undo.
def var lg_molde          as logi no-undo.
def var lg_cria_equipto   as logi no-undo.
def var c_equipamento     as char no-undo.
def var c-gm-codigo       as char no-undo.

def var c-aux    as char init "Sim,Nao" no-undo.
def var dt-corte as date init 12/5/2022 no-undo.

def new global shared var v_cod_empres_usuar as character no-undo.

def buffer b_int_bem_pat    for int_bem_pat.
def buffer b_tt_int_bem_pat for tt_int_bem_pat.

def stream st-imp.
def stream st-out.

/***** FRAMES *****/
form tt_int_bem_pat.linha           format ">>>>>9"      column-label "Linha Arq"
     tt_int_bem_pat.cod_cta_pat     format "x(18)"       column-label "Conta Patrimonial"
     tt_int_bem_pat.num_bem_pat     format ">>>>>>>>9"   column-label "Bem Pat"
     tt_int_bem_pat.num_seq_bem_pat format ">>>>9"       column-label "Seq Bem"
     tt_int_bem_pat.des_bem_pat     format "x(40)"       column-label "Descriá∆o Bem Pat"
     tt_int_bem_pat.hr_manut        format ">>>>,>>9.99" column-label "Hrs Manut"
     tt_int_bem_pat.potencia        format ">>>>,>>9.99" column-label "Potància kW"
     tt_int_bem_pat.molde           format "Sim/N∆o"     column-label "Molde"
     tt_int_bem_pat.equipamento     format "x(16)"       column-label "Equipamento"
     tt_int_bem_pat.gm-codigo       format "x(9)"        column-label "Grupo Maq"
     tt_int_bem_pat.existe_bem      format "Sim/N∆o"     column-label "Extens∆o j† existente"
     tt_int_bem_pat.existe_gm       format "Sim/N∆o"     column-label "Gr M†q j† existente"
     tt_int_bem_pat.mensagem        format "x(60)"       column-label "Mensagem"
     with width 250 down no-box stream-io frame f-dados.

form tt-erro.linha    format ">>>>>>9"   column-label "Linha"
     tt-erro.cod-erro format ">9"        column-label "Cod"
     tt-erro.bem      format ">>>>>>>>9" column-label "Bem"
     tt-erro.mensagem format "x(220)"    column-label "Erro"
     with width 250 down no-box stream-io frame f-erro.

find first param-global no-lock no-error.

for first int_param_uep
    where int_param_uep.cod_empresa = v_cod_empres_usuar
          no-lock: end.

assign c-programa     = "ESCDP120":U
       c-versao       = "1.00.00":U
       c-revisao      = "003":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "Importaá∆o Extens‰es Bens Patrimoniais"
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

{include/i-rpout.i &stream="stream st-out" &TOFILE=tt-param.arq-destino}

view stream st-out frame f-cabec.
view stream st-out frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Importando...").

if  tt-param.salva-log
and tt-param.destino > 1
then do:
     file-info:file-name = tt-param.arq-destino.
     assign c-param-arq = file-info:full-pathname.
     assign c-arq-copy  = fn-get-copy(input c-param-arq).
end. /* if tt-param.destino > 1 */

empty temp-table tt_int_bem_pat.

input stream st-imp from value(tt-param.arq-entrada) no-echo no-convert.

repeat:
    import stream st-imp unformatted c-imp.

    assign i-cont        = i-cont + 1
           i_num_bem_pat = 0.

    run pi-acompanhar in h-acomp (input "Linha: " + string(i-cont)).

    if  c-imp <> ""
    and not c-imp begins "CONTA PATRIMONIAL;"
    then.
    else next.

    if num-entries(c-imp,";") <> 8
    then do:
         run pi-erro (input i-cont,
                      input 1,
                      input "Nro. imprevisto de entradas com o delimitador ~";~"").
         next.
    end.

    assign c_cod_cta_pat     = ""
           i_num_seq_bem_pat = 0
           de_hr_manut       = 0
           de_potencia       = 0
           c_molde           = ""
           lg_molde          = ?
           c_equipamento     = ""
           c-gm-codigo       = ""
           c-tp-aux          = ""
           lg-existe-gm      = ?
           lg_cria_equipto   = no.

    assign c_cod_cta_pat = trim(entry(1,c-imp,";"))
           c_molde       = replace(trim(entry(6,c-imp,";")),"∆","a")
           c_equipamento = trim(entry(7,c-imp,";"))
           c-gm-codigo   = trim(entry(8,c-imp,";")).

    assign i_num_bem_pat = inte(entry(2,c-imp,";")) no-error.

    if error-status:error
    then assign c-tp-aux = c-tp-aux + "Bem Pat, ".

    assign i_num_seq_bem_pat = inte(entry(3,c-imp,";")) no-error.

    if error-status:error
    then assign c-tp-aux = c-tp-aux + "Seq Bem, ".

    assign de_hr_manut = deci(replace(entry(4,c-imp,";"),".",",")) no-error.

    if error-status:error
    then assign c-tp-aux = c-tp-aux + "Hr Manut, ".

    assign de_potencia = deci(replace(entry(5,c-imp,";"),".",",")) no-error.

    if error-status:error
    then assign c-tp-aux = c-tp-aux + "Potància kW, ".

    if lookup(c_molde,c-aux) = 0
    then assign c-tp-aux = c-tp-aux + "Molde, ".

    if c-tp-aux <> ""
    then do:
         assign c-tp-aux = trim(c-tp-aux)
                c-tp-aux = trim(c-tp-aux,",").

         run pi-erro (input i-cont,
                      input 2,
                      input "Linha ignorada. Erro quanto ao tipo de entrada de dados em " + c-tp-aux).
         next.
    end.

    release bem_pat.

    run pi-valida.

    create tt_int_bem_pat.
    assign tt_int_bem_pat.cod_cta_pat     = c_cod_cta_pat    
           tt_int_bem_pat.num_bem_pat     = i_num_bem_pat    
           tt_int_bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
           tt_int_bem_pat.num_id_bem_pat  = bem_pat.num_id_bem_pat when avail bem_pat
           tt_int_bem_pat.hr_manut        = de_hr_manut      
           tt_int_bem_pat.potencia        = de_potencia
           tt_int_bem_pat.molde           = lg_molde
           tt_int_bem_pat.equipamento     = c_equipamento
           tt_int_bem_pat.gm-codigo       = c-gm-codigo    
           tt_int_bem_pat.existe_bem      = can-find(first int_bem_pat where
                                                           int_bem_pat.cod_empresa     = v_cod_empres_usuar
                                                       and int_bem_pat.cod_cta_pat     = c_cod_cta_pat
                                                       and int_bem_pat.num_bem_pat     = i_num_bem_pat
                                                       and int_bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
                                                           no-lock)
           tt_int_bem_pat.existe_gm       = lg-existe-gm
           tt_int_bem_pat.des_bem_pat     = bem_pat.des_bem_pat when avail bem_pat
           tt_int_bem_pat.cria_equipto    = lg_cria_equipto
           tt_int_bem_pat.linha           = i-cont
           tt_int_bem_pat.erro            = can-find(first tt-erro where
                                                           tt-erro.linha = i-cont).
end. /* repeat */
find current tt_int_bem_pat no-error.

input stream st-imp close.

run pi-seta-titulo in h-acomp (input "Efetivando...").
run pi-acompanhar  in h-acomp (input "Aguarde transaá‰es cessarem...").

run esp/cdp/escdp118b.p persistent set h-escdp118b.

for each tt_int_bem_pat
   where tt_int_bem_pat.erro = no
         break by tt_int_bem_pat.cod_cta_pat
               by tt_int_bem_pat.num_bem_pat
               by tt_int_bem_pat.num_seq_bem_pat:

    if tt-param.simulacao
    then run pi-acompanhar in h-acomp (input tt_int_bem_pat.cod_cta_pat + "/" + string(tt_int_bem_pat.num_bem_pat)).

    assign i_num_bem_pat = tt_int_bem_pat.num_bem_pat.

    if  first-of(tt_int_bem_pat.num_seq_bem_pat)
    and not tt-param.simulacao
    then do transaction on error undo, leave
                        on stop  undo, leave:
             for first int_bem_pat exclusive-lock
                 where int_bem_pat.cod_empresa     = v_cod_empres_usuar
                   and int_bem_pat.cod_cta_pat     = tt_int_bem_pat.cod_cta_pat
                   and int_bem_pat.num_bem_pat     = tt_int_bem_pat.num_bem_pat
                   and int_bem_pat.num_seq_bem_pat = tt_int_bem_pat.num_seq_bem_pat:
                 for each int_bem_pat_gm exclusive-lock
                    where int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat:
                     delete int_bem_pat_gm.
                 end.
                 for each int_bem_pat_gm exclusive-lock
                    where int_bem_pat_gm.num_id_bem_pat = tt_int_bem_pat.num_id_bem_pat:
                     delete int_bem_pat_gm.
                 end.
                 delete int_bem_pat.
             end. /* for first int_bem_pat */

             if  tt_int_bem_pat.molde
             and tt_int_bem_pat.cria_equipto
             then if can-find(first ferr-prod where /* Revalida */
                                    ferr-prod.cod-ferr-prod = tt_int_bem_pat.equipamento
                                    no-lock)
                  then do:
                       assign tt_int_bem_pat.mensagem = "Equipto j† cadastrado"
                              tt_int_bem_pat.erro     = yes.

                       run pi-erro (input tt_int_bem_pat.linha,
                                    input 28,
                                    input tt_int_bem_pat.mensagem).

                       undo, leave.
                  end. /* if can-find(first ferr-prod */
                  else do:
                       run pi-executa in h-escdp118b (input  tt_int_bem_pat.equipamento,
                                                      input  tt_int_bem_pat.des_bem_pat,
                                                      output lg-mes-pad /*,
                                                      output lg-mes-esp*/ ).

                       if return-value <> "OK":U
                       then do:
                            assign tt_int_bem_pat.mensagem = "ERRO integr. Equipto MES Padr∆o. Importaá∆o n∆o realizada"
                                   tt_int_bem_pat.erro     = yes.

                            run pi-erro (input tt_int_bem_pat.linha,
                                         input 29,
                                         input tt_int_bem_pat.mensagem).                    

                            undo, leave.
                       end. /* if return-value <> "OK":U */

                       assign tt_int_bem_pat.mensagem = "Equipto " + tt_int_bem_pat.equipamento + " cadastrado".
                
                       /*if  not lg-mes-pad
                       and not lg-mes-esp
                       then assign tt_int_bem_pat.mensagem = tt_int_bem_pat.mensagem 
                                                           + ", porÇm, c/ pendància integr MES padr∆o e erro na espec°fica".
                       else*/ if not lg-mes-pad
                            then assign tt_int_bem_pat.mensagem = tt_int_bem_pat.mensagem
                                                                + ", porÇm, c/ pendància integr MES (padr∆o)".
/*                             else if not lg-mes-esp                                                                 */
/*                                  then assign tt_int_bem_pat.mensagem = tt_int_bem_pat.mensagem                     */
/*                                                                      + ", porÇm, c/ erro integr MES (espec°fica)". */
                  end. /* else do */

             create int_bem_pat.
             assign int_bem_pat.cod_empresa     = v_cod_empres_usuar
                    int_bem_pat.cod_cta_pat     = tt_int_bem_pat.cod_cta_pat    
                    int_bem_pat.num_bem_pat     = tt_int_bem_pat.num_bem_pat    
                    int_bem_pat.num_seq_bem_pat = tt_int_bem_pat.num_seq_bem_pat
                    int_bem_pat.num_id_bem_pat  = tt_int_bem_pat.num_id_bem_pat
                    int_bem_pat.hr_manut        = tt_int_bem_pat.hr_manut      
                    int_bem_pat.potencia        = tt_int_bem_pat.potencia      
                    int_bem_pat.molde           = tt_int_bem_pat.molde         
                    int_bem_pat.equipamento     = tt_int_bem_pat.equipamento.  

             if not tt_int_bem_pat.molde
             then for each b_tt_int_bem_pat use-index id2
                     where b_tt_int_bem_pat.cod_cta_pat     = tt_int_bem_pat.cod_cta_pat
                       and b_tt_int_bem_pat.num_bem_pat     = tt_int_bem_pat.num_bem_pat
                       and b_tt_int_bem_pat.num_seq_bem_pat = tt_int_bem_pat.num_seq_bem_pat
                       and b_tt_int_bem_pat.num_id_bem_pat  = tt_int_bem_pat.num_id_bem_pat
                       and b_tt_int_bem_pat.erro            = no:
                      create int_bem_pat_gm.
                      assign int_bem_pat_gm.num_id_bem_pat = b_tt_int_bem_pat.num_id_bem_pat
                             int_bem_pat_gm.gm-codigo      = b_tt_int_bem_pat.gm-codigo. 
                      find current int_bem_pat_gm no-lock no-error.
                  end. /* for each b_tt_int_bem_pat */    
         end. /* do transaction */

    if tt-param.todos = 1
    then do:
         if tt_int_bem_pat.erro
         then next.

         if not lg-cabec
         then do:
              if tt-param.simulacao
              then put stream st-out unformatted
                              fill("-",20) at 1
                              " APENAS SIMULAÄ«O "
                              fill("-",20) 
                              skip(1)
                              "REGISTROS OS QUAIS SERIAM CRIADOS/ALTERADOS ".
              else put stream st-out unformatted 
                             "LOGS DAS TENTATIVAs DE CRIAÄ«O/ALTERAÄ«O " at 1.

              put stream st-out unformatted
                        "(EMPRESA " v_cod_empres_usuar ")"
                         skip(1).

              assign lg-cabec = yes.
         end. /* if first(tt_int_bem_pat.linha) */

         disp stream st-out
              tt_int_bem_pat.linha
              tt_int_bem_pat.cod_cta_pat
              tt_int_bem_pat.num_bem_pat
              tt_int_bem_pat.num_seq_bem_pat
              tt_int_bem_pat.des_bem_pat
              tt_int_bem_pat.hr_manut
              tt_int_bem_pat.potencia
              tt_int_bem_pat.molde
              tt_int_bem_pat.equipamento
              tt_int_bem_pat.gm-codigo
              tt_int_bem_pat.existe_bem
              tt_int_bem_pat.existe_gm when tt_int_bem_pat.molde = no
              tt_int_bem_pat.mensagem
              with frame f-dados.
         down stream st-out with frame f-dados.
    end. /* if tt-param.todos = 1 */
end. /* for each tt_int_bem_pat */

find current int_bem_pat    no-lock no-error.
find current int_bem_pat_gm no-lock no-error.
release int_bem_pat.
release int_bem_pat_gm.

if not can-find(first tt_int_bem_pat where
                      tt_int_bem_pat.erro = no)
then put stream st-out unformatted
                "NENHUM REGISTRO FOI IMPORTADO!" at 1.

if temp-table tt-erro:has-records
then do:
     put stream st-out unformatted
                skip(1)
                "ERROS FORAM ENCONTRADOS!" at 1
                skip(1).

     for each tt-erro
              break by tt-erro.linha:
         if first-of(tt-erro.linha)
         then disp stream st-out
                   tt-erro.linha
                   with frame f-erro.

         disp stream st-out
              tt-erro.cod-erro
              tt-erro.bem
              tt-erro.mensagem
              with frame f-erro.
         down stream st-out with frame f-erro.
     end. /* for each tt-erro */
end. /* if temp-table tt-erro:has-records */

put stream st-out unformatted
    skip(1)
    "Nr. de linhas processadas: "
    i-cont
    skip.

run pi-finalizar in h-acomp.
run pi-finaliza  in h-escdp118b.
delete procedure h-escdp118b no-error.

{include/i-rpclo.i &stream="stream st-out"}

/* Salva Log */
if  c-arq-copy          <> ""
and search(c-param-arq) <> ?
then os-copy value(c-param-arq) value(c-arq-copy).

return "OK":U.

/******************** PROCEDURES ********************/
procedure pi-erro:
    def input parameter p-linha as inte no-undo.
    def input parameter p-erro  as inte no-undo.
    def input parameter p-msg   as char no-undo.

    if can-find(first tt-erro where
                      tt-erro.linha    = p-linha
                  and tt-erro.cod-erro = cod-erro)
    then return "OK".

    create tt-erro.
    assign tt-erro.linha    = p-linha
           tt-erro.cod-erro = p-erro
           tt-erro.bem      = i_num_bem_pat
           tt-erro.mensagem = p-msg.
    find current tt-erro no-error.

    return "OK".
end procedure. /* procedure pi-erro */

procedure pi-valida:
    def var c-msg         as char  no-undo.
    def var c_equipto_new as char  no-undo.
    def var r_aux         as rowid no-undo.

    assign lg_molde = c_molde = "Sim".

    for first bem_pat 
        where bem_pat.cod_empresa     = v_cod_empres_usuar
          and bem_pat.cod_cta_pat     = c_cod_cta_pat
          and bem_pat.num_bem_pat     = i_num_bem_pat
          and bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
              no-lock: end.

    if i_num_bem_pat = 0
    or not avail bem_pat
    then do:
         run pi-erro (input i-cont,
                      input 3,
                      input "Bem Patrimonial n∆o cadastrado").

         return "NOK".
    end.

    if not can-find(first int_param_cta_uep where
                          int_param_cta_uep.cod_empresa = bem_pat.cod_empresa
                      and int_param_cta_uep.cod_cta_pat = bem_pat.cod_cta_pat
                          no-lock)
    then do:
         run pi-erro (input i-cont,
                      input 4,
                      input "Conta Patrimonial do Bem n∆o prevista nos ParÉmetros UEP (escdp122)").

         return "NOK".
    end.

    if bem_pat.val_perc_bxa >= 100
    then do:
         run pi-erro (input i-cont,
                      input 5,
                      input "Bem Patrimonial j† baixado").

         return "NOK".
    end.

    if bem_pat.num_bem_pat > 999999
    then do:
         run pi-erro (input i-cont,
                      input 6,
                      input "N£mero Bem Pat muito extenso para arquivo UEP").

         return "NOK".
    end.

    if bem_pat.num_seq_bem_pat > 999
    then do:
         run pi-erro (input i-cont,
                      input 7,
                      input "Sequància Bem Pat muito extensa para arquivo UEP").

         return "NOK".
    end.

    if not can-find(first aloc_bem where
                          aloc_bem.num_id_bem_pat = bem_pat.num_id_bem_pat
                          no-lock)
    then if  bem_pat.cod_plano_ccusto    = int_param_uep.cod_plano_ccusto
         and bem_pat.cod_ccusto_respons >= int_param_uep.cod_ccusto_ini
         and bem_pat.cod_ccusto_respons <= int_param_uep.cod_ccusto_fim
         then.
         else run pi-erro (input i-cont,
                           input 8,
                           input "Centro de Custo Responsab fora da faixa parametrizada (escdp122)").
    else if not can-find(first aloc_bem where
                               aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
                           and aloc_bem.cod_empresa      = bem_pat.cod_empresa
                           and aloc_bem.cod_plano_ccusto = int_param_uep.cod_plano_ccusto
                           and aloc_bem.cod_ccusto      >= int_param_uep.cod_ccusto_ini
                           and aloc_bem.cod_ccusto      <= int_param_uep.cod_ccusto_fim
                               no-lock)
         then run pi-erro (input i-cont,
                           input 9,
                           input "Centro de Custo Alocaá‰es fora da faixa parametrizada (escdp122)").

    assign c-msg        = "Bem associado a registros repetidos no arquivo de importaá∆o"
           lg-existe-gm = can-find(first int_bem_pat_gm where
                                         int_bem_pat_gm.num_id_bem_pat = bem_pat.num_id_bem_pat
                                     and int_bem_pat_gm.gm-codigo      = c-gm-codigo
                                         no-lock).

    find tt_int_bem_pat use-index id2 where 
         tt_int_bem_pat.cod_cta_pat     = c_cod_cta_pat    
     and tt_int_bem_pat.num_bem_pat     = i_num_bem_pat    
     and tt_int_bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
     and tt_int_bem_pat.gm-codigo       = c-gm-codigo
         no-error.

    if avail tt_int_bem_pat
    then do:
         run pi-erro (input i-cont,
                      input 10,
                      input c-msg).

/*          run pi-erro (input tt_int_bem_pat.linha, */
/*                       input 10,                   */
/*                       input c-msg).               */

         run pi-replica-err (input c-msg,
                             input 10).

         assign tt_int_bem_pat.erro = yes.

         return "NOK".
    end.

    if ambiguous tt_int_bem_pat
    or can-find(first b_tt_int_bem_pat where
                      b_tt_int_bem_pat.cod_cta_pat     = c_cod_cta_pat
                  and b_tt_int_bem_pat.num_bem_pat     = i_num_bem_pat
                  and b_tt_int_bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
                  and b_tt_int_bem_pat.erro            = yes)
    then do:
         run pi-erro (input i-cont,
                      input 10,
                      input c-msg).

         return "NOK".
    end.

    if (c-gm-codigo = ""
    and can-find(first tt_int_bem_pat use-index id2 where 
                       tt_int_bem_pat.cod_cta_pat     = c_cod_cta_pat    
                   and tt_int_bem_pat.num_bem_pat     = i_num_bem_pat    
                   and tt_int_bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
                   and tt_int_bem_pat.gm-codigo      <> ""))
    or (c-gm-codigo <> ""
    and can-find(first tt_int_bem_pat use-index id2 where 
                       tt_int_bem_pat.cod_cta_pat     = c_cod_cta_pat    
                   and tt_int_bem_pat.num_bem_pat     = i_num_bem_pat    
                   and tt_int_bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
                   and tt_int_bem_pat.gm-codigo       = ""))
    then do:
         assign c-msg = "Linhas em que o Grupo M†quina n∆o Ç informado para o Bem, e linhas em que ele Ç informado".

         run pi-erro (input i-cont,
                      input 11,
                      input c-msg).

         run pi-replica-err (input c-msg,
                             input 11).

         return "NOK".
    end.

    if can-find(first tt_int_bem_pat use-index id2 where 
                      tt_int_bem_pat.cod_cta_pat     = c_cod_cta_pat    
                  and tt_int_bem_pat.num_bem_pat     = i_num_bem_pat    
                  and tt_int_bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
                  and tt_int_bem_pat.gm-codigo      <> c-gm-codigo
                  and tt_int_bem_pat.hr_manut       <> de_hr_manut)
    or can-find(first tt_int_bem_pat use-index id2 where 
                      tt_int_bem_pat.cod_cta_pat     = c_cod_cta_pat    
                  and tt_int_bem_pat.num_bem_pat     = i_num_bem_pat    
                  and tt_int_bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
                  and tt_int_bem_pat.gm-codigo      <> c-gm-codigo
                  and tt_int_bem_pat.potencia       <> de_potencia)
    then do:
         assign c-msg = "Inconsistància de Horas Manutená∆o e/ou Potància kW para o mesmo Bem, em Grupos M†quina diferentes".

         run pi-erro (input i-cont,
                      input 12,
                      input c-msg).

         run pi-replica-err (input c-msg,
                             input 12).

         return "NOK".
    end.
        
    if c-gm-codigo <> ""
    then do:
         if lg_molde
         then do:
              assign c-msg = "Informado Grupo M†quina, porÇm, a opá∆o Molde est† marcada".

              run pi-erro (input i-cont,
                           input 13,
                           input c-msg).

              run pi-replica-err (input c-msg,
                                  input 13).
        
              return "NOK".
         end.

         if not can-find(first grup-maquina where
                               grup-maquina.gm-codigo = c-gm-codigo
                               no-lock)
         then do:
              assign c-msg = "Ao menos um Grupo M†quina informado para o bem n∆o possui cadastro".
        
              run pi-erro (input i-cont,
                           input 14,
                           input c-msg).
        
              run pi-replica-err (input c-msg,
                                  input 14).

              return "NOK".
         end.

         for first gm-estab
             where gm-estab.gm-codigo   = c-gm-codigo
               and gm-estab.cod-estabel = bem_pat.cod_estab
                   no-lock: end.
        
         if  avail gm-estab
         and gm-estab.cc-codigo >= int_param_uep.cod_ccusto_ini
         and gm-estab.cc-codigo <= int_param_uep.cod_ccusto_fim
         then if can-find(first aloc_bem where
                                aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
                            and aloc_bem.cod_empresa      = bem_pat.cod_empresa
                            and aloc_bem.cod_plano_ccusto = int_param_uep.cod_plano_ccusto
                            and aloc_bem.cod_ccusto       = gm-estab.cc-codigo
                                no-lock)
              or (not can-find(first aloc_bem where
                                     aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
                                     no-lock)
              and bem_pat.cod_plano_ccusto   = int_param_uep.cod_plano_ccusto
              and bem_pat.cod_ccusto_respons = gm-estab.cc-codigo)
              then.
              else do:
                   assign c-msg = "Grupo M†quina x Estabelecimento n∆o vinculado ao Bem".

                   run pi-erro (input i-cont,
                                input 15,
                                input c-msg).

                   run pi-replica-err (input c-msg,
                                       input 15).

                   return "NOK".
              end. /* else do */
         else do:
              assign c-msg = "Ao menos um Grupo M†quina x Estabelecimento informado para o Bem n∆o possui Centro de Custo dentro da faixa parametrizada (escdp122)".

              run pi-erro (input i-cont,
                           input 16,
                           input c-msg).

              run pi-replica-err (input c-msg,
                                  input 16).

              return "NOK".
         end. /* else do */
    end. /* if c-gm-codigo <> "" */
    else if not lg_molde
         then do:
              assign c-msg = "Opá∆o Molde n∆o est† marcada, e Grupo M†quina n∆o foi informado".

              run pi-erro (input i-cont,
                           input 17,
                           input c-msg).

              run pi-replica-err (input c-msg,
                                  input 17).
        
              return "NOK".
         end. /* if not lg_molde */

    if lg_molde
    then do:
         for first int_bem_pat
             where int_bem_pat.cod_empresa     = bem_pat.cod_empresa
               and int_bem_pat.cod_cta_pat     = bem_pat.cod_cta_pat
               and int_bem_pat.num_bem_pat     = bem_pat.num_bem_pat
               and int_bem_pat.num_seq_bem_pat = bem_pat.num_seq_bem_pat
                   no-lock: end.

         if length(c_equipamento) > 10
         then do:
              run pi-erro (input i-cont,
                           input 19,
                           input "Equipamento muito extenso para arquivo UEP").

              return "NOK".
         end.

         if bem_pat.dat_aquis_bem_pat >= dt-corte
         then do:
              assign c_equipto_new = string(bem_pat.num_bem_pat,"999999")
                                   + "-"
                                   + string(bem_pat.num_seq_bem_pat,"999").

              if  c_equipamento <> ""
              and c_equipamento <> c_equipto_new
              then do:
                   run pi-erro (input i-cont,
                                input 26,
                                input "Equipto deve corresponder ao Nr. Bem mais Sequància (formato 999999-999)").
        
                   return "NOK".  
              end.

              assign c_equipamento   = c_equipto_new
                     lg_cria_equipto = yes.

              if can-find(first ferr-prod where 
                                ferr-prod.cod-ferr-prod = c_equipto_new
                                no-lock)
              then do:
                   run pi-erro (input i-cont,
                                input 27,
                                input "Equipto " + c_equipto_new + " j† cadastrado").
        
                   return "NOK".  
              end.
         end. /* if bem_pat.dat_aquis_bem_pat >= dt-corte */
         else do:
              if c_equipamento = ""
              then do:
                   run pi-erro (input i-cont,
                                input 18,
                                input "Equipamento deve ser informado").
        
                   return "NOK".
              end.

              for first ferr-prod
                  where ferr-prod.cod-ferr-prod = c_equipamento
                        no-lock: end.
        
              if not avail ferr-prod
              then do:
                   run pi-erro (input i-cont,
                                input 20,
                                input "Equipamento n∆o cadastrado").
        
                   return "NOK".              
              end.
        
              if ferr-prod.char-1 <> "Ferramenta"
              then do:
                   run pi-erro (input i-cont,
                                input 21,
                                input "Equipamento n∆o cadastrado como Ferramenta").
        
                   return "NOK".    
              end.
         end. /* else do */        

         if avail int_bem_pat
         then assign r_aux = rowid(int_bem_pat).
         else assign r_aux = ?.

         for first b_int_bem_pat use-index ch-equipto 
             where b_int_bem_pat.equipamento = c_equipamento
               and rowid(b_int_bem_pat)     <> r_aux
                   no-lock: end.

         if avail b_int_bem_pat
         then do:
              run pi-erro (input i-cont,
                           input 22,
                           input "Equipamento j† cadastrado para outro Bem (" + b_int_bem_pat.cod_cta_pat + "/" + string(b_int_bem_pat.num_bem_pat) + "/" + string(b_int_bem_pat.num_seq_bem_pat) + ")").

              return "NOK".                 
         end.

         if can-find(first tt_int_bem_pat use-index id3 where 
                           tt_int_bem_pat.equipamento = c_equipamento)
         then do:
              assign c-msg = "Equipamento replicado dentro do arquivo".
              
              run pi-erro (input i-cont,
                           input 23,
                           input c-msg).
              
              run pi-replica-err (input c-msg,
                                  input 23).
        
              return "NOK".
         end.
    end. /* if lg_molde */
    else if c_equipamento <> ""
         then do:
              run pi-erro (input i-cont,
                           input 24,
                           input "Molde desmarcado, porÇm, equipamento foi informado").

              return "NOK".
         end.

    if  de_hr_manut >= 0
    and de_potencia >= 0
    then if de_hr_manut > 528
         then run pi-erro (input i-cont,
                      input 29,
                      input "Horas Manutená∆o n∆o pode exceder o limite de 528").
         else.
    else run pi-erro (input i-cont,
                      input 25,
                      input "Inconsistància de Horas Manutená∆o e/ou Potància kW para o Bem: valor(es) negativo(s)").

    return "OK".
end procedure. /* procedure pi-valida */

procedure pi-replica-err:
    def input param p-msg      as char no-undo.
    def input param p-cod-erro as inte no-undo.

    for each b_tt_int_bem_pat use-index id2 
       where b_tt_int_bem_pat.cod_cta_pat     = c_cod_cta_pat    
         and b_tt_int_bem_pat.num_bem_pat     = i_num_bem_pat    
         and b_tt_int_bem_pat.num_seq_bem_pat = i_num_seq_bem_pat:
        run pi-erro (input b_tt_int_bem_pat.linha,
                     input p-cod-erro,
                     input p-msg).

        assign b_tt_int_bem_pat.erro = yes.
    end.

    return "OK".
end procedure. /* procedure pi-replica-err */

function fn-get-copy returns character (input c-file as character):
    def var c-arq-aux as char no-undo.
    def var c-dir-aux as char no-undo.
    def var c-result  as char no-undo.

    assign c-dir-aux = replace(c-file,"\","/")
           c-arq-aux = substr(c-dir-aux,r-index(c-dir-aux,"/"),length(c-dir-aux))
           c-arq-aux = substr(c-arq-aux,1,r-index(c-arq-aux,".") - 1)
                     + "_LOG"
                     + string(year(today),"9999")
                     + string(month(today),"99")
                     + string(day(today),"99")
                     + string(time)
                     + substr(c-arq-aux,r-index(c-arq-aux,"."),length(c-arq-aux))
                     no-error.

    if error-status:error
    then return "".

    assign file-info:file-name = substr(c-dir-aux,1,r-index(c-dir-aux,"/")).
    assign c-result = file-info:full-pathname
                    + c-arq-aux
           c-result = replace(c-result,"\","/").

    if c-result = ?
    then return "".

    return c-result.
end function.

