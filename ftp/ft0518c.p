/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i FT0518C 2.00.00.000}  /*** 010000 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ft0516c MFT}
&ENDIF

/****************************************************************************
**
**   PROGRAMA : ft0518C.P
**
**   OBJETIVO : Leitura das Duplicatas
**
****************************************************************************/

def shared var i-parcela-vet     as integer                           extent 8.
def shared var i-fatura-vet      as char    format "x(16)"            extent 8.
def shared var da-venc-dup-vet   as date    format "99/99/9999"       extent 8.
def shared var de-vl-dup-vet     as decimal format ">>>>>,>>>,>>9.99" extent 8.
def shared var de-cotacao        as decimal format ">>>,>>9.99999999".
def shared var i-cont            as integer.
def shared var r-nota-fiscal     as rowid.

find first nota-fiscal
     where rowid(nota-fiscal) = r-nota-fiscal
     no-lock no-error.

for each  fat-duplic
    where fat-duplic.cod-estabel = nota-fiscal.cod-estabel
    and   fat-duplic.serie       = nota-fiscal.serie
    and   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura   no-lock
    break by fat-duplic.parcela i-cont = 1 to 8:
    if  fat-duplic.vl-finsocial = 0 then
        assign de-cotacao = 1.
    else do:
        find first cotacao
             where cotacao.mo-codigo   = integer(fat-duplic.vl-finsocial)
             and   cotacao.ano-periodo =
                                    string(year (nota-fiscal.dt-emis-nota)) +
                                    string(month(nota-fiscal.dt-emis-nota),"99")
             no-lock no-error.

             assign de-cotacao = if  avail cotacao then
                                cotacao.cotacao[(day(nota-fiscal.dt-emis-nota))]
                                 else 1.
    end.

    assign da-venc-dup-vet [i-cont] = fat-duplic.dt-venciment.
    assign de-vl-dup-vet[i-cont]    = fat-duplic.vl-parcela / de-cotacao.
    assign i-fatura-vet[i-cont]     = fat-duplic.nr-fatura.
    assign i-parcela-vet[i-cont]    = integer(fat-duplic.parcela).

end.

/* ft0518C.P */

