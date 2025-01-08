/***********************************************************************
**  Programa..: UPC/PD4000-UPCB.P
**  Autor.....: Robson Jeorge Moser - Gestech
**  Data......: DEZEMBRO/2004 - Desenvolvimento
**  Descricao.: Chama o "choose" padr∆o do bot∆o de inclus∆o do representante 
                e desabilita o campo "Serv.Instalaá∆o" da tela do pd4000.
**  Vers∆o....: 001 26/12/2004
**              Desenvolvimento Programa
************************************************************************/

DEF NEW GLOBAL SHARED VAR whbtAddRepresentative     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbtAddRepresentative-new AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbtAddServInst-new AS WIDGET-HANDLE NO-UNDO.

APPLY "choose" TO whbtAddRepresentative.
ASSIGN whbtAddServInst-new:SENSITIVE = NO.




