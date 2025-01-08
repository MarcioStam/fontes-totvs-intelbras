/******************************************************************
**
**      i01es370.i  - campo: int-item.ind-tipo-venda 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Nenhum
&glob val2 Venda
&glob val3 Revenda
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Nenhum
&glob val2 Venda
&glob val3 Revenda
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Nenhum
&glob val2 Venda
&glob val3 Revenda
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

