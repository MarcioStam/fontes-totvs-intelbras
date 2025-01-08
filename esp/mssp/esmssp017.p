/*------------------------------------------------------------------------
    File        : ESMSSP017.P
    Purpose     : Zoom do Grupo de Estoque - Procedure: zoomGrupEstoque
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Junho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

CREATE WIDGET-POOL.

{include/i-freeac.i}

DEFINE TEMP-TABLE tt-grup-estoque NO-UNDO
    FIELD ge-codigo LIKE grup-estoque.ge-codigo
    FIELD descricao LIKE grup-estoque.descricao
    INDEX codigo IS UNIQUE PRIMARY
        ge-codigo.

DEFINE OUTPUT PARAMETER TABLE FOR tt-grup-estoque.

EMPTY TEMP-TABLE tt-grup-estoque.

FOR EACH grup-estoque FIELDS(ge-codigo descricao) NO-LOCK:
    CREATE tt-grup-estoque.
    ASSIGN tt-grup-estoque.ge-codigo = grup-estoque.ge-codigo
           tt-grup-estoque.descricao = fn-free-accent(UPPER(TRIM(grup-estoque.descricao))).
END.

DELETE WIDGET-POOL.

RETURN "OK":U.

