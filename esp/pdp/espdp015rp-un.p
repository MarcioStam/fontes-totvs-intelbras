DEFINE INPUT PARAMETER p-unid-negoc LIKE unid_negoc.cod_unid_negoc.

FIND FIRST unid_negoc
    WHERE unid_negoc.cod_unid_negoc = p-unid-negoc NO-LOCK NO-ERROR.

IF AVAILABLE unid_negoc THEN
    RETURN unid_negoc.des_unid_negoc.
ELSE
    RETURN "":U.
