/*----------------------------------------------------------------------
**  Programa..: esp/ftp/esftp033rp.p
**  Autor.....: Giovane Oliveira - Developer
**  Data......: Agosto/2007 - Desenvolvimento
**  Descricao.: Listar pre-faturamento com frete cif e peso inferior
**              a 4Kg para determina‡Æo se ‚ vi vel o envio da 
**              mercadoria por Sedex
-----------------------------------------------------------------------*/

/*---------------------------  Variaveis    ---------------------------*/
{include/i-prgvrs.i esftp033 2.00.00.000}
{include/i-rpvar.i}
{utp/ut-glob.i}

FIND FIRST param-global NO-LOCK.
FIND FIRST mgcad.empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Listagem de Aux¡lio a Escolha do Transportador"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESFTP033"
       c-versao       = "2.00"
       c-revisao      = "000".

{include/i-rpcab.i}

DEFINE VARIABLE h-acomp         AS HANDLE       NO-UNDO.

/*---------------------------  Temp-Tables  ---------------------------*/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHARACTER FORMAT "x(35)":U
    FIELD usuario           AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD nr-embarque-ini   LIKE pre-fatur.cdd-embarq
    FIELD nr-embarque-fim   LIKE pre-fatur.cdd-embarq
    FIELD nr-resumo-ini     LIKE pre-fatur.nr-resumo
    FIELD nr-resumo-fim     LIKE pre-fatur.nr-resumo
    FIELD cod-estab-ini     LIKE pre-fatur.cod-estabel
    FIELD cod-estab-fim     LIKE pre-fatur.cod-estabel
    field peso-bruto-max    like res-cli.peso-bru
    field log-sit-pre       as logical extent 3.
    
DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita         AS RAW.
   
/*---------------------------  Par?metros   ---------------------------*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Imprimindo...").

{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

for each pre-fatur no-lock
    where pre-fatur.cod-estabel >= tt-param.cod-estab-ini
    and   pre-fatur.cod-estabel <= tt-param.cod-estab-fim
    and   pre-fatur.cdd-embarq >= tt-param.nr-embarque-ini
    and   pre-fatur.cdd-embarq <= tt-param.nr-embarque-fim
    and   pre-fatur.nr-resumo   >= tt-param.nr-resumo-ini
    and   pre-fatur.nr-resumo   <= tt-param.nr-resumo-fim,
    first ped-venda no-lock
    where ped-venda.nome-abrev = pre-fatur.nome-abrev
    and   ped-venda.nr-pedcli  = pre-fatur.nr-pedcli
    and   ped-venda.cidade-cif ne ""
    and   can-find(first transporte no-lock
                   where transporte.nome-abrev = ped-venda.nome-transp
                   and   transporte.via-transp ne 8)
    break by pre-fatur.cod-estabel
          by pre-fatur.cdd-embarq
          by pre-fatur.nr-resumo:
          
    if (tt-param.log-sit-pre[1] and pre-fatur.cod-sit-pre = 1)       
    or (tt-param.log-sit-pre[2] and pre-fatur.cod-sit-pre = 3)
    or (tt-param.log-sit-pre[3] and pre-fatur.cod-sit-pre = 2) then do:
    
        run pi-acompanhar in h-acomp (input string(pre-fatur.cdd-embarq)).          
              
        for each res-cli of pre-fatur no-lock
            where res-cli.peso-bru-tot <= tt-param.peso-bruto-max:
        
            disp pre-fatur.cod-estabel
                 pre-fatur.cdd-embarq
                 {diinc/i01di162.i 04 pre-fatur.cod-sit-pre} format "x(10)" column-label "Situa‡Æo"
                 pre-fatur.nr-resumo
                 pre-fatur.nr-pedcli
                 pre-fatur.nome-abrev
                 ped-venda.nome-transp   
                 res-cli.peso-bru-tot 
                 with stream-io no-box width 132 down frame f-relat.
        
        end.
    
    end.
              
        
end.   

{include/i-rpclo.i}

run pi-finalizar in h-acomp.
