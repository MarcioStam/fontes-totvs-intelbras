/********************************************************************************
*      Programa .....: escdp126rp.p                                             *
*      Data .........: 10 de fevereiro de 2023                                  *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur°cio C.                                              *
*      Objetivo .....: Eliminaá∆o Gr Maq Patrimìnio UEP                         *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL    MOTIVO                           *
*      2.12.00.000  10/02/2023  Mauricio C.    Desenvolvimento                  *
********************************************************************************/
function fn-get-copy returns character (input c-file as character) forwards.
{include/i-prgvrs.i escdp126rp 2.12.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escdp126rp ESP}
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

define temp-table tt_int_bem_pat no-undo
    field gm-codigo       as char
    field descricao       as char
    field num_bem_pat     as inte
    field num_seq_bem_pat as inte
    field cod_cta_pat     as char
    field des_bem_pat     as char
    field num_id_bem_pat  as inte
    field linha           as inte
    field erro            as logi
    field mensagem        as char
    index id is primary erro
                        gm-codigo
                        num_bem_pat
                        num_seq_bem_pat
                        cod_cta_pat
                        linha
    index id2 gm-codigo
              num_bem_pat
              num_seq_bem_pat
              cod_cta_pat.

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
def var c-param-arq  as char   no-undo.
def var c-arq-copy   as char   no-undo.
def var i-cont       as inte   no-undo.
def var c-imp        as char   no-undo.
def var c-tp-aux     as char   no-undo.
def var lg-existe-gm as logi   no-undo.
def var lg-cabec     as logi   no-undo.

def var c-gm-codigo       as char no-undo.
def var i_num_bem_pat     as inte no-undo.
def var i_num_seq_bem_pat as inte no-undo.
def var c_cod_cta_pat     as char no-undo.

def new global shared var v_cod_empres_usuar as character no-undo.

def buffer b_int_bem_pat    for int_bem_pat.
def buffer b_tt_int_bem_pat for tt_int_bem_pat.

def stream st-imp.
def stream st-out.

/***** FRAMES *****/
form tt_int_bem_pat.linha           format ">>>>>9"      column-label "Linha Arq"
     tt_int_bem_pat.gm-codigo       format "x(9)"        column-label "Grupo Maq"
     tt_int_bem_pat.descricao       format "x(32)"       column-label "Descriá∆o Gr Maq"
     tt_int_bem_pat.num_bem_pat     format ">>>>>>>>9"   column-label "Bem Pat"
     tt_int_bem_pat.num_seq_bem_pat format ">>>>9"       column-label "Seq Bem"
     tt_int_bem_pat.cod_cta_pat     format "x(18)"       column-label "Conta Patrimonial"
     tt_int_bem_pat.des_bem_pat     format "x(40)"       column-label "Descriá∆o Bem Pat"
     tt_int_bem_pat.mensagem        format "x(82)"       column-label "Mensagem"
     with width 215 down no-box stream-io frame f-dados.

form tt-erro.linha    format ">>>>>>9"   column-label "Linha"
     tt-erro.cod-erro format ">9"        column-label "Cod"
     tt-erro.bem      format ">>>>>>>>9" column-label "Bem"
     tt-erro.mensagem format "x(190)"    column-label "Erro"
     with width 215 down no-box stream-io frame f-erro.

find first param-global no-lock no-error.

for first int_param_uep
    where int_param_uep.cod_empresa = v_cod_empres_usuar
          no-lock: end.

assign c-programa     = "ESCDP126":U
       c-versao       = "2.12.00":U
       c-revisao      = "000":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "Eliminaá∆o Gr Maq Patrimìnio UEP"
       c-sistema      = "ESP".

assign c-rodape = "iDBA - " 
                + c-sistema 
                + " - " 
                + c-programa
                + " - V:" 
                + c-versao
                + "."
                + c-revisao
       c-rodape = fill("-", 215 - length(c-rodape)) + c-rodape.

form header
     fill("-", 215) format "x(215)" skip
     c-empresa c-titulo-relat at 50
     "Folha:" at 205 page-number  at 211 format ">>>>9" skip
     fill("-", 195) format "x(193)" today format "99/99/9999"
     "-" string(time, "HH:MM:SS") skip(1)
     with stream-io width 215 no-labels no-box page-top frame f-cabec.

