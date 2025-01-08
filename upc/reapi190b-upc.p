/***********************************************************************
**  Programa..: upc\reapi190b-upc.p
**  Autor.....: Gustavo Eduardo Tamanini - SQL WORKS
**  Data......: Abril/2010
**  Descricao.: 
**  Vers∆o....: 001 25/05/2010 - Gustavo Eduardo Tamanini
**                  Desenvolvimento Programa
************************************************************************/

{include/i-epc200.i1}  /* definicao tt-epc */

DEF INPUT PARAMETER p-cod-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

DEFINE VARIABLE r-rowid AS ROWID NO-UNDO.

IF p-cod-event = "fim-reapi190":U THEN DO:

    FIND FIRST tt-epc WHERE
               tt-epc.cod-event     = "fim-reapi190":U    AND
               tt-epc.cod-parameter = "docum-est rowid":U NO-LOCK NO-ERROR.
    
    IF AVAIL tt-epc THEN DO:
        ASSIGN r-rowid = TO-ROWID(tt-epc.val-parameter).

        FIND FIRST docum-est WHERE 
             ROWID(docum-est) = r-rowid NO-LOCK NO-ERROR.

        IF AVAIL docum-est THEN DO:

            FIND FIRST item-doc-est OF docum-est NO-LOCK NO-ERROR.

            FIND FIRST pedido-compr WHERE
                       pedido-compr.num-pedido = item-doc-est.num-pedido NO-LOCK NO-ERROR.

            FIND FIRST cond-pagto WHERE
                       cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-LOCK NO-ERROR.

            IF AVAIL cond-pagto THEN DO:
                FIND FIRST int-cond-pagto WHERE 
                           int-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-LOCK NO-ERROR.

                IF AVAIL int-cond-pagto THEN DO:
                    /** Carta Credito **/
                    IF SUBSTRING(int-cond-pagto.char-1,2,1) = "S" THEN DO:
                        FIND FIRST dupli-apagar WHERE 
                                   dupli-apagar.serie-docto  = docum-est.serie-docto  AND 
                                   dupli-apagar.nro-docto    = docum-est.nro-docto    AND 
                                   dupli-apagar.cod-emitente = docum-est.cod-emitente AND 
                                   dupli-apagar.nat-operacao = docum-est.nat-operacao EXCLUSIVE-LOCK NO-ERROR. 

                        IF AVAIL dupli-apagar THEN DO:
                            ASSIGN dupli-apagar.dt-vencim = dupli-apagar.dt-vencim - 2.

                            IF  WEEKDAY(dupli-apagar.dt-vencim) = 1 OR 
                                WEEKDAY(dupli-apagar.dt-vencim) = 7 THEN
                                ASSIGN dupli-apagar.dt-vencim = dupli-apagar.dt-vencim - 2.

                            FIND FIRST param-estoq  NO-LOCK NO-ERROR.
                            FIND FIRST param-global NO-LOCK NO-ERROR.

                            REPEAT:                              
                                FIND FIRST calen-coml
                                     WHERE calen-coml.cod-estabel = param-estoq.estabel-pad
                                     AND   calen-coml.ep-codigo   = param-global.empresa-prin
                                     AND   calen-coml.data        = dupli-apagar.dt-vencim NO-LOCK NO-ERROR.
    
                                IF AVAIL calen-coml AND calen-coml.tipo-dia <> 1 THEN
                                    ASSIGN dupli-apagar.dt-vencim = dupli-apagar.dt-vencim - 1.
                                ELSE
                                    LEAVE.
                            END.                            
                        END.
                        RELEASE dupli-apagar.
                    END.
                END.
            END.
        END.
    END.
END.
