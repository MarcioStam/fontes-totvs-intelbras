/* -------------------------------------------------------------------------------------------------------------
Programa : trgd/dfin160.p
-------------------------------------------------------------------------------------------------------------- */

DEFINE PARAMETER BUFFER b_item_lancto_ctbl FOR item_lancto_ctbl.
                                  
FIND int_item_lancto_ctbl EXCLUSIVE-LOCK OF b_item_lancto_ctbl NO-ERROR.

IF AVAIL int_item_lancto_ctbl 
   THEN DELETE int_item_lancto_ctbl.
