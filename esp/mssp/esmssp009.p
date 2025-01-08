/*****************************************************************************
** Programa: esp/mssp/esmssp009.p
** Vers∆o..: 1.00
** Data....: 14/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Zoom de Destaque da NCM (zoom.p - Procedure: zoomDestaque)
*****************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE TEMP-TABLE tt-destaque-ncm NO-UNDO
    FIELD class-fiscal AS CHARACTER
    FIELD destaque     AS CHARACTER
    FIELD descricao    AS CHARACTER
    INDEX nm destaque.



/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER pNCM LIKE classif-fisc.class-fiscal  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-destaque-ncm.



/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-destaque-ncm.

FOR EACH  destaque-classif-fisc FIELDS (destaque-classif-fisc.class-fiscal destaque-classif-fisc.destaque destaque-classif-fisc.descricao) NO-LOCK
    WHERE destaque-classif-fisc.class-fiscal = pNCM
    BY    destaque-classif-fisc.destaque:
    CREATE tt-destaque-ncm.
    ASSIGN tt-destaque-ncm.class-fiscal = destaque-classif-fisc.class-fiscal
           tt-destaque-ncm.destaque     = STRING(destaque-classif-fisc.destaque, "999")
           tt-destaque-ncm.descricao    = destaque-classif-fisc.descricao.

END.


DELETE WIDGET-POOL.
RETURN "OK":U.
