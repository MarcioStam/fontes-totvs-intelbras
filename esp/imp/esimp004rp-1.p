def input param pc-cod-estabel  like embarque-imp.cod-estabel no-undo.
def input param pi-cod-emitente like emitente.cod-emitente no-undo.
def input param pi-nr-pagamento like pagamento-invoice.nr-pagamento no-undo.
def output param po-cod-tit-ap like tit_ap.cod_tit_ap no-undo.
def output param po-val-orig like tit_ap.val_origin_tit_ap no-undo.
def output param po-val-sdo-tit-ap like tit_ap.val_sdo_tit_ap no-undo.

find tit_ap NO-LOCK 
   WHERE tit_ap.cod_estab  = pc-cod-estabel
   AND tit_ap.cdn_fornecedor = pi-cod-emitente 
   AND tit_ap.cod_espec_docto = "ai"      
   AND tit_ap.cod_tit_ap = string(pi-nr-pagamento) no-error.   
if avail tit_ap then
    assign po-cod-tit-ap     = tit_ap.cod_tit_ap
           po-val-orig       = tit_ap.val_orig    
           po-val-sdo-tit-ap = tit_ap.val_sdo_tit_ap.
   



