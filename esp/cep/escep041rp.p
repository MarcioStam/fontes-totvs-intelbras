/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escep041rp 1.00.00.000}  /*** 010020 ***/
/*****************************************************************************
**
**       Programa: escep041rp
**
**       Datas...: Maio de 1997
**
**       Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**       Objetivo: Relatorio de Contagens
**
**       Versao..: 
**
*****************************************************************************/

def temp-table tt-param no-undo
    field destino           as integer format "99"
    field arquivo           as char    format "x(100)"
    field usuario           as char
    field data-exec         as date
    field hora-exec         as integer
    field estq-ini          as integer
    field estq-fim          as integer
    field item-ini          as character
    field item-fim          as character
    field fam-ini           as character
    field fam-fim           as character
    field loca-ini          as character
    field loca-fim          as character
    field lote-ini          as character
    field lote-fim          as character
    field refer-ini         as character
    field refer-fim         as character
    field dep-ini           as character
    field dep-fim           as character
    field estab-ini         as character
    field estab-fim         as character
    field ficha-ini         as integer
    field ficha-fim         as integer
    field classifica        as integer
    field desc-classifica   as char format "x(40)"
    field c-destino         as char
    field lista             as integer
    field contagem-1        as logical
    field contagem-2        as logical
    field contagem-3        as logical
    field lista-qt          as logical
    field saldo             as logical
    field data-saldo-invent as date
    field l-imp-param       as log.

def temp-table tt-raw-digita no-undo
    field raw-digita as raw.

define temp-table tt-digita no-undo
    field cod-estabel   as char      format "x(3)" 
    field nome          as character format "x(40)" 
    index id cod-estabel.

define temp-table tt-dig-imp no-undo LIKE tt-digita.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

{include/i-rpvar.i}
{include/i_dbvers.i}
{cdp/cdcfgmat.i}

def var c-item-aux  like item.it-codigo no-undo. 
def var c-sit       as char format "x(1)" init "".
def var c-ok        as char format "x(02)" init "".
def var c-trac      as char.
def var i-cont      as integer init 0.
def var h-acomp     as handle no-undo.

/************* Variÿveis para as frames *************/
def var c-considera-saldo-zero as char no-undo format "x(30)".
def var c-data-corte-invent    as char no-undo format "x(21)".
def var c-lista-contagem-1     as char no-undo format "x(22)".
def var c-lista-contagem-2     as char no-undo format "x(22)".
def var c-lista-contagem-3     as char no-undo format "x(22)".
def var c-estabelecimento      as char no-undo format "x(15)". 
def var c-saldo-contabil       as char no-undo format "x(14)".
def var c-grupo-estoque        as char no-undo format "x(13)".
def var c-localizacao          as char no-undo format "x(11)".
def var c-contagem-1           as char no-undo format "x(10)".
def var c-contagem-2           as char no-undo format "x(10)".
def var c-contagem-3           as char no-undo format "x(10)".
def var c-descricao            as char no-undo format "x(9)".
def var c-deposito             as char no-undo format "x(8)".
def var c-imprimir             as char no-undo format "x(24)".
def var c-familia              as char no-undo format "x(7)".
def var c-destino              as char no-undo format "x(7)".
def var c-usuario              as char no-undo format "x(7)".
def var c-situac               as char no-undo format "x(3)".
def var c-listar               as char no-undo format "x(30)".
def var c-ficha                as char no-undo format "x(5)".
def var c-param                as char no-undo format "x(14)".
def var c-lote                 as char no-undo format "x(4)".
def var c-refer                as char no-undo format "x(05)". 
def var c-item                 as char no-undo format "x(4)".
def var c-impr                 as char no-undo format "x(14)".
def var c-est                  as char no-undo format "x(3)".
def var c-dep                  as char no-undo format "x(3)".
def var c-cla                  as char no-undo format "x(18)".
def var c-sel                  as char no-undo format "x(8)".
def var c-un                   as char no-undo format "x(2)".
def var l-pag                  as logical no-undo.
def var c-lb-digit             as char no-undo format "x(7)".
def var c-lb-nome              as char no-undo format "x(4)".
def var c-contagem             as char no-undo format "x(10)".

