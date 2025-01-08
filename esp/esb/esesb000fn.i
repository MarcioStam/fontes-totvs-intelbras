
FUNCTION fnConverteChar RETURNS CHAR (INPUT p-string AS CHAR) :

    DEFINE VARIABLE c-permitidos AS CHARACTER   INIT "abcdefghijklmnopqrstuvxzywá1234567890!@#$%˘&*()'{}[]Ô`^~/?|\;:.,-_=+†Ç°¢£Öäçïó∆‰Éìàå " NO-UNDO.
    DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.


    DO i-aux = 1 TO LENGTH(p-string):
        
        IF INDEX(c-permitidos, SUBSTRING(p-string, i-aux, 1)) = 0 THEN DO:

            OVERLAY(p-string, i-aux, 1) = " ".

        END.

    END.

    RETURN p-string.

END FUNCTION.



