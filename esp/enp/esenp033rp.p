/********************************************************************************
*      Programa .....: esenp033rp.p                                             *
*      Data .........: 16 de janeiro de 2023                                    *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur¡cio C.                                              *
*      Objetivo .....: Opera‡äes x Ferramentas (APS)                            *
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

{include/i-prgvrs.i esenp033rp 1.00.00.000}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esenp033rp ESP}
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
    field it-codigo-ini   as char
    field it-codigo-fim   as char
    field ferramenta-ini  as char
    field ferramenta-fim  as char.

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
def var c-destino   as char   no-undo.
def var i-cont      as inte   no-undo.
def var c-tipo      as char   no-undo.
def var de-nro-hom  as deci   no-undo.
def var lg-cabec    as logi   no-undo.

def var c-formato as char init "xlsx" no-undo.

def var chExcelApplication as com-handle no-undo. 
def var chWorkbook         as com-handle no-undo. 
def var chWorksheet        as com-handle no-undo. 

def stream st-csv.

find first param-global no-lock no-error.

assign c-programa     = "ESENP033":U
       c-versao       = "1.00.00":U
       c-revisao      = "000":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "Opera‡äes x Ferramentas (APS)"
       c-sistema      = "ESP".

assign c-rodape = "iDBA - " 
                + c-sistema 
                + " - " 
                + c-programa
                + " - V:" 
                + c-versao
                + "."
                + c-revisao
       c-rodape = fill("-", 132 - length(c-rodape)) + c-rodape.

form header
     fill("-", 132) format "x(132)" skip
     c-empresa c-titulo-relat at 50
     "Folha:" at 122 page-number  at 128 format ">>>>9" skip
     fill("-", 112) format "x(110)" today format "99/99/9999"
     "-" string(time, "HH:MM:SS") skip(1)
     with stream-io width 132 no-labels no-box page-top frame f-cabec.

form header
     c-rodape format "x(132)"
     with stream-io width 132 no-labels no-box page-bottom frame f-rodape.

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
            c-diretorio      = c-diretorio + c-seg-usuario + "/":U
           //c-formato        = "csv"
         .
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
       c-formato = "csv"
       c-destino = c-diretorio 
                 + "esenp033_"
                 + replace(iso-date(today),"-","")
                 + "-"
                 + replace(string(time,"HH:MM:SS"),":","")
                 + "."
                 + c-formato.

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

if c-formato = "csv"
then output stream st-csv to value(c-destino) no-convert. /* convert target "iso8859-1" */
/* else do:                                                                      */
/*      create "Excel.Application" chExcelApplication.                           */
/*                                                                               */
/*      chExcelApplication:visible = no.                                         */
/*      chExcelApplication:DisplayAlerts = no.                                   */
/*      chWorkbook  = chExcelApplication:Workbooks:add() no-error.               */
/*      chWorkSheet = chWorkBook:ActiveSheet.                                    */
/*      chWorkSheet:Name = "Oper x Ferram (APS)".                                */
/*                                                                               */
/*      chWorkSheet:Range("A1:N1"):numberformat = "@".                           */
/*                                                                               */
/*      assign chWorkSheet:range("A" + string(i-cont)):value = "Item"            */
/*             chWorkSheet:range("B" + string(i-cont)):value = "Descri‡Æo Item"  */
/*             chWorkSheet:range("C" + string(i-cont)):value = "Opera‡Æo"        */
/*             chWorkSheet:range("D" + string(i-cont)):value = "Descri‡Æo Oper"  */
/*             chWorkSheet:range("E" + string(i-cont)):value = "Tmp Prep"        */
/*             chWorkSheet:range("F" + string(i-cont)):value = "Tmp Hom"         */
/*             chWorkSheet:range("G" + string(i-cont)):value = "Tmp Maq"         */
/*             chWorkSheet:range("H" + string(i-cont)):value = "Hom APS"         */
/*             chWorkSheet:range("I" + string(i-cont)):value = "Data In¡cio"     */
/*             chWorkSheet:range("J" + string(i-cont)):value = "Data T‚rmino"    */
/*             chWorkSheet:range("K" + string(i-cont)):value = "Grupo M quina"   */
/*             chWorkSheet:range("L" + string(i-cont)):value = "Ferramenta"      */
/*             chWorkSheet:range("M" + string(i-cont)):value = "Qtde Dispon¡vel" */
/*             chWorkSheet:range("N" + string(i-cont)):value = "Tipo".           */
/* end. /* else do */                                                            */

for each operacao no-lock
   where operacao.it-codigo >= tt-param.it-codigo-ini
     and operacao.it-codigo <= tt-param.it-codigo-fim,
   first item fields(it-codigo desc-item) no-lock
   where item.it-codigo = operacao.it-codigo,
    each op-ferram fields(num-id-operacao ferramenta) no-lock
   where op-ferram.num-id-operacao = operacao.num-id-operacao
     and op-ferram.ferramenta    >= tt-param.ferramenta-ini
     and op-ferram.ferramenta    <= tt-param.ferramenta-fim,
   first ferr-prod fields(cod-ferr-prod int-2 char-1) no-lock
   where ferr-prod.cod-ferr-prod = op-ferram.ferramenta:
        assign i-cont     = i-cont + 1
               c-tipo     = ""
               de-nro-hom = 0.

        if i-cont mod 5 = 0
        then run pi-acompanhar in h-acomp (input i-cont).

        if ferr-prod.char-1 <> "..."
        then assign c-tipo = trim(ferr-prod.char-1).

        for first int-ext-operacao no-lock
            where int-ext-operacao.num-id-operacao = operacao.num-id-operacao:
            assign de-nro-hom = int-ext-operacao.nro-homem-aps.
        end. /* for first int-ext-operacao */