{utp/ut-liter.i Ficha * R}
assign c-ficha = trim(return-value).
{utp/ut-liter.i Est * R}
assign c-est = trim(return-value).
{utp/ut-liter.i Nome * R}
assign c-lb-nome = trim(return-value).
{utp/ut-liter.i Dep * R}
assign c-dep = trim(return-value).
{utp/ut-liter.i Localiza‡Æo * R}
assign c-localizacao = substring(trim(return-value),1,12).
{utp/ut-liter.i Lote * R}
assign c-lote = trim(return-value).
{utp/ut-liter.i Refer * R}
assign c-refer = trim(return-value).
{utp/ut-liter.i Saldo_Cont bil * R}
assign c-saldo-contabil = trim(return-value).
{utp/ut-liter.i Contagem_1 * R}
assign c-contagem-1 = trim(return-value).
{utp/ut-liter.i Contagem_2 * R}
assign c-contagem-2 = trim(return-value).
{utp/ut-liter.i Contagem_3 * R}
assign c-contagem-3 = trim(return-value).
{utp/ut-liter.i Sit * R}
assign c-situac = trim(return-value).
{utp/ut-liter.i Item * R}
assign c-item = trim(return-value).
{utp/ut-liter.i Descri‡Æo * R}
assign c-descricao = trim(return-value).
{utp/ut-liter.i Un * R}
assign c-un = trim(return-value).
{utp/ut-liter.i DIGITA€ÇO mce R}
assign c-lb-digit = trim(return-value).

form inventario.nr-ficha       at 1 format "ZZZZ,ZZ9-"
     item.it-codigo            at 11 format "x(10)"
     "____________"            at 22    
     item.desc-item format "x(50)" at 35
     item.un                   at 86
     inventario.cod-estabel    at 89
     inventario.cod-depos      at 95
     inventario.cod-localiz    at 99
     inventario.lote           at 111
     SKIP
     header c-ficha            at 04
            c-item             at 11
            c-contagem         at 22
            c-descricao        at 35
            c-un               at 86
            c-est              at 89
            c-dep              at 95
            c-localizacao      at 99
            c-lote             at 111
            with stream-io no-box no-label 64 down width 132 frame f-situacao2.

form item.ge-codigo         "-"
     grup-estoque.descricao no-label skip(1)
     with stream-io no-box side-label width 132 fram f-estoque.

form c-item
     item.it-codigo   "-"
     item.desc-item "-"
     item.un
     with stream-io no-box no-label width 132 frame f-item.

form skip
     tt-dig-imp.cod-estabel at 1
     tt-dig-imp.nome        at 5 skip
     with stream-io no-box no-label width 132 frame f-digitacao.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Relat¢rio de Contagens").

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.

    create tt-dig-imp.
    raw-transfer tt-raw-digita.raw-digita to tt-dig-imp.
end.

run utp/ut-trfrrp.p (input frame f-item:handle).
run utp/ut-trfrrp.p (input frame f-situacao2:handle).
{include/i-rpcab.i}

for first param-estoq fields ( ) no-lock: end.

for first param-global fields ( grupo ) no-lock: end.

assign c-empresa  = (if  avail param-global then grupo else "")
       c-programa = "escep041"
       c-versao   = "1.00"
       c-revisao  = "000"
       c-trac     = fill("-",132)
       c-item-aux = "".

{utp/ut-liter.i ESTOQUE * r}
assign c-sistema = trim(return-value).
{utp/ut-liter.i Relat¢rio_de_Contagens * r}
assign c-titulo-relat = trim(return-value).

&IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
    /* se nÆo existir registro em tt-digita, insere*/
    if not can-find(first tt-digita) then do:
        for each estabelec no-lock
            where estabelec.cod-estabel >= tt-param.estab-ini
            and   estabelec.cod-estabel <= tt-param.estab-fim:

            create tt-digita.
            assign tt-digita.cod-estabel = estabelec.cod-estabel
                   tt-digita.nome        = estabelec.nome.
        end.
    end.
&endif


