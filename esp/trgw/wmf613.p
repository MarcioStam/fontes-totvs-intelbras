/********************************************************************************
 ** UPC........: wmf613.p - UPC TRIGGER WRITE DP-PROCESS-ITEM 
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes das unidades de federa‡Æo para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-dp-proces-item      FOR dp-proces-item.
DEF PARAM BUFFER b-old-dp-proces-item  FOR dp-proces-item.
/*
IF b-old-dp-proces-item.ind-aprov <= 2 AND 
  (b-dp-proces-item.ind-aprov     >= 3 OR 
   b-dp-proces-item.ind-aprov     <= 5) THEN DO:

   FOR FIRST dp-estrut OF b-dp-proces-item NO-LOCK:
       FOR FIRST dp-item OF b-dp-proces-item NO-LOCK,
           FIRST ITEM FIELDS(it-codigo tipo-contr) NO-LOCK
           WHERE ITEM.it-codigo = dp-item.it-codigo:
       END.
       IF NOT AVAIL ITEM OR item.tipo-contr = 4 THEN
       DO:
           MESSAGE "Item (" dp-item.it-codigo ") sem CTR cadastrada. NÆo pode ser aprovado."  SKIP(1)
                   "Deve-se primeiro cadastrar CTR e informa-lo no campo destino"
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN "NOK".
       END.
   END.
END.
*/
/*
        DISP dp-proces-item.item-dp 
             dp-proces-item.num-proces-item
             dp-item.niv-mais-bai
             dp-proces-item.ind-aprov
             WITH WIDTH 200.
             /*dp-item.it-codigo */
             /*dp-item.item-dp */
    END.

*/
