/********************************************************************************
*      Programa .....: escep093rp.p                                             *
*      Data .........: 13 de janeiro de 2023                                    *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur¡cio C.                                              *
*      Objetivo .....: Exporta‡Æo de Dados APS                                  *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL   MOTIVO                            *
*      1.00.00.000  13/01/2023  Mauricio C.   Desenvolvimento                   *
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

{include/i-prgvrs.i escep093rp 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escep093rp ESP}
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
    field cod-estabel-ini  as char
    field cod-estabel-fim  as char
    field it-codigo-ini    as char
    field it-codigo-fim    as char
    field cod-modelo-ini   as char
    field cod-modelo-fim   as char
    field cod-obsoleto-ini as inte
    field cod-obsoleto-fim as inte
    field comp-spot        as inte
    field mod-aereo        as inte
    field phase-in         as inte
    field phase-out        as inte
    field item-rest        as inte
    field bloq-prod        as inte
    field requer-aval      as inte.

define temp-table tt-raw-digita
    field raw-digita    as raw.

{esp/es0018.i}

/*  Recebimento de parametros --- */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.
find current tt-param no-error.    

/***** VARIµVEIS *****/
{include/i-rpvar.i}
{utp/ut-glob.i}

def var h-acomp     as handle no-undo.
def var h-wprog     as handle no-undo.
def var c-diretorio as char   no-undo.
def var c-dest-csv  as char   no-undo.
def var c-obsoleto  as char   no-undo.
def var i-cont      as inte   no-undo.
def var lg-cabec    as logi   no-undo.
def var lg-avail    as logi   no-undo.

def var lg-comp-spot   as logi no-undo.   
def var lg-mod-aereo   as logi no-undo.  
def var lg-phase-in    as logi no-undo.
def var lg-phase-out   as logi no-undo.
def var lg-item-rest   as logi no-undo.
def var lg-bloq-prod   as logi no-undo.
def var lg-requer-aval as logi no-undo.

def stream st-csv.

assign c-obsoleto = "Ativo,Obsoleto Ordens Autom ticas,Obsoleto Todas as Ordens,Totalmente Obsoleto".

find first param-global no-lock no-error.

assign c-programa     = "ESCEP093":U
       c-versao       = "1.00.00":U
       c-revisao      = "000":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "Exporta‡Æo de Dados APS"
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

if tt-param.execucao = 1 /* Online */
then do:
     run utp/ut-acomp.p persistent set h-acomp.
     run pi-inicializar in h-acomp(input "Carregando...").

     if tt-param.destino = 3 /* Terminal */
     then run utp/ut-utils.p persistent set h-wprog.
end. /* if tt-param.execucao = 1 */

if opsys = "UNIX":U
then do:
     run esp/es0018p.p (input  "SPOOL-UNIX":U,
                        input  1,
                        input  0,
                        input  "":U,
                        output table tt-prog-ponto).

     for first tt-prog-ponto:
         assign c-diretorio = replace(tt-prog-ponto.conteudo, "~\":U, "/":U).
     end. /* for first tt-prog-ponto */

     if substr(c-diretorio, length(c-diretorio), 1) <> "/":U 
     then assign c-diretorio = c-diretorio + "/":U.

     assign tt-param.arquivo = c-programa + ".lst":U
            c-diretorio      = c-diretorio + c-seg-usuario + "/":U.
end. /* if opsys = "UNIX":U */
else do:
     assign file-info:file-name = trim(tt-param.arquivo).
     assign c-diretorio = file-info:full-pathname.

     if c-diretorio = ?
     then assign c-diretorio = trim(tt-param.arquivo).

     assign c-diretorio = fn-get-dir(input c-diretorio).
end. /* else do */

assign c-dest-csv = c-diretorio 
                  + "escep093_"
                  + replace(iso-date(today),"-","")
                  + "-"
                  + replace(string(time,"HH:MM:SS"),":","")
                  + ".csv".

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

put unformatted
    skip(1)
    "Arquivo csv: "
    c-dest-csv
    skip
    "Arquivo: "
    tt-param.arquivo
    skip.

output stream st-csv to value(c-dest-csv) no-convert. /* convert target "iso8859-1" */

if tt-param.cod-modelo-ini = ""
then for each item-uni-estab fields(cod-estabel it-codigo cod-obsoleto) use-index estab no-lock
        where item-uni-estab.cod-estabel  >= tt-param.cod-estabel-ini
          and item-uni-estab.cod-estabel  <= tt-param.cod-estabel-fim
          and item-uni-estab.it-codigo    >= tt-param.it-codigo-ini
          and item-uni-estab.it-codigo    <= tt-param.it-codigo-fim
          and item-uni-estab.cod-obsoleto >= tt-param.cod-obsoleto-ini
          and item-uni-estab.cod-obsoleto <= tt-param.cod-obsoleto-fim:
         assign i-cont = i-cont + 1.
     
         if  valid-handle(h-acomp)
         and i-cont mod 30 = 0
         then run pi-acompanhar in h-acomp (input item-uni-estab.cod-estabel + " - " + item-uni-estab.it-codigo).

         for first int-item-uni-estab
             where int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
               and int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo
                   no-lock: end.

         assign lg-avail = (avail int-item-uni-estab).

         if lg-avail
         and int-item-uni-estab.cod-modelo > tt-param.cod-modelo-fim
         then next.

         {esp/cep/escep093rp.i}
     end. /* for each item-uni-estab */
else for each int-item-uni-estab no-lock
        where int-item-uni-estab.cod-estabel >= tt-param.cod-estabel-ini
          and int-item-uni-estab.cod-estabel <= tt-param.cod-estabel-fim
          and int-item-uni-estab.it-codigo   >= tt-param.it-codigo-ini
          and int-item-uni-estab.it-codigo   <= tt-param.it-codigo-fim
          and int-item-uni-estab.cod-modelo  >= tt-param.cod-modelo-ini
          and int-item-uni-estab.cod-modelo  <= tt-param.cod-modelo-fim,
        first item-uni-estab fields(cod-estabel it-codigo cod-obsoleto) no-lock
        where item-uni-estab.it-codigo     = int-item-uni-estab.it-codigo
          and item-uni-estab.cod-estabel   = int-item-uni-estab.cod-estabel
          and item-uni-estab.cod-obsoleto >= tt-param.cod-obsoleto-ini
          and item-uni-estab.cod-obsoleto <= tt-param.cod-obsoleto-fim:
         assign i-cont   = i-cont + 1
                lg-avail = yes.
     
         if  valid-handle(h-acomp)
         and i-cont mod 30 = 0
         then run pi-acompanhar in h-acomp (input item-uni-estab.cod-estabel + " - " + item-uni-estab.it-codigo).

         {esp/cep/escep093rp.i}
     end. /* for each int-item-uni-estab */

output stream st-csv close.

if valid-handle(h-acomp)
then run pi-finalizar in h-acomp.

{include/i-rpclo.i}

if valid-handle(h-wprog)
then do:
     run OpenDocument in h-wprog (input c-dest-csv). 
     delete procedure h-wprog no-error.
end. /* if valid-handle(h-wprog) */

return "OK":U.

/******************** PROCEDURES ********************/
