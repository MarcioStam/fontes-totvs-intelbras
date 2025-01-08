/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCEP999RP 2.00.00.040}  /*** 010040 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCEP999rp MCE}
&ENDIF

{include/i_fnctrad.i}

/***************************************************************************************************
 PROGRAMA : ESCEP999RP.P
 OBJETIVO : Relat¢rio de Itens Cr¡ticos.
****************************************************************************************************/ 

{cdp/cdcfgmat.i}

define temp-table tt-param
    field destino          as integer format "99"
    field arquivo          as char    format "x(100)"
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field i-ge-ini         like item.ge-codigo
    field i-ge-fim         like item.ge-codigo
    field c-estab-ini      like saldo-estoq.cod-estabel
    field c-estab-fim      like saldo-estoq.cod-estabel
    field c-item-ini       like item.it-codigo
    field c-item-fim       like item.it-codigo
    field l-crit           as logical  format "Sim/NÆo"
    field l-acer           as logical  format "Sim/NÆo"
    field l-pagina         as logical  format "Sim/NÆo"
    field i-moeda          as integer  format "9"
    field c-moeda          as char  format "x(10)" 
    field i-mo             as integer
    FIELD l-parametro      AS LOGICAL 
    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
        FIELD c-fm-cod-ini LIKE ITEM.fm-codigo
        FIELD c-fm-cod-fim LIKE ITEM.fm-codigo
    &ENDIF. 

define temp-table tt-digita
    field cod-estabel           like movto-estoq.cod-estabel
    field nome                  as character format "x(40)"
    field data-ini              like param-estoq.ult-fech-dia
    field data-fim              like param-estoq.ult-fech-dia
    field ult-per-fech          like param-estoq.ult-per-fech
    field mensal-ate            like param-estoq.mensal-ate
    field l-processou           like item.loc-unica
    index codigo cod-estabel.

define temp-table w-movto
    field w-cod-estabel like   saldo-estoq.cod-estabel
    field w-movto-aca   as logical initial no
    field w-qtidade     like   saldo-estoq.qtidade-ini
    field w-valor-mat-m   like   item-estab.sald-ini-mat-m
    field w-valor-mob-m   like   item-estab.sald-ini-mob-m
    field w-valor-ggf-m   like   item-estab.sald-ini-ggf-m
    field w-de-var-tot  as decimal format "-999999999999999.9999"
        index codigo is primary 
                w-cod-estabel.

define temp-table w-saldo
    field w-cod-estabel like saldo-estoq.cod-estabel
    field w-cod-depos   like saldo-estoq.cod-depos
    field w-qtidade     like saldo-estoq.qtidade-ini
    field w-valor-mat-m   like item-estab.sald-ini-mat-m
    field w-valor-mob-m   like item-estab.sald-ini-mob-m    
    field w-valor-ggf-m   like item-estab.sald-ini-ggf-m
        index codigo is primary
            w-cod-estabel
            w-cod-depos.

define temp-table w-saldo-ini
    field w-cod-estabel like saldo-estoq.cod-estabel
    field w-cod-depos   like saldo-estoq.cod-depos
    field w-qtidade     like saldo-estoq.qtidade-ini
    field w-valor-mat-m   like item-estab.sald-ini-mat-m
    field w-valor-mob-m   like item-estab.sald-ini-mob-m    
    field w-valor-ggf-m   like item-estab.sald-ini-ggf-m
        index estab-dep is primary
                w-cod-estabel
                w-cod-depos.

define query qr-movto-2 for tt-digita, movto-estoq.
define query qr-movto-1 for movto-estoq.

define query qr-movto-esp-2 for tt-digita, movto-estoq.
define query qr-movto-esp-1 for movto-estoq.


define query qr-saldo-1 for saldo-estoq.
define query qr-saldo-2 for tt-digita, saldo-estoq.
define query qr-item-estab for tt-digita, item-estab, item.

def new global shared temp-table tt-moedas
    field cod-moeda            as integer
    field qtd-decimais         as integer
    field ind-tratamento-infor as integer
    field ind-tratamento-calc  as integer.

def var l-rejeita-dec as logical.

function FN_AJUST_DEC_ANT returns decimal (p-valor as decimal, p-moeda as integer).

    &if '{&mguni_version}' < "2.03" &then
        if not can-find(funcao no-lock where funcao.cd-funcao = "spp_ajusta_dec") then
            return (p-valor).
    &endif

    find tt-moedas 
        where tt-moedas.cod-moeda = p-moeda no-error.
    if not avail tt-moedas then do:
        find moeda no-lock where moeda.mo-codigo = p-moeda no-error.
        create tt-moedas.
        &if '{&mguni_version}' < "2.02" &then
            assign tt-moedas.cod-moeda            = moeda.mo-codigo
                   tt-moedas.qtd-decimais         = moeda.qtd-dec
                   tt-moedas.ind-tratamento-infor = moeda.ind-val-inform
                   tt-moedas.ind-tratamento-calc  = moeda.ind-val-calc.
        &else
            assign tt-moedas.cod-moeda            = moeda.mo-codigo
                   tt-moedas.qtd-decimais         = 4
                   tt-moedas.ind-tratamento-infor = moeda.ind-val-infor
                   tt-moedas.ind-tratamento-calc  = moeda.ind-val-calc.
        &endif
    end.

    if tt-moedas.qtd-decimais = 4 then
        return (p-valor).   

    if tt-moedas.ind-tratamento-calc = 1 then
        return (round(p-valor, tt-moedas.qtd-decimais)).
    else
        return (truncate(p-valor, tt-moedas.qtd-decimais)).

end function.

function FN_VLD_AJUST_DEC_ANT returns decimal (p-valor as decimal, p-moeda as integer).

    &if '{&mguni_version}' < "2.03" &then
        if not can-find(funcao no-lock where funcao.cd-funcao = "spp_ajusta_dec") then
            return (p-valor).
    &endif

    find tt-moedas
        where tt-moedas.cod-moeda = p-moeda no-error.
    if not avail tt-moedas then do:
        find moeda no-lock where moeda.mo-codigo = p-moeda no-error.
        create tt-moedas.
        &if '{&mguni_version}' < "2.02" &then
            assign tt-moedas.cod-moeda            = moeda.mo-codigo
                   tt-moedas.qtd-decimais         = moeda.qtd-dec
                   tt-moedas.ind-tratamento-infor = moeda.ind-val-inform
                   tt-moedas.ind-tratamento-calc  = moeda.ind-val-calc.
        &else
            assign tt-moedas.cod-moeda            = moeda.mo-codigo
                   tt-moedas.qtd-decimais         = 4
                   tt-moedas.ind-tratamento-infor = moeda.ind-val-infor
                   tt-moedas.ind-tratamento-calc  = moeda.ind-val-calc.
        &endif
    end.

    if tt-moedas.qtd-decimais = 4 then
        return (p-valor).

    case tt-moedas.ind-tratamento-infor:
        when 1 then 
            return (round(p-valor, tt-moedas.qtd-decimais)).
        when 2 then 
            return (truncate(p-valor, tt-moedas.qtd-decimais)).
        when 3 then do:
            if (truncate(p-valor, tt-moedas.qtd-decimais) <> p-valor) then
                assign l-rejeita-dec = yes.
            return (p-valor).
        end.
    end.

end function.

function FN_AJUST_DEC returns decimal (p-valor as decimal, p-moeda as integer).

    return (p-valor).

end function.

function FN_VLD_AJUST_DEC returns decimal (p-valor as decimal, p-moeda as integer).

    return (p-valor).

end function.

