/*--------------------------------------------------------------------------
  Purpose: Definicao de temp-tables e variaveis para utilizacao da api
  CPAPI005.P
  Parameters:  
  Notes: 05/06/97 - By Murilo C‚sar      
---------------------------------------------------------------------------*/

def temp-table tt-movto-ggf like movto-ggf
   field cod-versao-integracao as integer format "999"
   field rw-movto-ggf          as rowid
   field cria-ext-ord          as logical
   field lg-recalc-horas       as logical
   field rw-mov-orig           as rowid.  /* registro original para  
                                             valorizar o estorno,
                                             devolu‡Æo,retorno */

