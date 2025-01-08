TRIGGER PROCEDURE FOR WRITE OF fatura-equipamentos.

/********************************************************************************
** UPC........: wes413.p - UPC WRITE fatura-equipamentos
********************************************************************************/

IF  NOT CAN-FIND(FIRST cc-rateio-fatura
                    WHERE cc-rateio-fatura.cod-estabel    = fatura-equipamentos.cod-estabel 
                      AND cc-rateio-fatura.equipamento    = fatura-equipamentos.equipamento 
                      AND cc-rateio-fatura.cod-fornecedor = fatura-equipamentos.fornecedor 
                      AND cc-rateio-fatura.mes-ref        = fatura-equipamentos.mes-ref 
                      AND cc-rateio-fatura.nr-fatura      = fatura-equipamentos.nr-fatura) THEN DO:

    FOR EACH cc-equipamentos NO-LOCK
        WHERE cc-equipamentos.cod-estabel = fatura-equipamento.cod-estabel
          AND cc-equipamentos.equipamento = fatura-equipamento.equipamento
        ,FIRST equipamentos NO-LOCK
            WHERE equipamentos.equipamento = fatura-equipamento.equipamento:
          CREATE cc-rateio-fatura.
          ASSIGN cc-rateio-fatura.cod-estabel        = fatura-equipamento.cod-estabel
                 cc-rateio-fatura.equipamento        = fatura-equipamento.equipamento
                 cc-rateio-fatura.cod-fornecedor     = fatura-equipamento.fornecedor
                 cc-rateio-fatura.mes-ref            = fatura-equipamento.mes-ref
                 cc-rateio-fatura.nr-fatura          = fatura-equipamento.nr-fatura
                 cc-rateio-fatura.ct-codigo          = equipamentos.ct-codigo
                 cc-rateio-fatura.cc-codigo          = cc-equipamentos.cc-codigo
                 cc-rateio-fatura.cod-unid-negoc     = cc-equipamentos.cod-unid-negoc
                 cc-rateio-fatura.cod-estabel-rateio = cc-equipamentos.cod-estabel-rateio
                 cc-rateio-fatura.perc-rateio        = cc-equipamentos.per-rateio.   
    END.
END.

RETURN "OK".

