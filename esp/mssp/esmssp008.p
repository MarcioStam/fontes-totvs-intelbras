/*****************************************************************************
** Programa: esp/mssp/esmssp008.p
** Vers∆o..: 1.00
** Data....: 14/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Zoom de NCM (zoom.p - Procedure: zoomNcm)
*****************************************************************************/

CREATE WIDGET-POOL.

/*--- Definiá∆o das Vari†veis ---*/
DEFINE TEMP-TABLE tt-ncm NO-UNDO
    FIELD class-fiscal    LIKE classif-fisc.class-fiscal
    FIELD descricao       LIKE classif-fisc.descricao
    FIELD aliquota-ii     AS DECIMAL
    FIELD aliquota-ipi    LIKE classif-fisc.aliquota-ipi
    FIELD aliquota-pis    LIKE classif-fisc.dec-1
    FIELD aliquota-cofins LIKE classif-fisc.dec-2
    INDEX ncm IS PRIMARY
        class-fiscal.

/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-ncm.

/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-ncm.

FOR EACH classif-fisc NO-LOCK
    BY classif-fisc.class-fiscal:
    CREATE tt-ncm.
    ASSIGN tt-ncm.class-fiscal    = classif-fisc.class-fiscal
           tt-ncm.descricao       = classif-fisc.descricao
           tt-ncm.aliquota-ii     = DECIMAL(TRIM(SUBSTRING(classif-fisc.char-1, 1, 6)))
           tt-ncm.aliquota-ipi    = classif-fisc.aliquota-ipi
           tt-ncm.aliquota-pis    = classif-fisc.dec-1
           tt-ncm.aliquota-cofins = classif-fisc.dec-2.
END.

DELETE WIDGET-POOL.

RETURN "OK":U.

