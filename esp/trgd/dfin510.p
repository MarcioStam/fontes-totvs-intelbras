/* -------------------------------------------------------------------------------------------------------------
Programa : trgd/dfin510.p
Funcao   : Trigger criada para eliminar o registro da tabela de extens∆o int_espec_docto_financ_acr.
           Esse registro Ç criado no cadastro de EspÇcies Financeiras ACR.
Autor    : Robson Jeorge Moser
Data     : 12/2004
Alteraá∆o:
Vers∆o   : 001
-------------------------------------------------------------------------------------------------------------- */

DEFINE PARAMETER BUFFER b_espec_docto_financ_acr FOR espec_docto_financ_acr.
                                  
find int_espec_docto_financ_acr EXCLUSIVE-LOCK
    where int_espec_docto_financ_acr.cod_espec_docto = b_espec_docto_financ_acr.cod_espec_docto NO-ERROR.
if available int_espec_docto_financ_acr then do:
   DELETE int_espec_docto_financ_acr.
end.
