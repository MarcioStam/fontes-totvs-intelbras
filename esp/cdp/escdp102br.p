/********************************************************************************
*      Programa .....: escdp102br.p                                             *
*      Data .........: 29 de dezembro de 2021                                   *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur°cio C.                                              *
*      Objetivo .....: Importaá∆o Cat†logo Grupo Cliente                        *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL    MOTIVO                           *
*      1.00.00.001  29/12/2021  Mauricio C.    Desenvolvimento                  *
********************************************************************************/
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

{include/i-prgvrs.i escdp102br 1.00.00.001}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escdp102br ESP}
&ENDIF

define temp-table tt-param
    field destino          as integer
    field arq-destino      as char
    field arq-entrada      as char
    field todos            as integer
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field simulacao        as logical
    field salva-log        as logical.

define temp-table tt-raw-digita
    field raw-digita    as raw.

define temp-table tt-int-gr-cli-catalogo no-undo like int-gr-cli-catalogo
    field linha as inte
    field erro  as logi
    index id is primary erro
                        linha
    index id2 cod-gr-cli    
              cod-unid-negoc
              segmento      
              fm-cod-com    
              it-codigo.

define temp-table tt-erro no-undo
    field linha    as inte
    field mensagem as char format "x(70)"
    index id is primary linha.

/*  Recebimento de parametros --- */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/***** VARIµVEIS *****/
{include/i-rpvar.i}
{utp/ut-glob.i}

def var h-acomp          as handle no-undo.
def var c-param-arq      as char   no-undo.
def var c-arq-copy       as char   no-undo.
def var i-cont           as inte   no-undo.
def var c-imp            as char   no-undo.
def var i-cod-gr-cli     as inte   no-undo.
def var c-it-codigo      as char   no-undo.
def var c-cod-unid-negoc as char   no-undo.
def var c-segmento       as char   no-undo.
def var c-fm-cod-com     as char   no-undo.

def stream st-imp.
def stream st-out.

/***** FRAMES *****/
form tt-int-gr-cli-catalogo.linha          format ">>>>>9" column-label "Linha Arq"
     tt-int-gr-cli-catalogo.cod-gr-cli     format ">>>9"   column-label "Grupo Cliente"
     tt-int-gr-cli-catalogo.it-codigo      format "x(16)"  column-label "Produto"
     tt-int-gr-cli-catalogo.cod-unid-negoc format "x(3)"   column-label "Unid Neg"
     tt-int-gr-cli-catalogo.segmento       format "x(8)"   column-label "Segmento"
     tt-int-gr-cli-catalogo.fm-cod-com     format "x(8)"   column-label "Fam Comercial"
     with width 172 down no-box stream-io frame f-dados.

form tt-erro.linha    format ">>>>>>9" column-label "Linha"
     tt-erro.mensagem format "x(150)"  column-label "Erro"
     with width 172 down no-box stream-io frame f-erro.

find first param-global no-lock no-error.

assign c-programa     = "ESCDP102":U
       c-versao       = "1.00.00":U
       c-revisao      = "001":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "Importaá∆o Cat†logo Grupo Cliente"
       c-sistema      = "ESP".

assign c-rodape = "iDBA - " 
                + c-sistema 
                + " - " 
                + c-programa
                + " - V:" 
                + c-versao
                + "."
                + c-revisao
       c-rodape = fill("-", 172 - length(c-rodape)) + c-rodape.

form header
    fill("-", 172) format "x(172)" skip
    c-empresa c-titulo-relat at 50
    "Folha:" at 162 page-number  at 168 format ">>>>9" skip
    fill("-", 152) format "x(150)" today format "99/99/9999"
    "-" string(time, "HH:MM:SS") skip(1)
    with stream-io width 172 no-labels no-box page-top frame f-cabec.

form header
     c-rodape format "x(172)"
     with stream-io width 172 no-labels no-box page-bottom frame f-rodape.

{include/i-rpout.i &stream="stream st-out" &TOFILE=tt-param.arq-destino}

view stream st-out frame f-cabec.
view stream st-out frame f-rodape.

find first tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Processando...").

if  tt-param.salva-log
and tt-param.destino > 1
then do:
     file-info:file-name = tt-param.arq-destino.
     assign c-param-arq = file-info:full-pathname.
     assign c-arq-copy  = fn-get-copy(input c-param-arq).
end. /* if tt-param.destino > 1 */

empty temp-table tt-int-gr-cli-catalogo.

