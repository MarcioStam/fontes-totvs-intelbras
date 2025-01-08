PROCEDURE pi-cidade-prestacao-servico:
    DEF INPUT  PARAM p-nome-abrev AS CHAR    NO-UNDO.
    DEF INPUT  PARAM p-nr-pedcli  AS CHAR    NO-UNDO.
    DEF INPUT  PARAM p-nr-seq-ped AS INTEGER NO-UNDO.
    DEF INPUT  PARAM p-it-codigo  AS CHAR    NO-UNDO.
    DEF INPUT  PARAM p-cod-refer  AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM p-cidade-ser AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM p-uf-ser     AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM p-pais-ser   AS CHAR    NO-UNDO.
    
    FOR FIRST int-ped-item-adic NO-LOCK
        WHERE int-ped-item-adic.nome-abrev   = p-nome-abrev
          AND int-ped-item-adic.nr-pedcli    = p-nr-pedcli
          AND int-ped-item-adic.nr-sequencia = p-nr-seq-ped
          AND int-ped-item-adic.it-codigo    = p-it-codigo
          AND int-ped-item-adic.cod-refer    = p-cod-refer:
          
          ASSIGN p-cidade-ser = int-ped-item-adic.cidade-servico
                 p-uf-ser     = int-ped-item-adic.uf-servico
                 p-pais-ser   = int-ped-item-adic.pais-servico.
    END.

    RETURN "OK".

END.
