/********************************************************************************
 ** UPC........: dfin023.p - UPC DELETE bem_pat
 ** Data.......: 12/08/2022
 ** Objetivo...: 
 ********************************************************************************/

def param buffer bff_bem_pat for bem_pat.

for each int_bem_pat use-index ch-id exclusive-lock
   where int_bem_pat.num_id_bem_pat = bff_bem_pat.num_id_bem_pat:
    delete int_bem_pat.
end.

for each int_bem_pat_gm exclusive-lock
   where int_bem_pat_gm.num_id_bem_pat = bff_bem_pat.num_id_bem_pat:
    delete int_bem_pat_gm.
end.
