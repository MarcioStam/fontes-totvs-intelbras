/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i escep049rp 2.00.00.001}  /*** 010001 ***/
{include/i_fnctrad.i}

{utp/ut-glob.i}

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.
def var c-imprimir                   as char format "x(30)" no-undo.

{esp/cep/escep049tt.i}

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def var h-acomp         as handle no-undo.    

def temp-table tt-se
    field it-codigo      like item.it-codigo
    field cod-depos      like deposito.cod-depos
    FIELD cod-estabel    LIKE saldo-estoq.cod-estabel
    field descricao      as char format "X(36)"
    field qtde           as dec format ">>>>,>>9.99"
    index tt-se is primary unique it-codigo cod-depos.

form
/*form-selecao-ini*/
    skip(1)
    c-liter-sel         no-label
    skip(1)
    /*form-selecao-usuario*/
    tt-param.cod-estabel-ini format ">>9" label "Estabelecimento" colon 40 SKIP
    tt-param.cod-depos-ini format "x(10)" label "Deposito" colon 40
    " <| |> " at 60
    tt-param.cod-depos-fim format "x(10)" no-label skip
    tt-param.it-codigo-ini format "x(16)" label "Item" colon 40 
    " <| |> " at 60
    tt-param.it-codigo-fim format "x(16)" no-label skip
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
    skip(1)
/*form-parametro-fim*/
/*form-impressao-ini*/
    skip(1)
    c-liter-imp         no-label
    skip(1)
    c-destino           colon 40 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    colon 40
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 132 frame f-impressao.

form
    /*campos-do-relatorio*/
     with no-box width 132 down stream-io frame f-relat.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

/*inicio-traducao*/
/*traducao-default*/
{utp/ut-liter.i PAR¶METROS * r}
assign c-liter-par = return-value.
{utp/ut-liter.i SELE€ÇO * r}
assign c-liter-sel = return-value.
{utp/ut-liter.i IMPRESSÇO * r}
assign c-liter-imp = return-value.
{utp/ut-liter.i Destino * l}
assign c-destino:label in frame f-impressao = return-value.
{utp/ut-liter.i Usu rio * l}
assign tt-param.usuario:label in frame f-impressao = return-value.   
/*fim-traducao*/

{include/i-rpvar.i}
{utp/ut-glob.i}

find empresa
    where empresa.ep-codigo = v_cdn_empres_usuar
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec¡ficos_Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio_de_Saldos_Item_Dep¢sito * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}.

{include/tt-edit.i}
{include/pi-edit.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ***************************  Main Block  *************************** */

do on stop undo, leave:
    {include/i-rpout.i &pagesize="0"}
/*    view frame f-cabec.
    view frame f-rodape.    */
    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Imprimindo":U). 
    
    for each item no-lock
       where item.it-codigo >= tt-param.it-codigo-ini
         and item.it-codigo <= tt-param.it-codigo-fim,
       each deposito no-lock
         where deposito.cod-depos >= tt-param.cod-depos-ini
           and deposito.cod-depos <= tt-param.cod-depos-fim:

       create tt-se.
       assign tt-se.cod-estabel = tt-param.cod-estabel
              tt-se.cod-depos   = deposito.cod-depos
              tt-se.it-codigo   = item.it-codigo
              tt-se.descricao   = item.desc-item.
    end.

    for each saldo-estoq no-lock
       where saldo-estoq.cod-estabel = tt-param.cod-estabel
         and saldo-estoq.it-codigo >= tt-param.it-codigo-ini
         and saldo-estoq.it-codigo <= tt-param.it-codigo-fim
         and saldo-estoq.cod-depos >= tt-param.cod-depos-ini
         and saldo-estoq.cod-depos <= tt-param.cod-depos-fim
         and saldo-estoq.qtidade-atu > 0,
       first tt-se of saldo-estoq exclusive-lock:

       run pi-acompanhar in h-acomp (input "Lendo saldo estoque item " + saldo-estoq.it-codigo). 

       assign tt-se.qtde = tt-se.qtde +
                           (saldo-estoq.qtidade-atu -
                            saldo-estoq.qt-alocada -
                            saldo-estoq.qt-aloc-prod).
    end.

    PUT UNFORMATTED "Itens;Descricao".
    for each deposito no-lock
       where deposito.cod-depos >= tt-param.cod-depos-ini
         and deposito.cod-depos <= tt-param.cod-depos-fim:

        PUT UNFORMATTED ";" deposito.cod-depos.
    end.

    put skip.

    for each tt-se no-lock
        break by tt-se.it-codigo
              by tt-se.cod-depos:

        if first-of(tt-se.it-codigo) then
           PUT UNFORMATTED 
            tt-se.it-codigo ";"
            tt-se.descricao.

        put UNFORMATTED 
            ";" tt-se.qtde.

        if last-of(tt-se.it-codigo) then
           PUT skip.
    end.
    
    run pi-finalizar in h-acomp.

    {include/i-rpclo.i}

    return "ok".
end.



