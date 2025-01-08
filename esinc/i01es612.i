/******************************************************************
**
**      i01es612.i  - campo: modelo-etiq.homologador 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Anatel
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Anatel
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Anatel
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