form header
     c-rodape format "x(215)"
     with stream-io width 215 no-labels no-box page-bottom frame f-rodape.

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
    and not replace(c-imp,"µ","A") begins "GRUPO MAQUINA;"
    then.
    else next.

    if num-entries(c-imp,";") <> 4
    then do:
         run pi-erro (input i-cont,
                      input 1,
                      input "Nro. imprevisto de entradas com o delimitador ~";~"").
         next.
    end.

    assign c-tp-aux          = ""
           c-gm-codigo       = ""
           i_num_seq_bem_pat = 0
           c_cod_cta_pat     = "".

    assign c-gm-codigo   = trim(entry(1,c-imp,";"))
           c_cod_cta_pat = trim(entry(4,c-imp,";")).

    assign i_num_bem_pat = inte(entry(2,c-imp,";")) no-error.

    if error-status:error
    then assign c-tp-aux = c-tp-aux + "Bem Pat, ".

    assign i_num_seq_bem_pat = inte(entry(3,c-imp,";")) no-error.

    if error-status:error
    then assign c-tp-aux = c-tp-aux + "Seq Bem, ".   

    if c-tp-aux <> ""
    then do:
         assign c-tp-aux = trim(c-tp-aux)
                c-tp-aux = trim(c-tp-aux,",").

         run pi-erro (input i-cont,
                      input 2,
                      input "Linha ignorada. Erro quanto ao tipo de entrada de dados em " + c-tp-aux).
         next.
    end.

    release grup-maquina.

    for first int_bem_pat 
        where int_bem_pat.cod_empresa     = v_cod_empres_usuar
          and int_bem_pat.num_bem_pat     = i_num_bem_pat
          and int_bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
          and int_bem_pat.cod_cta_pat     = c_cod_cta_pat
              no-lock: end.

    for first bem_pat 
        where bem_pat.cod_empresa     = v_cod_empres_usuar
          and bem_pat.cod_cta_pat     = c_cod_cta_pat
          and bem_pat.num_bem_pat     = i_num_bem_pat
          and bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
              no-lock: end.

    if c-gm-codigo <> ""
    then for first grup-maquina
             where grup-maquina.gm-codigo = c-gm-codigo
                   no-lock: end.

    run pi-valida.

    create tt_int_bem_pat.
    assign tt_int_bem_pat.gm-codigo       = c-gm-codigo  
           tt_int_bem_pat.descricao       = grup-maquina.descricao when avail grup-maquina
           tt_int_bem_pat.num_bem_pat     = i_num_bem_pat    
           tt_int_bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
           tt_int_bem_pat.cod_cta_pat     = c_cod_cta_pat  
           tt_int_bem_pat.num_id_bem_pat  = if avail int_bem_pat
                                            then int_bem_pat.num_id_bem_pat
                                            else if avail bem_pat
                                                 then bem_pat.num_id_bem_pat
                                                 else 0
           tt_int_bem_pat.des_bem_pat     = bem_pat.des_bem_pat    when avail bem_pat
           tt_int_bem_pat.linha           = i-cont
           tt_int_bem_pat.erro            = can-find(first tt-erro where
                                                           tt-erro.linha = i-cont).
end. /* repeat */
find current tt_int_bem_pat no-error.

input stream st-imp close.

run pi-seta-titulo in h-acomp (input "Efetivando...").
run pi-acompanhar  in h-acomp (input "Aguarde transaá‰es cessarem...").

