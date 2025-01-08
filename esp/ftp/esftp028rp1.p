define input  parameter p_cdn_unid_negoc as integer     no-undo.
define output parameter p_des_unid_negoc as character   no-undo.

find first unid_negoc
    where unid_negoc.cdn_unid_negoc = p_cdn_unid_negoc no-lock no-error.

if available unid_negoc then
    assign p_des_unid_negoc = unid_negoc.des_unid_negoc.
else
    assign p_des_unid_negoc = "":U.

return "OK":U.

