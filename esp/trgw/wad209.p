/********************************************************************************
 ** UPC........: upcw-un007.p - UPC WRITE Unidade da Federaá∆o
 ** Data.......: Outubro / 2004
 ** Objetivo...: Repassa inclus‰es e modificaá‰es das unidades de federaá∆o para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-portador      FOR mgcad.portador.
DEF PARAM BUFFER b-old-portador  FOR mgcad.portador.

/*Inicio Integraá∆o Canais*/
DEF VAR raw-param   AS RAW  NO-UNDO.

/* n∆o integrar quando as informacoes abaixo forem alteradas,
   pois tratam a proxima numeracao dos boletos */
IF  b-portador.int-4  = b-old-portador.int-4 
AND b-portador.char-1 = b-old-portador.char-1 THEN DO:
    
    RAW-TRANSFER b-portador TO raw-param.
    
    {esp/esb/esesb006.i 'msg0024' 'wad209.p' 'portador'}
END.

/*Fim Integraá∆o Canais*/
