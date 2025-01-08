/********************************************************************************
*      Programa .....: escsp015rp.p                                             *
*      Data .........: 13 de julho de 2022                                      *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur°cio C.                                              *
*      Objetivo .....: Extraá∆o de Dados UEP                                    *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL   MOTIVO                            *
*      1.00.00.001  13/07/2022  Mauricio C.   Desenvolvimento                   *
********************************************************************************/
function fn-get-dir returns character (input p-file as character):
    def var c-dir-aux as char no-undo.
    def var c-result  as char no-undo.

    if p-file begins "\\"
    then assign c-dir-aux = replace(p-file,"/","\")
                 c-result = substr(c-dir-aux,1,r-index(c-dir-aux,"\"))
                 c-result = replace(c-result,"/","\").
    else assign c-dir-aux = replace(p-file,"\","/")
                c-result  = substr(c-dir-aux,1,r-index(c-dir-aux,"/"))
                c-result  = replace(c-result,"\","/").

    if c-result = ""
    or c-result = ?
    then assign c-result = session:temp-directory.

    return c-result.
end function.

{include/i-prgvrs.i escsp015rp 1.00.00.001}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escsp015rp ESP}
&ENDIF

define temp-table tt-param no-undo
    field destino         as integer
    field arquivo         as char format "x(35)"
    field usuario         as char format "x(12)"
    field data-exec       as date
    field hora-exec       as integer
    field classifica      as integer
    field desc-classifica as char format "x(40)"
    field modelo-rtf      as char format "x(35)"
    field l-habilitaRtf   as LOG
    field execucao        as inte
    field dt-trans-ini    as date
    field dt-trans-fim    as date
    field diretorio       as char
    field estrutura       as logi
    field produtos        as logi
    field producoes       as logi
    field processos       as logi
    field procpo          as logi
    field procsa          as logi
    field mao-de-obra     as logi
    field turnos          as logi
    field centros-custo   as logi
    field despcc          as logi
    field postos-oper     as logi
    field equiptos        as logi
    field poxequiptos     as logi.

define temp-table tt-digita no-undo
    field cod-estabel as character format "x(5)"
    field nome        as character format "x(40)"
    index id cod-estabel.

def temp-table tt-produtos no-undo
    field it-codigo   as character 
    field desc-item   as character
    field po-erro     as logical
    index id is primary it-codigo.

def temp-table tt-pai-filho no-undo
    field it-codigo   as character
    field es-codigo   as character
    field quant-usada as decimal
    field fantasma    as logical
    index id is primary it-codigo
                        es-codigo.

def temp-table tt-producoes no-undo
    field it-codigo   like movto-estoq.it-codigo
    field cod-estabel like movto-estoq.cod-estabel
    field quantidade  as deci format "->>>>>>>>9.999999"
    index id is primary it-codigo
                        cod-estabel.

def temp-table tt-semiacabados no-undo
    field it-codigo    like ord-prod.it-codigo
    field cod-estabel  like ord-prod.cod-estabel
    field qt-pai       as deci format "->>>>>>>>9.999999"
    field es-codigo    like movto-estoq.it-codigo
    field nr-ord-produ like ord-prod.nr-ord-produ
    field quantidade   as deci format "->>>>>>>>9.999999"
    index id is primary it-codigo
                        cod-estabel
                        es-codigo
                        nr-ord-produ.

def temp-table tt-semiacabados-aux no-undo
    field it-codigo    like estrutura.it-codigo
    field cod-estabel  like estabelec.cod-estabel
    field es-codigo    like estrutura.es-codigo
    index id is primary it-codigo
                        cod-estabel
                        es-codigo.

def temp-table tt-ord-prod no-undo
    field it-codigo    like ord-prod.it-codigo
    field nr-ord-produ like ord-prod.nr-ord-produ
    field tipo         as char
    index id is primary it-codigo
                        nr-ord-produ.

def temp-table tt-oper-ord no-undo
    field nr-ord-produ like oper-ord.nr-ord-produ
    field it-codigo    like oper-ord.it-codigo
    field cod-roteiro  like oper-ord.cod-roteiro
    field op-codigo    like oper-ord.op-codigo
    field gm-codigo    like oper-ord.gm-codigo
    field tipo         as char
    field cod-estabel  like movto-estoq.cod-estabel
    field tempo-maquin as deci format "->>>>>>>>9.999999"
    field quantidade   as deci format "->>>>>>>>9.999999"
    field tempo-unit   as deci format "->>>>>>>>9.999999"
    field it-aux       like oper-ord.it-codigo
    index id is primary nr-ord-produ
                        it-codigo
                        cod-roteiro
                        op-codigo
                        gm-codigo
    index id2 it-codigo
              cod-estabel
              gm-codigo
              tipo
              nr-ord-produ
    index id3 it-codigo
              cod-estabel
              it-aux.

def temp-table tt-operacao no-undo
    field cod-estabel as char
    field it-codigo   as char
    field gm-codigo   as char
    field tempo       as deci
    field quantidade  as deci
    index id is primary cod-estabel
                        it-codigo
                        gm-codigo.

def temp-table tt-totais no-undo
    field it-codigo   like oper-ord.it-codigo
    field cod-estabel like movto-estoq.cod-estabel
    field gm-codigo   like oper-ord.gm-codigo
    field qt-total    as deci format "->>>>>>>>9.999999"
    index id is primary it-codigo
                        cod-estabel
                        gm-codigo.

def temp-table tt-estab-gm-cc no-undo
    field cod-estabel like gm-estab.cod-estabel
    field gm-codigo   like gm-estab.gm-codigo
    field cc-codigo   like gm-estab.cc-codigo
    index id is primary cod-estabel
                        gm-codigo
                        cc-codigo.

def temp-table tt-estab-gm no-undo
    field cod-estabel like gm-estab.cod-estabel
    field gm-codigo   like gm-estab.gm-codigo
    index id is primary cod-estabel
                        gm-codigo.

def temp-table tt-estab-cc no-undo
    field cod-estabel like gm-estab.cod-estabel
    field cc-codigo   like gm-estab.cc-codigo
    field descricao   like centro-custo.descricao
    index id is primary cod-estabel
                        cc-codigo.

def temp-table tt-grup-maquina no-undo
    field gm-codigo like grup-maquina.gm-codigo
    field descricao like grup-maquina.descricao
    field qt-ctrab  as inte
    index id is primary gm-codigo.

def temp-table tt-ocorrencia no-undo
    field ocorrencia as char format "x(10)"
    field sequencia  as inte
    index id is primary ocorrencia.

def temp-table tt-custo no-undo
    field cod-estabel like estabelecimento.cod_estab
    field cod-ccusto  as char
    field tipo        as inte /* 1 - Energia; 2 - Manutená∆o */
    field valor       as deci
    index id is primary cod-estabel
                        cod-ccusto
                        tipo.

def temp-table tt-custo-aux no-undo
    field cod-estabel like estabelecimento.cod_estab
    field cod-ccusto  as char
    field rateio      as deci
    field consistente as logi
    index id is primary cod-estabel
                        cod-ccusto
    index id2 consistente.

def temp-table tt_bem_pat no-undo
    field cod_estab       like bem_pat.cod_estab
    field num_bem_pat     like bem_pat.num_bem_pat
    field num_seq_bem_pat like bem_pat.num_seq_bem_pat
    field num_id_bem_pat  like bem_pat.num_id_bem_pat
    field des_bem_pat     like bem_pat.des_bem_pat
    field cod_cta_pat     like bem_pat.cod_cta_pat
    field cod_empresa     like bem_pat.cod_empresa
    field potencia        like int_bem_pat.potencia
    field hr_manut        like int_bem_pat.hr_manut
    field molde           like int_bem_pat.molde
    field equipamento     like int_bem_pat.equipamento
    field vl_deprec       as deci
    field nr_pos          as inte
    field lg_inconsis     as logi
    field mensagem        as char
    index id is primary cod_estab
                        num_bem_pat
                        num_seq_bem_pat
    index id2 cod_empresa
              cod_cta_pat
              num_bem_pat
              num_seq_bem_pat.

def temp-table tt_int_bem_pat_gm no-undo like int_bem_pat_gm.

/* Transfer Definitions */
def temp-table tt-raw-digita
   field raw-digita as raw.

/* Recebimento de parÉmetros */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. /* for each tt-raw-digita */

find current tt-param  no-error.    
find current tt-digita no-error.

/* Include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}

/* Definiá∆o de vari†veis  */
def var h-acomp     as handle no-undo.
def var h-wprog     as handle no-undo.
def var dt-aux      as date   no-undo.
def var i-cont      as inte   no-undo.
def var c-periodo   as char   no-undo.
def var c-msg       as char   no-undo.
def var c-arquivo   as char   no-undo.
def var c-extensao  as char   no-undo.
def var c-desativa  as char   no-undo.

def var de-mob-dir    as deci no-undo.
def var de-gastos-dir as deci no-undo.
def var de-depr-dir   as deci no-undo.
def var de-mob-ind    as deci no-undo.
def var de-gastos-ind as deci no-undo.
def var de-depr-ind   as deci no-undo.
def var de-manutencao as deci no-undo.
def var de-energia    as deci no-undo.
def var de-despesa    as deci no-undo.
def var de-tot-ind    as deci no-undo.
def var de-total      as deci no-undo.
def var i-seq         as inte no-undo.

def var c-gm-codigo as char format "x(16)" no-undo.

def new global shared var v_cod_empres_usuar as character no-undo.

def buffer b_tt_bem_pat      for tt_bem_pat.
def buffer b_int_bem_pat     for int_bem_pat.
def buffer b-item            for item.
def buffer b-tt-produtos     for tt-produtos.
def buffer b-tt-semiacabados for tt-semiacabados.

def stream st-export.
def stream st-export2.
def stream st-export3.

/***** FRAMES *****/
form c-arquivo                  format "x(15)" column-label "Arquivo"
     item-uni-estab.it-codigo   format "x(16)" column-label "Item"
     item.desc-item             format "x(60)" column-label "Descriá∆o"
     item-uni-estab.cod-estabel format "x(5)"  column-label "Estab"
     c-msg                      format "x(60)" column-label "Observaá∆o"
     with width 172 down no-box stream-io frame f-produtos.

form c-arquivo              format "x(15)"   column-label "Arquivo"
     tt-digita.cod-estabel  format "x(5)"    column-label "Estab"
     tt-produtos.it-codigo  format "x(16)"   column-label "Item"
     tt-produtos.desc-item  format "x(60)"   column-label "Descriá∆o Item"
     tt-produtos.po-erro    format "Sim/N∆o" column-label "PO_ERRO?"
     tt-pai-filho.es-codigo format "x(16)"   column-label "Componente"
     b-item.desc-item       format "x(60)"   column-label "Descriá∆o Componente"
     tt-pai-filho.fantasma  format "Sim/N∆o" COLUMN-LABEL "Fantasma?"
     with width 215 down no-box stream-io frame f-estrutura.

form c-arquivo                format "x(15)"          column-label "Arquivo"
     tt-producoes.it-codigo   format "x(16)"          column-label "Item"
     tt-producoes.cod-estabel format "x(5)"           column-label "Estab"
     c-periodo                format "99/9999"        column-label "Per°odo"
     tt-producoes.quantidade  format "->>>>,>>9.9999" column-label "Quantidade"
     c-msg                    format "x(75)"          column-label "Observaá∆o"
     with width 172 down no-box stream-io frame f-producoes.

form c-arquivo                format "x(15)"          column-label "Arquivo"
     tt-oper-ord.it-codigo    format "x(16)"          column-label "Item"
     tt-oper-ord.cod-estabel  format "x(5)"           column-label "Estab"
     c-periodo                format "99/9999"        column-label "Per°odo"
     tt-oper-ord.gm-codigo    format "x(16)"          column-label "Gr Maq/Ferram"
     tt-oper-ord.nr-ord-produ format ">>>,>>>,>>9"    column-label "Ord Prod"
     tt-oper-ord.tipo         format "x(10)"          column-label "Tipo"
     tt-oper-ord.op-codigo    format ">>>>9"          column-label "Oper"
     tt-oper-ord.tempo-maquin format "->>>>,>>9.9999" column-label "Tmp Maq"
     tt-oper-ord.quantidade   format "->>>>,>>9.9999" column-label "Quantidade"
     tt-producoes.quantidade  format "->>>>,>>9.9999" column-label "Produá‰es"
     de-total                 format "->>>>,>>9.9999" column-label "Resultado"
     with width 215 down no-box stream-io frame f-procpo.

form c-arquivo                    format "x(15)"        column-label "Arquivo"
     tt-semiacabados.it-codigo    format "x(16)"        column-label "Item"
     tt-semiacabados.cod-estabel  format "x(5)"         column-label "Estab"
     tt-semiacabados.qt-pai       format "->>>>,>>9.99" column-label "Qt Pai"
     c-periodo                    format "99/9999"      column-label "Per°odo"
     tt-semiacabados.es-codigo    format "x(16)"        column-label "Componente"
     tt-semiacabados.quantidade   format "->>>>,>>9.99" column-label "Qt Comp"
     tt-semiacabados.nr-ord-produ format ">>>,>>>,>>9"  column-label "Ord Prod"
     de-total                     format "->>>>>9.99"   column-label "Resultado"
     c-msg                        format "x(50)"        column-label "Observaá∆o"
     with width 172 down no-box stream-io frame f-procsa.

form c-arquivo             format "x(15)"   column-label "Arquivo"
     tt-digita.cod-estabel format "x(5)"    column-label "Estab"
     operador.cod-operador format "99999-9" column-label "Operador"
     operador.nom-operador format "x(30)"   column-label "Nome"
     with width 132 down no-box stream-io frame f-mod.

form c-arquivo                    format "x(15)"    column-label "Arquivo"
     tt-estab-gm.cod-estabel      format "x(5)"     column-label "Estab"
     tt-estab-gm.gm-codigo        format "x(9)"     column-label "Grupo Maq"
     int-gm-operador.cod-operador format "99999-9"  column-label "Operador"
     int-gm-operador.quantidade   format ">>>>>9.9" column-label "Quantidade"
     with width 132 down no-box stream-io frame f-turnos.

form c-arquivo               format "x(15)" column-label "Arquivo"
     tt-estab-cc.cod-estabel format "x(5)"  column-label "Estab"
     tt-estab-cc.cc-codigo   format "x(20)" column-label "Centro Custo"
     tt-estab-cc.descricao   format "x(32)" column-label "Descriá∆o"
     with width 132 down no-box stream-io frame f-cc.

form c-arquivo                       format "x(15)"          column-label "Arquivo"
     ext-per-custo-estab.cod-estabel format "x(5)"           column-label "Estab"
     ext-per-custo-estab.cc-codigo   format "x(20)"          column-label "Centro custo"
     c-periodo                       format "9999/99"        column-label "Per°odo"
     de-mob-dir                      format "->>>>,>>9.9999" column-label "Mob Dir"
     de-gastos-dir                   format "->>>>,>>9.9999" column-label "Gastos Dir"
     de-depr-dir                     format "->>>>,>>9.9999" column-label "Depr Dir"
     de-mob-ind                      format "->>>>,>>9.9999" column-label "Mob Ind"
     de-gastos-ind                   format "->>>>,>>9.9999" column-label "Gastos Ind"
     de-depr-ind                     format "->>>>,>>9.9999" column-label "Depr Ind"
     de-despesa                      format "->>>>,>>9.9999" column-label "Despesa"
     de-tot-ind                      format "->>>>,>>9.9999" column-label "Total Ind"
     de-manutencao                   format "->>>>,>>9.9999" column-label "Manutená∆o"
     de-energia                      format "->>>>,>>9.9999" column-label "Energia"
     with width 215 down no-box stream-io frame f-despcc.

form c-arquivo                  format "x(6)"      column-label "Arquivo"
     tt-estab-gm-cc.cod-estabel format "x(5)"      column-label "Estab"
     tt-estab-gm-cc.gm-codigo   format "x(16)"     column-label "Grupo Maq/Ferram"
     tt-grup-maquina.descricao  format "x(32)"     column-label "Descriá∆o"
     tt-estab-gm-cc.cc-codigo   format "x(20)"     column-label "Centro Custo"
     tt-grup-maquina.qt-ctrab   format ">>>>>>>>9" column-label "Qt de CTrab"
     c-desativa                 format "x(1)"      column-label "Desativa"
     c-extensao                 format "x(3)"      column-label "Vinculado a um Bem?"
     with width 132 down no-box stream-io frame f-pos.

form c-arquivo                  format "x(15)"      column-label "Arquivo"
     tt_bem_pat.cod_cta_pat     format "x(18)"      column-label "Conta Patrimonial"
     tt_bem_pat.num_bem_pat     format ">>>>>>>>9"  column-label "Bem"
     tt_bem_pat.num_seq_bem_pat format ">>>>9"      column-label "Seq"
     tt_bem_pat.des_bem_pat     format "x(40)"      column-label "Descriá∆o Bem Pat"
     tt_bem_pat.cod_estab       format "x(5)"       column-label "Estab"
     tt_bem_pat.potencia        format ">>>>>9.99"  column-label "Potància"
     tt_bem_pat.hr_manut        format ">>>>>9.99"  column-label "Hrs Manut"
     tt_bem_pat.molde           format "Sim/N∆o"    column-label "Molde"
     tt_bem_pat.equipamento     format "x(10)"      column-label "Equipamento"
     tt_bem_pat.nr_pos          format ">>>>>9"     column-label "Nr POs"
     tt_bem_pat.vl_deprec       format "->>>>>9.99" column-label "Vl Deprec"
     tt_bem_pat.mensagem        format "x(87)"      column-label "Observaá∆o"
     tt_bem_pat.lg_inconsis     format "Sim/N∆o"    column-label "Ignorado"
     with width 250 down no-box stream-io frame f-equipto.

form tt-ord-prod.it-codigo    format "x(16)"       column-label "Item"
     tt-ord-prod.nr-ord-produ format ">>>,>>>,>>9" column-label "Ord Prod"
     tt-ord-prod.tipo         format "x(10)"       column-label "Tipo"
     with width 80 down no-box stream-io frame f-log.

find first param-global no-lock no-error.

assign c-programa     = "ESCSP015":U
       c-versao       = "1.00.00":U
       c-revisao      = "001":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "LOG Extraá‰es UEP"
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

if tt-param.destino = 3 /* Terminal */
then run utp/ut-utils.p persistent set h-wprog.

{include/i-rpout.i}

if tt-param.diretorio = ""
then do:
     assign file-info:file-name = tt-param.arquivo.
     assign tt-param.diretorio = file-info:full-pathname.
     assign tt-param.diretorio = fn-get-dir(input trim(tt-param.diretorio)).
end.

view frame f-cabec.
view frame f-rodape.

if tt-param.execucao = 1 /* Online */
then do:
     run utp/ut-acomp.p persistent set h-acomp.
     run pi-inicializar in h-acomp(input "Processando extraá‰es... Aguarde!").
end. /* if tt-param.execucao = 1 */

for first int_param_uep
    where int_param_uep.cod_empresa = v_cod_empres_usuar
          no-lock: end.

assign c-periodo = string(month(tt-param.dt-trans-ini),"99")
                 + string(year(tt-param.dt-trans-ini),"9999").

/* Cuidado! Aqui, "a ordem dos fatores pode alterar o produto" */

/* Produtos */
if tt-param.produtos
or tt-param.estrutura
or tt-param.procsa
then run pi-produtos (input tt-param.diretorio + "UP_PRODUTOS.txt",
                      input tt-param.diretorio + "UP_PROCSA_estr.txt",
                      input tt-param.diretorio + "UP_PROCPO_estr.txt",
                      input tt-param.diretorio + "UP_PROCESSOS_estr.txt").

if tt-param.producoes
or tt-param.procpo
or tt-param.procsa
then do:
     if valid-handle(h-acomp)
     then do:
          run pi-seta-titulo in h-acomp (input "Processando movimentos...").
          run pi-acompanhar  in h-acomp (input "").
     end.

     run pi-esp (input 1). /* ACA */
     run pi-esp (input 8). /* EAC: Estorno */

     run pi-esp (input 28). /* REQ */
     run pi-esp (input 31). /* RRQ: Estorno */

     if temp-table tt-ord-prod:has-records
     then do:
          put unformatted skip(1)
              "ATENÄ«O! As Ordens de Produá∆o abaixo n∆o possuem registros de operaá∆o"
                          skip(1).

          for each tt-ord-prod
                   break by tt-ord-prod.it-codigo
                         by tt-ord-prod.nr-ord-produ:

              if first-of(tt-ord-prod.it-codigo)
              then disp tt-ord-prod.it-codigo
                        with frame f-log.

              disp tt-ord-prod.nr-ord-produ
                   tt-ord-prod.tipo
                   with frame f-log.
              down with frame f-log.
          end. /* for each tt-ord-prod */
     end. /* if temp-table tt-ord-prod:has-records */

     /* Semiacabados */
     run pi-procsa (input tt-param.diretorio + "UP_PROCSA.txt").

     /* Produá‰es */
     run pi-producoes (input tt-param.diretorio + "UP_PRODUCOES.txt").
     
     /* Processos e Postos Operativos */
     run pi-processos (input tt-param.diretorio + "UP_PROCPO.txt",
                       input tt-param.diretorio + "UP_PROCESSOS.txt").    
end. /* if tt-param.producoes ... */

/* M∆o de Obra direta */
if tt-param.mao-de-obra
then run pi-mod (input tt-param.diretorio + "UP_MOD.txt").

/* Turnos */
if tt-param.turnos
then run pi-turnos (input tt-param.diretorio + "UP_TURNOS.txt").

/* Centros de Custo */
if tt-param.centros-custo
then run pi-cc (input tt-param.diretorio + "UP_CC.txt").

/* Custos por Centros de Custo */
if tt-param.despcc
then run pi-despcc (input tt-param.diretorio + "UP_Despcc.txt").

/* Postos Operativos */
if tt-param.postos-oper
then run pi-po (input tt-param.diretorio + "UP_PO.txt").

if tt-param.equiptos    /* Equipamentos */
or tt-param.poxequiptos /* PO x Equipamentos */
then run pi-equiptos (input tt-param.diretorio + "UP_Equipamentos.txt",
                      input tt-param.diretorio + "UP_POxEquipamentos.txt").

if valid-handle(h-acomp)
then do:
     run pi-finalizar in h-acomp.
     if valid-handle(h-acomp)
     then delete procedure h-acomp no-error.
end.

{include/i-rpclo.i}

if valid-handle(h-wprog)
then do:
     if  tt-param.destino = 3 /* Terminal */
     and search(tt-param.arquivo) <> ?
     then run execute in h-wprog (input "notepad",
                                  input tt-param.arquivo).

     delete procedure h-wprog no-error.
end. /* if valid-handle(h-wprog) */

return "OK":U.  

/******************** Procedures ********************/
procedure pi-produtos:
    def input param p-arquivo1 as char no-undo.
    def input param p-arquivo2 as char no-undo.
    def input param p-arquivo3 as char no-undo.
    def input param p-arquivo4 as char no-undo.

    def var lg-obsol        as logi no-undo.
    def var de-tempo-maquin as deci no-undo.

    assign i-cont    = 0
           c-arquivo = "UP_Produtos".

    empty temp-table tt-produtos.
    empty temp-table tt-pai-filho.

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Extraindo produtos...").

    if tt-param.produtos
    then output stream st-export to value(p-arquivo1) convert target "iso8859-1".

    for each item-uni-estab fields(it-codigo cod-estabel cod-obsoleto cod-unid-negoc) no-lock:
        if not can-find(first tt-digita where
                              tt-digita.cod-estabel = item-uni-estab.cod-estabel)
        then next.

        assign i-cont = i-cont + 1.

        if  i-cont mod 50 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input "Item " + item-uni-estab.it-codigo).

        if item-uni-estab.cod-unid-negoc = "ENS"
        then next.

        for first item fields(desc-item un)
            where item.it-codigo    = item-uni-estab.it-codigo
              and item.compr-fabric = 2
              and item.tipo-contr  <> 4
                  no-lock: end.

        if not avail item
        then next.

        if item-uni-estab.cod-obsoleto > 3
        then do:
             if not can-find(first movto-estoq where
                                   movto-estoq.it-codigo   = item-uni-estab.it-codigo
                               and movto-estoq.cod-estabel = item-uni-estab.cod-estabel
                               and movto-estoq.dt-trans   >= tt-param.dt-trans-ini
                               and movto-estoq.dt-trans   <= tt-param.dt-trans-fim
                                   no-lock)
             then next.

             assign lg-obsol = yes.

             disp c-arquivo
                  item-uni-estab.it-codigo  
                  item.desc-item            
                  item-uni-estab.cod-estabel
                  "Obsoleto com movimento no per°odo. Registro considerado!" @ c-msg                     
                  with frame f-produtos.
             down with frame f-produtos.
        end. /* if item-uni-estab.cod-obsoleto > 3 */

        if tt-param.produtos
        then put stream st-export unformatted 
                 string(inte(item-uni-estab.cod-estabel),"99999") at 1
                 substr(item-uni-estab.it-codigo,1,15)            at 6
                 substr(trim(item.desc-item),1,50)                at 21
                 "1"                                              at 71
                 "1"                                              at 81
                 "000000001000000"                                at 91
                 item.un                                          at 106
                 "N"                                              at 154
                 skip.

        if can-find(first tt-produtos where
                          tt-produtos.it-codigo = item-uni-estab.it-codigo)
        then next.

        create tt-produtos.
        assign tt-produtos.it-codigo = item-uni-estab.it-codigo
               tt-produtos.desc-item = item.desc-item.
    end. /* for each item */
    find current tt-produtos no-error.

    if tt-param.produtos
    then do:
         output stream st-export close.

         if valid-handle(h-wprog)
         then run OpenDocument in h-wprog (input p-arquivo1). 
    end. /* if tt-param.produtos */

    if not tt-param.estrutura
    then return "OK".

    assign i-cont = 0.

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Extraindo estrutura...").

    output stream st-export  to value(p-arquivo2) convert target "iso8859-1".
    output stream st-export2 to value(p-arquivo3) convert target "iso8859-1".
    output stream st-export3 to value(p-arquivo4) convert target "iso8859-1".

    if temp-table tt-produtos:has-records
    then do:
         if lg-obsol
         then put skip(2).

         /* Carrega estrutura */
         for each tt-produtos:
             assign i-cont = i-cont + 1.
         
             if  i-cont mod 50 = 0
             and valid-handle(h-acomp)
             then run pi-acompanhar in h-acomp (input "Item " + tt-produtos.it-codigo).

             run pi-estrutura (input tt-produtos.it-codigo).
         end. /* for each tt-produtos */
         find current tt-pai-filho no-error.

         /* Carrega operaá‰es */
         assign i-cont = 0.

         if valid-handle(h-acomp)
         then run pi-seta-titulo in h-acomp (input "Extraindo operaá‰es...").
    
         put unformatted "LOGs Estrutura..." skip(1).
    
         assign c-arquivo = "Estrutura".
    
         for each tt-digita,
             each tt-produtos:
             assign i-cont = i-cont + 1
                    i-seq  = 100.
         
             if  i-cont mod 50 = 0
             and valid-handle(h-acomp)
             then run pi-acompanhar in h-acomp (input "Item " + tt-produtos.it-codigo).

             put stream st-export3 unformatted 
                 string(inte(tt-digita.cod-estabel),"99999") at 1
                 substr(tt-produtos.it-codigo,1,15)          at 6
                 c-periodo                                   at 21
                 fill("0",15)                                at 27
                 fill("0",15)                                at 42
                 fill("0",15)                                at 57
                 fill("0",15)                                at 72
                 fill("0",15)                                at 87
                 fill("0",15)                                at 102
                 fill("0",15)                                at 117
                 fill("0",15)                                at 132
                 fill("0",15)                                at 147
                 "000000000010000"                           at 162
                 fill("0",15)                                at 177
                 fill("0",15)                                at 192
                 skip.

             empty temp-table tt-operacao.

             if not can-find(first operacao where
                                   operacao.it-codigo     = tt-produtos.it-codigo
                               and operacao.data-termino >= today
                                   no-lock)
             then do:
                  assign tt-produtos.po-erro = yes.

                  put stream st-export2 unformatted 
                      string(inte(tt-digita.cod-estabel),"99999") at 1
                      substr(tt-produtos.it-codigo,1,15)          at 6
                      c-periodo                                   at 21
                      string(i-seq,"9999")                        at 27
                      "PO_ERRO"                                   at 31
                      string(0,"999999999999999")                 at 41
                      fill("0",15)                                at 56
                      fill("0",15)                                at 71
                      fill("0",15)                                at 86
                      "S"                                         at 101
                      ""                                          at 102
                      fill("0",15)                                at 152
                      fill("0",15)                                at 167
                      fill("0",15)                                at 182
                      fill("0",15)                                at 197
                      fill("0",15)                                at 212
                      fill("0",15)                                at 227
                      fill("0",15)                                at 242
                      fill("0",15)                                at 257
                      fill("0",15)                                at 272
                      fill("0",15)                                at 287
                      skip.
             end.
             else for each operacao fields(it-codigo cod-roteiro op-codigo gm-codigo tempo-maquin un-med-tempo num-id-operacao) no-lock
                     where operacao.it-codigo     = tt-produtos.it-codigo
                       and operacao.data-termino >= today,
                     first gm-estab fields() no-lock
                     where gm-estab.gm-codigo   = operacao.gm-codigo
                       and gm-estab.cod-estabel = tt-digita.cod-estabel:
                      assign de-tempo-maquin = operacao.tempo-maquin
                             c-gm-codigo     = operacao.gm-codigo.

                      case operacao.un-med-tempo:
                          when 2 /* Minutos */
                          then assign de-tempo-maquin = operacao.tempo-maquin / 60.
                          when 3 /* Segundos */
                          then assign de-tempo-maquin = operacao.tempo-maquin / 3600.
                          when 4 /* Dias */
                          then assign de-tempo-maquin = operacao.tempo-maquin * 24.
                      end case. /* case oper-ord.un-med-tempo */

                      {esp/csp/escsp015rp.i2}

                      for each op-ferram no-lock
                         where op-ferram.num-id-operacao = operacao.num-id-operacao
                           and op-ferram.op-altern       = 0
                           and op-ferram.ferramenta     <> ""
                           and op-ferram.ferramenta     <> operacao.gm-codigo,
                         first ferr-prod no-lock
                         where ferr-prod.cod-ferr-prod = op-ferram.ferramenta
                           and ferr-prod.char-1        = "Ferramenta":
                          assign c-gm-codigo = op-ferram.ferramenta.
                          {esp/csp/escsp015rp.i2}
                      end. /* for each op-ferram */
    
                  end. /* for each operacao */

             for each tt-operacao:
                 put stream st-export2 unformatted 
                     string(inte(tt-operacao.cod-estabel),"99999") at 1
                     substr(tt-operacao.it-codigo,1,15)            at 6
                     c-periodo                                     at 21
                     string(i-seq,"9999")                          at 27
                     trim(tt-operacao.gm-codigo)                   at 31
                     string((tt-operacao.tempo / tt-operacao.quantidade) * 1000000,"999999999999999") at 41
                     fill("0",15)                                  at 56
                     fill("0",15)                                  at 71
                     fill("0",15)                                  at 86
                     "S"                                           at 101
                     ""                                            at 102
                     fill("0",15)                                  at 152
                     fill("0",15)                                  at 167
                     fill("0",15)                                  at 182
                     fill("0",15)                                  at 197
                     fill("0",15)                                  at 212
                     fill("0",15)                                  at 227
                     fill("0",15)                                  at 242
                     fill("0",15)                                  at 257
                     fill("0",15)                                  at 272
                     fill("0",15)                                  at 287
                     skip.
                 
                 assign i-seq = i-seq + 100.   
             end. /* for each tt-operacao */
    
             disp c-arquivo 
                  tt-digita.cod-estabel             
                  tt-produtos.it-codigo 
                  tt-produtos.desc-item
                  tt-produtos.po-erro
                  with frame f-estrutura.
    
             if not can-find(first tt-pai-filho where
                                   tt-pai-filho.it-codigo = tt-produtos.it-codigo)
             then do:
                  down with frame f-estrutura.
                  next.
             end.
        
             for each tt-pai-filho
                where tt-pai-filho.it-codigo = tt-produtos.it-codigo:
                 for first b-item fields(it-codigo desc-item)
                     where b-item.it-codigo = tt-pai-filho.es-codigo
                           no-lock: end.
    
                 disp tt-pai-filho.es-codigo
                      b-item.desc-item when avail b-item
                      tt-pai-filho.fantasma
                      with frame f-estrutura.
                 down with frame f-estrutura.
    
                 put stream st-export unformatted 
                     string(inte(tt-digita.cod-estabel),"99999") at 1
                     substr(tt-pai-filho.it-codigo,1,15)         at 6                           
                     c-periodo                                   at 21
                     substr(tt-pai-filho.es-codigo,1,15)         at 27  
                     fill("0",15)                                at 42 
                     string(tt-pai-filho.quant-usada * 1000000,"999999999999999") at 57
                     fill("0",15)                                at 72 
                     fill("0",15)                                at 87 
                     fill("0",15)                                at 102 
                     skip.
             end. /* for each tt-pai-filho */        
         end. /* for each tt-digita */
    end. /* if temp-table tt-produtos:has-records */

    output stream st-export  close.
    output stream st-export2 close.
    output stream st-export3 close.

    if valid-handle(h-wprog) 
    then do:
         run OpenDocument in h-wprog (input p-arquivo2).
         run OpenDocument in h-wprog (input p-arquivo3).
         run OpenDocument in h-wprog (input p-arquivo4).
    end.

    return "OK".
end procedure. /* procedure pi-produtos */

procedure pi-estrutura:
    def input param p-it-codigo as char no-undo.

    for each estrutura fields(it-codigo es-codigo data-inicio data-termino quant-usada fantasma) no-lock
       where estrutura.it-codigo     = p-it-codigo
         and estrutura.data-inicio  <= today
         and estrutura.data-termino >= today:
        if can-find(first tt-pai-filho where
                          tt-pai-filho.it-codigo = estrutura.it-codigo 
                      and tt-pai-filho.es-codigo = estrutura.es-codigo)
        then return "OK".

        if not can-find(first b-tt-produtos where
                              b-tt-produtos.it-codigo = estrutura.es-codigo)
        then next.

        create tt-pai-filho.
        assign tt-pai-filho.it-codigo   = estrutura.it-codigo
               tt-pai-filho.es-codigo   = estrutura.es-codigo
               tt-pai-filho.quant-usada = estrutura.quant-usada
               tt-pai-filho.fantasma    = estrutura.fantasma.

        run pi-estrutura (input estrutura.es-codigo).
    end. /* for each estrutura */

    return "OK".
end procedure. /* procedure pi-estrutura */

procedure pi-producoes:
    def input param p-arquivo as char no-undo.

    assign c-arquivo = "UP_Producoes".

    output stream st-export to value(p-arquivo) convert target "iso8859-1".

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Extraindo producoes...").

    if temp-table tt-producoes:has-records
    then put unformatted skip(2) "LOGs UP_Producoes..." skip(1).

    for each tt-producoes:
        assign i-cont = i-cont + 1.

        if i-cont mod 50 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        if tt-producoes.quantidade <= 0
        then next.

        put stream st-export unformatted 
            string(inte(tt-producoes.cod-estabel),"99999") at 1
            substr(tt-producoes.it-codigo,1,15)            at 6
            c-periodo                                      at 21
            string(tt-producoes.quantidade * 1000000,"999999999999999") at 27
            fill("0",15)                                   at 42
            fill("0",15)                                   at 57
            skip.

        disp c-arquivo
             tt-producoes.it-codigo
             tt-producoes.cod-estabel
             c-periodo
             tt-producoes.quantidade
             with frame f-producoes.

        if not can-find(first tt-oper-ord use-index id2 where
                              tt-oper-ord.it-codigo    = tt-producoes.it-codigo
                          and tt-oper-ord.cod-estabel  = tt-producoes.cod-estabel
                          and tt-oper-ord.quantidade   > 0)
        then disp "Listado Producoes, mas n∆o listado Procpo." @ c-msg
                  with frame f-producoes.
             
        down with frame f-producoes.
    end. /* for each tt-producoes */

    output stream st-export close.

    if valid-handle(h-wprog)
    then run OpenDocument in h-wprog (input p-arquivo). 

    return "OK".
end procedure. /* procedure pi-producoes */

procedure pi-esp:
    def input parameter p-esp-docto like movto-estoq.esp-docto no-undo.

    do dt-aux = tt-param.dt-trans-ini to tt-param.dt-trans-fim:
        if valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input "Data: " + string(dt-aux) + ", Esp: " + string(p-esp-docto)).

        for each tt-digita,
            each movto-estoq fields(it-codigo cod-estabel nr-ord-produ quantidade) use-index data-esp no-lock
           where movto-estoq.dt-trans    = dt-aux
             and movto-estoq.esp-docto   = p-esp-docto
             and movto-estoq.cod-estabel = tt-digita.cod-estabel:

            if not can-find(first item-uni-estab where
                                  item-uni-estab.it-codigo       = movto-estoq.it-codigo
                              and item-uni-estab.cod-estabel     = movto-estoq.cod-estabel
                              and item-uni-estab.cod-unid-negoc <> "ENS"
                                  no-lock)
            then next.

            if not can-find(first item where
                                  item.it-codigo    = movto-estoq.it-codigo
                              and item.compr-fabric = 2
                              and item.tipo-contr  <> 4
                                  no-lock)
            then next.

            for first ord-prod fields(it-codigo cod-estabel tipo qt-ordem qt-produzida)
                where ord-prod.nr-ord-produ    = movto-estoq.nr-ord-produ
                  and ord-prod.cod-unid-negoc <> "ENS"
                  AND ord-prod.qt-produzida    > 0
                      no-lock: end.

            if not avail ord-prod
            then next.

            if  ord-prod.tipo <> 1 /* Interna    */
            and ord-prod.tipo <> 4 /* Retrabalho */
            and ord-prod.tipo <> 5 /* Conserto   */
            then next.

            if  p-esp-docto <> 1
            and p-esp-docto <> 8
            then do:
                 /* Revalida */
                 if  p-esp-docto <> 28
                 and p-esp-docto <> 31
                 then next.

                 if ord-prod.tipo <> 1 /* dif. Interna */
                 then next.

                 if not can-find(first item-uni-estab where
                                       item-uni-estab.it-codigo       = ord-prod.it-codigo
                                   and item-uni-estab.cod-estabel     = ord-prod.cod-estabel
                                   and item-uni-estab.cod-unid-negoc <> "ENS"
                                       no-lock)
                 then next.
                
                 if not can-find(first item where
                                       item.it-codigo    = ord-prod.it-codigo
                                   and item.compr-fabric = 2
                                   and item.tipo-contr  <> 4
                                       no-lock)
                 then next.

                 if  not can-find(first tt-producoes where
                                        tt-producoes.it-codigo   = movto-estoq.it-codigo
                                    and tt-producoes.cod-estabel = movto-estoq.cod-estabel)
                 and not can-find(first operacao where
                                        operacao.it-codigo     = movto-estoq.it-codigo
                                    and operacao.data-termino >= tt-param.dt-trans-ini
                                    and operacao.tipo-oper     = 1 /* Interna */
                                        no-lock)
                 then next.

                 for first tt-semiacabados
                     where tt-semiacabados.it-codigo    = ord-prod.it-codigo
                       and tt-semiacabados.cod-estabel  = ord-prod.cod-estabel
                       and tt-semiacabados.es-codigo    = movto-estoq.it-codigo
                       and tt-semiacabados.nr-ord-produ = movto-estoq.nr-ord-produ: end.
        
                 if not avail tt-semiacabados
                 then do:
                      create tt-semiacabados.
                      assign tt-semiacabados.it-codigo    = ord-prod.it-codigo   
                             tt-semiacabados.cod-estabel  = ord-prod.cod-estabel 
                             tt-semiacabados.es-codigo    = movto-estoq.it-codigo
                             tt-semiacabados.nr-ord-produ = movto-estoq.nr-ord-produ
                             tt-semiacabados.qt-pai       = ord-prod.qt-produzida.
                 end. /* if not avail tt-semiacabados */
        
                 case p-esp-docto:
                     when 28 
                     then assign tt-semiacabados.quantidade = tt-semiacabados.quantidade + movto-estoq.quantidade.
                     when 31 
                     then assign tt-semiacabados.quantidade = tt-semiacabados.quantidade - movto-estoq.quantidade.
                 end case. /* case p-esp-docto */

                 next.
            end. /* if p-esp-docto <> 1 */

            /* Produá‰es */
            if ord-prod.tipo <> 5 /* dif. Conserto */
            then do:
                 for first tt-producoes
                     where tt-producoes.it-codigo   = movto-estoq.it-codigo
                       and tt-producoes.cod-estabel = movto-estoq.cod-estabel: end.
                 
                 if not avail tt-producoes
                 then do:
                      create tt-producoes.
                      assign tt-producoes.it-codigo   = movto-estoq.it-codigo
                             tt-producoes.cod-estabel = movto-estoq.cod-estabel.                 
                 end.
                 
                 case p-esp-docto:
                     when 1 
                     then assign tt-producoes.quantidade = tt-producoes.quantidade + movto-estoq.quantidade.
                     when 8 
                     then assign tt-producoes.quantidade = tt-producoes.quantidade - movto-estoq.quantidade.
                 end case. /* case p-esp-docto */
            end. /* if ord-prod.tipo <> 5 */

            /* Postos Operativos */
            if can-find(first tt-oper-ord where
                              tt-oper-ord.nr-ord-produ = movto-estoq.nr-ord-produ)
            then do:
                 for each tt-oper-ord
                    where tt-oper-ord.nr-ord-produ = movto-estoq.nr-ord-produ:
                     case p-esp-docto:
                         when 1 
                         then assign tt-oper-ord.quantidade = tt-oper-ord.quantidade + movto-estoq.quantidade.
                         when 8 
                         then assign tt-oper-ord.quantidade = tt-oper-ord.quantidade - movto-estoq.quantidade.
                     end case. /* case p-esp-docto */

                     assign tt-oper-ord.tempo-maquin = tt-oper-ord.quantidade * tt-oper-ord.tempo-unit.
                 end. /* for each tt-oper-ord */

                 next.
            end. /* if can-find (first tt-oper-ord where */

            if not can-find(first oper-ord where
                                  oper-ord.nr-ord-produ = movto-estoq.nr-ord-produ
                                  no-lock)
            then do:
                 if not can-find(first tt-ord-prod where
                                       tt-ord-prod.it-codigo    = movto-estoq.it-codigo
                                   and tt-ord-prod.nr-ord-produ = movto-estoq.nr-ord-produ)
                 then do:
                      create tt-ord-prod.
                      assign tt-ord-prod.it-codigo    = movto-estoq.it-codigo
                             tt-ord-prod.nr-ord-produ = movto-estoq.nr-ord-produ.

                      case ord-prod.tipo:
                          when 1
                          then assign tt-ord-prod.tipo = "Interna".
                          when 4
                          then assign tt-ord-prod.tipo = "Retrabalho".
                          when 5
                          then assign tt-ord-prod.tipo = "Conserto".
                      end case. /* case ord-prod.tipo */

                      find current tt-ord-prod no-error.
                 end.     

                 for first tt-oper-ord
                     where tt-oper-ord.nr-ord-produ = movto-estoq.nr-ord-produ
                       and tt-oper-ord.it-codigo    = ord-prod.it-codigo
                       and tt-oper-ord.cod-roteiro  = ""
                       and tt-oper-ord.op-codigo    = 0
                       and tt-oper-ord.gm-codigo    = "PO_ERRO": end.

                 if not avail tt-oper-ord
                 then do:
                      create tt-oper-ord.
                      assign tt-oper-ord.nr-ord-produ = movto-estoq.nr-ord-produ
                             tt-oper-ord.it-codigo    = ord-prod.it-codigo
                             tt-oper-ord.cod-roteiro  = ""
                             tt-oper-ord.op-codigo    = 0
                             tt-oper-ord.gm-codigo    = "PO_ERRO"
                             tt-oper-ord.cod-estabel  = ord-prod.cod-estabel
                             tt-oper-ord.it-aux       = ""
                             tt-oper-ord.tempo-maquin = 0
                             tt-oper-ord.tempo-unit   = 0.

                      case p-esp-docto:
                          when 1 
                          then assign tt-oper-ord.quantidade = tt-oper-ord.quantidade + movto-estoq.quantidade.
                          when 8 
                          then assign tt-oper-ord.quantidade = tt-oper-ord.quantidade - movto-estoq.quantidade.
                      end case. /* case p-esp-docto */
                 end. /* if not avail tt-oper-ord */

                 next.
            end. /* if not can-find(first oper-ord where */
       
            for each oper-ord fields(nr-ord-produ cod-roteiro op-codigo gm-codigo ferramenta tempo-maquin un-med-tempo) no-lock
               where oper-ord.nr-ord-produ = movto-estoq.nr-ord-produ:
                assign c-gm-codigo = oper-ord.gm-codigo.
                {esp/csp/escsp015rp.i}

                if  oper-ord.ferramenta <> ""
                and oper-ord.ferramenta <> oper-ord.gm-codigo
                and can-find(first ferr-prod where 
                                   ferr-prod.cod-ferr-prod = oper-ord.ferramenta
                               and ferr-prod.char-1        = "Ferramenta"
                                   no-lock)
                then do:
                     assign c-gm-codigo = oper-ord.ferramenta.
                     {esp/csp/escsp015rp.i}
                end. /* if  oper-ord.ferramenta <> "" */
            end. /* for each oper-ord */
        end. /* for each tt-digita */
    end. /* do dt-aux */

    find current tt-producoes    no-error.
    find current tt-semiacabados no-error.
    find current tt-oper-ord     no-error.

    return "OK".
end procedure. /* procedure pi-esp */

procedure pi-processos:
    def input param p-arquivo-1 as char no-undo.
    def input param p-arquivo-2 as char no-undo.

    def var de-tempo as deci no-undo.
    def var de-aux   as deci no-undo.

    assign i-seq     = 0
           c-arquivo = "UP_Procpo".

    output stream st-export  to value(p-arquivo-1) convert target "iso8859-1".
    output stream st-export2 to value(p-arquivo-2) convert target "iso8859-1".

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Extraindo processos-pos...").

    if temp-table tt-oper-ord:has-records
    then put unformatted skip(2) "LOGs UP_Procpo..." skip(1).

    empty temp-table tt-totais.

    /* Totaliza quantidades por GM antes do processamento */
    for each tt-oper-ord use-index id2
             break by tt-oper-ord.it-codigo
                   by tt-oper-ord.cod-estabel
                   by tt-oper-ord.gm-codigo
                   by tt-oper-ord.tipo
                   by tt-oper-ord.nr-ord-produ:
        assign i-cont = i-cont + 1.
    
        if i-cont mod 50 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        if  tt-oper-ord.tipo <> "Conserto"
        and first-of(tt-oper-ord.nr-ord-produ)
        then accum tt-oper-ord.quantidade (total by tt-oper-ord.gm-codigo).

        if not last-of(tt-oper-ord.gm-codigo)
        then next.

        create tt-totais.
        assign tt-totais.it-codigo   = tt-oper-ord.it-codigo
               tt-totais.cod-estabel = tt-oper-ord.cod-estabel
               tt-totais.gm-codigo   = tt-oper-ord.gm-codigo
               tt-totais.qt-total    = accum total by tt-oper-ord.gm-codigo tt-oper-ord.quantidade.
    end. /* for each tt-oper-ord */
    find current tt-totais no-error.

    /* Reprocessa */
    for each tt-oper-ord use-index id2
             break by tt-oper-ord.it-codigo
                   by tt-oper-ord.cod-estabel
                   by tt-oper-ord.gm-codigo
                   by tt-oper-ord.tipo
                   by tt-oper-ord.nr-ord-produ:
        assign i-cont = i-cont + 1.
    
        if i-cont mod 50 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).
    
        if first-of(tt-oper-ord.cod-estabel)
        then assign i-seq = 0.
    
        accum tt-oper-ord.tempo-maquin (total by tt-oper-ord.tipo).
    
        disp c-arquivo
             tt-oper-ord.it-codigo
             tt-oper-ord.cod-estabel
             c-periodo
             tt-oper-ord.gm-codigo @ tt-oper-ord.gm-codigo
             tt-oper-ord.nr-ord-produ
             tt-oper-ord.tipo
             tt-oper-ord.op-codigo
             tt-oper-ord.tempo-maquin
             tt-oper-ord.quantidade when first-of(tt-oper-ord.nr-ord-produ)
             with frame f-procpo.
        down with frame f-procpo.
    
        if not last-of(tt-oper-ord.tipo)
        then next.

        assign de-tempo = accum total by tt-oper-ord.tipo tt-oper-ord.tempo-maquin.

        for first tt-totais
            where tt-totais.it-codigo   = tt-oper-ord.it-codigo
              and tt-totais.cod-estabel = tt-oper-ord.cod-estabel
              and tt-totais.gm-codigo   = tt-oper-ord.gm-codigo: end.

        for first tt-producoes
            where tt-producoes.it-codigo   = tt-oper-ord.it-codigo
              and tt-producoes.cod-estabel = tt-oper-ord.cod-estabel: end.

        if avail tt-producoes
        then assign de-aux = tt-producoes.quantidade.
        else assign de-aux = tt-totais.qt-total.
    
        if (de-tempo > 0
        and de-aux   > 0)
        or  tt-oper-ord.gm-codigo = "PO_Erro"
        then do:
             if i-seq = 0
             then put stream st-export2 unformatted 
                      string(inte(tt-oper-ord.cod-estabel),"99999") at 1
                      substr(tt-oper-ord.it-codigo,1,15)            at 6
                      c-periodo                                     at 21
                      fill("0",15)                                  at 27
                      fill("0",15)                                  at 42
                      fill("0",15)                                  at 57
                      fill("0",15)                                  at 72
                      fill("0",15)                                  at 87
                      fill("0",15)                                  at 102
                      fill("0",15)                                  at 117
                      fill("0",15)                                  at 132
                      fill("0",15)                                  at 147
                      "000000000010000"                             at 162
                      fill("0",15)                                  at 177
                      fill("0",15)                                  at 192
                      skip.
    
             assign i-seq    = i-seq + 100
                    de-total = de-tempo / de-aux.

             if de-total = ?
             then assign de-total = 0.
    
             put stream st-export unformatted 
                 string(inte(tt-oper-ord.cod-estabel),"99999") at 1
                 substr(tt-oper-ord.it-codigo,1,15)            at 6
                 c-periodo                                     at 21
                 string(i-seq,"9999")                          at 27
                 trim(tt-oper-ord.gm-codigo)                   at 31
                 string(de-total * 1000000,"999999999999999")  at 41
                 fill("0",15)                                  at 56
                 fill("0",15)                                  at 71
                 fill("0",15)                                  at 86
                 "S"                                           at 101
                 trim(tt-oper-ord.tipo)                        at 102
                 fill("0",15)                                  at 152
                 fill("0",15)                                  at 167
                 fill("0",15)                                  at 182
                 fill("0",15)                                  at 197
                 fill("0",15)                                  at 212
                 fill("0",15)                                  at 227
                 fill("0",15)                                  at 242
                 fill("0",15)                                  at 257
                 fill("0",15)                                  at 272
                 fill("0",15)                                  at 287
                 skip.
        end. /* if de-tempo > 0 */
    
        underline tt-oper-ord.it-codigo
                  tt-oper-ord.cod-estabel
                  c-periodo
                  tt-oper-ord.gm-codigo
                  tt-oper-ord.nr-ord-produ
                  tt-oper-ord.tipo
                  tt-oper-ord.op-codigo
                  tt-oper-ord.tempo-maquin
                  tt-oper-ord.quantidade
                  tt-producoes.quantidade
                  de-total
                  with frame f-procpo.
        down with frame f-procpo.
    
        disp tt-oper-ord.it-codigo
             tt-oper-ord.cod-estabel
             c-periodo
             tt-oper-ord.gm-codigo @ tt-oper-ord.gm-codigo   
             de-tempo              @ tt-oper-ord.tempo-maquin
             tt-totais.qt-total    @ tt-oper-ord.quantidade
             tt-producoes.quantidade when avail tt-producoes
            (de-tempo / de-aux)    @ de-total
             with frame f-procpo.
        down with frame f-procpo.
    
        put skip(1).
    end. /* for each tt-oper-ord */

    output stream st-export2 close.
    output stream st-export close.
        
    if valid-handle(h-wprog)
    then do:
         run OpenDocument in h-wprog (input p-arquivo-2).
         run OpenDocument in h-wprog (input p-arquivo-1).
    end. /* if valid-handle(h-wprog)*/

    return "OK".
end procedure. /* procedure pi-processos */

procedure pi-procsa:
    def input param p-arquivo as char no-undo.

    def var lg-valida     as logi no-undo.
    def var lg-ignora     as logi no-undo.
    def var de-quantidade as deci no-undo.

    assign i-cont    = 0
           c-arquivo = "UP_Procsa".

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Extraindo semiacabados...").

    output stream st-export to value(p-arquivo) convert target "iso8859-1".

    if temp-table tt-semiacabados:has-records
    then put unformatted skip(2) "LOGs UP_Procsa..." skip(1).

    for each tt-semiacabados
             break by tt-semiacabados.it-codigo
                   by tt-semiacabados.cod-estabel
                   by tt-semiacabados.es-codigo:
        assign i-cont = i-cont + 1.

        if  i-cont mod 50 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        accum tt-semiacabados.quantidade (total by tt-semiacabados.es-codigo).

        disp c-arquivo
             tt-semiacabados.it-codigo
             tt-semiacabados.cod-estabel
            /*tt-semiacabados.qt-pai*/ /* exclu°do do log pelo fato de a OP poder abranger mais de um màs */
             c-periodo
             tt-semiacabados.es-codigo
             tt-semiacabados.quantidade
             tt-semiacabados.nr-ord-produ
             with frame f-procsa.
        down with frame f-procsa.

        if not last-of(tt-semiacabados.es-codigo)
        then next.

        assign de-quantidade = accum total by tt-semiacabados.es-codigo tt-semiacabados.quantidade.

        assign c-msg     = ""
               de-total  = 0
               lg-ignora = no
               lg-valida = can-find(first tt-oper-ord use-index id3 where
                                          tt-oper-ord.it-codigo    = tt-semiacabados.es-codigo
                                      and tt-oper-ord.cod-estabel  = tt-semiacabados.cod-estabel
                                      and tt-oper-ord.it-aux       = ""
                                      and tt-oper-ord.quantidade   > 0).

        if  not lg-valida
        and can-find(first operacao where
                           operacao.it-codigo     = tt-semiacabados.es-codigo
                       and operacao.data-termino >= today
                           no-lock)
        then do:
             assign lg-ignora = yes.

             for each operacao fields(gm-codigo) no-lock
                where operacao.it-codigo     = tt-semiacabados.es-codigo
                  and operacao.data-termino >= today,
                first gm-estab fields() no-lock
                where gm-estab.gm-codigo   = operacao.gm-codigo
                  and gm-estab.cod-estabel = tt-semiacabados.cod-estabel:
                 assign lg-ignora = no.
                 leave.
             end. /* for each operacao */
        end. /* if not lg-valida */

        for first tt-producoes
            where tt-producoes.it-codigo   = tt-semiacabados.it-codigo
              and tt-producoes.cod-estabel = tt-semiacabados.cod-estabel: end.

        if  avail tt-producoes
        and tt-producoes.quantidade > 0
        then assign de-total = de-quantidade / tt-producoes.quantidade.
        else assign c-msg    = "Item-pai n∆o listado Producoes.".

        if  de-quantidade > 0
        and not lg-ignora
        then put stream st-export unformatted 
                 string(inte(tt-semiacabados.cod-estabel),"99999") at 1
                 substr(tt-semiacabados.it-codigo,1,15)            at 6                           
                 c-periodo                                         at 21
                 substr(tt-semiacabados.es-codigo,1,15)            at 27  
                 fill("0",15)                                      at 42 
                 string(de-total * 1000000,"999999999999999")      at 57
                 fill("0",15)                                      at 72 
                 fill("0",15)                                      at 87 
                 fill("0",15)                                      at 102 
                 skip.

        underline c-arquivo                   
                  tt-semiacabados.it-codigo   
                  tt-semiacabados.cod-estabel 
                  tt-semiacabados.qt-pai    
                  c-periodo                   
                  tt-semiacabados.es-codigo   
                  tt-semiacabados.quantidade  
                  tt-semiacabados.nr-ord-produ
                  de-total                    
                  c-msg
                  with frame f-procsa.
        down with frame f-procsa.

        disp c-arquivo
             tt-semiacabados.it-codigo
             tt-semiacabados.cod-estabel
             tt-producoes.quantidade when avail tt-producoes @ tt-semiacabados.qt-pai
             c-periodo
             tt-semiacabados.es-codigo
             de-quantidade @ tt-semiacabados.quantidade
             de-total
             with frame f-procsa.

        if  de-quantidade > 0
        and not lg-ignora
        then if not can-find(first tt-oper-ord use-index id3 where
                                   tt-oper-ord.it-codigo    = tt-semiacabados.it-codigo
                               and tt-oper-ord.cod-estabel  = tt-semiacabados.cod-estabel
                               and tt-oper-ord.it-aux       = ""
                               and tt-oper-ord.quantidade   > 0)
             then do:
                  if c-msg = ""
                  then assign c-msg = "Item-pai n∆o listado originamnte Procpo.".
                  else assign c-msg = "N∆o listado Producoes. nem originamnte Procpo.".
        
                  run pi-operacao (input tt-semiacabados.it-codigo,
                                   input tt-semiacabados.es-codigo).
             end.
             else.
        else assign c-msg = "Ignorado".

        disp c-msg
             with frame f-procsa.
        down with frame f-procsa.

        put skip(1).

        if de-quantidade <= 0
        or lg-valida
        or lg-ignora
        then next.

        run pi-operacao (input tt-semiacabados.es-codigo,
                         input tt-semiacabados.it-codigo).

        assign c-msg = "Estrutura".
            
        run pi-componentes (input tt-semiacabados.es-codigo).

        put skip(1).
    end. /* for each tt-semiacabados */

    output stream st-export close.

    if valid-handle(h-wprog)
    then run OpenDocument in h-wprog (input p-arquivo). 

    return "OK".
end procedure. /* procedure pi-procsa */

procedure pi-operacao:                     
    def input param p-it-codigo as char no-undo.
    def input param p-it-aux    as char no-undo.

    if can-find(first tt-oper-ord use-index id3 where
                      tt-oper-ord.it-codigo    = p-it-codigo
                  and tt-oper-ord.cod-estabel  = tt-semiacabados.cod-estabel
                  and tt-oper-ord.it-aux      <> "")
    then return "OK".

    if not can-find(first operacao where
                          operacao.it-codigo     = p-it-codigo
                      and operacao.data-termino >= today
                          no-lock)
    then do: 
         create tt-oper-ord.
         assign tt-oper-ord.it-codigo    = p-it-codigo
                tt-oper-ord.cod-roteiro  = ""
                tt-oper-ord.op-codigo    = 0
                tt-oper-ord.gm-codigo    = "PO_ERRO"
                tt-oper-ord.cod-estabel  = tt-semiacabados.cod-estabel
                tt-oper-ord.it-aux       = p-it-aux
                tt-oper-ord.tempo-maquin = 0
                tt-oper-ord.tempo-unit   = 0
                tt-oper-ord.quantidade   = 1.

         next.
    end.

    for each operacao fields(it-codigo cod-roteiro op-codigo gm-codigo tempo-maquin un-med-tempo num-id-operacao) no-lock
       where operacao.it-codigo     = p-it-codigo
         and operacao.data-termino >= today,
       first gm-estab fields() no-lock
       where gm-estab.gm-codigo   = operacao.gm-codigo
         and gm-estab.cod-estabel = tt-semiacabados.cod-estabel:
        assign c-gm-codigo = operacao.gm-codigo.

        {esp/csp/escsp015rp.i3}

        for each op-ferram no-lock
           where op-ferram.num-id-operacao = operacao.num-id-operacao
             and op-ferram.op-altern       = 0
             and op-ferram.ferramenta     <> ""
             and op-ferram.ferramenta     <> operacao.gm-codigo,
           first ferr-prod no-lock
           where ferr-prod.cod-ferr-prod = op-ferram.ferramenta
             and ferr-prod.char-1        = "Ferramenta":
            assign c-gm-codigo = op-ferram.ferramenta.
            {esp/csp/escsp015rp.i3}
        end. /* for each op-ferram */
    end. /* for each operacao */

    return "OK".
end procedure. /* procedure pi-operacao */

procedure pi-componentes:
    def input parameter p-it-codigo as char no-undo.

    for each estrutura fields(it-codigo es-codigo data-inicio data-termino quant-usada) no-lock
       where estrutura.it-codigo     = p-it-codigo
         and estrutura.data-inicio  <= today
         and estrutura.data-termino >= today:
        if not can-find (first tt-produtos where
                               tt-produtos.it-codigo = estrutura.es-codigo)
        or can-find(first b-tt-semiacabados where
                          b-tt-semiacabados.it-codigo   = estrutura.it-codigo
                      and b-tt-semiacabados.cod-estabel = tt-semiacabados.cod-estabel
                      and b-tt-semiacabados.es-codigo   = estrutura.es-codigo)
        then next.

        if not can-find(first tt-semiacabados-aux where
                              tt-semiacabados-aux.it-codigo   = estrutura.it-codigo
                          and tt-semiacabados-aux.cod-estabel = tt-semiacabados.cod-estabel
                          and tt-semiacabados-aux.es-codigo   = estrutura.es-codigo)
        then do:
             if not can-find(first tt-oper-ord use-index id3 where
                                   tt-oper-ord.it-codigo   = estrutura.es-codigo
                               and tt-oper-ord.cod-estabel = tt-semiacabados.cod-estabel
                               and tt-oper-ord.it-aux      = ""
                               and tt-oper-ord.quantidade  > 0)
             then run pi-operacao (input estrutura.es-codigo,
                                   input estrutura.it-codigo).
        
             put stream st-export unformatted 
                 string(inte(tt-semiacabados.cod-estabel),"99999") at 1
                 substr(estrutura.it-codigo,1,15)                  at 6                           
                 c-periodo                                         at 21
                 substr(estrutura.es-codigo,1,15)                  at 27  
                 fill("0",15)                                      at 42 
                 string(estrutura.quant-usada * 1000000,"999999999999999") at 57
                 fill("0",15)                                      at 72 
                 fill("0",15)                                      at 87 
                 fill("0",15)                                      at 102 
                 skip.

             create tt-semiacabados-aux.
             assign tt-semiacabados-aux.it-codigo   = estrutura.it-codigo
                    tt-semiacabados-aux.cod-estabel = tt-semiacabados.cod-estabel
                    tt-semiacabados-aux.es-codigo   = estrutura.es-codigo.
        end. /* if not can-find(first tt-semiacabados-aux */  

        disp c-arquivo
             estrutura.it-codigo   @ tt-semiacabados.it-codigo
             tt-semiacabados.cod-estabel
             c-periodo
             estrutura.es-codigo   @ tt-semiacabados.es-codigo
             estrutura.quant-usada @ tt-semiacabados.quantidade
             c-msg
             with frame f-procsa.
        down with frame f-procsa.

        run pi-componentes (input estrutura.es-codigo).
    end. /* for each estrutura */
    find current tt-semiacabados-aux no-error.

    return "OK".
end procedure. /* procedure pi-componentes */

procedure pi-mod:
    def input param p-arquivo as char no-undo.

    assign i-cont    = 0
           c-arquivo = "UP_Mod".

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Extraindo M∆o de Obra direta...").

    output stream st-export to value(p-arquivo) convert target "iso8859-1".

    put unformatted skip(2) "LOGs UP_Mod..." skip(1).

    for each tt-digita,
        each operador fields(cod-operador nom-operador) no-lock:
        assign i-cont = i-cont + 1.

        if  i-cont mod 50 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        put stream st-export unformatted
            string(inte(tt-digita.cod-estabel),"99999") at 1
            operador.cod-operador                       at 6
            operador.nom-operador                       at 16
/*             fill("0",15)                                at 96 */
            skip.

        disp c-arquivo
             tt-digita.cod-estabel
             operador.cod-operador
             operador.nom-operador
             with frame f-mod.
        down with frame f-mod.
    end. /* for each tt-digita */

    output stream st-export close.

    if valid-handle(h-wprog)
    then run OpenDocument in h-wprog (input p-arquivo). 

    return "OK".
end procedure. /* procedure pi-mod */

procedure pi-turnos:
    def input param p-arquivo as char no-undo.

    assign i-cont    = 0
           c-arquivo = "UP_Turnos".

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Extraindo Turnos...").

    if not temp-table tt-estab-gm:has-records 
    then run pi-estab-cc.

    output stream st-export to value(p-arquivo) convert target "iso8859-1".

    if temp-table tt-estab-gm:has-records
    then put unformatted skip(2) "LOGs UP_Turnos..." skip(1).

    for each tt-estab-gm:
        assign i-cont = i-cont + 1.

        if  i-cont mod 50 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        if not can-find(first int-gm-operador where
                              int-gm-operador.gm-codigo = tt-estab-gm.gm-codigo
                              no-lock)
        then do:
             put stream st-export unformatted
                 string(inte(tt-estab-gm.cod-estabel),"99999") at 1
                 tt-estab-gm.gm-codigo                         at 6
                 "001"                                         at 16
                 "999999"                                      at 19                
                 "000000001000000"                             at 29
                 fill("0",15)                                  at 44
                 fill("0",15)                                  at 59
                 fill("0",15)                                  at 74
                 fill("0",15)                                  at 89
                 fill("0",15)                                  at 104
                 fill("0",15)                                  at 119
                 skip.

             disp c-arquivo
                  tt-estab-gm.cod-estabel
                  tt-estab-gm.gm-codigo
                  with frame f-turnos.
             down with frame f-turnos.

             next.
        end.

        for each int-gm-operador no-lock
           where int-gm-operador.gm-codigo = tt-estab-gm.gm-codigo:
            put stream st-export unformatted
                string(inte(tt-estab-gm.cod-estabel),"99999") at 1
                tt-estab-gm.gm-codigo                         at 6
                "001"                                         at 16
                int-gm-operador.cod-operador                  at 19
                string(int-gm-operador.quantidade * 1000000,"999999999999999") at 29
                fill("0",15)                                  at 44
                fill("0",15)                                  at 59
                fill("0",15)                                  at 74
                fill("0",15)                                  at 89
                fill("0",15)                                  at 104
                fill("0",15)                                  at 119
                skip.

            disp c-arquivo
                 tt-estab-gm.cod-estabel
                 tt-estab-gm.gm-codigo
                 int-gm-operador.cod-operador
                 int-gm-operador.quantidade
                 with frame f-turnos.
            down with frame f-turnos.
        end. /* for each int-gm-operador */
    end. /* for each tt-estab-gm */

    output stream st-export close.

    if valid-handle(h-wprog)
    then run OpenDocument in h-wprog (input p-arquivo). 

    return "OK".
end procedure. /* procedure pi-turnos */

procedure pi-cc:
    def input param p-arquivo as char no-undo.

    assign i-cont    = 0
           c-arquivo = "UP_CC".

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Extraindo Centros de Custo...").

    if not temp-table tt-estab-cc:has-records 
    then run pi-estab-cc.

    output stream st-export to value(p-arquivo) convert target "iso8859-1".

    if temp-table tt-estab-cc:has-records
    then put unformatted skip(2) "LOGs UP_CC..." skip(1).

    for each tt-estab-cc:
        assign i-cont = i-cont + 1.

        if  i-cont mod 50 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        put stream st-export unformatted
            string(inte(tt-estab-cc.cod-estabel),"99999") at 1
            substr(trim(tt-estab-cc.cc-codigo),1,15)      at 6
            tt-estab-cc.descricao                         at 21
            "1"                                           at 71
            skip.

        disp c-arquivo
             tt-estab-cc.cod-estabel
             tt-estab-cc.cc-codigo
             tt-estab-cc.descricao
             with frame f-cc.
        down with frame f-cc.
    end. /* for each tt-estab-cc */

    output stream st-export close.

    if valid-handle(h-wprog)
    then run OpenDocument in h-wprog (input p-arquivo). 

    return "OK".
end procedure. /* procedure pi-cc */

procedure pi-estab-cc:
    for each tt-digita,
        each gm-estab use-index estab no-lock
       where gm-estab.cod-estabel = tt-digita.cod-estabel:
        for first grup-maquina fields(gm-codigo descricao log-1)
            where grup-maquina.gm-codigo = gm-estab.gm-codigo
                  no-lock: end.

        if not avail grup-maquina
        then next.

        assign i-cont = i-cont + 1.

        if  i-cont mod 50 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        if  tt-param.turnos
        and not grup-maquina.log-1
        and not can-find(first tt-estab-gm where
                               tt-estab-gm.cod-estabel = gm-estab.cod-estabel
                           and tt-estab-gm.gm-codigo   = gm-estab.gm-codigo)
        then do:
             create tt-estab-gm.
             assign tt-estab-gm.cod-estabel = gm-estab.cod-estabel
                    tt-estab-gm.gm-codigo   = gm-estab.gm-codigo.
             find current tt-estab-gm no-error.
        end. /* if  tt-param.turnos */

        if  tt-param.centros-custo
        and not can-find(first tt-estab-cc where
                               tt-estab-cc.cod-estabel = gm-estab.cod-estabel 
                           and tt-estab-cc.cc-codigo   = gm-estab.cc-codigo
                               no-lock)
        then do:
             for first centro-custo fields(descricao)
                 where centro-custo.cc-codigo = gm-estab.cc-codigo
                       no-lock: end.

             create tt-estab-cc.
             assign tt-estab-cc.cod-estabel = gm-estab.cod-estabel
                    tt-estab-cc.cc-codigo   = gm-estab.cc-codigo
                    tt-estab-cc.descricao   = centro-custo.descricao when avail centro-custo.
             find current tt-estab-cc no-error.
        end. /* if  tt-param.centros-custo */

        if  tt-param.postos-oper
        and not can-find(first tt-estab-gm-cc where
                               tt-estab-gm-cc.cod-estabel = gm-estab.cod-estabel
                           and tt-estab-gm-cc.gm-codigo   = gm-estab.gm-codigo
                           and tt-estab-gm-cc.cc-codigo   = gm-estab.cc-codigo)
        then do:
             create tt-estab-gm-cc.
             assign tt-estab-gm-cc.cod-estabel = gm-estab.cod-estabel
                    tt-estab-gm-cc.gm-codigo   = gm-estab.gm-codigo  
                    tt-estab-gm-cc.cc-codigo   = gm-estab.cc-codigo.
             find current tt-estab-gm-cc no-error.

             if not can-find(first tt-grup-maquina where 
                                   tt-grup-maquina.gm-codigo = gm-estab.gm-codigo)
             then do:
                  create tt-grup-maquina.
                  assign tt-grup-maquina.gm-codigo = grup-maquina.gm-codigo
                         tt-grup-maquina.descricao = trim(grup-maquina.descricao) when avail grup-maquina.

                  for each ctrab fields(cod-ctrab) use-index grp-maq no-lock
                     where ctrab.gm-codigo = grup-maquina.gm-codigo:
                      assign tt-grup-maquina.qt-ctrab = tt-grup-maquina.qt-ctrab + 1.
                  end. /* for each ctrab */

                  find current tt-grup-maquina no-error.
             end. /* if not can-find(first tt-grup-maquina */
        end. /* if  tt-param.postos-oper */
    end. /* for each tt-digita */

    return "OK".
end procedure. /* procedure pi-estab-cc */

procedure pi-despcc:
    def input param p-arquivo as char no-undo.

    def var c-period2 as char no-undo.

    assign i-cont = 0
           c-period2 = string(year(tt-param.dt-trans-ini),"9999")
                     + string(month(tt-param.dt-trans-ini),"99")
           c-arquivo = "UP_Despcc".

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Processando valores energia elÇtrica...").

    run pi-corrente.

    /* Energia ElÇtrica - ES0950 (FGL, APB e CEP) */
    run pi-custo (input 1,           /* 1 - Energia */
                  input "41520005"). /* Conta Cont†bil */

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Processando valores manutená∆o...").

    /* Manutená∆o - ES0950 (FGL, APB e CEP) */
    run pi-custo (input 2,   /* 2 - Manutená∆o */
                  input ""). /* Busca Contas Cont†beis dos ParÉmetros */

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Extraindo Custos por Centros de Custo...").

    output stream st-export to value(p-arquivo) convert target "iso8859-1".

    put unformatted skip(2) "LOGs UP_Despcc..." skip(1).

    for each ext-per-custo-estab no-lock
       where ext-per-custo-estab.periodo = c-period2:
        if  can-find(first tt-digita where
                           tt-digita.cod-estabel = ext-per-custo-estab.cod-estabel)
        and ext-per-custo-estab.mo-codigo    = 0
        and ext-per-custo-estab.horas-report > 0
        then.
        else next.

        assign i-cont        = i-cont + 1
               de-mob-dir    = 0
               de-gastos-dir = 0
               de-depr-dir   = 0
               de-mob-ind    = 0
               de-gastos-ind = 0
               de-depr-ind   = 0
               de-manutencao = 0
               de-energia    = 0
               de-despesa    = 0
               de-tot-ind    = 0.

        if  i-cont mod 50 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        for each tt-ocorrencia:
            case tt-ocorrencia.ocorrencia:
                when "MOB Dir"
                then assign de-mob-dir    = ext-per-custo-estab.custo-total[tt-ocorrencia.sequencia].
                when "Gastos Dir"            
                then assign de-gastos-dir = ext-per-custo-estab.custo-total[tt-ocorrencia.sequencia].
                when "Depr Dir"            
                then assign de-depr-dir   = ext-per-custo-estab.custo-total[tt-ocorrencia.sequencia].
                when "Mob Ind"            
                then assign de-mob-ind    = ext-per-custo-estab.custo-total[tt-ocorrencia.sequencia].
                when "Gastos Ind"
                then assign de-gastos-ind = ext-per-custo-estab.custo-total[tt-ocorrencia.sequencia].
                when "Depr Ind"
                then assign de-depr-ind   = ext-per-custo-estab.custo-total[tt-ocorrencia.sequencia].
            end case.
        end. /* for each tt-ocorrencia */

        assign de-tot-ind = de-mob-ind
                          + de-gastos-ind
                          + de-depr-ind
               de-despesa = de-mob-dir
                          + de-depr-dir
                          + de-gastos-dir
                          + de-tot-ind.

        for first tt-custo
            where tt-custo.cod-estabel = ext-per-custo-estab.cod-estabel
              and tt-custo.cod-ccusto  = ext-per-custo-estab.cc-codigo
              and tt-custo.tipo        = 1: /* Energia */
            assign de-energia = tt-custo.valor.
        end.

        for first int_param_est_ccusto_uep no-lock
            where int_param_est_ccusto_uep.cod_estab       = ext-per-custo-estab.cod-estabel
              and int_param_est_ccusto_uep.cod_ccusto_prod = ext-per-custo-estab.cc-codigo,
            first tt-custo
            where tt-custo.cod-estabel = int_param_est_ccusto_uep.cod_estab      
              and tt-custo.cod-ccusto  = int_param_est_ccusto_uep.cod_ccusto_orig
              and tt-custo.tipo        = 2: /* Manutená∆o */
            assign de-manutencao = tt-custo.valor * int_param_est_ccusto_uep.rateio / 100.

            for first tt-custo-aux 
                where tt-custo-aux.cod-estabel = tt-custo.cod-estabel
                  and tt-custo-aux.cod-ccusto  = tt-custo.cod-ccusto: end.

            if not avail tt-custo-aux
            then do:
                 create tt-custo-aux.
                 assign tt-custo-aux.cod-estabel = tt-custo.cod-estabel
                        tt-custo-aux.cod-ccusto  = tt-custo.cod-ccusto.
            end.

            assign tt-custo-aux.rateio = tt-custo-aux.rateio + int_param_est_ccusto_uep.rateio.

            if absolute(tt-custo-aux.rateio - 100) > 0.01
            then assign tt-custo-aux.consistente = no.
            else assign tt-custo-aux.consistente = yes.

            find current tt-custo-aux no-error.
        end. /* for first int_param_est_ccusto_uep */

        put stream st-export unformatted
            string(inte(ext-per-custo-estab.cod-estabel),"99999") at 1
            ext-per-custo-estab.cc-codigo                         at 6
            c-periodo                                             at 21
            string(de-despesa    * 1000000,"999999999999999")     at 27
            string(de-mob-dir    * 1000000,"999999999999999")     at 42
            string((de-tot-ind - de-manutencao) * 1000000,"999999999999999") at 57
            fill("0",15)                                          at 72
            string(de-depr-dir   * 1000000,"999999999999999")     at 87
            fill("0",15)                                          at 102
            fill("0",15)                                          at 117
            fill("0",15)                                          at 132
            string(de-manutencao * 1000000,"999999999999999")     at 147
            string((de-gastos-dir - de-energia) * 1000000,"999999999999999") at 162
            string(de-energia    * 1000000,"999999999999999")     at 177
            skip.

        disp c-arquivo
             ext-per-custo-estab.cod-estabel
             ext-per-custo-estab.cc-codigo
             c-period2 @ c-periodo
             de-mob-dir
             de-gastos-dir
             de-depr-dir
             de-mob-ind
             de-gastos-ind
             de-depr-ind
             de-despesa
             de-tot-ind
             de-manutencao
             de-energia
             with frame f-despcc.
        down with frame f-despcc.
    end. /* for each ext-per-custo-estab */

    if can-find(first tt-custo-aux use-index id2 where
                      tt-custo-aux.consistente = no)
    then put unformatted  skip(1)
             fill("-",5)
             "> ATENÄ«O!" skip
             "DE-PARA CONSTANTE DO ESCDP124 PODE N«O HAVER SIDO INTEGRALMENTE CONSIDERADO, CASUALMENTE LEVANDO A TOTAIS DE RATEIO INFERIORES A 100% QUANDO CONSIDERADOS SOMENTE OS CENTROS DE CUSTO AQUI PROCESSADOS"
             skip.

    output stream st-export close.

    if valid-handle(h-wprog)
    then run OpenDocument in h-wprog (input p-arquivo). 

    return "OK".
end procedure. /* procedure pi-despcc */

procedure pi-corrente:
    def var i-aux as inte no-undo.

    find first param-estoq no-lock no-error.
    find first param-cs    no-lock no-error.

/*     if not param-estoq.tem-moeda1 */
/*     then return "OK".             */

    do i-aux = 1 to 6:
        if param-cs.ocorrencia[i-aux] = ""
        then next.

        create tt-ocorrencia.
        assign tt-ocorrencia.ocorrencia = param-cs.ocorrencia[i-aux]
               tt-ocorrencia.sequencia  = i-aux.
    end. /* do i-aux = 1 to 6 */
    find current tt-ocorrencia no-error.

    return "OK".
end procedure. /* procedure pi-corrente */

procedure pi-custo:
    def input parameter p-tipo         as inte no-undo. /* 1 - Energia; 2 - Manutená∆o */
    def input parameter p-cod-cta-ctbl as char no-undo.

    def var c-plano-cta        as char init "PADRAO" no-undo.
    def var c-cod-cta-ctbl-ini as char               no-undo.
    def var c-cod-cta-ctbl-fim as char               no-undo.
    def var i-fator            as inte               no-undo.
    def var de-vl-movto        as deci               no-undo.

    assign c-cod-cta-ctbl-ini = p-cod-cta-ctbl
           c-cod-cta-ctbl-fim = p-cod-cta-ctbl.

    do dt-aux = tt-param.dt-trans-ini to tt-param.dt-trans-fim:
        if valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input string(dt-aux,"99/99/9999")).

        for each tt-digita,
           first estabelecimento fields(cod_estab cod_empresa) no-lock
           where estabelecimento.cod_estab = tt-digita.cod-estabel:
            for first int_param_est_uep 
                where int_param_est_uep.cod_estab = estabelecimento.cod_estab
                      no-lock: end.

            if p-tipo = 2 /* Manutená∆o; busca intervalo dos parÉmetros UEP */
            then do:
                 if not can-find(first int_param_est_ccusto_uep where
                                       int_param_est_ccusto_uep.cod_estab = int_param_est_uep.cod_estab
                                       no-lock)
                 then next.

                 assign c-plano-cta        = int_param_est_uep.cod_plano_cta_ctbl
                        c-cod-cta-ctbl-ini = int_param_est_uep.cod_cta_ctbl_ini
                        c-cod-cta-ctbl-fim = int_param_est_uep.cod_cta_ctbl_fim.
            end. /* if p-tipo = 2 */

            /* Movimentos Contabilidade - FGL */
            for each item_lancto_ctbl use-index tmlnctcb_estab no-lock
               where item_lancto_ctbl.cod_estab        = estabelecimento.cod_estab
                 and item_lancto_ctbl.cod_plano_cta    = c-plano-cta
                 and item_lancto_ctbl.cod_cta_ctbl    >= c-cod-cta-ctbl-ini
                 and item_lancto_ctbl.cod_cta_ctbl    <= c-cod-cta-ctbl-fim
                 and item_lancto_ctbl.dat_lancto_ctbl  = dt-aux
                 and item_lancto_ctbl.cod_empresa      = estabelecimento.cod_empresa,
               first lancto_ctbl fields(num_lote_ctbl num_lancto_ctbl cod_modul_dtsul) no-lock
               where lancto_ctbl.num_lote_ctbl    = item_lancto_ctbl.num_lote_ctbl
                 and lancto_ctbl.num_lancto_ctbl  = item_lancto_ctbl.num_lancto_ctbl
                 and lancto_ctbl.cod_modul_dtsul <> "ACR"
                 and lancto_ctbl.cod_modul_dtsul <> "APB"
                 and lancto_ctbl.cod_modul_dtsul <> "CMG"
                 and lancto_ctbl.cod_modul_dtsul <> "CEP"
                 and lancto_ctbl.cod_modul_dtsul <> "APL"
                 and lancto_ctbl.cod_modul_dtsul <> "FTP"
                 and lancto_ctbl.cod_modul_dtsul <> "FAS":        
                assign i-cont  = i-cont + 1
                       i-fator = 1.
        
                if  i-cont mod 50 = 0
                and valid-handle(h-acomp)
                then run pi-acompanhar in h-acomp (input i-cont).
                
                if  item_lancto_ctbl.cod_cenar_ctbl <> ""
                and item_lancto_ctbl.cod_cenar_ctbl <> "FISCAL"
                then next.

                case p-tipo:
                    when 1 /* Energia */
                    then if  item_lancto_ctbl.cod_plano_ccusto = int_param_uep.cod_plano_ccusto
                         and item_lancto_ctbl.cod_ccusto      >= int_param_uep.cod_ccusto_ini
                         and item_lancto_ctbl.cod_ccusto      <= int_param_uep.cod_ccusto_fim
                         then.
                         else next.
                    when 2 /* Manutená∆o */
                    then if  item_lancto_ctbl.cod_plano_ccusto = int_param_est_uep.cod_plano_ccusto
                         and can-find (first int_param_est_ccusto_uep use-index ch-orig where
                                             int_param_est_ccusto_uep.cod_estab       = item_lancto_ctbl.cod_estab
                                         and int_param_est_ccusto_uep.cod_ccusto_orig = item_lancto_ctbl.cod_ccusto
                                             no-lock)
                         then.
                         else next.
                    otherwise next.
                end case. /* case p-tipo */
        
                if item_lancto_ctbl.ind_natur_lancto_ctbl = "CR"
                then assign i-fator = -1.
            
                for first tt-custo 
                    where tt-custo.cod-estabel = estabelecimento.cod_estab
                      and tt-custo.cod-ccusto  = item_lancto_ctbl.cod_ccusto
                      and tt-custo.tipo        = p-tipo: end.

                if not avail tt-custo
                then do:
                     create tt-custo.
                     assign tt-custo.cod-estabel = estabelecimento.cod_estab
                            tt-custo.cod-ccusto  = item_lancto_ctbl.cod_ccusto
                            tt-custo.tipo        = p-tipo.
                end.
            
                if item_lancto_ctbl.cod_indic_econ = "Real"
                then assign tt-custo.valor = tt-custo.valor + (item_lancto_ctbl.val_lancto_ctbl * i-fator).
                else do:
                     for first aprop_lancto_ctbl
                         where aprop_lancto_ctbl.num_lote_ctbl       = lancto_ctbl.num_lote_ctbl
                           and aprop_lancto_ctbl.num_lancto_ctbl     = lancto_ctbl.num_lancto_ctbl
                           and aprop_lancto_ctbl.num_seq_lancto_ctbl = item_lancto_ctbl.num_seq_lancto_ctbl
                           and aprop_lancto_ctbl.cod_finalid_econ    = "corrente"
                               no-lock: end.
            
                     assign tt-custo.valor = tt-custo.valor + (aprop_lancto_ctbl.val_lancto_ctbl * i-fator).
                end. /* else do */
            end. /* for each item_lancto_ctbl */
        
            /* Movimentos Contas a Pagar - APB */
            for each aprop_ctbl_ap fields(cod_estab
                                          num_id_movto_tit_ap
                                          cod_plano_cta_ctbl
                                          cod_cta_ctbl
                                          dat_transacao
                                          cod_plano_ccusto
                                          cod_ccusto
                                          val_aprop_ctbl
                                          ind_natur_lancto_ctbl) use-index aprpctbl_estab_cta_ctbl_data
               where aprop_ctbl_ap.cod_estab          = estabelecimento.cod_estab
                 and aprop_ctbl_ap.cod_plano_cta_ctbl = c-plano-cta
                 and aprop_ctbl_ap.cod_cta_ctbl      >= c-cod-cta-ctbl-ini
                 and aprop_ctbl_ap.cod_cta_ctbl      <= c-cod-cta-ctbl-fim
                 and aprop_ctbl_ap.dat_transacao      = dt-aux
                     no-lock:

                if not can-find(first movto_tit_ap where
                                      movto_tit_ap.cod_estab           = estabelecimento.cod_estab
                                  and movto_tit_ap.num_id_movto_tit_ap = aprop_ctbl_ap.num_id_movto_tit_ap
                                  and movto_tit_ap.log_ctbz_aprop_ctbl
                                      no-lock)
                then next.

                case p-tipo:
                    when 1 /* Energia */
                    then if  aprop_ctbl_ap.cod_plano_ccusto = int_param_uep.cod_plano_ccusto
                         and aprop_ctbl_ap.cod_ccusto      >= int_param_uep.cod_ccusto_ini
                         and aprop_ctbl_ap.cod_ccusto      <= int_param_uep.cod_ccusto_fim
                         then.
                         else next.
                    when 2 /* Manutená∆o */
                    then if  aprop_ctbl_ap.cod_plano_ccusto = int_param_est_uep.cod_plano_ccusto
                         and can-find (first int_param_est_ccusto_uep use-index ch-orig where
                                             int_param_est_ccusto_uep.cod_estab       = aprop_ctbl_ap.cod_estab
                                         and int_param_est_ccusto_uep.cod_ccusto_orig = aprop_ctbl_ap.cod_ccusto
                                             no-lock)
                         then.
                         else next.
                    otherwise next.
                end case. /* case p-tipo */

                assign i-cont  = i-cont + 1
                       i-fator = 1.

                if aprop_ctbl_ap.ind_natur_lancto_ctbl = "CR"
                then assign i-fator = -1.

                if  i-cont mod 40 = 0
                and valid-handle(h-acomp)
                then run pi-acompanhar in h-acomp (input i-cont).

                for first tt-custo 
                    where tt-custo.cod-estabel = estabelecimento.cod_estab
                      and tt-custo.cod-ccusto  = aprop_ctbl_ap.cod_ccusto
                      and tt-custo.tipo        = p-tipo: end.

                if not avail tt-custo
                then do:
                     create tt-custo.
                     assign tt-custo.cod-estabel = estabelecimento.cod_estab
                            tt-custo.cod-ccusto  = aprop_ctbl_ap.cod_ccusto
                            tt-custo.tipo        = p-tipo.
                end.

                assign tt-custo.valor = tt-custo.valor + (aprop_ctbl_ap.val_aprop_ctbl * i-fator).
            end. /* for each aprop_ctbl_ap */

            /* Movimentos Estoque = CEP */
            for each movto-estoq use-index data-conta no-lock
               where movto-estoq.dt-trans    = dt-aux
                 and movto-estoq.ct-codigo  >= c-cod-cta-ctbl-ini
                 and movto-estoq.ct-codigo  <= c-cod-cta-ctbl-fim
                 and movto-estoq.cod-estabel = estabelecimento.cod_estab
                 and movto-estoq.esp-docto  <> 33:
                case p-tipo:
                    when 1 /* Energia */
                    then if  movto-estoq.sc-codigo >= int_param_uep.cod_ccusto_ini
                         and movto-estoq.sc-codigo <= int_param_uep.cod_ccusto_fim
                         then.
                         else next.
                    when 2 /* Manutená∆o */
                    then if not can-find (first int_param_est_ccusto_uep use-index ch-orig where
                                                int_param_est_ccusto_uep.cod_estab       = movto-estoq.cod-estabel
                                            and int_param_est_ccusto_uep.cod_ccusto_orig = movto-estoq.sc-codigo
                                                no-lock)
                         then next.
                    otherwise next.
                end case. /* case p-tipo */

                assign i-cont  = i-cont + 1
                       i-fator = 1.

                if movto-estoq.tipo-trans = 1
                then assign i-fator = -1.

                if  i-cont mod 40 = 0
                and valid-handle(h-acomp)
                then run pi-acompanhar in h-acomp (input i-cont).

                if movto-estoq.valor-nota > 0
                then assign de-vl-movto = movto-estoq.valor-nota.
                else assign de-vl-movto = movto-estoq.valor-mat-m[1]
                                        + movto-estoq.valor-mob-m[1]
                                        + movto-estoq.valor-ggf-m[1].

                for first tt-custo 
                    where tt-custo.cod-estabel = estabelecimento.cod_estab
                      and tt-custo.cod-ccusto  = movto-estoq.sc-codigo
                      and tt-custo.tipo        = p-tipo: end.

                if not avail tt-custo
                then do:
                     create tt-custo.
                     assign tt-custo.cod-estabel = estabelecimento.cod_estab
                            tt-custo.cod-ccusto  = movto-estoq.sc-codigo
                            tt-custo.tipo        = p-tipo.
                end.

                assign tt-custo.valor = tt-custo.valor + (de-vl-movto * i-fator).
            end. /* for each movto-estoq */
        end. /* for each tt-digita */
    end. /* do dt-aux = tt-param.dt-trans-ini to tt-param.dt-trans-fim */

    find current tt-custo no-error.

    return "OK".
end procedure. /* procedure pi-custo */

procedure pi-po:
    def input param p-arquivo as char no-undo.

    def var c-cod-estabel like estabelec.cod-estabel no-undo.
    def var c-gm-cod-aux  as char                    no-undo.
    def var c-descricao   as char                    no-undo.
    def var c-cc-codigo   as char                    no-undo.
    def var c-qt-ctrab    as char                    no-undo.
    def var i-qt-ctrab    as inte                    no-undo.

    assign i-cont    = 0
           c-arquivo = "UP_PO".

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Extraindo POs...").

    if not temp-table tt-estab-gm-cc:has-records 
    then run pi-estab-cc.

    output stream st-export to value(p-arquivo) convert target "iso8859-1".

    if temp-table tt-estab-gm-cc:has-records
    then put unformatted skip(2) "LOGs UP_PO..." skip(1).

    for each tt-estab-gm-cc,
       first tt-grup-maquina
       where tt-grup-maquina.gm-codigo = tt-estab-gm-cc.gm-codigo
        /*and tt-grup-maquina.qt-ctrab  > 0*/ :
        assign i-cont        = i-cont + 1
               c-cod-estabel = string(inte(tt-estab-gm-cc.cod-estabel),"99999")
               c-gm-cod-aux  = tt-estab-gm-cc.gm-codigo
               c-descricao   = tt-grup-maquina.descricao  
               c-cc-codigo   = tt-estab-gm-cc.cc-codigo
               c-desativa    = "N"
               c-extensao    = ""
               i-qt-ctrab    = tt-grup-maquina.qt-ctrab.

        if i-qt-ctrab = 0
        then assign i-qt-ctrab = 1
                    c-desativa = "S".

        assign c-qt-ctrab = string(i-qt-ctrab,"999999999999999").

        if  i-cont mod 50 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        {esp/csp/escsp015rp.i1}
    end. /* for each tt-estab-gm-cc */

    for each ferr-prod fields(cod-ferr-prod des-ferr-prod int-2) no-lock
       where ferr-prod.char-1 = "Ferramenta":
        assign i-cont       = i-cont + 1
               c-gm-cod-aux = ferr-prod.cod-ferr-prod
               c-descricao  = ferr-prod.des-ferr-prod
               c-desativa   = "N"
               i-qt-ctrab   = ferr-prod.int-2
               c-qt-ctrab   = string(i-qt-ctrab,"999999999999999").
        
        if  i-cont mod 15 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        release bem_pat.

        for first int_bem_pat use-index ch-equipto 
            where int_bem_pat.equipamento = ferr-prod.cod-ferr-prod
              and int_bem_pat.molde
                  no-lock: end.

        if avail int_bem_pat
        then for first bem_pat use-index bempat_seq
                 where bem_pat.num_id_bem_pat = int_bem_pat.num_id_bem_pat
                       no-lock: end.

        for each tt-digita:
            assign c-cod-estabel = string(inte(tt-digita.cod-estabel),"99999")
                   c-cc-codigo   = "99999"
                   c-extensao    = string(avail int_bem_pat,"Sim/N∆o").
    
            if avail bem_pat
            then do:
                 if bem_pat.cod_estab <> tt-digita.cod-estabel
                 then next.

                 for first aloc_bem
                     where aloc_bem.num_id_bem_pat   = int_bem_pat.num_id_bem_pat
                       and aloc_bem.cod_empresa      = int_bem_pat.cod_empresa
                       and aloc_bem.cod_plano_ccusto = int_param_uep.cod_plano_ccusto
                       and aloc_bem.cod_ccusto      >= int_param_uep.cod_ccusto_ini
                       and aloc_bem.cod_ccusto      <= int_param_uep.cod_ccusto_fim
                           no-lock: end.
                
                 if avail aloc_bem
                 then assign c-cc-codigo = aloc_bem.cod_ccusto.
                 else if not can-find (first aloc_bem where
                                             aloc_bem.num_id_bem_pat = int_bem_pat.num_id_bem_pat
                                             no-lock)
                      and bem_pat.cod_plano_ccusto    = int_param_uep.cod_plano_ccusto
                      and bem_pat.cod_ccusto_respons >= int_param_uep.cod_ccusto_ini
                      and bem_pat.cod_ccusto_respons <= int_param_uep.cod_ccusto_fim
                      then assign c-cc-codigo = bem_pat.cod_ccusto_respons.
            end. /* if  avail int_bem_pat */

           {esp/csp/escsp015rp.i1}
        end. /* for each tt-digita */
    end. /* for each ferr-prod */

    output stream st-export close.

    if valid-handle(h-wprog)
    then run OpenDocument in h-wprog (input p-arquivo). 

    return "OK".
end procedure. /* procedure pi-po */

procedure pi-equiptos:
    def input param p-arquivo-1 as char no-undo.
    def input param p-arquivo-2 as char no-undo.

    def var lg-erro as logi no-undo.
   //def var i-dias  as inte no-undo.

    assign i-cont    = 0
           c-arquivo = "UP_Equipamentos"
          //i-dias    = tt-param.dt-trans-fim - tt-param.dt-trans-ini + 1
        .

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Selecionando Bens...").

    output stream st-export  to value(p-arquivo-1) convert target "iso8859-1".
    output stream st-export2 to value(p-arquivo-2) convert target "iso8859-1".

    put unformatted skip(2) "LOGs UP_Equipamentos..." skip(1).

    for each tt-digita,
        each bem_pat use-index bempat_estab no-lock
       where bem_pat.cod_estab = tt-digita.cod-estabel,
       first int_param_cta_uep no-lock
       where int_param_cta_uep.cod_empresa = bem_pat.cod_empresa
         and int_param_cta_uep.cod_cta_pat = bem_pat.cod_cta_pat:
        assign i-cont = i-cont + 1.

        if  i-cont mod 25 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        run pi-cria-bem (input no).
    end. /* for each tt-digita */
    find current tt_bem_pat no-error.

    if valid-handle(h-wprog)
    then run pi-seta-titulo in h-acomp (input "Calculando vl deprec...").

    run pi-depreciacao (input "41690005",
                        input "41690020").

    if valid-handle(h-acomp)
    then run pi-seta-titulo in h-acomp (input "Extraindo Equipamentos...").

    for each tt_bem_pat:
        assign i-cont  = i-cont + 1
               lg-erro = no.

        if  i-cont mod 50 = 0
        and valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input i-cont).

        find b_tt_bem_pat where
             b_tt_bem_pat.cod_estab       = tt_bem_pat.cod_estab
         and b_tt_bem_pat.num_bem_pat     = tt_bem_pat.num_bem_pat
         and b_tt_bem_pat.num_seq_bem_pat = tt_bem_pat.num_seq_bem_pat
             no-error.

        if not avail b_tt_bem_pat
        then do:
             assign tt_bem_pat.lg_inconsis = yes.

             if tt_bem_pat.mensagem = ""
             then assign tt_bem_pat.mensagem = "duplicado".
        end.

        if tt_bem_pat.mensagem <> ""
        then assign tt_bem_pat.mensagem = "Erro Bem Pat: " + tt_bem_pat.mensagem.
        else if tt_bem_pat.vl_deprec < 0
             then assign tt_bem_pat.mensagem = "Valor negativo".

        disp c-arquivo
             tt_bem_pat.cod_cta_pat    
             tt_bem_pat.num_bem_pat    
             tt_bem_pat.num_seq_bem_pat
             tt_bem_pat.des_bem_pat    
             tt_bem_pat.cod_estab
             tt_bem_pat.potencia
             tt_bem_pat.hr_manut
             tt_bem_pat.molde
             tt_bem_pat.equipamento
             tt_bem_pat.nr_pos
             tt_bem_pat.vl_deprec
             tt_bem_pat.mensagem
             tt_bem_pat.lg_inconsis
             with frame f-equipto.
        down with frame f-equipto.

        if tt_bem_pat.lg_inconsis
        then next.

        if tt_bem_pat.vl_deprec < 0
        then assign tt_bem_pat.vl_deprec = 0.

        put stream st-export unformatted
            string(inte(tt_bem_pat.cod_estab),"99999")              at 1
            string(tt_bem_pat.num_bem_pat,"999999") + "-" + string(tt_bem_pat.num_seq_bem_pat,"999") at 6
            tt_bem_pat.des_bem_pat                                  at 16
            string(tt_bem_pat.potencia * 1000000,"999999999999999") at 96
            string(tt_bem_pat.hr_manut * 1000000,"999999999999999") at 111
            fill("0",15)                                            at 126
            fill("0",15)                                            at 141
            fill("0",15)                                            at 156
            string(tt_bem_pat.vl_deprec * 12 * 1000000,"999999999999999")                            at 171 /* x 12 meses */
            "000000001000000"                                       at 186
            string(tt_bem_pat.potencia * 1000000,"999999999999999") at 201
            "000000001000000"                                       at 216
            skip.

        if not can-find(first tt_int_bem_pat_gm where
                              tt_int_bem_pat_gm.num_id_bem_pat = tt_bem_pat.num_id_bem_pat)
        then do:
             put stream st-export2 unformatted
                 string(inte(tt_bem_pat.cod_estab),"99999") at 1
                 tt_bem_pat.equipamento                     at 6
                 string(tt_bem_pat.num_bem_pat,"999999") + "-" + string(tt_bem_pat.num_seq_bem_pat,"999") at 16
                 string(100000000,"999999999999999")        at 26
                 fill("0",15)                               at 41
                 skip.

             next.
        end.

        for each tt_int_bem_pat_gm
           where tt_int_bem_pat_gm.num_id_bem_pat = tt_bem_pat.num_id_bem_pat:
            put stream st-export2 unformatted
                string(inte(tt_bem_pat.cod_estab),"99999") at 1
                tt_int_bem_pat_gm.gm-codigo                at 6
                string(tt_bem_pat.num_bem_pat,"999999") + "-" + string(tt_bem_pat.num_seq_bem_pat,"999") at 16.
    
            if tt_bem_pat.nr_pos > 0
            then put stream st-export2 unformatted
                     string(100 / tt_bem_pat.nr_pos * 1000000,"999999999999999") at 26.
            else put stream st-export2 unformatted
                     fill("0",15)                                                at 26.
    
            put stream st-export2 unformatted
                fill("0",15) at 41
                skip.
        end. /* for each tt_int_bem_pat_gm */                                                               
    end. /* for each tt_bem_pat */

    output stream st-export2 close.
    output stream st-export  close.

    if valid-handle(h-wprog)
    then do:
         run OpenDocument in h-wprog (input p-arquivo-1). 
         run OpenDocument in h-wprog (input p-arquivo-2). 
    end.

    return "OK".