def var moeda        as integer no-undo. /*parametriza‡Æo chile*/
def var de-qtd-tot      like saldo-estoq.qtidade-ini.
def var de-tipo         as integer.
def var de-tipo2        as character.
def var de-conta        as decimal.
def var c-conta         as character format "x(17)".
def var c-opcao         as character.
def var c-item-aux      like item.it-codigo.
def var c-item-auxiliar like item.it-codigo.
def var i-ge-aux        like grup-estoque.ge-codigo.
def var i-ge-cod-ant    like grup-estoque.ge-codigo initial 0.
def var l-primeira      as logical initial yes.
def var de-total-ini    as decimal format "->>>>,>>>,>>>,>>9.9999".
def var de-total-fim    as decimal format "->>>>,>>>,>>>,>>9.9999".
def var c-auxiliar      as character format "X(12)".
def var l-mostra        as logical.
def var l-pagina        as logical.
def var l-critico       as logical.
def var l-acerto        as logical.
def var c-ponto-1       as character format "x".
def var l-movto         as logical.
def var c-trans         as character format "x(02)". 
def var c-esp-docto     as character format "x(03)".
def var i-dia           as integer format "99".
def var i-mes           as integer format "99".
def var c-traco-1       as character format "x(130)".
def var c-estab-aux     like movto-estoq.cod-estabel.
def var i-mo            as integer format "9" initial 1.
def var i-moeda         as integer format "9" initial 0.
def var c-moeda         as character format "x(10)".
def var l-var-movto     as logical.
def var de-valor-mat-m    like movto-estoq.valor-mat-m[1] extent 0.
def var de-valor-mob-m    like movto-estoq.valor-mob-m[1] extent 0.
def var de-valor-ggf-m    like movto-estoq.valor-ggf-m[1] extent 0.
def var de-numero-ordem as character format "x(10)".
def var c-form-1        as character format "x(13)" initial "".
def var c-form-2        as character format "x(13)" initial "".
def var c-form-3        as character format "x(13)" initial "".
def var c-form-4        as character format "x(13)" initial "".
def var c-form-5        as character format "x(10)" initial "".

DEF VAR l-segue         AS LOGICAL INITIAL NO NO-UNDO.

def var c-form-hifen    as character format "x(01)" initial "-".

def var de-tot-val-mat   as decimal format "->,>>>,>>>,>>>,>>9.9999" initial 0.
def var de-tot-val-mob   as decimal format "->,>>>,>>>,>>>,>>9.9999" initial 0.
def var de-tot-val-ggf   as decimal format "->,>>>,>>>,>>>,>>9.9999" initial 0.

def var de-maior-qtd     as decimal format "->,>>>,>>>,>>>,>>9.9999" initial 0.
def var r-maior-qtd      as rowid.

def var da-ini-per       as date.
def var da-fim-per       as date.
def var i-ano-corrente   as integer.
def var i-per-corrente   as integer.

def var da-dt-aux           as date no-undo.
def var da-data-ini         as date      format "99/99/9999".
def var da-data-fin         as date      format "99/99/9999".

def var l-pular-pag     as logical format "Sim/NÆo".
def var l-item-por-pag  as logical init no.   
def var c-sel           as char format "x(20)".
def var c-par           as char format "x(20)".
def var c-imp           as char format "x(20)".
def var c-labels-1      as char format "x(12)".
def var c-labels-2      as char format "x(12)". 
def var c-labels-3      as char format "x(20)".
def var c-labels-4      as char format "x(10)".
def var c-labels-5      as char format "x(20)".
def var c-data          as char format "x(5)".
def var i-tamanho       as int  no-undo.
def var de-valor-tot    as decimal no-undo.
def var i-tp-fech       as integer no-undo.
def var c-estabelec     as char    no-undo.

def var c-crit          as char format "x(05)".
def var c-acer          as char format "x(05)".
def var c-pagina        as char format "x(05)".
def var c-sim           as char format "x(05)".
def var c-nao           as char format "x(05)".

def var c-resumo        as char format "x(60)" no-undo.
def var c-transacoes    as char format "x(60)" no-undo.

def var c-quantidade    as char format "x(15)" no-undo.
def var c-valor-mat     as char format "x(15)" no-undo.
def var c-valor-mob     as char format "x(17)" no-undo.
def var c-valor-ggf     as char format "x(15)" no-undo.

def var c-cab-razao     as char format "x(132)" no-undo.
def var l-cab           as logical              no-undo.


def var h-acomp as handle no-undo.

/*****************Defini‡Æo e prepara‡Æo dos Parƒmetros *******************/
def temp-table tt-raw-digita
  field raw-digita as raw.

  def input parameter raw-param as raw no-undo.
  def input parameter table for tt-raw-digita.

  create tt-param.
  raw-transfer raw-param to tt-param.


&IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
    form  skip(2)
          c-sel no-labels at 2 skip(01)       
          tt-param.i-ge-ini        to 25   "|<  >|"  at 45 tt-param.i-ge-fim          no-labels  at 54 skip
          tt-param.c-estab-ini     to 26   "|<  >|"  at 45 tt-param.c-estab-fim       no-labels  at 54 skip      
          tt-param.c-item-ini      to 39   "|<  >|"  at 45 tt-param.c-item-fim        no-labels  at 54 skip
          tt-param.c-fm-cod-ini    TO 31   "|<  >|"  at 45 tt-param.c-fm-cod-fim      no-labels  at 54 skip
          with no-box side-labels stream-io width 132 frame f-selecao.
&ELSE
    form  skip(2)
          c-sel no-labels at 2 skip(01)       
          tt-param.i-ge-ini        to 25   "|<  >|"  at 45 tt-param.i-ge-fim          no-labels  at 54 skip
          tt-param.c-estab-ini     to 26   "|<  >|"  at 45 tt-param.c-estab-fim       no-labels  at 54 skip      
          tt-param.c-item-ini      to 39   "|<  >|"  at 45 tt-param.c-item-fim        no-labels  at 54 skip
          with no-box side-labels stream-io width 132 frame f-selecao.
&ENDIF

form skip(2)
     c-par no-labels at 1  skip(01)
     c-labels-1  to 23    c-crit    at 25          skip
     c-labels-2  to 24    c-acer    at 25          skip
     c-labels-3  to 23    c-pagina  at 25          skip
     c-labels-4  at 15    tt-param.i-moeda   at 25  "-" tt-param.c-moeda skip
     with no-box  no-labels stream-io width 132 frame f-parametro.

form skip(2)
     c-imp no-labels at 1  skip (01)
     c-labels-2  at 13 tt-param.destino at 25 "-"  tt-param.arquivo skip
     c-labels-1  at 13 tt-param.usuario at 25
     with no-box no-labels stream-io width 132 frame f-impressao.

form
    grup-estoque.ge-codigo 
    "-"
    grup-estoque.descricao no-label skip (01)
    c-traco-1 no-label
    with no-box side-labels stream-io width 132 frame f-grupo-estoq.

form
    item.it-codigo
    "-"
    item.un no-label
    "-"
    item.desc-item no-label
    space(1)
    item.cod-localiz
    with no-box side-labels stream-io width 132 frame f-item.

form
    skip(1)
    c-resumo at 49 no-label
    "------------------------------" at 49
    skip(1)
    c-quantidade no-label TO 69 /*69*/
    c-valor-mat to 90 no-label 
    c-valor-mob no-label to 111  
    c-valor-ggf no-label to 132
    c-traco-1 no-label "--" at 131
    with no-box no-attr-space width 132 side-labels stream-io frame f-cab-resumo.

form
    skip
    c-transacoes at 31 no-label
    "--------------------------------------------------------" at 31
    skip(1)
    with no-box no-attr-space width 132 stream-io frame f-acerto.

form
    c-form-1 at 01
    w-movto.w-cod-estabel  at 14
    estabelec.nome format "x(32)" at 20
    w-movto.w-qtidade format "->>>>,>>>,>>9.9999"  at 52
    w-movto.w-valor-mat-m[1] format "->>,>>>,>>>,>>9.9999" 
    w-movto.w-valor-mob-m[1] format "->>,>>>,>>>,>>9.9999"
    w-movto.w-valor-ggf-m[1] format "->>,>>>,>>>,>>9.9999"
    with no-box no-attr width 132 no-labels stream-io frame f-resumo-medio.

form 
    c-cab-razao at 1 no-label
    "----- --- ----- --- -- ----- ---------------- --------- -------------- ------------------ ------------- ------------- --------------" at 1
    with no-box no-attr-space width 132 side-labels stream-io frame f-cab-razao.

