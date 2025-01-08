/* es0001.i  - include para retornar a descricao do item */

FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = cIt-codigo NO-ERROR.
    IF AVAIL ITEM THEN
       ASSIGN cDesc-Item = ITEM.desc-item.
