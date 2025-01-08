/*****
Defini‡Æo tabela tt-comunica utilizada para gravar informa‡äes do retorno da SEFAZ (integr-totvs-colad.raw-contdo)
*****/



DEF TEMP-TABLE tt-comunica NO-UNDO
    FIELD ID       AS CHAR 
    FIELD tpAmb    AS CHAR  
    FIELD cStat    AS CHAR
    FIELD xMotivo  AS CHAR
    FIELD cUF      AS CHAR
    FIELD dhRecbto AS CHAR
    FIELD nProt    AS CHAR
    FIELD tpEvento AS CHAR.