{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

if  no then do:
    find first item no-lock no-error.
    find first grup-estoq no-lock no-error.
end.

if  tt-param.classifica = 1 then do:
    for each inventario 
        fields ( val-apurado[1] val-apurado[2] val-apurado[3] cod-localiz
                 it-codigo      situacao       nr-ficha       cod-estabel 
                 cod-depos      cod-refer      lote           qtidade-atu )
        where inventario.dt-saldo     = tt-param.data-saldo-invent
        &IF '{&BF_MAT_VERSAO_EMS}' < '2.04' &THEN
            and   inventario.cod-estab   >= tt-param.estab-ini
            and   inventario.cod-estab   <= tt-param.estab-fim
        &endif
        and   inventario.cod-depos   >= tt-param.dep-ini
        and   inventario.cod-depos   <= tt-param.dep-fim
        and   inventario.cod-localiz >= tt-param.loca-ini
        and   inventario.cod-localiz <= tt-param.loca-fim
        and   inventario.lote        >= tt-param.lote-ini
        and   inventario.lote        <= tt-param.lote-fim
        and   inventario.cod-refer   >= tt-param.refer-ini
        and   inventario.cod-refer   <= tt-param.refer-fim
        and   inventario.it-codigo   >= tt-param.item-ini
        and   inventario.it-codigo   <= tt-param.item-fim
        and   inventario.nr-ficha    >= tt-param.ficha-ini
        and   inventario.nr-ficha    <= tt-param.ficha-fim
        and  (tt-param.saldo
        or   (not tt-param.saldo and inventario.qtidade-atu <> 0)) no-lock 
            break by inventario.cod-localiz
                  by inventario.cod-estabel
                  by inventario.cod-depos
                  by inventario.it-codigo on stop undo, leave:

        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
            if not can-find(first tt-digita where tt-digita.cod-estabel = inventario.cod-estab) then
                next.
        &endif
       
        if inventario.val-apurado[1] = ? then 
            assign c-contagem = "Contagem 1".
        if inventario.val-apurado[1] <> ? then 
            assign c-contagem = "Contagem 2".
        if inventario.val-apurado[2] <> ? then 
            assign c-contagem = "Contagem 3".
                       
        if  not avail item
        or (    avail item
            and item.it-codigo <> inventario.it-codigo) then
            for first item
                fields (fm-codigo ge-codigo it-codigo desc-item un)
                where item.it-codigo = inventario.it-codigo no-lock:
            end.

        if item.fm-codigo < tt-param.fam-ini
        or item.fm-codigo > tt-param.fam-fim then next.

        if item.ge-codigo < tt-param.estq-ini
        or item.ge-codigo > tt-param.estq-fim then next.

        run pi-acompanhar in h-acomp (input inventario.it-codigo).

        /* RECALCULO DOS SALDOS NA DATA DE CORTE DO INVENTARIO */
        run cep/ce0799.p (input rowid(inventario)).

        l-pag = no.
        if  line-counter = 1
        or  line-counter >= 62
        or  line-counter >= 61 then do:
            if  line-counter >= 61 then do:
                l-pag = yes.
                page.
            end.    
           /*  if  tt-param.lista-qt then */
/*                 disp c-ficha */
/*                      c-est */
/*                      c-dep */
/*                      c-localizacao */
/*                      c-lote */
/*                      c-refer */
/*                      c-saldo-contabil */
/*                      c-contagem-1 */
/*                      c-contagem-2 */
/*                      c-contagem-3 */
/*                      c-situac */
/*                      c-trac */
/*                      with frame f-cab. */
        end.
        {esp/cep/escep041.i}
    end.
end.
if  tt-param.classifica = 2 then  do:
    for each inventario 
        fields ( val-apurado[1] val-apurado[2] val-apurado[3] cod-localiz
                 it-codigo      situacao       nr-ficha       cod-estabel 
                 cod-depos      cod-refer      lote           qtidade-atu )
        where inventario.dt-saldo     = tt-param.data-saldo-invent
        &IF '{&BF_MAT_VERSAO_EMS}' < '2.04' &THEN
            and   inventario.cod-estab   >= tt-param.estab-ini
            and   inventario.cod-estab   <= tt-param.estab-fim
        &endif
        and   inventario.cod-depos   >= tt-param.dep-ini
        and   inventario.cod-depos   <= tt-param.dep-fim
        and   inventario.cod-localiz >= tt-param.loca-ini
        and   inventario.cod-localiz <= tt-param.loca-fim
        and   inventario.lote        >= tt-param.lote-ini
        and   inventario.lote        <= tt-param.lote-fim
        and   inventario.cod-refer   >= tt-param.refer-ini
        and   inventario.cod-refer   <= tt-param.refer-fim
        and   inventario.it-codigo   >= tt-param.item-ini
        and   inventario.it-codigo   <= tt-param.item-fim
        and   inventario.nr-ficha    >= tt-param.ficha-ini
        and   inventario.nr-ficha    <= tt-param.ficha-fim
        and  (tt-param.saldo
        or   (not tt-param.saldo and inventario.qtidade-atu <> 0)) no-lock 
            break by inventario.it-codigo 
                  by inventario.cod-estabel
                  by inventario.cod-depos
                  by inventario.cod-localiz 
                  by inventario.nr-ficha on stop undo, leave: 

        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
            if not can-find(first tt-digita where tt-digita.cod-estabel = inventario.cod-estab) then
                next.
        &endif

        if  not avail item
        or (    avail item 
            and item.it-codigo <> inventario.it-codigo) then
            for first item
                fields (fm-codigo ge-codigo it-codigo desc-item un)
                where item.it-codigo = inventario.it-codigo no-lock:
            end.

        if item.fm-codigo < tt-param.fam-ini
        or item.fm-codigo > tt-param.fam-fim then next.

        if item.ge-codigo < tt-param.estq-ini
        or item.ge-codigo > tt-param.estq-fim then next.

        run pi-acompanhar in h-acomp (input item.it-codigo).       

        /* RECALCULO DOS SALDOS NA DATA DE CORTE DO INVENTARIO */
        run cep/ce0799.p (input rowid(inventario)).

        l-pag = no.
        if  line-counter = 1
        or  line-counter >= 61 then do:
            l-pag = yes.            
            page.
            /* if  tt-param.lista-qt then */
/*                 disp c-ficha */
/*                      c-est */
/*                      c-dep */
/*                      c-localizacao */
/*                      c-lote */
/*                      c-refer */
/*                      c-saldo-contabil */
/*                      c-contagem-1 */
/*                      c-contagem-2 */
/*                      c-contagem-3 */
/*                      c-situac */
/*                      c-trac */
/*                      with frame f-cab. */
        end.
        {esp/cep/escep041.i}
    end.
end.
if  tt-param.classifica = 3 then do:
    for each inventario 
        fields ( val-apurado[1] val-apurado[2] val-apurado[3] cod-localiz
                 it-codigo      situacao       nr-ficha       cod-estabel 
                 cod-depos      cod-refer      lote           qtidade-atu )
        where inventario.dt-saldo     = tt-param.data-saldo-invent
        &IF '{&BF_MAT_VERSAO_EMS}' < '2.04' &THEN
            and   inventario.cod-estab   >= tt-param.estab-ini
            and   inventario.cod-estab   <= tt-param.estab-fim
        &endif
        and   inventario.cod-depos   >= tt-param.dep-ini
        and   inventario.cod-depos   <= tt-param.dep-fim
        and   inventario.cod-localiz >= tt-param.loca-ini
        and   inventario.cod-localiz <= tt-param.loca-fim
        and   inventario.lote        >= tt-param.lote-ini
        and   inventario.lote        <= tt-param.lote-fim
        and   inventario.cod-refer   >= tt-param.refer-ini
        and   inventario.cod-refer   <= tt-param.refer-fim
        and   inventario.it-codigo   >= tt-param.item-ini
        and   inventario.it-codigo   <= tt-param.item-fim
        and   inventario.nr-ficha    >= tt-param.ficha-ini
        and   inventario.nr-ficha    <= tt-param.ficha-fim
        and  (tt-param.saldo
        or   (not tt-param.saldo and inventario.qtidade-atu <> 0)) no-lock ,
        each item of inventario  
            where item.fm-codigo >= tt-param.fam-ini
            and   item.fm-codigo <= tt-param.fam-fim
            and   item.ge-codigo >= tt-param.estq-ini
            and   item.ge-codigo <= tt-param.estq-fim no-lock
            break by item.ge-codigo 
                  by item.it-codigo
                  by inventario.cod-estabel
                  by inventario.cod-depos
                  by inventario.cod-localiz on stop undo, leave:

        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
            if not can-find(first tt-digita where tt-digita.cod-estabel = inventario.cod-estab) then
                next.
        &endif

        run pi-acompanhar in h-acomp (input string(item.ge-codigo)). 

        /* RECALCULO DOS SALDOS NA DATA DE CORTE DO INVENTARIO */
        run cep/ce0799.p (input rowid(inventario)).

        l-pag = no. 
        if  first-of(item.ge-codigo)
        or  line-counter >= 62 then do:
          if line-counter >= 62 then page.
            assign l-pag = yes.

            if  not avail grup-estoque 
            or (    avail grup-estoque 
                and grup-estoque.ge-codigo <> item.ge-codigo ) then
                for first grup-estoque
                    fields ( ge-codigo descricao )
                    where grup-estoque.ge-codigo = item.ge-codigo no-lock:
                end.

            if  avail grup-estoque then do:
                disp item.ge-codigo 
                     grup-estoque.descricao
                     with fram f-estoque.
                /* if  tt-param.lista-qt then */
/*                     disp c-ficha */
/*                          c-est */
/*                          c-dep */
/*                          c-localizacao */
/*                          c-lote */
/*                          c-refer */
/*                          c-saldo-contabil */
/*                          c-contagem-1 */
/*                          c-contagem-2 */
/*                          c-contagem-3 */
/*                          c-situac */
/*                          c-trac */
/*                          with frame f-cab. */
            end.
        end. 
        {esp/cep/escep041.i}
        if  last-of(item.ge-codigo) then do:
            l-pag = yes.
            page.
        end.    
    end.
end.
if  tt-param.classifica = 4 then do:
    for each  inventario 
        fields ( val-apurado[1] val-apurado[2] val-apurado[3] cod-localiz
                 it-codigo      situacao       nr-ficha       cod-estabel 
                 cod-depos      cod-refer      lote           qtidade-atu )
        where inventario.dt-saldo     = tt-param.data-saldo-invent
        &IF '{&BF_MAT_VERSAO_EMS}' < '2.04' &THEN
            and   inventario.cod-estab   >= tt-param.estab-ini
            and   inventario.cod-estab   <= tt-param.estab-fim
        &endif
        and   inventario.cod-depos   >= tt-param.dep-ini
        and   inventario.cod-depos   <= tt-param.dep-fim
        and   inventario.cod-localiz >= tt-param.loca-ini
        and   inventario.cod-localiz <= tt-param.loca-fim
        and   inventario.lote        >= tt-param.lote-ini
        and   inventario.lote        <= tt-param.lote-fim
        and   inventario.cod-refer   >= tt-param.refer-ini
        and   inventario.cod-refer   <= tt-param.refer-fim
        and   inventario.it-codigo   >= tt-param.item-ini
        and   inventario.it-codigo   <= tt-param.item-fim
        and   inventario.nr-ficha    >= tt-param.ficha-ini
        and   inventario.nr-ficha    <= tt-param.ficha-fim
        and  (tt-param.saldo
        or   (not tt-param.saldo and inventario.qtidade-atu <> 0)) no-lock 
            break by inventario.nr-ficha
                  by inventario.cod-estabel
                  by inventario.cod-depos
                  by inventario.cod-localiz on stop undo, leave:

        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
            if not can-find(first tt-digita where tt-digita.cod-estabel = inventario.cod-estab) then
                next.
        &endif

        if  not avail item
        or (    avail item 
            and item.it-codigo <> inventario.it-codigo) then
            for first item
                fields (fm-codigo ge-codigo it-codigo desc-item un)
                where item.it-codigo = inventario.it-codigo no-lock:
            end.

        if item.fm-codigo < tt-param.fam-ini
        or item.fm-codigo > tt-param.fam-fim then next.

        if item.ge-codigo < tt-param.estq-ini
        or item.ge-codigo > tt-param.estq-fim then next.

        run pi-acompanhar in h-acomp (input string(inventario.nr-ficha)).

        /* RECALCULO DOS SALDOS NA DATA DE CORTE DO INVENTARIO */
        run cep/ce0799.p (input rowid(inventario)). 

        l-pag = no.
        if  line-counter  = 1
        or  line-counter >= 62
        or  line-counter >= 61 then do:
            if  line-counter >= 61 then do:
                l-pag = yes.
                page.
            end.
            /* if  tt-param.lista-qt then */
/*                 disp c-ficha */
/*                      c-est */
/*                      c-dep */
/*                      c-localizacao */
/*                      c-lote */
/*                      c-refer */
/*                      c-saldo-contabil */
/*                      c-contagem-1 */
/*                      c-contagem-2 */
/*                      c-contagem-3 */
/*                      c-situac */
/*                      c-trac */
/*                      with frame f-cab. */
        end. 
        {esp/cep/escep041.i}
    end.
end.

/* ImpressÆo dos parƒmetros do relat¢rio */
/* {utp/ut-liter.i SELE€ÇO * R} */
/* assign c-sel = trim(return-value). */
/* {utp/ut-liter.i CLASSIFICA€ÇO * R} */
/* assign c-cla = trim(return-value). */
/* {utp/ut-liter.i PAR¶METROS * R} */
/* assign c-param = trim(return-value). */
/* {utp/ut-liter.i IMPRESSÇO * R} */
/* assign c-impr = trim(return-value). */
/* {utp/ut-liter.i Grupo_Estoque * R} */
/* assign c-grupo-estoque = trim(return-value). */
/* {utp/ut-liter.i Fam¡lia * R} */
/* assign c-familia = trim(return-value). */
/* {utp/ut-liter.i Dep¢sito * R} */
/* assign c-deposito = trim(return-value). */
/* {utp/ut-liter.i Estabelecimento * R} */
/* assign c-estabelecimento = trim(return-value). */
/* {utp/ut-liter.i Destino * R} */
/* assign c-destino = trim(return-value). */
/* {utp/ut-liter.i Usu rio * R} */
/* assign c-usuario = trim(return-value). */
/* {utp/ut-liter.i Data_Corte_Invent rio * r} */
/* assign c-data-corte-invent = trim(return-value). */
/* if  tt-param.lista = 1 then do: */
/*     {utp/ut-liter.i Lista_Todos_os_Itens * r} */
/* end. */
/* else do: */
/*     {utp/ut-liter.i Lista_somente_Itens_Pendentes * r} */
/* end. */
/* assign c-listar = trim(return-value). */
/*    */
/* if  tt-param.contagem-1 then do: */
/*     {utp/ut-liter.i Lista_Contagem-1 * r} */
/* end. */
/* else do: */
/*     {utp/ut-liter.i NÆo_Lista_Contagem-1 * r} */
/* end. */
/* assign c-lista-contagem-1 = trim(return-value). */
/*    */
/* if  tt-param.contagem-2 then do: */
/*     {utp/ut-liter.i Lista_Contagem-2 * r} */
/* end. */
/* else do: */
/*     {utp/ut-liter.i NÆo_Lista_Contagem-2 * r} */
/* end. */
/* assign c-lista-contagem-2 = trim(return-value). */
/*    */
/* if  tt-param.contagem-3 then do: */
/*     {utp/ut-liter.i Lista_Contagem-3 * r} */
/* end. */
/* else do: */
/*     {utp/ut-liter.i NÆo_Lista_Contagem-3 * r} */
/* end. */
/* assign c-lista-contagem-3 = trim(return-value). */
/*    */
/* if  tt-param.lista-qt then do: */
/*     {utp/ut-liter.i Imprime_Quantidades * r} */
/* end. */
/* else do: */
/*     {utp/ut-liter.i NÆo_Imprime_Quantidades * r} */
/* end. */
/* assign c-imprimir = trim(return-value). */
/*    */
/* if  tt-param.saldo then do: */
/*     {utp/ut-liter.i Considera_Saldo_Zero * r} */
/* end. */
/* else do: */
/*     {utp/ut-liter.i NÆo_Considera_Saldo_Zero * r} */
/* end. */
/* assign c-considera-saldo-zero = trim(return-value). */
  
DEF VAR c-atualiz     AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR c-nao-atualiz AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR c-inv-ok      AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR c-ok-p-inv    AS CHAR FORMAT "x(30)" NO-UNDO.
  
{utp/ut-liter.i Atualizado *}
ASSIGN c-atualiz     = "1 - " + trim(RETURN-VALUE).
{utp/ut-liter.i NÆo_atualizado *}
ASSIGN c-nao-atualiz = "2 - " + trim(RETURN-VALUE).
{utp/ut-liter.i Invent rio_Ok MCE}
ASSIGN c-inv-ok      = "3 - " + trim(RETURN-VALUE).
{utp/ut-liter.i Ok_para_inventariar MCE}
ASSIGN c-ok-p-inv    = "4 - " + trim(RETURN-VALUE).
  
{utp/ut-liter.i LEGENDA *}
put skip(01) RETURN-VALUE.
put skip c-atualiz.
put skip c-nao-atualiz.
put skip c-inv-ok.
put skip c-ok-p-inv.
  
/* &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN */
/*     if tt-param.l-imp-param then do: */
/* &endif */
/* page. */
/* put c-sel                    skip(1) */
/*     c-grupo-estoque          at 5  ": " */
/*     tt-param.estq-ini        at 22 format ">9"       "|<  >|" at 39 */
/*     tt-param.estq-fim        at 46 format ">9" */
/*     c-item                   at 5  ": " */
/*     tt-param.item-ini        at 22 format "x(16)"    "|<  >|" at 39 */
/*     tt-param.item-fim        at 46 format "x(16)" */
/*     c-familia                at 5  ": " */
/*     tt-param.fam-ini         at 22 format "x(8)"     "|<  >|" at 39 */
/*     tt-param.fam-fim         at 46 format "x(8)" */
/*     c-lote                   at 5  ": " */
/*     tt-param.lote-ini        at 22 format "x(10)"    "|<  >|" at 39 */
/*     tt-param.lote-fim        at 46 format "x(10)" */
/*     c-refer                   at 5  ": " */
/*     tt-param.refer-ini       at 22 format "x(8)"     "|<  >|" at 39 */
/*     tt-param.refer-fim       at 46 format "x(8)" */
/*     c-localizacao            at 5  ": " */
/*     tt-param.loca-ini        at 22 format "x(10)"    "|<  >|" at 39 */
/*     tt-param.loca-fim        at 46 format "x(10)" */
/*     c-deposito               at 5  ": " */
/*     tt-param.dep-ini         at 22 format "x(3)"     "|<  >|" at 39 */
/*     tt-param.dep-fim         at 46 format "x(3)" */
/*     c-estabelecimento        at 5  ": " */
/*     tt-param.estab-ini       at 22 format "x(3)"     "|<  >|" at 39 */
/*     tt-param.estab-fim       at 46 format "x(3)" */
/*     c-ficha                  at 5  ": " */
/*     tt-param.ficha-ini       at 22 format ">>>>,>>9" "|<  >|" at 39 */
/*     tt-param.ficha-fim       at 46 format ">>>>,>>9" skip(1) */
/*     c-cla                    skip(1) */
/*     tt-param.classifica      at 5  format "9" " - " */
/*     tt-param.desc-classifica skip(1) */
/*     c-param                  skip(1) */
/*     c-listar                 at 5  skip(1) */
/*     c-lista-contagem-1       at 5 */
/*     c-lista-contagem-2       at 5 */
/*     c-lista-contagem-3       at 5  skip(1) */
/*     c-imprimir               at 5  skip(1) */
/*     c-considera-saldo-zero   at 5  skip(1) */
/*     c-data-corte-invent      at 5  ": " */
/*     tt-param.data-saldo      format "99/99/9999". */
/*    */
/*     &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN */
/*         IF CAN-FIND(FIRST tt-dig-imp) THEN DO: */
/*             put unformatted skip(1) */
/*                 c-lb-digit           skip(1) */
/*                 c-est                at 1 */
/*                 c-lb-nome            at 5 skip */
/*                 '--- ---------------------------------------' skip. */
/*             for each tt-dig-imp: */
/*                 disp tt-dig-imp.cod-estabel */
/*                      tt-dig-imp.nome with frame f-digitacao. */
/*                     down with frame f-digitacao. */
/*             end. */
/*         end. */
/*     &endif */
/*    */
/*     put unformatted skip(1) */
/*     c-impr                   skip(1) */
/*     c-destino                at 5  ": " */
/*     trim(tt-param.c-destino)       " - " tt-param.arquivo skip */
/*     c-usuario                at 5  ": "  tt-param.usuario. */
/*    */
/* &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN */
/*     end. */
/* &endif */
/*    */
/* {include/i-rpclo.i} */

run pi-finalizar in h-acomp.

return "OK".
