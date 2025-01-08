/*******************************************************************************/ 
/* Objetivo: API de Consome MAC FiberHome                                      */
/* Data: 25/07/2024                                                            */
/*******************************************************************************/

FUNCTION fator RETURNS DECIMAL
  ( INPUT p-fator AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-valor AS DECIMAL     NO-UNDO.

    ASSIGN i-valor = 1.

    IF p-fator > 0 THEN DO:
        DO i-cont = 1 TO p-fator:
            ASSIGN i-valor = i-valor * 16.
        END.
    END.

    RETURN i-valor. /* Function return value. */

END FUNCTION.


FUNCTION conv-hex-to-dec RETURNS DECIMAL
  ( INPUT p-val-hexadecimal AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-valor       AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-num-decimal AS DECIMAL     NO-UNDO.

    DO i-cont = 1 TO LENGTH(p-val-hexadecimal):
        CASE SUBSTRING(p-val-hexadecimal, i-cont, 1):
            WHEN "A":U THEN
                ASSIGN i-valor = 10.
            WHEN "B":U THEN
                ASSIGN i-valor = 11.
            WHEN "C":U THEN
                ASSIGN i-valor = 12.
            WHEN "D":U THEN
                ASSIGN i-valor = 13.
            WHEN "E":U THEN
                ASSIGN i-valor = 14.
            WHEN "F":U THEN
                ASSIGN i-valor = 15.
            OTHERWISE DO:
                ASSIGN i-valor = INTEGER(SUBSTRING(p-val-hexadecimal, i-cont, 1)) NO-ERROR.

                IF ERROR-STATUS:ERROR THEN
                    RETURN 0. /* Function return value. */
            END.
        END CASE.

        ASSIGN i-num-decimal = i-num-decimal + (i-valor * fator(LENGTH(p-val-hexadecimal) - i-cont)).

    END.

    RETURN i-num-decimal. /* Function return value. */

END FUNCTION.


FUNCTION conv-dec-to-hex RETURNS CHARACTER
  ( INPUT p-num-decimal AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Converte decimal para hexadecimal
    Notes:  Carlos Daniel - 22/09/2015
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-simbolos AS CHARACTER NO-UNDO FORMAT "X(1)" EXTENT 16
    INITIAL ["0":U, "1":U, "2":U, "3":U, "4":U, "5":U, "6":U, "7":U, "8":U, "9":U, "A":U, "B":U, "C":U, "D":U, "E":U, "F":U].

DEFINE VARIABLE c-val-hexadecimal AS CHARACTER NO-UNDO INITIAL "":U.
DEFINE VARIABLE i-quociente       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE i-resto           AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE c-aux             AS CHARACTER NO-UNDO.

ASSIGN i-quociente = p-num-decimal.

REPEAT:
    ASSIGN i-resto           = i-quociente MODULO 16
           i-quociente       = TRUNCATE((i-quociente / 16), 0)
           c-val-hexadecimal = c-simbolos[(i-resto + 1)] + c-val-hexadecimal.

    IF i-quociente <= 0 THEN
        LEAVE.
END.

IF LENGTH(c-val-hexadecimal) < 6 THEN
    ASSIGN c-aux             = FILL("0",6 - LENGTH(c-val-hexadecimal))
           c-val-hexadecimal = c-aux + c-val-hexadecimal.

RETURN c-val-hexadecimal. /* Function return value. */

END FUNCTION.

/*********************** Inicio **************************/

DEF TEMP-TABLE tt-mac-address-fiber LIKE mac-address-fiber.

DEF INPUT PARAM p-num-mac AS INT  NO-UNDO.
DEF INPUT PARAM c-item    AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mac-address-fiber.

DEFINE VARIABLE c-prox-mac AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-mac-ult  AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cont     AS INTEGER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

DEFINE VARIABLE h-acomp   AS HANDLE NO-UNDO.

RUN utp\ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Processando").

EMPTY TEMP-TABLE tt-mac-address-fiber.

DO i-cont = 1 TO p-num-mac:
    FIND FIRST mac-address-param-fiber EXCLUSIVE-LOCK NO-ERROR.

    IF NOT(mac-address-param-fiber.faixa-fim = mac-address-param-fiber.mac-ult) THEN DO:

        IF mac-address-param-fiber.mac-ult = '' THEN 
           ASSIGN c-mac-ult = mac-address-param-fiber.faixa-ini.
        ELSE
           ASSIGN c-mac-ult = mac-address-param-fiber.mac-ult.

        ASSIGN c-prox-mac = mac-address-param-fiber.faixa + conv-dec-to-hex(conv-hex-to-dec(c-mac-ult) + 1).

        ASSIGN mac-address-param-fiber.mac-ult = SUBSTRING(c-prox-mac,7,6).
        
        RUN pi-acompanhar IN h-acomp (INPUT STRING(i-cont) + " - " + c-prox-mac).

        CREATE mac-address-fiber.
        ASSIGN mac-address-fiber.mac         = c-prox-mac
               mac-address-fiber.it-codigo   = c-item 
               mac-address-fiber.usuario     = c-seg-usuario
               mac-address-fiber.data        = NOW.

        CREATE tt-mac-address-fiber.
        BUFFER-COPY mac-address-fiber TO tt-mac-address-fiber.
    END.

    RELEASE mac-address-param-fiber.
END.

RUN pi-finalizar IN h-acomp.






    
