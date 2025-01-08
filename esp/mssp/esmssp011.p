/*****************************************************************************
** Programa: esp/mssp/esmssp011.p
** Vers∆o..: 1.00
** Data....: 26/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Zoom de Item (zoom.p - Procedure: zoomItem)
*****************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo  AS CHARACTER
    FIELD desc-item  AS CHARACTER
    FIELD ge-codigo  AS INTEGER
    FIELD fm-codigo  AS CHARACTER
    FIELD fm-cod-com AS CHARACTER
    FIELD un         AS CHARACTER
    INDEX nm it-codigo.



/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-item.



/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-item.

FOR EACH  item FIELDS(item.it-codigo item.desc-item item.ge-codigo item.fm-codigo item.fm-cod-com item.un) NO-LOCK
    WHERE item.cod-obsoleto = 1
    BY    item.it-codigo:
    CREATE tt-item.
    BUFFER-COPY item USING item.it-codigo item.desc-item item.ge-codigo item.fm-codigo item.fm-cod-com item.un
             TO tt-item.
END.


DELETE WIDGET-POOL.
RETURN "OK":U.