form
    movto-estoq.cod-estabel
    movto-estoq.cod-depos
    c-data                    column-label "Data"
    c-esp-docto               column-label "Esp"
    c-trans                   column-label "Tr"
    movto-estoq.serie-docto                         
    movto-estoq.nro-docto
    de-numero-ordem           column-label "Ordem" 
    /*##c-conta                   column-label "Conta" AT 57*/
    movto-estoq.quantidade    format "->>>>>>,>>9.9999" AT 74
                              column-label "QuantidaDe" space(1)
    de-valor-mat-m              format "->>>>>,>>9.99" 
                              column-label "Valor Mat" space(1)
    de-valor-mob-m              format "->>>>>,>>9.99"
                              column-label "Valor MOB" space(1)
    de-valor-ggf-m              format "->>>>>,>>9.99" AT 120
                              column-label "Valor GGF"
    with no-box no-labels 64 down width 132 stream-io frame f-razao.

form
    c-form-2 
    c-form-3 
    w-saldo.w-cod-estabel
    c-form-4 
    w-saldo.w-cod-depos
    w-saldo.w-qtidade    format "->>>>,>>>,>>9.9999"  at 52
    w-saldo.w-valor-mat-m[1] format "->>,>>>,>>>,>>9.9999"
    w-saldo.w-valor-mob-m[1] format "->>,>>>,>>>,>>9.9999"
    w-saldo.w-valor-ggf-m[1] format "->>,>>>,>>>,>>9.9999"
    with no-box width 132 no-label no-attr-space stream-io frame f-saldo.

{utp/ut-liter.i Resumo_Item_Para_Calculo_Medio}
assign c-resumo = trim(return-value).   

{utp/ut-liter.i Transacoes_de_Acerto_criadas_pelo_calculo_do_Preco_Medio}
assign c-transacoes = trim(return-value).

{utp/ut-field.i mgind movto-estoq cod-estabel 2}
assign c-cab-razao = string(return-value,"x(06)").

{utp/ut-field.i mgind movto-estoq cod-depos 2}
assign c-cab-razao = c-cab-razao + string(return-value,"x(04)").

{utp/ut-liter.i Data}
assign c-cab-razao = c-cab-razao + string(return-value,"x(06)").

{utp/ut-field.i mgadm esp-doc cod-esp 2}
assign c-cab-razao = c-cab-razao + string(return-value,"x(04)").

{utp/ut-liter.i Tr MCE}
assign c-cab-razao = c-cab-razao + string(return-value,"x(03)").

{utp/ut-field.i mgind movto-estoq serie-docto 2}
assign c-cab-razao = c-cab-razao + string(return-value,"x(06)").

{utp/ut-field.i mgind movto-estoq nro-docto 2}
assign c-cab-razao = c-cab-razao + string(return-value,"x(17)").

{utp/ut-field.i mgind movto-estoq numero-ordem 2}
assign c-cab-razao = c-cab-razao + string(return-value,"x(11)").
/*##
{utp/ut-field.i mgind movto-estoq ct-codigo 1}
assign c-cab-razao = c-cab-razao + string(return-value,"x(17)").*/
ASSIGN c-cab-razao = c-cab-razao + "                 ".

{utp/ut-liter.i Quantidade}
assign c-quantidade = string(fill(" ",15 - length(trim(return-value))) + trim(return-value) ,"x(15)")
       c-cab-razao = c-cab-razao + string(fill(" ",15 - length(trim(return-value))) + trim(return-value) ,"x(17)").

{utp/ut-liter.i Valor_Mat}
assign c-valor-mat = string(fill(" ",15 - length(trim(return-value))) + trim(return-value) ,"x(15)")
       c-cab-razao = c-cab-razao + string( fill(" ",12 - length(trim(return-value))) + trim(return-value),"x(14)").

{utp/ut-liter.i Valor_MOB}
assign c-valor-mob = string(fill(" ",17 - length(trim(return-value))) + trim(return-value) ,"x(17)")
       c-cab-razao = c-cab-razao + string( fill(" ",12 - length(trim(return-value))) + trim(return-value),"x(14)").

{utp/ut-liter.i Valor_GGF}
assign c-valor-ggf = string(fill(" ",15 - length(trim(return-value))) + trim(return-value) ,"x(15)")
       c-cab-razao = c-cab-razao + string( fill(" ",13 - length(trim(return-value))) + trim(return-value),"x(14)").

run utp/ut-acomp.p persistent set h-acomp.

/* Verifica formato do campo "nr-ord-produ" */

{include/i-rpvar.i}

if  not avail param-global then
    find first param-global no-lock no-error.

find first param-estoq  no-lock no-error.

&if defined(bf_mat_fech_estab) &then
    /* Release 2.03 - Digitacao de Estabelecimentos */
    for each tt-raw-digita:
        create tt-digita.
        raw-transfer tt-raw-digita.raw-digita to tt-digita.
    end.
    if can-find(first tt-digita) then
        assign c-estabelec = ",".
    if can-find(first tt-digita) then
    for each tt-digita no-lock:        
        assign c-estabelec = c-estabelec + tt-digita.cod-estabel + ",".
    end.

    if param-estoq.tp-fech = 2 then 
        assign i-tp-fech = 2.
    else 
        assign i-tp-fech = 1.
&else 
    assign i-tp-fech = 1.
&endif.

find mguni.empresa where empresa.ep-codigo = param-global.empresa-prin no-lock.

if available empresa then
   c-empresa = empresa.razao-social.
{utp/ut-liter.i Relacao_dos_Itens_Criticos}   
assign c-titulo-relat = trim(return-value).


{utp/ut-liter.i ESTOQUE}
assign c-sistema      = trim(return-value)
       c-programa     = "CE/0304"
       c-versao       = ""
       c-revisao      = "".

run utp/ut-trfrrp.p (input frame f-saldo:handle).
run utp/ut-trfrrp.p (input frame f-razao:handle).
run utp/ut-trfrrp.p (input frame f-cab-razao:handle).
run utp/ut-trfrrp.p (input frame f-resumo-medio:handle).
run utp/ut-trfrrp.p (input frame f-acerto:handle).
run utp/ut-trfrrp.p (input frame f-cab-resumo:handle).
run utp/ut-trfrrp.p (input frame f-item:handle).
run utp/ut-trfrrp.p (input frame f-grupo-estoq:handle).
run utp/ut-trfrrp.p (input frame f-impressao:handle).
run utp/ut-trfrrp.p (input frame f-parametro:handle).
run utp/ut-trfrrp.p (input frame f-selecao:handle).
{include/i-rpcab.i}
{include/i-rpout.i}

if i-tp-fech = 1 then do:
    {esp/cep/ce9998.i}
end.
else do:
    &if defined(bf_mat_fech_estab) &then
        find first tt-digita no-lock no-error.
        if avail tt-digita then do:
            find estab-mat where
                 estab-mat.cod-estabel = tt-digita.cod-estabel no-lock no-error.            
            assign da-iniper-x = (estab-mat.ult-fech-dia + 1).
            if month(da-iniper-x) = 12 then
                assign da-fimper-x = date(01,01,year(da-iniper-x) + 1) - 1.
            else
                assign da-fimper-x = date(month(da-iniper-x) + 1,01,year(da-iniper-x)) - 1.
            assign i-per-corrente = month(da-iniper-x)
                   i-ano-corrente = year(da-iniper-x).
        end.
        ELSE DO:
           find first estab-mat where
                 estab-mat.cod-estabel >= tt-param.c-estab-ini AND
                 estab-mat.cod-estabel <= tt-param.c-estab-fim no-lock no-error.            
            assign da-iniper-x = (estab-mat.ult-fech-dia + 1).
            if month(da-iniper-x) = 12 then
                assign da-fimper-x = date(01,01,year(da-iniper-x) + 1) - 1.
            else
                assign da-fimper-x = date(month(da-iniper-x) + 1,01,year(da-iniper-x)) - 1.
            assign i-per-corrente = month(da-iniper-x)
                   i-ano-corrente = year(da-iniper-x).
        END.
    &endif
end.

assign c-traco-1 = fill("-",130).

assign da-ini-per  = da-iniper-x
       da-fim-per  = da-fimper-x
       da-data-ini = da-ini-per
       da-data-fin = da-fim-per. 

/***    
hide frame f-saida    no-pause.
hide frame f-nome     no-pause.
hide frame f-param    no-pause.  ***/
hide frame f-selecao  no-pause. 

