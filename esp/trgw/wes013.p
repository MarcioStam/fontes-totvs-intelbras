TRIGGER PROCEDURE FOR WRITE OF atendente.

/********************************************************************************
 ** UPC........: wes013.p - UPC WRITE Atendente
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes das atendentes para a Base Oracle
 ********************************************************************************/
/*
DEF PARAM BUFFER b-atendente      FOR atendente.
DEF PARAM BUFFER b-old-atendente  FOR atendente.
*/

run esp/es0669.p (input "yes", 
                  "atendente", 
                  string(atendente.cd-oper),
                  "", "", "", "", "", "", "", "").
