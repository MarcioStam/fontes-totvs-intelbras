/***********************************************************************
**  Programa..: UPC\PD4000-UPC1.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Manuten‡Æo Parƒmetros Pedido
**  VersÆo....: 001 16/11/2004
**                  Desenvolvimento Programa
************************************************************************/

DEF NEW GLOBAL SHARED VAR whTgLimpaDesc     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtLocalOk      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtOkOrder      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR vLogLimpaDesc     AS LOGICAL       NO-UNDO.

DEF NEW GLOBAL SHARED VAR whBtOK            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtLocalOK       AS WIDGET-HANDLE NO-UNDO.

ASSIGN vLogLimpaDesc = whTgLimpaDesc:CHECKED.
APPLY "CHOOSE" TO whBtOk.
