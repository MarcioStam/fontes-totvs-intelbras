/********************************************************************************
 ** UPC........: win403.p - UPC WRITE saldo-estoq
 ** Data.......: Mar‡o / 2007
 ** Objetivo...: Repassa inclusäes e modifica‡äes de acordo para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-saldo-estoq      FOR saldo-estoq.
DEF PARAM BUFFER b-old-saldo-estoq  FOR saldo-estoq.


IF  PROGRAM-NAME(1)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(2)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(3)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(4)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(5)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(6)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(7)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(8)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(9)  MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(10) MATCHES "*esftp016rp*" OR
    PROGRAM-NAME(11) MATCHES "*esftp016rp*" OR

    PROGRAM-NAME(1)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(2)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(3)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(4)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(5)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(6)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(7)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(8)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(9)  MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(10) MATCHES "*espdp006rp*" OR
    PROGRAM-NAME(11) MATCHES "*espdp006rp*" THEN LEAVE.
ELSE DO:

    IF  (b-saldo-estoq.cod-depos    = "EXP" OR b-saldo-estoq.cod-depos    = "WEX" OR b-saldo-estoq.cod-depos    = "WEC") AND
        b-saldo-estoq.cod-localiz <> "" and
       (b-saldo-estoq.qt-alocada  <> 0 or
        b-saldo-estoq.qt-aloc-ped <> 0) THEN DO:

        IF OPSYS <> 'UNIX' THEN
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "WIN403.P - NAO EH PERMITIDO ALOCAR EM DEPOSITO EXP LOCALIZACAO DIFERENTE DE BRANCO!").
        ELSE
            PUT "WIN403.P - NAO EH PERMITIDO ALOCAR EM DEPOSITO EXP LOCALIZACAO DIFERENTE DE BRANCO!" SKIP.
        
         ASSIGN ERROR-STATUS:ERROR = YES.
        IF     PROGRAM-NAME(1) MATCHES '*ft4004*'
            OR PROGRAM-NAME(2) MATCHES '*ft4004*'
            OR PROGRAM-NAME(3) MATCHES '*ft4004*'
            OR PROGRAM-NAME(4) MATCHES '*ft4004*'
            OR PROGRAM-NAME(5) MATCHES '*ft4004*' 
            OR PROGRAM-NAME(6) MATCHES '*ft4004*'
            OR PROGRAM-NAME(7) MATCHES '*ft4004*'
            OR PROGRAM-NAME(8) MATCHES '*ft4004*'
            OR PROGRAM-NAME(9) MATCHES '*ft4004*'  THEN 
            RETURN 'OK'.
        ELSE
            RETURN 'NOK'.
            
    END.

END.
