/********************************************************************************
 ** UPC........: win176.p - UPC WRITE item-doc-est
 ** Data.......: Junho ; 2021
 ** Objetivo...: 
 ********************************************************************************/

DEF PARAM BUFFER b-item-doc-est      FOR item-doc-est.
DEF PARAM BUFFER b-old-item-doc-est  FOR item-doc-est.

IF LENGTH(b-item-doc-est.narrativa) > 120 THEN
   ASSIGN b-item-doc-est.narrativa = SUBSTR(b-item-doc-est.narrativa,1,120).


RETURN "ok".
