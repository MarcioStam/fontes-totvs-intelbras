/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp047RP LIBERADO}  /*** 010006 ***/
{include/i_fnctrad.i}
/******************************************************************************
**  Programa: esftp047rp.P
**  Data....: Maio - 2002
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**  Objetivo: Curva ABC Valor Faturado por Cliente
******************************************************************************/
def temp-table tt-raw-digita
    field raw-digita       as raw.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

define temp-table tt-param no-undo
    field destino             as integer
    field arquivo             as char format "x(35)"
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field c-estabel-ini       as char
    field c-estabel-fim       as char
    field i-agrupamento       as integer    
    field da-data-refer       as date format "99/99/9999"
    field da-data-inicio      as date format "99/99/9999"
    FIELD c-unid-neg-ini      AS CHAR
    FIELD c-unid-neg-fim      AS CHAR
    field i-moeda-imp         as integer
    field i-moeda-cor         as integer
    field l-devol             as log.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp as handle no-undo.
run utp/ut-acomp.p persistent set h-acomp.


def workfile fat-ignor
    field data-estat  like fat-estat.data-estat
    field fm-codigo   like fat-estat.fm-codigo
    field it-codigo   like fat-estat.it-codigo
    field mo-codigo   like cotacao.mo-codigo.

def temp-table tt-dados-graf
    field cod-emitente like emitente.cod-emitente
    field nome-abrev   like emitente.nome-abrev
    field nome-emit    as char format "x(30)"
    field quantidade   as decimal format ">>,>>>,>>>,>>9.9999"
    field quantidade-mes   as decimal format ">>,>>>,>>>,>>9.9999"  extent 6.

def temp-table tt-meses
    field cod-emitente like emitente.cod-emitente
    FIELD cod-gr-cli   LIKE emitente.cod-gr-cli
    field periodo      as char format "x(5)"
    field valor        as dec format "->>>,>>>,>>9.99"
    index ch-unico cod-emitente periodo.


def var c-destino       as char format "x(20)" no-undo.
def var c-selecao       as char format "x(8)" no-undo.
def var c-parametro     as char format "x(10)" no-undo.
def var c-impressao     as char format "x(9)" no-undo.
DEFINE VARIABLE c-unid-neg  AS CHARACTER   NO-UNDO.
def var c-tot           as char format "x(9)" no-undo.
def var c-devol         as char format "x(15)" no-undo.
def var i-cont          as integer no-undo.
def var i-mes           as integer no-undo.
def var de-fat          like cotacao.cotacao extent 0 init 1.
def var de-fat1         like cotacao.cotacao extent 0 init 1.
def var de-fat2         like cotacao.cotacao extent 0 init 1.
def var de-fat3         like cotacao.cotacao extent 0 init 1.
def var de-fator-conver like item.fator-conver.
def var c-nome-ab       like emitente.nome-abrev no-undo.
def var i-cont-cli      as integer.
def var c-mo-corr       like moeda.descricao no-undo.
def var c-mo-imp        like moeda.descricao no-undo.
def var da-conversao    as date no-undo.
def var i-op-tipo       as integer   init 1 no-undo.
def var c-desc-agrup    as character format "x(19)" no-undo.
def var de-perc-valor   as decimal format "->>9.99" label "Perc".
def var de-perc-acum    as decimal format "->>9.99" label "% Acum".
def var de-valor-acum   as decimal format ">>>,>>>,>>>,>>9.99" .
def var de-lucro        like de-valor-acum.
def var c-ord           as char format "x(5)"  no-undo.
def var c-cli           as char format "x(7)"  no-undo.
def var c-grupo         as char format "x(7)"  no-undo.
def var c-nome          as char format "x(4)"  no-undo.
def var c-vl-fat        as char format "x(12)"  no-undo.
def var c-lucro2        as char format "x(15)" no-undo.
def var c-per1          as char format "x(4)"  no-undo.
def var c-per2          as char format "x(4)"  no-undo.
def var c-per3          as char format "x(4)"  no-undo.
def var c-acum1         as char format "x(10)" no-undo.
def var c-acum2         as char format "x(5)"  no-undo.
def var de-quantidade-mes as dec  extent 12    no-undo.
def var c-mes             as char extent 12    no-undo.   
def new shared var de-cot-urv   as decimal init 275000 no-undo.
def            var da-conv-real as date    init 07/01/1994 no-undo.
def var    c-end  like emitente.endereco initial "Endereco".
def var    c-cid  like emitente.cidade           initial "Cidade".
def var    c-uf   like emitente.estado           initial "UF".
def var    c-cep  as char format "x(3)"          initial "CEP".
def var    c-telefone as char format "x(20)"     initial "Telefone".
def var    c-e-mail   as char                    initial "E-mail".
def var    c-mes1   as char format "x(07)".
def var    c-mes2   as char format "x(07)".
def var    c-mes3   as char format "x(07)".
def var    c-mes4   as char format "x(07)".
def var    c-mes5   as char format "x(07)".
def var    c-mes6   as char format "x(07)".
def var    c-mes7   as char format "x(07)".
def var    c-mes8   as char format "x(07)".
def var    c-mes9   as char format "x(07)".
def var    c-mes10  as char format "x(07)".
def var    c-mes11  as char format "x(07)".
def var    c-mes12  as char format "x(07)".