/***
hide frame f-selecao2 no-pause. ***/
hide message no-pause.

assign c-item-aux  = ""
       c-estab-aux = ""
       i-ge-aux    = 0
       l-pagina    = yes.
page.
view frame f-cabec.
view frame f-rodape.

{utp/ut-liter.i Relat¢rio_de_Itens_Cr¡ticos * L}
run pi-inicializar in h-acomp(input trim(return-value)).

/*Parametriza‡Æo Chile*/
if tt-param.i-moeda = 0 then assign moeda = 0.
if tt-param.i-moeda = 1 then assign moeda = param-estoq.moeda1.
if tt-param.i-moeda = 2 then assign moeda = param-estoq.moeda2.

/*Salta p gina a cada item*/
assign l-pular-pag = tt-param.l-pagina.
if c-estabelec <> " " then
  if  tt-param.i-ge-ini = 0 and
      tt-param.i-ge-fim = 99 then
      open query q-item-estab 
      for each item-estab
          where item-estab.cod-estabel = tt-digita.cod-estabel
            and item-estab.it-codigo  >= tt-param.c-item-ini
            and item-estab.it-codigo  <= tt-param.c-item-fim,
          first item 
          where item.it-codigo = item-estab.it-codigo
          &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
              and item.fm-codigo >= tt-param.c-fm-cod-ini  
              and item.fm-codigo <= tt-param.c-fm-cod-fim
  
          &ENDIF 
              and item.tipo-contr = 2  NO-LOCK. /*on stop undo, leave*/
  else
      open query q-item-estab 
      for each item-estab
          where item-estab.cod-estabel = tt-digita.cod-estabel
            and item-estab.it-codigo  >= tt-param.c-item-ini
            and item-estab.it-codigo  <= tt-param.c-item-fim,
          first item 
          where item.it-codigo = item-estab.it-codigo
            and item.ge-codigo >= tt-param.i-ge-ini   
            and item.ge-codigo <= tt-param.i-ge-fim   
          &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
              and item.fm-codigo >= tt-param.c-fm-cod-ini  
              and item.fm-codigo <= tt-param.c-fm-cod-fim
  
          &ENDIF 
              and item.tipo-contr = 2  NO-LOCK. /*on stop undo, leave*/
else
    if  tt-param.i-ge-ini = 0 and
        tt-param.i-ge-fim = 99 then
        open query q-item
        for each item use-index codigo where 
                 item.tipo-contr = 2                   and 
                 item.it-codigo >= tt-param.c-item-ini and 
                 item.it-codigo <= tt-param.c-item-fim 
                 &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
                    AND ITEM.fm-codigo >= tt-param.c-fm-cod-ini  
                    AND ITEM.fm-codigo <= tt-param.c-fm-cod-fim  
                &ENDIF NO-LOCK. /*on stop undo, leave*/
    else
        open query q-item
        for each item use-index grupo where 
                 item.ge-codigo >= tt-param.i-ge-ini   and 
                 item.ge-codigo <= tt-param.i-ge-fim   and 
                 item.tipo-contr = 2                   and 
                 item.it-codigo >= tt-param.c-item-ini and 
                 item.it-codigo <= tt-param.c-item-fim 
                 &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
                    AND ITEM.fm-codigo >= tt-param.c-fm-cod-ini  
                    AND ITEM.fm-codigo <= tt-param.c-fm-cod-fim  
                 &ENDIF NO-LOCK
                 by ge-codigo.

ASSIGN l-segue = NO.

if c-estabelec <> " " THEN DO:
    get first q-item-estab.
    IF AVAIL item-estab THEN
        ASSIGN l-segue = YES.
END.
ELSE DO:
    get first q-item.
    IF AVAIL ITEM THEN
        ASSIGN l-segue = YES.

END.

