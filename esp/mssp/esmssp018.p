/*------------------------------------------------------------------------
    File        : ESMSSP018.P
    Purpose     : Zoom do Fam¡lia Comercial - Procedure: zoomFamComercial
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Junho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

CREATE WIDGET-POOL.

{include/i-freeac.i}

DEFINE TEMP-TABLE tt-fam-comerc NO-UNDO
    FIELD fm-cod-com LIKE fam-comerc.fm-cod-com
    FIELD descricao  LIKE fam-comerc.descricao
    INDEX idDesc IS PRIMARY
        descricao.

DEFINE OUTPUT PARAMETER TABLE FOR tt-fam-comerc.

EMPTY TEMP-TABLE tt-fam-comerc.

FOR EACH fam-comerc FIELDS(fm-cod-com descricao) NO-LOCK:
    CREATE tt-fam-comerc.
    ASSIGN tt-fam-comerc.fm-cod-com = fam-comerc.fm-cod-com
           tt-fam-comerc.descricao  = fn-free-accent(UPPER(TRIM(fam-comerc.descricao))).
END.

DELETE WIDGET-POOL.

RETURN "OK":U.