form
   c-ord    at 1
   c-cli    at 10
   c-grupo  AT 38
   c-end    at 48
   c-cid    at 89
   c-uf     at 115
   c-cep    at 119
   c-telefone at 130
   c-e-mail   at 161
   c-vl-fat at 208
   c-per2   at 222
   "         "
   c-mes1     COLUMN-LABEL "Ord" format "x(07)"
   "        "   
   c-mes2     COLUMN-LABEL "Ord" format "x(07)"
   "        "   
   c-mes3     COLUMN-LABEL "Ord" format "x(07)" 
   "        "   
   c-mes4     COLUMN-LABEL "Ord" format "x(07)" 
   "        "   
   c-mes5     COLUMN-LABEL "Ord" format "x(07)" 
   "        "   
   c-mes6     COLUMN-LABEL "Ord" format "x(07)" 
   "        "   
   c-mes7     COLUMN-LABEL "Ord" format "x(07)" 
   "        "   
   c-mes8     COLUMN-LABEL "Ord" format "x(07)" 
   "        "   
   c-mes9     COLUMN-LABEL "Ord" format "x(07)" 
   "        "   
   c-mes10    COLUMN-LABEL "Ord" format "x(07)" 
   "        "   
   c-mes11    COLUMN-LABEL "Ord" format "x(07)" 
   "        "   
   c-mes12    COLUMN-LABEL "Ord" format "x(07)"
   /*
   "----------------------------------------" at 1
   "----------------------------------------" at 41
   "----------------------------------------------------" at 81*/
with stream-io no-box no-labels page-top frame f-cab width 550.


{utp/ut-liter.i Ordem * R}
assign c-ord = trim(return-value).

{utp/ut-liter.i Perc * L}
assign c-per2 = trim(return-value).

{utp/ut-liter.i %_Ac * L}
assign c-per3 = trim(return-value).

{utp/ut-liter.i Cliente * L}
assign c-cli = trim(return-value).
{utp/ut-liter.i Grupo * L}
assign c-grupo =  trim(return-value).

{utp/ut-liter.i Vl_Faturado * R}
assign c-vl-fat = trim(return-value).

{utp/ut-liter.i Vl_Fat_Acum * L}
assign c-lucro2 = trim(return-value).

{utp/ut-liter.i Acum * L}
assign c-acum2 = trim(return-value).

{utp/ut-liter.i Acumulado * L}
assign c-acum1 = trim(return-value).

form space(5)     
    c-selecao     colon 20 skip(1)
    tt-param.c-estabel-ini   colon 30 "|<         >|" at 40 tt-param.c-estabel-fim no-label skip(2) 
    with side-label frame f-selecao stream-io width 132 . 

{utp/ut-table.i mgadm estabelec 1}      
assign tt-param.c-estabel-ini:label in frame f-selecao = trim(return-value).

form space(2)
    c-parametro      colon 20 skip(1)
    tt-param.da-data-refer format "99/99/9999" colon 30 skip 
    tt-param.da-data-inicio        format "99/99/9999" colon 30 skip 
    tt-param.i-moeda-cor        colon 30 format ">9" " - " c-mo-corr no-label skip
    tt-param.i-moeda-imp        colon 30 format ">9" " - " c-mo-imp no-label skip 
    c-desc-agrup     colon 30 skip
    c-devol          colon 30 skip(2)
    with frame f-param side-label stream-io width 132 .      

