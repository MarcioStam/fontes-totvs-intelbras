DEFINE INPUT PARAMETER p-cod_unid_negoc LIKE unid_negoc.cod_unid_negoc NO-UNDO.

FIND FIRST unid_negoc
    WHERE unid_negoc.cod_unid_negoc = p-cod_unid_negoc NO-LOCK NO-ERROR.

IF AVAILABLE unid_negoc THEN
    RETURN unid_negoc.des_unid_negoc.
ELSE
    RETURN "":U.

