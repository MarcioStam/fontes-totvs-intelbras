
/* include de controle de versÆo */
{include/i-prgvrs.i ESCPP037RP 2.00.00.000}

/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{esp/cpp/escpp037.i}



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
{include/i-rpout.i  }

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i  }

/* defini‡Æo de frames do relat¢rio */
FORM  
     ord-prod.nr-ord-produ COLUMN-LABEL 'Nrø Ord Prod'
     ord-prod.cod-estabel  COLUMN-LABEL 'Estabel'
     ord-prod.it-codigo
     ITEM.desc-item  
     ord-prod.dt-emissao
     ord-prod.qt-ordem
      WITH WIDTH 200 FRAME f-relat DOWN STREAM-IO. 


FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FOR FIRST tt-param:
END.

/* bloco principal do programa */
ASSIGN  c-programa 	    = "ESCPP037"
	    c-versao	    = "2.00"
	    c-revisao	    = ".00.000"
	    c-empresa       = "Intelbr s"
	    c-sistema	    = "CPP"
	    c-titulo-relat  = "Finaliza‡Æo de Ordens de Produ‡Æo".


/* para nÆo visualizar cabe‡alho/rodap‚ em sa¡da RTF */
IF tt-param.destino <> 4 THEN DO:
    VIEW   FRAME f-cabec. 
    VIEW   FRAME f-rodape. 
END.

/* executando de forma persistente o utilit rio de acompanhamento */
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Finalizando_Ordens *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

/* corpo do relat¢rio */


IF NOT CAN-FIND(FIRST tt-digita) THEN DO:

    for each ord-prod NO-LOCK
        WHERE ord-prod.it-codigo   >= tt-param.it-codigo-ini 
          AND ord-prod.it-codigo   <= tt-param.it-codigo-fim
          AND ord-prod.dt-inicio   >= tt-param.dt-ini 
          AND ord-prod.dt-inicio   <= tt-param.dt-fim 
          AND ord-prod.cod-estabel >= tt-param.cod-estabel-ini 
          AND ord-prod.cod-estabel <= tt-param.cod-estabel-fim:

        IF ord-prod.nr-linha    < tt-param.nr-linha-ini OR
           ord-prod.nr-linha    > tt-param.nr-linha-fim THEN NEXT.

        RUN pi-finaliza.
    END.

END.
ELSE DO:

    FOR EACH tt-digita:
        FOR FIRST ord-prod NO-LOCK
            WHERE ord-prod.nr-ord-produ = tt-digita.nr-ord-prod:

            RUN pi-finaliza.
        END.
    END.
END.    


PAGE.   


disp 
     skip(1)
     "SELE€ÇO" NO-LABEL
     SKIP(1)
     tt-param.dt-ini            to 32       "|<  >|"  AT 45         tt-param.dt-fim             at 55 no-label
     tt-param.cod-estabel-ini   to 25       "|<  >|"  AT 45         tt-param.cod-estabel-fim    at 55 no-label
     tt-param.nr-linha-ini      TO 25       "|<  >|"  AT 45         tt-param.nr-linha-fim       at 55 no-label
     tt-param.it-codigo-ini     to 38       "|<  >|"  AT 45         tt-param.it-codigo-fim      at 55 no-label
     with frame f-selecao width 132 stream-io side-labels.


disp  
     skip(3)
     "IMPRESSÇO"
     SKIP(1)
     "Destino:" at 10
     " - " tt-param.arquivo 
     skip
     "Usu rio:" at 10
     tt-param.usuario 
     with frame f-impressao width 132 stream-io no-labels.

/*fechamento do output do relat¢rio*/
{include/i-rpclo.i }
RUN pi-finalizar IN h-acomp.
RETURN "OK":U.


PROCEDURE pi-finaliza:

    IF AVAIL ord-prod THEN DO:

        IF ord-prod.estado = 7 THEN NEXT. //ORDEM JA FINALIZADA

        CASE ord-prod.estado:
           WHEN 1 THEN 
              IF NOT tt-param.nao-iniciada THEN NEXT.
           WHEN 2 THEN 
               IF NOT tt-param.liberada THEN NEXT.
           WHEN 3 THEN 
               IF NOT tt-param.reservada THEN NEXT.
           WHEN 4 THEN 
               IF NOT tt-param.separada THEN NEXT.
           WHEN 5 THEN 
              IF NOT tt-param.requisitada THEN NEXT.
           WHEN 6 THEN 
              IF NOT tt-param.iniciada THEN NEXT.
        END CASE.               

        FIND ITEM where item.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAIL ITEM THEN NEXT.

        /* Liberada */
        /*
        IF ord-prod.estado = 2 THEN DO:
            FIND FIRST movto-estoq
                 WHERE movto-estoq.nr-ord-prod = ord-prod.nr-ord-prod NO-LOCK NO-ERROR.
            IF NOT AVAIL movto-estoq THEN NEXT.
        END.*/

        RUN pi-acompanhar IN h-acomp (INPUT "Ordem: " + string(ord-prod.nr-ord-prod)).

        FIND CURRENT ord-prod EXCLUSIVE-LOCK.
        
        assign ord-prod.estado = 7.
    
        for each reservas EXCLUSIVE-LOCK
           where reservas.nr-ord-prod = ord-prod.nr-ord-prod:
            
            assign reservas.estado = 2.
        end.

        DISP ord-prod.nr-ord-prod          
             ord-prod.cod-estabel          
             ord-prod.it-codigo            
             ITEM.desc-item                
             ord-prod.dt-emissao           
             ord-prod.qt-ordem         
             "OP finalizada com Sucesso"
             WITH FRAME f-relat. 
             DOWN WITH FRAME f-relat.
    end.

END PROCEDURE.
