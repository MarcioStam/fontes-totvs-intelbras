/********************************************************************************
 ** UPC........: dcx220.p - DELETE embarque-imp
 ** Data.......: Novembro / 2020
 ** Objetivo...: 
 ********************************************************************************/

DEF PARAM BUFFER bf-embarque-imp FOR embarque-imp.

{esp/esapi505b.i}  

FIND FIRST ext-embarque-imp EXCLUSIVE-LOCK
    WHERE ext-embarque-imp.cod-estabel    = bf-embarque-imp.cod-estabel
      AND ext-embarque-imp.embarque        = bf-embarque-imp.embarque 
      AND ext-embarque-imp.log-envio-comex = YES NO-ERROR.
IF AVAIL ext-embarque-imp THEN DO:
   RUN pi-output-api-request  ("CEX",
                               "1",
                               "ProcessoCEX-DEL",
                               "TRIGGER",
                               bf-embarque-imp.cod-estabel + "," + bf-embarque-imp.embarque,
                               lcRequest
                              ).
END.

FIND FIRST ext-embarque-imp EXCLUSIVE-LOCK
     WHERE ext-embarque-imp.cod-estabel = bf-embarque-imp.cod-estabel
       AND ext-embarque-imp.embarque    = bf-embarque-imp.embarque 
     NO-ERROR.
IF AVAIL  ext-embarque-imp 
THEN DELETE ext-embarque-imp .


