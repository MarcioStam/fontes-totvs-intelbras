/***********************************************************************
**  Programa..: ESP/REP/ESREP020TT.I
**  Autor.....: Anderson Cenci
**  Data......: FEVEREIRO/2008 - Desenvolvimento
**  Descricao.: Notas de Entrada - Despesas Acessorias
**  Vers∆o....: 000 - 27/02/2008 - Desenvolvimento Programa
**              001 - 14/05/2012 - Inclus∆o do detalhe de outras
**              despesas - Fabiano Sakae Ribeiro (Exponencial TI/SQL Works)
************************************************************************/

/****************************  Definitions  ****************************/

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino         AS INTEGER
    FIELD arquivo         AS CHARACTER format "x(35)":U
    FIELD usuario         AS CHARACTER format "x(12)":U
    FIELD data-exec       AS DATE
    FIELD hora-exec       AS INTEGER
    FIELD ini-data        AS DATE
    FIELD fim-data        AS DATE
    FIELD ini-cod-estabel AS CHARACTER
    FIELD fim-cod-estabel AS CHARACTER
    FIELD ind-tip-relat   AS INTEGER.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