do while l-segue on stop undo, leave:
    run pi-acompanhar in h-acomp (input ITEM.it-codigo).

    assign l-item-por-pag = yes
           de-qtd-tot     = 0.
    if c-estabelec <> " " then    /* usa o tt-digita */
    do:
        run pi-open-saldo (1).
        get first qr-saldo-2.
    end.
    else
    do:
        run pi-open-saldo (2).       
        get first qr-saldo-1.
    end.
    do while avail saldo-estoq:

        assign de-qtd-tot = de-qtd-tot + saldo-estoq.qtidade-ini.

        /* verifica existencia de w-movto-1 a nivel de estabelecimento e item.*/
        do for w-movto:
            find first w-movto where 
                       w-movto.w-cod-estabel = saldo-estoq.cod-estabel no-error.
            if  not avail w-movto then do:
                create w-movto.
                assign w-movto.w-cod-estabel = saldo-estoq.cod-estabel
                       w-movto.w-qtidade     = saldo-estoq.qtidade-ini.
            end.
            else
                assign w-movto.w-qtidade = saldo-estoq.qtidade-ini + w-movto.w-qtidade.

        end. /* do for w-movto */

        /* verifica existencia w-saldo a nivel de estabelecimento, deposito e item    */
        do for w-saldo-ini:
            find first w-saldo-ini where 
                       w-saldo-ini.w-cod-estabel = saldo-estoq.cod-estabel and 
                       w-saldo-ini.w-cod-depos  = saldo-estoq.cod-depos no-error.
            if  not available w-saldo-ini then do:
                create w-saldo-ini.
                assign w-saldo-ini.w-cod-estabel = saldo-estoq.cod-estabel
                       w-saldo-ini.w-cod-depos   = saldo-estoq.cod-depos
                       w-saldo-ini.w-qtidade     = saldo-estoq.qtidade-ini.
            end.
            else
                assign w-saldo-ini.w-qtidade = saldo-estoq.qtidade-ini + w-saldo-ini.w-qtidade.
        end. /* do for w-saldo-ini */

        if c-estabelec <> " " then
            get next qr-saldo-2.
        else
            get next qr-saldo-1.

        /* fim inicializacao de w-saldo e w-movto */
    end. /* while saldo-estoq */

    for each w-movto:

        if not avail item-estab then
            find item-estab where
                 item-estab.it-codigo   = item.it-codigo and
                 item-estab.cod-estabel = w-movto.w-cod-estabel no-lock no-error.
        else
            if item-estab.it-codigo   <> item.it-codigo
            or item-estab.cod-estabel <> w-movto.w-cod-estabel then
                find item-estab where
                     item-estab.it-codigo   = item.it-codigo and
                     item-estab.cod-estabel = w-movto.w-cod-estabel no-lock no-error.

        if  not avail item-estab then do:
            create item-estab.
            assign item-estab.it-codigo   = item.it-codigo
                   item-estab.cod-estabel = w-movto.w-cod-estabel.
        end.

        /* Valores utilizados p/calculo do medio do estab. */

        if  de-qtd-tot <>  0  then 
            assign w-movto.w-valor-mat-m[tt-param.i-mo] = item-estab.sald-ini-mat-m[tt-param.i-mo]
                   w-movto.w-valor-mob-m[tt-param.i-mo] = item-estab.sald-ini-mob-m[tt-param.i-mo]
                   w-movto.w-valor-ggf-m[tt-param.i-mo] = item-estab.sald-ini-ggf-m[tt-param.i-mo].

        /* Valores utilizados p/calculo do saldo inicial. */

            assign de-maior-qtd   = 0
                   r-maior-qtd    = ?
                   de-tot-val-mat = item-estab.sald-ini-mat-m[tt-param.i-mo]
                   de-tot-val-mob = item-estab.sald-ini-mob-m[tt-param.i-mo]
                   de-tot-val-ggf = item-estab.sald-ini-ggf-m[tt-param.i-mo].

        for each w-saldo-ini where
                 w-saldo-ini.w-cod-estabel = w-movto.w-cod-estabel:

            if  w-movto.w-qtidade <> 0 then do:
                assign w-saldo-ini.w-valor-mat-m[tt-param.i-mo] = if item-estab.sald-ini-mat-m[tt-param.i-mo] <> 0 then
                                                                    FN_AJUST_DEC((item-estab.sald-ini-mat-m[tt-param.i-mo] / 
                                                                    w-movto.w-qtidade) * w-saldo-ini.w-qtidade,moeda)
                                                                else 0 .

                 assign w-saldo-ini.w-valor-mob-m[tt-param.i-mo] = if item-estab.sald-ini-mob-m[tt-param.i-mo] <> 0 then
                                                                   FN_AJUST_DEC((item-estab.sald-ini-mob-m[tt-param.i-mo] / 
                                                                    w-movto.w-qtidade) * w-saldo-ini.w-qtidade,moeda)
                                                                else 0.

                 assign  w-saldo-ini.w-valor-ggf-m[tt-param.i-mo] = if item-estab.sald-ini-ggf-m[tt-param.i-mo] <> 0 then
                                                                  FN_AJUST_DEC((item-estab.sald-ini-ggf-m[tt-param.i-mo] / 
                                                                    w-movto.w-qtidade) * w-saldo-ini.w-qtidade,moeda)
                                                                else 0.
              end.                                                  
            else
                assign w-saldo-ini.w-valor-mat-m[tt-param.i-mo] = 0
                       w-saldo-ini.w-valor-mob-m[tt-param.i-mo] = 0                
                       w-saldo-ini.w-valor-ggf-m[tt-param.i-mo] = 0.

                assign de-tot-val-mat = de-tot-val-mat - w-saldo-ini.w-valor-mat-m[tt-param.i-mo]
                       de-tot-val-mob = de-tot-val-mob - w-saldo-ini.w-valor-mob-m[tt-param.i-mo]
                       de-tot-val-ggf = de-tot-val-ggf - w-saldo-ini.w-valor-ggf-m[tt-param.i-mo].

                assign de-tot-val-mat =  FN_AJUST_DEC(de-tot-val-mat,moeda). 
                assign de-tot-val-mob =  FN_AJUST_DEC(de-tot-val-mob,moeda).
                assign de-tot-val-ggf =  FN_AJUST_DEC(de-tot-val-ggf,moeda).                      



            /* Localiza registro c/ maior movimento de quantidade p/ posterior rateio da diferenca de valorizacao.*/

            if w-saldo-ini.w-qtidade > de-maior-qtd then
                assign de-maior-qtd   = w-saldo-ini.w-qtidade
                       r-maior-qtd   = rowid(w-saldo-ini).

        end. /* for each w-saldo-ini */


        /* Rateio da diferenca da valorizacao do MAT ,MOB E GGF */

        if (de-tot-val-mat > 0  or de-tot-val-mob > 0 or de-tot-val-ggf > 0) and r-maior-qtd   <> ? then do:                         
            do for w-saldo-ini:
                find first w-saldo-ini where
                    rowid(w-saldo-ini) = r-maior-qtd no-lock no-error.
                w-saldo-ini.w-valor-mat-m[tt-param.i-mo] = w-saldo-ini.w-valor-mat-m[tt-param.i-mo] + de-tot-val-mat.    
                w-saldo-ini.w-valor-mob-m[tt-param.i-mo] = w-saldo-ini.w-valor-mob-m[tt-param.i-mo] + de-tot-val-mob.
                w-saldo-ini.w-valor-ggf-m[tt-param.i-mo] = w-saldo-ini.w-valor-ggf-m[tt-param.i-mo] + de-tot-val-ggf.
            end. /* do for w-saldo-ini */
        end. /* if */

    end. /* for each w-movto */

    do for w-saldo:
        for each w-saldo:
            delete w-saldo.
        end.
    end.

    for each w-saldo-ini:
        create w-saldo.
        assign w-saldo.w-cod-estabel              = w-saldo-ini.w-cod-estabel
               w-saldo.w-cod-depos                = w-saldo-ini.w-cod-depos
               w-saldo.w-qtidade                  = w-saldo-ini.w-qtidade
               w-saldo.w-valor-mat-m[tt-param.i-mo] = w-saldo-ini.w-valor-mat-m[tt-param.i-mo]
               w-saldo.w-valor-mob-m[tt-param.i-mo] = w-saldo-ini.w-valor-mob-m[tt-param.i-mo]
               w-saldo.w-valor-ggf-m[tt-param.i-mo] = w-saldo-ini.w-valor-ggf-m[tt-param.i-mo].
    end.
    assign l-acerto = no.
    do da-dt-aux = da-data-ini to da-data-fin:

        if c-estabelec <> " " then    /* usa o tt-digita */
        do:
            run pi-open-movto (1).
            get first qr-movto-2.
        end.
        else
        do:
            run pi-open-movto (2).       
            get first qr-movto-1.
        end.

        do while avail movto-estoq:

            {esp/cep/ce9997.i "movto-estoq" "-m" 
                "if c-estabelec <> ' ' then
                     get next qr-movto-2.
                 else
                     get next qr-movto-1"
                "tt-param.i-moeda + 1"}

            if  movto-estoq.esp-docto      =  2     and 
                int(movto-estoq.nro-docto) <  900   and 
                movto-estoq.dt-trans       <> da-data-ini then 
                assign l-acerto = yes.

            do for w-movto:
                find first w-movto where 
                           w-movto.w-cod-estabel = movto-estoq.cod-estabel no-lock no-error.

                if not avail w-movto then
                do: 
                    if c-estabelec <> " " then
                        get next qr-movto-2.
                    else
                        get next qr-movto-1.
                    next.
                end.

                if movto-estoq.valor-mat-m[tt-param.i-mo] <> 0  or
                   movto-estoq.valor-mob-m[tt-param.i-mo] <> 0  or
                   movto-estoq.valor-ggf-m[tt-param.i-mo] <> 0  then do:
                    if movto-estoq.tipo-trans = 1 then
                        assign w-movto.w-valor-mat-m[tt-param.i-mo] = w-movto.w-valor-mat-m[tt-param.i-mo] + 
                                                                    movto-estoq.valor-mat-m[tt-param.i-mo]
                               w-movto.w-valor-mob-m[tt-param.i-mo] = w-movto.w-valor-mob-m[tt-param.i-mo] + 
                                                                    movto-estoq.valor-mob-m[tt-param.i-mo]                                     
                               w-movto.w-valor-ggf-m[tt-param.i-mo] = w-movto.w-valor-ggf-m[tt-param.i-mo] + 
                                                                    movto-estoq.valor-ggf-m[tt-param.i-mo]
                               w-movto.w-qtidade = w-movto.w-qtidade + movto-estoq.quantidade
                               w-movto.w-de-var-tot = w-movto.w-de-var-tot + 
                                                      movto-estoq.valor-mat-m[tt-param.i-mo] + 
                                                      movto-estoq.valor-mob-m[tt-param.i-mo] +
                                                      movto-estoq.valor-ggf-m[tt-param.i-mo].
                    else
                        assign w-movto.w-valor-mat-m[tt-param.i-mo] = w-movto.w-valor-mat-m[tt-param.i-mo] - 
                                                                    movto-estoq.valor-mat-m[tt-param.i-mo]
                               w-movto.w-valor-mob-m[tt-param.i-mo] = w-movto.w-valor-mob-m[tt-param.i-mo] - 
                                                                    movto-estoq.valor-mob-m[tt-param.i-mo]                                     
                               w-movto.w-valor-ggf-m[tt-param.i-mo] = w-movto.w-valor-ggf-m[tt-param.i-mo] - 
                                                                    movto-estoq.valor-ggf-m[tt-param.i-mo]
                               w-movto.w-qtidade = w-movto.w-qtidade - movto-estoq.quantidade
                               w-movto.w-de-var-tot = w-movto.w-de-var-tot - 
                                                      movto-estoq.valor-mat-m[tt-param.i-mo] -
                                                      movto-estoq.valor-mob-m[tt-param.i-mo] -                                                     
                                                      movto-estoq.valor-ggf-m[tt-param.i-mo].
                end. /* if */
                if movto-estoq.esp-docto = 1 then 
                    assign w-movto.w-movto-aca = yes.
            end. /* do for w-movto */

            do for w-saldo:
                find first w-saldo where
                           w-saldo.w-cod-estabel = movto-estoq.cod-estabel and
                           w-saldo.w-cod-depos   = movto-estoq.cod-depos no-lock no-error.

                if  avail w-saldo then do:
                    if movto-estoq.tipo-trans = 1 then
                        assign w-saldo.w-qtidade = w-saldo.w-qtidade + movto-estoq.quantidade
                               w-saldo.w-valor-mat-m[tt-param.i-mo] = w-saldo.w-valor-mat-m[tt-param.i-mo] + 
                                                                    movto-estoq.valor-mat-m[tt-param.i-mo]
                               w-saldo.w-valor-mob-m[tt-param.i-mo] = w-saldo.w-valor-mob-m[tt-param.i-mo] + 
                                                                    movto-estoq.valor-mob-m[tt-param.i-mo]                                     
                               w-saldo.w-valor-ggf-m[tt-param.i-mo] = w-saldo.w-valor-ggf-m[tt-param.i-mo] + 
                                                                    movto-estoq.valor-ggf-m[tt-param.i-mo].
                    else
                        assign w-saldo.w-qtidade = w-saldo.w-qtidade - movto-estoq.quantidade
                               w-saldo.w-valor-mat-m[tt-param.i-mo] = w-saldo.w-valor-mat-m[tt-param.i-mo] - 
                                                                    movto-estoq.valor-mat-m[tt-param.i-mo]
                               w-saldo.w-valor-mob-m[tt-param.i-mo] = w-saldo.w-valor-mob-m[tt-param.i-mo] - 
                                                                    movto-estoq.valor-mob-m[tt-param.i-mo]                                                                    
                               w-saldo.w-valor-ggf-m[tt-param.i-mo] = w-saldo.w-valor-ggf-m[tt-param.i-mo] - 
                                                                    movto-estoq.valor-ggf-m[tt-param.i-mo].
                end. /* if */
            end. /* do for w-saldo */
            if c-estabelec <> " " then
                get next qr-movto-2.
            else
                get next qr-movto-1.

        end. /* for each movto-estoq */
    end. /* do da-dt-aux */     

    l-critico = no.
    for each w-movto:
           if ((w-movto.w-qtidade                    > 0    and 
               (w-movto.w-valor-mat-m[tt-param.i-mo] < 0    or
                w-movto.w-valor-mob-m[tt-param.i-mo] < 0    or
                w-movto.w-valor-ggf-m[tt-param.i-mo] < 0))
           or  
              (w-movto.w-qtidade                     < 0    and
              (w-movto.w-valor-mat-m[tt-param.i-mo]  > 0    or   
               w-movto.w-valor-mob-m[tt-param.i-mo]  > 0    or
               w-movto.w-valor-ggf-m[tt-param.i-mo]  > 0))
           or
              (w-movto.w-valor-mat-m[tt-param.i-mo]  =  0   and
               w-movto.w-valor-mob-m[tt-param.i-mo]  =  0   and  
               w-movto.w-valor-ggf-m[tt-param.i-mo]  =  0   and
               w-movto.w-qtidade                     <> 0) 
           or   
              (w-movto.w-qtidade                     =  0   and  
               w-movto.w-valor-mat-m[tt-param.i-mo]  <> 0) 

           or   
              (w-movto.w-qtidade                     =  0   and  
               w-movto.w-valor-mob-m[tt-param.i-mo]  <> 0) 

           or  
              (w-movto.w-qtidade                     =  0   and
               w-movto.w-valor-ggf-m[tt-param.i-mo]  <> 0))

           and (w-movto.w-movto-aca = no) 
           then
              assign l-critico = yes.
       end.  

      for each w-movto while l-critico = no:
          if w-movto.w-movto-aca = no then 
             if (w-movto.w-qtidade                    < 0    or 
                 w-movto.w-valor-mat-m[tt-param.i-mo] < 0    or
                 w-movto.w-valor-mob-m[tt-param.i-mo] < 0    or
                 w-movto.w-valor-ggf-m[tt-param.i-mo] < 0) 
             then 
                assign l-critico = yes.
             else do:
                assign de-valor-tot = w-movto.w-valor-mat-m[tt-param.i-mo] +
                                      w-movto.w-valor-mob-m[tt-param.i-mo] +
                                      w-movto.w-valor-ggf-m[tt-param.i-mo].
                if (w-movto.w-qtidade  = 0 and de-valor-tot <> 0) or
                   (w-movto.w-qtidade <> 0 and de-valor-tot <= 0) then   
                   assign l-critico = yes.
             end.
       end.            

    if l-critico = no then

        for each w-saldo where w-saldo.w-qtidade < 0 while l-critico = no:
            assign l-critico = yes. 
        end.

        if  (l-critico = yes and tt-param.l-crit = yes) or 
            (tt-param.l-acer = yes and l-acerto = yes) then  do:
            find grup-estoq where
                 grup-estoq.ge-codigo = item.ge-codigo no-lock no-error.

            if  item.ge-codigo <> i-ge-cod-ant or
                l-primeira                     or 
               (l-pular-pag and l-item-por-pag) then do:
                assign i-ge-cod-ant = item.ge-codigo
                       l-primeira   = no.
                page.
                view frame f-cabec.
                view frame f-rodape.
                display grup-estoq.ge-codigo
                        grup-estoq.descricao
                        c-traco-1 
                        with stream-io frame f-grupo-estoq.
            end.
            else  put " " skip.

            assign l-item-por-pag = no.

            display item.it-codigo
                    item.un
                    item.desc-item
                    item.cod-localiz with stream-io frame f-item.

            display c-resumo 
                    c-traco-1 
                    c-quantidade
                    c-valor-mat 
                    c-valor-mob 
                    c-valor-ggf 
               with stream-io frame f-cab-resumo.
            {utp/ut-liter.i Medio MCE}
            assign c-form-1 = trim(return-value).
            {utp/ut-liter.i Est}
            assign l-mostra = yes
                   c-form-1 = c-form-1 + " - " + trim(return-value) + ":".

            for each w-movto no-lock:

                if not avail estabelec then
                    find estabelec where 
                         estabelec.cod-estabel = w-movto.w-cod-estabel no-lock no-error.
                else
                    if w-movto.w-cod-estabel <> estabelec.cod-estabel then
                        find estabelec where 
                             estabelec.cod-estabel = w-movto.w-cod-estabel no-lock no-error.

                {esp/cep/escep999.i1} 

                assign w-movto.w-valor-mat-m[1] =  FN_AJUST_DEC(w-movto.w-valor-mat-m[1],param-estoq.moeda1). 
                assign w-movto.w-valor-mob-m[1] =  FN_AJUST_DEC(w-movto.w-valor-mob-m[1],param-estoq.moeda1).
                assign w-movto.w-valor-ggf-m[1] =  FN_AJUST_DEC(w-movto.w-valor-ggf-m[1],param-estoq.moeda1).                      


                display c-form-1 when l-mostra = yes
                        w-movto.w-cod-estabel
                        estabelec.nome
                        w-movto.w-qtidade
                        w-movto.w-valor-mat-m[tt-param.i-mo] @ w-movto.w-valor-mat-m[1]
                        w-movto.w-valor-mob-m[tt-param.i-mo] @ w-movto.w-valor-mob-m[1] 
                        w-movto.w-valor-ggf-m[tt-param.i-mo] @ w-movto.w-valor-ggf-m[1] 
                        with stream-io frame f-resumo-medio.
                down with stream-io frame f-resumo-medio.

                l-mostra = no.
            end. /* for each w-movto */
            {esp/cep/escep999.i1}
            else put "  " skip.
            {utp/ut-liter.i Saldo_Inicial}
            assign c-form-2 = return-value.
            {utp/ut-liter.i Estabel}
            assign c-form-3 = "- " + return-value + ":".
            {utp/ut-liter.i Deposito}            
            assign c-form-4 = "- " + trim(return-value) + ": ".

            for each w-saldo-ini 
                break by w-saldo-ini.w-cod-estabel:

                {esp/cep/escep999.i1}
                disp c-form-2 when first-of(w-saldo-ini.w-cod-estabel)
                     c-form-3 when first-of(w-saldo-ini.w-cod-estabel)
                     w-saldo-ini.w-cod-estabel when first-of(w-saldo-ini.w-cod-estabel) @ w-saldo.w-cod-estabel
                     c-form-4 when first-of(w-saldo-ini.w-cod-estabel)
                     w-saldo-ini.w-cod-depos @ w-saldo.w-cod-depos
                     w-saldo-ini.w-qtidade   @ w-saldo.w-qtidade
                     w-saldo-ini.w-valor-mat-m[tt-param.i-mo] @ w-saldo.w-valor-mat-m[1]
                     w-saldo-ini.w-valor-mob-m[tt-param.i-mo] @ w-saldo.w-valor-mob-m[1]
                     w-saldo-ini.w-valor-ggf-m[tt-param.i-mo] @ w-saldo.w-valor-ggf-m[1] with stream-io frame f-saldo.
                down with stream-io frame f-saldo.
            end.
            {esp/cep/escep999.i1}
            else put " " skip.
            
            if  line-counter > (page-size - 1) then do:
                page.
                view frame f-cabec.
                view frame f-rodape.
                display grup-estoq.ge-codigo
                        grup-estoq.descricao
                        c-traco-1 with stream-io frame f-grupo-estoq.
                display item.it-codigo
                        item.un
                        item.desc-item
                        with stream-io frame f-item.
            end.
            c-ponto-1 = ".".


            do da-dt-aux = da-data-ini to da-data-fin:
                if c-estabelec <> " " then    /* usa o tt-digita */
                do:
                    run pi-open-movto (1).
                    get first qr-movto-2.
                end.
                else
                do:
                    run pi-open-movto (2).       
                    get first qr-movto-1.
                end.
                do while avail movto-estoq:

                    if not l-cab then do:
                       display c-cab-razao with frame f-cab-razao.    
                       assign l-cab = yes.
                    end.     

                    if  movto-estoq.esp-docto = 2
                    and movto-estoq.dt-trans  = da-data-fin then
                    do: 
                        if c-estabelec <> " " then
                            get next qr-movto-2.
                        else
                            get next qr-movto-1.
                        next.
                    end.                       

                    {esp/cep/ce9997.i "movto-estoq" "-m" 
                        " if c-estabelec <> ' ' then
                              get next qr-movto-2.
                          else
                              get next qr-movto-1 " 
                        "tt-param.i-moeda + 1"}

                    /*if movto-estoq.esp-docto = 2 then do :                     
                       assign i-tamanho = length(movto-estoq.nro-docto).

                       if substring(movto-estoq.nro-docto,1,1) <> "3" and 
                          i-tamanho = 1 then next.

                       if i-tamanho = 2 and 
                          substring(movto-estoq.nro-docto,2,1) <> string(i-moeda) 
                       or
                          i-tamanho = 3 and 
                          substring(movto-estoq.nro-docto,3,1) <> string(i-moeda)
                       then next.                          
                    end.      
                    */

                    if  movto-estoq.tipo-trans = 1 then do:
                        {utp/ut-liter.i E MCE}
                        c-trans = trim(return-value).
                    end.   
                    else do:
                        {utp/ut-liter.i S MCE}
                        c-trans = trim(return-value).
                    end.    

                    assign i-dia = day(movto-estoq.dt-trans)
                           i-mes = month(movto-estoq.dt-trans)
                           c-data = string(i-dia,"99") + "/" +
                                    string(i-mes,"99").
                    
                    if  line-counter > (page-size - 1) then do:
                        page.
                        view frame f-cabec.
                        view frame f-rodape.
                        display grup-estoq.ge-codigo
                                grup-estoq.descricao
                                c-traco-1 with stream-io frame f-grupo-estoq.
                        display item.it-codigo
                                item.un
                                item.desc-item with stream-io frame f-item.

                        display c-cab-razao with frame f-cab-razao.    

                    end.

                    

                    assign de-valor-mat-m = movto-estoq.valor-mat-m[tt-param.i-mo]
                           de-valor-mob-m = movto-estoq.valor-mob-m[tt-param.i-mo]                    
                           de-valor-ggf-m = movto-estoq.valor-ggf-m[tt-param.i-mo].

                    if movto-estoq.esp-docto >= 19 and movto-estoq.esp-docto <= 23 then 
                        assign de-numero-ordem = string(movto-estoq.numero-ordem,"zzz,zz9,99").
                    else
                        assign de-numero-ordem = string(movto-estoq.nr-ord-produ).

                    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
                        ASSIGN cAuxTraducao001 = {ininc/i03in218.i 04 movto-estoq.esp-docto}.
                        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                            INPUT "",
                                            INPUT "").
                        ASSIGN  c-esp-docto = RETURN-VALUE.
                    &else
                        ASSIGN c-esp-docto = {ininc/i03in218.i 04 movto-estoq.esp-docto}.
                    &endif

                assign de-valor-mat-m =  FN_AJUST_DEC(de-valor-mat-m,moeda). 
                assign de-valor-mob-m =  FN_AJUST_DEC(de-valor-mob-m,moeda).
                assign de-valor-ggf-m =  FN_AJUST_DEC(de-valor-ggf-m,moeda).      

             

                    display movto-estoq.cod-estabel
                            movto-estoq.cod-depos
                            c-data
                            c-esp-docto 
                            c-trans
                            movto-estoq.serie-docto
                            movto-estoq.nro-docto
                            de-numero-ordem
                            /*##c-conta*/
                            movto-estoq.quantidade
                            de-valor-mat-m
                            de-valor-mob-m
                            de-valor-ggf-m with stream-io frame f-razao.
                    down with stream-io frame f-razao.

                    if c-estabelec <> " " then
                        get next qr-movto-2.
                    else
                        get next qr-movto-1.

                end. /* for each movto-estoq */
            end. /* do da-dt-aux */
            assign l-cab = no.
            {utp/ut-liter.i Saldo_Final}
            assign c-form-2 = return-value.
            put "  " skip.
            for each w-saldo 
                break by w-saldo.w-cod-estabel:

                {esp/cep/escep999.i1}
                disp c-form-2 when first-of(w-saldo.w-cod-estabel)
                     c-form-3 when first-of(w-saldo.w-cod-estabel)
                     w-saldo.w-cod-estabel when first-of(w-saldo.w-cod-estabel)
                     c-form-4 when first-of(w-saldo.w-cod-estabel)
                     w-saldo.w-cod-depos
                     w-saldo.w-qtidade with stream-io frame f-saldo.
                down with stream-io frame f-saldo.
            end.
            if l-acerto then do:
                put "" skip.
                
                if  line-counter > (page-size - 1) then do:
                    page.
                    view frame f-cabec.
                    view frame f-rodape.
                    display grup-estoq.ge-codigo
                            grup-estoq.descricao
                            c-traco-1 with stream-io frame f-grupo-estoq.
                    display item.it-codigo
                            item.un
                            item.desc-item with stream-io frame f-item.
                    display c-transacoes with frame f-acerto.
                end.
                else 
                    display c-transacoes with frame f-acerto.


                do da-dt-aux = da-data-ini to da-data-fin:
                    if c-estabelec <> " " then    /* usa o tt-digita */
                    do:
                        run pi-open-movto-by-esp (1,
                                                  2).
                        get first qr-movto-esp-2.
                    end.
                    else
                    do:
                        run pi-open-movto-by-esp (2,
                                                  2).       
                        get first qr-movto-esp-1.
                    end.
                    do while avail movto-estoq:
                        if int(movto-estoq.nro-docto) < 900 then do:

                            if not l-cab then do:
                               display c-cab-razao with frame f-cab-razao.    
                               assign l-cab = yes.
                            end.     

                            {esp/cep/ce9997.i "movto-estoq" "-m" 
                                " if c-estabelec <> ' ' then
                                      get next qr-movto-esp-2.
                                  else
                                      get next qr-movto-esp-1 " 
                                "tt-param.i-moeda + 1"}

                            /*
                            if movto-estoq.esp-docto = 2 then do :                     
                               assign i-tamanho = length(movto-estoq.nro-docto).

                               if substring(movto-estoq.nro-docto,1,1) <> "3" and 
                                  i-tamanho = 1 then next.

                               if i-tamanho = 2 and 
                                  substring(movto-estoq.nro-docto,2,1) <> string(i-moeda)
                               or
                                  i-tamanho = 3 and 
                                  substring(movto-estoq.nro-docto,3,1) <> string(i-moeda)
                               then next.                          
                            end.      
                            */

                            if  movto-estoq.tipo-trans = 1 then do:
                                {utp/ut-liter.i E MCE}
                                c-trans = trim(return-value).
                            end.   
                            else do:
                               {utp/ut-liter.i S MCE}
                               c-trans = trim(return-value).
                            end.                        
                            assign i-dia = day(movto-estoq.dt-trans)
                                   i-mes = month(movto-estoq.dt-trans)
                                   c-data = string(i-dia,"99") + "/" +
                                            string(i-mes,"99"). 
                            
                            if  line-counter > (page-size - 1) then do:
                                page.
                                view frame f-cabec.
                                view frame f-rodape.
                                display grup-estoq.ge-codigo
                                        grup-estoq.descricao
                                        c-traco-1 with stream-io frame f-grupo-estoq.
                                display item.it-codigo
                                        item.un
                                        item.desc-item with stream-io frame f-item.
                                display c-transacoes with frame f-acerto.
                                display c-cab-razao with frame f-cab-razao.    
                            end.

                            

                            if  movto-estoq.esp-docto >= 19 and 
                                movto-estoq.esp-docto <= 23 then
                                assign de-numero-ordem = string(movto-estoq.numero-ordem,"zzz,zz9,99").
                            else
                                assign de-numero-ordem = string(movto-estoq.nr-ord-produ).

                            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                                DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
                                ASSIGN cAuxTraducao002 = {ininc/i03in218.i 04 movto-estoq.esp-docto}.
                                run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                                    INPUT "",
                                                    INPUT "").
                                ASSIGN  c-esp-docto = RETURN-VALUE.
                            &else
                                ASSIGN c-esp-docto = {ininc/i03in218.i 04 movto-estoq.esp-docto}.
                            &endif


                            disp movto-estoq.cod-estabel
                                 movto-estoq.cod-depos
                                 c-data
                                 c-esp-docto 
                                 c-trans
                                 movto-estoq.serie-docto
                                 movto-estoq.nro-docto
                                 de-numero-ordem
                                 /*##c-conta*/
                                 movto-estoq.quantidade
                                 movto-estoq.valor-mat-m[tt-param.i-mo] @ de-valor-mat-m
                                 movto-estoq.valor-mob-m[tt-param.i-mo] @ de-valor-mob-m
                                 movto-estoq.valor-ggf-m[tt-param.i-mo] @ de-valor-ggf-m 
                                 with stream-io frame f-razao.
                            down with stream-io frame f-razao.
                        end.

                        if c-estabelec <> " " then
                            get next qr-movto-esp-2.
                        else
                            get next qr-movto-esp-1.
                    end. /* do while movto-estoq */
                end. /* do da-dt-aux */
                assign l-cab = no.
            end. /* if l-acerto */
        end. /* if l-critico */
        for each w-movto:
            delete w-movto.
        end.
        for each w-saldo:
            delete w-saldo.
        end.
        for each w-saldo-ini:
            delete w-saldo-ini.
        end.
        IF c-estabelec <> "" THEN DO:
           get NEXT q-item-estab.
           IF NOT AVAIL item-estab THEN
               ASSIGN l-segue = NO.
        END.
        ELSE DO:
           get next q-item.
           IF NOT AVAIL ITEM THEN
               ASSIGN l-segue = NO.
        END.

