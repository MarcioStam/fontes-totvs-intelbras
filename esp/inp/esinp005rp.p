{include/i-prgvrs.i esinp005RP 2.00.00.000}  

define temp-table tt-param no-undo
    field destino             AS INTEGER
    field arquivo             AS CHAR format "x(35)"
    field usuario             AS CHAR format "x(12)"
    field data-exec           AS DATE
    field hora-exec           AS INTEGER.

def temp-table tt-raw-digita 
    FIELD raw-digita	as raw.

/* recebimento de parƒmetros */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.
/*{cdp/cdcfgdis.i}*/

DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.                                                        

/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}

/*{method/dbotterr.i}*/

/* bloco principal do programa */
ASSIGN c-programa     = "esinp005"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = "Intelbras"
       c-sistema      = "Obriga‡Æo Fiscal"
       c-titulo-relat = "Atualiza‡Æo Dados FiscoSoft".

/*include padrÆo para output de relat¢rios*/
{include/i-rpout.i}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i}

{include/tt-edit.i}
{include/pi-edit.i}

view frame f-cabec.
view frame f-rodape.

/* IF  NOT VALID-HANDLE(h-acomp) THEN                                   */
/*     RUN utp/ut-acomp.p PERSISTENT set h-acomp.                       */
/*                                                                      */
/* if valid-handle(h-acomp) then                                        */
/*     run pi-inicializar in h-acomp (input "Pesquisando Documentos").  */


RUN esp/inp/esinp003.p.
    
IF  RETURN-VALUE = "OK" THEN
    DISPLAY SKIP(3)
            "Atualiza‡Æo Realizada !" SKIP(1) WITH WIDTH 132 NO-BOX SIDE-LABELS COLUMN 5 FRAME fParam STREAM-IO.

{include/i-rpclo.i}

/* if valid-handle(h-acomp) then    */
/*     RUN pi-finalizar IN h-acomp. */
/*                                  */
RETURN "OK".

