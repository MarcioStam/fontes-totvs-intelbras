def temp-table tt-int-ped-compr no-undo like int-ped-compr
    FIELD row-table      AS ROWID
    FIELD nome-abrev     LIKE emitente.nome-abrev
    FIELD dat-movto      LIKE int-mov-ped-compr.dat-movto
    FIELD hra-movto      LIKE int-mov-ped-compr.hra-movto
    FIELD log-select     AS LOG
    FIELD des-status     AS CHAR
    FIELD des-situacao   AS CHAR
    FIELD des-i-situacao AS CHAR.