{utp/ut-liter.i  Dt_Referˆncia * L}
assign tt-param.da-data-refer:label in frame f-param = trim(return-value).

{utp/ut-liter.i  Dt_In¡cio * L}
assign tt-param.da-data-inicio:label in frame f-param = trim(return-value).

{utp/ut-liter.i Agrupa_dados_por * L}
assign c-desc-agrup:label in frame f-param = trim(return-value).

{utp/ut-liter.i Considera_Devolu‡äes? * L}
assign c-devol:label in frame f-param = trim(return-value).

{utp/ut-liter.i Moeda_para_Corre‡Æo * L}
assign tt-param.i-moeda-cor:label in frame f-param = trim(return-value).

{utp/ut-liter.i Moeda_para_ImpressÆo * L}
assign tt-param.i-moeda-imp:label in frame f-param = trim(return-value).

if tt-param.l-devol then do:
   {utp/ut-liter.i Sim * L}
   assign c-devol = trim(return-value).
end.
else do:
   {utp/ut-liter.i NÆo * L}
   assign c-devol = trim(return-value).
end.

form space(1)
   c-impressao  colon 20 skip(1)    
   c-destino    colon 30 no-label skip
   arquivo      colon 21 with frame f-impressao 1 col side-label stream-io width 132 .
{utp/ut-liter.i Aguarde *}

run pi-inicializar in h-acomp (input  Return-value ).

{include/i-rpvar.i}

run cdp/cd9200.p (output da-conversao).



{utp/ut-liter.i Faturamento * L}
assign c-sistema      = trim(return-value)
       c-programa     = "esftp047".

find first param-global no-lock no-error.
assign c-empresa = param-global.grupo.

run utp/ut-trfrrp.p (input frame f-impressao:handle).
run utp/ut-trfrrp.p (input frame f-param:handle).
run utp/ut-trfrrp.p (input frame f-selecao:handle).
/*
run utp/ut-trfrrp.p (input frame f-cab:handle).
*/
/*
{include/i-rpcab.i}

{utp/ut-liter.i Curva_ABC_de_Valor_Faturado_por_Cliente * R}
*/
assign c-titulo-relat = trim(return-value).

if tt-param.i-agrupamento = 1 then do:
  {utp/ut-table.i mgadm cliente 1}
  assign c-desc-agrup = trim(return-value).
end.
else 
  if tt-param.i-agrupamento = 2 then do:
    {utp/ut-liter.i Matriz * R}
    assign c-desc-agrup = trim(return-value).
  end.   
  
{include/i-rpout.i}
    /*
view frame f-cabec.
view frame f-rodape.
      */


for each tt-dados-graf:
    delete tt-dados-graf.
end.

for each fat-ignor no-lock :
    delete fat-ignor.
end.

 assign de-perc-acum  = 0
        de-valor-acum = 0
        i-cont-cli    = 0.

find first moeda where moeda.mo-codigo = tt-param.i-moeda-cor no-lock no-error.
if avail moeda then
   assign c-mo-corr = moeda.descricao.
else 
   assign c-mo-corr = "".

find first moeda where moeda.mo-codigo = tt-param.i-moeda-imp no-lock no-error.
if avail moeda then
   assign c-mo-imp = moeda.descricao.
else 
   assign c-mo-imp = "".

for each  fat-estat use-index ch-estab
    where fat-estat.data-estat >= tt-param.da-data-inicio
    and   fat-estat.data-estat <= tt-param.da-data-refer
    and   fat-estat.cod-estabel >= tt-param.c-estabel-ini
    and   fat-estat.cod-estabel <= tt-param.c-estabel-fim no-lock
    break by fat-estat.nome-ab-cli:

    
    FIND ITEM WHERE ITEM.it-codigo = fat-estat.it-codigo NO-LOCK NO-ERROR.