/*         if c-formato = "csv" */
/*         then do:             */
             if not lg-cabec
             then put stream st-csv unformatted 
                      "sep=;"
                      skip
                      "Item;"           
                      "Descri‡Æo Item;" 
                      "Opera‡Æo;"       
                      "Descri‡Æo Oper;" 
                      "Tmp Prep;"       
                      "Tmp Hom;"        
                      "Tmp Maq;"        
                      "Hom APS;"        
                      "Data In¡cio;"    
                      "Data T‚rmino;"   
                      "Grupo M quina;"  
                      "Ferramenta;"     
                      "Qtde Dispon¡vel;"
                      "Tipo;"
                      skip.
             
             assign lg-cabec = yes.
        
             put stream st-csv unformatted 
                 operacao.it-codigo    ";"
                 trim(item.desc-item)  ";"
                 operacao.op-codigo    ";"
                 operacao.descricao    ";"
                 operacao.tempo-prepar ";"
                 operacao.tempo-homem  ";"
                 operacao.tempo-maquin ";"
                 de-nro-hom            ";"
                 operacao.data-inicio  ";"
                 operacao.data-termino ";"
                 operacao.gm-codigo    ";"
                 op-ferram.ferramenta  ";"
                 ferr-prod.int-2       ";"
                 c-tipo                ";"
                 skip.
/*                                                                                                      */
/*              next.                                                                                   */
/*         end. /* if lg-csv */                                                                         */
/*                                                                                                      */
/*         chWorkSheet:Range("C" + string(i-cont)):numberformat = "#####0".                             */
/*         chWorkSheet:Range("E" + string(i-cont)):numberformat = "###0,000".                           */
/*         chWorkSheet:Range("F" + string(i-cont)):numberformat = "###0,000".                           */
/*         chWorkSheet:Range("G" + string(i-cont)):numberformat = "###0,000".                           */
/*         chWorkSheet:Range("H" + string(i-cont)):numberformat = "##0,0".                              */
/*         chWorkSheet:Range("I" + string(i-cont) + ":J" + string(i-cont)):numberformat = "dd/mm/aaaa". */
/*         chWorkSheet:Range("M" + string(i-cont)):numberformat = "########0".                          */
/*                                                                                                      */
/*         assign chWorkSheet:range("A" + string(i-cont)):value = operacao.it-codigo                    */
/*                chWorkSheet:range("B" + string(i-cont)):value = trim(item.desc-item)                  */
/*                chWorkSheet:range("C" + string(i-cont)):value = operacao.op-codigo                    */
/*                chWorkSheet:range("D" + string(i-cont)):value = operacao.descricao                    */
/*                chWorkSheet:range("E" + string(i-cont)):value = operacao.tempo-prepar                 */
/*                chWorkSheet:range("F" + string(i-cont)):value = operacao.tempo-homem                  */
/*                chWorkSheet:range("G" + string(i-cont)):value = operacao.tempo-maquin                 */
/*                chWorkSheet:range("H" + string(i-cont)):value = de-nro-hom                            */
/*                chWorkSheet:range("I" + string(i-cont)):value = operacao.data-inicio                  */
/*                chWorkSheet:range("J" + string(i-cont)):value = operacao.data-termino                 */
/*                chWorkSheet:range("K" + string(i-cont)):value = operacao.gm-codigo                    */
/*                chWorkSheet:range("L" + string(i-cont)):value = op-ferram.ferramenta                  */
/*                chWorkSheet:range("M" + string(i-cont)):value = ferr-prod.int-2                       */
/*                chWorkSheet:range("N" + string(i-cont)):value = c-tipo.                               */
end. /* for each operacao */

if c-formato = "csv"
then output stream st-csv close.
/* else do:                                                                                  */
/*      chWorkSheet:Range("A1:" + "N" + string(i-cont)):Borders({&xlEdgeTop}):LineStyle = 1. */
/*      chWorkSheet:Range("A1:" + "N" + string(i-cont)):Borders({&xlEdgeTop}):Weight    = 1. */
/*                                                                                           */
/*      chExcelApplication:Cells:select.                                                     */
/*      chExcelApplication:Cells:EntireColumn:AutoFit.                                       */
/*                                                                                           */
/*      chExcelApplication:range("A1"):select.                                               */
/*      chExcelApplication:Workbooks:item(1):SaveAs(c-destino,,,,,,).                        */
/*                                                                                           */
/*      chExcelApplication:quit().                                                           */
/*                                                                                           */
/*      release object chWorkbook         no-error.                                          */
/*      release object chWorksheet        no-error.                                          */
/*      release object chExcelApplication no-error.                                          */
/* end. /* else do */                                                                        */

if valid-handle(h-acomp)
then run pi-finalizar in h-acomp.

{include/i-rpclo.i}

if valid-handle(h-wprog)
then do:
     if c-formato = "csv"
     then run OpenDocument in h-wprog (input c-destino).
/*      else run execute in h-wprog (input "Excel", c-destino). */
     delete procedure h-wprog no-error.
end. /* if valid-handle(h-wprog) */

return "OK":U.

/******************** PROCEDURES ********************/

