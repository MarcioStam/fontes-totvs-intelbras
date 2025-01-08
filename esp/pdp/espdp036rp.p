/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp036rp.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Janeiro/2008 - Desenvolvimento
**  Descricao.: Relat¢rio de pedidos em carteira
-----------------------------------------------------------------------*/

/*---------------------------  Variaveis    ---------------------------*/
{include/i-prgvrs.i espdp036 2.04.00.001}
{include/i-rpvar.i}
{utp/ut-glob.i}

FIND FIRST param-global NO-LOCK.
FIND FIRST mgcad.empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Pedidos em carteira"
       c-empresa      = IF AVAILABLE empresa THEN mgcad.empresa.razao-social ELSE ''
       c-programa     = "ESPDP036"
       c-versao       = "2.04"
       c-revisao      = "002".

{esp/pdp/espdp036tt.i}

DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.

/*---------------------------  Parƒmetros   ---------------------------*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
   {include/i-rpout.i &pagesize="0"}
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

   RUN piImprimeRelat.

   RUN pi-finalizar IN h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
END.



PROCEDURE piImprimeRelat:
FOR EACH indice-cgc,
    FIRST emitente 
    WHERE emitente.cgc BEGINS indice-cgc.cgc NO-LOCK:
    RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Cliente : " + STRING(emitente.cod-emitente)).
    DISP emitente.cod-emitente 
         indice-cgc.cgc
         emitente.cgc
         emitente.cod-gr-cli
         emitente.nome-emit
         indice-cgc.unid-neg
         indice-cgc.indice
        WITH WIDTH 500 64 DOWN.
        
END.
END.
