DEFINE INPUT PARAM raw-param   AS RAW  NO-UNDO.
DEFINE INPUT PARAM c-msg       AS CHAR NO-UNDO.

{esp/esb/esesb006.i c-msg 'wdi154' 'it-nota-fisc'}
DEFINE OUTPUT PARAM TABLE FOR resultado.

FIND FIRST resultado NO-ERROR.

IF  NOT AVAIL resultado THEN
    RETURN "NOK".
ELSE DO:
    IF  AVAIL resultado 
    AND NOT resultado.sucesso THEN
        RETURN "NOK".
    ELSE 
        RETURN "OK".
END.
    
