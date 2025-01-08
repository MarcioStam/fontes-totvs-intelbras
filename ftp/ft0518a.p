/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i FT0518A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ft0516a MFT}
&ENDIF


/*******************************************************************************
** PROGRAMA: ft0518A.P
**
** OBJETIVO: Tratar os niveis de tributacao de ICMS dos itens.
**
*******************************************************************************/

def input  parameter r-nota-item as rowid.
def output parameter i-codigo    as integer format ">".
def output parameter l-sub       as logical init no.

def var l-char1-2 as logical init no.
def var l-char2-2 as logical init no.

find it-nota-fisc where rowid(it-nota-fisc) = r-nota-item no-lock no-error.

find natur-oper
     where natur-oper.nat-operacao = it-nota-fisc.nat-operacao no-lock no-error.

find item where item.it-codigo = it-nota-fisc.it-codigo no-lock no-error.

assign l-char1-2 = natur-oper.ind-it-sub-dif /* variavel logica para cod trib 5 */
       l-char2-2 = natur-oper.ind-it-icms.   /* variavel logica para cod trib 6 */

/*----------------------------------------------------------------------------*/

if  l-char1-2 = yes then do:
    assign i-codigo = 5.
    return.
end.
else do:
    if  l-char2-2 = yes then do:
        assign i-codigo = 6.
        return.
    end.
end.

/*----------------------------------------------------------------------------*/

if  it-nota-fisc.cd-trib-icm = 1
and it-nota-fisc.ind-icm-ret = yes then do:
    assign i-codigo = 1
           l-sub    = yes.
    return.
end.
else do:
    if  it-nota-fisc.cd-trib-icm = 1 then do:
        assign i-codigo = 0.
        return.
    end.
end.

/*----------------------------------------------------------------------------*/

if  it-nota-fisc.cd-trib-icm  = 4
and it-nota-fisc.ind-icm-ret = yes then do:
    assign i-codigo = 7.
    return.
end.

/*----------------------------------------------------------------------------*/

if  it-nota-fisc.cd-trib-icm = 4
and it-nota-fisc.ind-icm-ret = no then do:
    assign i-codigo = 2.
    return.
end.

/*----------------------------------------------------------------------------*/

if  it-nota-fisc.cd-trib-icm = 2
and it-nota-fisc.ind-icm-ret = yes then do:
    assign i-codigo = 3
           l-sub    = yes.
    return.
end.
else do:
    if  it-nota-fisc.cd-trib-icm = 2 then do:
        assign i-codigo = 4.
        return.
    end.
end.

/*---------------------------------------------------------------------------*/

if  it-nota-fisc.cd-trib-icm = 3 then do:
    assign i-codigo = 9.
    return.
end.

/*---------------------------------------------------------------------------*/

/* ft0518a.p */

