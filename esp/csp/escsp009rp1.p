DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod_unid_negoc AS CHARACTER
    FIELD cdn_unid_negoc AS INTEGER
    FIELD descricao      AS CHARACTER FORMAT "x(30)".

DEFINE OUTPUT PARAMETER TABLE FOR tt-unid-negoc.

FOR EACH tt-unid-negoc:
    DELETE tt-unid-negoc.
END.

FOR EACH unid_negoc:
    CREATE tt-unid-negoc.
    ASSIGN tt-unid-negoc.cod_unid_negoc = unid_negoc.cod_unid_negoc
           tt-unid-negoc.cdn_unid_negoc = unid_negoc.cdn_unid_negoc
           tt-unid-negoc.descricao      = unid_negoc.des_unid_negoc.
END.
