/*****************************************************************************
** Programa: esp/mssp/esmssp004.p
** Vers∆o..: 1.00
** Data....: 13/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Zoom da Fam°lia do Item (zoom.p - Procedure: zoomFamiliaItem)
*****************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE TEMP-TABLE tt-familia-item NO-UNDO
    FIELD cod-familia AS INTEGER
    FIELD descricao   AS CHARACTER
    FIELD abreviatura AS CHARACTER
    INDEX nm cod-familia.



/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-familia-item.



/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-familia-item.

FOR EACH familia-item FIELDS(familia-item.cod-familia familia-item.descricao familia-item.abreviatura) NO-LOCK
    BY   familia-item.cod-familia:
    CREATE tt-familia-item.
    BUFFER-COPY familia-item USING familia-item.cod-familia familia-item.descricao familia-item.abreviatura TO tt-familia-item.
END.


DELETE WIDGET-POOL.
RETURN "OK":U.
