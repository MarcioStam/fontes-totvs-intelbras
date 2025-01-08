TRIGGER PROCEDURE FOR WRITE OF ext-embarque-imp
        NEW BUFFER new-embarque-imp 
        OLD BUFFER old-embarque-imp.
/*        
{esp/esapi505b.i}  
IF new-embarque-imp.log-envio-comex <> old-embarque-imp.log-envio-comex 
THEN DO:
   IF new-embarque-imp.log-envio-comex = YES
   THEN RUN pi-output-api-request  ("CEX",
                                    "1",
                                    "ProcessoEX-NEW",
                                    "TRIGGER",
                                    new-embarque-imp.cod-estabel + "," + new-embarque-imp.embarque,
                                    lcRequest
                                   ).
END.   
*/
RETURN "OK".
