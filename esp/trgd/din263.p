/********************************************************************************
 ** UPC........: din263.p - UPC DELETE operacao
 ** Data.......: 28/03/2013
 ** Objetivo...: 
 ** Vers∆o....: 001 - Desenvolvimento Programa
 ** Vers∆o....: 002 - 
 ********************************************************************************/

{utp/ut-glob.i}
{esp/es0018.i}

DEF PARAM BUFFER b-operacao     FOR operacao.
DEF VAR v_log AS CHAR NO-UNDO.
DEFINE VARIABLE ix    AS INTEGER   NO-UNDO INITIAL 2. 
DEFINE VARIABLE plist AS CHARACTER NO-UNDO FORMAT "x(70)".
DEFINE VARIABLE l-teste AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-dir AS CHARACTER   NO-UNDO.


/* validaá∆o para evitar perda de hist¢rico, quando eliminava operaá∆o j† relacionada a uma ordem de produá∆o - SENSUS */
FIND FIRST oper-ord NO-LOCK
    WHERE  oper-ord.it-codigo   = b-operacao.it-codigo
    AND    oper-ord.cod-roteiro = b-operacao.cod-roteiro
    AND    oper-ord.op-codigo   = b-operacao.op-codigo NO-ERROR.
IF  AVAIL  oper-ord THEN DO:
    RUN utp/ut-msgs.p (INPUT "show":U, 
                       INPUT 17006, 
                       INPUT "OPERAÄ«O N«O PODE SER ELIMINADA" + '~~' +
                             "Operaá∆o " + STRING(b-operacao.op-codigo) + " est† relacionada a Ordem de Produá∆o: " + 
                                           string(oper-ord.nr-ord-produ) + ", Item: " + string(oper-ord.it-codigo) + "." +
                                           CHR(10) + "N∆o pode ser eliminada.").
    RETURN "NOK".
END. /* IF  AVAIL  oper-ord */

FOR FIRST int-ext-operacao USE-INDEX index2
    WHERE int-ext-operacao.num-id-operacao = b-operacao.num-id-operacao
          EXCLUSIVE-LOCK: END.

IF AVAIL int-ext-operacao
THEN DELETE int-ext-operacao.

