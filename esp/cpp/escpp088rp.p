/* include de controle de versÆo */
{include/i-prgvrs.i ESCPP088RP 1.00.00.000}

/* pr‚processador para ativar ou nÆo a sa¡da para RTF */
&global-define RTF no

/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{esp/cpp/escpp088tt.i}

/* recebimento de parƒmetros */
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/* include padrÆo para vari veis para o log  */
{include/i-rpvar.i}
{include/i-freeac.i}

/* defini‡Æo de vari veis e streams */
def var h-acomp     as handle  no-undo.
DEF VAR i-linha     as integer no-undo.

form
     item-dun.it-codigo at 10 
     item-dun.cod-dun 
     item-dun.digito 
     item-dun.qtd-emb 
     item-dun.impresso
    with frame f-registros no-box down no-attr-space width 132 stream-io. 

/* defini‡Æo de frames do log */

/* include padrÆo para output de log */
{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arquivo}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i &STREAM="str-rp"}

find first param-global no-lock no-error. 

/* bloco principal do programa */
assign	c-programa 	= "ESCPP088RP"
        c-versao	= "1.00"
        c-revisao	= ".00.000"
        c-empresa	= param-global.grupo
        c-titulo-relat = "Relat¢rio C¢digos DUN14".

view stream str-rp frame f-cabec.
view stream str-rp frame f-rodape.
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Processando *}

run pi-inicializar in h-acomp (input RETURN-VALUE).



/* bloco principal do programa */
for each item-dun no-lock
   where item-dun.it-codigo >= tt-param.it-codigo-ini
     and item-dun.it-codigo <= tt-param.it-codigo-fim:

    assign i-linha = i-linha + 1.

    run pi-acompanhar in h-acomp (input i-linha).

    disp stream str-rp
         item-dun.it-codigo
         item-dun.cod-dun  
         item-dun.digito   
         item-dun.qtd-emb  
         item-dun.impresso
        with frame f-registros.
        down with frame f-registros.
end.

/* fechamento do output do log */
{include/i-rpclo.i}

run pi-finalizar in h-acomp.

return "Ok":U.
