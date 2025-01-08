/********************************************************************************
*      Programa .....: esenp034rp.p                                             *
*      Data .........: 21 de mar‡o de 2023                                      *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur¡cio C.                                              *
*      Objetivo .....: Opera‡äes x Atributos (APS)                              *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL   MOTIVO                            *
*      1.00.00.000  21/03/2023  Mauricio C.   Desenvolvimento                   *
********************************************************************************/
function fn-get-dir returns character (input p-file as character) forwards.
{include/i-prgvrs.i esenp034rp 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esenp034rp ESP}
&ENDIF

define temp-table tt-param no-undo
    field destino              as integer
    field arquivo              as char format "x(35)"
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field classifica           as integer
    field desc-classifica      as char format "x(40)"
    field modelo-rtf           as char format "x(35)"
    field l-habilitaRtf        as LOG
    field execucao             as inte
    field cod-estabel-ini      as char
    field cod-estabel-fim      as char
    field it-codigo-ini        as char
    field it-codigo-fim        as char
    field cod-cor-ini          as char
    field cod-cor-fim          as char
    field cod-tipo-mp-ini      as char
    field cod-tipo-mp-fim      as char
    field cod-modelo-placa-ini as char
    field cod-modelo-placa-fim as char
    field cod-tam-placa-ini    as char
    field cod-tam-placa-fim    as char
    field cod-potencia-ini     as char
    field cod-potencia-fim     as char.

define temp-table tt-digita no-undo
    field cod-estabel as character format "x(5)"
    field nome        as character format "x(40)"
    index id cod-estabel.

define temp-table tt-raw-digita
    field raw-digita    as raw.

define temp-table tt-dados no-undo
    field cod-estabel      like item.cod-estabel 
    field it-codigo        like item.it-codigo   
    field desc-item        like item.desc-item
    field nr-linha         like item-uni-estab.nr-linha    
    field cod-cor          like int-item.cod-cor           
    field cod-tipo-mp      like int-item.cod-tipo-mp       
    field cod-modelo-placa like int-item.cod-modelo-placa  
    field cod-tam-placa    like int-item.cod-tam-placa     
    field cod-potencia     like int-item.cod-potencia
    index id is primary cod-estabel
                        it-codigo
    index id2 it-codigo
              cod-estabel.

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
release tt-digita.

/***** VARIµVEIS *****/
{include/i-rpvar.i}
{utp/ut-glob.i}

def var h-acomp     as handle no-undo.
def var h-wprog     as handle no-undo.
def var c-diretorio as char   no-undo.
def var c-destino   as char   no-undo.
def var i-cont      as inte   no-undo.

def var chExcelApplication as com-handle no-undo. 
def var chWorkbook         as com-handle no-undo. 
def var chWorksheet        as com-handle no-undo. 

def stream st-csv.

find first param-global no-lock no-error.

