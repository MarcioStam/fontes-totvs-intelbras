{include/i-prgvrs.i ESOFP002 2.04.00.002}
/***********************************************************************
**  Programa..: ESP\OFP\ESOFP002RP.P
**  Autor.....: Cenci
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Relatorio IBAMA
**  VersÆo....: 002 05/09/08
**                  Desenvolvimento Programa

************************************************************************/

/****************************  Definitions  ****************************/
{esp/ofp/esofp002tt.i}

{include/i-rpvar.i}


/****************************  Temp-Tables  ****************************/

/****************************  Variaveis    ****************************/

/****************************  Frames       ****************************/


def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.
find first mgcad.empresa NO-LOCK
     where empresa.ep-codigo = tt-param.ep-codigo no-error.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Ressarcimento IPI"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESOFP002"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i &pagesize = 0}

   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run pi-imprime.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-imprime:
FOR EACH doc-fiscal NO-LOCK                            
    WHERE doc-fiscal.dt-docto    >= tt-param.da-ini           
      AND doc-fiscal.dt-docto    <= tt-param.da-fim           
      AND doc-fiscal.cod-estabel  = tt-param.c-cod-estabel 
      AND doc-fiscal.vl-ipi      <> 0 
      AND doc-fiscal.tipo-nat     = 1 
      AND doc-fiscal.ind-sit-doc = 1,
    FIRST emitente NO-LOCK
    WHERE emitente.cod-emitente = doc-fiscal.cod-emitente
    BREAK BY doc-fiscal.dt-docto:
    RUN pi-acompanhar IN h-acomp (INPUT STRING(doc-fiscal.dt-docto)).
    FIND estabelec
        WHERE estabelec.cod-estabel = doc-fiscal.cod-estabel
        NO-LOCK NO-ERROR.

    PUT "R13"
         estabelec.cgc FORMAT "99999999999999"
         "              "
         estabelec.cgc FORMAT "99999999999999".
        .
    
    IF emitente.pais = "brasil" AND
       emitente.natureza = 2 THEN
        PUT  string(DEC(emitente.cgc),"99999999999999") FORMAT "99999999999999".
    ELSE
        PUT  string(DEC(estabelec.cgc),"99999999999999") FORMAT "99999999999999".

    PUT  int(substring(doc-fiscal.nr-doc-fis,2,6)) FORMAT "999999999" AT 60
         doc-fiscal.serie      FORMAT "x(3)"    AT 69
         doc-fiscal.dt-emis-doc FORMAT "99999999" AT 72
         doc-fiscal.dt-docto    FORMAT "99999999" AT 80
         substring(doc-fiscal.nat-operacao,1,4) FORMAT "x(4)"   AT 88
         doc-fiscal.vl-cont-doc * 100 FORMAT "99999999999999" AT 92
         doc-fiscal.vl-ipi * 100 FORMAT "99999999999999" AT 106
         doc-fiscal.vl-ipi * 100 FORMAT "99999999999999" AT 120
         SKIP.
END.
END PROCEDURE.


