{include/i-prgvrs.i ESOFP006 2.06.00.001}
/***********************************************************************
**  Programa..: ESP\OFP\ESOFP006RP.P
**  Autor.....: Hoepers
**  Data......: 23/01/2013
**  Descricao.: Registro Apuraá∆o IPI
**  Vers∆o....: 001 23/01/2013 - Desenvolvimento
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ofp/esofp006tt.i}

{include/i-rpvar.i}

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-dat-tmp AS DATE        NO-UNDO.


DEF TEMP-TABLE tt-apuracao-ipi NO-UNDO
    FIELD cod-tipo     AS CHAR
    FIELD ano          AS INT
    FIELD mes          AS INT
    FIELD cgc          LIKE estabelec.cgc
    FIELD cod-cfop     LIKE doc-fiscal.cod-cfop    
    FIELD vl-bipi-it   LIKE it-doc-fisc.vl-bipi-it 
    FIELD vl-ipi-it    LIKE it-doc-fisc.vl-ipi-it  
    FIELD vl-ipint-it  LIKE it-doc-fisc.vl-ipint-it
    FIELD vl-ipiou-it  LIKE it-doc-fisc.vl-ipiou-it
    INDEX id-apuracao
            cod-cfop.

/***********************************************************************/

create tt-param.
raw-transfer raw-param to tt-param.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Registro Apuraá∆o IPI"
       c-programa     = "ESOFP006"
       c-versao       = "2.06"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i &pagesize = 0}

   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").

   FIND estabelec NO-LOCK
       WHERE estabelec.cod-estabel = tt-param.cod-estabel NO-ERROR.

   EMPTY TEMP-TABLE tt-apuracao-ipi.

   IF  tt-param.tipo-nota = 1
   THEN
       run pi-gera-relatorio (INPUT 11). /* Entrada */
   ELSE
       run pi-gera-relatorio (INPUT 12). /* Sa°da   */

   RUN pi-imprime.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-gera-relatorio:

    DEF INPUT PARAM p-tipo-docto AS INT NO-UNDO.

    DO v-dat-tmp = tt-param.da-ini TO tt-param.da-fim:

        FOR EACH  doc-fiscal NO-LOCK
            WHERE doc-fiscal.dt-docto    = v-dat-tmp 
              AND doc-fiscal.tipo-nat    = tt-param.tipo-nota
              AND doc-fiscal.cod-estabel = tt-param.cod-estabel
              AND doc-fiscal.ind-sit-doc = 1: /* Normal */

            RUN pi-acompanhar IN h-acomp (INPUT ENTRY(tt-param.tipo-nota, "Entradas,Sa°das") + " - Data: " + STRING(doc-fiscal.dt-docto)).

            bloco_item_nf:
            FOR EACH it-doc-fisc OF doc-fiscal NO-LOCK:

                IF  tt-param.log-zerado      = NO AND
                    it-doc-fisc.vl-bipi-it   = 0  AND
                    it-doc-fisc.vl-ipi-it    = 0  AND
                    it-doc-fisc.vl-ipint-it  = 0  AND
                    it-doc-fisc.vl-ipiou-it  = 0
                THEN
                    NEXT bloco_item_nf.

                FIND FIRST tt-apuracao-ipi 
                    WHERE  tt-apuracao-ipi.cod-cfop = doc-fiscal.cod-cfop NO-ERROR.

                IF  NOT AVAIL tt-apuracao-ipi
                THEN DO:
                    CREATE tt-apuracao-ipi.
                    ASSIGN tt-apuracao-ipi.cod-cfop = doc-fiscal.cod-cfop
                           tt-apuracao-ipi.cod-tipo = "R" + STRING(p-tipo-docto,"99")
                           tt-apuracao-ipi.cgc      = estabelec.cgc
                           tt-apuracao-ipi.ano      = YEAR(tt-param.da-ini)
                           tt-apuracao-ipi.mes      = MONTH(tt-param.da-ini).
                END.

                ASSIGN tt-apuracao-ipi.vl-bipi-it   = tt-apuracao-ipi.vl-bipi-it  + it-doc-fisc.vl-bipi-it 
                       tt-apuracao-ipi.vl-ipi-it    = tt-apuracao-ipi.vl-ipi-it   + it-doc-fisc.vl-ipi-it  
                       tt-apuracao-ipi.vl-ipint-it  = tt-apuracao-ipi.vl-ipint-it + it-doc-fisc.vl-ipint-it
                       tt-apuracao-ipi.vl-ipiou-it  = tt-apuracao-ipi.vl-ipiou-it + it-doc-fisc.vl-ipiou-it.

            END. /* FOR EACH it-doc-fisc OF doc-fiscal NO-LOCK: */
        END. /* FOR EACH  doc-fiscal NO-LOCK */
    END. /* DO v-dat-tmp = tt-param.da-ini TO tt-param.da-fim: */
END PROCEDURE.


PROCEDURE pi-imprime:
    FOR EACH tt-apuracao-ipi:
        PUT tt-apuracao-ipi.cod-tipo           FORMAT "x(3)"
            tt-apuracao-ipi.cgc                FORMAT "99999999999999"
            "              "              
            tt-apuracao-ipi.cgc                FORMAT "99999999999999"
            tt-apuracao-ipi.ano                FORMAT "9999"
            tt-apuracao-ipi.mes                FORMAT "99"
            "0"
            tt-apuracao-ipi.cod-cfop           FORMAT "9999"
            tt-apuracao-ipi.vl-bipi-it   * 100 FORMAT "99999999999999"
            tt-apuracao-ipi.vl-ipi-it    * 100 FORMAT "99999999999999"
            tt-apuracao-ipi.vl-ipint-it  * 100 FORMAT "99999999999999"
            tt-apuracao-ipi.vl-ipiou-it  * 100 FORMAT "99999999999999"
            SKIP.
    END.
END PROCEDURE.