input stream st-imp from value(tt-param.arq-entrada) no-echo no-convert.

repeat:
    import stream st-imp unformatted c-imp.

    assign i-cont = i-cont + 1.

    run pi-acompanhar in h-acomp (input "Linha: " + string(i-cont)).

    if c-imp = ""
    then next.

    if num-entries(c-imp,";") <> 5
    then do:
         run pi-erro (input i-cont,
                      input "Nro. imprevisto de entradas com o delimitador ~";~"").
         next.
    end.

    assign i-cod-gr-cli   = 0
           c-it-codigo      = ""
           c-cod-unid-negoc = ""
           c-segmento       = ""
           c-fm-cod-com     = "".

    assign i-cod-gr-cli     = inte(entry(1,c-imp,";"))
           c-it-codigo      = trim(entry(2,c-imp,";"))
           c-cod-unid-negoc = trim(entry(3,c-imp,";"))
           c-segmento       = trim(entry(4,c-imp,";"))
           c-fm-cod-com     = trim(entry(5,c-imp,";"))
                              no-error.

    if error-status:error
    then do:
         run pi-erro (input i-cont,
                      input "Erro quanto ao tipo de entrada de dados").
         next.
    end.

    run pi-valida.

    create tt-int-gr-cli-catalogo.
    assign tt-int-gr-cli-catalogo.cod-gr-cli     = i-cod-gr-cli     
           tt-int-gr-cli-catalogo.cod-unid-negoc = c-cod-unid-negoc
           tt-int-gr-cli-catalogo.segmento       = c-segmento 
           tt-int-gr-cli-catalogo.fm-cod-com     = c-fm-cod-com      
           tt-int-gr-cli-catalogo.it-codigo      = c-it-codigo
           tt-int-gr-cli-catalogo.linha          = i-cont
           tt-int-gr-cli-catalogo.erro           = can-find(first tt-erro where
                                                                  tt-erro.linha = i-cont).
end. /* repeat */

input stream st-imp close.

find current tt-int-gr-cli-catalogo no-error.

for each tt-int-gr-cli-catalogo
   where tt-int-gr-cli-catalogo.erro = no
         break by tt-int-gr-cli-catalogo.linha:
    if tt-param.todos = 1
    then do:
         if first(tt-int-gr-cli-catalogo.linha)
         then do:
              if tt-param.simulacao
              then put stream st-out unformatted
                              fill("-",20) at 1
                              " APENAS SIMULAÄ«O "
                              fill("-",20) 
                              skip(1)
                              "REGISTROS OS QUAIS SERIAM CRIADOS".
              else put stream st-out unformatted 
                             "REGISTROS CRIADOS" at 1.

              put stream st-out skip(1).       
         end. /* if first(tt-int-gr-cli-catalogo.linha) */    

         disp stream st-out
              tt-int-gr-cli-catalogo.linha
              tt-int-gr-cli-catalogo.cod-gr-cli        
              tt-int-gr-cli-catalogo.it-codigo  
              tt-int-gr-cli-catalogo.cod-unid-negoc
              tt-int-gr-cli-catalogo.segmento   
              tt-int-gr-cli-catalogo.fm-cod-com  
              with frame f-dados.
         down stream st-out with frame f-dados.
    end. /* if tt-param.todos = 1 */

    if not tt-param.simulacao
    then do transaction:
             create int-gr-cli-catalogo.
             assign int-gr-cli-catalogo.cod-gr-cli     = tt-int-gr-cli-catalogo.cod-gr-cli       
                    int-gr-cli-catalogo.it-codigo      = tt-int-gr-cli-catalogo.it-codigo     
                    int-gr-cli-catalogo.cod-unid-negoc = tt-int-gr-cli-catalogo.cod-unid-negoc
                    int-gr-cli-catalogo.segmento       = tt-int-gr-cli-catalogo.segmento      
                    int-gr-cli-catalogo.fm-cod-com     = tt-int-gr-cli-catalogo.fm-cod-com.
         end. /* do transaction */
end. /* for each tt-int-gr-cli-catalogo */

find current int-gr-cli-catalogo no-lock no-error.

if not can-find(first tt-int-gr-cli-catalogo where
                      tt-int-gr-cli-catalogo.erro = no)
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
    def input parameter p-msg   as char no-undo.

    create tt-erro.
    assign tt-erro.linha    = p-linha
           tt-erro.mensagem = p-msg.
    find current tt-erro no-error.

    return "OK".
