/***********************************************************************
**  Programa..: upc\re1001b2-upca.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

DEF NEW GLOBAL SHARED VAR wh-class-fiscal       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-aliquota-ipi       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btCheck            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-desc-class-fiscal  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-natur-oper         AS ROWID         NO-UNDO.

DEF VAR c-class AS CHAR FORMAT "x(20)".
DEF VAR l-ipi   AS LOG.

ASSIGN c-class = REPLACE(wh-class-fiscal:SCREEN-VALUE,".","").

FIND FIRST classif-fisc NO-LOCK
    WHERE classif-fisc.class-fiscal = c-class NO-ERROR.
IF AVAIL classif-fisc THEN DO:
    ASSIGN l-ipi = NO.

    ASSIGN wh-desc-class-fiscal:SCREEN-VALUE = classif-fisc.descricao.

    IF classif-fisc.aliquota-ipi <> DEC(wh-aliquota-ipi:SCREEN-VALUE) THEN
        MESSAGE "Aliquota de IPI do item difere da aliquota de IPI da Classificaá∆o Fiscal. Deseja assumir a aliquota da Classificaá∆o?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-ipi.
    IF l-ipi THEN
        ASSIGN wh-aliquota-ipi:SCREEN-VALUE = STRING(classif-fisc.aliquota-ipi).

    FIND natur-oper NO-LOCK
        WHERE ROWID(natur-oper) = gr-natur-oper NO-ERROR.
    IF AVAIL natur-oper
    AND SUBSTRING(natur-oper.nat-operacao,1,1) <> "3" THEN
        APPLY 'CHOOSE' TO wh-btCheck.
END.

                            



