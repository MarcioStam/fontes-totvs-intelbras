/*-----------------------------------------------------------------------------
** Programa...: esp/plp/esplp006rp.p
** Autor......: Intelbras
** VersÒo.....: 2.06.00.000 
** Finalidade.: Corre‡Æo res-item
-------------------------------------------------------------------------------*/          
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esplp006 2.06.00.000}

/****************************  Definitions  ****************************/

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEFINE STREAM str-excel.

{utp/ut-glob.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/

define temp-table tt-param no-undo
    field destino       as integer
    FIELD arquivo       as char
    field usuario       as char format "x(12)"
    field data-exec     as date
    field hora-exec     as integer
    FIELD it-codigo-ini like ITEM.it-codigo
    FIELD it-codigo-fim like ITEM.it-codigo
    FIELD cod-estabel-ini AS CHAR
    FIELD cod-estabel-fim AS CHAR.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    field ordem            AS INTEGER   FORMAT ">>>>9":U
    field exemplo          AS CHARACTER FORMAT "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-estab
    FIELD cod-estabel AS CHAR FORMAT "x(5)".
/****************************  Frames  ****************************/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

/* include padrÆo para output de relat¢rios */
{include/i-rpout.i}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i}

IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

/****************************  defini‡Æo de variaveis  ****************************/

DEFINE VARIABLE h-acomp            AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE c-cabecalho        AS CHAR FORMAT "x(400)" NO-UNDO.

FOR FIRST param-global NO-LOCK,
    FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-prin: END.
FOR FIRST param-estoq NO-LOCK: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Baixa saldo pendente de faturamento"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESPLP006"
       c-versao       = "2.06"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */

PROCEDURE piImprimeRelat:

    FOR EACH res-item WHERE
             res-item.it-codigo   >= tt-param.it-codigo-ini   AND
             res-item.it-codigo   <= tt-param.it-codigo-fim   AND
             res-item.cod-estabel >= tt-param.cod-estabel-ini AND
             res-item.cod-estabel <= tt-param.cod-estabel-fim
             EXCLUSIVE-LOCK:

        IF res-item.dec-1 = 0 THEN NEXT.

        run pi-acompanhar in h-acomp (input 'Item: ' + res-item.it-codigo).

        DISP res-item.it-codigo
             res-item.cod-estabel
             res-item.dec-1 COLUMN-LABEL "Saldo Pend"
             WITH FRAME f-res DOWN STREAM-IO.
             

        ASSIGN res-item.dec-1 = 0.

        RELEASE res-item.
             
    END.

END PROCEDURE.


