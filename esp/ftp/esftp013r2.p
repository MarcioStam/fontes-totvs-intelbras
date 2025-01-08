/******************************************************************************
*******************************************************************************
*  VERSAO       DATA        RESPONSAVEL     MOTIVO                            *
*  1.00.00.001  24/02/2000  Daniela         Desenvolvimento                   *
******************************************************************************/
{esp\ftp\esftp013rtt.i "shared"}


if ti-banco = 237 then do:
/*********   Carrega variaveis   *********/   
   assign tc-nrbarr     = string (ti-banco,"999")                     +   
                          string (ti-moeda,"9")                       +
  /* 03/07/00 MENOS 1000DIAS - BASE DE INST. DO SISTEMA PELO BCO CENTRAL */
                          string (td-vencimento - 10/07/1997,"9999")  +
                          string((td-valor * 100),"9999999999")       +
                          string (ti-ag-cedente,"9999")               +
                          string (ti-carteira,"99")                   +
                          string (ti-nnumero,"99999999999")           +
                          string (ti-ccorrente,"9999999")             +
                          string (ti-zeros,"9")
                                                                        
          tc-cpo-1      = string (ti-banco,"999")                     + 
                          string (ti-moeda,"9")                       +
                          string (ti-ag-cedente,"9999")               +
                          substr(string(ti-carteira,"99"),1,1)
                          
          tc-cpo-2      = substr(string(ti-carteira,"99"),2,1) +
                          string(ti-nnumero,"99999999999")
                          
          tc-cpo-3      = substr(string(ti-nnumero,"99999999999"),10,2)  +
                          string (ti-ccorrente,"9999999")             +
                          string (ti-zeros,"9") 
                          
          tc-cpo-4      = string (ti-dac-barra,"9") 
          tc-cpo-5      = string(td-vencimento - 10/07/1997,"9999") +
                          TRIM(string (td-valor * 100,">>>>>>>999")).
end.

/*********-  Calcula o digito verificador do codigo de barra  ************-*/
assign td-soma         = 0
       ti-multiplicador = 2.
       
do ti-ixtab = 43 to 1 by -1.
   if ti-multiplicador > 9 then
      assign ti-multiplicador = 2.
      
   assign td-soma         = td-soma +
                           (integer (substr (tc-nrbarr,ti-ixtab,1)) * ti-multiplicador)
          ti-multiplicador = ti-multiplicador + 1.
end.


assign ti-dac-barra = 11 - td-soma modulo 11.
if ti-dac-barra = 0 or ti-dac-barra > 9 
then ti-dac-barra = 1.       

assign tc-nrbarr = substr (tc-nrbarr,1,4) +  string (ti-dac-barra) +
                  substr (tc-nrbarr,5,39)
       td-soma  = 0.
       
       
/***   Calculo do digito verificador do primeiro campo da linha digitavel ***/
do ti-ixtab = 9 to 1 by -1.
   if ti-ixtab mod 2 eq 0 then
        assign ti-valor-mod-10 = integer (substr (tc-cpo-1,ti-ixtab,1)).
   else assign ti-valor-mod-10 = integer (substr (tc-cpo-1,ti-ixtab,1)) * 2.
   assign td-soma = td-soma +
                    integer (substr (string (ti-valor-mod-10,"99"),1,1)) +
                    integer (substr (string (ti-valor-mod-10,"99"),2,1)).
end.

assign ti-dac-cpo-1  = if (10 - td-soma mod 10) = 10
                         then 0
                         else 10 - (td-soma mod 10)
       td-soma      = 0.
       
/***   Calculo do digito verificador do segundo campo da linha digitavel ***/
do ti-ixtab = 10 to 1 by -1.
   if ti-ixtab mod 2 eq 0 then
        assign ti-valor-mod-10 = integer (substr (tc-cpo-2,ti-ixtab,1)) * 2.
   else assign ti-valor-mod-10 = integer (substr (tc-cpo-2,ti-ixtab,1)).
   assign td-soma = td-soma +
                    integer (substr (string (ti-valor-mod-10,"99"),1,1)) +
                    integer (substr (string (ti-valor-mod-10,"99"),2,1)).
end.
assign ti-dac-cpo-2  = if (10 - td-soma mod 10) = 10
                         then 0
                         else 10 - (td-soma mod 10)
       td-soma      = 0.
/***   Calculo do digito verificador do terceiro campo da linha digitavel ****/
do ti-ixtab = 10 to 1 by -1.
   if ti-ixtab mod 2 eq 0 then
        assign ti-valor-mod-10 = integer (substr (tc-cpo-3,ti-ixtab,1)) * 2.
   else assign ti-valor-mod-10 = integer (substr (tc-cpo-3,ti-ixtab,1)).
   assign td-soma = td-soma +
                    integer (substr (string (ti-valor-mod-10,"99"),1,1)) +
                    integer (substr (string (ti-valor-mod-10,"99"),2,1)).
end.  

assign ti-dac-cpo-3 = if (10 - td-soma mod 10) = 10
                        then 0
                        else 10 - (td-soma mod 10)
                        
       tc-linha-dig = substr (tc-cpo-1,1,5) + "." +
                     substr (tc-cpo-1,6,4) + string (ti-dac-cpo-1,"9") + "  " +
                     substr (tc-cpo-2,1,5) + "." +
                     substr (tc-cpo-2,6,5) + string (ti-dac-cpo-2,"9") + "  " +
                     substr (tc-cpo-3,1,5) + "." +
                     substr (tc-cpo-3,6,5) + string (ti-dac-cpo-3,"9") + "  " +
                     string (ti-dac-barra,"9")                        + "  " +
                     substr (tc-cpo-5,1,4) + 
                     string (td-valor * 100,"9999999999").
/*   fim    */



