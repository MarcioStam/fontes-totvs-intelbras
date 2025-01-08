/********************************************************************************
 ** UPC........: dad209.p - UPC DELETE item-uni-estab    
 ** Data.......: Maio / 2008
 ** Objetivo...: Repassa inclusäes e modifica‡äes de iterm-uni-estab para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-item-uni-estab       FOR item-uni-estab.

run esp/es0669.p (input "no",
                  "item-uni-estab",
                  b-item-uni-estab.it-codigo,
                  b-item-uni-estab.cod-estabel,
                  "", "", "", "", "", "", "").

/*FOR FIRST int-item-uni-estab OF b-item-uni-estab EXCLUSIVE-LOCK:
    DELETE int-item-uni-estab.
END.*/
