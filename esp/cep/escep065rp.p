
/* include de controle de versÆo */
{include/i-prgvrs.i ESCEP065RP 2.00.00.000}

/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{esp/cep/escep065.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

/* recebimento de parƒmetros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}

/* defini‡Æo de vari veis  */
DEFINE VARIABLE h-acomp     AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-aux       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-mensagem  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-status    AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-impressao AS CHARACTER    NO-UNDO.

/* include padrÆo para output de relat¢rios */
{include/i-rpout.i}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i}

FOR FIRST tt-param:
END.

/* bloco principal do programa */
ASSIGN  c-programa 	    = "ESCEP065"
	    c-versao	    = "2.00"
	    c-revisao	    = ".00.000"
	    c-empresa       = "Intelbr s"
	    c-sistema	    = "CEP"
	    c-titulo-relat  = "Inconsistencias de AEs".


/* para nÆo visualizar cabe‡alho/rodap‚ em sa¡da RTF */
IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

/* executando de forma persistente o utilit rio de acompanhamento */
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Finalizando_Ordens *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

/* corpo do relat¢rio */


RUN pi-trata.


DISP "Processo conclu¡do com sucesso." FORMAT "X(35)" SKIP.


PAGE.


disp skip(1)
     "PARAMETROS" NO-LABEL
     SKIP(1)
     tt-param.cod-estabel           AT 2
     tt-param.cod-depos             AT 9
     tt-param.arq-csv               AT 6
     with frame f-parametros width 132 stream-io side-labels.


disp skip(3)
     "IMPRESSÇO"
     SKIP(1)
     "Destino:" at 10
     " - " tt-param.arquivo 
     skip
     "Usu rio:" at 10
     tt-param.usuario 
     with frame f-impressao width 132 stream-io no-labels.




/*fechamento do output do relat¢rio*/
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.
RETURN "OK":U.






PROCEDURE pi-trata:

    def var c-linha     as char format "x(200)"     no-undo.
    DEF VAR l-liberado AS LOGICAL NO-UNDO.
    
    DEF BUFFER b-saldo-estoq FOR saldo-estoq.

    
    OUTPUT TO value(tt-param.arq-csv).
    
    FOR EACH local WHERE local.loc-unica   = NO                   AND
                         local.cod-estabel = tt-param.cod-estabel AND
                         local.cod-depos   = tt-param.cod-depos   NO-LOCK:
        
        FIND FIRST saldo-estoq use-index dep-estabel
             where saldo-estoq.cod-estabel = local.cod-estabel
               and saldo-estoq.cod-depos   = local.cod-depos 
               and saldo-estoq.cod-localiz = local.localizacao
               and saldo-estoq.qtidade-atu > 0 no-lock no-error.
        IF AVAIL saldo-estoq THEN DO:
            PUT local.localizacao ";Localizacao Tem saldo." SKIP.
            NEXT.
        END.
    
        FIND FIRST ae-baixa WHERE ae-baixa.cod-estabel = local.cod-estabel AND
                                  ae-baixa.localizacao = local.localizacao NO-LOCK NO-ERROR.
        IF AVAIL ae-baixa THEN DO:
            PUT local.localizacao ";Localizacao esta no baixado." SKIP.
            NEXT.
        END.
    
        assign l-liberado = yes.
        
        for each b-saldo-estoq use-index dep-estabel
            where b-saldo-estoq.cod-estabel = local.cod-estabel
              and b-saldo-estoq.cod-depos   = local.cod-depos 
              and b-saldo-estoq.cod-localiz = local.localizacao no-lock:
    
            FIND FIRST int-saldo-estoq 
                 where int-saldo-estoq.cod-estabel = b-saldo-estoq.cod-estabel
                   and int-saldo-estoq.cod-depos   = b-saldo-estoq.cod-depos
                   and int-saldo-estoq.it-codigo   = b-saldo-estoq.it-codigo
                   and int-saldo-estoq.cod-localiz = b-saldo-estoq.cod-localiz
                   and not int-saldo-estoq.log-baixado no-error.
                 
            if avail int-saldo-estoq THEN DO:
                assign l-liberado = no
                       int-saldo-estoq.log-baixado = YES.
    
            END.
        END.
        
        IF NOT l-liberado THEN DO:
            PUT local.localizacao ";Localizacao Foi liberada." SKIP.
            NEXT.
        END.
        
        PUT local.localizacao ";LIVRE." SKIP.        
    
    
    END.
    OUTPUT CLOSE.
    
    



END PROCEDURE.
