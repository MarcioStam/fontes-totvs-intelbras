/***********************************************************************
**  Programa..: ESP/REP/ESREP021RP.P
**  Autor.....: Emerson Colla
**  Data......: Maio/2010 - Desenvolvimento
**  Descricao.: Sumariza Ordens de Produ‡Æo
**  VersÆo....: 001 04/05/2010
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i escpp056 1.00.00.000}

/****************************  Definitions  ****************************/
{esp/cpp/escpp056tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

def var l-rej as logical.
def var i-ind        as int.
def var i-cod-emit   like emitente.cod-emit.
def var c-nome-emit  like emitente.nome-emit.



/****************************  Temp-Tables  ****************************/


/****************************  Frames       ****************************/
def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.


def var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Sumariza Ordens"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCPP056"
       c-versao       = "1.00"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpout.i &pagesize="0"}

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    run piRelat.

    RUN pi-finalizar in h-acomp.

    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE piRelat:        
    RUN pi-inicializar in h-acomp (INPUT "Sumarizando...").

    FOR EACH ord-prod EXCLUSIVE-LOCK  
        WHERE ord-prod.nr-req-sum = 0 AND
              ord-prod.cod-estabel = tt-param.cod-estabel,
        FIRST lin-prod FIELDS (sum-requis) NO-LOCK 
            WHERE lin-prod.nr-linha    = ord-prod.nr-linha AND
                  lin-prod.cod-estabel = ord-prod.cod-estabel AND
                  lin-prod.sum-requis  = 1:
     
        IF ord-prod.estado >= 7 THEN NEXT.
        ASSIGN ord-prod.nr-req-sum = ord-prod.nr-ord-produ.

    
        FIND FIRST cab-req-sum WHERE cab-req-sum.nr-req-sum = ord-prod.nr-ord-produ NO-LOCK NO-ERROR.
        IF NOT AVAIL cab-req-sum THEN DO:
            CREATE cab-req-sum.
            ASSIGN cab-req-sum.cod-estabel = ord-prod.cod-estabel
                   cab-req-sum.dt-fim-pri  = ord-prod.dt-termino
                   cab-req-sum.dt-fim-ult  = ord-prod.dt-termino
                   cab-req-sum.dt-ini-pri  = ord-prod.dt-inicio
                   cab-req-sum.dt-ini-ult  = ord-prod.dt-inicio
                   cab-req-sum.nr-linha    = ord-prod.nr-linha
                   cab-req-sum.nr-req-sum  = ord-prod.nr-req-sum.
        END.
        
     
    END.


end.




