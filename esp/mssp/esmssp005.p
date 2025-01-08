/*****************************************************************************
** Programa: esp/mssp/esmssp005.p
** Vers∆o..: 1.00
** Data....: 13/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Zoom da Sub-Fam°lia do Item (zoom.p - Procedure: zoomSubFamilia)
*****************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE TEMP-TABLE tt-sub-familia-item NO-UNDO 
    FIELD cod-familia     AS INTEGER
    FIELD cod-sub-familia AS CHARACTER
    FIELD descricao       AS CHARACTER
    FIELD abreviatura     AS CHARACTER
    INDEX nm cod-familia.



/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER pCodFamilia LIKE familia-item.cod-familia  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-sub-familia-item.



/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-sub-familia-item.

FOR EACH  sub-familia-item FIELDS(sub-familia-item.cod-sub-familia sub-familia-item.cod-familia sub-familia-item.descricao sub-familia-item.abreviatura) NO-LOCK
    WHERE sub-familia-item.cod-familia = pCodFamilia
    BY    sub-familia-item.cod-familia:
    CREATE tt-sub-familia-item.
    BUFFER-COPY sub-familia-item EXCEPT cod-sub-familia TO tt-sub-familia-item.

    ASSIGN tt-sub-familia-item.cod-sub-familia = STRING(sub-familia-item.cod-sub-familia, '99').
END.


DELETE WIDGET-POOL.
RETURN "OK":U.
