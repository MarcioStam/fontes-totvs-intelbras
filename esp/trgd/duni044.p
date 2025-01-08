/********************************************************************************
 ** UPC........: duni044.p - UPC DELETE cta_ctbl
 ** Data.......: 30/11/2022
 ** Objetivo...: 
 ********************************************************************************/

def param buffer bff_cta_ctbl for cta_ctbl.

for each int_cta_ctbl exclusive-lock
   where int_cta_ctbl.cod_plano_cta_ctbl = bff_cta_ctbl.cod_plano_cta_ctbl
     and int_cta_ctbl.cod_cta_ctbl       = bff_cta_ctbl.cod_cta_ctbl:
    delete int_cta_ctbl.
end.
