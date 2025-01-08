/*****************************************************************************
** Programa: esp/mssp/esmssp006.p
** Vers∆o..: 1.00
** Data....: 13/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Zoom da Caracter°stica da Fam°lia do Item (zoom.p - Procedure: zoomCarFamilia)
*****************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE TEMP-TABLE tt-car-familia-item NO-UNDO
    FIELD cod-familia     AS INTEGER
    FIELD cod-sub-familia AS CHARACTER
    FIELD cod-car-familia AS CHARACTER
    FIELD descricao       AS CHARACTER
    FIELD abreviatura     AS CHARACTER
    INDEX nm cod-familia.



/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER pCodFamilia    LIKE familia-item.cod-familia          NO-UNDO.
DEFINE INPUT  PARAMETER pCodSubFamilia LIKE sub-familia-item.cod-sub-familia  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-car-familia-item.



/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-car-familia-item.

FOR EACH  car-familia-item FIELDS(car-familia-item.cod-car-familia car-familia-item.cod-sub-familia car-familia-item.cod-familia car-familia-item.descricao car-familia-item.abreviatura) NO-LOCK
    WHERE car-familia-item.cod-familia     = pCodFamilia
    AND   car-familia-item.cod-sub-familia = pCodSubFamilia
    BY    car-familia-item.cod-familia:
    CREATE tt-car-familia-item.
    BUFFER-COPY car-familia-item EXCEPT cod-sub-familia cod-car-familia TO tt-car-familia-item.

    ASSIGN tt-car-familia-item.cod-sub-familia = STRING(car-familia-item.cod-sub-familia, '99')
           tt-car-familia-item.cod-car-familia = STRING(car-familia-item.cod-car-familia, '99').
END.


DELETE WIDGET-POOL.
RETURN "OK":U.