/*     find first unid-neg-item no-lock                                           */
/*          where unid-neg-item.it-codigo = fat-estat.it-codigo no-error.         */
/*     if   avail unid-neg-item then                                              */
/*          assign c-unid-neg = unid-neg-item.cod_unid_negoc.                     */
/*     ELSE DO:                                                                   */
/*         FIND ITEM WHERE ITEM.it-codigo = fat-estat.it-codigo NO-LOCK NO-ERROR. */
/*         FIND FIRST unid-neg-fam-com NO-LOCK                                    */
/*              WHERE unid-neg-fam-com.fm-codigo = item.fm-cod-com NO-ERROR.      */
/*         if   avail unid-neg-fam-com then                                       */
/*              assign c-unid-neg = unid-neg-fam-com.cod_unid_negoc.              */
/*         else assign c-unid-neg = "INVALIDA".                                   */
/*     END.                                                                       */
    
    assign c-unid-neg = ITEM.cod-unid-negoc.
    /*
    PUT "fat-estat " fat-estat.cod-emitente fat-estat.nome-ab-cli fat-estat.data-estat c-unid-neg SKIP.
      */
    IF c-unid-neg >= tt-param.c-unid-neg-ini AND
       c-unid-neg <= tt-param.c-unid-neg-fim THEN DO:
        if  tt-param.i-moeda-cor <> 0 then do:
            find first cotacao
                where cotacao.mo-codigo   = tt-param.i-moeda-cor
                and   cotacao.ano-periodo = string(year(fat-estat.data-estat)) + string(month(fat-estat.data-estat),"99")
                and   cotacao.cotacao[int(day(fat-estat.data-estat))] <> 0 no-lock no-error.
            
            if  avail cotacao then
                assign de-fat3 = cotacao.cotacao[int(day(fat-estat.data-estat))].
            
    
        end.
        if  not avail cotacao and tt-param.i-moeda-cor <> 0 then do:
            create fat-ignor.
            assign fat-ignor.data-estat  = fat-estat.data-estat
                   fat-ignor.fm-codigo   = fat-estat.fm-codigo
                   fat-ignor.it-codigo   = fat-estat.it-codigo
                   fat-ignor.mo-codigo   = tt-param.i-moeda-cor.
        end.
        else do:
            if tt-param.i-moeda-cor = 0 then do:
               if fat-estat.data-estat < da-conversao then
                  assign de-fat3 = 1000.
               else
                  if fat-estat.data-estat > da-conversao and
                     fat-estat.data-estat < da-conv-real then
                     assign de-fat3 = de-cot-urv.
                  else
                     assign de-fat3 = 1.
            end.
    
            assign de-lucro = fat-estat.vl-contabil - fat-estat.vl-ipi.
    
            if  not fat-estat.ind-devolucao then do:
                accumulate ((fat-estat.vl-contabil - fat-estat.vl-ipi) / de-fat3 )
                                 (total by fat-estat.nome-ab-cli).
                accumulate de-lucro / de-fat3
                                 (total by fat-estat.nome-ab-cli).
                assign de-quantidade-mes[month(fat-estat.data-estat)] = de-quantidade-mes[month(fat-estat.data-estat)] + (fat-estat.vl-contabil - fat-estat.vl-ipi) / de-fat3
                        c-mes[month(fat-estat.data-estat)]             = string(year(fat-estat.data-estat),"9999") + "/" + string(month(fat-estat.data-estat),"99").
               
            end.
            else 
                if  l-devol = yes then do:
                     accumulate (- (fat-estat.vl-contabil - fat-estat.vl-ipi) / de-fat3)
                           (total by fat-estat.nome-ab-cli).
                     accumulate (- de-lucro / de-fat3)
                           (total by fat-estat.nome-ab-cli).
                     assign de-quantidade-mes[month(fat-estat.data-estat)] = de-quantidade-mes[month(fat-estat.data-estat)] - (fat-estat.vl-contabil - fat-estat.vl-ipi) / de-fat3
                            c-mes[month(fat-estat.data-estat)]             = string(year(fat-estat.data-estat),"9999") + "/" + string(month(fat-estat.data-estat),"99").
                end.
        end.
    END.
    find first emitente where 
               emitente.nome-abrev = fat-estat.nome-ab-cli no-lock no-error.
    if  last-of(fat-estat.nome-ab-cli) then do:

        if avail emitente then do:
            if  tt-param.i-agrupamento = 2 then do:
                if  emitente.nome-matriz <> emitente.nome-abrev then do:
                    assign c-nome-ab = emitente.nome-matriz.
                    find emitente 
                         where emitente.nome-abrev = c-nome-ab
                         no-lock.
                end.
                find first tt-dados-graf
                     where tt-dados-graf.cod-emitente = emitente.cod-emitente  no-error.
                if  not avail tt-dados-graf then do:
                    create tt-dados-graf.
                    assign tt-dados-graf.cod-emitente = emitente.cod-emitente
                           tt-dados-graf.nome-emit    = emitente.nome-emit
                           tt-dados-graf.nome-abrev   = emitente.nome-abrev                       
                           i-cont-cli                 = i-cont-cli + 1.
                end.
            end.
            else do:
                create tt-dados-graf.
                assign tt-dados-graf.cod-emitente = emitente.cod-emitente
                       tt-dados-graf.nome-emit    = emitente.nome-emit
                       tt-dados-graf.nome-abrev   = fat-estat.nome-ab-cli
                       i-cont-cli                 = i-cont-cli + 1.
            end.

            assign tt-dados-graf.quantidade  = tt-dados-graf.quantidade +
                              (accum total by fat-estat.nome-ab-cli
                                              (fat-estat.vl-contabil - fat-estat.vl-ipi) / de-fat3) +
                              (accum total by fat-estat.nome-ab-cli
                                           (- (fat-estat.vl-contabil - fat-estat.vl-ipi) / de-fat3)).
        end.
        do i-cont = 1 to 12:
            find tt-meses
                 where tt-meses.cod-emitente = emitente.cod-emitente
                   and tt-meses.periodo      = c-mes[i-cont]
                 no-lock no-error.

            if not avail tt-meses then do:
               create tt-meses.
               assign tt-meses.cod-emitente = emitente.cod-emitente
                      tt-meses.cod-gr-cli   = emitente.cod-gr-cli
                      tt-meses.periodo      = c-mes[i-cont].               
            end.              
            assign tt-meses.valor = tt-meses.valor + de-quantidade-mes[i-cont]
