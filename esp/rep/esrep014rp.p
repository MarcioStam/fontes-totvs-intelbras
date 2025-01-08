/***********************************************************************
**  Programa..: ESP\REP\ESREP013RP.P
**  Autor.....: Clayton Antunes
**  Data......: JANEIRORO/2007 - Desenvolvimento
**  Descricao.: NF de Entrada
**  VersÆo....: 001 24/01/2006
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESREP013 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/rep/esrep014tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

DEF VAR dt-data AS DATE INITIAL TODAY FORMAT "99/99/9999".

/****************************  Temp-Tables  ****************************/
DEF TEMP-TABLE tt-imposto  
    FIELD cod-estabel       LIKE docum-est.cod-estabel
    FIELD dt-emissa-nf      LIKE docum-est.dt-trans
    FIELD dt-venc-imp       LIKE dupli-imp.dt-venc-imp
    FIELD rend-trib         LIKE dupli-imp.rend-trib
    FIELD aliquota          LIKE dupli-imp.aliquota
    FIELD vl-imposto        LIKE dupli-imp.vl-imposto
    FIELD int-1             LIKE dupli-imp.int-1
    FIELD cod-esp           LIKE dupli-imp.cod-esp
    FIELD nro-docto-imp     LIKE dupli-imp.nro-docto-imp
    FIELD cod-retencao      LIKE dupli-imp.cod-retencao
    field cod-emitente      like docum-est.cod-emitente.


/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEF VAR h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Impostos Retidos"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESREP013"
       c-versao       = "2.04"
       c-revisao      = "001".


/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i &pagesize="0"}

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    RUN piMontaRelat.

    RUN pi-finalizar in h-acomp. 

    {include/i-rpclo.i} 

    RETURN "OK".
END.



PROCEDURE piMontaRelat.

    FOR EACH tt-imposto:
        DELETE tt-imposto.
    END.

    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

    PUT UNFORMATTED
       "Est;Dt.EmissÆo;Dt.Venc.Imp.;Rend.Tributados;Al¡q.;VL.Impostos;C¢d.Imposto;Esp.;Emitente;Docto.Imposto;C¢d.Reten‡Æo " SKIP.
                                                                                                                                                 
    do dt-data = tt-param.data-ini to tt-param.data-fim:                
        FOR EACH docum-est NO-LOCK
           WHERE docum-est.dt-trans = dt-data
             AND docum-est.cod-estabel >= tt-param.cod-estabel-ini
             AND docum-est.cod-estabel <= tt-param.cod-estabel-fim:
            run pi-acompanhar in h-acomp (input "Documento " + docum-est.nro-docto).
            

            FOR EACH dupli-imp NO-LOCK WHERE 
                     dupli-imp.nro-docto    = docum-est.nro-docto     AND
                     dupli-imp.serie-docto  = docum-est.serie-docto   AND
                     dupli-imp.cod-emitente = docum-est.cod-emitente  AND
                     dupli-imp.nat-operacao = docum-est.nat-operacao  AND 
                     dupli-imp.cod-esp      >= tt-param.especie-ini   AND 
                     dupli-imp.cod-esp      <= tt-param.especie-fim:
                CREATE tt-imposto.
                ASSIGN tt-imposto.cod-estabel   = docum-est.cod-estabel
                       tt-imposto.dt-emissa-nf  = docum-est.dt-trans   
                       tt-imposto.dt-venc-imp   = dupli-imp.dt-venc-imp
                       tt-imposto.rend-trib     = dupli-imp.rend-trib
                       tt-imposto.aliquota      = dupli-imp.aliquota
                       tt-imposto.vl-imposto    = dupli-imp.vl-imposto
                       tt-imposto.int-1         = dupli-imp.int-1
                       tt-imposto.cod-esp       = dupli-imp.cod-esp
                       tt-imposto.nro-docto-imp = dupli-imp.nro-docto-imp
                       tt-imposto.cod-retencao  = dupli-imp.cod-retencao
                       tt-imposto.cod-emitente  = docum-est.cod-emitente.
            END.
        END.
    end.

    FOR EACH tt-imposto:
        PUT tt-imposto.cod-estabel                                  ";"
            tt-imposto.dt-emissa-nf   FORMAT "99/99/9999"           ";"
            tt-imposto.dt-venc-imp        FORMAT "99/99/9999"       ";"
            tt-imposto.rend-trib          FORMAT "->>>,>>>,>>9.99"  ";"
            tt-imposto.aliquota           FORMAT ">>9.99"           ";"
            tt-imposto.vl-imposto         FORMAT ">>>,>>>,>>9.99"   ";"
            tt-imposto.int-1              FORMAT "->>>>>>9"         ";"
            tt-imposto.cod-esp            FORMAT "x(2)"             ";"
            tt-imposto.cod-emitente       format ">>>>>>>>9"        ";"
            tt-imposto.nro-docto-imp                                ";"
            tt-imposto.cod-retencao       skip.
    END.
END.
