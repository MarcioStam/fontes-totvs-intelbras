FUNCTION fn-retira-espec RETURNS CHAR ( INPUT p-palavra AS CHAR ):
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-palavra AS CHARACTER   NO-UNDO.

    ASSIGN c-palavra = p-palavra
           c-palavra =  replace(c-palavra, '∑', 'A')
           c-palavra =  replace(c-palavra, 'µ', 'A')
           c-palavra =  replace(c-palavra, '∂', 'A')
           c-palavra =  replace(c-palavra, '«', 'A')
           c-palavra =  replace(c-palavra, 'é', 'A')
           c-palavra =  replace(c-palavra, '‘', 'E')
           c-palavra =  replace(c-palavra, 'ê', 'E')
           c-palavra =  replace(c-palavra, '“', 'E')
           c-palavra =  replace(c-palavra, '”', 'E')
           c-palavra =  replace(c-palavra, 'ﬁ', 'I')
           c-palavra =  replace(c-palavra, '÷', 'I')
           c-palavra =  replace(c-palavra, '◊', 'I')
           c-palavra =  replace(c-palavra, 'ÿ', 'I')
           c-palavra =  replace(c-palavra, '„', 'O')
           c-palavra =  replace(c-palavra, '‡', 'O')
           c-palavra =  replace(c-palavra, '‚', 'O')
           c-palavra =  replace(c-palavra, 'Â', 'O')
           c-palavra =  replace(c-palavra, 'ô', 'O')
           c-palavra =  replace(c-palavra, 'Î', 'U')
           c-palavra =  replace(c-palavra, 'È', 'U')
           c-palavra =  replace(c-palavra, 'Í', 'U')
           c-palavra =  replace(c-palavra, 'ö', 'U')
           c-palavra =  replace(c-palavra, 'Ì', 'Y')
           c-palavra =  replace(c-palavra, 'ü', 'Y')
           c-palavra =  replace(c-palavra, 'Ä', 'C')
           c-palavra =  replace(c-palavra, '•', 'N')
           c-palavra =  replace(c-palavra, 'Ö', 'a')
           c-palavra =  replace(c-palavra, '†', 'a')
           c-palavra =  replace(c-palavra, 'É', 'a')
           c-palavra =  replace(c-palavra, '∆', 'a')
           c-palavra =  replace(c-palavra, 'Ñ', 'a')
           c-palavra =  replace(c-palavra, 'ä', 'e')
           c-palavra =  replace(c-palavra, 'Ç', 'e')
           c-palavra =  replace(c-palavra, 'à', 'e')
           c-palavra =  replace(c-palavra, 'â', 'e')
           c-palavra =  replace(c-palavra, 'ç', 'i')
           c-palavra =  replace(c-palavra, '°', 'i')
           c-palavra =  replace(c-palavra, 'å', 'i')
           c-palavra =  replace(c-palavra, 'ã', 'i')
           c-palavra =  replace(c-palavra, 'ï', 'o')
           c-palavra =  replace(c-palavra, '¢', 'o')
           c-palavra =  replace(c-palavra, 'ì', 'o')
           c-palavra =  replace(c-palavra, '‰', 'o')
           c-palavra =  replace(c-palavra, 'î', 'o')
           c-palavra =  replace(c-palavra, 'ó', 'u')
           c-palavra =  replace(c-palavra, '£', 'u')
           c-palavra =  replace(c-palavra, 'ñ', 'u')
           c-palavra =  replace(c-palavra, 'Å', 'u')
           c-palavra =  replace(c-palavra, 'Ï', 'y')
           c-palavra =  replace(c-palavra, 'ò', 'y')
           c-palavra =  replace(c-palavra, 'á', 'c')
           c-palavra =  replace(c-palavra, '§', 'n')
           c-palavra =  replace(c-palavra, '¶', 'a')
           c-palavra =  replace(c-palavra, 'ß', 'o')
           c-palavra =  replace(c-palavra, '&', 'E').
    
    DO i-cont = 1 TO LENGTH(c-palavra):
        IF ASC(SUBSTRING(c-palavra, i-cont, 1)) < 32  OR
           ASC(SUBSTRING(c-palavra, i-cont, 1)) > 125 THEN
            ASSIGN OVERLAY(c-palavra, i-cont, 1) = "":U.
    END.

    RETURN c-palavra.

END FUNCTION.