/*                    c-mes[i-cont] = ""  */
                   de-quantidade-mes[i-cont] = 0. 
        end.
    end.
end.

assign i-cont = 0.
for each tt-meses
    where tt-meses.periodo <> "" and
          tt-meses.valor <> 0 
    break by tt-meses.periodo:
    
    
    if last-of(tt-meses.periodo) then do:
       assign i-cont = i-cont + 1.

       if i-cont = 01 then
          assign c-mes1 = tt-meses.periodo.
       if i-cont = 02 then
          assign c-mes2 = tt-meses.periodo.
       if i-cont = 03 then
          assign c-mes3 = tt-meses.periodo.
       if i-cont = 04 then
          assign c-mes4 = tt-meses.periodo.
       if i-cont = 05 then
          assign c-mes5 = tt-meses.periodo.
       if i-cont = 06 then
          assign c-mes6 = tt-meses.periodo.
       if i-cont = 07 then
          assign c-mes7 = tt-meses.periodo.
       if i-cont = 08 then
          assign c-mes8 = tt-meses.periodo.
       if i-cont = 09 then
          assign c-mes9 = tt-meses.periodo.
       if i-cont = 10 then
          assign c-mes10 = tt-meses.periodo.
       if i-cont = 11 then
          assign c-mes11 = tt-meses.periodo.
       if i-cont = 12 then
          assign c-mes12 = tt-meses.periodo.         
    end.

    
end.

put  c-ord       ";"
      c-per1     ";"
      c-cli      ";"
      c-grupo    ";"
      c-end      ";"
      c-cid      ";"
      c-uf       ";"
      c-cep      ";"
      c-telefone ";"
      c-e-mail   ";"
      c-vl-fat   ";"
      c-per2     ";"
      c-mes1     ";"
      c-mes2     ";"
      c-mes3     ";"
      c-mes4     ";"
      c-mes5     ";"
      c-mes6     ";"
      c-mes7     ";"
      c-mes8     ";"
      c-mes9     ";"
      c-mes10    ";"
      c-mes11    ";"
      c-mes12    ";".
      
assign i-cont = 0.      
for each  tt-dados-graf
    break by tt-dados-graf.quantidade descending:
    find emitente where 
         emitente.cod-emitente = tt-dados-graf.cod-emitente no-lock no-error.
    accumulate tt-dados-graf.quantidade  (total).

    assign i-cont        = i-cont + 1
           de-perc-valor = ((tt-dados-graf.quantidade * de-fat) * 100) /
                           (accum total de-lucro / de-fat3)
           de-valor-acum = de-valor-acum + tt-dados-graf.quantidade.
           de-perc-acum  = ((de-valor-acum * 100) /
                                  (accum total de-lucro / de-fat3)).

    FIND gr-cli
        WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.

    put i-cont                     format ">>>>9"               ";"
        tt-dados-graf.cod-emitente format ">>>>>>>>9"           ";"
        tt-dados-graf.nome-emit        ";"                      
        gr-cli.descricao ";"
        replace(emitente.endereco,";","") FORMAT "x(40)"          ";" 
        emitente.cidade ";"
        emitente.estado ";"
        emitente.cep    format "99999-999" ";"
        emitente.telefone  ";"
        emitente.e-mail ";"
        tt-dados-graf.quantidade  * de-fat
                                   format "->,>>>,>>>,>>9.99"  ";"
        de-perc-valor              format "->>9.99"        ";" .
   assign i-mes = 0.
   for each tt-meses
       where tt-meses.cod-emitente = tt-dados-graf.cod-emitente 
