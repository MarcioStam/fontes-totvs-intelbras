/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i escep054rp 2.00.00.001}  /*** 010001 ***/
{include/i_fnctrad.i}
/******************************************************************************
**
**       Programa: escep054rp
**
**       Objetivo: Listagem de movimentos de REQ e Perdas
**
**       Versao..: 1.00.000
**
******************************************************************************/

{cdp/cd0666.i}
{cdp/cdcfgdis.i}
{utp/ut-glob.i}

/*--- temp-tables usadas na atualizacao do documento ---*/
define temp-table tt-param
      field destino            as integer
      field arquivo            as char
      field usuario            as char format "x(12)"
      field data-exec          as date
      field hora-exec          as integer
      FIELD cod-estab          AS CHAR
      FIELD conta              AS CHAR
      FIELD cod-depos-ini      AS CHAR
      FIELD cod-depos-fim      AS CHAR
      field dt-trans-ini     as date format "99/99/9999"
      field dt-trans-fim     as date format "99/99/9999".

define temp-table tt-digita
    field ordem        as integer   format ">>>>9"
    field exemplo      as character format "x(30)"
    index id is primary unique ordem.

def temp-table tt-raw-digita 
    field raw-digita as raw.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def var h-acomp as handle no-undo.
def var l-erro  as log    no-undo.

def var i-empresa like param-global.empresa-prin no-undo.
DEF VAR dt-data AS DATE NO-UNDO.

DEF VAR v-ppm   LIKE movto-estoq.quantidade.
DEF VAR v-perda AS DECIMAL FORMAT "->>>>,>>>,>>9.9999".

DEF TEMP-TABLE tt-movto NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD cod-depos LIKE movto-estoq.cod-depos
    FIELD conta LIKE movto-estoq.conta-contabil
    FIELD quant-perda LIKE movto-estoq.quantidade
    FIELD quantidade LIKE movto-estoq.quantidade
    FIELD valor LIKE item-estab.val-unit-mat-m[1]
    INDEX chapri it-codigo cod-depos.

find first param-global no-lock no-error.
find first param-estoq  no-lock no-error.

{include/i-rpvar.i}
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp ("Listagem de movimentos REQ").

assign i-empresa = param-global.empresa-prin.

&if defined (bf_dis_consiste_conta) &then

    find estabelec where
         estabelec.cod-estabel = param-estoq.estabel-pad no-lock no-error.

    run cdp/cd9970.p (input rowid(estabelec),
                      output i-empresa).
&endif

find empresa where
     empresa.ep-codigo = i-empresa no-lock no-error.

create tt-param.
raw-transfer raw-param to tt-param.
FIND FIRST tt-param NO-ERROR.

assign c-empresa  = (if avail param-global then param-global.grupo else "")
       c-programa = "esep/024"
       c-versao   = "1.00"
       c-revisao  = "000".

/*run utp/ut-trfrrp.p (input frame f-docto:handle).*/
{include/i-rpcab.i}

{include/i-rpout.i}
/*
view frame f-cabec.
view frame f-rodape.
*/
/* Leitura dos documentos */
do with frame f-docto:
    bloco:

    DO dt-data = tt-param.dt-trans-ini TO tt-param.dt-trans-fim:
        
        RUN pi-lendo-movto (INPUT 5).
       /* RUN pi-lendo-movto (INPUT 6). */
        RUN pi-lendo-movto (INPUT 28).
        RUN pi-lendo-movto (INPUT 31).
    END.
end.

PUT "Item;Descri‡Æo;Depos;Quantidade;Qtde Perda;Custo;PPM;Val.Perda;" tt-param.cod-estab SKIP(1).

FOR EACH tt-movto
   BREAK BY tt-movto.cod-depos:
    FIND item-estab WHERE
         item-estab.it-codigo   = tt-movto.it-codigo AND
         item-estab.cod-estabel = tt-param.cod-estab NO-LOCK NO-ERROR.
    IF AVAIL item-estab THEN DO:
        ASSIGN tt-movto.valor = item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1].
    END.

    FIND FIRST ITEM WHERE ITEM.it-codigo = tt-movto.it-codigo NO-LOCK NO-ERROR.

    ASSIGN v-ppm   = (tt-movto.quant-perda / tt-movto.quantidade) * 1000000
           v-perda = tt-movto.quant-perda * tt-movto.valor.

    PUT trim(tt-movto.it-codigo) ";"
        ITEM.desc-item ";"
        tt-movto.cod-depos ";"
        tt-movto.quantidade ";"
        tt-movto.quant-perda ";"
        tt-movto.valor ";" 
        v-ppm ";"
        v-perda SKIP.
END.

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

return "OK".

PROCEDURE pi-lendo-movto:
    DEFINE INPUT PARAMETER p-esp-docto AS INTEGER NO-UNDO.

    run pi-acompanhar in h-acomp ("Lendo: " + string(dt-data) + " - Tipo Docto: " + STRING(p-esp-docto)).

    FOR EACH movto-estoq NO-LOCK
       WHERE movto-estoq.dt-trans    = dt-data
         AND movto-estoq.esp-docto   = p-esp-docto:

        IF movto-estoq.cod-estabel <> tt-param.cod-estab     THEN NEXT.
        IF movto-estoq.cod-depos   <  tt-param.cod-depos-ini THEN NEXT.
        IF movto-estoq.cod-depos   >  tt-param.cod-depos-fim THEN NEXT.

        FIND FIRST tt-movto
             WHERE tt-movto.it-codigo = movto-estoq.it-codigo 
               AND tt-movto.cod-depos = movto-estoq.cod-depos NO-ERROR.
        IF NOT AVAIL tt-movto THEN DO:
            CREATE tt-movto.
            ASSIGN tt-movto.it-codigo = movto-estoq.it-codigo
                   tt-movto.cod-depos = movto-estoq.cod-depos.
        END.


        IF movto-estoq.ct-codigo = tt-param.conta THEN DO:
            IF movto-estoq.tipo-trans = 1 THEN DO:
                ASSIGN tt-movto.quant-perda = tt-movto.quant-perda - movto-estoq.quantidade.
            END.
            ELSE DO:
                ASSIGN tt-movto.quant-perda = tt-movto.quant-perda + movto-estoq.quantidade.

            END.
        END.
        ELSE DO:
            IF movto-estoq.tipo-trans = 1 THEN DO:
                ASSIGN tt-movto.quantidade = tt-movto.quantidade - movto-estoq.quantidade.
            END.
            ELSE DO:
                ASSIGN tt-movto.quantidade = tt-movto.quantidade + movto-estoq.quantidade.
            END.
        END.
    END.
END PROCEDURE.
