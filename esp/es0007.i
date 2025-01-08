/*  es0007.i - 17/12/2002 - Flavio Schoenell

    include para uso da conta de transferencia */
    
def var pa-ct-codigo like conta-contab.ct-codigo.
def var pa-sc-codigo like conta-contab.sc-codigo.
                            
find first estab-mat no-lock
    where  estab-mat.cod-estabel = v_cod_estab_usuar no-error.

assign pa-ct-codigo = estab-mat.cod-cta-transf-unif
       pa-sc-codigo = estab-mat.cod-ccusto-transf-unif.
       


