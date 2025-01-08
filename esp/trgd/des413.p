/********************************************************************************/
/** UPC........: des413.p - UPC DELETE fatura-equipamento                       */
/********************************************************************************/
trigger procedure for DELETE of fatura-equipamentos.                                

FOR EACH cc-rateio-fatura EXCLUSIVE-LOCK
    WHERE cc-rateio-fatura.cod-estabel        = fatura-equipamento.cod-estabel 
      and cc-rateio-fatura.equipamento        = fatura-equipamento.equipamento 
      and cc-rateio-fatura.cod-fornecedor     = fatura-equipamento.fornecedor  
      and cc-rateio-fatura.mes-ref            = fatura-equipamento.mes-ref     
      and cc-rateio-fatura.nr-fatura          = fatura-equipamento.nr-fatura  :
      
    DELETE cc-rateio-fatura.
END.

