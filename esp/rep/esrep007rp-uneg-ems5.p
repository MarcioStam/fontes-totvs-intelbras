DEFINE INPUT  PARAMETER p_cod_unid_negoc LIKE unid_negoc.cod_unid_negoc NO-UNDO.
DEFINE OUTPUT PARAMETER p_des_unid_negoc LIKE unid_negoc.des_unid_negoc NO-UNDO.

FIND FIRST unid_negoc
    WHERE unid_negoc.cod_unid_negoc = p_cod_unid_negoc NO-LOCK NO-ERROR.

IF AVAILABLE unid_negoc THEN
    ASSIGN p_des_unid_negoc = unid_negoc.des_unid_negoc.

RETURN "OK":U.

