{include/i-prgvrs.i ESUTP016 2.04.00.000}
/***********************************************************************
**  Programa..: ESP\REP\ESUTP016RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: JULHO/2008 - Desenvolvimento
**  Descricao.: Relat¢rio Tarifador
**  VersÆo....: 001 01/10/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/utp/esutp016tt.i}

{utp/utapi009.i}
{utp/ut-glob.i}
{include/i-rpvar.i}
{upc/btb910za-upc.i}

/****************************  Temp-Tables  ****************************/

DEFINE TEMP-TABLE tt-sintetico NO-UNDO
    FIELD ramal      AS CHARACTER FORMAT "x(20)"
    FIELD nome       AS CHARACTER FORMAT "x(40)"
    FIELD cc-codigo  AS CHARACTER FORMAT "x(40)"
    FIELD qtde       AS INTEGER FORMAT ">,>>>,>>9"
    FIELD qtde-aval  AS INTEGER FORMAT ">,>>>,>>9"
    FIELD qtde-pend  AS INTEGER FORMAT ">,>>>,>>9"
    FIELD valor      AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELD valor-aval AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELD valor-pend AS DECIMAL FORMAT "->>>,>>>,>>9.99". 

DEFINE TEMP-TABLE tt-analitico NO-UNDO LIKE tarifador
    FIELD nome      AS CHARACTER FORMAT "x(40)"
    FIELD cc-codigo AS CHARACTER FORMAT "x(40)".

DEF VAR h-acomp      as handle no-undo.

/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Tarifador"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESUTP016"
       c-versao       = "2.04"
       c-revisao      = "001".

FOR EACH tt-sintetico:
    DELETE tt-sintetico.
END.

FOR EACH tt-analitico:
    DELETE tt-analitico.
END.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    {include/i-rpout.i &pagesize="0"}

    RUN pi-carrega-dados.
    RUN pi-relatorio.
             
    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE pi-carrega-dados:

    RUN pi-inicializar in h-acomp (input "Carregando Informa‡äes...").

    IF tt-param.i-tipo = 1 THEN DO:
        FOR EACH tarifador NO-LOCK
           WHERE tarifador.ramal >= tt-param.c-ramal-ini
             AND tarifador.ramal <= tt-param.c-ramal-fim
             AND tarifador.data  >= tt-param.data-ini
             AND tarifador.data  <= tt-param.data-fim
             AND tarifador.numero MATCHES "*" + tt-param.c-telefone + "*"
             AND tarifador.tipo <> "TIM"
            BREAK BY tarifador.ramal:
            
            {esp/utp/esutp016rp.i}
        END.
    END.
    ELSE IF tt-param.i-tipo = 2 THEN DO:
        FOR EACH tarifador NO-LOCK
           WHERE tarifador.tipo   = "TIM"
             AND tarifador.ramal >= tt-param.c-ramal-ini
             AND tarifador.ramal <= tt-param.c-ramal-fim
             AND tarifador.data  >= tt-param.data-ini
             AND tarifador.data  <= tt-param.data-fim
             AND tarifador.numero MATCHES "*" + tt-param.c-telefone + "*"
            BREAK BY tarifador.ramal:
            
            {esp/utp/esutp016rp.i}
        END.
    END.
    ELSE DO:
        FOR EACH tarifador NO-LOCK
           WHERE tarifador.ramal >= tt-param.c-ramal-ini
             AND tarifador.ramal <= tt-param.c-ramal-fim
             AND tarifador.data  >= tt-param.data-ini
             AND tarifador.data  <= tt-param.data-fim
             AND tarifador.numero MATCHES "*" + tt-param.c-telefone + "*"

            BREAK BY tarifador.ramal:
            
            {esp/utp/esutp016rp.i}
        END.
    END.

END PROCEDURE.

PROCEDURE pi-relatorio:
    DEFINE VARIABLE c-situacao AS CHARACTER   NO-UNDO.

    RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio...").

    IF tt-param.i-relat = 1 THEN DO:
        /*Sint‚tico*/
        PUT UNFORMATTED 
            "Ramal;Nome;Centro Custo;Qtde Total;Qtde Aval.;Qtde Pend.;Valor Total;Valor Aval.;Valor Pend;% Pend.;" SKIP.

        FOR EACH tt-sintetico NO-LOCK:
            PUT UNFORMATTED 
                tt-sintetico.ramal      ";"
                tt-sintetico.nome       ";"
                tt-sintetico.cc-codigo  ";"
                tt-sintetico.qtde       ";"
                tt-sintetico.qtde-aval  ";"
                tt-sintetico.qtde-pend  ";"
                tt-sintetico.valor      ";"
                tt-sintetico.valor-aval ";"
                tt-sintetico.valor-pend ";"
                (tt-sintetico.qtde-pend / tt-sintetico.qtde * 100) ";" SKIP.
        END.
    END.
    ELSE DO:
        /*Anal¡tico*/
        PUT UNFORMATTED 
            "Ramal;Nome;Centro Custo;Data;Hora;Dura‡Æo;N£mero;Localidade;Valor;Finalidade;Avaliado;Dt.Aval.;Usuario;Cobrado;Cobran‡a;Situa‡Æo;" SKIP.

        FOR EACH tt-analitico NO-LOCK:
            IF tt-analitico.cobrado THEN
                ASSIGN c-situacao = "Cobrado".
            ELSE IF tt-analitico.avaliado THEN
                ASSIGN c-situacao = "Avaliado".
            ELSE 
                ASSIGN c-situacao = "Pendente".

            PUT UNFORMATTED 
                tt-analitico.ramal                                    ";"
                tt-analitico.nome                                     ";"  
                tt-analitico.cc-codigo                                ";"  
                tt-analitico.data                                     ";"
                tt-analitico.hora                                     ";"
                tt-analitico.duracao                                  ";"
                tt-analitico.numero                                   ";"
                tt-analitico.localidade                               ";"
                tt-analitico.valor                                    ";" 
                tt-analitico.finalidade   FORMAT "Particular/Servi‡o" ";"
                tt-analitico.avaliado     FORMAT "Sim/NÆo"            ";"
                tt-analitico.dt-avaliac                               ";" 
                tt-analitico.cod_usuario                              ";" 
                tt-analitico.cobrado      FORMAT "Sim/NÆo"            ";" 
                tt-analitico.periodo-cobranca                         ";" 
                c-situacao                                            ";" SKIP.
        END.
    END.
END PROCEDURE.


