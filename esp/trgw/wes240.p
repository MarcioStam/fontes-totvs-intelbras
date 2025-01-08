/********************************************************************************
 ** UPC........: wes240.p - UPC WRITE acordo
 ** Data.......: Mar‡o / 2007
 ** Objetivo...: Repassa inclusäes e modifica‡äes de acordo para a Base Oracle
 ********************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF acordo-com.

run esp/es0669.p (input "yes",
                  "acordo-com",
                  string(acordo-com.cgc),
                  string(acordo-com.periodo),
                  "","", "", "", "", "", "").
