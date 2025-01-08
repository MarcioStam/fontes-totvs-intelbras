/********************************************************************************
 ** UPC........: wuni183.p - UPC WRITE pessoa_jurid
 ** Data.......: maio / 2014
 ** Objetivo...: Gravar o Codigo do Condado para Valida‡Æo do Representante
 ********************************************************************************/
DEF PARAM BUFFER b_pessoa_jurid      FOR pessoa_jurid.
DEF PARAM BUFFER b_old_pessoa_jurid  FOR pessoa_jurid.

IF b_pessoa_jurid.nom_condado = "" THEN DO:
    ASSIGN b_pessoa_jurid.nom_condado = "1".
END.
