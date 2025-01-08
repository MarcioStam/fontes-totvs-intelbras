/********************************************************************************
*      Programa .....: escdp125rp.p                                             *
*      Data .........: 09 de fevereiro de 2023                                  *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur¡cio C.                                              *
*      Objetivo .....: Relat¢rio Gr Maq Patrim“nio x UEP                        *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL   MOTIVO                            *
*      2.12.00.000  09/02/2023  Mauricio C.   Desenvolvimento                   *
********************************************************************************/
function fn-get-dir returns character (input p-file as character) forward.
{include/i-prgvrs.i escdp125rp 2.12.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escdp125rp ESP}
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
    field execucao         as inte
    field dat_aquis_ini    as date
    field dat_aquis_fim    as date
    field cod_cta_ini      as char
    field cod_cta_fim      as char
    field num_bem_ini      as inte
    field num_bem_fim      as inte
    field num_seq_bem_ini  as inte
    field num_seq_bem_fim  as inte
    field gm-codigo-ini    as char
    field gm-codigo-fim    as char
    field cod_estab_ini    as char
    field cod_estab_fim    as char
    field cod_ccusto_ini   as char
    field cod_ccusto_fim   as char
    field cod_plano_ccusto as char.

define temp-table tt-digita no-undo
    field gm-codigo as char
    field descricao as char
    index id is primary gm-codigo.

define temp-table tt-raw-digita
    field raw-digita    as raw.

define temp-table tt_int_bem_pat no-undo
    field num_bem_pat       as inte
    field num_seq_bem_pat   as inte
    field cod_cta_pat       as char
    field des_bem_pat       as char
    field cod_estab         as char
    field dat_aquis_bem_pat as date
    field gm-codigo         as char
    field descricao         as char
    index id is primary gm-codigo
                        num_bem_pat
                        num_seq_bem_pat
                        cod_cta_pat
    index id2 num_bem_pat
              num_seq_bem_pat
              cod_cta_pat
              gm-codigo.

{esp/es0018.i}

/*  Recebimento de parametros --- */
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

/***** VARIµVEIS *****/
{include/i-rpvar.i}
{utp/ut-glob.i}

def var h-acomp   as handle no-undo.
def var h-wprog   as handle no-undo.
def var c-destino as char   no-undo.
def var i-cont    as inte   no-undo.

def stream st-export.

find first param-global no-lock no-error.

assign c-programa     = "ESCDP125":U
       c-versao       = "2.12.00":U
       c-revisao      = "000":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "Relat¢rio Gr Maq Pat x UEP"
       c-sistema      = "ESP".

assign c-rodape = "iDBA - " 
                + c-sistema 
                + " - " 
                + c-programa
                + " - V:" 
                + c-versao
                + "."
                + c-revisao
       c-rodape = fill("-", 80 - length(c-rodape)) + c-rodape.

form header
     fill("-", 80) format "x(80)" skip
     c-empresa format "x(24)" c-titulo-relat at 30 format "x(30)"
     "Folha:" at 70 page-number  at 76 format ">>>>9" skip
     fill("-", 60) format "x(58)" today format "99/99/9999"
     "-" string(time, "HH:MM:SS") skip(1)
     with stream-io width 80 no-labels no-box page-top frame f-cabec.

form header
     c-rodape format "x(80)"
     with stream-io width 80 no-labels no-box page-bottom frame f-rodape.

