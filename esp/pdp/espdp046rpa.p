 /**********************************************************************************
** Programa: esp/pdp/espdp046rpa.p
** VersÆo..: 1.00
** Data....: 16/12/2013
** Autor...: Roger
** Obs.....: elimina‡Æo itens da tabela de pre‡os por faixa
**********************************************************************************/

{include/i-prgvrs.i espdp046rp 2.00.00.000}  

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD tp-execucao      AS INTEGER
    FIELD nr-tabpre        AS CHAR
    FIELD item-ini         AS CHAR FORMAT "x(16)"
    FIELD item-fim         AS CHAR FORMAT "x(16)".
                                         
DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

DEFINE TEMP-TABLE tt-erro-local NO-UNDO
    FIELD mensagem  AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem  AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD errorSequence     AS INT
    FIELD errorNumber       AS INT
    FIELD errorDescription  AS CHAR FORMAT "x(150)"
    FIELD errorParameters   AS CHAR
    FIELD errorType         AS CHAR
    FIELD errorHelp         AS CHAR FORMAT "x(150)"
    FIELD errorSubtype      AS CHAR.


/*--- Defini‡Æo das Vari veis ---*/

DEFINE VARIABLE l-erro  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-linha AS CHARACTER NO-UNDO.

/*------------------------*/
/*     I N C L U D E S    */
/*------------------------*/
/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{utp/ut-glob.i}


/* bloco principal do programa */
ASSIGN c-programa     = "espdp046"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = "Intelbras"
       c-sistema      = "Elimina‡Æo de Itens da tabela de pre‡os"
       c-titulo-relat = "Elimina‡Æo de Itens da tabela de pre‡os".

/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Eliminando itens da Tabela").

view frame f-cabec.
view frame f-rodape.    

DO TRANS:

    FOR FIRST tb-preco NO-LOCK
        WHERE tb-preco.nr-tabpre = tt-param.nr-tabpre:
    

        PUT sKIP(2) "  Elimina‡Æo de itens da Tabela: " tt-param.nr-tabpre "- " tb-preco.descricao  SKIP.
        PUT         "  Faixa: " tt-param.item-ini " at‚ " tt-param.item-fim SKIP(2). 

        PUT "Item             Data In¡cio Quant. Min    Pre‡o CIF          Pre‡o FOB   " SKIP
            "---------------- ----------- ------------- ------------------ ------------------" SKIP.

        FOR EACH preco-item EXCLUSIVE-LOCK 
            WHERE preco-item.nr-tabpre = tb-preco.nr-tabpre
              AND preco-item.it-codigo >= tt-param.item-ini
              AND preco-item.it-codigo <= tt-param.item-fim:
    
            FIND int-preco-item EXCLUSIVE-LOCK
                OF preco-item.
    
            IF  AVAIL int-preco-item THEN
                DELETE int-preco-item.

            PUT preco-item.it-codigo AT 1
                preco-item.dt-inival AT 18
                preco-item.quant-min TO 42
                preco-item.preco-venda TO 61
                preco-item.preco-fob TO 80 SKIP.
            
            DELETE preco-item.
        END.
    
    
    END.
END.

RUN pi-finalizar in h-acomp.


RETURN "OK":U.
