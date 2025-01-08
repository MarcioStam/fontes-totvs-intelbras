/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i CQ0203B 2.00.00.021}  /*** 010021 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i CQ0203B MCQ}
&ENDIF

/*******************************************************************************
**
**   Programa: CQ0203B.P
**
**   Autor...: Datasul S/A.
**
**   Objetivo: Relat¢rio Roteiro de Inspeá∆o (classificaá∆o por Est/Dep)
**
**   Data....: Novembro de 1998
**
**   Vers∆o..: 1.00.000
**
*********************************************************************************/
{esp/cqp/escqp012.i2}

def input parameter table for tt-param.

find first tt-param no-lock no-error.

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

{esp/cqp/escqp012.i "estab-depos" "ficha-cq.cod-estabel" "BY ficha-cq.cod-depos"}

run pi-finalizar in h-acomp.

{include/i-rpclo.i}



