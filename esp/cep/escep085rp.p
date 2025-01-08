/***********************************************************************
**  Programa..: esp/cep/escep085rp.p
**  Autor.....: Nicolas Martinez
**  Data......: Outubro/2020 - Desenvolvimento
**  Descricao.: Relatorio estoque sem movimento
**  Versao....: 001 14/10/2020
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.
{include/i-prgvrs.i ESCEP085RP 2.00.00.000}

/****************************  Definitions  ****************************/

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD modelo           AS CHAR FORMAT "x(35)":U
    FIELD item-ini         AS CHAR
    FIELD item-fim         AS CHAR
    FIELD data-ini         AS DATE
    FIELD data-fim         AS DATE
    FIELD cod-estabel-ini  AS CHAR
    FIELD cod-estabel-fim  AS CHAR
    FIELD cod-depos-ini    AS CHAR
    FIELD cod-depos-fim    AS CHAR
    FIELD ge-ini           AS INTE
    FIELD ge-fim           AS INTE
    FIELD fm-codigo-ini    AS CHAR
    FIELD fm-codigo-fim    AS CHAR
    FIELD entradas         AS LOG 
    FIELD saidas           AS LOG
    FIELD l-habilitaRtf    AS LOG
    .

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD esp-docto   AS CHAR
    FIELD esp-docto-i AS INTE
    FIELD descricao   AS CHAR
        INDEX id esp-docto.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE STREAM str-excel.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

{include/i-rpvar.i}
{esp/es0018.i}

/****************************  Variables  ****************************/
DEFINE VARIABLE h-acomp     AS HANDLE       NO-UNDO.

DEFINE VARIABLE c-excel       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE chExcel       AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chArquivo     AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chPlanilhaMod AS COM-HANDLE NO-UNDO.

/****************************  Temp-Tables  ****************************/
DEF TEMP-TABLE tt-movto NO-UNDO
    FIELD it-codigo     AS CHAR
    FIELD cod-estabel   AS CHAR
    FIELD cod-depos     AS CHAR
    FIELD lote          AS CHAR
    FIELD cod-localiz   AS CHAR
    FIELD dt-trans      AS DATE
    FIELD tipo          AS INTE
    FIELD tipo-char     AS CHAR
    FIELD nr-dias       AS INTE
    FIELD quantidade    AS DECIMAL
    FIELD preco         AS DECIMAL
    FIELD vl-total      AS DECIMAL
    FIELD ge-codigo     LIKE ITEM.ge-codigo
    FIELD fm-codigo     LIKE ITEM.fm-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    index movto is primary unique 
          it-codigo 
          cod-estabel
          cod-depos
          lote
          cod-localiz
          tipo.
    
IF OPSYS = "UNIX":U THEN DO:
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto:
        ASSIGN c-excel = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-excel, LENGTH(c-excel), 1) <> "/":U THEN
    ASSIGN c-excel = c-excel + "/":U + TRIM(tt-param.usuario) + "/":U.
END.
ELSE DO:
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto:
        ASSIGN c-excel = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
                           
    END.
    IF SUBSTRING(c-excel, LENGTH(c-excel), 1) <> "~\":U THEN
    ASSIGN c-excel = c-excel + "~\":U + TRIM(tt-param.usuario) + "~\":U.
END.

OS-CREATE-DIR VALUE(c-excel).
ASSIGN c-excel = c-excel + "ESCEP085.csv":U.

/* **************************** Frames ********************************* */

{include/i-rpout.i}
{include/i-rpcab.i}

FOR FIRST tt-param:
END.

ASSIGN  c-programa 	    = "ESCEP085"
	    c-versao	    = "2.00"
	    c-revisao	    = ".00.000"
	    c-empresa       = "Intelbras"
	    c-sistema	    = "CEP"
	    c-titulo-relat  = "Listagem Itens sem movimento estoque".

/* para nÆo visualizar cabe‡alho/rodap‚ em sa¡da RTF */

/* ***************************  Main Block  *************************** */

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Listando_Movimentos *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