if opsys = "UNIX":U
then do:
     run esp/es0018p.p (input  "SPOOL-UNIX":U,
                        input  1,
                        input  0,
                        input  "":U,
                        output table tt-prog-ponto).

     for first tt-prog-ponto:
         assign c-destino = replace(tt-prog-ponto.conteudo, "~\":U, "/":U).
     end. /* for first tt-prog-ponto */

     if substr(c-destino, length(c-destino), 1) <> "/":U 
     then assign c-destino = c-destino + "/":U.

     assign tt-param.arquivo = c-programa + ".lst":U
            c-destino        = c-destino  + c-seg-usuario + "/":U.
end. /* if opsys = "UNIX":U */
else do:
     assign file-info:file-name = trim(tt-param.arquivo).
     assign c-destino = file-info:full-pathname.

     if c-destino = ?
     then assign c-destino = trim(tt-param.arquivo).

     assign c-destino = fn-get-dir(input c-destino)
            c-destino = replace(c-destino,"/","\").
end. /* else do */

assign c-destino = c-destino 
                 + "escdp125_emp"
                 + trim(v_cod_empres_usuar)
                 + "-"
                 + replace(iso-date(today),"-","")
                 + replace(string(time,"HH:MM:SS"),":","")
                 + ".csv".

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

put unformatted
    skip(1)
    "Planilha: "
    c-destino
    skip
    "Arquivo: "
    tt-param.arquivo
    skip.

if tt-param.execucao = 1 /* Online */
then do:
     run utp/ut-acomp.p persistent set h-acomp.
     run pi-inicializar in h-acomp(input "Carregando...").

     if tt-param.destino = 3 /* Terminal */
     then run utp/ut-utils.p persistent set h-wprog.
end. /* if tt-param.execucao = 1 */

for first int_param_uep
    where int_param_uep.cod_empresa = v_cod_empres_usuar
          no-lock: end.

if temp-table tt-digita:has-records
then for each tt-digita,
         each int_bem_pat_gm use-index ch-gm no-lock
        where int_bem_pat_gm.gm-codigo = tt-digita.gm-codigo,
        first int_bem_pat use-index ch-id no-lock
        where int_bem_pat.num_id_bem_pat     = int_bem_pat_gm.num_id_bem_pat
          and int_bem_pat.cod_empresa        = v_cod_empres_usuar
          and int_bem_pat.num_bem_pat       >= tt-param.num_bem_ini
          and int_bem_pat.num_bem_pat       <= tt-param.num_bem_fim
          and int_bem_pat.num_seq_bem_pat   >= tt-param.num_seq_bem_ini
          and int_bem_pat.num_seq_bem_pat   <= tt-param.num_seq_bem_fim
          and int_bem_pat.cod_cta_pat       >= tt-param.cod_cta_ini
          and int_bem_pat.cod_cta_pat       <= tt-param.cod_cta_fim,
        first bem_pat no-lock
        where bem_pat.cod_empresa        = int_bem_pat.cod_empresa
          and bem_pat.cod_cta_pat        = int_bem_pat.cod_cta_pat
          and bem_pat.num_bem_pat        = int_bem_pat.num_bem_pat
          and bem_pat.num_seq_bem_pat    = int_bem_pat.num_seq_bem_pat
          and bem_pat.cod_estab         >= tt-param.cod_estab_ini
          and bem_pat.cod_estab         <= tt-param.cod_estab_fim
          and bem_pat.dat_aquis_bem_pat >= tt-param.dat_aquis_ini
          and bem_pat.dat_aquis_bem_pat <= tt-param.dat_aquis_fim:
         assign i-cont = i-cont + 1.

         if  i-cont mod 10 = 0
         and valid-handle(h-acomp)
         then run pi-acompanhar in h-acomp (input int_bem_pat_gm.gm-codigo + " " + string(int_bem_pat.num_bem_pat)).

         {esp/cdp/escdp125rp.i}
     end. /* for each tt-digita */
else for each bem_pat use-index bempat_dat_aquis no-lock
        where bem_pat.cod_empresa        = v_cod_empres_usuar
          and bem_pat.cod_cta_pat       >= tt-param.cod_cta_ini
          and bem_pat.cod_cta_pat       <= tt-param.cod_cta_fim
          and bem_pat.cod_estab         >= tt-param.cod_estab_ini
          and bem_pat.cod_estab         <= tt-param.cod_estab_fim
          and bem_pat.dat_aquis_bem_pat >= tt-param.dat_aquis_ini
          and bem_pat.dat_aquis_bem_pat <= tt-param.dat_aquis_fim
          and bem_pat.num_bem_pat       >= tt-param.num_bem_ini
          and bem_pat.num_bem_pat       <= tt-param.num_bem_fim
          and bem_pat.num_seq_bem_pat   >= tt-param.num_seq_bem_ini
          and bem_pat.num_seq_bem_pat   <= tt-param.num_seq_bem_fim,
        first int_bem_pat no-lock
        where int_bem_pat.cod_empresa     = bem_pat.cod_empresa
          and int_bem_pat.num_bem_pat     = bem_pat.num_bem_pat
          and int_bem_pat.num_seq_bem_pat = bem_pat.num_seq_bem_pat
          and int_bem_pat.cod_cta_pat     = bem_pat.cod_cta_pat,
         each int_bem_pat_gm no-lock
        where int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat
          and int_bem_pat_gm.gm-codigo     >= tt-param.gm-codigo-ini
          and int_bem_pat_gm.gm-codigo     <= tt-param.gm-codigo-fim:
         assign i-cont = i-cont + 1.
        
         if  i-cont mod 10 = 0
         and valid-handle(h-acomp)
         then run pi-acompanhar in h-acomp (input i-cont).

         {esp/cdp/escdp125rp.i}
     end. /* for each int_param_cta_uep */

find current tt_int_bem_pat no-error.
release tt_int_bem_pat.

output stream st-export to value(c-destino) no-convert.

if valid-handle(h-acomp)
then run pi-seta-titulo in h-acomp (input "Gerando CSV...").

assign i-cont = 0.

case tt-param.classifica:
    when 1
    then do:
         put stream st-export unformatted
             "GRUPO DE MµQUINA;DESCRI€ÇO GRUPO MAQ;BEM PATRIMONIAL;SEQUÒNCIA BEM;CONTA PATRIMONIAL;DESCRI€ÇO BEM;ESTAB;DT AQUISI€ÇO"
             skip.

         for each tt_int_bem_pat:
             assign i-cont = i-cont + 1.

             if  i-cont mod 15 = 0
             and valid-handle(h-acomp)
             then run pi-acompanhar in h-acomp (input i-cont).

             put stream st-export unformatted
                 tt_int_bem_pat.gm-codigo       ";"
                 tt_int_bem_pat.descricao       ";"
                 tt_int_bem_pat.num_bem_pat     ";"
                 tt_int_bem_pat.num_seq_bem_pat ";"
                 tt_int_bem_pat.cod_cta_pat     ";"
                 tt_int_bem_pat.des_bem_pat     ";"
                 tt_int_bem_pat.cod_estab       ";"
                 tt_int_bem_pat.dat_aquis_bem_pat
                 skip.
         end. /* for each tt_int_bem_pat */

    end. /* when 1 */
    when 2
    then do:
         put stream st-export unformatted
             "BEM PATRIMONIAL;SEQUÒNCIA BEM;CONTA PATRIMONIAL;DESCRI€ÇO BEM;ESTAB;DT AQUISI€ÇO;GRUPO DE MµQUINA;DESCRI€ÇO GRUPO MAQ"
             skip.

         for each tt_int_bem_pat use-index id2:
             assign i-cont = i-cont + 1.

             if  i-cont mod 15 = 0
             and valid-handle(h-acomp)
             then run pi-acompanhar in h-acomp (input i-cont).

             put stream st-export unformatted
                 tt_int_bem_pat.num_bem_pat       ";"
                 tt_int_bem_pat.num_seq_bem_pat   ";"
                 tt_int_bem_pat.cod_cta_pat       ";"
                 tt_int_bem_pat.des_bem_pat       ";"
                 tt_int_bem_pat.cod_estab         ";"
                 tt_int_bem_pat.dat_aquis_bem_pat ";"
                 tt_int_bem_pat.gm-codigo         ";"
                 tt_int_bem_pat.descricao
                 skip.
         end. /* for each tt_int_bem_pat */
    end. /* when 2 */
end case. /* case tt-param.classifica */

if valid-handle(h-acomp)
then run pi-finalizar in h-acomp.

output stream st-export close.

{include/i-rpclo.i}

if valid-handle(h-wprog)
then do:
     run OpenDocument in h-wprog (input c-destino).
     delete procedure h-wprog no-error.
end. /* if valid-handle(h-wprog) */

return "OK":U.

/******************** PROCEDURES e FUN€åES ********************/
function fn-get-dir returns character (input p-file as character):
    def var c-destino-aux as char no-undo.
    def var c-result  as char no-undo.

    if p-file begins "\\"
    then assign c-destino-aux = replace(p-file,"/","\")
                 c-result = substr(c-destino-aux,1,r-index(c-destino-aux,"\"))
                 c-result = replace(c-result,"/","\").
    else assign c-destino-aux = replace(p-file,"\","/")
                c-result  = substr(c-destino-aux,1,r-index(c-destino-aux,"/"))
                c-result  = replace(c-result,"\","/").

    if c-result = ""
    or c-result = ?
    then assign c-result = session:temp-directory.

    return c-result.
end function.