/*          and tt-meses.valor <> 0 */
         and tt-meses.periodo <> "" no-lock
          by tt-meses.periodo :      
          assign i-mes = i-mes + 1.
          put tt-meses.valor at 228 + 40 * i-mes format "->,>>>,>>>,>>9.99" ";".
   end.
   
   PUT ";" at 228 + 40 * 12.
   FOR EACH cont-emit
       WHERE cont-emit.cod-emitente = emitente.cod-emitente NO-LOCK:
       PUT  cont-emit.nome ";"
            cont-emit.telefone ";"
            cont-emit.e-mail ";".
   END.
     put "" skip.   
end.

{utp/ut-liter.i Total * R}
assign c-tot = trim(return-value) +  ":".
put fill("-",132) format "x(132)" skip
    c-tot at 1
    (accum total tt-dados-graf.quantidade) * de-fat format "->>,>>>,>>>,>>9.99" to 202.

def var c-mo-ignor  as character.
{utp/ut-liter.i Listagem_dos_Itens_Ignorados_por_Falta_de_Cota‡Æo * L}
assign c-titulo-relat = return-value.
 
form
    space(12)
    fat-ignor.it-codigo  
    space(6)
    fat-ignor.data-estat 
    with stream-io down centered frame f-ignorados .

{utp/ut-table.i mgind item 1}
assign fat-ignor.it-codigo:label in frame f-ignorados = return-value .

{utp/ut-liter.i Data_da_Estat¡stica * L}
assign fat-ignor.data-estat:label in frame f-ignorados = return-value.
find first param-global no-lock no-error.
page.

for each fat-ignor no-lock break by fat-ignor.mo-codigo:
    
    disp fat-ignor.it-codigo
         fat-ignor.data-estat with frame f-ignorados.

    down with frame f-ignorados.
end.
page.

/* FT0704.I1 */

{utp/ut-liter.i Curva_ABC_de_Valor_Faturado_por_Cliente * R}
assign c-titulo-relat = trim(return-value).

for each tt-dados-graf:
    delete tt-dados-graf.
end.


if tt-param.destino = 1 then do:
  {utp/ut-liter.i Destino:Arquivo * R}
  assign c-destino = trim(return-value).
end.
else
if tt-param.destino = 2 then do:
  {utp/ut-liter.i Destino:Impressora * R}
  assign c-destino = trim(return-value).
end.
else
if tt-param.destino = 3 then do:
  {utp/ut-liter.i Destino:Terminal * R}
  assign c-destino = trim(return-value).
end.

{utp/ut-liter.i Arquivo * R}
assign arquivo:label in frame f-impressao = trim(return-value). 

{utp/ut-liter.i Sele‡Æo * L}
assign c-selecao:label in frame f-selecao = trim(return-value).

{utp/ut-liter.i ImpressÆo * L}
assign c-impressao:label in frame f-impressao = trim(return-value).


{utp/ut-liter.i Parƒmetros * L}
assign c-parametro:label in frame f-param = trim(return-value).

clear frame f-cab all.
hide all.

view frame f-cabec.
view frame f-rodape.

disp c-selecao  
     tt-param.c-estabel-ini 
     tt-param.c-estabel-fim 
    with frame f-selecao . 

disp
    c-parametro     
    tt-param.da-data-refer   
    tt-param.da-data-inicio
    tt-param.i-moeda-cor    
    c-mo-corr   
    tt-param.i-moeda-imp        
    c-mo-imp
    c-desc-agrup
    c-devol
    with frame f-param .      

disp
   c-impressao  
   c-destino    
   arquivo format "x(23)"      
   with frame f-impressao .   

{include/i-rpclo.i}
run pi-finalizar in h-acomp.

RETURN "OK":U.