for each tt_int_bem_pat
   where tt_int_bem_pat.erro = no:

    if tt-param.simulacao
    then run pi-acompanhar in h-acomp (input string(tt_int_bem_pat.num_bem_pat)).

    assign i_num_bem_pat = tt_int_bem_pat.num_bem_pat.
    if not tt-param.simulacao
    then do:
         blk-mod:
         do transaction on error undo blk-mod, leave blk-mod 
                        on stop  undo blk-mod, leave blk-mod:            
             if not can-find(first int_bem_pat_gm where
                                   int_bem_pat_gm.num_id_bem_pat = tt_int_bem_pat.num_id_bem_pat
                               and int_bem_pat_gm.gm-codigo      = tt_int_bem_pat.gm-codigo
                                   no-lock)
             then do:
                  assign tt_int_bem_pat.mensagem = "Grupo de M†quina j† eliminado para o Bem"
                         tt_int_bem_pat.erro     = yes.

                  run pi-erro (input tt_int_bem_pat.linha,
                               input 8,
                               input tt_int_bem_pat.mensagem).    

                  leave blk-mod.
             end.

             find int_bem_pat_gm where
                  int_bem_pat_gm.num_id_bem_pat = tt_int_bem_pat.num_id_bem_pat
              and int_bem_pat_gm.gm-codigo      = tt_int_bem_pat.gm-codigo
                  exclusive-lock no-error no-wait.

             if not avail int_bem_pat_gm
             then do:
                  assign tt_int_bem_pat.mensagem = "Bem Patrimonial x Grupo M†quina bloqueado para alteraá∆o. Tente em outro momento"
                         tt_int_bem_pat.erro     = yes.

                  run pi-erro (input tt_int_bem_pat.linha,
                               input 9,
                               input tt_int_bem_pat.mensagem).    

                  leave blk-mod.
             end.

             delete int_bem_pat_gm.
         end. /* do transaction */
    end. /* if not tt-param.simulacao */

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
                              "REGISTROS OS QUAIS SERIAM ELIMINADOS ".
              else put stream st-out unformatted 
                             "LOGS DAS TENTATIVAs DE ELIMINAÄ«O " at 1.

              put stream st-out unformatted
                        "(EMPRESA " v_cod_empres_usuar ")"
                         skip(1).

              assign lg-cabec = yes.
         end. /* if first(tt_int_bem_pat.linha) */

         disp stream st-out
              tt_int_bem_pat.linha
              tt_int_bem_pat.gm-codigo
              tt_int_bem_pat.descricao
              tt_int_bem_pat.num_bem_pat
              tt_int_bem_pat.num_seq_bem_pat              
              tt_int_bem_pat.cod_cta_pat
              tt_int_bem_pat.des_bem_pat
              tt_int_bem_pat.mensagem
              with frame f-dados.
         down stream st-out with frame f-dados.
    end. /* if tt-param.todos = 1 */
end. /* for each tt_int_bem_pat */

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
    if  i_num_bem_pat > 0
    and avail int_bem_pat
    then.
    else do:
         if avail bem_pat
         then run pi-erro (input i-cont,
                           input 1,
                           input "Extens∆o do Bem Patrimonial n∆o cadastrada (escdp118)").
         else run pi-erro (input i-cont,
                           input 2,
                           input "Bem Patrimonial n∆o cadastrado").

         return "NOK".
    end. /* else do */

    if  avail bem_pat
    and bem_pat.val_perc_bxa >= 100
    then do:
         run pi-erro (input i-cont,
                      input 3,
                      input "Bem Patrimonial j† baixado").

         return "NOK".
    end.

    if c-gm-codigo = ""
    then do:
         run pi-erro (input i-cont,
                      input 4,
                      input "Grupo de M†quina deve ser informado").

         return "NOK".
    end.

    if not can-find(first int_bem_pat_gm where
                          int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat
                      and int_bem_pat_gm.gm-codigo      = c-gm-codigo
                          no-lock)
    then do:
         if avail grup-maquina
         then run pi-erro (input i-cont,
                           input 5,
                           input "Grupo de M†quina n∆o cadastrado para o Bem (ou j† eliminado)").
         else run pi-erro (input i-cont,
                           input 6,
                           input "Grupo de M†quina inv†lido").


         return "NOK".
    end.

    find tt_int_bem_pat use-index id2 where 
         tt_int_bem_pat.gm-codigo       = c-gm-codigo
     and tt_int_bem_pat.num_bem_pat     = i_num_bem_pat    
     and tt_int_bem_pat.num_seq_bem_pat = i_num_seq_bem_pat
     and tt_int_bem_pat.cod_cta_pat     = c_cod_cta_pat 
         no-error.

    if avail tt_int_bem_pat
    then do:
         run pi-erro (input i-cont,
                      input 7,
                      input "Grupo de M†quina repetido no arquivo, para o Bem. A linha original ser† considerada, e esta, desprezada").

         return "NOK".
    end.

    return "OK".
end procedure. /* procedure pi-valida */

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
