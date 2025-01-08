/***********************************************************************
**  Programa..: UPC\PD4000K-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Chamada Bot∆o OK no programa PD4000K
**  Vers∆o....: 001 16/11/2004
**                  Desenvolvimento Programa
************************************************************************/
DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtOK            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtLocalOK       AS WIDGET-HANDLE NO-UNDO.

IF  whBtLocalOK:SENSITIVE THEN DO:
    APPLY "CHOOSE" TO whBtOK.
END.