assign c-programa     = "ESENP034":U
       c-versao       = "1.00.00":U
       c-revisao      = "000":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "Opera‡äes x Atributos (APS)"
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
     with stream-io width 80 no-labels no-box page-top    frame f-cabec.

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

     assign c-diretorio = fn-get-dir(input c-diretorio)
            c-diretorio = replace(c-diretorio,"/","\").
end. /* else do */

assign i-cont    = 1
       c-destino = c-diretorio 
                 + "esenp034_"
                 + replace(iso-date(today),"-","")
                 + "-"
                 + replace(string(time,"HH:MM:SS"),":","")
                 + ".csv".

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

put unformatted
    "Planilha: "
    c-destino
    skip
    "Arquivo: "
    tt-param.arquivo
    skip.

output stream st-csv to value(c-destino) no-convert.

if not temp-table tt-digita:has-records
then for each estabelec fields(cod-estabel nome) no-lock
        where estabelec.cod-estabel >= tt-param.cod-estabel-ini
          and estabelec.cod-estabel <= tt-param.cod-estabel-fim:
         create tt-digita.
         assign tt-digita.cod-estabel = estabelec.cod-estabel
                tt-digita.nome        = estabelec.nome.
         find current tt-digita no-error.
         release tt-digita.
     end. /* for each estabelec */

if tt-param.it-codigo-ini <> ""
or not tt-param.it-codigo-fim begins "ZZZ"
then for each item fields(it-codigo desc-item cod-estabel) no-lock
        where item.it-codigo >= tt-param.it-codigo-ini
          and item.it-codigo <= tt-param.it-codigo-fim
          and item.it-codigo <> "",
        first tt-digita
        where tt-digita.cod-estabel = item.cod-estabel,
        first item-uni-estab fields(it-codigo    cod-estabel 
                                    cod-obsoleto nr-linha) no-lock
        where item-uni-estab.it-codigo    = item.it-codigo
          and item-uni-estab.cod-estabel  = item.cod-estabel
          and item-uni-estab.cod-obsoleto < 4,
        first int-item no-lock
        where int-item.it-codigo          = item.it-codigo
          and int-item.cod-cor           >= tt-param.cod-cor-ini
          and int-item.cod-cor           <= tt-param.cod-cor-fim
          and int-item.cod-tipo-mp       >= tt-param.cod-tipo-mp-ini
          and int-item.cod-tipo-mp       <= tt-param.cod-tipo-mp-fim
          and int-item.cod-modelo-placa  >= tt-param.cod-modelo-placa-ini
          and int-item.cod-modelo-placa  <= tt-param.cod-modelo-placa-fim
          and int-item.cod-tam-placa     >= tt-param.cod-tam-placa-ini
          and int-item.cod-tam-placa     <= tt-param.cod-tam-placa-fim
          and int-item.cod-potencia      >= tt-param.cod-potencia-ini
          and int-item.cod-potencia      <= tt-param.cod-potencia-fim
          and (int-item.cod-cor          <> "" or
               int-item.cod-tipo-mp      <> "" or
               int-item.cod-modelo-placa <> "" or
               int-item.cod-tam-placa    <> "" or
               int-item.cod-potencia     <> ""):
         {esp/enp/esenp034rp.i}     
     end. /* for each item */
else for each tt-digita:
         if valid-handle(h-acomp)
         then run pi-seta-titulo in h-acomp (input "Carregando Est " + tt-digita.cod-estabel).
        
         for each item fields(it-codigo desc-item cod-estabel) use-index ch-localiz no-lock
            where item.cod-estabel = tt-digita.cod-estabel
              and item.it-codigo  >= tt-param.it-codigo-ini
              and item.it-codigo  <= tt-param.it-codigo-fim
              and item.it-codigo  <> "",
            first item-uni-estab fields(it-codigo    cod-estabel 
                                        cod-obsoleto nr-linha) no-lock
            where item-uni-estab.it-codigo    = item.it-codigo
              and item-uni-estab.cod-estabel  = item.cod-estabel
              and item-uni-estab.cod-obsoleto < 4,
            first int-item no-lock
            where int-item.it-codigo          = item.it-codigo
              and int-item.cod-cor           >= tt-param.cod-cor-ini
              and int-item.cod-cor           <= tt-param.cod-cor-fim
              and int-item.cod-tipo-mp       >= tt-param.cod-tipo-mp-ini
              and int-item.cod-tipo-mp       <= tt-param.cod-tipo-mp-fim
              and int-item.cod-modelo-placa  >= tt-param.cod-modelo-placa-ini
              and int-item.cod-modelo-placa  <= tt-param.cod-modelo-placa-fim
              and int-item.cod-tam-placa     >= tt-param.cod-tam-placa-ini
              and int-item.cod-tam-placa     <= tt-param.cod-tam-placa-fim
              and int-item.cod-potencia      >= tt-param.cod-potencia-ini
              and int-item.cod-potencia      <= tt-param.cod-potencia-fim
              and (int-item.cod-cor          <> "" or
                   int-item.cod-tipo-mp      <> "" or
                   int-item.cod-modelo-placa <> "" or
                   int-item.cod-tam-placa    <> "" or
                   int-item.cod-potencia     <> ""):
              {esp/enp/esenp034rp.i}         
         end. /* for each item-uni-estab */
     end. /* for each tt-digita */

if valid-handle(h-acomp)
then run pi-seta-titulo in h-acomp (input "Imprimindo...").

assign i-cont = 0.

if temp-table tt-dados:has-records
then put stream st-csv unformatted 
         "sep=|"
         skip
         "Estab|"
         "Item|"           
         "Descri‡Æo Item|" 
         "Lin|"       
         "Cor|" 
         "Tipo MP|"       
         "Modelo Placa|"        
         "Tamanho Placa|"        
         "Potˆncia" 
         skip.

case tt-param.classifica:
    when 1
    then do:
         {esp/enp/esenp034rp.i1 &1=id}
    end. /* when 1 */
    when 2
    then do:
         {esp/enp/esenp034rp.i1 &1=id2}
    end. /* when 2 */
end case. /* case tt-param.classifica */

output stream st-csv close.

if valid-handle(h-acomp)
then run pi-finalizar in h-acomp.

{include/i-rpclo.i}

if valid-handle(h-wprog)
then do:
     run OpenDocument in h-wprog (input c-destino).
     delete procedure h-wprog no-error.
end. /* if valid-handle(h-wprog) */

return "OK":U.

/******************** PROCEDURES e FUN€åES ********************/
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
