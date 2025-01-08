/********************************************************************************
 ** UPC........: wdi154.p- UPC WRITE ped-item    
 ** Data.......: outubro / 2010
 ** Objetivo...: Repassa inclusäes e modifica‡äes dos itens do pedido de venda 
 **              para o CRM
 ********************************************************************************/

CREATE WIDGET-POOL.

DEF PARAM BUFFER b-dwf-alter-emit      FOR dwf-alter-emit.
DEF PARAM BUFFER b-old-dwf-alter-emit  FOR dwf-alter-emit.

DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-dir       AS CHARACTER   NO-UNDO.
{esp/es0018.i}
{utp/ut-glob.i}
    FIND emitente
         WHERE emitente.cod-emitente = int(b-dwf-alter-emit.cod-emitente)
         NO-LOCK NO-ERROR.

    MESSAGE "Conteudo alterado " SKIP
        b-dwf-alter-emit.num-campo SKIP
        trim(b-dwf-alter-emit.dsl-contdo-ant) SKIP
        TRIM(emitente.ins-estadual)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

IF b-dwf-alter-emit.num-campo = 7 THEN DO:
    FIND emitente
         WHERE emitente.cod-emitente = int(b-dwf-alter-emit.cod-emitente)
         NO-LOCK NO-ERROR.


    IF  trim(b-dwf-alter-emit.dsl-contdo-ant) <> TRIM(emitente.ins-estadual) THEN DO:
    END.
END.



DELETE WIDGET-POOL.


RETURN "ok".


