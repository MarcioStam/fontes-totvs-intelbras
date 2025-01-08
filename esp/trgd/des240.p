/********************************************************************************
 ** UPC........: des240.p - UPC DELETE acordo
 ** Data.......: Mar‡o / 2007
 ** Objetivo...: Repassa inclusäes e modifica‡äes de aciordo para a Base Oracle
 ********************************************************************************/

TRIGGER PROCEDURE FOR DELETE OF acordo-com.

run esp/es0669.p (input "no",
                  "acordo-com",
                   string(acordo-com.cgc),
                   string(acordo-com.periodo),
                   "", "", "", "", "", "", "").

