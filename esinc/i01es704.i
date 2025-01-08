/******************************************************************
**
**      i01es370.i  - campo: int-item.ind-tipo-venda 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pendente
&glob val2 Confirmado
&glob val3 Emitido
&glob val4 Atualizado
&glob val5 Finalizado
&glob val6 Cancelado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Pendente
&glob val2 Confirmado
&glob val3 Emitido
&glob val4 Atualizado
&glob val5 Finalizado
&glob val6 Cancelado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Pendente
&glob val2 Confirmado
&glob val3 Emitido
&glob val4 Atualizado
&glob val5 Finalizado
&glob val6 Cancelado
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