FOR EACH ITEM WHERE
         ITEM.it-codigo >= tt-param.item-ini      AND
         ITEM.it-codigo <= tt-param.item-fim      AND
         ITEM.ge-codigo >= tt-param.ge-ini        AND
         ITEM.ge-codigo <= tt-param.ge-fim        AND
         ITEM.fm-codigo >= tt-param.fm-codigo-ini AND
         ITEM.fm-codigo <= tt-param.fm-codigo-fim
         NO-LOCK.

    RUN pi-acompanhar in h-acomp (input 'Item: ' + ITEM.it-codigo). 

    FOR EACH movto-estoq WHERE
             movto-estoq.it-codigo    = ITEM.it-codigo           AND
             movto-estoq.cod-estabel >= tt-param.cod-estabel-ini AND
             movto-estoq.cod-estabel <= tt-param.cod-estabel-fim AND
             movto-estoq.dt-trans    >= tt-param.data-ini        AND
             movto-estoq.dt-trans    <= tt-param.data-fim        AND
             movto-estoq.cod-depos   >= tt-param.cod-depos-ini   AND
             movto-estoq.cod-depos   <= tt-param.cod-depos-fim 
             NO-LOCK
        BREAK BY movto-estoq.dt-trans DESCENDING.

        IF tt-param.entradas      = NO AND 
           movto-estoq.tipo-trans = 1 THEN NEXT.

        IF tt-param.saidas        = NO AND 
           movto-estoq.tipo-trans = 2 THEN NEXT.

        FIND FIRST tt-digita WHERE
                   tt-digita.esp-docto-i = movto-estoq.esp-docto
                   NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-digita THEN NEXT.

        FIND FIRST tt-movto WHERE
                   tt-movto.it-codigo   = movto-estoq.it-codigo   AND
                   tt-movto.cod-estabel = movto-estoq.cod-estabel AND
                   tt-movto.cod-depos   = movto-estoq.cod-depos   AND
                   tt-movto.lote        = movto-estoq.lote        AND
                   tt-movto.cod-localiz = movto-estoq.cod-localiz
                  // tt-movto.tipo        = movto-estoq.tipo-trans
                   NO-ERROR.
                   
        IF NOT AVAIL tt-movto 
        THEN DO:

            FIND FIRST saldo-estoq WHERE
                       saldo-estoq.it-codigo   = movto-estoq.it-codigo   AND
                       saldo-estoq.cod-estabel = movto-estoq.cod-estabel AND
                       saldo-estoq.cod-depos   = movto-estoq.cod-depos   AND
                       saldo-estoq.lote        = movto-estoq.lote        AND
                       saldo-estoq.cod-localiz = movto-estoq.cod-localiz
                       NO-LOCK NO-ERROR.

            CREATE tt-movto.
            ASSIGN tt-movto.it-codigo   = movto-estoq.it-codigo   
                   tt-movto.cod-estabel = movto-estoq.cod-estabel 
                   tt-movto.cod-depos   = movto-estoq.cod-depos   
                   tt-movto.lote        = movto-estoq.lote        
                   tt-movto.tipo        = movto-estoq.tipo-trans
                   tt-movto.cod-localiz = movto-estoq.cod-localiz
                   tt-movto.tipo-char   = IF movto-estoq.tipo-trans = 1 THEN "Entrada" ELSE "Saida"
                   tt-movto.nr-dias     = tt-param.data-fim - movto-estoq.dt-trans
                   //tt-movto.quantidade  = movto-estoq.quantidade
                   tt-movto.quantidade  = IF AVAIL saldo-estoq THEN DEC(saldo-estoq.qtidade-atu - (saldo-estoq.qt-aloc-ped + saldo-estoq.qt-aloc-prod)) ELSE 0
                   tt-movto.preco       = movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]
                   tt-movto.vl-total    = tt-movto.quantidade * tt-movto.preco
                   tt-movto.ge-codigo   = ITEM.ge-codigo
                   tt-movto.fm-codigo   = ITEM.fm-codigo
                   tt-movto.desc-item   = ITEM.desc-item.

        END.
    END.
END.

OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET SESSION:CHARSET.

PUT STREAM str-excel "Item;Descri‡Æo;GE;Familia;Est;Depos;Lote;Localiz;Tipo;Dias;Qtd;Pre‡o;Vl Tot" SKIP.

FOR EACH tt-movto NO-LOCK.

    IF tt-movto.quantidade = 0 THEN NEXT.

    PUT STREAM str-excel UNFORMATTED 
        tt-movto.it-codigo   ";"
        tt-movto.desc-item   ";"
        tt-movto.ge-codigo   ";"
        tt-movto.fm-codigo   ";"
        tt-movto.cod-estabel ";"
        tt-movto.cod-depos   ";"
        tt-movto.lote        ";"
        tt-movto.cod-localiz ";"
        tt-movto.tipo-char   ";"
        tt-movto.nr-dias     ";"
        tt-movto.quantidade  ";"
        tt-movto.preco       ";"
        tt-movto.vl-total    ";"
        SKIP.

END.

OUTPUT STREAM str-excel CLOSE.

IF tt-param.destino = 3 THEN
DOS SILENT START excel value(c-excel).

/*fechamento do output do relat¢rio*/
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.

