/********************************************************************************
 ** UPC........: wuni182.p - UPC WRITE pessoa_fisic
 ** Data.......: maio / 2014
 ** Objetivo...: Gravar o Codigo do Condado para Valida‡Æo do Representante
 ********************************************************************************/
DEF PARAM BUFFER b_pessoa_fisic      FOR pessoa_fisic.
DEF PARAM BUFFER b_old_pessoa_fisic  FOR pessoa_fisic.

IF b_pessoa_fisic.nom_condado = "" THEN DO:
    ASSIGN b_pessoa_fisic.nom_condado = "1".
END.
