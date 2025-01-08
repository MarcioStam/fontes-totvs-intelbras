/************************************************************************
 ** Programa....: din182.p - UPC delete para a tabela cotacao-cotacao-item             **
 ** Data........: novembro/2009                                        **
 ************************************************************************/

define param buffer b-cotacao-item   for cotacao-item.
    /***** foi substituida pela trigger de assign ***/

FIND FIRST int-cotacao-item OF cotacao-item EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL int-cotacao-item THEN 
    DELETE int-cotacao-item.
