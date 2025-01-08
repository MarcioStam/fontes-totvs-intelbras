/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCQP012RP 2.00.00.017}  /*** 010017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ESCQP012RP MCQ}
&ENDIF

/*******************************************************************************
**
**   Programa: ESCQP012rp.p
**
**   Autor...: Datasul S/A.
**
**   Objetivo: Relat¢rio Roteiro de Inspeá∆o
**
**   Data....: Abril de 1997
**
**   Vers∆o..: 1.00.000
**
*********************************************************************************/

define temp-table tt-param
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field c-estab-ini        like ficha-cq.cod-estabel
    field c-estab-fim        like ficha-cq.cod-estabel
    field c-depos-ini        like ficha-cq.cod-depos
    field c-depos-fim        like ficha-cq.cod-depos
    field c-item-ini         like ficha-cq.it-codigo
    field c-item-fim         like ficha-cq.it-codigo
    field c-cod-emitente-ini like ficha-cq.cod-emitente
    field c-cod-emitente-fim like ficha-cq.cod-emitente
    field c-local-ini        like ficha-cq.cod-localiz
    field c-local-fim        like ficha-cq.cod-localiz
    field c-lote-ini         like ficha-cq.lote
    field c-lote-fim         like ficha-cq.lote
    field i-ficha-ini        like ficha-cq.nr-ficha
    field i-ficha-fim        like ficha-cq.nr-ficha
    field c-serie-ini        like ficha-cq.serie-docto
    field c-serie-fim        like ficha-cq.serie-docto
    field c-docto-ini        like ficha-cq.nro-docto
    field c-docto-fim        like ficha-cq.nro-docto
    field l-ja-impresso      as logical
    field l-um-por-pag       as logical
    field l-observacao       AS logical
    FIELD l-narrativa-item   AS LOGICAL
    FIELD l-narrativa-comp   AS LOGICAL
    field c-classe           as char
    field c-destino          as char.

def temp-table tt-raw-digita
   field raw-digita as raw.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.


if  tt-param.classifica = 1 then do:
    run esp/cqp/ESCQP012a.p (input table tt-param).
end.
if  tt-param.classifica = 2 then do:
    run esp/cqp/ESCQP012b.p (input table tt-param).
end.
if  tt-param.classifica = 3 then do:
    run esp/cqp/ESCQP012c.p (input table tt-param).
end.

return "OK".