END. /*do while*/

run pi-finalizar in h-acomp.  

procedure pi-open-movto:
    def input param i-query as integer.

    if i-query = 2 then
        open query qr-movto-1
            for each movto-estoq where 
                     movto-estoq.dt-trans    =  da-dt-aux                and 
                     movto-estoq.it-codigo   =  item.it-codigo           and 
                     movto-estoq.cod-estabel >= tt-param.c-estab-ini     and
                     movto-estoq.cod-estabel <= tt-param.c-estab-fim no-lock.
    else
        open query qr-movto-2
            for each tt-digita,
                each movto-estoq where
                     movto-estoq.dt-trans    =  da-dt-aux                and 
                     movto-estoq.it-codigo   =  item.it-codigo           and 
                     movto-estoq.cod-estabel = tt-digita.cod-estabel no-lock.
end procedure.


procedure pi-open-movto-by-esp:
    def input param i-query as integer.
    def input param p-esp   as integer.

    if i-query = 2 then
        open query qr-movto-esp-1
            for each movto-estoq where 
                     movto-estoq.dt-trans    =  da-dt-aux                and 
                     movto-estoq.it-codigo   =  item.it-codigo           and 
                     movto-estoq.esp-docto   =  p-esp                    and
                     movto-estoq.cod-estabel >= tt-param.c-estab-ini     and
                     movto-estoq.cod-estabel <= tt-param.c-estab-fim no-lock.
    else
        open query qr-movto-esp-2
            for each tt-digita,
                each movto-estoq where
                     movto-estoq.dt-trans    =  da-dt-aux                and 
                     movto-estoq.it-codigo   =  item.it-codigo           and 
                     movto-estoq.esp-docto   =  p-esp                    and
                     movto-estoq.cod-estabel = tt-digita.cod-estabel no-lock.
