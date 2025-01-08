/*------------------------------------------------------------------------
    File        : ESCPP106.P
    Purpose     : Retorna informaá‰es do QRCODE
    Syntax      : <none>
    Description : <none>

    Author(s)   : Nicolas Martinez 
    Created     : Janeiro de 2020
    Notes       : <none>
----------------------------------------------------------------------*/

{esp/es0018.i}

DEFINE INPUT  PARAMETER c-it-codigo  AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER c-qr-code    AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER c-n-serie    AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER c-mac        AS CHAR NO-UNDO EXTENT 10.
DEFINE OUTPUT PARAMETER c-erro       AS CHAR NO-UNDO.

DEFINE VAR i-cont AS INTEGER NO-UNDO.

//EX c-qr-code = SN:ABCDE12345678,MAC1:ZWXABCD12345

IF c-it-codigo = "" 
THEN DO:
    ASSIGN c-erro = "Informe um Item".
    RETURN "NOK":U.
END.

IF c-qr-code = "" 
THEN DO:
    ASSIGN c-erro = "Informe o QrCode".
    RETURN "NOK":U.
END.

//Padr∆o na devoluá∆o de Numero de Serie e MAC
ASSIGN c-n-serie = SUBSTRING(c-qr-code,5,13)
       c-mac[1]  = SUBSTRING(c-qr-code,24,12)
       c-mac[2]  = SUBSTRING(c-qr-code,42,12).

IF SUBSTRING(c-qr-code,24,3) = 'MAC' THEN
   ASSIGN c-n-serie = SUBSTRING(c-qr-code,5,18)
          c-mac[1]  = SUBSTRING(c-qr-code,29,12)
          c-mac[2]  = SUBSTRING(c-qr-code,47,12). 


IF SUBSTRING(c-qr-code,26,3) = 'MAC' THEN
   ASSIGN c-n-serie = SUBSTRING(c-qr-code,5,20)
          c-mac[1]  = SUBSTRING(c-qr-code,31,12)
          c-mac[2]  = SUBSTRING(c-qr-code,49,12).


//Especifico por item
FIND FIRST item-qr-code WHERE
           item-qr-code.it-codigo = c-it-codigo
           NO-LOCK NO-ERROR.

IF AVAIL item-qr-code 
THEN DO:

    IF item-qr-code.l-n-serie = YES 
    THEN DO:
        ASSIGN c-n-serie = SUBSTRING(c-qr-code,INT(item-qr-code.ini-n-serie),INT(item-qr-code.fim-n-serie)).
    END.
    ELSE ASSIGN c-n-serie = "".

    DO i-cont = 1 TO 10:

        IF item-qr-code.l-mac[i-cont] = YES 
        THEN DO:
            ASSIGN c-mac[i-cont]  = SUBSTRING(c-qr-code,INT(item-qr-code.ini-mac[i-cont]),INT(item-qr-code.fim-mac[i-cont])).
        END.
        ELSE ASSIGN c-mac[i-cont]  = "".
    END.
END.

RETURN "OK":U.
