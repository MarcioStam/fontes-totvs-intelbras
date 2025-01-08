
/*----------------------------------------------------------------------------------------------------------------------*/         
/*  Inclusde esp/esb/esesb003.i1 - Totaliza o faturamento/sellout apurado em determinado per¡odo de tempo para          */
/*                                 um benef¡cio                                                                         */
/*                                                                                                                      */
/*  Roger Marcelino Bruhn -01/07/2014                                                                                   */
/*----------------------------------------------------------------------------------------------------------------------*/         
DEF BUFFER b-int-fat-mensal FOR int-fat-mensal.

PROCEDURE pi-retorna-base-faturamento-periodo:
    DEF INPUT  PARAM p-canal          AS INT     NO-UNDO.
    DEF INPUT  PARAM p-unidade        AS CHAR    NO-UNDO.
    DEF INPUT  PARAM p-periodo-ini    AS DATE    NO-UNDO.
    DEF INPUT  PARAM p-periodo-fim    AS DATE    NO-UNDO.
    DEF OUTPUT PARAM p-vl-base-apur   AS DEC     NO-UNDO.
    DEF OUTPUT PARAM p-vl-base-fat    AS DEC     NO-UNDO.
    DEF OUTPUT PARAM p-vl-base-dev    AS DEC     NO-UNDO.
    
    IF  YEAR(p-periodo-ini) <> YEAR(p-periodo-fim) THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Faixa de data para busca da base de c lculo do benef¡cio ‚ inv lido.",
                                            INPUT "Deve ser informada um per¡odo dentro do mesmo ano.").
        RETURN "NOK".
    END.

    FOR EACH b-int-fat-mensal  NO-LOCK
        WHERE b-int-fat-mensal.ano      = YEAR(p-periodo-fim)
          AND b-int-fat-mensal.mes     >= MONTH(p-periodo-ini)
          AND b-int-fat-mensal.mes     <= MONTH(p-periodo-fim)
          and b-int-fat-mensal.canal    = p-canal
          and b-int-fat-mensal.unid-neg = p-unidade:
          
          assign p-vl-base-apur = p-vl-base-apur + b-int-fat-mensal.vl-apurado
                 p-vl-base-fat  = p-vl-base-fat  + b-int-fat-mensal.vl-faturado
                 p-vl-base-fat  = p-vl-base-fat  + b-int-fat-mensal.vl-devolvido.
                
          
    END.
    
    RETURN "OK".

END.