end procedure. /* procedure pi-equiptos */

procedure pi-cria-bem:
    def input param p-inconsis as logi no-undo.

    if can-find(first aloc_bem where
                      aloc_bem.num_id_bem_pat   = bem_pat.num_id_bem_pat
                  and aloc_bem.cod_empresa      = bem_pat.cod_empresa
                  and aloc_bem.cod_plano_ccusto = int_param_uep.cod_plano_ccusto
                  and aloc_bem.cod_ccusto      >= int_param_uep.cod_ccusto_ini
                  and aloc_bem.cod_ccusto      <= int_param_uep.cod_ccusto_fim
                      no-lock)
    or (not can-find (first aloc_bem where
                            aloc_bem.num_id_bem_pat = bem_pat.num_id_bem_pat
                            no-lock)
    and bem_pat.cod_plano_ccusto    = int_param_uep.cod_plano_ccusto
    and bem_pat.cod_ccusto_respons >= int_param_uep.cod_ccusto_ini
    and bem_pat.cod_ccusto_respons <= int_param_uep.cod_ccusto_fim)
    then.
    else return "NOK".

    for first int_bem_pat
        where int_bem_pat.cod_empresa     = bem_pat.cod_empresa
          and int_bem_pat.cod_cta_pat     = bem_pat.cod_cta_pat
          and int_bem_pat.num_bem_pat     = bem_pat.num_bem_pat
          and int_bem_pat.num_seq_bem_pat = bem_pat.num_seq_bem_pat
              no-lock: end.

    if  not p-inconsis
    and bem_pat.val_perc_bxa >= 100
    and not avail int_bem_pat
    then return "NOK".

    create tt_bem_pat.
    assign tt_bem_pat.cod_estab       = bem_pat.cod_estab
           tt_bem_pat.num_bem_pat     = bem_pat.num_bem_pat
           tt_bem_pat.num_seq_bem_pat = bem_pat.num_seq_bem_pat
           tt_bem_pat.num_id_bem_pat  = bem_pat.num_id_bem_pat
           tt_bem_pat.des_bem_pat     = bem_pat.des_bem_pat
           tt_bem_pat.cod_cta_pat     = bem_pat.cod_cta_pat
           tt_bem_pat.cod_empresa     = bem_pat.cod_empresa
           tt_bem_pat.des_bem_pat     = bem_pat.des_bem_pat
           tt_bem_pat.lg_inconsis     = yes.

    if  avail int_bem_pat
    and int_bem_pat.num_id_bem_pat = bem_pat.num_id_bem_pat
    then.
    else do:
         assign tt_bem_pat.mensagem = "Sem extens∆o".
         return "NOK".
    end.

    assign tt_bem_pat.potencia    = int_bem_pat.potencia
           tt_bem_pat.hr_manut    = int_bem_pat.hr_manut
           tt_bem_pat.molde       = int_bem_pat.molde
           tt_bem_pat.equipamento = int_bem_pat.equipamento.

    if int_bem_pat.molde
    then if can-find(first int_bem_pat_gm where
                           int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat
                           no-lock)
         then do:
              assign tt_bem_pat.mensagem = "Extens∆o com Molde e Gr Maq".
              return "NOK".
         end.
         else if  int_bem_pat.equipamento         <> ""
              and length(int_bem_pat.equipamento) <= 10
              and can-find(first ferr-prod where
                                 ferr-prod.cod-ferr-prod = int_bem_pat.equipamento
                             and ferr-prod.char-1        = "Ferramenta"
                                 no-lock)
              then.
              else do:
                   assign tt_bem_pat.mensagem = "Extens∆o com Molde, mas sem Equipamento v†lido".
                   return "NOK".
              end.
    else if not can-find(first int_bem_pat_gm where
                               int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat
                               no-lock) 
         then do:
              assign tt_bem_pat.mensagem = "Extens∆o sem Molde e sem Gr Maq".
              return "NOK".
         end.

    if not p-inconsis
    then assign tt_bem_pat.lg_inconsis = no.
    else do:
         assign tt_bem_pat.mensagem = "Vl Deprec sem Bem previamente carregado".
         return "NOK".
    end.
        
    for each int_bem_pat_gm no-lock
       where int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat:
        for first gm-estab
            where gm-estab.gm-codigo   = int_bem_pat_gm.gm-codigo
              and gm-estab.cod-estabel = bem_pat.cod_estab
                  no-lock: end.
    
        if  avail gm-estab
        and gm-estab.cc-codigo >= int_param_uep.cod_ccusto_ini
        and gm-estab.cc-codigo <= int_param_uep.cod_ccusto_fim
        then.
        else do:
             assign tt_bem_pat.lg_inconsis = yes
                    tt_bem_pat.mensagem    = "GM x Estab inv†lido".
             return "NOK".
        end.
    
        if can-find(first aloc_bem where
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
             assign tt_bem_pat.lg_inconsis = yes
                    tt_bem_pat.mensagem    = "GM x Estab desvinculado ao Bem".
             return "NOK".
        end.
    
        assign tt_bem_pat.nr_pos = tt_bem_pat.nr_pos + 1.
    
        create tt_int_bem_pat_gm.
        buffer-copy int_bem_pat_gm to tt_int_bem_pat_gm.
        find current tt_int_bem_pat_gm no-error.
    end. /* for each int_bem_pat_gm */

    return "OK".
end procedure. /* procedure pi-cria-bem */

procedure pi-depreciacao:
    def input param p-cod-cta-ctbl-ini as char no-undo.
    def input param p-cod-cta-ctbl-fim as char no-undo.

    def var c_cod_plano_cta_ctbl as char init "PADRAO" no-undo.

    do dt-aux = tt-param.dt-trans-ini to tt-param.dt-trans-fim:
        if valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input string(dt-aux,"99/99/9999")).

        /* FAS - Ativo Fixo */
        for each reg_calc_bem_pat no-lock
           where reg_calc_bem_pat.cod_tip_calc     = "Deprec"
             and reg_calc_bem_pat.cod_cenar_ctbl   = "IFRS"
             and reg_calc_bem_pat.cod_finalid_econ = "Corrente"
             and reg_calc_bem_pat.dat_calc_pat     = dt-aux:
            find bem_pat of reg_calc_bem_pat no-lock no-error.

            if  can-find(first tt-digita where
                               tt-digita.cod-estabel = bem_pat.cod_estab)
            and can-find(first int_param_cta_uep where
                               int_param_cta_uep.cod_empresa = bem_pat.cod_empresa
                           and int_param_cta_uep.cod_cta_pat = bem_pat.cod_cta_pat
                               no-lock)
            then.
            else next.

            for first tt_bem_pat use-index id2
                where tt_bem_pat.cod_empresa     = bem_pat.cod_empresa
                  and tt_bem_pat.cod_cta_pat     = bem_pat.cod_cta_pat
                  and tt_bem_pat.num_bem_pat     = bem_pat.num_bem_pat
                  and tt_bem_pat.num_seq_bem_pat = bem_pat.num_seq_bem_pat: end.            

            for each aprop_ctbl_pat no-lock
               where aprop_ctbl_pat.num_seq_reg_calc_bem_pat = reg_calc_bem_pat.num_seq_reg_calc_bem_pat:
                if  aprop_ctbl_pat.cod_plano_cta_ctbl_db = c_cod_plano_cta_ctbl
                and aprop_ctbl_pat.cod_cta_ctbl_db      >= p-cod-cta-ctbl-ini
                and aprop_ctbl_pat.cod_cta_ctbl_db      <= p-cod-cta-ctbl-fim
                and aprop_ctbl_pat.cod_plano_ccusto_db   = int_param_uep.cod_plano_ccusto
                and aprop_ctbl_pat.cod_ccusto_db        >= int_param_uep.cod_ccusto_ini
                and aprop_ctbl_pat.cod_ccusto_db        <= int_param_uep.cod_ccusto_fim
                then do:
                     if not avail tt_bem_pat
                     then run pi-cria-bem (input yes).                          

                     if avail tt_bem_pat
                     then assign tt_bem_pat.vl_deprec = tt_bem_pat.vl_deprec + aprop_ctbl_pat.val_lancto_ctbl.
                     else leave.
                end.

                if  aprop_ctbl_pat.cod_plano_cta_ctbl_cr = c_cod_plano_cta_ctbl
                and aprop_ctbl_pat.cod_cta_ctbl_cr      >= p-cod-cta-ctbl-ini
                and aprop_ctbl_pat.cod_cta_ctbl_cr      <= p-cod-cta-ctbl-fim
                and aprop_ctbl_pat.cod_plano_ccusto_cr   = int_param_uep.cod_plano_ccusto
                and aprop_ctbl_pat.cod_ccusto_cr        >= int_param_uep.cod_ccusto_ini
                and aprop_ctbl_pat.cod_ccusto_cr        <= int_param_uep.cod_ccusto_fim
                then do:
                     if not avail tt_bem_pat
                     then run pi-cria-bem (input yes).

                     if avail tt_bem_pat
                     then assign tt_bem_pat.vl_deprec = tt_bem_pat.vl_deprec - aprop_ctbl_pat.val_lancto_ctbl.
                     else leave.
                end.
            end. /* for each aprop_ctbl_pat */
        end. /* for each reg_calc_bem_pat */

        if dt-aux <> tt-param.dt-trans-fim
        then next.

        for each calc_parc_pis_cofins use-index clcprcps_period no-lock
           where calc_parc_pis_cofins.cod_exerc_ctbl   = string(year(dt-aux))
              AND calc_parc_pis_cofins.num_period_ctbl = month(dt-aux)
              AND calc_parc_pis_cofins.cod_empresa     = v_cod_empres_usuar:
            find bem_pat of calc_parc_pis_cofins no-lock no-error.

            if  can-find(first tt-digita where
                               tt-digita.cod-estabel = bem_pat.cod_estab)
            and can-find(first int_param_cta_uep where
                               int_param_cta_uep.cod_empresa = bem_pat.cod_empresa
                           and int_param_cta_uep.cod_cta_pat = bem_pat.cod_cta_pat
                               no-lock)
            then.
            else next.

            for first tt_bem_pat use-index id2
                where tt_bem_pat.cod_empresa     = bem_pat.cod_empresa
                  and tt_bem_pat.cod_cta_pat     = bem_pat.cod_cta_pat
                  and tt_bem_pat.num_bem_pat     = bem_pat.num_bem_pat
                  and tt_bem_pat.num_seq_bem_pat = bem_pat.num_seq_bem_pat: end.

            for each aprop_parc_pis_cofins no-lock
               where aprop_parc_pis_cofins.num_id_calc_parc = calc_parc_pis_cofins.num_id_calc_parc
                 and aprop_parc_pis_cofins.cod_cenar_ctbl   = "IFRS"
                 and aprop_parc_pis_cofins.cod_finalid_econ = "corrente":
                if  aprop_parc_pis_cofins.cod_plano_ccusto   = int_param_uep.cod_plano_ccusto
                and aprop_parc_pis_cofins.cod_ccusto        >= int_param_uep.cod_ccusto_ini
                and aprop_parc_pis_cofins.cod_ccusto        <= int_param_uep.cod_ccusto_fim
                and aprop_parc_pis_cofins.cod_plano_cta_ctbl = c_cod_plano_cta_ctbl
                then.
                else next.

                if  aprop_parc_pis_cofins.cod_cta_ctbl_db >= p-cod-cta-ctbl-ini
                and aprop_parc_pis_cofins.cod_cta_ctbl_db <= p-cod-cta-ctbl-fim
                then do:
                     if not avail tt_bem_pat
                     then run pi-cria-bem (input yes).

                     if avail tt_bem_pat
                     then assign tt_bem_pat.vl_deprec = tt_bem_pat.vl_deprec + aprop_parc_pis_cofins.val_aprop_ctbl.
                     else leave.
                end.

                if  aprop_parc_pis_cofins.cod_cta_ctbl_cr >= p-cod-cta-ctbl-ini
                and aprop_parc_pis_cofins.cod_cta_ctbl_cr <= p-cod-cta-ctbl-fim
                then do:
                     if not avail tt_bem_pat
                     then run pi-cria-bem (input yes).

                     if avail tt_bem_pat
                     then assign tt_bem_pat.vl_deprec = tt_bem_pat.vl_deprec - aprop_parc_pis_cofins.val_aprop_ctbl.
                     else leave.
                end.
            end. /* for each aprop_parc_pis */        
        end. /* for each calc_parc_pis_cofins */
    end. /* do dt-aux = tt-param.dt-trans-ini to tt-param.dt-trans-fim */

    return "OK".
end procedure. /* procedure pi-depreciacao */

