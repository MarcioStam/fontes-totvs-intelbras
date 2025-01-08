/********************************************************************************
 ** UPC........: win668.p - UPC WRITE Item-fornec-estab
 ** Data.......: Dezembro / 2021
 ** Objetivo...: Trava alteracao no campo item-do-forn
 ********************************************************************************/

DEF PARAM BUFFER b-item-fornec-estab     FOR item-fornec-estab.
DEF PARAM BUFFER b-old-item-fornec-estab  FOR item-fornec-estab.

IF NOT NEW b-item-fornec-estab THEN DO:    
    IF PROGRAM-NAME(1) MATCHES "*boin688.p"
    OR PROGRAM-NAME(2) MATCHES "*boin688.p"
    OR PROGRAM-NAME(3) MATCHES "*boin688.p"
    OR PROGRAM-NAME(4) MATCHES "*boin688.p"
    OR PROGRAM-NAME(5) MATCHES "*boin688.p"
    OR PROGRAM-NAME(6) MATCHES "*boin688.p"
    OR PROGRAM-NAME(1) MATCHES "*esapi603.p"
    OR PROGRAM-NAME(2) MATCHES "*esapi603.p"
    OR PROGRAM-NAME(3) MATCHES "*esapi603.p"
    OR PROGRAM-NAME(4) MATCHES "*esapi603.p"
    OR PROGRAM-NAME(5) MATCHES "*esapi603.p"
    OR PROGRAM-NAME(6) MATCHES "*esapi603.p" THEN DO:

        ASSIGN b-item-fornec-estab.item-do-forn = b-old-item-fornec-estab.item-do-forn.
    END.
END.


/*     MESSAGE "1" PROGRAM-NAME(1) SKIP              */
/*             "2" PROGRAM-NAME(2) SKIP              */
/*             "3" PROGRAM-NAME(3) SKIP              */
/*             "4" PROGRAM-NAME(4) SKIP              */
/*             "5" PROGRAM-NAME(5)                   */
/*         VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */


