/*------------------------------------------------------------------------
    File        : ESMSSP019.P
    Purpose     : Folha Especifica‡Æo - Procedure: folhaEspec
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Junho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

CREATE WIDGET-POOL.

{include/i-freeac.i}

DEFINE TEMP-TABLE tt-folh-espec NO-UNDO
    FIELD cd-folha  LIKE folh-espec.cd-folha
    FIELD descricao LIKE folh-espec.descricao
    INDEX codigo IS UNIQUE PRIMARY
        cd-folha.

DEFINE INPUT  PARAMETER p-fm-codigo LIKE familia.fm-codigo NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-folh-espec.

EMPTY TEMP-TABLE tt-folh-espec.

FOR FIRST folh-fm-it NO-LOCK
    WHERE folh-fm-it.fm-codigo = p-fm-codigo,
    EACH folh-espec OF folh-fm-it NO-LOCK:
    CREATE tt-folh-espec.
    ASSIGN tt-folh-espec.cd-folha  = folh-espec.cd-folha
           tt-folh-espec.descricao = fn-free-accent(UPPER(TRIM(folh-espec.descricao))).
END.

DELETE WIDGET-POOL.

RETURN "OK":U.