end procedure.

procedure pi-open-saldo:
    def input param i-query as integer.

    if i-query = 2 then
        open query qr-saldo-1
            for each saldo-estoq where 
                     saldo-estoq.it-codigo   = item.it-codigo        and 
                     saldo-estoq.cod-estabel >= tt-param.c-estab-ini and
                     saldo-estoq.cod-estabel <= tt-param.c-estab-fim no-lock.
    else
        open query qr-saldo-2
            for each tt-digita,
                each saldo-estoq where 
                     saldo-estoq.it-codigo   = item.it-codigo        and 
                     saldo-estoq.cod-estabel = tt-digita.cod-estabel no-lock.
end procedure.

page.

if l-parametro then do:
    {utp/ut-liter.i SELE€ÇO_:}
    assign c-sel = return-value.
    display c-sel
            tt-param.i-ge-ini        tt-param.i-ge-fim 
            tt-param.c-estab-ini     tt-param.c-estab-fim      
            tt-param.c-item-ini      tt-param.c-item-fim       
            &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
                tt-param.c-fm-cod-ini    tt-param.c-fm-cod-fim 
            &ENDIF
            with stream-io frame f-selecao.


    {utp/ut-liter.i PAR¶METRO_:}
    assign c-par = return-value.
    display c-par with stream-io frame f-parametro.

    {utp/ut-liter.i Sim}
    assign c-sim = return-value.

    {utp/ut-liter.i NÆo}
    assign c-nao = return-value.

    if tt-param.l-crit then
       assign c-crit = c-sim.
    else 
       assign c-crit = c-nao.   

    if tt-param.l-acer then
       assign c-acer = c-sim.
    else 
       assign c-acer = c-nao.   

    if tt-param.l-pagina then
       assign c-pagina = c-sim.
    else 
       assign c-pagina = c-nao.   


    {utp/ut-liter.i Cr¡ticos:}
    assign c-labels-1 = return-value.
    display c-labels-1  c-crit  with stream-io frame f-parametro.

    {utp/ut-liter.i Acertos:}
    assign c-labels-2 = return-value.
    display c-labels-2  c-acer  with stream-io frame f-parametro.

    {utp/ut-liter.i Um_item_por_p g.:}
    assign c-labels-3 = trim(return-value).
    display c-labels-3  c-pagina  with stream-io frame f-parametro.

    {utp/ut-liter.i Moeda:}
    assign c-labels-4 = trim(return-value).
    display c-labels-4  tt-param.i-moeda  tt-param.c-moeda  with stream-io frame f-parametro.

    {utp/ut-liter.i IMPRESSÇO_:}
    assign c-imp = return-value.
    display c-imp with stream-io frame f-impressao.

    {utp/ut-liter.i Destino:}
    assign c-labels-2 = return-value.
    display c-labels-2 tt-param.destino tt-param.arquivo with stream-io frame f-impressao.

    {utp/ut-liter.i Usu rio:}
    assign c-labels-1 = return-value.
    display c-labels-1  tt-param.usuario with stream-io frame f-impressao.

    hide message no-pause.
END.
{include/i-rpclo.i} /* Verifica Impressora Escrava */

return "OK".

/* fim-do-programa */