end procedure. /* procedure pi-erro */

procedure pi-valida:
    if can-find(first int-gr-cli-catalogo where
                      int-gr-cli-catalogo.cod-gr-cli     = i-cod-gr-cli
                  and int-gr-cli-catalogo.cod-unid-negoc = c-cod-unid-negoc
                  and int-gr-cli-catalogo.segmento       = c-segmento
                  and int-gr-cli-catalogo.fm-cod-com     = c-fm-cod-com
                  and int-gr-cli-catalogo.it-codigo      = c-it-codigo
                      no-lock)
    then do:
         run pi-erro (input i-cont,
                      input "Registro j† existente").
         return "NOK".
    end.

    find tt-int-gr-cli-catalogo use-index id2 where 
         tt-int-gr-cli-catalogo.cod-gr-cli     = i-cod-gr-cli
     and tt-int-gr-cli-catalogo.cod-unid-negoc = c-cod-unid-negoc
     and tt-int-gr-cli-catalogo.segmento       = c-segmento
     and tt-int-gr-cli-catalogo.fm-cod-com     = c-fm-cod-com
     and tt-int-gr-cli-catalogo.it-codigo      = c-it-codigo
         no-error.

    if avail tt-int-gr-cli-catalogo
    then do:
         run pi-erro (input i-cont,
                      input "Registro repetido no arquivo de importaá∆o").

         run pi-erro (input tt-int-gr-cli-catalogo.linha,
                      input "Registro repetido no arquivo de importaá∆o").

         assign tt-int-gr-cli-catalogo.erro = yes.

         return "NOK".
    end.

    if ambiguous tt-int-gr-cli-catalogo
    then do:
         run pi-erro (input i-cont,
                      input "Registro repetido no arquivo de importaá∆o").

         return "NOK".
    end.

    if i-cod-gr-cli = 0
    or not can-find(first gr-cli where
                          gr-cli.cod-gr-cli = i-cod-gr-cli
                          no-lock)
    then run pi-erro (input i-cont,
                      input "Grupo Cliente n∆o cadastrado").

    if c-it-codigo = ""
    then run pi-erro (input i-cont,
                      input "Produto n∆o pode estar em branco").

    if c-it-codigo <> "*"
    then if not can-find(first item where
                               item.it-codigo = c-it-codigo
                               no-lock)
         then run pi-erro (input i-cont,
                           input "Produto n∆o cadastrado").
         else if c-cod-unid-negoc <> ""
              or c-segmento       <> ""
              then run pi-erro (input i-cont,
                                input "Quando Produto Ç informado, Unid Negoc e Segmento devem estar em branco").
              else.
    else do:
         if c-cod-unid-negoc = ""
         then run pi-erro (input i-cont,
                           input "Unid Neg deve ser informada").

         if c-segmento = ""
         then run pi-erro (input i-cont,
                           input "Segmento deve ser informado").

         if c-cod-unid-negoc <> "*"
         then do:
              if length(c-cod-unid-negoc) <> 2
              then run pi-erro (input i-cont,
                                input "Unidade Neg¢cio deve ter dois caracteres").

              if not can-find(first fam-com-item where                                     
                                    fam-com-item.fm-cod-com = c-cod-unid-negoc
                                    no-lock)
              then run pi-erro (input i-cont,
                                input "Fam Com Item n∆o cadastrada").
         end. /* if c-cod-unid-negoc <> "*" */

         if c-segmento <> "*"
         then do:
              if length(c-segmento) <> 4
              then run pi-erro (input i-cont,
                                input "Segmento deve ter quatro caracteres").

              if not can-find(first fam-com-item where                                     
                                    fam-com-item.fm-cod-com = c-segmento
                                    no-lock)
              then run pi-erro (input i-cont,
                                input "Fam Com Item n∆o cadastrada").
         end. /* if c-segmento <> "*" */
    end. /* else do */

    if c-fm-cod-com = ""
    then run pi-erro (input i-cont,
                      input "Fam°lia Comercial n∆o pode estar em branco").

    if c-fm-cod-com <> "*"
    then do:
         if not can-find(first fam-comerc where
                               fam-comerc.fm-cod-com = c-fm-cod-com
                               no-lock)
         then run pi-erro (input i-cont,
                           input "Fam°lia Comercial n∆o cadastrada").
    end.

    return "OK".
end procedure. /* procedure pi-valida */
