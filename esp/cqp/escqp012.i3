/******************************************************************************
**
**  CQ0203.I3 - ImpressÆo dos Parƒmetros
**
*******************************************************************************/

{utp/ut-liter.i Reimprime_os_j _Impressos * r}
assign c-lb-ja = trim(return-value).
{utp/ut-liter.i Imprime_um_Exame_por_P gina * r}
assign c-lb-pag = trim(return-value).
{utp/ut-liter.i Imprime_Narrativa_do_Item * r}
assign c-lb-nar-item = trim(return-value).
{utp/ut-liter.i Imprime_Narrativa_Componente * r}
assign c-lb-nar-comp = trim(return-value).
{utp/ut-liter.i Imprime_Observa‡Æo * r}
assign c-lb-obs = trim(return-value).
{utp/ut-liter.i Estabelecimento * r}
assign c-lb-est = trim(return-value).
{utp/ut-liter.i Dep¢sito * r}
assign c-lb-dep = trim(return-value).
{utp/ut-liter.i Item * r}
assign c-lb-item = trim(return-value).
{utp/ut-liter.i Localiza‡Æo * r}
assign c-lb-loc = trim(return-value).
{utp/ut-liter.i Lote * r}
assign c-lb-lote = trim(return-value).
{utp/ut-liter.i Roteiro_Inspe‡Æo * r}
assign c-lb-ficha = trim(return-value).
{utp/ut-liter.i S‚rie * r}
assign c-lb-ser = trim(return-value).
{utp/ut-liter.i Documento * r}
assign c-lb-doc = trim(return-value).
{utp/ut-liter.i Destino * r}
assign c-lb-dest = trim(return-value).
{utp/ut-liter.i Usu rio * r}
assign c-lb-usuar = trim(return-value).
{utp/ut-liter.i PAR¶METROS * r}
assign c-lb-par = trim(return-value).
{utp/ut-liter.i SELE€ÇO * r}
assign c-lb-sel = trim(return-value).
{utp/ut-liter.i CLASSIFICA€ÇO * r}
assign c-lb-cla = trim(return-value).
{utp/ut-liter.i IMPRESSÇO * r}
assign c-lb-imp = trim(return-value).

page.

put unformatted c-lb-par skip(1).

assign l-param = tt-param.l-ja-impresso.
put c-lb-ja  at 16 format "x(20)" ": " l-param.
assign l-param = tt-param.l-um-por-pag.
put c-lb-pag at 5 format "x(31)" ": " l-param.
assign l-param = tt-param.l-observacao.
put c-lb-obs at 16 format "x(20)" ": " l-param.
assign l-param = tt-param.l-narrativa-item.
put c-lb-nar-item  at 11 format "x(25)" ": " l-param.
assign l-param = tt-param.l-narrativa-comp.
put c-lb-nar-comp  at 8 format "x(28)" ": " l-param skip(1).

put unformatted
    c-lb-sel   skip(1)
    c-lb-est   to 21 ": " tt-param.c-estab-ini "|<  >| " at 65 tt-param.c-estab-fim
    c-lb-dep   to 21 ": " tt-param.c-depos-ini "|<  >| " at 65 tt-param.c-depos-fim
    c-lb-item  at 18 ": " tt-param.c-item-ini  "|<  >| " at 65 tt-param.c-item-fim
    c-lb-loc   to 21 ": " tt-param.c-local-ini "|<  >| " at 65 tt-param.c-local-fim
    c-lb-lote  to 21 ": " tt-param.c-lote-ini  "|<  >| " at 65 tt-param.c-lote-fim
    c-lb-ficha to 21 ": " tt-param.i-ficha-ini "|<  >| " at 65 tt-param.i-ficha-fim
    c-lb-ser   to 21 ": " tt-param.c-serie-ini "|<  >| " at 65 tt-param.c-serie-fim
    c-lb-doc   to 21 ": " tt-param.c-docto-ini "|<  >| " at 65 tt-param.c-docto-fim skip(1)
    c-lb-cla   skip(1)    tt-param.c-classe    at 5 skip(1)
    c-lb-imp   skip(1)
    c-lb-dest  at 5  ": " tt-param.c-destino   " - " tt-param.arquivo
    c-lb-usuar at 7  ": " tt-param.usuario.

run pi-finalizar in h-acomp.

{include/i-rpclo.i}
