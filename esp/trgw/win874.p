/********************************************************************************
 ** UPC.......: win874.p - UPC WRITE docto-orig-nfse
 ** Data......: 21/09/2022
 ** Objetivo..: Ajustar data de transa‡Æo na entrada do xml de nota de servi‡o. 
********************************************************************************/

DEF PARAM BUFFER b-docto-orig-nfse     FOR docto-orig-nfse.
DEF PARAM BUFFER b-old-docto-orig-nfse FOR docto-orig-nfse.

IF  NEW b-docto-orig-nfse THEN DO:
    
    /*
    OUTPUT TO "\\erpapp\spool\an052677\nfs\log_v360.txt" APPEND.
    PUT UNFORMATTED "1 - win874 - b-docto-orig-nfse.serie-docto " b-docto-orig-nfse.serie-docto SKIP
                    "b-docto-orig-nfse.nro-docto " b-docto-orig-nfse.nro-docto                  SKIP
                    "b-docto-orig-nfse.cod-emitente " b-docto-orig-nfse.cod-emitente            SKIP
                    "b-docto-orig-nfse.nat-operacao " b-docto-orig-nfse.nat-operacao            SKIP
                    "b-docto-orig-nfse.idi-orig-trad " b-docto-orig-nfse.idi-orig-trad          SKIP(2).
    OUTPUT CLOSE.                                
    */

    ASSIGN b-docto-orig-nfse.dt-transacao = TODAY.

    IF  b-docto-orig-nfse.des-narrat = "" THEN
        ASSIGN b-docto-orig-nfse.des-narrat = "." .

    IF  b-docto-orig-nfse.idi-orig-trad = 2 THEN DO:

        /*
        OUTPUT TO "\\erpapp\spool\an052677\nfs\log_v360.txt" APPEND.
        PUT UNFORMATTED "2 - win874 - b-docto-orig-nfse.serie-docto " b-docto-orig-nfse.serie-docto SKIP
                        "b-docto-orig-nfse.nro-docto " b-docto-orig-nfse.nro-docto                  SKIP
                        "b-docto-orig-nfse.cod-emitente " b-docto-orig-nfse.cod-emitente            SKIP
                        "b-docto-orig-nfse.nat-operacao " b-docto-orig-nfse.nat-operacao            SKIP
                        "b-docto-orig-nfse.idi-orig-trad " b-docto-orig-nfse.idi-orig-trad          SKIP(2).
        OUTPUT CLOSE.  
        */

        FIND FIRST docto-orig-nfse
             WHERE entry(1,docto-orig-nfse.serie-docto,";") = b-docto-orig-nfse.serie-docto
             AND   docto-orig-nfse.nro-docto     = b-docto-orig-nfse.nro-docto   
             AND   docto-orig-nfse.cod-emitente  = b-docto-orig-nfse.cod-emitente
             /*AND   docto-orig-nfse.nat-operacao  = b-docto-orig-nfse.nat-operacao*/
             AND   docto-orig-nfse.idi-orig-trad = 1 NO-LOCK NO-ERROR.
    
        IF  AVAIL docto-orig-nfse THEN DO:
            /*
            OUTPUT TO "\\erpapp\spool\an052677\nfs\log_v360.txt" APPEND.
            PUT UNFORMATTED "3 - win874 - docto-orig-nfse.serie-docto " docto-orig-nfse.serie-docto SKIP
                            "docto-orig-nfse.nro-docto " docto-orig-nfse.nro-docto                  SKIP
                            "docto-orig-nfse.cod-emitente " docto-orig-nfse.cod-emitente            SKIP
                            "docto-orig-nfse.idi-orig-trad " docto-orig-nfse.idi-orig-trad          SKIP(2).
            OUTPUT CLOSE.  
            */

            ASSIGN b-docto-orig-nfse.cod-livre-1 = ENTRY(3,docto-orig-nfse.serie-docto,";").
        END.
    END.
END.

RETURN "OK".
