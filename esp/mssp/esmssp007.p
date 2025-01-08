/*****************************************************************************
** Programa: esp/mssp/esmssp007.p
** Vers∆o..: 1.00
** Data....: 13/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Zoom do Complemento da Fam°lia do Item (zoom.p - Procedure: zoomCompFamilia)
*****************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE TEMP-TABLE tt-comp-familia-item NO-UNDO
    FIELD cod-familia      AS INTEGER
    FIELD cod-sub-familia  AS CHARACTER
    FIELD cod-car-familia  AS CHARACTER
    FIELD cod-comp-familia AS INTEGER
    FIELD descricao        AS CHARACTER
    FIELD abreviatura      AS CHARACTER
    INDEX nm cod-familia.



/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER pCodFamilia    LIKE familia-item.cod-familia          NO-UNDO.
DEFINE INPUT  PARAMETER pCodSubFamilia LIKE sub-familia-item.cod-sub-familia  NO-UNDO.
DEFINE INPUT  PARAMETER pCodCarFamilia LIKE car-familia-item.cod-car-familia  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-comp-familia-item.



/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-comp-familia-item.

FOR EACH  comp-familia-item FIELDS(comp-familia-item.cod-comp-familia comp-familia-item.cod-car-familia comp-familia-item.cod-sub-familia comp-familia-item.cod-familia comp-familia-item.descricao comp-familia-item.abreviatura) NO-LOCK
    WHERE comp-familia-item.cod-familia     = pCodFamilia
    AND   comp-familia-item.cod-sub-familia = pCodSubFamilia
    AND   comp-familia-item.cod-car-familia = pCodCarFamilia
    BY    comp-familia-item.cod-familia:
    CREATE tt-comp-familia-item. BUFFER-COPY comp-familia-item EXCEPT cod-sub-familia cod-car-familia TO tt-comp-familia-item.

    ASSIGN tt-comp-familia-item.cod-sub-familia = TRIM(STRING(comp-familia-item.cod-sub-familia, '99'))
           tt-comp-familia-item.cod-car-familia = TRIM(STRING(comp-familia-item.cod-car-familia, '99')).
END.


DELETE WIDGET-POOL.
RETURN "OK":U.
